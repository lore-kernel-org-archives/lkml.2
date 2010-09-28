Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab0I1CG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:06:27 -0400
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:40501 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933532Ab0I1CGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:23 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: CUILYQMVM1nwzi4hOeEI9SKCVawiuz5C2wc5KKwC_pmHmJ3
 vZmfShgeFloZjVHwysEqxwHDQc04A.fQFChhdh0oqYIiyGMzO6YRe0o0.vGD
 OhIy2XasNsa2Yamcuy8ycv_uOR2wtLv_gvLQV93_YOj6IZyO5vIuKXitGeNA
 _qReaRjK1ujnsYtvND3jTESmek5ApzKfWb2xuH8kbLJmdVSF.iGbk.nut.xf
 fslVwKP0GC7pmxZXv5OhJrF1W8X6zXcsUMzlgXN5FLC2BkAcrTDqgOBtIpsO
 sY4frPz0o4MfSUxXwpMkQ4VYbPvaCGqavP4D98g.C4A4-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 07/19] libfc: Remove host_lock unlock() + lock() from fc_queuecommand()
Date: Mon, 27 Sep 2010 19:06:11 -0700
Message-Id: <1285639571-7345-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
fc_fcp.c:fc_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libfc/fc_fcp.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..140cd94 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1751,8 +1751,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
  * @cmd:   The scsi_cmnd to be executed
  * @done:  The callback function to be called when the scsi_cmnd is complete
  *
- * This is the i/o strategy routine, called by the SCSI layer. This routine
- * is called with the host_lock held.
+ * This is the i/o strategy routine, called by the SCSI layer.
  */
 int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 {
@@ -1772,7 +1771,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		done(sc_cmd);
 		return 0;
 	}
-	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
@@ -1849,7 +1847,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 out:
-	spin_lock_irq(lport->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
-- 
1.7.3

