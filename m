Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0LPQvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:51:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:51901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0LPQvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:51:02 -0500
Message-ID: <4D0A4372.2010503@kernel.org>
Date: Thu, 16 Dec 2010 17:50:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH 01/30] infiniband: update workqueue usage
References: <1292086307-19211-1-git-send-email-tj@kernel.org>	<1292086307-19211-2-git-send-email-tj@kernel.org> <adad3p2hony.fsf@cisco.com>
In-Reply-To: <adad3p2hony.fsf@cisco.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 16:51:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.  Sorry about the delay.

On 12/15/2010 07:33 PM, Roland Dreier wrote:
> Thanks Tejun.  A couple questions:
> 
>  > * ib_wq is added, which is used as the common workqueue for infiniband
>  >   instead of the system workqueue.  All system workqueue usages
>  >   including flush_scheduled_work() callers are converted to use and
>  >   flush ib_wq.  This is to prepare for deprecation of
>  >   flush_scheduled_work().
> 
> Why do we want to move to a subsystem-specific workqueue?  Can we just
> replace flush_scheduled_work() by cancel_delayed_work_sync() as
> appropriate and not create yet another work queue?

Because there are places where work is used to free the containing
structure.  Before a module is unloaded, all works which uses
functions in the module should be flushed; however, if a work is used
to free the containing structure, such work can't be flushed
explicitly, so the workqueue which processes such works should be
flushed.

So, in this case, ib_wq is added primarily to serve as a flush domain.
For driver midlayers, this seems often necessary.  Also, the workqueue
doesn't have any dedicated worker and is quite cheap.

> 
>  > * qib_wq is removed and ib_wq is used instead.
> 
> You obviously looked at the comment
> 
> -	/*
> -	 * We create our own workqueue mainly because we want to be
> -	 * able to flush it when devices are being removed.  We can't
> -	 * use schedule_work()/flush_scheduled_work() because both
> -	 * unregister_netdev() and linkwatch_event take the rtnl lock,
> -	 * so flush_scheduled_work() can deadlock during device
> -	 * removal.
> -	 */
> -	qib_wq = create_workqueue("qib");
> 
> and know that with the new workqueue stuff, this issue no longer
> exists.  But for both my education and also the clarity of the changelog
> for this patch, perhaps you could expand on why ib_wq is safe here.

I think I got confused.  I thought the comment was indicating the
separation between qib_wq and qib_cq_wq.  It's between system_wq and
qib_wq, right?  I'll drop this part from the series, but then again
what's the difference from ib_srp, which flushes the common workqueue?
Why doesn't ib_srp have the same problem?

>  > * create[_singlethread]_workqueue() usages are replaced with the new
>  >   alloc[_ordered]_workqueue().  This removes rescuers from all
>  >   infiniband workqueues.
> 
> What are rescuers?

Normally, all workqueues share global per-cpu worker pool, but certain
workqueues needs forward progress guarantee under memory pressure (the
ones which are used to free memory).  In this case, the workqueues are
created with WQ_MEM_RECLAIM and has a single rescuer worker reserved.
So, any workqueue which is in memory reclaim path needs to have the
flag set to avoid the unlikely but still possible deadlock under
memory pressure.

> Can we replace some of these driver-specific work queues by the ib_wq?
>
> Are all these things just possibilities for future cleanup?

Hmm... Yeah, sure, they can be.  With the new implementation, separate
workqueues are used for the following purposes.

* As a forward progress guarantee domain as decribed above.

* As a flushing domain.

* As a property domain.  Different workqueues have different execution
  and queueing properties set.

Unless one of the above is necessary, work items can be queued
together into the same workqueue.  Concurrency-wise, it wouldn't make
any difference.  They all use the same set of workers anyway, but I
don't know the code well enough to make the changes myself.  If you're
interested in doing it, I'll be happy to help.

Thanks.

-- 
tejun
