Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BUPlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab1BUPlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:41:35 -0500
Date: Mon, 21 Feb 2011 10:41:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110221154127.GG6428@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539804.9090308@cn.fujitsu.com>
 <20110214181322.GJ13097@redhat.com>
 <4D5E0BE2.6020104@cn.fujitsu.com>
 <20110218145432.GA26654@redhat.com>
 <4D61FE5A.5060402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D61FE5A.5060402@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 01:55:38PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Fri, Feb 18, 2011 at 02:04:18PM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:
> >>>
> >>> [..]
> >>>> +/*
> >>>> + * The time when a CFQ queue is put onto a service tree is recoreded in
> >>>> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
> >>>> + * on each service tree, and select the workload type that contains the lowest
> >>>> + * reposition_time CFQ queue among them.
> >>>> + */
> >>>>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >>>>  				struct cfq_group *cfqg, enum wl_prio_t prio)
> >>>>  {
> >>>>  	struct cfq_entity *cfqe;
> >>>> +	struct cfq_queue *cfqq;
> >>>> +	unsigned long lowest_start_time;
> >>>>  	int i;
> >>>> -	bool key_valid = false;
> >>>> -	unsigned long lowest_key = 0;
> >>>> +	bool time_valid = false;
> >>>>  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
> >>>>  
> >>>> +	/*
> >>>> +	 * TODO: We may take io priority and io class into account when
> >>>> +	 * choosing a workload type. But for the time being just make use of
> >>>> +	 * reposition_time only.
> >>>> +	 */
> >>>>  	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> >>>> -		/* select the one with lowest rb_key */
> >>>>  		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
> >>>> -		if (cfqe &&
> >>>> -		    (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
> >>>> -			lowest_key = cfqe->rb_key;
> >>>> +		cfqq = cfqq_of_entity(cfqe);
> >>>> +		if (cfqe && (!time_valid ||
> >>>> +			     time_before(cfqq->reposition_time,
> >>>> +					 lowest_start_time))) {
> >>>> +			lowest_start_time = cfqq->reposition_time;
> >>> Gui,
> >>>
> >>> Have you had a chance to run some mixed workloads in a group (some sync,
> >>> some async and some sync-idle queues), and see how latency and throughput
> >>> of sync-idle workload changes due to this "resposition_time" logic. I 
> >>> just want to make sure that latency of sync-noidle workload does not
> >>> go up as that's the workload that people care and gets noticed first.
> >> Hi Vivek,
> >>
> >> I made a quick test by using fio. It seems the number changes little
> >> between vanilla kernel and patched kernel.
> >>
> >>
> >> Vanilla:    SYNC read            SYNC-NOIDLE read      ASYNC write  
> >>          1. 23,640KB/s 5.40 ---- 6,696KB/s 19.07 ---- 50,142KB/s 128.00
> >>          2. 24,459KB/s 5.22 ---- 6,775KB/s 18.86 ---- 47,349KB/s 129.89
> >>          3. 25,929KB/s 4.93 ---- 7,378KB/s 17.32 ---- 32,350KB/s 131.88
> >>
> >> Patched:   SYNC read            SYNC-NOIDLE read      ASYNC write  
> >>         1. 24,000KB/s 5.32 ---- 6,942KB/s 18.39 ---- 30,860KB/s 135.95
> >>         2. 23,678KB/s 5.40 ---- 7,274KB/s 17.58 ---- 67,432KB/s 120.44
> >>         3. 23,004KB/s 5.55 ---- 6,621KB/s 19.30 ---- 36,536KB/s 148.64
> > 
> > Hi Gui,
> > 
> > Do you also have latency numbers? I am especially interested max completion
> > latencies of SYNC-NOIDLE workload.
> 
> Vivek,
> 
> Here some numbers about latency between vanilla and patched kernel.
> I tested 4 times for each. It seems no latency regression happens.
> 
> Vanilla:
> 1. clat (msec): min=1, max=302, avg=18.19, stdev=39.80
> 2. clat (msec): min=1, max=201, avg=17.76, stdev=31.90
> 3. clat (msec): min=1, max=303, avg=18.64, stdev=41.30
> 4. clat (msec): min=1, max=370, avg=17.43, stdev=35.09
> 
> Patched:
> 1. clat (msec): min=1, max=176, avg=19.00, stdev=32.98
> 2. clat (msec): min=1, max=175, avg=17.75, stdev=32.41
> 3. clat (msec): min=1, max=191, avg=19.11, stdev=33.28
> 4. clat (msec): min=1, max=176, avg=17.11, stdev=32.99

Thanks Gui, In fact they seem to have mproved a bit for sync-noidle
workload. So there are no major issues in presence of other SYNC-IDLE
and ASYNC workload. I wanted to be sure of that. If we run into issues,
we will tweak the worklaod selection logic futher.

Thanks
Vivek
