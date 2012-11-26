Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2KZRBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2KZRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 024/270] target: fix truncation of mode data, support zero allocation length
Date: Mon, 26 Nov 2012 14:55:14 -0200
Message-Id: <1353949160-26803-25-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7a3f369ce31694017996524a1cdb08208a839077 upstream.

The offset was not bumped back to the full size after writing the
header of the MODE SENSE response, so the last 1 or 2 bytes were
not copied.

On top of this, support zero-length requests by checking for the
return value of transport_kmap_data_sg.

Testcase: sg_raw -r20 /dev/sdb 5a 00 0a 00 00 00 00 00 14 00
    last byte should be 0x1e
    it is 0x00 without the patch
    it is correct with the patch

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: backported, code to be patched is on target_core_cdb.c,
  target_emulate_modesense, the function was moved/renamed later ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_cdb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 5b20579..3dc3393 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -856,7 +856,7 @@ int target_emulate_modesense(struct se_cmd *cmd)
 	unsigned char *rbuf;
 	int type = dev->transport->get_device_type(dev);
 	int ten = (cmd->t_task_cdb[0] == MODE_SENSE_10);
-	int offset = ten ? 8 : 4;
+	u32 offset = ten ? 8 : 4;
 	int length = 0;
 	unsigned char buf[SE_MODE_PAGE_BUF];
 
@@ -889,6 +889,7 @@ int target_emulate_modesense(struct se_cmd *cmd)
 		offset -= 2;
 		buf[0] = (offset >> 8) & 0xff;
 		buf[1] = offset & 0xff;
+		offset += 2;
 
 		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
@@ -898,13 +899,10 @@ int target_emulate_modesense(struct se_cmd *cmd)
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			target_modesense_dpofua(&buf[3], type);
-
-		if ((offset + 2) > cmd->data_length)
-			offset = cmd->data_length;
-
 	} else {
 		offset -= 1;
 		buf[0] = offset & 0xff;
+		offset += 1;
 
 		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
@@ -914,14 +912,13 @@ int target_emulate_modesense(struct se_cmd *cmd)
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			target_modesense_dpofua(&buf[2], type);
-
-		if ((offset + 1) > cmd->data_length)
-			offset = cmd->data_length;
 	}
 
 	rbuf = transport_kmap_data_sg(cmd);
-	memcpy(rbuf, buf, offset);
-	transport_kunmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min(offset, cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;
-- 
1.7.9.5

