Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1ASW7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:59:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1ASW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:59:07 -0500
Date: Wed, 19 Jan 2011 17:58:55 -0500
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
Message-ID: <20110119225855.GH13887@redhat.com>
References: <4D180ECE.4000305@cn.fujitsu.com>
 <4D185374.6090300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D185374.6090300@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 04:51:00PM +0800, Gui Jianfeng wrote:
> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> group scheduling on the same service tree.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

[..]
> @@ -1246,47 +1278,71 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
>  						cfqq_type(cfqq));
> +	/*
> +	 * For the time being, put the newly added CFQ queue at the end of the
> +	 * service tree.
> +	 */
> +	if (RB_EMPTY_NODE(&cfqe->rb_node)) {
> +		/*
> +		 * If this CFQ queue moves to another group, the original
> +		 * vdisktime makes no sense any more, reset the vdisktime
> +		 * here.
> +		 */
> +		parent = rb_last(&service_tree->rb);
> +		if (parent) {
> +			u64 boost;
> +			s64 __vdisktime;
> +
> +			__cfqe = rb_entry_entity(parent);
> +			cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
> +
> +			/* Give some vdisktime boost according to its weight */
> +			boost = cfq_get_boost(cfqd, cfqe);
> +			__vdisktime = cfqe->vdisktime - boost;
> +			if (__vdisktime > service_tree->min_vdisktime)
> +				cfqe->vdisktime = __vdisktime;
> +			else
> +				cfqe->vdisktime = service_tree->min_vdisktime;
> +		} else
> +			cfqe->vdisktime = service_tree->min_vdisktime;

Hi Gui,

Is above logic actually working? I suspect that most of the time all the
new queues will end up getting same vdisktime and that is st->min_vdisktime
and there will be no service differentiation across various prio.

Reason being, on SSD, idle is disabled. So very few/no queue will consume
its slice and follow reque path. So every queue will be new. Now you are
doing following.

	cfqd->vdisktime = vdisktime_of_parent + IDLE_DELAY - boost

assume vdisktime_of_parent=st->min_vdisktime, then (IDLE_DELAY - boost)
is always going to be a -ve number and hence cfqd->vdisktime will 
default to st->min_vdisktime. (IDLE_DELAY=200 while boost should be a huge
value due to SERVICE_SHIFT thing).

I think this logic needs refining. Maybe instead of subtracting the boost
we can instead place entities further away from st->min_vdisktime and
offset is higher for lower ioprio queues.

	cfqe->vdisktime = st->min_vdisktime + offset

here offset is something similar to boost but reversed in nature in the
sense that lower weight has got lower offset and vice-versa.

The important test here will be to run bunch of cfqq queues of different 
ioprio on a SSD with queue depth 1 and see if you can see the service
differentiation. If yes, then you can increase the queue depth a bit
and also number of competing queues and see what's the result. Also 
monitor the blktrace and vdisktime and make sure higher prio queues
get to run more than lower prio queues.

This is the most critical piece of converting cfqq scheduling logic,
so lets make sure that we get it right.


Thanks
Vivek
