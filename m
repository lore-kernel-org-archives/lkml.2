Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2EQPG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:06:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43795 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab2EQPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:06:54 -0400
Date: Thu, 17 May 2012 08:06:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120517150649.GG21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com>
 <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com>
 <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com>
 <alpine.LNX.2.00.1205162234150.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205162234150.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:44:31PM +0200, Jiri Kosina wrote:
> On Wed, 16 May 2012, Tejun Heo wrote:
> 
> > > In floppy_grab_irq_and_dma() the point is to drain the workqueue 
> > > completely (before the conversion, we were just using 
> > > flush_work_sync(&floppy_work) for particular work item), and for that 
> > > flush_work() is not sufficient any more.
> > > 
> > > So I am really considering going back to driver-specific singlethreaded 
> > > workqueue.
> > 
> > Ummm... still confused.  flush_work_sync() is fine too.  If you have
> > two, two calls to flush_work_sync() are equivalent to flushing the
> > workqueue in effect.  You just need to avoid flush_workqueue() because
> > system workqueues may be hosting work items which can run arbitrarily
> > long.
> 
> Before the conversion, we do
> 
> 	flush_work_sync(&floppy_work);
> 
> in floppy_grab_irq_and_dma(). After the conversion, the single-threaded 
> workqueue is used to queue more than just floppy_work, and we want all 
> this to be flushed before proceeding, so neither flush_work() nor 
> flush_work_sync() is enough, as there might be floppy_work, fd_timer or 
> fd_timeout queued. This all has to be flushed.
> 
> If this still doesn't seem to make sense, I'll get back to it tomorrow, it 
> might be just too late and my brain cells might already be dreaming.

So, AFAICS, there are only three work items in question here,
floppy_work, fd_timer and fd_timeout, so three calls to
flush[_delayed]_work_sync() is functionally equivalent to
flush_workqueue().  While flushing separately may take longer, AFAICS,
it doesn't seem to be on the hot path (not much in floppy can be
considered hot these days tho) and I don't think it would make any
noticeable performance difference.

If having a separate flush domain is beneficial, please create a
non-reentrant workqueue without rescuer - alloc_workqueue("floppy",
WQ_NON_REENTRANT, 0).  If serialization among different work items is
necessary, single thread workqueue without rescuer can be used -
alloc_workqueue("floppy", WQ_UNBOUND, 1).

create_*workqueue() are left there for backwards compatibility and
they all have rescuer for that reason.  Gotta clean them up and maybe
create different wrappers, I guess.

Thanks.

-- 
tejun
