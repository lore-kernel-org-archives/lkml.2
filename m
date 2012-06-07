Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2FGDcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 23:32:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:9811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab2FGDcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 23:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154010350"
Message-ID: <4FD020B0.5040608@linux.intel.com>
Date: Thu, 07 Jun 2012 11:32:00 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos> <4FCF0500.9050704@linux.intel.com> <alpine.LFD.2.02.1206061056520.3086@ionos> <alpine.LFD.2.02.1206061215250.3086@ionos> <4FCF4BFE.6090103@linux.intel.com> <alpine.LFD.2.02.1206061535410.3086@ionos> <alpine.LFD.2.02.1206061641450.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206061641450.3086@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/6 22:46, Thomas Gleixner 写道:
> On Wed, 6 Jun 2012, Thomas Gleixner wrote:
>
>> On Wed, 6 Jun 2012, Chen Gong wrote:
>>> 于 2012/6/6 18:23, Thomas Gleixner 写道:
>>> I think you mean
>>>
>>> -               del_timer_sync(t);
>>>                  smp_call_function_single(cpu, mce_disable_cpu,&action, 1);
>>> +		del_timer_sync(t);
>>>                  break;
>>
>> No I meant it the way I wrote, but as you don't execute hotplug it's
>> irrelevant.
>>
>> So the obvious candidate is the mce-injection code, which was
>> obviously never tested with DEBUG_PREEMPT enabled.
>>
>> raise_local() can be called with preemption enabled from
>> raise_mce(). Fix for that below.
>>
>> Though I can't see how that would do anything with the timer.
>
> I think I found it. Do you have CONFIG_NO_HZ enabled? Then mod_timer()
> will try to move the timer to a different cpu, when the cpu which is
> running that code is idle. Bloody obvious :(

Oh, yes, it works! mod_timer is really a naughty baby :-).
Now it passes the basic test, and then I will use your latest
patch series to test more scenarios.

>
> I'll send out a combo patch with all changes so far later.
>
> Thanks,
> 	
> 	tglx
>
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1307,7 +1307,7 @@ void mce_timer_kick(unsigned long interv
>
>   	if (timer_pending(t)) {
>   		if (time_before(when, t->expires))
> -			mod_timer(t, when);
> +			mod_timer_pinned(t, when);
>   	} else {
>   		t->expires = round_jiffies(when);
>   		add_timer_on(t, smp_processor_id());

