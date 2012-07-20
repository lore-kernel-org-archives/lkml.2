Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab2GTO6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:58:23 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:32773 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GTO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:58:22 -0400
Message-ID: <500971C6.4040204@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 20:27:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1550 __rcu_process_callbacks+0x46f/0x4b0()
References: <5007F8FA.7000203@linux.vnet.ibm.com> <20120719171550.GL2507@linux.vnet.ibm.com> <500935BC.4040405@linux.vnet.ibm.com> <20120720143657.GC2721@linux.vnet.ibm.com>
In-Reply-To: <20120720143657.GC2721@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072014-5564-0000-0000-000003AEDB83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:06 PM, Paul E. McKenney wrote:
> On Fri, Jul 20, 2012 at 04:11:00PM +0530, Srivatsa S. Bhat wrote:
>> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
>>> On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
>>>> Hi Paul,
>>>>
>>>> While running a CPU hotplug stress test on v3.5-rc7+
>>>> (mainline commit 8a7298b7805ab) I hit this warning.
>>>> I haven't tried to debug this yet...
>>>>
>>>> Line number 1550 maps to:
>>>>
>>>> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
>>>>
>>>> inside rcu_do_batch().
>>>
>>> Hello, Srivatsa,
>>>
>>> I believe that you need commit a16b7a69 (Prevent __call_rcu() from
>>> invoking RCU core on offline CPUs), which is currently in -tip, queued
>>> for 3.6.  Please see below for the patch.
>>>
>>> Does this help?
>>
>> Yes, that fixed it, thanks! :-)
>> Sorry for the noise...
> 
> May I add your Tested-by?

Of course, go ahead! :-)

Regards,
Srivatsa S. Bhat

>>
>>>
>>> ------------------------------------------------------------------------
>>>
>>> rcu: Prevent __call_rcu() from invoking RCU core on offline CPUs
>>>
>>> The __call_rcu() function will invoke the RCU core, for example, if
>>> it detects that the current CPU has too many callbacks.  However, this
>>> can happen on an offline CPU that is on its way to the idle loop, in
>>> which case it is an error to invoke the RCU core, and the excess callbacks
>>> will be adopted in any case.  This commit therefore adds checks to
>>> __call_rcu() for running on an offline CPU, refraining from invoking
>>> the RCU core in this case.
>>>
>>> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>>
>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>> index a4a9c91..ceaa959 100644
>>> --- a/kernel/rcutree.c
>>> +++ b/kernel/rcutree.c
>>> @@ -1904,11 +1904,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>>>  	 * If called from an extended quiescent state, invoke the RCU
>>>  	 * core in order to force a re-evaluation of RCU's idleness.
>>>  	 */
>>> -	if (rcu_is_cpu_idle())
>>> +	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
>>>  		invoke_rcu_core();
>>>
>>> -	/* If interrupts were disabled, don't dive into RCU core. */
>>> -	if (irqs_disabled_flags(flags)) {
>>> +	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
>>> +	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
>>>  		local_irq_restore(flags);
>>>  		return;
>>>  	}
>>>

