Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0EZJ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:29:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60094 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0EZJ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:29:53 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Alexander Shishkin <virtuoso@slind.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: add an option to disable cryptoalgos' self-tests
Date: Wed, 26 May 2010 12:28:34 +0300
Message-Id: <1274866114-15817-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1.1.g15764
In-Reply-To: <20100526004357.GE20073@gondor.apana.org.au>
References: <20100526004357.GE20073@gondor.apana.org.au>
X-OriginalArrivalTime: 26 May 2010 09:29:06.0002 (UTC) FILETIME=[E2EE2B20:01CAFCB5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, CONFIG_CRYPTO_MANAGER_TESTS will be enabled and thus
self-tests will still run, but it is now possible to disable them
to gain some time during bootup.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-kernel@vger.kernel.org
CC: linux-crypto@vger.kernel.org
---
 crypto/Kconfig   |    8 ++++++++
 crypto/algboss.c |    4 ++++
 crypto/testmgr.c |   14 ++++++++++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9d9434f..df332c1 100644
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
index 5c8aaa0..abd980c 100644
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
@@ -2530,4 +2541,7 @@ notest:
 non_fips_alg:
 	return -EINVAL;
 }
+
+#endif /* CONFIG_CRYPTO_MANAGER_TESTS */
+
 EXPORT_SYMBOL_GPL(alg_test);
-- 
1.5.6.5

