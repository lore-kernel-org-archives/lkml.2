Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab1FVCID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:08:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:51983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab1FVCIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,404,1304319600"; 
   d="scan'208";a="18055599"
Subject: Re: [PATCH] cfq: Fix starvation of async writes in presence of
 heavy sync workload
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>
In-Reply-To: <20110621152601.GD15123@redhat.com>
References: <20110620141631.GA4749@redhat.com>
	 <BANLkTike3ZhFR9HioPcQWzwXYhszo0-SkA@mail.gmail.com>
	 <20110621152601.GD15123@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 10:07:58 +0800
Message-ID: <1308708478.15392.160.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 23:26 +0800, Vivek Goyal wrote:
> On Tue, Jun 21, 2011 at 10:15:15AM +0800, Shaohua Li wrote:
> > 2011/6/20 Vivek Goyal <vgoyal@redhat.com>:
> > > In presence of heavy sync workload CFQ can starve asnc writes.
> > > If one launches multiple readers (say 16), then one can notice
> > > that CFQ can withhold dispatch of WRITEs for a very long time say
> > > 200 or 300 seconds.
> > >
> > > Basically CFQ schedules an async queue but does not dispatch any
> > > writes because it is waiting for exisintng sync requests in queue to
> > > finish. While it is waiting, one or other reader gets queued up and
> > > preempts the async queue. So we did schedule the async queue but never
> > > dispatched anything from it. This can repeat for long time hence
> > > practically starving Writers.
> > >
> > > This patch allows async queue to dispatch atleast 1 requeust once
> > > it gets scheduled and denies preemption if async queue has been
> > > waiting for sync requests to drain and has not been able to dispatch
> > > a request yet.
> > >
> > > One concern with this fix is that how does it impact readers
> > > in presence of heavy writting going on.
> > >
> > > I did a test where I launch firefox, load a website and close
> > > firefox and measure the time. I ran the test 3 times and took
> > > average.
> > >
> > > - Vanilla kernel time ~= 1 minute 40 seconds
> > > - Patched kenrel time ~= 1 minute 35 seconds
> > >
> > > Basically it looks like that for this test times have not
> > > changed much for this test. But I would not claim that it does
> > > not impact reader's latencies at all. It might show up in
> > > other workloads.
> > >
> > > I think we anyway need to fix writer starvation. If this patch
> > > causes issues, then we need to look at reducing writer's
> > > queue depth further to improve latencies for readers.
> > I'm afraid this can causes read latency because cfq_dispatch_requests
> > doesn't check preempt. we will dispatch 4 requests at least instead of
> > just one. can we add a logic to force it just dispatches one request?
> 
> This will happen only if some other read queue does not preempt write
> queue after disptaching 1 request.
could happen in multiple queues too, because ncq disks dispatch several
requests in a short time.

> Anyway, agreed that with single reader, it will not preempt writer and
> then writer gets to dispatch bunch of requests.
> 
> If we want to protect against that, then we can simply expire writer
> after dispatching one request if there are busy queues.
> 
> I could change following code.
> 
>         /*
>          * expire an async queue immediately if it has used up its slice.
>          * idle
>          * queue always expire after 1 dispatch round.
>          */
>         if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
>             cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
>             cfq_class_idle(cfqq))) {
>                 cfqq->slice_end = jiffies + 1;
>                 cfq_slice_expired(cfqd, 0);
>         }
> 
> to look as follows.
> 
>         /*
>          * expire an async queue and idle queue after 1 dispatch round.
>          */
>         if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) ||
> 	    cfq_class_idle(cfqq))) {
>                 cfqq->slice_end = jiffies + 1;
>                 cfq_slice_expired(cfqd, 0);
>         }
Looks fine. the cfqd->busy_queues check for async queue need exclude a
idle queue if there is. That is for a idle queue and an aync queue,
don't expire async. maybe use this:
if (cfqd->busy_queues > 1 && cfq_calss_idle(cfqq) ||
cfqd->busy_sync_queues > 0 && !cfq_cfqq_sync(cfqq))

Thanks,
Shaohua

