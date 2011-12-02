Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1LBSon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:44:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab1LBSol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:44:41 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/21] KEYS: DSA signature verification algorithm [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:44:31 +0000
Message-ID: <20111202184431.21874.52240.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the DSA algorithm (FIPS-186).  At this time, only signature
verification is supported.  This uses the asymmetric public key subtype to hold
its key data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/Kconfig      |    7 ++
 security/keys/Makefile     |    1 
 security/keys/crypto_dsa.c |  126 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 security/keys/crypto_dsa.c


diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 07c7f3b..76de2ba 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -86,3 +86,10 @@ config CRYPTO_KEY_PUBLIC_KEY_SUBTYPE
 	  If signature generation and/or verification are to be used,
 	  appropriate hash algorithms (such as SHA-1) must be available.
 	  ENOPKG will be reported if the requisite algorithm is unavailable.
+
+config CRYPTO_KEY_PKEY_ALGO_DSA
+	tristate "DSA public-key algorithm"
+	depends on CRYPTO_KEY_PUBLIC_KEY_SUBTYPE
+	help
+	  This option enables support for the DSA public key algorithm
+	  (FIPS-186).
diff --git a/security/keys/Makefile b/security/keys/Makefile
index dc3281f..5f1c627 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
 obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
 obj-$(CONFIG_CRYPTO_KEY_PUBLIC_KEY_SUBTYPE) += public_key.o
+obj-$(CONFIG_CRYPTO_KEY_PKEY_ALGO_DSA) += crypto_dsa.o
 
 crypto_keys-y := crypto_type.o crypto_verify.o
diff --git a/security/keys/crypto_dsa.c b/security/keys/crypto_dsa.c
new file mode 100644
index 0000000..26b86f2
--- /dev/null
+++ b/security/keys/crypto_dsa.c
@@ -0,0 +1,126 @@
+/* DSA asymmetric public-key algorithm
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "DSA: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "public_key.h"
+
+MODULE_LICENSE("GPL");
+
+#define kenter(FMT, ...) \
+	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
+
+/*
+ * Perform the actual mathematical DSA signature verification.
+ */
+static int DSA_verify(const MPI datahash,
+		      const struct public_key_signature *sig,
+		      const struct public_key *key)
+{
+	MPI w = NULL, u1 = NULL, u2 = NULL, v = NULL;
+	MPI base[3];
+	MPI exp[3];
+	int rc;
+
+	kenter("");
+
+	if (!(mpi_cmp_ui(sig->dsa.r, 0) > 0 &&
+	      mpi_cmp(sig->dsa.r, key->dsa.q) < 0)) {
+		pr_warning("Assertion failed [0 < r < q]\n");
+		return -EKEYREJECTED;
+	}
+
+	if (!(mpi_cmp_ui(sig->dsa.s, 0) > 0 &&
+	      mpi_cmp(sig->dsa.s, key->dsa.q) < 0)) {
+		pr_warning("Assertion failed [0 < s < q]\n");
+		return -EKEYREJECTED;
+	}
+
+	rc = -ENOMEM;
+	w  = mpi_alloc(mpi_get_nlimbs(key->dsa.q)); if (!w ) goto cleanup;
+	u1 = mpi_alloc(mpi_get_nlimbs(key->dsa.q)); if (!u1) goto cleanup;
+	u2 = mpi_alloc(mpi_get_nlimbs(key->dsa.q)); if (!u2) goto cleanup;
+	v  = mpi_alloc(mpi_get_nlimbs(key->dsa.p)); if (!v ) goto cleanup;
+
+	/* w = s^(-1) mod q */
+	if (mpi_invm(w, sig->dsa.s, key->dsa.q) < 0)
+		goto cleanup;
+
+	/* u1 = (datahash * w) mod q */
+	if (mpi_mulm(u1, datahash, w, key->dsa.q) < 0)
+		goto cleanup;
+
+	/* u2 = r * w mod q  */
+	if (mpi_mulm(u2, sig->dsa.r, w, key->dsa.q) < 0)
+		goto cleanup;
+
+	/* v =  g^u1 * y^u2 mod p mod q */
+	base[0] = key->dsa.g;	exp[0] = u1;
+	base[1] = key->dsa.y;	exp[1] = u2;
+	base[2] = NULL;		exp[2] = NULL;
+
+	if (mpi_mulpowm(v, base, exp, key->dsa.p) < 0)
+		goto cleanup;
+
+	if (mpi_fdiv_r(v, v, key->dsa.q) < 0)
+		goto cleanup;
+
+	rc = (mpi_cmp(v, sig->dsa.r) == 0) ? 0 : -EKEYREJECTED;
+
+cleanup:
+	mpi_free(w);
+	mpi_free(u1);
+	mpi_free(u2);
+	mpi_free(v);
+	kleave(" = %d", rc);
+	return rc;
+}
+
+/*
+ * Perform the verification step.
+ */
+static int DSA_verify_signature(const struct public_key *key,
+				const struct public_key_signature *sig)
+{
+	MPI datahash = NULL;
+	int ret;
+
+	kenter("");
+
+	ret = -ENOMEM;
+	datahash = mpi_alloc((sig->digest_size + BYTES_PER_MPI_LIMB - 1) /
+			     BYTES_PER_MPI_LIMB);
+	if (!datahash)
+		goto error;
+
+	ret = mpi_set_buffer(datahash, sig->digest, sig->digest_size, 0);
+	if (ret < 0)
+		goto error;
+
+	ret = DSA_verify(datahash, sig, key);
+
+error:
+	mpi_free(datahash);
+	kleave(" = %d", ret);
+	return ret;
+}
+
+const struct public_key_algorithm DSA_public_key_algorithm = {
+	.name		= "DSA",
+	.n_pub_mpi	= 4,
+	.n_sec_mpi	= 1,
+	.n_sig_mpi	= 2,
+	.verify		= DSA_verify_signature,
+};
+EXPORT_SYMBOL_GPL(DSA_public_key_algorithm);

