Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab1DNRqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:38080 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab1DNRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alexander Shishkin <virtuoso@slind.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 013/209] crypto: testmgr - add an option to disable cryptoalgos' self-tests
Date: Thu, 14 Apr 2011 13:40:43 -0400
Message-Id: <1302803039-9400-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Shishkin <virtuoso@slind.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 0b767f96164b2b27488e3daa722ff16e89d49314 upstream.

By default, CONFIG_CRYPTO_MANAGER_TESTS will be enabled and thus
self-tests will still run, but it is now possible to disable them
to gain some time during bootup.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 crypto/Kconfig   |    8 ++++++++
 crypto/algboss.c |    4 ++++
 crypto/testmgr.c |   14 ++++++++++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 403857a..00f9341 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -96,6 +96,14 @@ config CRYPTO_MANAGER2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_PCOMP
 
+config CRYPTO_MANAGER_TESTS
+	bool "Run algolithms' self-tests"
+	default y
+	depends on CRYPTO_MANAGER2
+	help
+	  Run cryptomanager's tests for the new crypto algorithms being
+	  registered.
+
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/crypto/algboss.c b/crypto/algboss.c
index c3c196b..40bd391 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -206,6 +206,7 @@ err:
 	return NOTIFY_OK;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_TESTS
 static int cryptomgr_test(void *data)
 {
 	struct crypto_test_param *param = data;
@@ -266,6 +267,7 @@ err_put_module:
 err:
 	return NOTIFY_OK;
 }
+#endif /* CONFIG_CRYPTO_MANAGER_TESTS */
 
 static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 			    void *data)
@@ -273,8 +275,10 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 	switch (msg) {
 	case CRYPTO_MSG_ALG_REQUEST:
 		return cryptomgr_schedule_probe(data);
+#ifdef CONFIG_CRYPTO_MANAGER_TESTS
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
+#endif
 	}
 
 	return NOTIFY_DONE;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c494d76..73e8a46 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -22,6 +22,17 @@
 #include <crypto/rng.h>
 
 #include "internal.h"
+
+#ifndef CONFIG_CRYPTO_MANAGER_TESTS
+
+/* a perfect nop */
+int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+{
+	return 0;
+}
+
+#else
+
 #include "testmgr.h"
 
 /*
@@ -2500,4 +2511,7 @@ notest:
 non_fips_alg:
 	return -EINVAL;
 }
+
+#endif /* CONFIG_CRYPTO_MANAGER_TESTS */
+
 EXPORT_SYMBOL_GPL(alg_test);
-- 
1.7.4.4

