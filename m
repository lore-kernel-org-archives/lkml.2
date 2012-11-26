Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2KZRBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2KZRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 033/270] qla2xxx: Fix endianness of task management response code
Date: Mon, 26 Nov 2012 14:55:23 -0200
Message-Id: <1353949160-26803-34-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e4b11b89f9039ca97b2ed1b6efeb6749fbdeb252 upstream.

The qla2xxx firmware actually expects the task management response
code in a CTIO IOCB with SCSI status mode 1 to be in little-endian
byte order, ie the response code should be the first byte in the
sense_data[] array.  The old code erroneously byte-swapped the
response code, which puts it in the wrong place on the wire and leads
to initiators thinking every task management request succeeds (since
they see 0 in the byte where they look for the response code).

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 77759c7..5a71e84 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1403,7 +1403,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->u.status1.scsi_status =
 	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
-	((uint32_t *)ctio->u.status1.sense_data)[0] = cpu_to_be32(resp_code);
+	ctio->u.status1.sense_data[0] = resp_code;
 
 	qla2x00_start_iocbs(ha, ha->req);
 }
-- 
1.7.9.5

