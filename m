Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2JQEtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:49:14 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52698 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2JQEtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:49:13 -0400
Message-ID: <507E388F.102@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 10:18:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: peterz@infradead.org, acme@ghostprotocols.net, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] perf, cpu hotplug: Run CPU_STARTING notifiers
 with irqs disabled
References: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com> <20121016163140.GA2385@linux.vnet.ibm.com> <507D8D3B.5000506@linux.vnet.ibm.com> <20121016183431.GF2385@linux.vnet.ibm.com>
In-Reply-To: <20121016183431.GF2385@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101704-5490-0000-0000-0000024CA592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:04 AM, Paul E. McKenney wrote:
> On Tue, Oct 16, 2012 at 10:07:15PM +0530, Srivatsa S. Bhat wrote:
>> On 10/16/2012 10:01 PM, Paul E. McKenney wrote:
>>> On Tue, Oct 16, 2012 at 01:28:10PM +0530, Srivatsa S. Bhat wrote:
>>>> The CPU_STARTING notifiers are supposed to be run with irqs disabled. But the
>>>> perf_cpu_notifier() macro invokes them without doing that. Fix it.
>>>
>>> Color me confused...
>>
>> Hehe, I believe the context provided by diff tricked you ;-)
>> The function I am referring to is perf_cpu_notifier(), not
>> perf_event_task_tick() :-)
> 
> It did indeed fool me!  And indeed, checking the code did indeed show
> that the name of interest if perf_cpu_notifier().
> 
> When using the correct name, I do indeed find places where it is
> called with interrupts enabled.  So...
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>

Great! Thank you :)

Regards,
Srivatsa S. Bhat

>>
>>>  Isn't perf_event_task_tick() invoked only
>>> from scheduler_tick(), which always has interrupts disabled?
>>>
>>> Or are you needing to invoke it from somewhere else?
>>>
>>> 							Thanx, Paul
>>>
>>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>>> ---
>>>>
>>>>  include/linux/perf_event.h |    3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>>> index 2e90235..0647805 100644
>>>> --- a/include/linux/perf_event.h
>>>> +++ b/include/linux/perf_event.h
>>>> @@ -803,10 +803,13 @@ static inline void perf_event_task_tick(void)				{ }
>>>>  do {									\
>>>>  	static struct notifier_block fn##_nb __cpuinitdata =		\
>>>>  		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
>>>> +	unsigned long flags;						\
>>>>  	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
>>>>  		(void *)(unsigned long)smp_processor_id());		\
>>>> +	local_irq_save(flags);						\
>>>>  	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
>>>>  		(void *)(unsigned long)smp_processor_id());		\
>>>> +	local_irq_restore(flags);					\
>>>>  	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
>>>>  		(void *)(unsigned long)smp_processor_id());		\
>>>>  	register_cpu_notifier(&fn##_nb);				\
>>>>
>>

