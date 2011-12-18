Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1LRWXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:23:52 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39227 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222Ab1LRWXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:23:47 -0500
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: Remove global #define PFX and use, use pr_<level>
Date: Sun, 18 Dec 2011 14:23:40 -0800
Message-Id: <b18a29f3f4217c311ff672a4ffb0bdadd2f6930d.1324246975.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PFX is not a good #define to have in a system #include.
Use pr_fmt and pr_<level> instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hw_random/via-rng.c |   12 ++++++------
 drivers/crypto/padlock-aes.c     |   10 ++++++----
 drivers/crypto/padlock-sha.c     |   14 ++++++++------
 include/crypto/padlock.h         |    2 --
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index d0387a8..c4a7f11 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -24,6 +24,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -140,8 +142,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * register */
 	if ((c->x86 == 6) && (c->x86_model >= 0x0f)) {
 		if (!cpu_has_xstore_enabled) {
-			printk(KERN_ERR PFX "can't enable hardware RNG "
-				"if XSTORE is not enabled\n");
+			pr_err("can't enable hardware RNG if XSTORE is not enabled\n");
 			return -ENODEV;
 		}
 		return 0;
@@ -179,7 +180,7 @@ static int via_rng_init(struct hwrng *rng)
 	   unneeded */
 	rdmsr(MSR_VIA_RNG, lo, hi);
 	if ((lo & VIA_RNG_ENABLE) == 0) {
-		printk(KERN_ERR PFX "cannot enable VIA C3 RNG, aborting\n");
+		pr_err("cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
 	}
 
@@ -201,11 +202,10 @@ static int __init mod_init(void)
 
 	if (!cpu_has_xstore)
 		return -ENODEV;
-	printk(KERN_INFO "VIA RNG detected\n");
+	pr_info("VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {
-		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
-		       err);
+		pr_err("RNG registering failed (%d)\n", err);
 		goto out;
 	}
 out:
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 29b9469..0dad679 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -7,6 +7,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/padlock.h>
@@ -512,7 +514,7 @@ static int __init padlock_init(void)
 		return -ENODEV;
 
 	if (!cpu_has_xcrypt_enabled) {
-		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+		pr_notice("VIA PadLock detected, but not enabled. Hmm, strange...\n");
 		return -ENODEV;
 	}
 
@@ -525,12 +527,12 @@ static int __init padlock_init(void)
 	if ((ret = crypto_register_alg(&cbc_aes_alg)))
 		goto cbc_aes_err;
 
-	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
+	pr_notice("Using VIA PadLock ACE for AES algorithm\n");
 
 	if (c->x86 == 6 && c->x86_model == 15 && c->x86_mask == 2) {
 		ecb_fetch_blocks = MAX_ECB_FETCH_BLOCKS;
 		cbc_fetch_blocks = MAX_CBC_FETCH_BLOCKS;
-		printk(KERN_NOTICE PFX "VIA Nano stepping 2 detected: enabling workaround.\n");
+		pr_notice("VIA Nano stepping 2 detected: enabling workaround\n");
 	}
 
 out:
@@ -541,7 +543,7 @@ cbc_aes_err:
 ecb_aes_err:
 	crypto_unregister_alg(&aes_alg);
 aes_err:
-	printk(KERN_ERR PFX "VIA PadLock AES initialization failed.\n");
+	pr_err("VIA PadLock AES initialization failed\n");
 	goto out;
 }
 
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 06bdb4b..dad4585 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/internal/hash.h>
 #include <crypto/padlock.h>
 #include <crypto/sha.h>
@@ -219,8 +221,8 @@ static int padlock_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
-		       fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
@@ -534,12 +536,12 @@ static int __init padlock_init(void)
 	struct shash_alg *sha256;
 
 	if (!cpu_has_phe) {
-		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not detected.\n");
+		pr_notice("VIA PadLock Hash Engine not detected\n");
 		return -ENODEV;
 	}
 
 	if (!cpu_has_phe_enabled) {
-		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+		pr_notice("VIA PadLock detected, but not enabled. Hmm, strange...\n");
 		return -ENODEV;
 	}
 
@@ -561,7 +563,7 @@ static int __init padlock_init(void)
 	if (rc)
 		goto out_unreg1;
 
-	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for SHA1/SHA256 algorithms.\n");
+	pr_notice("Using VIA PadLock ACE for SHA1/SHA256 algorithms\n");
 
 	return 0;
 
@@ -569,7 +571,7 @@ out_unreg1:
 	crypto_unregister_shash(sha1);
 
 out:
-	printk(KERN_ERR PFX "VIA PadLock SHA1/SHA256 initialization failed.\n");
+	pr_err("VIA PadLock SHA1/SHA256 initialization failed\n");
 	return rc;
 }
 
diff --git a/include/crypto/padlock.h b/include/crypto/padlock.h
index d2cfa2e..4245f86 100644
--- a/include/crypto/padlock.h
+++ b/include/crypto/padlock.h
@@ -15,8 +15,6 @@
 
 #define PADLOCK_ALIGNMENT 16
 
-#define PFX	KBUILD_MODNAME ": "
-
 #define PADLOCK_CRA_PRIORITY	300
 #define PADLOCK_COMPOSITE_PRIORITY 400
 
-- 
1.7.8.111.gad25c.dirty

