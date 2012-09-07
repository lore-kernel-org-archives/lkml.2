Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2IGPb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2IGPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:23 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 08/11] target: fix truncation of mode data, support zero allocation length
Date: Fri,  7 Sep 2012 17:30:39 +0200
Message-Id: <1347031842-2531-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/target/target_core_spc.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 647e51b..96e5c48 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -784,7 +784,7 @@ static int spc_emulate_modesense(struct se_cmd *cmd)
 	unsigned char *rbuf;
 	int type = dev->transport->get_device_type(dev);
 	int ten = (cmd->t_task_cdb[0] == MODE_SENSE_10);
-	int offset = ten ? 8 : 4;
+	u32 offset = ten ? 8 : 4;
 	int length = 0;
 	unsigned char buf[SE_MODE_PAGE_BUF];
 
@@ -817,6 +817,7 @@ static int spc_emulate_modesense(struct se_cmd *cmd)
 		offset -= 2;
 		buf[0] = (offset >> 8) & 0xff;
 		buf[1] = offset & 0xff;
+		offset += 2;
 
 		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
@@ -826,13 +827,10 @@ static int spc_emulate_modesense(struct se_cmd *cmd)
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			spc_modesense_dpofua(&buf[3], type);
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
@@ -842,14 +840,13 @@ static int spc_emulate_modesense(struct se_cmd *cmd)
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			spc_modesense_dpofua(&buf[2], type);
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
1.7.1


