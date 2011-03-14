Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1CNLG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:06:29 -0400
Received: from nm16-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.210]:37906 "HELO
	nm16-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752783Ab1CNLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:06:26 -0400
X-Yahoo-Newman-Id: 694246.55340.bm@omp1022.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: r5pTwqQVM1lV5yL.4vCMDxLs7bIpLgXOAJejiTOBTuW41Ao
 BLWOOzLq_d7cnISjo2vT4ObyATlA_UdprawJTc5BlWE8mki.i0NFkZsQ8Vvh
 ElYHUC9f3s3mYp9yWz4UBMs1HtUJEn.D6yvUXrnAPYXpRJvUfui9Ho1PFW7h
 2rCvsm2oiQhHvg0ojxrY.9C.A5_OOk_GHh1A1z2xRlEFgq7XGn9gJt.aXxSq
 x4T1y4BwwMnwCrw6NsCw1_OYbmLYuT3qmLxRMmCDg6BtTlx0V2l4KBX4M.Az
 TS3Y2mTB5X0aguOTbazXthMoDRH4HDuZA0VYb9mFpxfvFT6eV1LdDkk_kyrj
 Aa2VLX134OhlNfS82Wa9IhFdRBNOsnx5_hJsLjlI7aIeDvsdQ68SFx5yckpu
 IHIgfGWfL53IcZw64aqaezPdqBkW2vsp4Y5jZNY4GcLP7P4KMU.fvUKSaXJH
 KPN3JUpVez4Z5_2a76PcKnPKY8YRKcXknDF4igJ5Wq1z7xTldd7xe8o59iID
 SCM9dp8VnaG1N5GqYO5II3bfeHvc-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Roland Dreier <rolandd@cisco.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/21] target: Fix memory leak on error path in pscsi_alloc_task
Date: Mon, 14 Mar 2011 04:05:55 -0700
Message-Id: <1300100775-10012-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rolandd@cisco.com>

If allocation of pt->pscsi_cdb fails, we need to free the just-allocated
pt or else it will be leaked.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f2a0847..f596cb7 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -817,6 +817,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 		if (!(pt->pscsi_cdb)) {
 			printk(KERN_ERR "pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
+			kfree(pt);
 			return NULL;
 		}
 	} else
-- 
1.7.4.1

