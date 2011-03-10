Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1CJIVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:21:37 -0500
Received: from nm20-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.214]:41900 "HELO
	nm20-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752269Ab1CJIVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:21:30 -0500
X-Yahoo-Newman-Id: 998342.83933.bm@omp1015.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ruWPq_YVM1n3JWSjSg3T_KO7AyPLwdZQKZy_KzWOOjvPNou
 qAh2F7..pHJsdl0XuXn.hI1Ue3tSlyuThPz1iTPCtsqXwUatlHI6A5tddRcw
 caRSTC8Eb80nAsYaAlBAyQxU.DsxLD19fePGrWYLmhnBbRncJxx8.c43fLld
 Qt6q4VtGUuPgU9Bu2RsYCr7.nG2LK8dR7488tIRHoxbuMhAmnhhaLLwDSsHL
 Vtf.J9C2pXMFY5YIW7_NQdRTryoEkJH4XYP4m2drBrTQH24b7tOZMxSkMFfI
 XlCjaiRZFItaGhloWw6JFTw84tZadjA_mO.sg8pUW.sv7rJlpA5U.KQIZ74W
 oPohjo4Rt61YpTVbqukxUakDonDiCoR9_pOHRzK.PuTtC
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 2/2] crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel
Date: Thu, 10 Mar 2011 00:21:12 -0800
Message-Id: <1299745272-25477-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds crc32c_cra_check_optimized() for use by the new
struct crypto_alg->cra_check_optimized() API caller in order to
call request_module() to load crc32c_intel.ko for CRC32C instruction
offload when available on CONFIG_X86 w/ SSE v4.2 compatiable hardware.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/crc32c.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index de9e55c..3f1d3a3 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -44,6 +44,8 @@
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
 
+static int crc32c_offload_enabled;
+
 struct chksum_ctx {
 	u32 key;
 };
@@ -221,6 +223,24 @@ static int crc32c_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crc32c_cra_check_optimized(struct crypto_alg *alg)
+{
+	if (crc32c_offload_enabled)
+		return;
+#ifdef CONFIG_X86
+	/*
+	 * For cpu_has_xmm4_2 go ahead and load crc32c_intel.ko in order so
+	 * crypto_alloc_hash("crc32c", ...) will automatically use SSE v4.2
+	 * CRC32C instruction offload.
+	 */
+	if (cpu_has_xmm4_2) {
+		int rc = request_module("crc32c_intel");
+		if (rc == 0)
+			crc32c_offload_enabled = 1;
+	}
+#endif
+}
+
 static struct shash_alg alg = {
 	.digestsize		=	CHKSUM_DIGEST_SIZE,
 	.setkey			=	chksum_setkey,
@@ -239,11 +259,14 @@ static struct shash_alg alg = {
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	crc32c_cra_init,
+		.cra_check_optimized	=	crc32c_cra_check_optimized,
 	}
 };
 
 static int __init crc32c_mod_init(void)
 {
+	crc32c_offload_enabled = 0;
+
 	return crypto_register_shash(&alg);
 }
 
-- 
1.5.6.5

