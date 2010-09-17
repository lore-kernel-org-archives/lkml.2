Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0IQSWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:22:53 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:40027 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755919Ab0IQSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:51 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 7azA2FoVM1l1olAhzfYu9V6FzRKfGg2E7GDtW8yJFKNFCTb
 dPeSsltAEDeeaqFbocFMBiZKfUaNOpsvkJ2fWA8qLM4KEx7a6wyVJdnGGVcG
 JTFcZSYQEE5a9N1MXhIuqY3CoHxAbjL1qEvbca1obu29L6KkglyTsgjPQpXQ
 DHNvOS3XnEU3f_HIDfbbUW6oZMswZLaIspvYml20DHIzc26sNN0Lc_.0C.3f
 lk7v723cw_LS7SxDpGenrPMaPigLbP3ltqkJxQ.5V9FM5u1Jk5.wJ9Q.jdci
 PvipdVRMhUS9_40DEcakYdcwHpqssISxWb5Akp2xbHUnyWPBX6EomZxhHzZj
 imAiO8FMzBcrG6BcwZuCDv6DsOEdrQKJkYF9PDPRnGvu5tq9MXHXZRx17Gn8
 o_I2hRhBw_9Rdohjdg66OJhNZCCjNTEQlzrOidioDKaFNjEw1oSJ8JfUmW0v
 hfya9cg8avVX8
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
Subject: [PATCH v2 07/11] lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
Date: Fri, 17 Sep 2010 11:22:45 -0700
Message-Id: <1284747765-20976-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from lpfc_scsi.c:lpfc_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2e51aa6..4b085f6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3023,11 +3023,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_unlock(shost->host_lock);
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
-		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
-- 
1.7.2.3

