Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0JRMWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:22:04 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56628 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab0JRMWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:22:02 -0400
Message-ID: <4CBC3BE2.2020802@kernel.dk>
Date: Mon, 18 Oct 2010 14:21:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com> <4CB6FDB7.5010501@kernel.dk> <4CB8135E.1030100@jp.fujitsu.com> <4CB82720.8040708@kernel.dk> <4CBC0524.7060804@jp.fujitsu.com> <4CBC06B2.7070107@kernel.dk> <4CBC3B3A.9040300@jp.fujitsu.com>
In-Reply-To: <4CBC3B3A.9040300@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-18 14:19, Yasuaki Ishimatsu wrote:
> Hi Jens,
> 
> Jens Axboe wrote:
>> On 2010-10-18 10:28, Yasuaki Ishimatsu wrote:
>>> Hi Jens,
>>>
>>>> This looks good! To quiesce the queue, something like the below.
>>>> Completely untested.
>>> Thank you for your advice.
>>> I applied your idea to the patch.
>>
>> But you changed it, though:
>>
>>>  	if (old_ptbl) {
>>>  		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
>>> +		spin_lock_irq(q->queue_lock);
>>> +		elv_quiesce_start(q);
>>>  		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
>>> +		elv_quiesce_end(q);
>>> +		spin_unlock_irq(q->queue_lock);
>>>  	}
>>>  }
>>
>> That is not going to work. The point is to start the drain period
>> before, then end it when the callback has gone through. By placing it
>> just after the call_rcu() call, there's no guarentee that the RCU grace
>> period has elapsed. That is why I placed it inside the rcu callback. Why
>> did you move it?
> 
> Ah...
> I misunderstood the purpose of the call_rcu().
> I moved elv_quiesce_end() to the rcu callback.

This version looks good, thanks for following through on this. What kind
of testing did you do?

-- 
Jens Axboe

