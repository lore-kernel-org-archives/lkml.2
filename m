Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2CIAdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:33:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64049 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759100Ab2CIAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:33:14 -0500
Date: Thu, 8 Mar 2012 16:33:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-ID: <20120309003309.GB2968@htj.dyndns.org>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
 <20120308231521.GA2968@htj.dyndns.org>
 <20120308153048.4a80de34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308153048.4a80de34.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Mar 08, 2012 at 03:30:48PM -0800, Andrew Morton wrote:
> >  The behavior change was primarily to
> > allow long running work items to use regular workqueues without
> > worrying about inducing delay across cpu hotplug operations, which is
> > important as it's also used on suspend / hibernation, especially on
> > mobile platforms.
> 
> Well..  why did we want to support these long-running work items? 
> They're abusive, aren't they?  Where are they?

The rationale was two-fold.  One was that using kthread directly is
inefficient and difficult.  We end up with a lot of mostly idle
kthreads lying around and w/ increasing number of cores, creating them
per-cpu becomes problematic.  On certain setups, we were reaching task
limit during boot, so having an easy to use worker pool mechanism is
necessary.  We already had workqueue, so it was logical to extend wq
to support that.

Also, on auditing kthread users, a lot of them were (and still are)
racy around kthread_should_exit() handling.  kthread_should_exit()
requires careful synchronization to avoid missing the event.  It just
sets should exit flag and wakes up the kthread once.  Many simply
forget to consider the synchronization requirements.

Another side was that "long-running" isn't obvious at all.  Many
workqueue items are used because they require sleepable context for
synchronization and while they usually don't consume large amount of
time, there are occassions where certain locking takes way longer
through chain of dependencies.  This was mostly visible through system
workqueue getting stalled.

> > Another approach would be requiring all workqueues to be drained on
> > cpu offlining and requiring any work item which may stall to use
> > unbound wq.  IMHO, picking out the ones which may stall would be much
> > less obvious than the ones which require cpu pinning.
> 
> I'd be surprised if it's *that* hard to find and fix the long-running
> work items.  Hopefully most of them are already using
> create_freezable_workqueue() or create_singlethread_workqueue().
> 
> I wonder if there's some debug code we can put in workqueue.c to detect
> when a pinned work item takes "too long".

Yes, we can go either way, but I think it would be easier to weed out
the ones with pinned assumptions.  As they usually are much less
common, more obvious and probably easier to automatically detect
(ie. trigger warning on debug_smp_processor_id() if running as
un-pinned work item).

ISTR there was something already broken about having specific CPU
assumption w/ workqueue even before cmwq when using queue_work_on()
unless it was explicitly synchronizing using cpu hotplug callback.
Hmmm... what was it... I think it was that there was no protection
against queueing on workqueue on dead CPU and workqueue was flushed
only once during cpu shutdown meaning that queue_work_on() or
requeueing work items could end up queued on a workqueue of a dead
CPU.

Thanks.

-- 
tejun
