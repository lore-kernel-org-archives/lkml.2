Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab1BLBVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:21:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1BLBVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:21:03 -0500
Message-ID: <4D55E07A.8060903@cn.fujitsu.com>
Date: Sat, 12 Feb 2011 09:20:58 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539804.9090308@cn.fujitsu.com> <20110210192940.GA2600@redhat.com>
In-Reply-To: <20110210192940.GA2600@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-12 09:20:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-12 09:20:08,
	Serialize complete at 2011-02-12 09:20:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:
>> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
>> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
>> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
>> group scheduling on the same service tree.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |  219 +++++++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 167 insertions(+), 52 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index f3a126e..41cef2e 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -39,6 +39,13 @@ static const int cfq_hist_divisor = 4;
>>   */
>>  #define CFQ_IDLE_DELAY		(HZ / 5)
>>  
>> +/* 
>> + * The base boosting value.
>> + */
>> +#define CFQ_BOOST_SYNC_BASE          (HZ / 10)
>> +#define CFQ_BOOST_ASYNC_BASE          (HZ / 25)
>> +
> 
> These are same as cfq_slice_sync and cfq_slice_async. Looking at
> boost logic, this is equivalent of starting a new queue/group as
> if it is being requeued after conuming a full slice. So may be we can divide
> it by some const number say 4 or something like that. This is a minor
> point though as this algorimthm will kind of evolve and we will learn
> what works best.
> 
> Secondly, I think you wanted to SYNC vs ASYNC logic seem to be reversed.
> We would like to give ASYNC queues higher boost (Put these farther in 
> tree) and lesser boost to SYNC queues. Looks like above constants will
> do the reverse? 

Hi Vivek,

Currently, SYNC and ASYNC queues are in different service tree, they don't
impact each other. Here, I Really want use this logic.

Thanks,
Gui

> 
> 
> [..]
>> +	if (RB_EMPTY_NODE(&cfqe->rb_node)) {
>> +		/*
>> +		 * If this CFQ queue moves to another group, the original
>> +		 * vdisktime makes no sense any more, reset the vdisktime
>> +		 * here.
>> +		 */
>> +		parent = rb_last(&service_tree->rb);
>> +		if (parent) {
>> +			u64 pos_offset;
>> +
>> +			/*
>> +			 * Estimate the position according to its weight and
>> +			 * ioprio.
>> +			 */
>> +			pos_offset = cfq_get_boost(cfqd, cfqq);
>> +			/* Debug purpose, should remove. */
>> +			cfq_log_cfqq(cfqd, cfqq, "pos_offset: %llu",
>> +				     pos_offset);
> 
> You wanted to get rid of above debugging comment?
> 
> Thanks
> Vivek
> 

-- 
Regards
Gui Jianfeng
