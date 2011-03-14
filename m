Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1CNLHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:05 -0400
Received: from nm30.bullet.mail.ne1.yahoo.com ([98.138.90.93]:20476 "HELO
	nm30.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753581Ab1CNLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:00 -0400
X-Yahoo-Newman-Id: 520413.36270.bm@omp1060.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: WPs.HO0VM1lhVZN9zi_KX0hGgZ7KQDFaI7T4Cz35OugIxFW
 opLfG3YxVGGqJVfhBnOkBL5aZ7vpKSkZsS69CP34MUswmFEp1Ufi2jtvOFkQ
 UdwWdBzYICx5.LoSaQ_YKeCn8im8LXg5XFsV7B5wgG8VUkg3OZgaR3t95gWZ
 6N9BSAf_K4KZw7fNjnux_GDPlpgPuxgjwc4gF8HUrWhtaSSqE0G7glEo.Nfb
 8k7KuFr1Qmu1p7asp5gEfMHmv27j6kG8mU5ackhYyIKb2dicbQDnw6Cg3_E4
 7_yRsBboF5SPruTGjDgBbW5wbh4LRiaGavqD6DsC0.MjKb.U0eQVZLc8RVsA
 qc_WFOU4TbA4dykIe7hc5slKuLjr_AYOFDjD9Xo1YRdA.jaXcMYqYMZQNGL1
 O5GLl6_Coa4Lu.mryne2GYwMZbR2wPEqQOFnOjGzbkXPcYly3lKT1jlB4yrJ
 z_0p0m03D67N3KvkETZTgGgUuliJX9u.MG4X_TUAWimD3j_7l
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Dan Carpenter <error27@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 07/21] target: Minor sparse warning fixes and annotations
Date: Mon, 14 Mar 2011 04:06:01 -0700
Message-Id: <1300100775-10012-8-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

This patch addresses the majority of sparse warnings and adds
proper locking annotations.  It also fixes the dubious one-bit signed
bitfield, for which the signed one-bit types can be 0 or -1 which can
cause a problem if someone ever checks if (foo->lu_gp_assoc == 1).
The current code is fine because everyone just checks zero vs non-zero.
But Sparse complains about it so lets change it.  The warnings look like
this:

include/target/target_core_base.h:228:26: error: dubious one-bit signed bitfield

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c     |    1 +
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_pscsi.c      |    3 +++
 drivers/target/target_core_rd.h         |    2 --
 drivers/target/target_core_transport.c  |    4 +---
 include/target/target_core_base.h       |   14 +++++++-------
 include/target/target_core_fabric_ops.h |    2 +-
 include/target/target_core_transport.h  |    4 ++++
 8 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c9085e3..9d8adee 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -590,6 +590,7 @@ static void core_export_port(
  *	Called with struct se_device->se_port_lock spinlock held.
  */
 static void core_release_port(struct se_device *dev, struct se_port *port)
+	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
 {
 	/*
 	 * Wait for any port reference for PR ALL_TG_PT=1 operation
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 2628564..bddab5d 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -35,6 +35,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
 #include <target/target_core_transport.h>
+#include <target/target_core_fabric_lib.h>
 #include <target/target_core_fabric_ops.h>
 #include <target/target_core_configfs.h>
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e795f7d..40c2419 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -442,6 +442,7 @@ static struct se_device *pscsi_create_type_disk(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
@@ -489,6 +490,7 @@ static struct se_device *pscsi_create_type_rom(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
@@ -523,6 +525,7 @@ static struct se_device *pscsi_create_type_other(
 	struct pscsi_dev_virt *pdv,
 	struct se_subsystem_dev *se_dev,
 	struct se_hba *hba)
+	__releases(sh->host_lock)
 {
 	struct se_device *dev;
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)pdv->pdv_se_hba->hba_ptr;
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 13badfb..3ea19e2 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -14,8 +14,6 @@
 #define RD_BLOCKSIZE		512
 #define RD_MAX_SECTORS		1024
 
-extern struct kmem_cache *se_mem_cache;
-
 /* Used in target_core_init_configfs() for virtual LUN 0 access */
 int __init rd_module_init(void);
 void rd_module_exit(void);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 236e22d..8392b26 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,8 +228,6 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
 static void transport_stop_all_task_timers(struct se_cmd *cmd);
 
-int transport_emulate_control_cdb(struct se_task *task);
-
 int init_se_global(void)
 {
 	struct se_global *global;
@@ -4396,7 +4394,7 @@ out:
 	return -1;
 }
 
-extern u32 transport_calc_sg_num(
+u32 transport_calc_sg_num(
 	struct se_task *task,
 	struct se_mem *in_se_mem,
 	u32 task_offset)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0828b6c..bc93b78 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -239,7 +239,7 @@ struct t10_alua_lu_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_lu_gp_member {
-	int lu_gp_assoc:1;
+	bool lu_gp_assoc;
 	atomic_t lu_gp_mem_ref_cnt;
 	spinlock_t lu_gp_mem_lock;
 	struct t10_alua_lu_gp *lu_gp;
@@ -271,7 +271,7 @@ struct t10_alua_tg_pt_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_tg_pt_gp_member {
-	int tg_pt_gp_assoc:1;
+	bool tg_pt_gp_assoc;
 	atomic_t tg_pt_gp_mem_ref_cnt;
 	spinlock_t tg_pt_gp_mem_lock;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -336,7 +336,7 @@ struct t10_pr_registration {
 	int pr_res_type;
 	int pr_res_scope;
 	/* Used for fabric initiator WWPNs using a ISID */
-	int isid_present_at_reg:1;
+	bool isid_present_at_reg;
 	u32 pr_res_mapped_lun;
 	u32 pr_aptpl_target_lun;
 	u32 pr_res_generation;
@@ -418,7 +418,7 @@ struct se_transport_task {
 	unsigned long long	t_task_lba;
 	int			t_tasks_failed;
 	int			t_tasks_fua;
-	int			t_tasks_bidi:1;
+	bool			t_tasks_bidi;
 	u32			t_task_cdbs;
 	u32			t_tasks_check;
 	u32			t_tasks_no;
@@ -470,7 +470,7 @@ struct se_task {
 	u8		task_flags;
 	int		task_error_status;
 	int		task_state_flags;
-	int		task_padded_sg:1;
+	bool		task_padded_sg;
 	unsigned long long	task_lba;
 	u32		task_no;
 	u32		task_sectors;
@@ -583,7 +583,7 @@ struct se_ua {
 struct se_node_acl {
 	char			initiatorname[TRANSPORT_IQN_LEN];
 	/* Used to signal demo mode created ACL, disabled by default */
-	int			dynamic_node_acl:1;
+	bool			dynamic_node_acl;
 	u32			queue_depth;
 	u32			acl_index;
 	u64			num_cmds;
@@ -632,7 +632,7 @@ struct se_lun_acl {
 }  ____cacheline_aligned;
 
 struct se_dev_entry {
-	int			def_pr_registered:1;
+	bool			def_pr_registered;
 	/* See transport_lunflags_table */
 	u32			lun_flags;
 	u32			deve_cmds;
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index f3ac12b..5eb8b1a 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -8,7 +8,7 @@ struct target_core_fabric_ops {
 	 * for scatterlist chaining using transport_do_task_sg_link(),
 	 * disabled by default
 	 */
-	int task_sg_chaining:1;
+	bool task_sg_chaining;
 	char *(*get_fabric_name)(void);
 	u8 (*get_fabric_proto_ident)(struct se_portal_group *);
 	char *(*tpg_get_wwn)(struct se_portal_group *);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 2469405..96e13e7 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -109,6 +109,8 @@
 struct se_mem;
 struct se_subsystem_api;
 
+extern struct kmem_cache *se_mem_cache;
+
 extern int init_se_global(void);
 extern void release_se_global(void);
 extern void init_scsi_index_table(void);
@@ -188,6 +190,8 @@ extern void transport_generic_process_write(struct se_cmd *);
 extern int transport_generic_do_tmr(struct se_cmd *);
 /* From target_core_alua.c */
 extern int core_alua_check_nonop_delay(struct se_cmd *);
+/* From target_core_cdb.c */
+extern int transport_emulate_control_cdb(struct se_task *);
 
 /*
  * Each se_transport_task_t can have N number of possible struct se_task's
-- 
1.7.4.1

