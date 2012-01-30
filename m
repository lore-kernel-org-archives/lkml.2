Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2A3KBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:01:12 -0500
Received: from plane.gmane.org ([80.91.229.3]:34463 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2A3KBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:01:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Date: Mon, 30 Jan 2012 11:00:58 +0100
Message-ID: <4F266A5A.6050207@web.de>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <1327449683.14373.12.camel@edumazet-laptop>   <20120125091818.45e00b3c.kamezawa.hiroyu@jp.fujitsu.com>  <1327451195.14373.28.camel@edumazet-laptop> <4F264F75.7040601@web.de> <1327915555.2288.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
X-Gmane-NNTP-Posting-Host: p5b3718ae.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
In-Reply-To: <1327915555.2288.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote, on 01/30/12 10:25:
> Le lundi 30 janvier 2012 à 09:06 +0100, Jörg-Volker Peetz a écrit :
>> Eric Dumazet wrote, on 01/25/12 01:26:
>>> Le mercredi 25 janvier 2012 à 09:18 +0900, KAMEZAWA Hiroyuki a écrit :
>>>
>>>> BTW, what is the reason of this change ?
>>>>
>>>>> -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
>>>>> +	unsigned size = 1024 + 128 * num_possible_cpus();
>>>>
>>>> I think size of buffer is affected by the number of online cpus.
>>>> (Maybe 128 is enough but please add comment why 128 ?)
>>>>
>>>
>>> There is no change, as 4096/32 is 128 bytes per cpu.
>>>
>>
>> Wrong math, only num_possible_cpus() is divided by 32. Thus,
>>
>> -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
>> +	unsigned size = 4096 + 128 * num_possible_cpus();
>>
>> <snip>
> 
> 
> It is good math, once you take the time to think a bit about it.
> 
> The original question was about the 128 * num_possible_cpus()
> 
> 4096/32 is 128 as I said. 
> 
> The 4096 -> 1024 is just taking into account fact that once you do the
> correct computations, you dont need initial 4096 value, and 1024 is more
> than enough.

Thanks for your explanation, that makes sense now. At first, I was mislead by
your comment "There is no change" which was apparently related to the second
term in the formula.

> 
> Example on a dual core machine : 
> 
> # dmesg|grep nr_irq
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] NR_IRQS:2304 nr_irqs:712 16
> 
> size = 1024 + 2*128 + 2*712 = 2704 bytes (rounded to 4096 by kmalloc())
> 
> # wc -c /proc/stat
> 1767 /proc/stat
> 
> Problem with original math was that for a machine with 16 cpus or a
> machine with 1 cpu, we ended with the same 4096 value. That was a real
> problem.
> 
> If we instead use "unsigned size = 4096 + 128 * num_possible_cpus();" as
> you suggest, we would always allocate 2 pages of memory, this is not
> needed at all for typical 1/2/4 way machines.
> 
-- 
Best regards,
Jörg-Volker.

