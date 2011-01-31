Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1AaOK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:10:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1AaOKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qQ9e8gPxgPniposLGP6qYMfmYf7JNCHgZVRuoIS/Q0uC2IPBgbysYbwRBG06ZQ4zkh
         ugNNDCpN8nbqtX5pf4+5gFBw1WXMgq5xpa5AuZP3HYrFomskJWUBJ2GuvQR+YEaEtvfk
         uNEyhoNLaw6o3Oq1GFt3E3XCMEH7yIsQgHF0c=
MIME-Version: 1.0
In-Reply-To: <1296469006.15234.359.camel@laptop>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	<1295894492.28776.470.camel@laptop>
	<AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	<1295946736.28776.479.camel@laptop>
	<AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	<1296210619.15234.263.camel@laptop>
	<AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
	<1296405366.2274.60.camel@twins>
	<AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
	<1296469006.15234.359.camel@laptop>
Date: Mon, 31 Jan 2011 09:10:23 -0500
Message-ID: <AANLkTikwPq+vJEGyOrbS3hbPk6ygsmC8cxGun9-KGA6a@mail.gmail.com>
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 5:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2011-01-30 at 22:26 -0500, Luming Yu wrote:
>
>> > Guessing is totally the wrong thing when you're sending stuff upstream,
>> > esp ugly patches such as this. .32 is more than a year old, anything
>> > could have happened.
>>
>> Ok. the default upstream kernel seems to have NMI watchdog disabled?
>
> Then enable it already, its a whole CONFIG option away..
>
>> It's not working because of NMI watchdog. If you ignore NMI watchdog,
>> then I guess it works but just slow..
>
> Don't guess, test it dammit. And then figure out why it triggers, I
> haven't seen _anything_ that would cause it to trigger, nor a sane
> explanation for your patch.

As what I suspected, it's reproduced with upstream git three (head is at 2.6.37)
after enabled soft LOCK UP detector kernel debug option.

 is now offline
Booting Node 3 Processor 59 APIC 0x75
NMI watchdog enabled, takes one hw-pmu counter.
CPU 59 is now offline
Booting Node 3 Processor 59 APIC 0x75
CPU59: Stuck ??
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 3
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 17, comm: migration/3 Not tainted 2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024562>] ? mtrr_work_handler+0x52/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8d5 ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 1
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 8, comm: migration/1 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024560>] ? mtrr_work_handler+0x50/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8d6 ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 63
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 304, comm: migration/63 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024562>] ? mtrr_work_handler+0x52/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8d7 ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 7
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 33, comm: migration/7 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024562>] ? mtrr_work_handler+0x52/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8d8 ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 39
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 183, comm: migration/39 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024562>] ? mtrr_work_handler+0x52/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8d9 ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 5
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 25, comm: migration/5 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024562>] ? mtrr_work_handler+0x52/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8da ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 37
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 175, comm: migration/37 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024564>] ? mtrr_work_handler+0x54/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8db ]---
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:227 watchdog_overflow_callback+0xe4/0x110()
Hardware name: QSSC-S4R
Watchdog detected hard LOCKUP on cpu 11
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ipv6 dm_mirror dm_region_hash dm_log pcspkr shpchp
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
edac_core sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last unloaded:
microcode]
Pid: 49, comm: migration/11 Tainted: G        W   2.6.37 #8
Call Trace:
 <NMI>  [<ffffffff810620af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810621a6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810c4cf4>] watchdog_overflow_callback+0xe4/0x110
 [<ffffffff810f6a2b>] __perf_event_overflow+0x8b/0x220
 [<ffffffff8101c763>] ? intel_pmu_save_and_restart+0x93/0xb0
 [<ffffffff810f7004>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e46a>] intel_pmu_handle_irq+0x25a/0x4d0
 [<ffffffff814ada16>] ? kprobe_exceptions_notify+0x16/0x4a0
 [<ffffffff814ac3b1>] ? hw_breakpoint_exceptions_notify+0x21/0x160
 [<ffffffff814ac548>] perf_event_nmi_handler+0x58/0xf0
 [<ffffffff814ae935>] notifier_call_chain+0x55/0x80
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff814ae99a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814ae9ce>] notify_die+0x2e/0x30
 [<ffffffff814abba3>] do_nmi+0x173/0x2b0
 [<ffffffff814ab460>] nmi+0x20/0x30
 [<ffffffff81024510>] ? mtrr_work_handler+0x0/0xd0
 [<ffffffff81024564>] ? mtrr_work_handler+0x54/0xd0
 <<EOE>>  [<ffffffff810b5ff2>] cpu_stopper_thread+0xf2/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b5f00>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff81083356>] kthread+0x96/0xa0
 [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
 [<ffffffff810832c0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
---[ end trace d2115ecb4672c8dc ]---
------------[ cut here ]------------


>
>> > Ok, so one IPI costs 50-100 us, even with 64 cpu, that's at most 6.4ms
>> > nowhere near enough to trigger the NMI watchdog. So what does go wrong?
>>
>> Good question!
>> But we also can't forget there were large latency from C3.
>
> Not 60+ seconds large I hope, I know NHM-EX has some suckage, but surely
> not that bad?

I guess the side effects of the large latency could have confused high
resolution timer code, which could have caused some reschedule ticks
lost. So we can't just directly multiply  those 100 or 200 us latency
with 64 to  calculate any suckage.

>
>> And I guess some reschedule ticks get lost to kick some CPUs out of
>> idle due to the side effects of the CPU PM feature. if use nohz=off,
>> everything seems to just work.
>> Yes, I agree we need to dig it out either.
>> But it's kind of combination problem between the special stop_machine
>> context and CPU power management...
>
> Yeah, so? Also, incidentally, stop-machine got a rewrite around .35 and
> again significant changes in .37, so please do test mainline and not
> your dinosaur.

With a .37 kernel, I've reproduced almost same problem as my .32-based kernel

>
>> > Yeah, what are you smoking? Why do you wreck perfectly fine code for one
>> > backward ass piece of hardware.
>>
>> Just make things less complex...
>
> But its wrong, it very clearly works around a real problem, don't ever
> do that, fix the problem!
>
My understanding is if the heart of the problem is triggered by some
hardware defects.
And we could have no other clean option than a solution I proposed
here. As long as the defects would not affect kernel hot path, I think
it should be fine to save some unnecessary complexity .

Yes, I agree before say yes to a "workaround", we need to understand
exactly what those side effects are. I will try to do research on all
side effects caused by the ipi and c3 latency to tickless and highres
kernel after one week vacation starting from Feb 1st.

--Luming
