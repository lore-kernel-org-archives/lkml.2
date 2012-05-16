Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2EPUom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:44:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2EPUol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:44:41 -0400
Date: Wed, 16 May 2012 22:44:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
In-Reply-To: <20120516202924.GE21275@google.com>
Message-ID: <alpine.LNX.2.00.1205162234150.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz> <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz> <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com> <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz> <20120516200147.GD21275@google.com> <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz> <20120516202924.GE21275@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Tejun Heo wrote:

> > In floppy_grab_irq_and_dma() the point is to drain the workqueue 
> > completely (before the conversion, we were just using 
> > flush_work_sync(&floppy_work) for particular work item), and for that 
> > flush_work() is not sufficient any more.
> > 
> > So I am really considering going back to driver-specific singlethreaded 
> > workqueue.
> 
> Ummm... still confused.  flush_work_sync() is fine too.  If you have
> two, two calls to flush_work_sync() are equivalent to flushing the
> workqueue in effect.  You just need to avoid flush_workqueue() because
> system workqueues may be hosting work items which can run arbitrarily
> long.

Before the conversion, we do

	flush_work_sync(&floppy_work);

in floppy_grab_irq_and_dma(). After the conversion, the single-threaded 
workqueue is used to queue more than just floppy_work, and we want all 
this to be flushed before proceeding, so neither flush_work() nor 
flush_work_sync() is enough, as there might be floppy_work, fd_timer or 
fd_timeout queued. This all has to be flushed.

If this still doesn't seem to make sense, I'll get back to it tomorrow, it 
might be just too late and my brain cells might already be dreaming.

-- 
Jiri Kosina
SUSE Labs
