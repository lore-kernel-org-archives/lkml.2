Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2DTG0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:26:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59910 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2DTG0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:26:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="181082167"
Message-ID: <4F9101A7.5010100@codeaurora.org>
Date: Thu, 19 Apr 2012 23:26:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with flush_work()
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org> <20120419081002.GB3963@zhy> <4F905B30.4080501@codeaurora.org> <20120420052633.GA16219@zhy> <20120420060101.GA16563@zhy>
In-Reply-To: <20120420060101.GA16563@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/2012 11:01 PM, Yong Zhang wrote:
> On Fri, Apr 20, 2012 at 01:26:33PM +0800, Yong Zhang wrote:
>> On Thu, Apr 19, 2012 at 11:36:32AM -0700, Stephen Boyd wrote:
>>> Does looking at the second patch help? Basically schedule_work() can run
>>> the callback right between the time the mutex is acquired and
>>> flush_work() is called:
>>>
>>> CPU0                        CPU1
>>>
>>> <irq>
>>>   schedule_work()           mutex_lock(&mutex)
>>> <irq return>
>>>     my_work()               flush_work() 
>>>       mutex_lock(&mutex)    
>>>       <deadlock>
>> Get you point. It is a problem. But your patch could introduece false
>> positive since when flush_work() is called that very work may finish
>> running already.
>>
>> So I think we need the lock_map_acquire()/lock_map_release() only when
>> the work is under processing, no?
> But start_flush_work() has tried take care of this issue except it
> doesn't add work->lockdep_map into the chain.
>
> So does below patch help?
>
[snip]
> @@ -2461,6 +2461,8 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
>  		lock_map_acquire(&cwq->wq->lockdep_map);
>  	else
>  		lock_map_acquire_read(&cwq->wq->lockdep_map);
> +	lock_map_acquire(&work->lockdep_map);
> +	lock_map_release(&work->lockdep_map);
>  	lock_map_release(&cwq->wq->lockdep_map);
>  
>  	return true;

No this doesn't help. The whole point of the patch is to get lockdep to
complain in the case where the work is not queued. That case is not a
false positive. We will get a lockdep warning if the work is running
(when start_flush_work() returns true) solely with the
lock_map_acquire() on cwq->wq->lockdep_map.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

