Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422771Ab2CPXmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:42:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946495Ab2CPXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:44 -0400
Message-Id: <20120316233814.199396648@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Svec <martin.svec@zoner.cz>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 40/41] target: Fix compatible reservation handling (CRH=1) with legacy RESERVE/RELEASE
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 087a03b3ea1c8d6e2d5743a8d1c6d571058caa04 upstream.

This patch addresses a bug with target_check_scsi2_reservation_conflict()
return checking in target_scsi2_reservation_[reserve,release]() that was
preventing CRH=1 operation from silently succeeding in the two special
cases defined by SPC-3, and not failing with reservation conflict status
when dealing with legacy RESERVE/RELEASE + active SPC-3 PR logic.

Also explictly set cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT during
the early non reservation holder failure from pr_ops->t10_seq_non_holder()
check in transport_generic_cmd_sequencer() for fabrics that already expect
it to be set.

This bug was originally introduced in mainline commit:

commit eacac00ce5bfde8086cd0615fb53c986f7f970fe
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Nov 3 17:50:40 2011 -0400

    target: split core_scsi2_emulate_crh

Reported-by: Martin Svec <martin.svec@zoner.cz>
Cc: Martin Svec <martin.svec@zoner.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c        |   34 +++++++++++++++++++++------------
 drivers/target/target_core_transport.c |    1 
 2 files changed, 23 insertions(+), 12 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -120,7 +120,7 @@ static struct t10_pr_registration *core_
 					struct se_node_acl *, struct se_session *);
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
 
-static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd, int *ret)
+static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 {
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_subsystem_dev *su_dev = cmd->se_dev->se_sub_dev;
@@ -130,7 +130,7 @@ static int target_check_scsi2_reservatio
 	int conflict = 0;
 
 	if (!crh)
-		return false;
+		return -EINVAL;
 
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 			se_sess);
@@ -158,16 +158,14 @@ static int target_check_scsi2_reservatio
 		 */
 		if (pr_reg->pr_res_holder) {
 			core_scsi3_put_pr_reg(pr_reg);
-			*ret = 0;
-			return false;
+			return 1;
 		}
 		if ((pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
 		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) ||
 		    (pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
 			core_scsi3_put_pr_reg(pr_reg);
-			*ret = 0;
-			return true;
+			return 1;
 		}
 		core_scsi3_put_pr_reg(pr_reg);
 		conflict = 1;
@@ -192,10 +190,10 @@ static int target_check_scsi2_reservatio
 			" while active SPC-3 registrations exist,"
 			" returning RESERVATION_CONFLICT\n");
 		cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
-		return true;
+		return -EBUSY;
 	}
 
-	return false;
+	return 0;
 }
 
 int target_scsi2_reservation_release(struct se_task *task)
@@ -204,12 +202,18 @@ int target_scsi2_reservation_release(str
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg = sess->se_tpg;
-	int ret = 0;
+	int ret = 0, rc;
 
 	if (!sess || !tpg)
 		goto out;
-	if (target_check_scsi2_reservation_conflict(cmd, &ret))
+	rc = target_check_scsi2_reservation_conflict(cmd);
+	if (rc == 1)
 		goto out;
+	else if (rc < 0) {
+		cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = 0;
 	spin_lock(&dev->dev_reservation_lock);
@@ -246,7 +250,7 @@ int target_scsi2_reservation_reserve(str
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg = sess->se_tpg;
-	int ret = 0;
+	int ret = 0, rc;
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
@@ -262,8 +266,14 @@ int target_scsi2_reservation_reserve(str
 	 */
 	if (!sess || !tpg)
 		goto out;
-	if (target_check_scsi2_reservation_conflict(cmd, &ret))
+	rc = target_check_scsi2_reservation_conflict(cmd);
+	if (rc == 1)
 		goto out;
+	else if (rc < 0) {
+		cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = 0;
 	spin_lock(&dev->dev_reservation_lock);
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2507,6 +2507,7 @@ static int transport_generic_cmd_sequenc
 					cmd, cdb, pr_reg_type) != 0) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			cmd->se_cmd_flags |= SCF_SCSI_RESERVATION_CONFLICT;
+			cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
 			cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
 			return -EBUSY;
 		}


