Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0DAAzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:55:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab0DAAzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:55:50 -0400
Message-ID: <4BB3EF25.1040804@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 08:56:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
References: <4BB014DF.9030905@cn.fujitsu.com> <20100329044236.GB2343@linux.vnet.ibm.com> <4BB1C7C5.5070700@cn.fujitsu.com> <20100330160339.GB2513@linux.vnet.ibm.com> <20100331153656.GA4623@linux.vnet.ibm.com>
In-Reply-To: <20100331153656.GA4623@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Mar 30, 2010 at 09:03:39AM -0700, Paul E. McKenney wrote:
>> On Tue, Mar 30, 2010 at 05:43:33PM +0800, Lai Jiangshan wrote:
>>> Paul E. McKenney wrote:
>>>> On Mon, Mar 29, 2010 at 10:47:59AM +0800, Lai Jiangshan wrote:
>>>>> Content-Type: text/plain; charset=UTF-8
>>>>> Content-Transfer-Encoding: 7bit
>>>>>
>>>>>
>>>>> Even though in user mode or idle mode, rcu_check_callbacks() is not
>>>>> context switch, so we don't call rcu_preempt_note_context_switch()
>>>>> in rcu_check_callbacks().
>>>>>
>>>>> Though there is no harm that calls rcu_preempt_note_context_switch()
>>>>> in rcu_check_callbacks(), but it is waste.
>>>>>
>>>>> rcu_check_callbacks()
>>>>>   rcu_sched_qs()
>>>>>     rcu_preempt_note_context_switch()
>>>>>        Now, ->rcu_read_lock_nesting == 0, so we just calls
>>>>>        rcu_preempt_qs(), but, rcu_preempt_check_callbacks()
>>>>>        will call it again and set the ->rcu_read_unlock_special
>>>>>        correct again.
>>>>>
>>>>> So let rcu_preempt_check_callbacks() handle things for us.
>>>> Nice!!!
>>>>
>>>> But how about naming the new function that invokes
>>>> rcu_preempt_note_context_switch() something like
>>>> rcu_sched_note_context_switch(), and then leaving the
>>>> name of rcu_sched_qs() the same (rather than changing
>>>> it to __rcu_sched_qs(), as below)?
>>>>
>>>> This way, the names clearly call out what the function
>>>> is doing.
>>>>
>>> If I understand right, it will become this:
>>>
>>> schedule() / run_ksoftirqd() / rcu_needs_cpu()
>>>   rcu_sched_note_context_switch()
>>>     rcu_sched_qs()
>>>     rcu_preempt_note_context_switch()
>> Wow!!!  That was a scare!!!  I misread "run_ksoftirqd()" as
>> "do_softirq().  ;-)
>>
>> And I am not seeing a call to rcu_sched_qs() in rcu_needs_cpu()...
>>
>> Here is how I believe it needs to go:
>>
>> 	schedule():
>> 		rcu_sched_note_context_switch()
>> 			rcu_sched_qs()
>> 			rcu_preempt_note_context_switch()
>>
>> 	run_ksoftirqd():
>> 		rcu_sched_qs()
>>
>> 	rcu_check_callbacks():
>> 		rcu_sched_qs() [if idle etc.]
>> 		rcu_bh_qs() [if not in softirq]
>>
>> The reason we don't need rcu_bh_qs() from run_ksoftirqd() is that
>> __do_softirq() already calls rcu_bh_qs().
>>
>> Make sense, or am I missing something?
> 
> And I was in fact missing something.  The rcu_preempt_note_context_switch()
> function currently combines some work that needs to happen only at
> context-switch time with work that needs to happen all the time.
> 
> At first glance, it appears that the big "if" statement in
> rcu_preempt_note_context_switch() need only happen for context switches.


> The remaining lines must happen unconditionally for context switches,
> and should be executed from rcu_check_callbacks() only if the current
> CPU is not in an RCU read-side critical section.
> 

I think rcu_preempt_check_callbacks() will do this work better
in rcu_check_callbacks().

Thanks, Lai
