Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2IMV7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:59:30 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:46560 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab2IMV72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:59:28 -0400
Message-ID: <50525719.5010701@blueyonder.co.uk>
Date: Thu, 13 Sep 2012 22:58:49 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        LKML Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD Bulldozer FX-8150 Powers off during kernel build
References: <50513733.8040801@blueyonder.co.uk> <20120913094413.GB15810@liondog.tnic>
In-Reply-To: <20120913094413.GB15810@liondog.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=beXUTUSmZ6sA:10 a=fP1BnWn3WWgA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=O56eIuB7fwl670rHgugA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# uname -r
3.6.0-rc5-u1-smp+

I built a new 3.6-rc5 kernel (3.6.0-rc5-u2) using 3.6.0-rc5-u1 with 8 
cores and power off didn't ocur.
slipstream:/usr/src/linux-3.6.0-rc5-u1 # grep POWER .config
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_IPMI_POWEROFF=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_TEST_POWER=m
CONFIG_POWER_AVS=y
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
# CONFIG_XZ_DEC_POWERPC is not set

When it was powering off "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y" was 
set.
slipstream:/usr/src/linux-3.6.0-rc5-u1 # grep PERFORMANCE .config
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y

slipstream:/usr/src/linux-3.6.0-rc5-u1 # grep MCE .config
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set

During the build temperature and power was around these values
-------------------------------------------------------------------------------------
fam15h_power-pci-00c4
Adapter: PCI adapter
power1:      133.30 W  (crit = 124.77 W)

k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +61.9캜  (high = +70.0캜)
                        (crit = +90.0캜, hyst = +87.0캜)

Immediately after the build the values are much lower than what it was 
with the kernel and config that caused the power off.
----------------------------------------
fam15h_power-pci-00c4
Adapter: PCI adapter
power1:       31.10 W  (crit = 124.77 W)

k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +33.2캜  (high = +70.0캜)
                        (crit = +90.0캜, hyst = +87.0캜)
------------------------------------------

If needed I can go back to the earlier 3.6.0-rc5 kernel and config to 
recreate the power off situation.
With the kernel that powered off, MCE was not set and 
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y

For the 3.6.0-rc5-u1 kernel only those 2 were changed.
Regards
Sid.

On 13/09/12 10:44, Borislav Petkov wrote:
> On Thu, Sep 13, 2012 at 02:30:27AM +0100, Sid Boyce wrote:
>> I have a huge heatsink and large CPU fan plus lots of cooling fans
>> in the case and nothing gets hot.
>> If I build e.g 3.6-rc5 with 8 or 6 cores, part way through it
>> suddenly powers off.
> Ok, can you catch the whole dmesg when you boot the machine _after_ the
> sudden poweroff? You can send it to me and Andreas (on CC) privately if
> you prefer.
>
> Important: make sure the kernel has CONFIG_X86_MCE and
> CONFIG_EDAC_DECODE_MCE built-in.
>
> Please make sure to use a recent kernel, i.e. 3.4, 3.5 is fine.
>
> Thanks.
>
> (Leaving in the rest for reference)
>
>> I have checked hwmon/k10temp.c to see if I could see where these
>> values were defined.
>>
>> k10temp.h is 0 bytes.
>> -rw-r--r-- 1 root root 0 Sep  9 01:59
>> /usr/src/linux-3.6.0-rc5/include/config/sensors/k10temp.h
>>
>> Currently I build with "make -j 1" and temperature and power values
>> are around those below.
>> # sensors
>> k10temp-pci-00c3
>> Adapter: PCI adapter
>> temp1:        +60.4째C  (high = +70.0째C)
>>                         (crit = +90.0째C, hyst = +87.0째C)
>>
>> fam15h_power-pci-00c4
>> Adapter: PCI adapter
>> power1:      127.49 W  (crit = 124.77 W)
>>
>> # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 21
>> model           : 1
>> model name      : AMD FX(tm)-8150 Eight-Core Processor
>> stepping        : 2
>> microcode       : 0x6000626
>> cpu MHz         : 3600.000
>> cache size      : 2048 KB
>>
>> from .config:-
>> # grep HWMON .config
>> CONFIG_IXGBE_HWMON=y
>> CONFIG_HWMON=y
>> CONFIG_HWMON_VID=m
>> # CONFIG_HWMON_DEBUG_CHIP is not set
>> CONFIG_THERMAL_HWMON=y
>>
>> # grep POWERSAVE .config
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
>> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
>> # CONFIG_PCIEASPM_POWERSAVE is not set
>> CONFIG_DEVFREQ_GOV_POWERSAVE=y
>>
>> On another 6-core box I can build kernels with "make -j 6" without problems.
>> # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 21
>> model           : 1
>> model name      : AMD FX(tm)-6100 Six-Core Processor
>> stepping        : 2
>> microcode       : 0x6000623
>> cpu MHz         : 3300.000
>> cache size      : 2048 KB
>>
>> With a kernel build going on six core box, temperature and power
>> hover around the values below.
>> sabre:~ # sensors
>> k10temp-pci-00c3
>> Adapter: PCI adapter
>> temp1:        +50.2째C  (high = +70.0째C)
>>                         (crit = +90.0째C, hyst = +87.0째C)
>>
>> fam15h_power-pci-00c4
>> Adapter: PCI adapter
>> power1:       94.40 W  (crit =  95.01 W)
>>
>> 73 ... Sid.
>>
>> -- 
>>


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

