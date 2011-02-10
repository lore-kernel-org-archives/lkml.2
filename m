Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1BJT3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1BJT3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:29:48 -0500
Date: Thu, 10 Feb 2011 14:29:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110210192940.GA2600@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539804.9090308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D539804.9090308@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:
> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> group scheduling on the same service tree.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |  219 +++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 167 insertions(+), 52 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index f3a126e..41cef2e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -39,6 +39,13 @@ static const int cfq_hist_divisor = 4;
>   */
>  #define CFQ_IDLE_DELAY		(HZ / 5)
>  
> +/* 
> + * The base boosting value.
> + */
> +#define CFQ_BOOST_SYNC_BASE          (HZ / 10)
> +#define CFQ_BOOST_ASYNC_BASE          (HZ / 25)
> +

These are same as cfq_slice_sync and cfq_slice_async. Looking at
boost logic, this is equivalent of starting a new queue/group as
if it is being requeued after conuming a full slice. So may be we can divide
it by some const number say 4 or something like that. This is a minor
point though as this algorimthm will kind of evolve and we will learn
what works best.

Secondly, I think you wanted to SYNC vs ASYNC logic seem to be reversed.
We would like to give ASYNC queues higher boost (Put these farther in 
tree) and lesser boost to SYNC queues. Looks like above constants will
do the reverse? 


[..]
> +	if (RB_EMPTY_NODE(&cfqe->rb_node)) {
> +		/*
> +		 * If this CFQ queue moves to another group, the original
> +		 * vdisktime makes no sense any more, reset the vdisktime
> +		 * here.
> +		 */
> +		parent = rb_last(&service_tree->rb);
> +		if (parent) {
> +			u64 pos_offset;
> +
> +			/*
> +			 * Estimate the position according to its weight and
> +			 * ioprio.
> +			 */
> +			pos_offset = cfq_get_boost(cfqd, cfqq);
> +			/* Debug purpose, should remove. */
> +			cfq_log_cfqq(cfqd, cfqq, "pos_offset: %llu",
> +				     pos_offset);

You wanted to get rid of above debugging comment?

Thanks
Vivek
