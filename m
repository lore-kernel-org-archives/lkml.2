Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2HOSnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:43:32 -0400
Received: from mga05.intel.com ([192.55.52.89]:48176 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754928Ab2HOSn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:29 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 1/7] integrity: added digest calculation function
Date: Wed, 15 Aug 2012 21:43:06 +0300
Message-Id: <f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several functions, that need to calculate digest.
This patch adds common function for use by integrity subsystem.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/digsig.c    |   31 +++++++++++++++++++++++++++++--
 security/integrity/integrity.h |    3 +++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 2dc167d..61a0c92 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -13,9 +13,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
-#include <linux/rbtree.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <crypto/hash.h>
 
 #include "integrity.h"
 
@@ -28,7 +28,7 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 };
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
-					const char *digest, int digestlen)
+			    const char *digest, int digestlen)
 {
 	if (id >= INTEGRITY_KEYRING_MAX)
 		return -EINVAL;
@@ -46,3 +46,30 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 	return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
 }
+
+int integrity_calc_digest(const char *algo, const void *data, const int len,
+			  char *digest)
+{
+	int rc = -ENOMEM;
+	struct crypto_shash *tfm;
+
+	tfm = crypto_alloc_shash(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		rc = PTR_ERR(tfm);
+		pr_err("Can not allocate %s (reason: %d)\n", algo, rc);
+		return rc;
+	} else {
+		struct {
+			struct shash_desc shash;
+			char ctx[crypto_shash_descsize(tfm)];
+		} desc;
+
+		desc.shash.tfm = tfm;
+		desc.shash.flags = 0;
+
+		rc = crypto_shash_digest(&desc.shash, data, len, digest);
+	}
+
+	crypto_free_shash(tfm);
+	return rc;
+}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index e21362a..48ee2d4 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -59,6 +59,9 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
+int integrity_calc_digest(const char *algo, const void *data, const int len,
+			  char *digest);
+
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen);
 
-- 
1.7.9.5

