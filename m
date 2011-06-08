Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1FHJEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:04:35 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59570 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1FHJDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C9zrXNeJRfIk9xLMB/CaGS6UwmQqA7PgPUdi7ZtwbGRhJfVpII9nWaVVt7GUq7iTXO
         1HavK54y31HRYR8bVodvSqtEWiyBV8Xu9u8fKUaKffJlrDgRgHvmRjzDudZMQu8+H1Nq
         ZkLv+ERG+n7FogWRjNd1WifBmG2P4r7EliOeE=
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [RFC v1 4/5] ksign: provides keyring to search in for the key
Date: Wed,  8 Jun 2011 12:03:19 +0300
Message-Id: <a428503ea101e27ddc039bffe9f0a2b8bbf68ef8.1307522457.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1307522457.git.dmitry.kasatkin@intel.com>
References: <cover.1307522457.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1307522457.git.dmitry.kasatkin@intel.com>
References: <cover.1307522457.git.dmitry.kasatkin@intel.com>
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

