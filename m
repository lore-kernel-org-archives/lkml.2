Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0GOCJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:09:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55592 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab0GOCJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:09:16 -0400
Message-ID: <4C3E6BF0.4040506@kernel.org>
Date: Wed, 14 Jul 2010 19:01:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>	 <4C3CF650.30905@kernel.org> <4C3E1FA0.9000107@kernel.org>	 <4C3E2AE6.30406@kernel.org>  <4C3E40EC.5060607@kernel.org> <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3E6CEA.015F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 05:03 PM, Suresh Siddha wrote:
> On Wed, 2010-07-14 at 15:57 -0700, Yinghai Lu wrote:
>> On 07/14/2010 02:23 PM, Yinghai Lu wrote:
>>> On 07/14/2010 01:35 PM, Yinghai Lu wrote:
>>>> On 07/13/2010 04:27 PM, Yinghai Lu wrote:
>>>>> On 07/13/2010 03:00 PM, H. Peter Anvin wrote:
>>>>>> On 07/12/2010 07:59 PM, Yinghai Lu wrote:
>>>>>>> tip/master: 
>>>>>>> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
>>>>>>>
>>>>>>> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
>>>>>>>
>>>>>>> linus' tree is ok.
>>>>>>>
>>>>>>> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
>>>>>>>
>>>>>>> the problem looks start in recent two or three weeks.
>>>>>>>
>>>>>>> Any idea?
>>>>>>>
>>>>>>> bisecting will take a while, because the system post take a while everytime.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>> Yinghai Lu
>>>>>>
>>>>>> OK, I found the bug... if you could test out the patch which will be
>>>>>> sent out shortly I would very much appreciate it.
>>>>>
>>>>> not sure if your patch is the offending one now.
>>>>>
>>>>> kL: kernel from linus tree
>>>>> kT1: kernel from tip
>>>>> kT2: kernel from tip with reverting your patch
>>>>>
>>>>> BIOS-->kL ---> kL ---> kL....always working
>>>>> BIOS-->kT1 ---> kT1 --->  kT1 : between second one and third one system reset instant...
>>>>> BIOS-->kT2 ---> kT2 --->  kT2 : between second one and third one system reset instant...
>>>>>
>>>>> BIOS-->kL ---> kL ---> kL ---> then kT1 ---> kT1 .... always working
>>>>> BIOS-->kL ---> kL ---> kL ---> then kT2 ---> kT2 .... always working
>>>>>
>>>>
>>>> bisecting said:
>>>>
>>>>> git bisect good
>>>> 58687acba59266735adb8ccd9b5b9aa2c7cd205b is the first bad commit
>>>> commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
>>>> Author: Don Zickus <dzickus@redhat.com>
>>>> Date:   Fri May 7 17:11:44 2010 -0400
>>>>
>>>>     lockup_detector: Combine nmi_watchdog and softlockup detector
>>>>     
>>>>     The new nmi_watchdog (which uses the perf event subsystem) is very
>>>>     similar in structure to the softlockup detector.  Using Ingo's
>>>>     suggestion, I combined the two functionalities into one file:
>>>>     kernel/watchdog.c.
>>>>     
>>>>     Now both the nmi_watchdog (or hardlockup detector) and softlockup
>>>>     detector sit on top of the perf event subsystem, which is run every
>>>>     60 seconds or so to see if there are any lockups.
>>>>     
>>>>     To detect hardlockups, cpus not responding to interrupts, I
>>>>     implemented an hrtimer that runs 5 times for every perf event
>>>>     overflow event.  If that stops counting on a cpu, then the cpu is
>>>>     most likely in trouble.
>>>>     
>>>>     To detect softlockups, tasks not yielding to the scheduler, I used the
>>>>     previous kthread idea that now gets kicked every time the hrtimer fires.
>>>>     If the kthread isn't being scheduled neither is anyone else and the
>>>>     warning is printed to the console.
>>>>     
>>>>     I tested this on x86_64 and both the softlockup and hardlockup paths
>>>>     work.
>>>>     
>>>
>>> with
>>> # CONFIG_LOCKUP_DETECTOR is not set
>>> # CONFIG_HARDLOCKUP_DETECTOR is not set
>>>
>>> kexec loop test could passed.
>>>
>>> also that patch will break x2apic preenabled system 's kexec/kdump.
>>
>> before the combining patch
>>
>> CONFIG_DETECT_SOFTLOCKUP=y
>> CONFIG_NMI_WATCHDOG=y
>>
>> will have the same problem.
>>
>> so the problem should come from NMI_WATCHDOG.
> 
> Yinghai, It looks like some timing issue wrt nmi handling/kexec and
> perhaps not directly related to x2apic? Perhaps we should try with
> x2apic disabled but with intr-remapping enabled etc to see if it changes
> anything.

only have "nox2apic", without "nointremap intel_iommu=off"
the kexec loop test work well.

So it is x2apic, nmi_watchdog related...

 Also do we know (like serial console log etc) how far ahead we
> went in the kexec before we rebooted?

will add more printk after "Starting new kernel" to check it.

Thanks

Yinghai
