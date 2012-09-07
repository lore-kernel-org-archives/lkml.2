Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2IGPeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:34:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2IGPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 02/11] target: report too-small parameter lists everywhere
Date: Fri,  7 Sep 2012 17:30:33 +0200
Message-Id: <1347031842-2531-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several places were not checking that the parameter list length
was large enough, and thus accessing invalid memory.  Zero-length
parameter lists are just a special case of this.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_alua.c   |    7 +++++++
 drivers/target/target_core_iblock.c |   17 +++++++++++++++--
 drivers/target/target_core_pr.c     |    8 ++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 9179997..41641ba 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -218,6 +218,13 @@ int target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		return -EINVAL;
 	}
+	if (cmd->data_length < 4) {
+		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
+			" small\n", cmd->data_length);
+		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+		return -EINVAL;
+	}
+
 	buf = transport_kmap_data_sg(cmd);
 
 	/*
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 76db75e..9ba4954 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -325,17 +325,30 @@ static int iblock_execute_unmap(struct se_cmd *cmd)
 	struct iblock_dev *ibd = dev->dev_ptr;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
-	int size = cmd->data_length;
+	int size;
 	u32 range;
 	int ret = 0;
 	int dl, bd_dl;
 
+	if (cmd->data_length < 8) {
+		pr_warn("UNMAP parameter list length %u too small\n",
+			cmd->data_length);
+		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+		return -EINVAL;
+	}
+
 	buf = transport_kmap_data_sg(cmd);
 
 	dl = get_unaligned_be16(&buf[0]);
 	bd_dl = get_unaligned_be16(&buf[2]);
 
-	size = min(size - 8, bd_dl);
+	size = cmd->data_length - 8;
+	if (bd_dl > size)
+		pr_warn("UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
+			cmd->data_length, bd_dl);
+	else
+		size = bd_dl;
+
 	if (size / 16 > dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count) {
 		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
 		ret = -EINVAL;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1e94650..956c84c 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1540,6 +1540,14 @@ static int core_scsi3_decode_spec_i_port(
 	tidh_new->dest_local_nexus = 1;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
+	if (cmd->data_length < 28) {
+		pr_warn("SPC-PR: Received PR OUT parameter list"
+			" length too small: %u\n", cmd->data_length);
+		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	buf = transport_kmap_data_sg(cmd);
 	/*
 	 * For a PERSISTENT RESERVE OUT specify initiator ports payload,
-- 
1.7.1


