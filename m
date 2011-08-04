Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1HDPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:08:24 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:45807 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1HDPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:08:19 -0400
Message-ID: <4E3AB5E0.5080506@lwfinger.net>
Date: Thu, 04 Aug 2011 10:08:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regression in 3.0-git - bisected to commit dd4e5d3ac4a76b868daf30e35bd572def96c30ed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logs for a recent git pull from Linus's tree show the warning below. The 
problem has been bisected to commit dd4e5d3ac4a7 with the commit message of

===============
lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion

Commit:

1efc5da3cf56: [PATCH] order of lockdep off/on in vprintk() should be changed

explains the reason for having raw_local_irq_*() and lockdep_off()
in printk(). Instead of working around the broken recursion detection
of interrupt state tracking, fix it.
===============

I will be happy to supply any additi0onal logs and test patches.

Thanks,

Larry

==================================================


[   12.969190] ------------[ cut here ]------------
[   12.969305] WARNING: at kernel/lockdep.c:2532 
trace_hardirqs_on_caller+0x19b/0x1a0()
[   12.969499] Hardware name: HP Pavilion dv2700 Notebook PC
[   12.969593] Modules linked in: rtl8192se rtlwifi snd_hda_intel(+) mac80211 
snd_hda_codec amd74xx(+) cfg80211 ide_core snd_pcm joydev serio_raw snd_timer 
k8temp snd i2c_nforce2 hwmon soundcore sg forcedeth rfkill snd_page_alloc 
i2c_core wmi battery ac button ext3 jbd mbcache sd_mod ohci_hcd ahci libahci 
libata scsi_mod ehci_hcd usbcore fan processor thermal
[   12.970296] Pid: 2220, comm: work_for_cpu Not tainted 3.0.0-Linus+ #70
[   12.970406] Call Trace:
[   12.970453]  [<ffffffff810478ca>] warn_slowpath_common+0x7a/0xb0
[   12.970567]  [<ffffffffa02f5175>] ? __ide_wait_stat+0x105/0x160 [ide_core]
[   12.970712]  [<ffffffff81047915>] warn_slowpath_null+0x15/0x20
[   12.970855]  [<ffffffff81083f6b>] trace_hardirqs_on_caller+0x19b/0x1a0
[   12.970970]  [<ffffffff81083f7d>] trace_hardirqs_on+0xd/0x10
[   12.971070]  [<ffffffffa02f5175>] __ide_wait_stat+0x105/0x160 [ide_core]
[   12.971188]  [<ffffffffa02f5698>] ide_config_drive_speed+0xf8/0x3e0 [ide_core]
[   12.975510]  [<ffffffffa02fb3c5>] ide_set_pio_mode+0xa5/0xc0 [ide_core]
[   12.979956]  [<ffffffff81275129>] ? device_register+0x19/0x20
[   12.984383]  [<ffffffffa02fb480>] ide_set_pio+0xa0/0x1e0 [ide_core]
[   12.988965]  [<ffffffffa02f5434>] ? ide_check_nien_quirk_list+0x44/0x60 
[ide_core]
[   12.993630]  [<ffffffffa02f619a>] ide_port_tune_devices+0xaa/0xe0 [ide_core]
[   12.998084]  [<ffffffffa02f8064>] ide_host_register+0x3f4/0x780 [ide_core]
[   13.002903]  [<ffffffffa02fdaca>] ide_pci_init_two+0x56a/0x7f0 [ide_core]
[   13.007470]  [<ffffffff8107e04d>] ? trace_hardirqs_off+0xd/0x10
[   13.011874]  [<ffffffff8135ea37>] ? _raw_spin_unlock_irqrestore+0x67/0x70
[   13.016266]  [<ffffffff8104806f>] ? console_unlock+0x1ff/0x270
[   13.020860]  [<ffffffff81062ea0>] ? cwq_dec_nr_in_flight+0xa0/0xa0
[   13.020868]  [<ffffffffa02fdd61>] ide_pci_init_one+0x11/0x20 [ide_core]
[   13.020875]  [<ffffffffa03576c3>] amd74xx_probe+0x143/0x14a [amd74xx]
[   13.020879]  [<ffffffffa03573f0>] ? amd_set_pio_mode+0x20/0x20 [amd74xx]
[   13.020885]  [<ffffffff811eaca2>] local_pci_probe+0x12/0x20
[   13.020888]  [<ffffffff81062eb3>] do_work_for_cpu+0x13/0x30
[   13.020891]  [<ffffffff81062ea0>] ? cwq_dec_nr_in_flight+0xa0/0xa0
[   13.020895]  [<ffffffff8106acf6>] kthread+0x96/0xa0
[   13.020900]  [<ffffffff813616d4>] kernel_thread_helper+0x4/0x10
[   13.020904]  [<ffffffff8135eddd>] ? retint_restore_args+0xe/0xe
[   13.020907]  [<ffffffff8106ac60>] ? __init_kthread_worker+0x70/0x70
[   13.020910]  [<ffffffff813616d0>] ? gs_change+0xb/0xb
[   13.020913] ---[ end trace bda080baac8b219c ]---
