Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512Ab1JGQs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:48:28 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54575 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1JGQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:48:26 -0400
Message-ID: <4E8F2D51.9020207@linux.vnet.ibm.com>
Date: Fri, 07 Oct 2011 22:18:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <bp@alien8.de>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH RESEND] Freezer, CPU hotplug, x86 Microcode: Fix
 task freezing failures
References: <20111002195023.GC31799@mtj.dyndns.org> <201110052226.58373.rjw@sisk.pl> <4E8CC8FA.2090100@linux.vnet.ibm.com> <201110060043.19583.rjw@sisk.pl> <4E8D4FC6.1080204@linux.vnet.ibm.com> <20111006083439.GA21575@aftab> <4E8DCDA6.8030802@linux.vnet.ibm.com> <4E8E1125.4050701@linux.vnet.ibm.com> <20111006221334.GB7085@google.com> <20111006223438.GA27702@aftab>
In-Reply-To: <20111006223438.GA27702@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 04:04 AM, Borislav Petkov wrote:
> On Thu, Oct 06, 2011 at 06:13:34PM -0400, Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Oct 07, 2011 at 02:05:49AM +0530, Srivatsa S. Bhat wrote:
>> ...
>>> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
>>> index f924280..cd7ef2f 100644
>>> --- a/arch/x86/kernel/microcode_core.c
>>> +++ b/arch/x86/kernel/microcode_core.c
>>> @@ -483,7 +483,15 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>>>  		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>>>  		pr_debug("CPU%d removed\n", cpu);
>>>  		break;
>>> -	case CPU_DEAD:
>>> +
>>> +	/*
>>> +	 * Do not invalidate the microcode if a CPU goes offline,
>>> +	 * because it would be impossible to get the microcode again
>>> +	 * from userspace when the CPU comes back up, if the userspace
>>> +	 * happens to be frozen at that moment by the freezer subsystem,
>>> +	 * for example, due to a suspend operation in progress.
>>> +	 */
>>> +
>>
>> This still looks like a bandaid to me.  The exclusion approach didn't
>> pan out?
> 
> Well, this saves us the needless reloading of the ucode image when the
> CPU comes back online and is an annoyance fix and onlining path speedup
> in its own right. I, as you, thought that the exclusion approach should
> be the proper fix. Srivatsa?
> 

Boris, it is only now (after you explained) that I really understood why you
saw value in this patch (even though it was not the proper fix). So actually
this patch is just a good-to-have cpu hotplug optimization, but the real fix
would be the exclusion approach. More than that, this patch has got nothing
intentional to do with freezer, but its motivation is just to avoid doing
something needless in the cpu hotplug path. And an entirely different patch
(having the exclusion stuff) is needed to properly fix the problem we are
facing. This is what you mean right?

If so, then in a way we are trying to reposition why we need this patch. And
since we don't want to position this as a fix to this problem, I should
probably submit this patch with a different patch description and subject,
to explain the new usecase/motivation for this patch. Am I right?


By the way, even I believe that the exclusion approach is the best fix to the
problem. (I have been mulling about this in some of my previous mails as well).
At least we can see 3 call paths that get into trouble when racing with
freezer:
1. CPU hotplug.
2. Microcode module load/unload.
3. Reloading the microcode by controlling the sysfs file
/sys/devices/system/cpu/cpu*/microcode/reload. See below for log for this new
scenario.

At least this is what I got from looking at the microcode call paths that
involve a call to request_firmware.

I am still working on implementing the mutual exclusion at appropriate
places. However, since any of this would involve locking, with the
freezer/suspend involved as well (and especially since cpu hotplug is
used by the suspend code itself), I am trying to tread cautiously
(read: needing more time) to ensure that I don't introduce incorrect locking
scenarios and hence task freezing failures myself, while intending to fix it.


Log (warnings while reloading microcode by writing 1 to reload file in sysfs
while simultaneously running freezer):

[58247.407637] ------------[ cut here ]------------^M
[58247.407642] WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0x423/0x440()^M
[58247.407644] Hardware name: BladeCenter HS22V -[7871G2A]-^M
[58247.407646] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod sg qla2xxx tpm_tis ioatdma i2c_i801 shpchp serio_raw pcspkr iTCO_wdt i2c_core bnx2 pci_hotplug scsi_transport_fc tpm iTCO_vendor_support mptctl dca scsi_tgt tpm_bios button uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon^M [58247.407682] Pid: 16294, comm: reload_microcod Tainted: G        W   3.1.0-rc8-mc-notifier-fix-0.7-default #2^M
[58247.407685] Call Trace:^M
[58247.407689]  [<ffffffff812a34e3>] ? _request_firmware+0x423/0x440^M
[58247.407693]  [<ffffffff8104cbda>] warn_slowpath_common+0x7a/0xb0^M
[58247.407697]  [<ffffffff8104cc25>] warn_slowpath_null+0x15/0x20^M
[58247.407701]  [<ffffffff812a34e3>] _request_firmware+0x423/0x440^M
[58247.407705]  [<ffffffff812a3591>] request_firmware+0x11/0x20^M
[58247.407711]  [<ffffffffa01a0d1c>] request_microcode_fw+0x5c/0xd0 [microcode]^M
[58247.407716]  [<ffffffffa01a0250>] reload_store+0xc0/0x110 [microcode]^M
[58247.407722]  [<ffffffff81294fbb>] sysdev_store+0x1b/0x20^M
[58247.407726]  [<ffffffff81178222>] sysfs_write_file+0xc2/0x130^M
[58247.407731]  [<ffffffff8110fdab>] vfs_write+0xcb/0x180^M
[58247.407735]  [<ffffffff8110ff50>] sys_write+0x50/0x90^M
[58247.407739]  [<ffffffff813c1452>] system_call_fastpath+0x16/0x1b^M
[58247.407742] ---[ end trace 87b5d9a227b8fcf8 ]---^M
[58247.407744] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded^M

--
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
