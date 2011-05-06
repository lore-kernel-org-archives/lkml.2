Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1EFUYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:24:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16495 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1EFUYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:24:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=hdnkBhFG4RkpCZikTogZ6tOq4aBBY99oK+HHZtc8s9k72bjtGuTlqeDVrEuxWyS0Q
	aqVt6KoVPsFyAUz+W5wyw==
From: Mike Waychison <mikew@google.com>
To: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
        Matt_Domsch@dell.com
Cc: akpm@linux-foundation.org, matthew.e.tolentino@intel.com, gregkh@suse.de,
        Mike Waychison <mikew@google.com>
Subject: [PATCH v2] efivars: prevent oops on unload when efi is not enabled
Date: Fri,  6 May 2011 13:23:17 -0700
Message-Id: <1304713397-14321-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110506125702.2585228b.randy.dunlap@oracle.com>
References: <20110506125702.2585228b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

efivars_exit() should check for efi_enabled and not undo
allocations when efi is not enabled.  Otherwise there is an Oops
during module unload:

calling  efivars_init+0x0/0x1000 [efivars] @ 2810
EFI Variables Facility v0.08 2004-May-17
initcall efivars_init+0x0/0x1000 [efivars] returned 0 after 5120 usecs
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/module/firmware_class/initstate
CPU 1
Modules linked in: efivars(-) af_packet tun nfsd lockd nfs_acl auth_rpcgss sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep mousedev snd_seq joydev snd_seq_device mac_hid evdev snd_pcm usbkbd usbmouse usbhid snd_timer hid tg3 snd sr_mod pcspkr rtc_cmos soundcore cdrom iTCO_wdt processor sg dcdbas i2c_i801 rtc_core iTCO_vendor_support intel_agp snd_page_alloc thermal_sys rtc_lib intel_gtt 8250_pnp button hwmon unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore [last unloaded: dell_rbu]

Pid: 2812, comm: rmmod Not tainted 2.6.39-rc6 #1 Dell Inc.                 OptiPlex 745                 /0TY565
RIP: 0010:[<ffffffffa06a17f6>]  [<ffffffffa06a17f6>] unregister_efivars+0x28/0x12c [efivars]
RSP: 0018:ffff88005eedde98  EFLAGS: 00010283
RAX: ffffffffa06a23fc RBX: ffffffffa06a44c0 RCX: ffff88007c227a50
RDX: 0000000000000000 RSI: 00000055ac13db78 RDI: ffffffffa06a44c0
RBP: ffff88005eeddec8 R08: 0000000000000000 R09: ffff88005eeddd78
R10: ffffffffa06a4220 R11: ffff88005eeddd78 R12: fffffffffffff7d0
R13: 00007fff5a3aaec0 R14: 0000000000000000 R15: ffffffffa06a4508
FS:  00007fa8dcc4a6f0(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000005d148000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 2812, threadinfo ffff88005eedc000, task ffff88006754b000)
Stack:
 ffff88005eeddec8 ffffffffa06a4220 0000000000000000 00007fff5a3aaec0
 0000000000000000 0000000000000001 ffff88005eedded8 ffffffffa06a2418
 ffff88005eeddf78 ffffffff810d3598 ffffffffa06a4220 0000000000000880
Call Trace:
 [<ffffffffa06a2418>] efivars_exit+0x1c/0xc04 [efivars]
 [<ffffffff810d3598>] sys_delete_module+0x2d6/0x368
 [<ffffffff812d1db9>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff810fcba1>] ? audit_syscall_entry+0x172/0x1a5
 [<ffffffff81575082>] system_call_fastpath+0x16/0x1b
Code: 5c c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 4c 8b 67 48 48 89 fb 4c 8d 7f 48 49 81 ec 30 08 00 00 <4d> 8b ac 24 30 08 00 00 49 81 ed 30 08 00 00 eb 59 48 89 df 48
RIP  [<ffffffffa06a17f6>] unregister_efivars+0x28/0x12c [efivars]
 RSP <ffff88005eedde98>
CR2: 0000000000000000
 ---[ end trace aa99b99090f70baa ]---

Matt apparently removed such a check in 2004 (with no reason given):
 *  17 May 2004 - Matt Domsch <Matt_Domsch@dell.com>
 *   remove check for efi_enabled in exit
but there have been several changes since then.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: <matthew.e.tolentino@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
v2:
- Updated to conditionally unregister efivars for real EFI in the module
  unload itself -- mikew
---
 drivers/firmware/efivars.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff0c373..2ab7c0c 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -820,8 +820,10 @@ efivars_init(void)
 static void __exit
 efivars_exit(void)
 {
-	unregister_efivars(&__efivars);
-	kobject_put(efi_kobj);
+	if (efi_enable) {
+		unregister_efivars(&__efivars);
+		kobject_put(efi_kobj);
+	}
 }
 
 module_init(efivars_init);
-- 
1.7.3.1

