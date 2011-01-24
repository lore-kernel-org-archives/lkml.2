Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1AXSvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:51:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1AXSvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:51:49 -0500
Date: Mon, 24 Jan 2011 13:51:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 3/6 v3] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110124185133.GD9420@redhat.com>
References: <4D180ECE.4000305@cn.fujitsu.com>
 <4D185374.6090300@cn.fujitsu.com>
 <20110119225855.GH13887@redhat.com>
 <4D37B2DA.1060908@cn.fujitsu.com>
 <20110120110952.GA16184@redhat.com>
 <4D3D03DE.20604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3D03DE.20604@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:45:18PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Thu, Jan 20, 2011 at 11:58:18AM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> On Mon, Dec 27, 2010 at 04:51:00PM +0800, Gui Jianfeng wrote:
> >>>> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> >>>> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> >>>> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> >>>> group scheduling on the same service tree.
> >>>>
> >>>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >>> [..]
> >>>> @@ -1246,47 +1278,71 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>>>  
> >>>>  	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> >>>>  						cfqq_type(cfqq));
> >>>> +	/*
> >>>> +	 * For the time being, put the newly added CFQ queue at the end of the
> >>>> +	 * service tree.
> >>>> +	 */
> >>>> +	if (RB_EMPTY_NODE(&cfqe->rb_node)) {
> >>>> +		/*
> >>>> +		 * If this CFQ queue moves to another group, the original
> >>>> +		 * vdisktime makes no sense any more, reset the vdisktime
> >>>> +		 * here.
> >>>> +		 */
> >>>> +		parent = rb_last(&service_tree->rb);
> >>>> +		if (parent) {
> >>>> +			u64 boost;
> >>>> +			s64 __vdisktime;
> >>>> +
> >>>> +			__cfqe = rb_entry_entity(parent);
> >>>> +			cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
> >>>> +
> >>>> +			/* Give some vdisktime boost according to its weight */
> >>>> +			boost = cfq_get_boost(cfqd, cfqe);
> >>>> +			__vdisktime = cfqe->vdisktime - boost;
> >>>> +			if (__vdisktime > service_tree->min_vdisktime)
> >>>> +				cfqe->vdisktime = __vdisktime;
> >>>> +			else
> >>>> +				cfqe->vdisktime = service_tree->min_vdisktime;
> >>>> +		} else
> >>>> +			cfqe->vdisktime = service_tree->min_vdisktime;
> >>> Hi Gui,
> >>>
> >>> Is above logic actually working? I suspect that most of the time all the
> >>> new queues will end up getting same vdisktime and that is st->min_vdisktime
> >>> and there will be no service differentiation across various prio.
> >>>
> >>> Reason being, on SSD, idle is disabled. So very few/no queue will consume
> >>> its slice and follow reque path. So every queue will be new. Now you are
> >>> doing following.
> >>>
> >>> 	cfqd->vdisktime = vdisktime_of_parent + IDLE_DELAY - boost
> >>>
> >>> assume vdisktime_of_parent=st->min_vdisktime, then (IDLE_DELAY - boost)
> >>> is always going to be a -ve number and hence cfqd->vdisktime will 
> >>> default to st->min_vdisktime. (IDLE_DELAY=200 while boost should be a huge
> >>> value due to SERVICE_SHIFT thing).
> >> Vivek,
> >>
> >> Actually, I tested on rotational disk with idling disabled, I saw service
> >> differentiation between two tasks with different ioprio.
> >> I don't have a SSD on hand, But I'll get one and do more tests.
> > 
> > Ok, I am really not sure how did it work for you because boost will
> > turn out to be huge number in comparision to IDLE_DELAY or vdisktime
> > of parent. If you have some blktrace data or if you can explain how
> > it is working will help in understanding it better.
> 
> Vivek,
> 
> I think there must be something configuration wrong in my previous tests.
> I tested again with patch applied. I don't see service differentiation
> this time.
> But, I do the same test on vanilla kernel, I don't see service differentiation
> either. I dig into it. It seems when I set slice_idle and group_idle to zero,
> it means i close idle window by mannual. In this case, IO tasks becomes SYNC NOIDLE
> workloads, they will preempts each other mutually. And the cfqq will always be put
> at the front of service tree. So we don't see service differentiation.
> 
> Actually, We don't want preemption happening in such case, right? So I think we should
> refine the preemption logic. 
> Thoughts?

Gui,

That preemption only happens when we are idling on existing sync-noidle
queue and a new queue gets backlogged. It makes sense from overall
throughput perspective. So I think getting rid of this is not a good
idea.

But agreed that it does not play well with ioprio thing. I would suggest
that instead of two threads, try more 4-5 threads which are doing IO and
keep queue depth as 1. That way you should end up in a case where there
are more than 1 thread backlogged on sync-noidle service tree.

Thanks
Vivek

> 
> Below is my fio job file:
> 
> [global]
> directory=/hdb3
> ioengine=sync
> runtime=30
> time_based=1
> direct=1
> bs=128K
> size=64M
> numjobs=1
> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
> 
> [task-prio-0]
> description=task-prio-0
> rw=read
> prio=0
> filename=file1
> 
> [task-prio-7]
> description=task-prio-7
> rw=read
> prio=7
> filename=file2
> 
> Thanks,
> Gui
