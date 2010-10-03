Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0JCTvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:51:22 -0400
Received: from www.tglx.de ([62.245.132.106]:41876 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0JCTvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:51:20 -0400
Date: Sun, 3 Oct 2010 21:51:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>
Subject: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Message-ID: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mainline triggers a list corruption bug in
module_bug_finalize(). dmesg excerpt below.

The corresponding code says:

        /*
         * Strictly speaking this should have a spinlock to protect against
         * traversals, but since we only traverse on BUG()s, a spinlock
         * could potentially lead to deadlock and thus be counter-productive.
         */
        list_add(&mod->bug_list, &module_bug_list);

I can see the traversal problem vs. BUG(), but what's protecting the
list_add() ? BKL probably did, but is that true anymore ?

Thanks,
	tglx
---

initcall floppy_module_init+0x0/0xddb [floppy] returned 0 after 12247 usecs
calling  mb862xxfb_init+0x0/0x25 [mb862xxfb] @ 768
mb862xxfb 0000:05:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
mb862xxfb 0000:05:00.0: Fujitsu Carmine GDC Rev.3 found
initcall mb862xxfb_init+0x0/0x25 [mb862xxfb] returned 0 after 36925 usecs
calling  parport_default_proc_register+0x0/0x1b [parport] @ 800
initcall parport_default_proc_register+0x0/0x1b [parport] returned 0 after 6 usecs
calling  alsa_sound_init+0x0/0x96 [snd] @ 689
initcall alsa_sound_init+0x0/0x96 [snd] returned 0 after 20 usecs
calling  i82975x_init+0x0/0xa1 [i82975x_edac] @ 690
EDAC i82975x: ECC disabled on both channels.
initcall i82975x_init+0x0/0xa1 [i82975x_edac] returned 0 after 4060 usecs
calling  alsa_timer_init+0x0/0x17f [snd_timer] @ 689
initcall alsa_timer_init+0x0/0x17f [snd_timer] returned 0 after 45 usecs
calling  parport_pc_init+0x0/0x357 [parport_pc] @ 800
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
calling  cp_init+0x0/0x35 [8139cp] @ 766
8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:05:02.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 845
initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 6 usecs
initcall cp_init+0x0/0x35 [8139cp] returned 0 after 23729 usecs
initcall parport_pc_init+0x0/0x357 [parport_pc] returned 0 after 99365 usecs
calling  ppdev_init+0x0/0xd2 [ppdev] @ 847
ppdev: user-space parallel port driver
initcall ppdev_init+0x0/0xd2 [ppdev] returned 0 after 3744 usecs
calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 848
initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 5 usecs
calling  rtl8139_init_module+0x0/0x2e [8139too] @ 766
8139too: 8139too Fast Ethernet driver 0.9.28
8139too 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
8139too 0000:05:02.0: eth0: RealTek RTL8139 at 0xffffc900055dcc00, 00:50:fc:23:8e:aa, IRQ 18
initcall rtl8139_init_module+0x0/0x2e [8139too] returned 0 after 18257 usecs
calling  shpcd_init+0x0/0x68 [shpchp] @ 654
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x68 [shpchp] returned 0 after 94 usecs
udev: renamed network interface eth0 to eth2
calling  alsa_seq_init+0x0/0x4c [snd_seq] @ 848
initcall alsa_seq_init+0x0/0x4c [snd_seq] returned 0 after 56 usecs
------------[ cut here ]------------
calling  alsa_hwdep_init+0x0/0x69 [snd_hwdep] @ 856
initcall alsa_hwdep_init+0x0/0x69 [snd_hwdep] returned 0 after 5 usecs
WARNING: at /home/tglx/work/kernel/rt-new/linux-2.6-tip/lib/list_debug.c:26 __list_add+0x3f/0x83()
Hardware name:         
list_add corruption. next->prev should be prev (ffffffff81a4c260), but was ffffffffa02a1368. (next=ffffffffa028b5c8).
calling  e1000_init_module+0x0/0x43 [e1000e] @ 853
e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
e1000e 0000:04:00.0: Disabling ASPM  L1
e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:04:00.0: setting latency timer to 64
e1000e 0000:04:00.0: irq 42 for MSI/MSI-X
e1000e 0000:04:00.0: Disabling ASPM L0s 
Modules linked in: e1000e(+) snd_hwdep snd_seq shpchp 8139too snd_seq_device ppdev snd_pcm 8139cp parport_pc snd_timer i82975x_edac snd parport mii mb862xxfb mb862xxfb_accel floppy edac_core i2c_i801 serio_raw pcspkr microcode soundcore iTCO_wdt snd_page_alloc iTCO_vendor_support raid0 raid1 firewire_ohci firewire_core sata_sil crc_itu_t radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 689, comm: modprobe Not tainted 2.6.36-rc5+ #80
e1000e 0000:04:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:ab:5f:54
e1000e 0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:04:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
initcall e1000_init_module+0x0/0x43 [e1000e] returned 0 after 82625 usecs
Call Trace:
 [<ffffffff81048c95>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81048d50>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff811fac30>] __list_add+0x3f/0x83
 [<ffffffff811ecf0b>] module_bug_finalize+0xb9/0xca
 [<ffffffff810276f5>] module_finalize+0x156/0x165
 [<ffffffff81079b65>] load_module+0xf75/0x177a
 [<ffffffff8107a3b4>] sys_init_module+0x4a/0x1e2
 [<ffffffff81009cd2>] system_call_fastpath+0x16/0x1b
---[ end trace c97cbc43385366a8 ]---
------------[ cut here ]------------
WARNING: at /home/tglx/work/kernel/rt-new/linux-2.6-tip/lib/list_debug.c:30 __list_add+0x68/0x83()
Hardware name:         
list_add corruption. prev->next should be next (ffffffffa028b5c8), but was ffffffffa02c9068. (prev=ffffffff81a4c260).
Modules linked in: e1000e snd_hwdep snd_seq shpchp 8139too snd_seq_device ppdev snd_pcm 8139cp parport_pc snd_timer i82975x_edac snd parport mii mb862xxfb mb862xxfb_accel floppy edac_core i2c_i801 serio_raw pcspkr microcode soundcore iTCO_wdt snd_page_alloc iTCO_vendor_support raid0 raid1 firewire_ohci firewire_core sata_sil crc_itu_t radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 689, comm: modprobe Tainted: G        W   2.6.36-rc5+ #80
Call Trace:
 [<ffffffff81048c95>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81048d50>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff811fac59>] __list_add+0x68/0x83
 [<ffffffff811ecf0b>] module_bug_finalize+0xb9/0xca
 [<ffffffff810276f5>] module_finalize+0x156/0x165
 [<ffffffff81079b65>] load_module+0xf75/0x177a
 [<ffffffff8107a3b4>] sys_init_module+0x4a/0x1e2
 [<ffffffff81009cd2>] system_call_fastpath+0x16/0x1b
---[ end trace c97cbc43385366a9 ]---
udev: renamed network interface eth0 to eth1
calling  alsa_card_azx_init+0x0/0x20 [snd_hda_intel] @ 689
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
md: bind<sdb6>
md: bind<sda6>
