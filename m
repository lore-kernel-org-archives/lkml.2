Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab2EPG1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:27:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57154 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2EPG1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:27:37 -0400
Message-ID: <1337146409.18429.11.camel@mengcong>
Subject: [PATCH] target: Handle ATA_PASS_THROUGH_16 passthrough
From: mengcong <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        meng cong <mc@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 13:33:29 +0800
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12051519-0260-0000-0000-000001213C47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
with a SATA CD-ROM. This patch adds support to it so that PSCSI 
CD-ROM passthrough works with the cdrecord.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
 include/scsi/scsi.h                    |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2d75c29..41439b3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2926,6 +2926,36 @@ static int transport_generic_cmd_sequencer(
 		size = (cdb[7] << 8) | cdb[8];
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
+	case ATA_PASS_THROUGH_16:
+		// T_LENGTH
+		switch (cdb[2] & 0x3) {
+		case 0x0:
+			sectors = 0;
+			break;
+		case 0x1:
+			sectors = (((cdb[1] & 0x1) ? cdb[3] : 0) << 8) | cdb[4];
+			break;
+		case 0x2:
+			sectors = (((cdb[1] & 0x1) ? cdb[5] : 0) << 8) | cdb[6];
+			break;
+		case 0x3:
+			pr_err("T_LENGTH=0x3 not supported\n");
+			goto out_invalid_cdb_field;
+			break;
+		}
+		
+		// BYTE_BLOCK
+		if (cdb[2] & 0x4) {
+			// BLOCK
+			// T_TYPE: 512 or sector
+			size = sectors * ((cdb[2] & 0x10) ? 
+				dev->se_sub_dev->se_dev_attrib.block_size : 512);
+		} else {
+			// BYTE
+			size = sectors;
+		}
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
+		break;
 	default:
 		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
 			" 0x%02x, sending CHECK_CONDITION.\n",
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index f34a5a8..f6dcd25 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -116,6 +116,7 @@ struct scsi_cmnd;
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define VARIABLE_LENGTH_CMD   0x7f
+#define ATA_PASS_THROUGH_16   0x85
 #define REPORT_LUNS           0xa0
 #define SECURITY_PROTOCOL_IN  0xa2
 #define MAINTENANCE_IN        0xa3
-- 
1.7.7


