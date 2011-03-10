Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1CJIVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:21:31 -0500
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:34448 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752242Ab1CJIV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:21:28 -0500
X-Yahoo-Newman-Id: 237161.99175.bm@omp1051.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: NdDzVkQVM1kQekEGu4wCqvJMIPEkWb1ydwdsTg7rgYJbGnI
 WTz.ufoFZrr17fbOa5mPn49GKJE5d.Tb9qqGOMggpyvuSY0bm9WSaDb2iqa7
 fJ3IBK6o5DCKJAVeP00uzJMQTurfoxlIPMXbj1mUMX5vl.KUhxjNW5nJ55Me
 7i76jLw1fi85SMQb8FvF8OJPm5.vSoVaqlqO4xSLc29oE4ECPYpyinVxOjD7
 ffjzbiKisPJnJXNtMU2nfLzhfMkca.tnazEpT8W2yrr.V7w.30bGkPEBeehS
 Xfq_a1iL_cdMzDiFwwZI_go7_F_t4s5u7G.s0drA-
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
Subject: [PATCH 1/2] crypto: Add struct crypto_alg->cra_check_optimized
Date: Thu, 10 Mar 2011 00:21:11 -0800
Message-Id: <1299745272-25477-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds an optional struct crypto_alg->cra_check_optimized() caller
that can be used by libcrypto algorithms in order to load an architecture
dependent optimized / HW offload module.

This includes adding the call to alg->cra_check_optimized() inside of
crypto_larval_lookup() once the initial generic algorithm has been
loaded via request_module().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/api.c           |    6 +++++-
 include/linux/crypto.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..4dcbef6 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -226,8 +226,12 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 		alg = crypto_alg_lookup(name, type, mask);
 	}
 
-	if (alg)
+	if (alg) {
+		if (alg->cra_check_optimized)
+			alg->cra_check_optimized(alg);
+
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
+	}
 
 	return crypto_larval_add(name, type, mask);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a6a7a1c..ea7c426 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -295,6 +295,7 @@ struct crypto_alg {
 
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
+	void (*cra_check_optimized)(struct crypto_alg *alg);
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
-- 
1.5.6.5

