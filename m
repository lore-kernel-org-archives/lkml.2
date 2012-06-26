Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2FZLIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:08:21 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40403 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2FZLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:08:19 -0400
Message-ID: <4FE997DE.9020107@linux.vnet.ibm.com>
Date: Tue, 26 Jun 2012 16:37:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] acpi, cpuidle: Register with cpuidle even
 if cpu is onlined after boot (beyond maxcpus)
References: <4FDB549F.1020002@linaro.org> <201206251553.55867.trenn@suse.de> <4FE88BDE.1050406@linux.vnet.ibm.com>	<201206261129.45591.trenn@suse.de> <4FE983E0.2050802@linaro.org>	<4FE987BB.4020508@linux.vnet.ibm.com> <4FE99206.8060109@linaro.org>
In-Reply-To: <4FE99206.8060109@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062611-5564-0000-0000-00000356F410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 04:12 PM, Daniel Lezcano wrote:
> On 06/26/2012 11:58 AM, Srivatsa S. Bhat wrote:
>> On 06/26/2012 03:11 PM, Daniel Lezcano wrote:
>>> On 06/26/2012 11:29 AM, Thomas Renninger wrote:
>>>> On Monday, June 25, 2012 06:03:42 PM Srivatsa S. Bhat wrote:
>>>>> On 06/25/2012 07:23 PM, Thomas Renninger wrote:
>>>>>
>>>>>> On Monday, June 25, 2012 01:25:43 PM Srivatsa S. Bhat wrote:
>>>>>>>
>>>>>>> Daniel Lezcano noticed that after booting with maxcpus=X, if we online the
>>>>>>> remaining cpus by writing: echo 1 > /sys/devices/system/cpu/cpuY/online, then
>>>>>>> for the newly onlined cpus, the cpuidle directory is not found under
>>>>>>> /sys/devices/system/cpu/cpuY.
>>>>>>>
>>>>>>> Partly, the reason for this is that acpi restricts the initialization to cpus
>>>>>>> within the maxcpus limit. (See commit 75cbfb9 "ACPI: Do not try to set up acpi
>>>>>>> processor stuff on cores exceeding maxcpus="). The maxcpus= kernel parameter is
>>>>>>> used to restrict the number of cpus brought up during boot. That doesn't mean
>>>>>>> that we should hard restrict the bring up of the remaining cpus later on.
>>>>>>
>>>>>> Sorry, but IMO it exaclty does mean that (adding more general lists for
>>>>>> further comments).
>>>>>>
>>>>>> If you can online more cores than maxcpus= via sysfs, this sounds like a bug.
>>>>>> Not the other way around.
>>>>>>
>>>>>> Compare with Documentation/kernel-parameters.txt:
>>>>>>         maxcpus=        [SMP] Maximum number of processors that an SMP kernel
>>>>>>                         should make use of.  maxcpus=n : n >= 0 limits the
>>>>>>                         kernel to using 'n' processors.  n=0 is a special case,
>>>>>>                         it is equivalent to "nosmp", which also disables
>>>>>>                         the IO APIC.
>>>>>>
>>>>>> Chances that you run into more problems are high.
>>>>>
>>>>>
>>>>> Right, I agree on that. So, IMHO, maxcpus=X doesn't mean that the kernel must and
>>>>> should forbid any new cpus from coming online, but in the interest of avoiding
>>>>> problems/complications in some obscure paths, I guess it makes sense to avoid
>>>>> onlining new cpus beyond maxcpus.
>>>>
>>>> Yep, for such reasons:
>>>>    - That nobody realizes this to be useful and makes use of it in a productive
>>>>      environment
>>>>    - If I see maxcpus=X in a bugreport's dmesg command line,
>>>>      I want to be sure that's true.
>>>>    - To enforce that things work as documented
>>>>
>>>>
>>>> Wow, after looking a bit into this I found (Documentation/cpu-hotplug.txt):
>>>>
>>>> maxcpus=n    Restrict boot time cpus to n. Say if you have 4 cpus, using
>>>>              maxcpus=2 will only boot 2. You can choose to bring the
>>>>              other cpus later online, read FAQ's for more info.
>>>>
>>>> Looks like someone already documented this (IMO broken) behavior.
>>>> I didn't find further info in the FAQs.
>>>>
>>>>> In any case, I was just trying to see why the simple removal of the setup_max_cpus
>>>>> check in acpi_processor_add() wasn't enough to expose the cpuidle directories under
>>>>> the new cpus.. and while debugging that, I came up with this patch. I don't mind
>>>>> if this doesn't get picked up.
>>>>
>>>>> Right, the usecase of why somebody would like to online new cpus beyond maxcpus
>>>>> doesn't look all that solid anyway. So I am OK with leaving the code as it is now.
>>>>
>>>> In the end this is a debug option, I expect everybody is aware of that.
>>>> Yep, let's just leave it...
>>>
>>> In this case, let's remove the intel_idle_cpu_init stuff in
>>> acpi_cpu_soft_notify, no ?
>>>
>>
>> Why? And how would that help? The intel_idle_cpu_init() call is essential if intel_idle
>> driver is being used instead of acpi idle.
> 
> AFAIU, this code is not called after onlining a cpu greater than maxcpus
> and Thomas thinks that system with cpu hotplug at runtime are not sold.
> 

No, the point that Thomas is making is, if you boot with maxcpus=X, it looks
odd if you want to online more cpus later on. And allowing that is scary
because those code paths may not be well-tested or even designed to do that.

But one thing is crystal clear about the maxcpus semantics: if you say maxcpus=X
while booting, the kernel must not even *attempt* to initialize *anything* for
the remaining cpus, as far as possible. For all you know, the user might have
discovered a problem (which will cause a crash during init) and hence is setting
maxcpus to a smaller value than available, to just be able to still have a usable
system.

> The problem I see with this code is acpi and intel-idle are tied
> together now. I would like to break this dependency and use the notifier
> to handle the cpu hotplug directly in intel-idle.
> 

Ok, that's a different problem, unrelated to maxcpus. And in that context, what
you are proposing (breaking that dependency) looks good to me.

> It is hard to test my patch as there is not such system and maxcpus is
> not correctly handled here. I can use your patch to test my patch but
> anyway ... I am just asking if that would make sense to remove this
> portion of code instead :)
> 

> If we want to keep this code untouched, I can try my patch and maybe
> Thomas will agreed to test it also on a cpu-online-runtime-system if he
> has one.
> 

Again, to reiterate, we all agree that we can offline/online existing cpus
on a running system. We can also (perhaps) do physical cpu hotplug, and
we want to support it in Linux, if such hardware exists. What doesn't really
make much sense is a "usecase" where you boot the kernel with maxcpus=X and
then try to online more cpus than that. Saying no to that looks safe and is
preferred, than trying to "handle" it, because we cannot guarantee that it
will work in all cases anyway.

But in a separate context (unrelated to maxcpus), moving the intel idle stuff
into intel idle code (from acpi idle) looks like a sensible thing to do. But
then, dependency between the two must be handled properly (ie., low-level acpi
init must happen first, followed by intel idle init, for a hotplugged cpu).

Regards,
Srivatsa S. Bhat

