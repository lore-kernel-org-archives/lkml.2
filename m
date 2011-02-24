Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1BXOXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab1BXOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:23:16 -0500
Date: Thu, 24 Feb 2011 09:23:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Cc: libvir-list@redhat.com, Dominik Klein <dk@in-telegence.net>
Subject: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt] blkio
 cgroup [solved])
Message-ID: <20110224142303.GA18494@redhat.com>
References: <20110218163137.GF26654@redhat.com>
 <4D621B9B.3070205@in-telegence.net>
 <4D622002.2040604@in-telegence.net>
 <4D6222A8.6090303@in-telegence.net>
 <20110221184442.GM6428@redhat.com>
 <4D63BA3B.7070809@in-telegence.net>
 <20110222152426.GD28269@redhat.com>
 <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D662248.6040405@in-telegence.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:18:00AM +0100, Dominik Klein wrote:

Hi Dominik,

Thanks for the tests and reports. I checked the latest logs also and
I see that cfq has scheduled a work but that work never gets scheduled.
I never see the trace message which says cfq_kick_queue().

I am ccing it to lkml and tejun to see if he has any suggestions.

Tejun,

I will give you some details about what we have discussed so far.

Dominik is trying blkio throttling feature and trying to throttle some
virtual machines. He is using 2.6.37 kernels and once he launches 3
virtual machines he notices that system is kind of frozen. After running
some traces we noticed that CFQ has requests but it is not dispatching
these to devices any more.

This problem does not show up with deadline scheduler and also goes away
with 2.6.38-rc6 kernels.

CFQ seems to have scheduled a work and that work never gets called back
that's why CFQ is frozen. I modifed CFQ a bit and capture following
traces.

           <...>-3118  [022]   230.001571:   8,16   m   N cfq idle timer
fired
           <...>-3118  [022]   230.001575:   8,16   m   N cfq3834 slice
expired t=0
           <...>-3118  [022]   230.001577:   8,16   m   N cfq3834
sl_used=3 disp=37 charge=3 iops=0 sect=16048
           <...>-3118  [022]   230.001578:   8,16   m   N cfq3834
del_from_rr
           <...>-3118  [022]   230.001581:   8,16   m   N cfq schedule
dispatch: busy_queues=29 rq_queued=128 rq_in_driver=0 q=ffff88080a581ba0

<CFQ hangs after this. No traces>

I have put a trace message in cfq_kick_queue(). If work was ever scheduled
that trace message should have been present here.

Tejun, I was wondering if you have come across similar issue in the past
which has been fixed in 2.6.38-rc kernels? Or any suggestions regarding
how to debug it further.

Thanks
Vivek 


> 
> First of all, I need to define the "freeze"- or "hang"-situation in
> order to avoid misunderstandings. When the "hang" state occures, this
> means it is impossible to do any io on the system. vmstat shows 250-300
> blocked threads. Therefore, it is not possible to open new ssh
> connections or log into the servers console. Established ssh connections
> however, keep working. It is possible to run commands. Just don't touch
> any files. That immediately hangs the connections.
> 
> Okay, now that we got that cleared up ...
> 
> During the "hang" situation, it is possible to change from cfq to
> deadline scheduler for /dev/sdb (the pv for the lvs). This makes the io
> happen and the system is responsive as usual.
> 
> After applying the patch correctly (my mistake), we could see these
> debug messages from debugfs:
> 
> qemu-kvm-3955  [004]   823.360594:   8,16   Q  WS 3408164104 + 480
> [qemu-kvm]
> qemu-kvm-3955  [004]   823.360594:   8,16   S  WS 3408164104 + 480
> [qemu-kvm]
> <...>-3252  [016]   823.361146:   8,16   m   N cfq idle timer fired
> <...>-3252  [016]   823.361151:   8,16   m   N cfq3683 slice expired t=0
> <...>-3252  [016]   823.361154:   8,16   m   N cfq3683 sl_used=2 disp=25
> charge=2 iops=0 sect=9944
> <...>-3252  [016]   823.361154:   8,16   m   N cfq3683 del_from_rr
> <...>-3252  [016]   823.361161:   8,16   m   N cfq schedule dispatch:
> busy_queues=38 rq_queued=132 rq_in_driver=0
> 
> quote Vivek Goyal
> cfq has 38 busy queues and 132 requests queued and it tries to schedule
> a dispatch
> and that dispatch never happens for some reason and cfq is hung
> /quote
> 
> So the next idea was to try with 2.6.38-rc6, just in case there is a bug
> in workqueue logic which got fixed?
> 
> And it turns out: With 2.6.38-rc6, the problem does not happen.
> 
> I will see whether I can bisect the kernel patches and see which one was
> the good one. I have to figure out a way to do that, but if I do it and
> find out, I will keep you posted.
> 
> Vivek then asked me to use another 2.6.37 debug patch and re-run the
> test. Attached are the logs from that run.
> 
> Regards
> Dominik
> 
> On 02/23/2011 02:37 PM, Dominik Klein wrote:
> > Hi
> > 
> > so I ran these tests again. No patch applied yet. And - at least once -
> > it worked. I did everything exactly the same way as before. Since the
> > logs are 8 MB, even when best-bzip2'd, and I don't want everybody to
> > have to download these, I uploaded them to an external hoster:
> > http://www.megaupload.com/?d=SWKTC0V4
> > 
> > Traces were created with
> > blktrace -n 64 -b 16384 -d /dev/sdb -o - | blkparse -i -
> > blktrace -n 64 -b 16384 -d /dev/vdisks/kernel3 -o - | blkparse -i -
> > 
> >> Can you please apply attached patch. 
> > 
> > Unfortunately not. Cannot be applied to 2.6.37. I guess your source is
> > newer and I fail to find the places in the file to patch manually.
> > 
> >> This just makes CFQ output little
> >> more verbose and run the test again and capture the trace.
> >>
> >> - Start the trace on /dev/sdb
> >> - Start the dd jobs in virt machines
> >> - Wait for system to hang
> >> - Press CTRL-C
> >> - Make sure there were no lost events otherwise increase the size and
> >>   number of buffers.
> > 
> > Tried that. Unfortunately, even with max buffer size of 16 M [1], this
> > leaves some Skips. I also tried to increase the number of buffers over
> > 64, but that produced Oops'es.
> > 
> > However, I attached kernel3's blktrace of a case where the error
> > occured. Maybe you can read something from that.
> > 
> >> Can you also open tracing in another window and also trace one of the
> >> throttled dm deivces, say /dev/disks/kernel3. Following the same procedure
> >> as above. So let the two traces run in parallel.
> > 
> > So what next?
> > 
> > Regards
> > Dominik
> > 
> > [1]
> > http://git.kernel.org/?p=linux/kernel/git/axboe/blktrace.git;a=blob_plain;f=blktrace.c;hb=HEAD
> > and look for "Invalid buffer"

> vmstat 2 
>  0  0      0 130316736  16364  74840    0    0     0     0 16891 33021  0  1 99  0
>  8  0      0 129400944  16364  74840    0    0     0    14 17975 33233  4  3 93  0
>  0 306      0 127762016  16364  74840    0    0     0 144642 20478 35476 11  6 28 56
>  1 306      0 127761176  16364  74840    0    0     0     0 17307 33100  3  4 25 69
>  2 306      0 127760904  16364  74840    0    0     0     0 17300 32947  3  4 24 69
>  0 306      0 127760768  16364  74840    0    0     0     0 17189 32953  2  3 25 70
>  1 306      0 127760752  16364  74840    0    0     0     0 17228 32966  2  3 21 74
>  0 306      0 127760752  16364  74840    0    0     0     0 17138 32938  1  4 24 72
>  0 306      0 127760736  16364  74840    0    0     0     0 17159 32954  1  4 22 73
>  1 306      0 127760736  16364  74840    0    0     0     0 17210 33011  1  4 23 73
>  0 306      0 127760736  16364  74840    0    0     0     0 17167 32980  0  4 22 74
>  0 306      0 127760736  16364  74840    0    0     0     0 17137 32930  0  4 21 75
>  1 306      0 127760352  16364  74840    0    0     0     0 17165 32933  0  2 23 75
>  1 306      0 127760472  16364  74840    0    0     0     0 17079 32928  0  0 25 74
>  0 306      0 127760560  16364  74840    0    0     0     0 17188 32950  1  2 22 75
>  2 306      0 127760560  16364  74840    0    0     0     6 17142 32838  1  4 21 74
>  0 306      0 127760560  16364  74840    0    0     0    16 17213 32896  1  4 21 74
>  0 306      0 127760560  16364  74840    0    0     0     0 17198 32899  2  4 21 74
>  0 306      0 127760560  16364  74840    0    0     0    12 17218 32910  1  4 21 74
>  1 306      0 127760544  16364  74840    0    0     0     0 17203 32884  2  3 21 74
>  1 306      0 127760552  16364  74840    0    0     0     0 17199 32904  2  4 21 74
>  0 306      0 127760560  16364  74840    0    0     0     0 17230 32871  2  4 21 74
>  0 306      0 127760560  16364  74840    0    0     0     0 17177 32860  2  4 21 74
>  0 306      0 127760640  16364  74840    0    0     0     0 17185 32888  1  4 21 73
>  0 306      0 127760640  16364  74840    0    0     0     0 17207 32851  2  4 25 70
>  1 306      0 127760640  16364  74840    0    0     0     0 17023 32914  0  4 25 70

>  block/blk-core.c    |    1 +
>  block/blk.h         |    8 +++++++-
>  block/cfq-iosched.c |   11 ++++++++---
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2011-02-22 13:23:25.000000000 -0500
> +++ linux-2.6/block/cfq-iosched.c	2011-02-23 11:54:49.488446104 -0500
> @@ -498,7 +498,7 @@ static inline bool cfq_bio_sync(struct b
>  static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
>  {
>  	if (cfqd->busy_queues) {
> -		cfq_log(cfqd, "schedule dispatch");
> +		cfq_log(cfqd, "schedule dispatch: busy_queues=%d rq_queued=%d rq_in_driver=%d q=%p", cfqd->busy_queues, cfqd->rq_queued, cfqd->rq_in_driver, cfqd->queue);
>  		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
>  	}
>  }
> @@ -2229,6 +2229,8 @@ static struct cfq_queue *cfq_select_queu
>  {
>  	struct cfq_queue *cfqq, *new_cfqq = NULL;
>  
> +	cfq_log(cfqd, "select_queue: busy_queues=%d rq_queued=%d rq_in_driver=%d", cfqd->busy_queues, cfqd->rq_queued, cfqd->rq_in_driver);
> +
>  	cfqq = cfqd->active_queue;
>  	if (!cfqq)
>  		goto new_queue;
> @@ -2499,8 +2501,10 @@ static int cfq_dispatch_requests(struct 
>  		return cfq_forced_dispatch(cfqd);
>  
>  	cfqq = cfq_select_queue(cfqd);
> -	if (!cfqq)
> +	if (!cfqq) {
> +		cfq_log(cfqd, "select: no cfqq selected");
>  		return 0;
> +	}
>  
>  	/*
>  	 * Dispatch a request from this cfqq, if it is allowed
> @@ -3359,7 +3363,7 @@ static void cfq_insert_request(struct re
>  	struct cfq_data *cfqd = q->elevator->elevator_data;
>  	struct cfq_queue *cfqq = RQ_CFQQ(rq);
>  
> -	cfq_log_cfqq(cfqd, cfqq, "insert_request");
> +	cfq_log_cfqq(cfqd, cfqq, "insert_request: busy_queues=%d rq_queued=%d rq_in_driver=%d", cfqd->busy_queues, cfqd->rq_queued, cfqd->rq_in_driver);
>  	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
>  
>  	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
> @@ -3707,6 +3711,7 @@ static void cfq_kick_queue(struct work_s
>  	struct request_queue *q = cfqd->queue;
>  
>  	spin_lock_irq(q->queue_lock);
> +	cfq_log(cfqd, "cfq_kick_queue called. busy_queues=%d rq_queued=%d rq_in_driver=%d", cfqd->busy_queues, cfqd->rq_queued, cfqd->rq_in_driver);
>  	__blk_run_queue(cfqd->queue);
>  	spin_unlock_irq(q->queue_lock);
>  }
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c	2011-02-22 13:23:25.000000000 -0500
> +++ linux-2.6/block/blk-core.c	2011-02-23 11:50:34.406700216 -0500
> @@ -413,6 +413,7 @@ void __blk_run_queue(struct request_queu
>  		queue_flag_clear(QUEUE_FLAG_REENTER, q);
>  	} else {
>  		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
> +		trace_printk("not recursing. Scheduling another dispatch\n");
>  		kblockd_schedule_work(q, &q->unplug_work);
>  	}
>  }
> Index: linux-2.6/block/blk.h
> ===================================================================
> --- linux-2.6.orig/block/blk.h	2011-02-18 13:39:47.000000000 -0500
> +++ linux-2.6/block/blk.h	2011-02-23 11:53:37.844304978 -0500
> @@ -57,6 +57,8 @@ static inline struct request *__elv_next
>  {
>  	struct request *rq;
>  
> +	trace_printk("elv_next_request called. q=%p\n", q);
> +
>  	while (1) {
>  		while (!list_empty(&q->queue_head)) {
>  			rq = list_entry_rq(q->queue_head.next);
> @@ -68,8 +70,12 @@ static inline struct request *__elv_next
>  				return rq;
>  		}
>  
> -		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
> +		trace_printk("No requests in q->queue_head. Will call elevator. q=%p\n", q);
> +
> +		if (!q->elevator->ops->elevator_dispatch_fn(q, 0)) {
> +			trace_printk("No requests in elevator either q=%p\n", q);
>  			return NULL;
> +		}
>  	}
>  }
> 


