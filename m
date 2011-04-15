Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab1DOEPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:15:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1DOEPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:15:01 -0400
Date: Fri, 15 Apr 2011 00:14:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415041455.GA27928@infradead.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110414202445.GA6173@liondog.tnic>
 <BANLkTi=h+NL+qqMDBNvOUmVDonORf4Qx2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=h+NL+qqMDBNvOUmVDonORf4Qx2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 01:55:02PM -0700, Linus Torvalds wrote:
> On Thu, Apr 14, 2011 at 1:24 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > Yep, I had to hit a buglet too. Looks like block layer, ->request_fn
> > (do_ide_request) called in IRQ disabled region. Process is blkid, i.e.
> > some udev helper. Kernel is -rc3 + Joerg's USB quirk fix which should be
> > unrelated.
> 
> I think this particular backtrace should be fixed by commit
> 6631e635c65d ("block: don't flush plugged IO on forced preemtion
> scheduling"), although even without preempt scheduling, I don't think
> it's at all ok to sleep inside __blk_run_queue.
> 
> Jens? Even from a _regular_ schedule, it would not be ok if we end up
> sleeping - we're caching things like the request-queue, and we have
> preempt_disable() inside the scheduler for a very good reason.

Jens already has a fix in his tree to always offload the block I/O
submission to blockd for this case.

