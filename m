Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1EDJxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:53:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:41444 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1EDJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:53:08 -0400
Date: Wed, 4 May 2011 11:52:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504083559.GB25724@elte.hu>
Message-ID: <alpine.LFD.2.02.1105041124080.3005@ionos>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Ingo Molnar wrote:

> 1415		if (!nr_sectors)
> 1416			return 0;
> 1417	
> 1418		/* Test device or partition size, when known. */
> 1419		maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;   <==== [ **CRASH** ]
> 1420		if (maxsector) {
> 1421			sector_t sector = bio->bi_sector;
> 1422	
> 1423			if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
> 
> bio->bi_bdev has become NULL?
> 
> I do not think the _cond_resched() was called, judging from stack contents. But 
> we just had an IRQ:
> 
>  [<c1d74030>] ? common_interrupt+0x30/0x40
> 
> So we might have raced with block IO IRQ queue-completion/submission activites.
> 
> But maybe it was a reschedule after all, just the stack does not carry any 
> traces of it anymore. IRQs do not clear ->bi_bdev, right? Unless the bio 
> refcounts are wrong and an IRQ's completion actually frees the bio, right?

Looking at the call chain that's impossible:

generic_make_request
submit_bio
submit_bh

submit_bh does:

	bio = bio_alloc()
	bio_get(bio)
	submit_bio(bio)
	bio_put(bio)

So that bio is not yet known to anything else than the calling
code. 

One possibility is that bh->bdev is NULL when submit_bh() is called,
which I think is rather unlikely, but can be easily verified with

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2887,6 +2887,7 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!bh->b_end_io);
 	BUG_ON(buffer_delay(bh));
 	BUG_ON(buffer_unwritten(bh));
+	BUG_ON(!bh->b_bdev);
 
 	/*
 	 * Only clear out a write error when rewriting

But I rather suspect, that CONFIG_SLUB=y is the thing we need to look
at. The lockless fastpath cmpxchg comes to my mind.

Either we generate broken code with that ELAN caused options or
that combo triggers some hidden problem in SLUB.

Thanks,

	tglx


