Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1ERFHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:07:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58354 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1ERFHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:07:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD353E9.6020503@jp.fujitsu.com>
Date: Wed, 18 May 2011 14:06:49 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: linux-kernel@vger.kernel.org, joe@perches.com, mingo@elte.hu,
        mina86@mina86.com, apw@canonical.com, jirislaby@gmail.com,
        rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] comm: Introduce comm_lock spinlock to protect task->comm
 access
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>	 <1305682865-27111-2-git-send-email-john.stultz@linaro.org>	 <4DD3287A.2030808@jp.fujitsu.com> <1305691896.2915.136.camel@work-vm>
In-Reply-To: <1305691896.2915.136.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If we provide __get_task_comm(), we can't remove memset() forever.
>
> True enough. I'll fix that comment up then.
>
>>
>>>    	task_lock(tsk);
>>> +	spin_lock_irqsave(&tsk->comm_lock, flags);
>>
>> This is strange order. task_lock() doesn't disable interrupt.
>
> Strange order? Can you explain why you think that is? Having comm_lock
> as an inner-most lock seems quite reasonable, given the limited nature
> of what it protects.

spinlock -> irq_disable is wrong order.

local_irq_save()
task_lock()
spin_lock(task->comm)

is better. I think.

I mean if the task get interrupt at following point,

     	task_lock(tsk);
         // HERE
	spin_lock_irqsave(&tsk->comm_lock, flags);

the task hold task-lock long time rather than expected.

>> And, can you please document why we need interrupt disabling?
>
> Since we might access current->comm from irq context. Where would you
> like this documented? Just there in the code?

I'm prefer code comment. but another way is also good.


Thanks.

