Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1DBJPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 05:15:55 -0400
Received: from toro.web-alm.net ([62.245.132.31]:48420 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1DBJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 05:15:54 -0400
Message-ID: <4D96E90D.9000905@osadl.org>
Date: Sat, 02 Apr 2011 11:14:53 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.33.8
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net>
In-Reply-To: <1301632555.4766.5.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

> [..]
>> Bisecting from 2.6.33.7 to 2.6.33.8 revealed:
>> 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c is the first bad commit
>> commit 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c
>> Author: H. Peter Anvin<hpa@linux.intel.com>
>> Date:   Fri Dec 10 23:57:04 2010 -0500
>>
>>       x86, hotplug: Use mwait to offline a processor, fix the legacy case
>>
>>       upstream ea53069231f9317062910d6e772cca4ce93de8c8
>>       x86, hotplug: Use mwait to offline a processor, fix the legacy case
>
> The question would appear to be does mainline beyond this point exhibit
> the same symptom?
Unfortunately, I could not immediately try to reproduce the situation on 
a more recent mainline kernel, since the box was freezing while enabling 
the various services on any kernel >= 2.6.35.

After applying a workaround for this problem which may or may not be 
related (https://lkml.org/lkml/2011/4/2/33), I was able to test more 
recent kernels up to 2.6.39-rc1; they all show the same behavior. 
Interestingly, the system only refuses to power down, if processor 
frequency scaling was selected. The problem persisted, even if frequency 
scaling was disabled by selecting userspace or performance 
scaling_governor before halting the system.

CPU info:
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz
stepping	: 2

This is the situation:

1. Without commit ea53069231f9317062910d6e772cca4ce93de8c8:
Everyting is fine. The system correctly powers off.

2. With commit ea53069231f9317062910d6e772cca4ce93de8c8:
    a) Frequency scaling never enabled (acpi_cpufreq not loaded,
       cpufreq_ondemand not loaded):
       Everything is fine. The system correctly powers off.
    b) Frequency scaling enabled (acpi_cpufreq loaded, cpufreq_ondemand
       loaded) or
    c) Frequency scaling enabled and disabled (acpi_cpufreq still loaded
       since it cannot be removed easily, cpufreq_ondemand no longer
       loaded) or
    d) Frequency scaling enabled and disabled (acpi_cpufreq unloaded
       with force, cpufreq_ondemand no longer loaded):
       Not powering off, message:
       ACPI: Preparing to enter system sleep state S5
       Disabling non-boot CPUs ...

In a next step, I will debug arch/x86/kernel/smpboot.c to find out why 
mwait_play_dead() returns when frequency scaling was not enabled and why 
it does not after it was enabled.

Thanks,
	-Carsten.
