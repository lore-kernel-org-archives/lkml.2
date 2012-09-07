Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2IGPbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2IGPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:04 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 03/11] target: fail REPORT LUNS with less than 16 bytes of payload
Date: Fri,  7 Sep 2012 17:30:34 +0200
Message-Id: <1347031842-2531-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPC says:

"The ALLOCATION LENGTH field is defined in 4.3.5.6. The allocation length
should be at least 16.  Device servers compliant with SPC return CHECK
CONDITION status, with the sense key set to ILLEGAL REQUEST, and the
additional sense code set to INVALID FIELD IN CDB when the allocation
length is less than 16 bytes".

Testcase: sg_raw -r8 /dev/sdb a0 00 00 00 00 00 00 00 00 08 00 00
    should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
    does not fail without the patch
    fails correctly with the patch

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_device.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cf2c66f..9fc9a60 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -669,6 +669,13 @@ int target_report_luns(struct se_cmd *se_cmd)
 	unsigned char *buf;
 	u32 lun_count = 0, offset = 8, i;
 
+	if (se_cmd->data_length < 16) {
+		pr_warn("REPORT LUNS allocation length %u too small\n",
+			se_cmd->data_length);
+		se_cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
+		return -EINVAL;
+	}
+
 	buf = transport_kmap_data_sg(se_cmd);
 	if (!buf)
 		return -ENOMEM;
-- 
1.7.1


