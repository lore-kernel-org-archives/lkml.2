Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1HKR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:28:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:54960 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235Ab1HKR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:28:50 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 13:28:50 EDT
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [RFC v1.1 4/5] ksign: provides keyring to search in for the key
Date: Thu, 11 Aug 2011 20:20:07 +0300
Message-Id: <4c951bf4dee72c54f2718ee0e1b15900106946da.1313082284.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Allows to specify keyring to search in for the key. Later patches
will use special keyrings to store EVM and IMA public keys.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 crypto/ksign.c               |   17 ++++++++++++++---
 include/linux/crypto/ksign.h |    4 ++--
 security/integrity/evm/evm.h |    2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/crypto/ksign.c b/crypto/ksign.c
index 60ccfc9..ed355b7 100644
--- a/crypto/ksign.c
+++ b/crypto/ksign.c
@@ -183,7 +183,7 @@ err1:
 /*
  * Signature verification with public key
  */
-int ksign_verify(const char *sig, int siglen,
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		       const char *digest, int digestlen)
 {
 	int err = -ENOMEM;
@@ -201,10 +201,21 @@ int ksign_verify(const char *sig, int siglen,
 
 	sprintf(name, "%llX", __be64_to_cpup((uint64_t *)sh->keyid));
 
-	key = request_key(&key_type_user, name, NULL);
+	if (keyring) {
+		/* search in specific keyring */
+		key_ref_t kref;
+		kref = keyring_search(make_key_ref(keyring, 1UL),
+						&key_type_user, name);
+		if (IS_ERR(kref))
+			key = ERR_PTR(PTR_ERR(kref));
+		else
+			key = key_ref_to_ptr(kref);
+	} else {
+		key = request_key(&key_type_user, name, NULL);
+	}
 	if (IS_ERR(key)) {
 		pr_err("key not found, id: %s\n", name);
-		return -ENOENT;
+		return PTR_ERR(key);
 	}
 
 	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
diff --git a/include/linux/crypto/ksign.h b/include/linux/crypto/ksign.h
index f1e47cb..ba23b2a 100644
--- a/include/linux/crypto/ksign.h
+++ b/include/linux/crypto/ksign.h
@@ -32,12 +32,12 @@ struct signature_hdr {
 
 #ifdef CONFIG_CRYPTO_KSIGN
 
-int ksign_verify(const char *sig, int siglen,
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		 const char *digest, int digestlen);
 
 #else
 
-static inline int ksign_verify(const char *sig, int siglen,
+static inline int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		 const char *digest, int digestlen)
 {
 	return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 6d297a1..9e1bcba 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -53,7 +53,7 @@ extern void evm_cleanup_secfs(void);
 static inline int evm_sign_verify(const char *sig, int siglen,
 		       const char *digest, int digestlen)
 {
-	return ksign_verify(sig, siglen, digest, digestlen);
+	return ksign_verify(NULL, sig, siglen, digest, digestlen);
 }
 
 #else
-- 
1.7.4.1

