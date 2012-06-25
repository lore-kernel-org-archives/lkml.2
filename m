Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2FYQEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:04:54 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33426 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2FYQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:04:51 -0400
Message-ID: <4FE88BDE.1050406@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 21:33:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi, cpuidle: Register with cpuidle even if cpu is onlined
 after boot (beyond maxcpus)
References: <4FDB549F.1020002@linaro.org> <4FE027AC.8010607@linaro.org> <4FE84AB7.6020305@linux.vnet.ibm.com> <201206251553.55867.trenn@suse.de>
In-Reply-To: <201206251553.55867.trenn@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062516-5816-0000-0000-0000034DF1EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 07:23 PM, Thomas Renninger wrote:

> On Monday, June 25, 2012 01:25:43 PM Srivatsa S. Bhat wrote:
>>
>> Daniel Lezcano noticed that after booting with maxcpus=X, if we online the
>> remaining cpus by writing: echo 1 > /sys/devices/system/cpu/cpuY/online, then
>> for the newly onlined cpus, the cpuidle directory is not found under
>> /sys/devices/system/cpu/cpuY.
>>
>> Partly, the reason for this is that acpi restricts the initialization to cpus
>> within the maxcpus limit. (See commit 75cbfb9 "ACPI: Do not try to set up acpi
>> processor stuff on cores exceeding maxcpus="). The maxcpus= kernel parameter is
>> used to restrict the number of cpus brought up during boot. That doesn't mean
>> that we should hard restrict the bring up of the remaining cpus later on.
> 
> Sorry, but IMO it exaclty does mean that (adding more general lists for
> further comments).
> 
> If you can online more cores than maxcpus= via sysfs, this sounds like a bug.
> Not the other way around.
> 
> Compare with Documentation/kernel-parameters.txt:
>         maxcpus=        [SMP] Maximum number of processors that an SMP kernel
>                         should make use of.  maxcpus=n : n >= 0 limits the
>                         kernel to using 'n' processors.  n=0 is a special case,
>                         it is equivalent to "nosmp", which also disables
>                         the IO APIC.
> 
> Chances that you run into more problems are high.


Right, I agree on that. So, IMHO, maxcpus=X doesn't mean that the kernel must and
should forbid any new cpus from coming online, but in the interest of avoiding
problems/complications in some obscure paths, I guess it makes sense to avoid
onlining new cpus beyond maxcpus.

In any case, I was just trying to see why the simple removal of the setup_max_cpus
check in acpi_processor_add() wasn't enough to expose the cpuidle directories under
the new cpus.. and while debugging that, I came up with this patch. I don't mind
if this doesn't get picked up.

> It would help if it is explained why at all this would be needed.
> 


Right, the usecase of why somebody would like to online new cpus beyond maxcpus
doesn't look all that solid anyway. So I am OK with leaving the code as it is now.

> If there really is a valid use-case, possibly a bootcpus= param could get
> defined or above documentation is adjusted. But this would need thorough
> double checking, because I expect maxcpus=X was never intended to bring up
> more than X cores later via sysfs and I expect there are more
> places where things have to get ajusted.
> 


Yep, that sounds reasonable.

Regards,
Srivatsa S. Bhat

> 
>> So
>> teach acpi to play nice with maxcpus= parameter, and perform the initialization
>> for all present cpus, but defer their startup to the point when they are
>> actually onlined later.
>>
>> But that alone won't suffice as a fix, because there is one more thing that
>> the present but !online cpus lack - the need_hotplug_init flag.
>> The need_hotplug_init flag is set only for physically hotplugged cpus and not
>> for cpus which were already present but not brought online during boot (due to
>> the maxcpus= parameter). For cpus with this flag set, during the online
>> operation, acpi_cpu_soft_notify() takes care of the registration with cpuidle.
>> So, in order to allow the present but !online cpus to be onlined later with
>> full features (by making use of acpi_cpu_soft_notify()), set their
>> need_hotplug_init flag.
>>
>> Reported-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>
>> ---
>>
>> Daniel, this patch works for me. Does it work for you as well?
>>
>>  drivers/acpi/processor_driver.c |   16 +++++++++++-----
>>  1 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index 0734086..f29d30f 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -551,11 +551,6 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>>  		return 0;
>>  	}
>>  
>> -#ifdef CONFIG_SMP
>> -	if (pr->id >= setup_max_cpus && pr->id != 0)
>> -		return 0;
>> -#endif
>> -
>>  	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
>>  
>>  	/*
>> @@ -580,6 +575,17 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>>  		goto err_clear_processor;
>>  	}
>>  
>> +#ifdef CONFIG_SMP
>> +	if (pr->id >= setup_max_cpus && pr->id != 0) {
>> +		/*
>> +		 * Don't start cpus beyond maxcpus now. But allow them to
>> +		 * to be brought online later.
>> +		 */
>> +		pr->flags.need_hotplug_init = 1;
>> +		return 0;
>> +	}
>> +#endif
>> +
>>  	/*
>>  	 * Do not start hotplugged CPUs now, but when they
>>  	 * are onlined the first time
>>
>>
>>

