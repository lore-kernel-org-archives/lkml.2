Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2KZRBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2KZRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 023/270] target: support zero allocation length in INQUIRY
Date: Mon, 26 Nov 2012 14:55:13 -0200
Message-Id: <1353949160-26803-24-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit ffe7b0e9326d9c68f5688bef691dd49f1e0d3651 upstream.

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
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: code to be patched is in target_core_cdb.c on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_cdb.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index bf7d38a..5b20579 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -605,30 +605,11 @@ int target_emulate_inquiry(struct se_cmd *cmd)
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
@@ -660,11 +641,11 @@ int target_emulate_inquiry(struct se_cmd *cmd)
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
1.7.9.5

