Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2D3Pfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:35:30 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40575 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2D3Pf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:35:28 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: <target-devel@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] target: Handle GET_EVENT_STATUS_NOTIFICATION passthrough
Date: Mon, 30 Apr 2012 16:35:13 +0100
Message-Id: <1335800113-28075-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12043015-4966-0000-0000-0000022CF191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI MMC GET_EVENT_STATUS_NOTIFICATION command can be used to find
out about media change, among other things.  This patch adds it to the
command sequencer so that PSCSI CD-ROM passthrough works with modern
Linux guests that issue this command.

Tested-by: Cong Meng <mengcong@cn.ibm.com>
Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 drivers/target/target_core_transport.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a953ca0..5b83fd2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3146,6 +3146,10 @@ static int transport_generic_cmd_sequencer(
 			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
+	case GET_EVENT_STATUS_NOTIFICATION:
+		size = (cdb[7] << 8) | cdb[8];
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
+		break;
 	default:
 		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
 			" 0x%02x, sending CHECK_CONDITION.\n",
-- 
1.7.10

