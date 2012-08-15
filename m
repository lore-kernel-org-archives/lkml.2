Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2HOTuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62883 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2HOTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Salyzyn <mark_salyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 058/165] libsas: fix panic when single phy is disabled on a wide port
Date: Wed, 15 Aug 2012 15:46:42 -0400
Message-ID: <1345060109-9187-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a73914c35b05d80f8ce78288e10056c91090b666 upstream.

When a wide port is being utilized to a target, if one disables only one
of the
phys, we get an OS crash:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000238
IP: [<ffffffff814ca9b1>] mutex_lock+0x21/0x50
PGD 4103f5067 PUD 41dba9067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/bus/pci/slots/5/address
CPU 0
Modules linked in: pm8001(U) ses enclosure fuse nfsd exportfs autofs4
ipmi_devintf ipmi_si ipmi_msghandler nfs lockd fscache nfs_acl
auth_rpcgss 8021q fcoe libfcoe garp libfc scsi_transport_fc stp scsi_tgt
llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table ipv6 sr_mod cdrom
dm_mirror dm_region_hash dm_log uinput sg i2c_i801 i2c_core iTCO_wdt
iTCO_vendor_support e1000e mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext3
jbd mbcache sd_mod crc_t10dif usb_storage ata_generic pata_acpi ata_piix
libsas(U) scsi_transport_sas dm_mod [last unloaded: pm8001]

Modules linked in: pm8001(U) ses enclosure fuse nfsd exportfs autofs4
ipmi_devintf ipmi_si ipmi_msghandler nfs lockd fscache nfs_acl
auth_rpcgss 8021q fcoe libfcoe garp libfc scsi_transport_fc stp scsi_tgt
llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table ipv6 sr_mod cdrom
dm_mirror dm_region_hash dm_log uinput sg i2c_i801 i2c_core iTCO_wdt
iTCO_vendor_support e1000e mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext3
jbd mbcache sd_mod crc_t10dif usb_storage ata_generic pata_acpi ata_piix
libsas(U) scsi_transport_sas dm_mod [last unloaded: pm8001]
Pid: 5146, comm: scsi_wq_5 Not tainted
2.6.32-71.29.1.el6.lustre.7.x86_64 #1 Storage Server
RIP: 0010:[<ffffffff814ca9b1>]  [<ffffffff814ca9b1>]
mutex_lock+0x21/0x50
RSP: 0018:ffff8803e4e33d30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000238 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8803e664c800 RDI: 0000000000000238
RBP: ffff8803e4e33d40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000238 R14: ffff88041acb7200 R15: ffff88041c51ada0
FS:  0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000238 CR3: 0000000410143000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_wq_5 (pid: 5146, threadinfo ffff8803e4e32000, task
ffff8803e4e294a0)
Stack:
 ffff8803e664c800 0000000000000000 ffff8803e4e33d70 ffffffffa001f06e
<0> ffff8803e4e33d60 ffff88041c51ada0 ffff88041acb7200 ffff88041bc0aa00
<0> ffff8803e4e33d90 ffffffffa0032b6c 0000000000000014 ffff88041acb7200
Call Trace:
 [<ffffffffa001f06e>] sas_port_delete_phy+0x2e/0xa0 [scsi_transport_sas]
 [<ffffffffa0032b6c>] sas_unregister_devs_sas_addr+0xac/0xe0 [libsas]
 [<ffffffffa0034914>] sas_ex_revalidate_domain+0x204/0x330 [libsas]
 [<ffffffffa00307f0>] ? sas_revalidate_domain+0x0/0x90 [libsas]
 [<ffffffffa0030855>] sas_revalidate_domain+0x65/0x90 [libsas]
 [<ffffffff8108c7d0>] worker_thread+0x170/0x2a0
 [<ffffffff81091ea0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108c660>] ? worker_thread+0x0/0x2a0
 [<ffffffff81091b36>] kthread+0x96/0xa0
 [<ffffffff810141ca>] child_rip+0xa/0x20
 [<ffffffff81091aa0>] ? kthread+0x0/0xa0
 [<ffffffff810141c0>] ? child_rip+0x0/0x20
Code: ff ff 85 c0 75 ed eb d6 66 90 55 48 89 e5 48 83 ec 10 48 89 1c 24
4c 89 64 24 08 0f 1f 44 00 00 48 89 fb e8 92 f4 ff ff 48 89 df <f0> ff
0f 79 05 e8 25 00 00 00 65 48 8b 04 25 08 cc 00 00 48 2d
RIP  [<ffffffff814ca9b1>] mutex_lock+0x21/0x50
 RSP <ffff8803e4e33d30>
CR2: 0000000000000238

The following patch is admittedly a band-aid, and does not solve the
root cause, but it still is a good candidate for hardening as a pointer
check before reference.

Signed-off-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Tested-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 46acf74..7107bbc 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1758,10 +1758,12 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	sas_port_delete_phy(phy->port, phy->phy);
-	if (phy->port->num_phys == 0)
-		sas_port_delete(phy->port);
-	phy->port = NULL;
+	if (phy->port) {
+		sas_port_delete_phy(phy->port, phy->phy);
+		if (phy->port->num_phys == 0)
+			sas_port_delete(phy->port);
+		phy->port = NULL;
+	}
 }
 
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
-- 
1.7.12.rc2

