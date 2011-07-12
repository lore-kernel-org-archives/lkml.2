Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1GLIEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:04:16 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:58538 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1GLIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:03:54 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH 0/3] ACPI / Battery: fix NULL pointer dereference from battery
Date: Tue, 12 Jul 2011 09:03:26 +0100
Message-Id: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following oops happens non-deterministically when resuming from suspend on
a recent Acer Aspire laptop.  The issue seems to be unregistering a led trigger
that was never registered.  The led_trigger->next_trig list_head fields contain
zeroes, hence the NULL pointer dereference in list_del().

Due to the non-deterministic nature of the bug I am not sure whether the
patches eliminate the oops.  However, the patches do address real problems in
drivers/acpi/battery.c.

There is a lack of error handling in battery.c so when power_supply_register()
fails the power_supply will continue be used as if there was no error.  The
reason for this is that power_supply_register() leaves a stale
power_supply->dev pointer set when it returns an error and battery.c simply
uses that field to decide whether the power_supply is registered or not.  This
is fixed in the first patch.

The second and third patches clean up the error handling in acpi_battery_add()
to prevent a use-after-free and properly release resources.

Here is the oops from a Debian 2.6.39-2-amd64 kernel.  linux-2.6/master
contains no relevant fixes AFAICT.  Any thoughts on what is going on here
appreciated:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008 IP: [<ffffffff81263f1a>] led_trigger_unregister+0x36/0xb4
PGD 1b3d13067 PUD 118545067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/virtual/vc/vcsa63/uevent
CPU 0 
Modules linked in: parport_pc ppdev lp parport rfcomm bnep bluetooth crc16 acpi_cpufreq mperf cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave uinput fuse ext2 loop snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 ecb ath9k snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm ath9k_common ath9k_hw snd_seq snd_timer i915 ath snd_seq_device snd uvcvideo videodev drm_kms_helper soundcore cfg80211 drm snd_page_alloc ac sparse_keymap media wmi battery rfkill v4l2_compat_ioctl32 intel_ips pcspkr evdev i2c_i801 power_supply i2c_algo_bit i2c_core psmouse video processor button serio_raw ext3 jbd mbcache sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sd_mod crc_t10dif ahci libahci libata scsi_mod ehci_hcd usbcore atl1c thermal thermal_sys [last unloaded: scsi_wait_scan]

Pid: 29129, comm: pm-suspend Not tainted 2.6.39-2-amd64 #1 Acer Aspire 3820/JM31_CP
RIP: 0010:[<ffffffff81263f1a>]  [<ffffffff81263f1a>] led_trigger_unregister+0x36/0xb4
RSP: 0018:ffff8801187fbd68  EFLAGS: 00010246
RAX: 0000000000000000 RBX: dead000000200200 RCX: 0000000000000004
RDX: 0000000000000000 RSI: dead000000100100 RDI: ffffffff8164ede0
     ^                     ^
rdx gets dereferenced      LIST_POISON constants (haven't been used yet)

RBP: ffff8801b321aec0 R08: 0000000000000200 R09: ffffffff81683390
R10: ffff880100000010 R11: ffff8801b0e3f800 R12: 00000000ffffffff
R13: ffff8801b3d93378 R14: 0000000000000003 R15: ffffffffffffffff
FS:  00007f83b6797700(0000) GS:ffff8801bbc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 00000001b21cc000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pm-suspend (pid: 29129, threadinfo ffff8801187fa000, task ffff8801b2880e40)
Stack:
 ffff8801b321aec0 0000000000000004 00000000ffffffff ffffffff81263fa6
 ffff8801b0e3f820 ffffffffa01716b2 ffff8801b0e3f820 ffffffffa0171035
 ffff8801b0e3f800 ffffffffa018628f ffff8801b0e3f800 ffffffffa01863ae
Call Trace:
 [<ffffffff81263fa6>] ? led_trigger_unregister_simple+0xe/0x17
 [<ffffffffa01716b2>] ? power_supply_remove_triggers+0x16/0x80 [power_supply]
 [<ffffffffa0171035>] ? power_supply_unregister+0x15/0x1f [power_supply]
 [<ffffffffa018628f>] ? sysfs_remove_battery+0x25/0x32 [battery]
 [<ffffffffa01863ae>] ? battery_notify+0x16/0x22 [battery]
 [<ffffffff81335b48>] ? notifier_call_chain+0x2e/0x5b
 [<ffffffff810634ab>] ? __blocking_notifier_call_chain+0x4c/0x63
 [<ffffffff81076439>] ? pm_notifier_call_chain+0x15/0x2a
 [<ffffffff81076ca0>] ? enter_state+0x10c/0x12b
 [<ffffffff8107638e>] ? state_store+0xb1/0xce
 [<ffffffff8114ed16>] ? sysfs_write_file+0xe0/0x11c
 [<ffffffff810fbfe8>] ? vfs_write+0xa4/0xff
 [<ffffffff810fc0f9>] ? sys_write+0x45/0x6e
 [<ffffffff81338dd2>] ? system_call_fastpath+0x16/0x1b
Code: 64 81 53 48 bb 00 02 20 00 00 00 ad de e8 fc e2 0c 00 48 8b 55 30 48 8b 45 38 48 be 00 01 10 00 00 00 ad de 48 c7 c7 e0 ed 64 81 
 89 42 08 48 89 10 48 89 75 30 48 89 5d 38 e8 60 ec df ff 48 
RIP  [<ffffffff81263f1a>] led_trigger_unregister+0x36/0xb4
 RSP <ffff8801187fbd68>
CR2: 0000000000000008
---[ end trace 099c095de50533f3 ]---

Disassembly of led_trigger_unregister:
ffffffff81263ee4 <led_trigger_unregister>:
ffffffff81263ee4:       41 54                   push   %r12
ffffffff81263ee6:       55                      push   %rbp
ffffffff81263ee7:       48 89 fd                mov    %rdi,%rbp
ffffffff81263eea:       48 c7 c7 e0 ed 64 81    mov    $0xffffffff8164ede0,%rdi
ffffffff81263ef1:       53                      push   %rbx
ffffffff81263ef2:       48 bb 00 02 20 00 00    movabs $0xdead000000200200,%rbx
ffffffff81263ef9:       00 ad de 
ffffffff81263efc:       e8 fc e2 0c 00          callq  ffffffff813321fd <down_write>
ffffffff81263f01:       48 8b 55 30             mov    0x30(%rbp),%rdx
ffffffff81263f05:       48 8b 45 38             mov    0x38(%rbp),%rax
ffffffff81263f09:       48 be 00 01 10 00 00    movabs $0xdead000000100100,%rsi
ffffffff81263f10:       00 ad de 
ffffffff81263f13:       48 c7 c7 e0 ed 64 81    mov    $0xffffffff8164ede0,%rdi
ffffffff81263f1a:       48 89 42 08             mov    %rax,0x8(%rdx)
                                                ^--- boom!

Stefan Hajnoczi (3):
  power_supply: scrub device pointer if registration fails
  ACPI / Battery: avoid acpi_battery_add() use-after-free
  ACPI / Battery: propagate sysfs error in acpi_battery_add()

 drivers/acpi/battery.c            |   29 ++++++++++++++++++++---------
 drivers/power/power_supply_core.c |    1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

-- 
1.7.5.4

