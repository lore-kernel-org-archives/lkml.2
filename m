Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2LNLDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:03:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64576 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2LNLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:03:12 -0500
Subject: [PATCH 11/12] firmware/dmi-sysfs: fix sysfs warning on module unload
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Waychison <mikew@google.com>
Date: Fri, 14 Dec 2012 15:03:06 +0400
Message-ID: <20121214110306.11019.12679.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes redundant sysfs_remove_bin_file(), kobject_cleanup() already did this.

[ 1189.278210] ------------[ cut here ]------------
[ 1189.278293] WARNING: at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa9/0xb0()
[ 1189.278414] Hardware name: M52S-S3P
[ 1189.278489] sysfs: can not remove 'raw', no directory
[ 1189.278566] Modules linked in: dmi_sysfs(-) mce_inject ar7part mtd decnet cs5535_mfgpt cs5520 eni suni atm cmd640 ide_generic dccp_ipv6 dccp_ipv4 dccp sctp bnep rfcomm bluetooth fuse nfsd exportfs powernow_k8 kvm_amd kvm k8temp parport_pc parport edac_core i2c_nforce2 evbug pcspkr btrfs zlib_deflate libcrc32c ide_core ata_generic pata_acpi sata_nv [last unloaded: dmi_sysfs]
[ 1189.280071] Pid: 5773, comm: rmmod Tainted: P        W    3.7.0-rc8-next-20121207+ #594
[ 1189.280200] Call Trace:
[ 1189.280276]  [<ffffffff8103bc2a>] warn_slowpath_common+0x7a/0xb0
[ 1189.280355]  [<ffffffff8103bd01>] warn_slowpath_fmt+0x41/0x50
[ 1189.280434]  [<ffffffff811b9a49>] sysfs_hash_and_remove+0xa9/0xb0
[ 1189.280513]  [<ffffffff817f8a16>] ? _raw_spin_unlock+0x26/0x40
[ 1189.280592]  [<ffffffff811bd222>] sysfs_remove_bin_file+0x12/0x20
[ 1189.280671]  [<ffffffffa0d40a83>] dmi_sysfs_entry_release+0x23/0x58 [dmi_sysfs]
[ 1189.280794]  [<ffffffff812d2f13>] kobject_cleanup+0x43/0x80
[ 1189.280872]  [<ffffffff812d2f8b>] kobject_put+0x2b/0x60
[ 1189.280951]  [<ffffffffa0d40ae8>] cleanup_entry_list+0x30/0x4a [dmi_sysfs]
[ 1189.281043]  [<ffffffffa0d40b0b>] dmi_sysfs_exit+0x9/0x23 [dmi_sysfs]
[ 1189.281130]  [<ffffffff810a0f43>] sys_delete_module+0x163/0x280
[ 1189.281211]  [<ffffffff812ddd84>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1189.281296]  [<ffffffff812ddd0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1189.281375]  [<ffffffff818009d2>] system_call_fastpath+0x16/0x1b
[ 1189.281453] ---[ end trace e9fbdfe9449ac55f ]---

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Waychison <mikew@google.com>
---
 drivers/firmware/dmi-sysfs.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index eb26d62..4185f09 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -553,7 +553,6 @@ static const struct bin_attribute dmi_entry_raw_attr = {
 static void dmi_sysfs_entry_release(struct kobject *kobj)
 {
 	struct dmi_sysfs_entry *entry = to_entry(kobj);
-	sysfs_remove_bin_file(&entry->kobj, &dmi_entry_raw_attr);
 	spin_lock(&entry_list_lock);
 	list_del(&entry->list);
 	spin_unlock(&entry_list_lock);

