Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0IVUaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:30:35 -0400
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:35965 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755353Ab0IVUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:30:31 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Er2.Uy8VM1mcUKUFlAh6kzcWJWchaZpK5T_lCbE3PsRnNuA
 Q2vxMBybmLbmPa9zXXAecv.Ggs3iCA4aoMViUtVfgw5ZHt5L7wJ8n8GmdhH1
 GejG8bYdlB7sxnlLBpFovqO2nKYzBYlRvsVCyDTjSRKWsLqepiPjdS.Mq6bq
 CMGvttamg1zmw.UDEhtq0YeiQ0oPvZStKhrMOKXUO3cS7a8rBpHb2s6Sf_8v
 B_NPnS6eORMtFLG5jK1hBZY6VXeG8krhX2MAX2vcAgSEGKDgiZS61NLHFRwn
 hYX29J65QJ0krfFzaziil5Q30LM547RDr3Qw0Dpuy1bnfDxNjy0uliCzc
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
Cc: David Miller <davem@davemloft.net>, Matthew Wilcox <willy@linux.intel.com>,
        Andi Keen <ak@linux.intel.com>, Roland Dreier <rdreier@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/2] siw: Add support for CRC32C offload instruction using libcrypto crc32c-intel
Date: Wed, 22 Sep 2010 13:30:25 -0700
Message-Id: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates siw_create_qp() to check for the CONFIG_X86 + cpu_has_xmm4_2
dependent use of the CRC32C instruction offload using libcrypto crc32c-intel.ko.
This patch will by default use crc32c-intel when available, and fall back to the
legacy slicing by 1x libcrypto crc32c.ko code when the instruction offload is not
availabe.

Because of the ability to selectively use c_tx->crc_enabled and c_rx->crc_enabled,
this patch has to use a handful of less than appealing goto's in order to handle the
default case where the offload is enabled by default, the crc32c-intel module is
not available and we need to fall back to slicing by 1x crc32c.ko, or we need to
fail all together.

Note that this code has only been compile tested so far, but a similar patch
to LIO-Target (w/o the selectively use of TX/RX checksums) to use crc32c-intel.ko
instruction offload is available here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=c92ef80235302a1f891f636691c928c3bb4e9ac1

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 softiwarp/siw_verbs.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/softiwarp/siw_verbs.c b/softiwarp/siw_verbs.c
index 27e2e5e..00ac03c 100644
--- a/softiwarp/siw_verbs.c
+++ b/softiwarp/siw_verbs.c
@@ -348,7 +348,7 @@ struct ib_qp *siw_create_qp(struct ib_pd *ofa_pd, struct ib_qp_init_attr *attrs,
 	struct siw_iwarp_rx		*c_rx;
 	struct siw_uresp_create_qp	uresp;
 
-	int rv = 0;
+	int rv = 0, crc32c_offload = 1;
 
 	dprint(DBG_OBJ|DBG_CM, ": new QP on device %s\n",
 		ofa_dev->name);
@@ -460,6 +460,23 @@ struct ib_qp *siw_create_qp(struct ib_pd *ofa_pd, struct ib_qp_init_attr *attrs,
 	c_tx->crc_enabled = c_rx->crc_enabled = CONFIG_RDMA_SIW_CRC_ENFORCED;
 
 	if (c_tx->crc_enabled) {
+#ifdef CONFIG_X86
+		/*
+		 * Check for the Nehalem optimized crc32c-intel instructions
+		 * This is only currently available while running on bare-metal,
+		 * and is not yet available with QEMU-KVM guests.
+		 */
+		if (cpu_has_xmm4_2 && crc32c_offload) {
+			c_tx->mpa_crc_hd.tfm = crypto_alloc_hash("crc32c-intel",
+						0, CRYPTO_ALG_ASYNC);
+			if (IS_ERR(c_tx->mpa_crc_hd.tfm)) {
+				crc32c_offload = 0;
+				goto check_legacy_tx;
+			}
+			goto check_rx;
+		}
+check_legacy_tx:
+#endif /* CONFIG_X86 */
 		c_tx->mpa_crc_hd.tfm =
 			crypto_alloc_hash("crc32c", 0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(c_tx->mpa_crc_hd.tfm)) {
@@ -469,7 +486,24 @@ struct ib_qp *siw_create_qp(struct ib_pd *ofa_pd, struct ib_qp_init_attr *attrs,
 			goto remove_qp;
 		}
 	}
+check_rx:
 	if (c_rx->crc_enabled) {
+#ifdef CONFIG_X86
+		/*
+		 * Check for the Nehalem optimized crc32c-intel instructions
+		 * This is only currently available while running on bare-metal,
+		 * and is not yet available with QEMU-KVM guests.
+		 */
+		if (cpu_has_xmm4_2 && crc32c_offload) {
+			c_rx->mpa_crc_hd.tfm = crypto_alloc_hash("crc32c-intel",
+						0, CRYPTO_ALG_ASYNC);
+			if (IS_ERR(c_rx->mpa_crc_hd.tfm))
+				goto check_legacy_rx;
+
+			goto after_crc32c;
+		}
+check_legacy_rx:
+#endif /* CONFIG_X86 */
 		c_rx->mpa_crc_hd.tfm =
 			crypto_alloc_hash("crc32c", 0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(c_rx->mpa_crc_hd.tfm)) {
@@ -478,6 +512,7 @@ struct ib_qp *siw_create_qp(struct ib_pd *ofa_pd, struct ib_qp_init_attr *attrs,
 			goto remove_qp;
 		}
 	}
+after_crc32c:
 	atomic_set(&qp->tx_ctx.in_use, 0);
 
 	qp->ofa_qp.qp_num = QP_ID(qp);
-- 
1.5.6.5

