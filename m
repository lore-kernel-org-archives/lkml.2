Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0IWXhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:37:53 -0400
Received: from nm25-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.228]:26203 "HELO
	nm25-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756186Ab0IWXhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:37:48 -0400
X-Yahoo-Newman-Id: 394026.96325.bm@omp1047.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: jUHjQ0kVM1mrJNssyfJslOAbrzQ4MGQ6JGKTzCnkLSIaGaO
 xIXAatH3pHAUQKLkVqSY3sQSKWEbT74pV38KU6aXMx2B8jSXJBJbR.7b45sf
 um3zx0PnPihoCpwqqNKqAnCuMZUV2DZCjY5Zsuf1iIBrv0AdjiUZonSGvEr3
 8N1AV72f0znuuBlsTdE8C3sADIaD3XZBWkcTaFks6IIZI6_vFpelHj879WIZ
 l2rsMdj03IKBxi.P88nKSXhTbSoBING6Zi4RqgDdqR2DPRSxu3_H8A9HCZwW
 u3ydP36dQXS64zp2d7K2xnz40huGIrXRWjxvhwqh.IgYDefBLX_2eyKhqQqz
 7Zn.ZtQM9OYK82gEUs7E-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v3 02/15] libiscsi: Remove host_lock unlock() + lock() from iscsi_queuecommand()
Date: Thu, 23 Sep 2010 16:37:42 -0700
Message-Id: <1285285062-16371-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from libiscsi.c:iscsi_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 633e090..7e4134e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1615,7 +1615,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	host = sc->device->host;
 	ihost = shost_priv(host);
-	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -1706,7 +1705,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
-	spin_lock(host->host_lock);
 	return 0;
 
 prepd_reject:
@@ -1716,7 +1714,6 @@ reject:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
-	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
@@ -1733,7 +1730,6 @@ fault:
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 	done(sc);
-	spin_lock(host->host_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
-- 
1.7.3

