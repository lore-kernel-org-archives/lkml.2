Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2G3IQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:16:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51292 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab2G3IQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:16:44 -0400
Date: Mon, 30 Jul 2012 11:16:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [SCSI] ipr: missing unlock before a return
Message-ID: <20120730081635.GE15702@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently changed the locking in this function, but this return was
missed.  It needs an unlock and the IRQs need to be restored.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 07b14ba..7a5ccb2c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5874,8 +5874,11 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 		goto err_nodev;
 	}
 
-	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
+	if (ipr_is_gata(res) && res->sata_port) {
+		rc = ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
+		spin_unlock_irqrestore(shost->host_lock, lock_flags);
+		return rc;
+	}
 
 	ipr_cmd = __ipr_get_free_ipr_cmnd(ioa_cfg);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
