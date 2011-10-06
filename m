Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab1JFSME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:12:04 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42148 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1JFSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:12:01 -0400
Message-ID: <4E8DEF62.20700@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 23:41:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        Tejun Heo <tj@kernel.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <20111002195023.GC31799@mtj.dyndns.org> <201110052226.58373.rjw@sisk.pl> <4E8CC8FA.2090100@linux.vnet.ibm.com> <201110060043.19583.rjw@sisk.pl> <4E8D4FC6.1080204@linux.vnet.ibm.com> <20111006083439.GA21575@aftab> <4E8DCDA6.8030802@linux.vnet.ibm.com>
In-Reply-To: <4E8DCDA6.8030802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 09:17 PM, Srivatsa S. Bhat wrote:
> On 10/06/2011 02:04 PM, Borislav Petkov wrote:
>> On Thu, Oct 06, 2011 at 02:50:46AM -0400, Srivatsa S. Bhat wrote:
>>> On 10/06/2011 04:13 AM, Rafael J. Wysocki wrote:
>>>> On Wednesday, October 05, 2011, Srivatsa S. Bhat wrote:
>>>>> On 10/06/2011 01:56 AM, Rafael J. Wysocki wrote:
>>>>>>
>>>>>> OK, can you please repost the patch with Borislav's Acked-by and Tested-by
>>>>>> and add some more Intel people to the CC list?
>>>>>>
>>>>>
>>>>> Sure, I'll do that. Thank you.
>>>>> But are we not going to consider a cleaner/correct solution such as the
>>>>> one proposed here:
>>>>> http://permalink.gmane.org/gmane.linux.kernel/1199494
>>>>>
>>>>> Well, honestly I don't mean to be stubborn, but somehow, knowing that
>>>>> there are issues with my patch doesn't make me feel very comfortable
>>>>> going with it, especially when there is another approach, which I
>>>>> believe can fix the issue properly, without undesirable side-effects.
>>>>>
>>>>> I agree that the issues are mostly some corner cases, so if you want a
>>>>> quick fix for now, I guess we can go with this patch and then later on
>>>>> follow-up with a proper solution to this whole problem.
>>>>
>>>> It ultimately is your call.  If you feel more comfortable with the
>>>> alternative, just post that one instead.
>>>>
>>> Cool! I am working on implementing that other solution. I'll post it as soon
>>> as I am done writing and testing that patch.
>>
>> Please test your other patch which removes the CPU_DEAD line from the
>> microcode CPU hotplug callback on an Intel box with microcode too and
>> submit it. This fix makes sense irrespective of a suspend/resume fix
>> because reloading the ucode when onlining the CPU is clearly unneeded.
>>
> 
> Ok, I tested both these scenarios on Intel boxes:
> 1. cpu hotplug stress test + pm_test in parallel
> 2. loading/unloading microcode etc. 
> They all work fine. I'll post that one-line patch with your Acked-by and Tested-by.
> Thank you very much.
> 

Well, unfortunately the following test case fails (not because of my patch, but rather
because my patch does not fix the root cause of the entire issue).

Wildly loading and unloading microcode driver and simultaneously running
pm_test(even at freezer level). "WARNING"s at drivers/base/firmware_class.c
appear similar to what we have seen before, just that the call stack is slightly
different. But we already know the precise reason why we hit this!

kernel: [  271.552553] microcode: CPU7 sig=0x206c2, pf=0x1, revision=0x13
kernel: [  271.552557] ------------[ cut here ]------------
kernel: [  271.552560] WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0x423/0x440()
kernel: [  271.552562] Hardware name: BladeCenter HS22V -[7871G2A]-
kernel: [  271.552563] Modules linked in: microcode(+) ipmi_devintf ipmi_si ipmi_msghandler ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod ioatdma tpm_tis serio_raw pcspkr sg tpm qla2xxx shpchp pci_hotplug i2c_i801 bnx2 dca scsi_transport_fc iTCO_wdt i2c_core iTCO_vendor_support mptctl scsi_tgt tpm_bios button uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon [last unloaded: microcode]
kernel: [  271.552590] Pid: 19050, comm: modprobe Tainted: G        W   3.1.0-rc8-mc-notifier-fix-0.7-default #2
kernel: [  271.552592] Call Trace:
firmware.sh[19229]: Cannot find  firmware file 'intel-ucode/06-2c-02'
kernel: [  271.552595]  [<ffffffff812a34e3>] ? _request_firmware+0x423/0x440
kernel: [  271.552598]  [<ffffffff8104cbda>] warn_slowpath_common+0x7a/0xb0
kernel: [  271.552601]  [<ffffffff8104cc25>] warn_slowpath_null+0x15/0x20
kernel: [  271.552604]  [<ffffffff812a34e3>] _request_firmware+0x423/0x440
kernel: [  271.552607]  [<ffffffff812a3591>] request_firmware+0x11/0x20
kernel: [  271.552612]  [<ffffffffa1aa2d1c>] request_microcode_fw+0x5c/0xd0 [microcode]
kernel: [  271.552617]  [<ffffffffa1aa2368>] microcode_init_cpu+0xc8/0x120 [microcode]
kernel: [  271.552622]  [<ffffffffa1aa242a>] mc_sysdev_add+0x6a/0xa0 [microcode]
kernel: [  271.552626]  [<ffffffff812954b6>] sysdev_driver_register+0xc6/0x160
firmware.sh[19234]: Cannot find  firmware file 'intel-ucode/06-2c-02'
kernel: [  271.552630]  [<ffffffffa1abf000>] ? 0xffffffffa1abefff
kernel: [  271.552634]  [<ffffffffa1abf094>] microcode_init+0x94/0x15c [microcode]
kernel: [  271.552637]  [<ffffffff810001ce>] do_one_initcall+0x3e/0x180
kernel: [  271.552640]  [<ffffffff810855f9>] sys_init_module+0x89/0x1e0
kernel: [  271.552643]  [<ffffffff813c1452>] system_call_fastpath+0x16/0x1b
kernel: [  271.552646] ---[ end trace 1cfc5940e70d5532 ]---
kernel: [  271.552648] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded


Since I had never tried this scenario before, I missed this one.
But at least we now know that cpu hotplugging was just *one* of the call paths
that could trigger this issue... and that my patch took care of only that call path alone
and didn't really fix the root cause.

Probably we should add synchronization between microcode and freezer, to prevent the
relevant microcode call paths and the freezer from running in parallel.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
