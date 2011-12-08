Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1LHAn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:43:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:13722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab1LHAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="84754689"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        davej@redhat.com, axboe@kernel.dk, hpa@zytor.com,
        herbert@gondor.hengli.com.au, ying.huang@intel.com
Subject: [PATCH 02/10] crypto: Add support for x86 cpuid auto loading for x86 crypto drivers
Date: Wed,  7 Dec 2011 16:41:15 -0800
Message-Id: <1323304882-27953-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for auto-loading of crypto drivers based on cpuid features.
This enables auto-loading of the VIA and Intel specific drivers
for AES, hashing and CRCs.

Requires the earlier infrastructure patch to add x86 modinfo.
I kept it all in a single patch for now.

I dropped the printks when the driver cpuid doesn't match (imho
drivers never should print anything in such a case)

One drawback is that udev doesn't know if the drivers are used or not,
so they will be unconditionally loaded at boot up. That's better
than not loading them at all, like it often happens.

Cc: davej@redhat.com
Cc: trenn@suse.de
Cc: kay.sievers@vrfy.org
Cc: axboe@kernel.dk
Cc: hpa@zytor.com
Cc: herbert@gondor.apana.org.au
Cc: ying.huang@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c         |   12 +++++++++---
 arch/x86/crypto/crc32c-intel.c             |   11 ++++++++---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   12 ++++++++----
 drivers/crypto/padlock-aes.c               |    9 ++++++++-
 drivers/crypto/padlock-sha.c               |   16 ++++++++--------
 5 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 545d0ce..4a34a77 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -28,6 +28,7 @@
 #include <crypto/aes.h>
 #include <crypto/cryptd.h>
 #include <crypto/ctr.h>
+#include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 #include <asm/aes.h>
 #include <crypto/scatterwalk.h>
@@ -1253,14 +1254,19 @@ static struct crypto_alg __rfc4106_alg = {
 };
 #endif
 
+
+static struct x86_cpu_id aesni_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_AES),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
+
 static int __init aesni_init(void)
 {
 	int err;
 
-	if (!cpu_has_aes) {
-		printk(KERN_INFO "Intel AES-NI instructions are not detected.\n");
+	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
-	}
 
 	if ((err = crypto_fpu_init()))
 		goto fpu_err;
diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel.c
index b9d0026..0fe11a9 100644
--- a/arch/x86/crypto/crc32c-intel.c
+++ b/arch/x86/crypto/crc32c-intel.c
@@ -31,6 +31,7 @@
 #include <crypto/internal/hash.h>
 
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
@@ -173,13 +174,17 @@ static struct shash_alg alg = {
 	}
 };
 
+static struct x86_cpu_id crc32c_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_XMM4_2),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
 
 static int __init crc32c_intel_mod_init(void)
 {
-	if (cpu_has_xmm4_2)
-		return crypto_register_shash(&alg);
-	else
+	if (!x86_match_cpu(crc32c_cpu_id))
 		return -ENODEV;
+	return crypto_register_shash(&alg);
 }
 
 static void __exit crc32c_intel_mod_fini(void)
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 976aa64..4d5b128 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -20,6 +20,7 @@
 #include <crypto/gf128mul.h>
 #include <crypto/internal/hash.h>
 #include <asm/i387.h>
+#include <asm/cpu_device_id.h>
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -294,15 +295,18 @@ static struct ahash_alg ghash_async_alg = {
 	},
 };
 
+static struct x86_cpu_id pcmul_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ), /* Pickle-Mickle-Duck */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
+
 static int __init ghash_pclmulqdqni_mod_init(void)
 {
 	int err;
 
-	if (!cpu_has_pclmulqdq) {
-		printk(KERN_INFO "Intel PCLMULQDQ-NI instructions are not"
-		       " detected.\n");
+	if (!x86_match_cpu(pcmul_cpu_id))
 		return -ENODEV;
-	}
 
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 29b9469..37b2e94 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -19,6 +19,7 @@
 #include <linux/percpu.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
+#include <asm/cpu_device_id.h>
 #include <asm/byteorder.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
@@ -503,12 +504,18 @@ static struct crypto_alg cbc_aes_alg = {
 	}
 };
 
+static struct x86_cpu_id padlock_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_XCRYPT),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, padlock_cpu_id);
+
 static int __init padlock_init(void)
 {
 	int ret;
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
-	if (!cpu_has_xcrypt)
+	if (!x86_match_cpu(padlock_cpu_id))
 		return -ENODEV;
 
 	if (!cpu_has_xcrypt_enabled) {
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 06bdb4b..9266c0e 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
+#include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 
 struct padlock_sha_desc {
@@ -526,6 +527,12 @@ static struct shash_alg sha256_alg_nano = {
 	}
 };
 
+static struct x86_cpu_id padlock_sha_ids[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_PHE),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, padlock_sha_ids);
+
 static int __init padlock_init(void)
 {
 	int rc = -ENODEV;
@@ -533,15 +540,8 @@ static int __init padlock_init(void)
 	struct shash_alg *sha1;
 	struct shash_alg *sha256;
 
-	if (!cpu_has_phe) {
-		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not detected.\n");
-		return -ENODEV;
-	}
-
-	if (!cpu_has_phe_enabled) {
-		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+	if (!x86_match_cpu(padlock_sha_ids) || !cpu_has_phe_enabled)
 		return -ENODEV;
-	}
 
 	/* Register the newly added algorithm module if on *
 	* VIA Nano processor, or else just do as before */
-- 
1.7.4.4

