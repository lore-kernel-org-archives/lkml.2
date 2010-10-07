Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0JGUiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:38:22 -0400
Received: from www.tglx.de ([62.245.132.106]:60836 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0JGUiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:38:21 -0400
Date: Thu, 7 Oct 2010 22:38:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Airlie <airlied@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
In-Reply-To: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Dave Airlie wrote:

> We are seeing this on both intel and radeon drivers when we reload the
> module with 2.6.36-rc7 or so, and we get no irqs for that device.
> 
> you can reproduce by
> 
> init 3
> echo 0 > /sys/class/vtconsole/vtcon1/bind
> rmmod i915
> modprobe i915
> 
> or radeon.
> 
> It seems to be possibly MSI related.

Yeah, can reproduce. Digging into it. I just discovered a even worse
thing. I wanted to know whether it recovers when I rmmod/modprobe the
module again, which resulted in:



Oct  7 22:24:19 ionos kernel: Console: switching to colour VGA+ 80x25
Oct  7 22:24:22 ionos kernel: drm: unregistered panic notifier
Oct  7 22:24:22 ionos kernel: vga_switcheroo: disabled
Oct  7 22:24:22 ionos kernel: BUG: sleeping function called from invalid context at /home/tglx/work/kernel/git/linux-2.6/arch/x86/mm/fault.c:1074
Oct  7 22:24:22 ionos kernel: in_atomic(): 0, irqs_disabled(): 1, pid: 2681, name: udevd
Oct  7 22:24:22 ionos kernel: Pid: 2681, comm: udevd Not tainted 2.6.36-rc7 #4
Oct  7 22:24:22 ionos kernel: Call Trace:
Oct  7 22:24:22 ionos kernel: [<ffffffff8103d3d1>] __might_sleep+0xed/0xef
Oct  7 22:24:22 ionos kernel: [<ffffffff81452d81>] do_page_fault+0x1b2/0x2bb
Oct  7 22:24:22 ionos kernel: [<ffffffff8144ff55>] page_fault+0x25/0x30
Oct  7 22:24:22 ionos kernel: [<ffffffff8106af14>] ? lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: [<ffffffff8106af5e>] hrtimer_get_remaining+0x1c/0x46
Oct  7 22:24:22 ionos kernel: [<ffffffff8105119d>] itimer_get_remtime+0x16/0x3c

That means that the hrtimer in the shared signal handler is corrupted. Uurg.

Oct  7 22:24:22 ionos kernel: [<ffffffff8106d127>] ? abort_creds+0x1a/0x1c
Oct  7 22:24:22 ionos kernel: [<ffffffff81051445>] do_setitimer+0x97/0x1e7
Oct  7 22:24:22 ionos kernel: [<ffffffff81051674>] alarm_setitimer+0x3a/0x60
Oct  7 22:24:22 ionos kernel: [<ffffffff8105a248>] sys_alarm+0xe/0x12
Oct  7 22:24:22 ionos kernel: [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Oct  7 22:24:22 ionos kernel: BUG: unable to handle kernel paging request at 00000000934a2400

Something is fishy here. That's not a kernel address

Oct  7 22:24:22 ionos kernel: IP: [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: PGD 716e6067 PUD 0 
Oct  7 22:24:22 ionos kernel: Oops: 0000 [#1] SMP 
Oct  7 22:24:22 ionos kernel: last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/bind
Oct  7 22:24:22 ionos kernel: CPU 2 
Oct  7 22:24:22 ionos kernel: Modules linked in: i915(-) fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb iwlagn snd_hda_codec_intelhdmi snd_hda_codec_conexant iwlcore snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_seq snd_seq_device snd_pcm thinkpad_acpi snd_timer uvcvideo snd videodev sdhci_pci cfg80211 sdhci v4l1_compat soundcore snd_page_alloc v4l2_compat_ioctl32 mmc_core wmi microcode rfkill pcspkr joydev e1000e i2c_i801 shpchp iTCO_wdt iTCO_vendor_support firewire_ohci firewire_core crc_itu_t drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: i915]
Oct  7 22:24:22 ionos kernel:
Oct  7 22:24:22 ionos kernel: Pid: 2681, comm: udevd Not tainted 2.6.36-rc7 #4 25222AU/25222AU
Oct  7 22:24:22 ionos kernel: RIP: 0010:[<ffffffff8106af14>]  [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: RSP: 0018:ffff8800573a7e58  EFLAGS: 00010006
Oct  7 22:24:22 ionos kernel: RAX: 00000000000006a4 RBX: 00000000934a2400 RCX: 0000000000000060
Oct  7 22:24:22 ionos kernel: RDX: 00000000000006a4 RSI: ffff8800573a7e90 RDI: ffff880037bffc70
Oct  7 22:24:22 ionos kernel: RBP: ffff8800573a7e78 R08: 0000000000000068 R09: 0101010101010101
Oct  7 22:24:22 ionos kernel: R10: 0000000000000060 R11: 0000000000000202 R12: ffff880037bffc70
Oct  7 22:24:22 ionos kernel: R13: ffff8800573a7e90 R14: ffff8800573a7f28 R15: 0000000000a97c20
Oct  7 22:24:22 ionos kernel: FS:  00007ff08870c7a0(0000) GS:ffff880002500000(0000) knlGS:0000000000000000
Oct  7 22:24:22 ionos kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  7 22:24:22 ionos kernel: CR2: 000000313a047256 CR3: 00000000716e7000 CR4: 00000000000006e0
Oct  7 22:24:22 ionos kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  7 22:24:22 ionos kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  7 22:24:22 ionos kernel: Process udevd (pid: 2681, threadinfo ffff8800573a6000, task ffff880059238000)
Oct  7 22:24:22 ionos kernel: Stack:
Oct  7 22:24:22 ionos kernel: ffff88003798e180 ffff880037bffc70 ffff880059238000 ffff880037bffc70
Oct  7 22:24:22 ionos kernel: <0> ffff8800573a7ea8 ffffffff8106af5e ffff8800573a7e98 00000000810a069d
Oct  7 22:24:22 ionos kernel: <0> ffff880037bffc70 ffff880059238000 ffff8800573a7ee8 ffffffff8105119d
Oct  7 22:24:22 ionos kernel: Call Trace:
Oct  7 22:24:22 ionos kernel: [<ffffffff8106af5e>] hrtimer_get_remaining+0x1c/0x46
Oct  7 22:24:22 ionos kernel: [<ffffffff8105119d>] itimer_get_remtime+0x16/0x3c
Oct  7 22:24:22 ionos kernel: [<ffffffff8106d127>] ? abort_creds+0x1a/0x1c
Oct  7 22:24:22 ionos kernel: [<ffffffff81051445>] do_setitimer+0x97/0x1e7
Oct  7 22:24:22 ionos kernel: [<ffffffff81051674>] alarm_setitimer+0x3a/0x60
Oct  7 22:24:22 ionos kernel: [<ffffffff8105a248>] sys_alarm+0xe/0x12
Oct  7 22:24:22 ionos kernel: [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Oct  7 22:24:22 ionos kernel: Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 49 89 fc 49 89 f5 49 8b 5c 24 30 48 85 db 74 2a <48> 8b 3b e8 bf 47 3e 00 49 89 45 00 49 3b 5c 24 30 75 0c 41 59 
Oct  7 22:24:22 ionos kernel: RIP  [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: RSP <ffff8800573a7e58>
Oct  7 22:24:22 ionos kernel: CR2: 00000000934a2400
Oct  7 22:24:22 ionos kernel: ---[ end trace 9b1fb5b66b44ba63 ]---
Oct  7 22:24:22 ionos kernel: BUG: unable to handle kernel paging request at 00000000934a2400
Oct  7 22:24:22 ionos kernel: IP: [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: PGD 716e6067 PUD 0 
Oct  7 22:24:22 ionos kernel: Oops: 0000 [#2] SMP 
Oct  7 22:24:22 ionos kernel: last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/bind
Oct  7 22:24:22 ionos kernel: CPU 2 
Oct  7 22:24:22 ionos kernel: Modules linked in: i915(-) fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb iwlagn snd_hda_codec_intelhdmi snd_hda_codec_conexant iwlcore snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_seq snd_seq_device snd_pcm thinkpad_acpi snd_timer uvcvideo snd videodev sdhci_pci cfg80211 sdhci v4l1_compat soundcore snd_page_alloc v4l2_compat_ioctl32 mmc_core wmi microcode rfkill pcspkr joydev e1000e i2c_i801 shpchp iTCO_wdt iTCO_vendor_support firewire_ohci firewire_core crc_itu_t drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: i915]
Oct  7 22:24:22 ionos kernel:
Oct  7 22:24:22 ionos kernel: Pid: 2681, comm: udevd Tainted: G      D     2.6.36-rc7 #4 25222AU/25222AU
Oct  7 22:24:22 ionos kernel: RIP: 0010:[<ffffffff8106af14>]  [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: RSP: 0018:ffff8800573a7b48  EFLAGS: 00010206
Oct  7 22:24:22 ionos kernel: RAX: ffff880037bffc00 RBX: 00000000934a2400 RCX: 00000000000003e8
Oct  7 22:24:22 ionos kernel: RDX: 0000000000000001 RSI: ffff8800573a7b90 RDI: ffff880037bffc70
Oct  7 22:24:22 ionos kernel: RBP: ffff8800573a7b68 R08: 0000000000000000 R09: ffff880076c08000
Oct  7 22:24:22 ionos kernel: R10: ffff880076c08000 R11: 0000000000000020 R12: ffff880037bffc70
Oct  7 22:24:22 ionos kernel: R13: ffff8800573a7b90 R14: 0000000000000000 R15: 0000000000000001
Oct  7 22:24:22 ionos kernel: FS:  00007ff08870c7a0(0000) GS:ffff880002500000(0000) knlGS:0000000000000000
Oct  7 22:24:22 ionos kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  7 22:24:22 ionos kernel: CR2: 00000000934a2400 CR3: 00000000716e7000 CR4: 00000000000006e0
Oct  7 22:24:22 ionos kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  7 22:24:22 ionos kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  7 22:24:22 ionos kernel: Process udevd (pid: 2681, threadinfo ffff8800573a6000, task ffff880059238000)
Oct  7 22:24:22 ionos kernel: Stack:
Oct  7 22:24:22 ionos kernel: ffff8800573a7b78 ffff880037bffc70 0000000000000009 0000000000000009
Oct  7 22:24:22 ionos kernel: <0> ffff8800573a7ba8 ffffffff8106afa2 ffff8800573a7c18 0000000000000046
Oct  7 22:24:22 ionos kernel: <0> ffff8800573a7bc8 0000000000000282 0000000000000000 ffff880037bffc70
Oct  7 22:24:22 ionos kernel: Call Trace:
Oct  7 22:24:22 ionos kernel: [<ffffffff8106afa2>] hrtimer_try_to_cancel+0x1a/0x4b
Oct  7 22:24:22 ionos kernel: [<ffffffff8106afec>] hrtimer_cancel+0x19/0x25
Oct  7 22:24:22 ionos kernel: [<ffffffff81050ac2>] do_exit+0x181/0x726
Oct  7 22:24:22 ionos kernel: [<ffffffff8104dfae>] ? kmsg_dump+0x12b/0x145
Oct  7 22:24:22 ionos kernel: [<ffffffff81450b16>] oops_end+0xbf/0xc7
Oct  7 22:24:22 ionos kernel: [<ffffffff81031e6b>] no_context+0x1fc/0x20b
Oct  7 22:24:22 ionos kernel: [<ffffffff81032004>] __bad_area_nosemaphore+0x18a/0x1ad
Oct  7 22:24:22 ionos kernel: [<ffffffff81032083>] bad_area+0x47/0x4e
Oct  7 22:24:22 ionos kernel: [<ffffffff81452dda>] do_page_fault+0x20b/0x2bb
Oct  7 22:24:22 ionos kernel: [<ffffffff8144ff55>] page_fault+0x25/0x30
Oct  7 22:24:22 ionos kernel: [<ffffffff8106af14>] ? lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: [<ffffffff8106af5e>] hrtimer_get_remaining+0x1c/0x46
Oct  7 22:24:22 ionos kernel: [<ffffffff8105119d>] itimer_get_remtime+0x16/0x3c
Oct  7 22:24:22 ionos kernel: [<ffffffff8106d127>] ? abort_creds+0x1a/0x1c
Oct  7 22:24:22 ionos kernel: [<ffffffff81051445>] do_setitimer+0x97/0x1e7
Oct  7 22:24:22 ionos kernel: [<ffffffff81051674>] alarm_setitimer+0x3a/0x60
Oct  7 22:24:22 ionos kernel: [<ffffffff8105a248>] sys_alarm+0xe/0x12
Oct  7 22:24:22 ionos kernel: [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Oct  7 22:24:22 ionos kernel: Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 49 89 fc 49 89 f5 49 8b 5c 24 30 48 85 db 74 2a <48> 8b 3b e8 bf 47 3e 00 49 89 45 00 49 3b 5c 24 30 75 0c 41 59 
Oct  7 22:24:22 ionos kernel: RIP  [<ffffffff8106af14>] lock_hrtimer_base+0x22/0x50
Oct  7 22:24:22 ionos kernel: RSP <ffff8800573a7b48>
Oct  7 22:24:22 ionos kernel: CR2: 00000000934a2400
Oct  7 22:24:22 ionos kernel: ---[ end trace 9b1fb5b66b44ba64 ]---
Oct  7 22:24:22 ionos kernel: Fixing recursive fault but reboot is needed!
Oct  7 22:24:22 ionos kernel: [drm] Module unloaded
