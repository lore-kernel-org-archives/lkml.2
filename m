Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0IVK3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:29:33 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:36679 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753302Ab0IVK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:29:31 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 9MonYjgVM1lR5jlZcKC6ympfrct_TF8HxpeK7Z5op_PdHag
 3s_tlC939tpYRpGivmTWlr3mJwtq6OawGzBr7F032CD5iU.RhY6vuowVsaqi
 bzUoR5PmOrP7QH666GgGu3HCiu.4lSBE0EgAUx_onqBlrCoYsF93F164Il6s
 RccwfuRnV6YQHGJurcoaP1R5WFa_aovnWpkDxSss98vyl4omjRycXF17kZS9
 Mkuw5PVzGrDKnlA5qr2GIM8QwxjJffgpZzWc2RH27c74KTcPSpb4oDxLFqKV
 sPgPIMXIYcg3kP4yyoaypRMsy1ZATmZjwbMxxj2Uq_3ZXFQengEBSy_f9PgT
 w_8hcff60f8nxMg2NqQ--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <Joel.Becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Allow MappedLUNs with non existent struct se_lun
Date: Wed, 22 Sep 2010 03:29:29 -0700
Message-Id: <1285151369-26666-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Joel and Co,

This patch updates the TCM fabric independent MappedLUN ConfigFS handler in
target_core_fabric_configfs.c:target_fabric_mappedlun_unlink() and
associated TCM Core device + tpg code to allow a MappedLUN group at
struct se_lun_acl->se_lun_group to function with a non-existent struct se_lun
that has been removed with an explict target_core_fabric_configfs.c:
target_fabric_port_unlink() to the parent struct config_group while any number
of N MappedLUN struct config_group's are still outstanding in the TCM fabric
ConfigFS layout.

This patch has been tested with a manual unlink(2) of $FABRIC/lun/lun_0/$PORT_SYMLINK
and $FABRIC/acl/$NODE_ACL/lun_0/lunacl_link and /etc/init.d/target stop with
multiple outstanding MappedLUN w/o a valid TPG struct se_lun symlink.

Many thanks to Joel Becker for helping to resolve this issue without
the original ->check_link() patch to fs/configfs/symlink.c:configfs_unlink()..!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c          |    4 ++++
 drivers/target/target_core_fabric_configfs.c |   16 ++++++++++++----
 drivers/target/target_core_tpg.c             |    8 --------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f52fff8..6fe4408 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -470,6 +470,10 @@ int core_update_device_list_for_node(
 	 * core_alua_do_transition_tg_pt() depends on these being present.
 	 */
 	if (!(enable)) {
+		if (!(deve->se_lun_acl)) {
+			dump_stack();
+			return 0;
+		}
 		spin_lock_bh(&port->sep_alua_lock);
 		list_del(&deve->alua_port_list);
 		spin_unlock_bh(&port->sep_alua_lock);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 58da51a..f433120 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -137,11 +137,20 @@ static int target_fabric_mappedlun_unlink(
 	struct config_item *lun_acl_ci,
 	struct config_item *lun_ci)
 {
-	struct se_lun *lun = container_of(to_config_group(lun_ci),
-			struct se_lun, lun_group);
+	struct se_lun *lun;
 	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
 			struct se_lun_acl, se_lun_group);
-	struct se_portal_group *se_tpg = lun->lun_sep->sep_tpg;
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve = &nacl->device_list[lacl->mapped_lun];
+	struct se_portal_group *se_tpg;
+	/*
+	 * Determine if the underlying MappedLUN has already been released..
+	 */
+	if (!(deve->se_lun))
+		return 0;
+
+	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
+	se_tpg = lun->lun_sep->sep_tpg;
 
 	core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
 	return 0;
@@ -708,7 +717,6 @@ static struct configfs_item_operations target_fabric_port_item_ops = {
 	.show_attribute		= target_fabric_port_attr_show,
 	.store_attribute	= target_fabric_port_attr_store,
 	.allow_link		= target_fabric_port_link,
-	.check_link		= target_fabric_port_check_link,
 	.drop_link		= target_fabric_port_unlink,
 };
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index e598f2b..a895364 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -817,8 +817,6 @@ int core_tpg_post_dellun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	struct se_lun_acl *acl, *acl_tmp;
-
 	core_tpg_shutdown_lun(tpg, lun);
 
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
@@ -827,12 +825,6 @@ int core_tpg_post_dellun(
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	spin_unlock(&tpg->tpg_lun_lock);
 
-	spin_lock(&lun->lun_acl_lock);
-	list_for_each_entry_safe(acl, acl_tmp, &lun->lun_acl_list, lacl_list) {
-		kfree(acl);
-	}
-	spin_unlock(&lun->lun_acl_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_post_dellun);
-- 
1.5.6.5

