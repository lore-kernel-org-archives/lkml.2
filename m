Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0IPWgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:36:15 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:35405 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756930Ab0IPWgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:36:13 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ecHZ6RMVM1k2yddIgMyrUiOa13HFMF2RSgFXwuTqZ9ANXUg
 wO9xantYhnZ6JXy._4IURRytvonbYGEDH.WZO0tl7mqTPle6MBjaRdIEaozM
 2ghxeE0I0567aNTu92ETJLGz9mUaY0u0LaafVjw_veJlFhbzqKdk.6uGMA_S
 CGqRJ3mk9JrGzBpCRW4_aWNyGK._r94ItX1aSHZsnwRJDNxYqbge9dW2nK22
 tgMZyPxtNROKC0OuqtmpPx4DrE6.ScnZyKFVkzMP0EuOvCLJUZq6EwsACK.F
 KFPPrwKXKmuPg_RwXl40tONaYobVX6aq41S.Ua.MQKw6Y58bqDuvhCq8J6Tj
 QLtztFOeCyvgfaa9hNw--
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
Subject: [PATCH 6/8] qla2xxx: Remove host_lock unlock() + lock() from qla2xxx_queuecommand()
Date: Thu, 16 Sep 2010 15:36:11 -0700
Message-Id: <1284676571-10854-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from qla_os.c:qla2xxx_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8c80b49..45c3d28 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -574,11 +574,9 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc24_target_busy;
 	}
 
-	spin_unlock_irq(vha->host->host_lock);
-
 	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
-		goto qc24_host_busy_lock;
+		goto qc24_host_busy;
 
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
@@ -592,8 +590,7 @@ qc24_host_busy_free_sp:
 	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
-qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
+qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
-- 
1.7.2.3

