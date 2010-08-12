Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab0HLAJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:09:21 -0400
Received: from kroah.org ([198.145.64.141]:48005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab0HLAJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:09:07 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.764932351@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Shishkin <virtuoso@slind.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [66/67] crypto: testmgr - add an option to disable cryptoalgos self-tests
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Shishkin <virtuoso@slind.org>

commit 0b767f96164b2b27488e3daa722ff16e89d49314 upstream.

By default, CONFIG_CRYPTO_MANAGER_TESTS will be enabled and thus
self-tests will still run, but it is now possible to disable them
to gain some time during bootup.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/Kconfig   |    8 ++++++++
 crypto/algboss.c |    4 ++++
 crypto/testmgr.c |   14 ++++++++++++++
 3 files changed, 26 insertions(+)

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
@@ -273,8 +275,10 @@ static int cryptomgr_notify(struct notif
 	switch (msg) {
 	case CRYPTO_MSG_ALG_REQUEST:
 		return cryptomgr_schedule_probe(data);
+#ifdef CONFIG_CRYPTO_MANAGER_TESTS
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
+#endif
 	}
 
 	return NOTIFY_DONE;
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


