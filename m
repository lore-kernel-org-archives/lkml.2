Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab2BKAX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 19:23:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2BKAXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 19:23:54 -0500
Date: Fri, 10 Feb 2012 16:23:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
Message-ID: <20120211002349.GN19392@google.com>
References: <20120210211255.GK19392@google.com>
 <Pine.LNX.4.44L0.1202101631180.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202101631180.1179-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 10, 2012 at 04:44:48PM -0500, Alan Stern wrote:
> > I think it should be nrt.  It assumes that no one else is running it
> > concurrently; otherwise, multiple CPUs could jump into
> > disk->fops->check_events() concurrently which can be pretty ugly.
> 
> Come to mention it, how can a single work item ever run on more than
> one CPU concurrently?  Are you concerned about cases where some other 
> thread requeues the work item while it is executing?

Yeah, there are multiple paths which may queue the work item.  For
polling work, it definitely was possible but maybe locking changes
afterwards removed that.  Even then, it would be better to use nrt wq
as bug caused that way would be very difficult to track down.

> The problem is that these async threads generally aren't freezable.  
> They will continue to run and do I/O while a system goes through a
> sleep transition.  How should this be handled?

I think it would be better to use wq for most kthreads.  A lot of them
aren't strictly correct in the way they deal with
kthread_should_stop() and freezing.  kthread in general simply seems
way too difficult to use correctly.

> kthread_run() can be adjusted on a case-by-case basis, by inserting
> calls to set_freezable() and try_to_freeze() at the appropriate places.  
> But what about async_schedule()?

Given the stuff async is used for, maybe just make all async execution
freezable?

Thanks.

-- 
tejun
