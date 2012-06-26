Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2FZKmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:42:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35371 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2FZKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:42:15 -0400
Message-ID: <4FE99206.8060109@linaro.org>
Date: Tue, 26 Jun 2012 12:42:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Thomas Renninger <trenn@suse.de>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi, cpuidle: Register with cpuidle even if cpu is onlined
 after boot (beyond maxcpus)
References: <4FDB549F.1020002@linaro.org> <201206251553.55867.trenn@suse.de> <4FE88BDE.1050406@linux.vnet.ibm.com> <201206261129.45591.trenn@suse.de> <4FE983E0.2050802@linaro.org> <4FE987BB.4020508@linux.vnet.ibm.com>
In-Reply-To: <4FE987BB.4020508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 11:58 AM, Srivatsa S. Bhat wrote:
> On 06/26/2012 03:11 PM, Daniel Lezcano wrote:
>> On 06/26/2012 11:29 AM, Thomas Renninger wrote:
>>> On Monday, June 25, 2012 06:03:42 PM Srivatsa S. Bhat wrote:
>>>> On 06/25/2012 07:23 PM, Thomas Renninger wrote:
>>>>
>>>>> On Monday, June 25, 2012 01:25:43 PM Srivatsa S. Bhat wrote:
>>>>>>
>>>>>> Daniel Lezcano noticed that after booting with maxcpus=X, if we online the
>>>>>> remaining cpus by writing: echo 1 > /sys/devices/system/cpu/cpuY/online, then
>>>>>> for the newly onlined cpus, the cpuidle directory is not found under
>>>>>> /sys/devices/system/cpu/cpuY.
>>>>>>
>>>>>> Partly, the reason for this is that acpi restricts the initialization to cpus
>>>>>> within the maxcpus limit. (See commit 75cbfb9 "ACPI: Do not try to set up acpi
>>>>>> processor stuff on cores exceeding maxcpus="). The maxcpus= kernel parameter is
>>>>>> used to restrict the number of cpus brought up during boot. That doesn't mean
>>>>>> that we should hard restrict the bring up of the remaining cpus later on.
>>>>>
>>>>> Sorry, but IMO it exaclty does mean that (adding more general lists for
>>>>> further comments).
>>>>>
>>>>> If you can online more cores than maxcpus= via sysfs, this sounds like a bug.
>>>>> Not the other way around.
>>>>>
>>>>> Compare with Documentation/kernel-parameters.txt:
>>>>>         maxcpus=        [SMP] Maximum number of processors that an SMP kernel
>>>>>                         should make use of.  maxcpus=n : n >= 0 limits the
>>>>>                         kernel to using 'n' processors.  n=0 is a special case,
>>>>>                         it is equivalent to "nosmp", which also disables
>>>>>                         the IO APIC.
>>>>>
>>>>> Chances that you run into more problems are high.
>>>>
>>>>
>>>> Right, I agree on that. So, IMHO, maxcpus=X doesn't mean that the kernel must and
>>>> should forbid any new cpus from coming online, but in the interest of avoiding
>>>> problems/complications in some obscure paths, I guess it makes sense to avoid
>>>> onlining new cpus beyond maxcpus.
>>>
>>> Yep, for such reasons:
>>>    - That nobody realizes this to be useful and makes use of it in a productive
>>>      environment
>>>    - If I see maxcpus=X in a bugreport's dmesg command line,
>>>      I want to be sure that's true.
>>>    - To enforce that things work as documented
>>>
>>>
>>> Wow, after looking a bit into this I found (Documentation/cpu-hotplug.txt):
>>>
>>> maxcpus=n    Restrict boot time cpus to n. Say if you have 4 cpus, using
>>>              maxcpus=2 will only boot 2. You can choose to bring the
>>>              other cpus later online, read FAQ's for more info.
>>>
>>> Looks like someone already documented this (IMO broken) behavior.
>>> I didn't find further info in the FAQs.
>>>
>>>> In any case, I was just trying to see why the simple removal of the setup_max_cpus
>>>> check in acpi_processor_add() wasn't enough to expose the cpuidle directories under
>>>> the new cpus.. and while debugging that, I came up with this patch. I don't mind
>>>> if this doesn't get picked up.
>>>
>>>> Right, the usecase of why somebody would like to online new cpus beyond maxcpus
>>>> doesn't look all that solid anyway. So I am OK with leaving the code as it is now.
>>>
>>> In the end this is a debug option, I expect everybody is aware of that.
>>> Yep, let's just leave it...
>>
>> In this case, let's remove the intel_idle_cpu_init stuff in
>> acpi_cpu_soft_notify, no ?
>>
> 
> Why? And how would that help? The intel_idle_cpu_init() call is essential if intel_idle
> driver is being used instead of acpi idle.

AFAIU, this code is not called after onlining a cpu greater than maxcpus
and Thomas thinks that system with cpu hotplug at runtime are not sold.

The problem I see with this code is acpi and intel-idle are tied
together now. I would like to break this dependency and use the notifier
to handle the cpu hotplug directly in intel-idle.

It is hard to test my patch as there is not such system and maxcpus is
not correctly handled here. I can use your patch to test my patch but
anyway ... I am just asking if that would make sense to remove this
portion of code instead :)

If we want to keep this code untouched, I can try my patch and maybe
Thomas will agreed to test it also on a cpu-online-runtime-system if he
has one.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

