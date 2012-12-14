Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2LNLDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:03:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52604 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2LNLDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:03:16 -0500
Subject: [PATCH 12/12] edac: fix kernel panic on module unloading
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, Borislav Petkov <bp@alien8.de>
Date: Fri, 14 Dec 2012 15:03:10 +0400
Message-ID: <20121214110310.11019.21098.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes use-after-free and double-free bugs in edac_mc_sysfs_exit().
mci_pdev has single reference and put_device() calls mc_attr_release() which
calls kfree(), thus following device_del() works with already released memory.
An another kfree() in edac_mc_sysfs_exit() releses the same memory again. Great.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>

---

[    2.707667] general protection fault: 0000 [#1] SMP
[    2.707809] Modules linked in: sctp rfcomm bnep bluetooth fuse nfsd exportfs parport_pc parport powernow_k8 i2c_nforce2 pcspkr k8temp evbug edac_cor
e(-) kvm_amd kvm btrfs zlib_deflate libcrc32c ide_pci_generic ide_core ata_generic pata_acpi sata_nv [last unloaded: leds_pca9532]
[    2.708369] CPU 0
[    2.708369] Pid: 15179, comm: rmmod Tainted: P             3.7.0-rc8-next-20121211+ #595 Gigabyte Technology Co., Ltd. M52S-S3P/M52S-S3P
[    2.708369] RIP: 0010:[<ffffffff812e58e6>]  [<ffffffff812e58e6>] __list_add+0x26/0xd0
[    2.708369] RSP: 0018:ffff88007a609da8  EFLAGS: 00010046
[    2.708369] RAX: ffff880079883570 RBX: ffff88007a609df8 RCX: 0000000000000000
[    2.708369] RDX: ffff880079883570 RSI: 6b6b6b6b6b6b6b6b RDI: ffff88007a609df8
[    2.708369] RBP: ffff88007a609dc8 R08: 6b6b6b6b6b6b6b6b R09: 0000000000000000
[    2.708369] R10: ffff8800798934b0 R11: 0000000000000000 R12: ffff880079883570
[    2.708369] R13: 6b6b6b6b6b6b6b6b R14: 00007fc92d0d1090 R15: ffff880079883530
[    2.708369] FS:  00007fc92b533700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    2.708369] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.708369] CR2: 00007f1da5d61000 CR3: 000000007b28e000 CR4: 00000000000007f0
[    2.708369] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.708369] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.708369] Process rmmod (pid: 15179, threadinfo ffff88007a608000, task ffff8800798934b0)
[    2.710227] Stack:
[    2.710227]  0000000000000000 ffff880079883538 0000000000000246 ffff8800798934b0
[    2.710227]  ffff88007a609e48 ffffffff817f711b ffffffff8141fde1 ffffffff8141e180
[    2.710227]  ffff880079883570 ffffffff812d2e3b ffff88007a609df8 ffff88007a609df8
[    2.710227] Call Trace:
[    2.710227]  [<ffffffff817f711b>] mutex_lock_nested+0xfb/0x320
[    2.710227]  [<ffffffff8141fde1>] ? device_release_driver+0x21/0x40
[    2.710227]  [<ffffffff8141e180>] ? bus_get_device_klist+0x10/0x10
[    2.710227]  [<ffffffff812d2e3b>] ? kobject_put+0x2b/0x60
[    2.710227]  [<ffffffff8141fde1>] device_release_driver+0x21/0x40
[    2.710227]  [<ffffffff8141f621>] bus_remove_device+0xf1/0x140
[    2.710227]  [<ffffffff8141cdd7>] device_del+0x127/0x1b0
[    2.710227]  [<ffffffffa0276794>] edac_mc_sysfs_exit+0x1c/0x2f [edac_core]
[    2.710227]  [<ffffffffa02767d8>] edac_exit+0x31/0x33 [edac_core]
[    2.710227]  [<ffffffff810a0ce3>] sys_delete_module+0x163/0x280
[    2.710227]  [<ffffffff812ddc34>] ? lockdep_sys_exit_thunk+0x35/0x67
[    2.710227]  [<ffffffff812ddbbe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.710227]  [<ffffffff81801a12>] system_call_fastpath+0x16/0x1b
[    2.710227] Code: 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 4c 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 <4d> 8b 45 00 4d 39 c4 75 6f 4c 39 e3 74 45 4c 39 eb 74 40 49 89
[    2.710227] RIP  [<ffffffff812e58e6>] __list_add+0x26/0xd0
[    2.710227]  RSP <ffff88007a609da8>
---
 drivers/edac/edac_mc_sysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index de2df92..a3b0119 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1159,8 +1159,7 @@ int __init edac_mc_sysfs_init(void)
 
 void __exit edac_mc_sysfs_exit(void)
 {
-	put_device(mci_pdev);
 	device_del(mci_pdev);
+	put_device(mci_pdev);
 	edac_put_sysfs_subsys();
-	kfree(mci_pdev);
 }

