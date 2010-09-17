Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0IQSWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:22:16 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:46020 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756019Ab0IQSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:12 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: pQIuBPcVM1nUS_I7K4pmPnaNmwvxZRKLeD71HXyNrL7U0ob
 FViNgr02mZstlhClmBOam_q6Og0emjCpjJTZDkggtcS1yRziFT87zNcLNXSz
 J6WNpX9ZpfgTX3DONfPbcdmv6xtHmr4Bxg78chsYbk6L0JBzYfbt6wLZhTlQ
 Wt11ewmqb6E.Vpq0FvH_PGcK07Ijs8HAx31NZTaO7NTFprOkJzLbSRHuu1Ok
 0MGrtTUrMqkVcZLXrbFAGlZ0WFRtw8iF3G8.bXuJTxM_wp4ANYuTfUO1eJjN
 I5J9PRREiYOhRyhQg2FlJTOi1Tv0EM4uW5.xZU4oZXkqPyZ._j4dVZqzrIBY
 VKsjf73___fs3diR_pQ--
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
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 03/11] libiscsi: Remove host_lock unlock() + lock() from iscsi_queuecommand()
Date: Fri, 17 Sep 2010 11:22:08 -0700
Message-Id: <1284747728-20900-1-git-send-email-nab@linux-iscsi.org>
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
1.7.2.3

