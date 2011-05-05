Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1EERrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:47:11 -0400
Received: from christianhoffmann.info ([88.175.101.52]:40111 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1EERrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:47:09 -0400
Message-ID: <4DC2E298.4090603@christianhoffmann.info>
Date: Thu, 05 May 2011 19:47:04 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info>  <1304470839.3037.12.camel@work-vm>  <4DC100D0.1030302@christianhoffmann.info> <1304558210.2943.24.camel@work-vm> <alpine.LFD.2.02.1105051025290.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105051025290.3005@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 10:25 AM, Thomas Gleixner wrote:
> On Wed, 4 May 2011, john stultz wrote:
>
>> On Wed, 2011-05-04 at 09:31 +0200, Christian Hoffmann wrote:
>>> In fact, switching to acpi_pm doesn't seem to work:
>>>
>>> $ dmesg | grep clock
>>>
>>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+
>>> root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
>>> [    0.000000] Kernel command line:
>>> BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+ root=/dev/mapper/vg-root ro
>>> quiet splash vt.handoff=7 clocksource=acpi_pm
>>> [    0.000000] hpet clockevent registered
>>> [    1.413835] Switching to clocksource hpet
>>> [    1.420762] Override clocksource acpi_pm is not HRT compatible.
>>> Cannot switch while in HRT/NOHZ mode
>>> [  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
>>> [  147.940147] Switching to clocksource tsc
>>
>> So I think I've sorted this out.
>>
>> The watchdog code is what enables CLOCK_SOURCE_VALID_FOR_HRES, but we
>> actually end up selecting the clocksource before we enqueue it into the
>> watchdog list, so that's why we see the warning.
>>
>> I suspect the following will resolve this detail.
>
> It does. Good catch!
>
>> Signed-off-by: John Stultz<johnstul@us.ibm.com>
>>
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index 6519cf6..0e17c10 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -685,8 +685,8 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
>>   	/* Add clocksource to the clcoksource list */
>>   	mutex_lock(&clocksource_mutex);
>>   	clocksource_enqueue(cs);
>> -	clocksource_select();
>>   	clocksource_enqueue_watchdog(cs);
>> +	clocksource_select();
>>   	mutex_unlock(&clocksource_mutex);
>>   	return 0;
>>   }
>> @@ -706,8 +706,8 @@ int clocksource_register(struct clocksource *cs)
>>
>>   	mutex_lock(&clocksource_mutex);
>>   	clocksource_enqueue(cs);
>> -	clocksource_select();
>>   	clocksource_enqueue_watchdog(cs);
>> +	clocksource_select();
>>   	mutex_unlock(&clocksource_mutex);
>>   	return 0;
>>   }
>>

I can now select clocksource=acpi_pm as kernel parameter. The boot still 
hangs after "MSI quirk detected...", but the timestamps in dmesg don't 
show the jump anymore.

[    1.426107] NET: Registered protocol family 1
[    1.426162] pci 0000:00:01.0: MSI quirk detected; subordinate MSI 
disabled
[    2.300212] pci 0000:01:05.0: Boot video device
[    2.300226] PCI: CLS 64 bytes, default 64


Full dmesg is here:
http://pastebin.com/raw.php?i=3Fctvsrp

Rgds,
Chris

