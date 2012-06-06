Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2FFMYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:24:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:44816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2FFMYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161680344"
Message-ID: <4FCF4BFE.6090103@linux.intel.com>
Date: Wed, 06 Jun 2012 20:24:30 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos> <4FCF0500.9050704@linux.intel.com> <alpine.LFD.2.02.1206061056520.3086@ionos> <alpine.LFD.2.02.1206061215250.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206061215250.3086@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/6 18:23, Thomas Gleixner 写道:
> On Wed, 6 Jun 2012, Thomas Gleixner wrote:
>
>> On Wed, 6 Jun 2012, Chen Gong wrote:
>>> 于 2012/6/5 21:35, Thomas Gleixner 写道:
>>> I add some print in timer callback, it shows:
>>>
>>> smp_processor_id() = 0, mce_timer_fn data(CPU id) = 10
>>> timer->function = ffffffff8102c200, timer pending = 1, CPU = 0
>>> (add_timer_on, BUG!!!)
>> Sure. That's not a surprise. The timer function for cpu 10 is called
>> on cpu 0. And the timer function does:
>>
>>    struct timer_list *t = &__get_cpu_var(mce_timer);
>>
>> which gets a pointer to the timer of cpu0. And that timer is
>> pending. So yes, it's exploding for a good reason.
>>
>> Though, this does not tell us how the timer of cpu10 gets on cpu0.
>>
>> Did you do any cpu hotplug operations ?
> There's a problem in the hotplug code.
>
>         case CPU_DOWN_PREPARE:
> 	case CPU_DOWN_PREPARE_FROZEN:
>                 del_timer_sync(t);
>                 smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
>                 break;
>
> We delete the timer before we disable mce and cmci. So if the cmci
> interrupt kicks the timer after del_timer_sync() and before
> mce_disable_cpu() is called on the other core, then the timer is still
> enqueued when the cpu goes down. After it's dead the timer is migrated
> and then the above scenario happens.
>
> Can you try the following just for a quick test ?
>
>         case CPU_DOWN_PREPARE:
> 	case CPU_DOWN_PREPARE_FROZEN:
>                 del_timer_sync(t);
>                 smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
> +		del_timer_sync(t);
>                 break;
I think you mean

-               del_timer_sync(t);
                smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		del_timer_sync(t);
                break;


I don't execute hotplug and the whole error injection shouldn't trigger
hotplug.
I tried your patch but the test result was as before. But your thought
give me
a new way to find out the reason. I will continue to do more tests on
tomorrow. :-)

