Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2IGPbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2IGPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:12 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 05/11] target: support zero allocation length in REQUEST SENSE
Date: Fri,  7 Sep 2012 17:30:36 +0200
Message-Id: <1347031842-2531-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to INQUIRY and MODE SENSE, construct the sense data in a
buffer and later copy it to the scatterlist.  Do not do anything,
but still clear a pending unit attention condition, if the allocation
length is zero.

However, SPC tells us that "If a REQUEST SENSE command is terminated with
CHECK CONDITION status [and] the REQUEST SENSE command was received on
an I_T nexus with a pending unit attention condition (i.e., before the
device server reports CHECK CONDITION status), then the device server
shall not clear the pending unit attention condition."  Do the
transport_kmap_data_sg early to detect this case.

It also tells us "Device servers shall not adjust the additional sense
length to reflect truncation if the allocation length is less than the
sense data available", so do not do that!  Note that the err variable
is write-only.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_spc.c  |   35 ++++++++++++++++++-----------------
 include/target/target_core_base.h |    1 +
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 4c861de..b905fb2 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -877,9 +877,11 @@ static int spc_emulate_modesense(struct se_cmd *cmd)
 static int spc_emulate_request_sense(struct se_cmd *cmd)
 {
 	unsigned char *cdb = cmd->t_task_cdb;
-	unsigned char *buf;
+	unsigned char *rbuf;
 	u8 ua_asc = 0, ua_ascq = 0;
-	int err = 0;
+	unsigned char buf[SE_SENSE_BUF];
+
+	memset(buf, 0, SE_SENSE_BUF);
 
 	if (cdb[1] & 0x01) {
 		pr_err("REQUEST_SENSE description emulation not"
@@ -888,20 +890,21 @@ static int spc_emulate_request_sense(struct se_cmd *cmd)
 		return -ENOSYS;
 	}
 
-	buf = transport_kmap_data_sg(cmd);
-
-	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
+	rbuf = transport_kmap_data_sg(cmd);
+	if (cmd->scsi_sense_reason != 0) {
+		/*
+		 * Out of memory.  We will fail with CHECK CONDITION, so
+		 * we must not clear the unit attention condition.
+		 */
+		target_complete_cmd(cmd, CHECK_CONDITION);
+		return 0;
+	} else if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
 		/*
 		 * CURRENT ERROR, UNIT ATTENTION
 		 */
 		buf[0] = 0x70;
 		buf[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
 
-		if (cmd->data_length < 18) {
-			buf[7] = 0x00;
-			err = -EINVAL;
-			goto end;
-		}
 		/*
 		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
 		 */
@@ -915,11 +916,6 @@ static int spc_emulate_request_sense(struct se_cmd *cmd)
 		buf[0] = 0x70;
 		buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
 
-		if (cmd->data_length < 18) {
-			buf[7] = 0x00;
-			err = -EINVAL;
-			goto end;
-		}
 		/*
 		 * NO ADDITIONAL SENSE INFORMATION
 		 */
@@ -927,8 +923,11 @@ static int spc_emulate_request_sense(struct se_cmd *cmd)
 		buf[7] = 0x0A;
 	}
 
-end:
-	transport_kunmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
+
 	target_complete_cmd(cmd, GOOD);
 	return 0;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 015cea0..5be8937 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -121,6 +121,7 @@
 
 #define SE_INQUIRY_BUF				512
 #define SE_MODE_PAGE_BUF			512
+#define SE_SENSE_BUF				96
 
 /* struct se_hba->hba_flags */
 enum hba_flags_table {
-- 
1.7.1


