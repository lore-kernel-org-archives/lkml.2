Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2FHGmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:42:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56511 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2FHGmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:42:22 -0400
Message-ID: <4FD19E8C.7040207@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2012 12:11:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Tomas M." <tmezzadra@gmail.com>,
        Ferenc Wagner <wferi@niif.hu>, Arnd Bergmann <arnd@arndb.de>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        linux-pm@lists.linux-foundation.org, preeti@linux.vnet.ibm.com,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspend/resume regressions on Lenovo S10-3
References: <4FC2DA8C.7050401@linux.vnet.ibm.com> <4FCF5249.2070600@linux.vnet.ibm.com> <201206061543.03537.rjw@sisk.pl>
In-Reply-To: <201206061543.03537.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060720-0260-0000-0000-000001505165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 07:13 PM, Rafael J. Wysocki wrote:

> On Wednesday, June 06, 2012, Deepthi Dharwar wrote:
>> On 05/28/2012 07:23 AM, Dave Hansen wrote:
>>
>>> I have a Lenovo S10-3 Atom netbook.  It's always had some amount of
>>> trouble working with the intel_idle driver, so I usually compile that
>>> out an use the acpi one.  However, just after 3.1, suspend/resume broke.
>>>  'echo mem > /sys/power/state' would hang before suspending.  I bisected
>>> it down to the commits around:
>>>
>>> 	e978aa7d7d57d04eb5f88a7507c4fb98577def77 / v3.1-1-ge978aa7
>>>
>>> by Deepthi.  But, current mainline (v3.4-07644-g07acfc2) hangs with a
>>> different symptom: it suspends, but hangs on resume from suspend.  I
>>> think _that_ delta in the behavior was caused by:
>>>
>>> 	3439a8da16bcad6b0982ece938c9f8299bb53584
>>>
>>>         ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend
>>> 		regression)
>>>
>>> It's a bit of a pain to bisect these two different things in parallel.
>>> I was trying to tell git bisect 'good' on working suspend/resume, 'bad'
>>> on the hang during resume, and 'skip' on the hangs _during_ suspend.  83
>>> kernels in, I'm not sure that's working very well. :)
>>>
>>> Deepthi, do you have any idea why your patches broke me in the first
>>> place?  Perhaps we should fix that regression first before we go on and
>>> try to figure out what changed to let it suspend again, but break later.
>>
>>
>> Hi Dave,
>>
>> Sorry about my patches breaking your suspend-resume.
>>
>> I, basically tried out building and booting 3.1 kernel with 
>> my patch set to reproduce the failure. I could clearly
>> see suspend not happening. It turns out to be 
>> a bug with my first patch in global registration
>> series submitted earlier.
>>
>> e978aa7d7d57d04eb5f88a7507c4fb98577def77 / v3.1-1-ge978aa7
>>
>> The following patch, fixes the suspend issues
>> seen on my laptop due to earlier cpuidle cleanup 
>> (Lenevo T420 booting with acpi_idle enabled). 
>> Can you please give this a try
>> on top of my patch set (without Rafael's fix) 
>> and see if it fixes the problem for you. 
>> I am not reverting acpi_idle_suspend flag and 
>> hopefully it should resume fine too. 
>>
>> ---
>>
>> This patch fixes suspend-resume issue seen in the kernel 3.1
>> series using acpi_idle_driver because of cpuidle global 
>> registration cleanup.
>> Here, when acpi_idle_suspend flag was set ( during suspend)
>> the interrupts were not getting enabled in acpi_idle_enter_bm()
>> routine which was causing the system to hang.
>>
>>
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>>
>> ---
>>  drivers/acpi/processor_idle.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 24fe3af..6e35293 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -895,8 +895,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>>  	if (unlikely(!pr))
>>  		return -EINVAL;
>>  
>> -
>>  	if (acpi_idle_suspend) {
>> +		local_irq_disable();
>> +		local_irq_enable();
>>  		cpu_relax();
>>  		return -EINVAL;
>>  	}
> 
> May I say this is ugly?  Why can't we track the status of interrupts
> properly here?
> 


Btw, Deepthi, when you are modifying this to keep track of interrupt enabled/
disabled status, I think it would be worthwhile to also add a WARN_ON() in
cpu_idle() inside arch/x86/kernel/process.c, just like how ARM and sh do it.

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 735279e..1ca7e1a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -459,6 +459,9 @@ void cpu_idle(void)
                        if (cpuidle_idle_call())
                                pm_idle();

+                       /* The idle routine must return with IRQs enabled. */
+                       WARN_ON(irqs_disabled());
+
                        rcu_idle_exit();
                        start_critical_timings();

[If we had done this earlier, we could have caught the bug right when the
patch went in :-)]

Regards,

Srivatsa S. Bhat

