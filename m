Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2BMRag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:30:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2BMRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:30:33 -0500
Date: Mon, 13 Feb 2012 09:30:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
Message-ID: <20120213173027.GC12117@google.com>
References: <20120211002349.GN19392@google.com>
 <Pine.LNX.4.44L0.1202121216060.18114-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202121216060.18114-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Sun, Feb 12, 2012 at 12:48:22PM -0500, Alan Stern wrote:
> > I think it would be better to use wq for most kthreads.  A lot of them
> > aren't strictly correct in the way they deal with
> > kthread_should_stop() and freezing.  kthread in general simply seems
> > way too difficult to use correctly.
> 
> Maybe so, but getting rid of it at this point would be a big change.  

Ooh, yeah, if we do it, it would be a gradual transition.

> Also, kthreads were originally considered more suitable for tasks that
> would need to run for a long time; is this no longer true?

wq no longer has problem w/ long running work items.  The only
limiting parameter is max_active, which is primarily there to protect
against berserk cases.

> > > kthread_run() can be adjusted on a case-by-case basis, by inserting
> > > calls to set_freezable() and try_to_freeze() at the appropriate places.  
> > > But what about async_schedule()?
> > 
> > Given the stuff async is used for, maybe just make all async execution
> > freezable?
> 
> That probably won't work.  What if a driver relies on async thread
> execution to carry out its I/O?
>
> As another example, sd_probe() calls async_schedule(sd_probe_async,...)
> to handle the long-running parts of probing a SCSI disk.  In turn,
> sd_remove() calls async_synchronize_full() to insure that probing is
> over before the device is unbound from sd.
> 
> What happens if a hot-unpluggable disk drive is unplugged while the
> system is asleep?  It's entirely possible that the bus subsystem's
> resume routine would see the device was gone and would try to 
> unregister it.  Then sd_remove would wait for the async thread 
> to finish, which would never happen because the thread would be frozen 
> and wouldn't be thawed until all the resume routines had finished.
> 
> In this case, the proper solution is to have the SCSI prepare method 
> call async_synchronize_full().  Other cases will require other 
> solutions.

Hmmm.... I don't know then. :)

Thanks.

-- 
tejun
