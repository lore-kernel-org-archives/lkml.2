Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab1H0Ggz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 02:36:55 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:50238
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1H0Ggx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 02:36:53 -0400
Message-ID: <4E589084.7020607@kernel.dk>
Date: Sat, 27 Aug 2011 08:36:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shaohua Li <shaohua.li@intel.com>, Suresh Jayaraman <sjayaraman@suse.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: document blk_plug
References: <1311909215.15392.418.camel@sli10-conroe> <4E32A409.6060707@suse.de> <1312245970.15392.446.camel@sli10-conroe> <20110826152518.dc63fe89.akpm@linux-foundation.org>
In-Reply-To: <20110826152518.dc63fe89.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-27 00:25, Andrew Morton wrote:
> On Tue, 02 Aug 2011 08:46:10 +0800
> Shaohua Li <shaohua.li@intel.com> wrote:
> 
>> On Fri, 2011-07-29 at 20:14 +0800, Suresh Jayaraman wrote:
>>> On 07/29/2011 08:43 AM, Shaohua Li wrote:
>>>> Andrew Morton is asking to document blk_plug, so here is my attempt.
>>>>
>>>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>>> ---
>>>>  include/linux/blkdev.h |   11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> Index: linux/include/linux/blkdev.h
>>>> ===================================================================
>>>> --- linux.orig/include/linux/blkdev.h	2011-07-29 10:51:29.000000000 +0800
>>>> +++ linux/include/linux/blkdev.h	2011-07-29 11:07:49.000000000 +0800
>>>> @@ -858,6 +858,17 @@ struct request_queue *blk_alloc_queue_no
>>>>  extern void blk_put_queue(struct request_queue *);
>>>>  
>>>>  /*
>>>> + * blk_plug gives each task a request list. Since blk_start_plug() called,
>>>> + * requests from the task will be added to the per-task list and then moved
>>>> + * to global request_queue in a batch way at appropriate time(either
>>>> + * blk_finish_plug() is called or task goes to sleep). blk_plug has some
>>>> + * advantages:
>>>> + * 1. Better request merge. The assumption here is requests from a task have
>>>> + *    better chances to be merged.
>>>> + * 2. Better scalability. Requests are moved from per-task list to global
>>>> + *    request_queue in a batch way, so the total times grabing global
>>>> + *    request_queue lock are reduced.
>>>> + *
>>>
>>> Hi Shaohua,
>>>
>>> This seems too brief atleast for someone like me who has not spent much
>>> time with the code and also is not in kerneldoc format. Here's my attempt:
>> Hi Suresh,
>> I like the blk_start_plug part below. The blk_plug part needs more
>> description to explain why we need it.
>>
> 
> I'm getting all excited about getting some blk_plug documentation!
> 
>>> From: Suresh Jayaraman <sjayaraman@suse.de>
>>> Subject: [PATCH] block: document blk-plug
>>>
>>> Thus spake Andrew Morton:
>>>
>>> "And I have the usual maintainability whine.  If someone comes up to
>>> vmscan.c and sees it calling blk_start_plug(), how are they supposed to
>>> work out why that call is there?  They go look at the blk_start_plug()
>>> definition and it is undocumented.  I think we can do better than this?"
>>>
>>> Shaohua Li attempted to document it. But, I think it was too brief and
>>> was not in kerneldoc format. Here's my attempt to document it. 
>>>
>>> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
>>> ---
>>>
>>>  block/blk-core.c       |   10 ++++++++++
>>>  include/linux/blkdev.h |   13 ++++++++-----
>>>  2 files changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index b850bed..355aa2c 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2620,6 +2620,16 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_work);
>>>  
>>>  #define PLUG_MAGIC	0x91827364
>>>  
>>> +/**
>>> + * blk_start_plug - initialize blk_plug and track it inside the task_struct
>>> + * @plug:	The &struct blk_plug that needs to be initialized
>>> + *
>>> + * Description:
>>> + *   Tracking blk_plug inside the task_struct will help with flushing the
>>> + *   pending I/O should the task end up blocking between blk_start_plug() and
>>> + *   blk_finish_plug() and is important for deadlock avoidance and for the
>>> + *   performance.
>>> + */
>> I'm not aware blk_plug is to avoid deadlock. It's most for performance
>> to me. Jens, any idea?
> 
> Only we can't document it because we don't understand it.  Great.
> 
> c'mon Jens.   Talk to us?

The pointer in the task_struct is to be able to auto-flush the plug if
the task inadvertently ends up scheduling with requests plugged. For
instance, if we end up doing a wait for a page that is already plugged,
then we must ensure that everything up to that point has been flushed
out.

-- 
Jens Axboe

