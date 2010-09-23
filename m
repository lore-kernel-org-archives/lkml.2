Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0IWXip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:38:45 -0400
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:46556 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756559Ab0IWXim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:38:42 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: BNpO9o8VM1mQ9waNvkIslU8A2VPVx3Wp6krC4cXANwXmBo8
 9sZEKEKoaNxlxqUCmgPqLfsPu_ylsruKX.cn0ceHHIpKI7JzVIomiTCuAv1w
 CBTSl7erOKg5bTRlPEuTDHy5QMaK5YxQo9kum3OkJ9LG8VrGO4DmVIYIfnNn
 QwA13u58BW9YuTqB7pG1axKGE3q1fZQtITRCkpnf1eCstQje48ygcdycgJL3
 MliNqvyikv7N_3.LmNx2HdqK5SD1NXTx6wQAnRoR8zxERLgAEq9VoQll4qfX
 26gMavTffr1HuoivUZE7MNtHuuHanSjUpi.oMuoTCemdaNNGS7w2Q1if1Kuw
 UTVwGVJ8C2cjmyRfOOmAl1tIYorH7dLPZtc3.Zgr7VSnHJRICcCJzforwHp9
 SnFDYsab5aGFbL6hvZORyRSiXvURtQYbo3Til3d.ET1NcvtjvQKstuo2c3IX
 QvLf1hAG.jYdW
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
Subject: [RFC v3 08/15] qla2xxx: Remove host_lock unlock() + lock() from qla2xxx_queuecommand()
Date: Thu, 23 Sep 2010 16:38:37 -0700
Message-Id: <1285285117-16491-1-git-send-email-nab@linux-iscsi.org>
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
index 1e4bff6..b30310f 100644
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
1.7.3

