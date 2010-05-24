Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0EXJgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 05:36:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32664 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0EXJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 05:36:38 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Alexander Shishkin <virtuoso@slind.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: [RFC][PATCH] crypto: disable tests when they are not enabled
Date: Mon, 24 May 2010 12:35:24 +0300
Message-Id: <1274693724-23831-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1.1.g15764
X-OriginalArrivalTime: 24 May 2010 09:35:57.0331 (UTC) FILETIME=[83467E30:01CAFB24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't compile in and don't schedule cryptomanager's tests when
CONFIG_CRYPTO_TESTS is not set. This saves quite some time during
kernel initialization.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-kernel@vger.kernel.org
CC: linux-crypto@vger.kernel.org
---
 crypto/algboss.c |    4 ++++
 crypto/testmgr.c |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index c3c196b..4814a44 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -206,6 +206,7 @@ err:
 	return NOTIFY_OK;
 }
 
+#ifdef CONFIG_CRYPTO_TEST
 static int cryptomgr_test(void *data)
 {
 	struct crypto_test_param *param = data;
@@ -266,6 +267,7 @@ err_put_module:
 err:
 	return NOTIFY_OK;
 }
+#endif /* CONFIG_CRYPTO_TEST */
 
 static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 			    void *data)
@@ -273,8 +275,10 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 	switch (msg) {
 	case CRYPTO_MSG_ALG_REQUEST:
 		return cryptomgr_schedule_probe(data);
+#ifdef CONFIG_CRYPTO_TEST
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
+#endif
 	}
 
 	return NOTIFY_DONE;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5c8aaa0..3529484 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -22,6 +22,17 @@
 #include <crypto/rng.h>
 
 #include "internal.h"
+
+#ifndef CONFIG_CRYPTO_TEST
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
+#endif
+
 EXPORT_SYMBOL_GPL(alg_test);
-- 
1.7.1.1.g15764

