Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964Ab2EQDO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:14:58 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37322 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760477Ab2EQDO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:14:56 -0400
Message-ID: <1337224486.18429.14.camel@mengcong>
Subject: Re: [PATCH] V2: target: Handle ATA_PASS_THROUGH_16 passthrough
From: mengcong <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Thu, 17 May 2012 11:14:46 +0800
In-Reply-To: <1337153889.2985.5.camel@dabdike.int.hansenpartnership.com>
References: <1337146409.18429.11.camel@mengcong>
	 <1337153889.2985.5.camel@dabdike.int.hansenpartnership.com>
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12051703-8878-0000-0000-0000027BA4DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
with a SATA CD-ROM. This patch adds support to it so that PSCSI 
CD-ROM passthrough works with the cdrecord.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2d75c29..25e0fc0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2926,6 +2926,36 @@ static int transport_generic_cmd_sequencer(
 		size = (cdb[7] << 8) | cdb[8];
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
+	case ATA_16:
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
-- 
1.7.7



