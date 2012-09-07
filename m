Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2IGPbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2IGPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:19 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 07/11] target: support zero allocation length in INQUIRY
Date: Fri,  7 Sep 2012 17:30:38 +0200
Message-Id: <1347031842-2531-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INQUIRY processing already uses an on-heap bounce buffer for loopback,
but not for other fabrics.  Switch this to a cheaper on-stack bounce
buffer, similar to the one used by MODE SENSE and REQUEST SENSE, and
use it unconditionally.  With this in place, zero allocation length is
handled simply by checking the return address of transport_kmap_data_sg.

Testcase: sg_raw /dev/sdb 12 00 83 00 00 00
    should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
    does not fail without the patch
    fails correctly with the series

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_spc.c |   31 ++++++-------------------------
 1 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index b905fb2..647e51b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -600,30 +600,11 @@ static int spc_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
-	unsigned char *buf, *map_buf;
+	unsigned char *rbuf;
 	unsigned char *cdb = cmd->t_task_cdb;
+	unsigned char buf[SE_INQUIRY_BUF];
 	int p, ret;
 
-	map_buf = transport_kmap_data_sg(cmd);
-	/*
-	 * If SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is not set, then we
-	 * know we actually allocated a full page.  Otherwise, if the
-	 * data buffer is too small, allocate a temporary buffer so we
-	 * don't have to worry about overruns in all our INQUIRY
-	 * emulation handling.
-	 */
-	if (cmd->data_length < SE_INQUIRY_BUF &&
-	    (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-		buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
-		if (!buf) {
-			transport_kunmap_data_sg(cmd);
-			cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-			return -ENOMEM;
-		}
-	} else {
-		buf = map_buf;
-	}
-
 	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
 	else
@@ -655,11 +636,11 @@ static int spc_emulate_inquiry(struct se_cmd *cmd)
 	ret = -EINVAL;
 
 out:
-	if (buf != map_buf) {
-		memcpy(map_buf, buf, cmd->data_length);
-		kfree(buf);
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
 	}
-	transport_kunmap_data_sg(cmd);
 
 	if (!ret)
 		target_complete_cmd(cmd, GOOD);
-- 
1.7.1


