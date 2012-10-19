Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438Ab2JSDCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:02:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:52169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907Ab2JSCsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 33/76] qla2xxx: Fix endianness of task management response code
Date: Thu, 18 Oct 2012 19:46:57 -0700
Message-Id: <20121019024355.454371648@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1403,7 +1403,7 @@ static void qlt_24xx_send_task_mgmt_ctio
 	ctio->u.status1.scsi_status =
 	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
-	((uint32_t *)ctio->u.status1.sense_data)[0] = cpu_to_be32(resp_code);
+	ctio->u.status1.sense_data[0] = resp_code;
 
 	qla2x00_start_iocbs(ha, ha->req);
 }


