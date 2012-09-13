Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab2IMXwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759153Ab2IMXtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:20 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/16] KEYS: Provide signature verification with an asymmetric
 key
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:49:06 +0100
Message-ID: <20120913234906.3575.85399.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide signature verification using an asymmetric-type key to indicate the
public key to be used.

The API is a single function that can be found in crypto/public_key.h:

	int verify_signature(const struct key *key,
			     const struct public_key_signature *sig)

The first argument is the appropriate key to be used and the second argument
is the parsed signature data:

	struct public_key_signature {
		u8 *digest;
		u16 digest_size;
		enum pkey_hash_algo pkey_hash_algo : 8;
		union {
			MPI mpi[2];
			struct {
				MPI s;		/* m^d mod n */
			} rsa;
			struct {
				MPI r;
				MPI s;
			} dsa;
		};
	};

This should be filled in prior to calling the function.  The hash algorithm
should already have been called and the hash finalised and the output should
be in a buffer pointed to by the 'digest' member.

Any extra data to be added to the hash by the hash format (eg. PGP) should
have been added by the caller prior to finalising the hash.

It is assumed that the signature is made up of a number of MPI values.  If an
algorithm becomes available for which this is not the case, the above structure
will have to change.

It is also assumed that it will have been checked that the signature algorithm
matches the key algorithm.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/Makefile    |    2 +
 crypto/asymmetric_keys/signature.c |   49 ++++++++++++++++++++++++++++++++++++
 include/crypto/public_key.h        |    4 +++
 3 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 crypto/asymmetric_keys/signature.c


diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 5ed46ee..8dcdf0c 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -4,6 +4,6 @@
 
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 
-asymmetric_keys-y := asymmetric_type.o
+asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
new file mode 100644
index 0000000..50b3f88
--- /dev/null
+++ b/crypto/asymmetric_keys/signature.c
@@ -0,0 +1,49 @@
+/* Signature verification with an asymmetric key
+ *
+ * See Documentation/security/asymmetric-keys.txt
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <keys/asymmetric-subtype.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <crypto/public_key.h>
+#include "asymmetric_keys.h"
+
+/**
+ * verify_signature - Initiate the use of an asymmetric key to verify a signature
+ * @key: The asymmetric key to verify against
+ * @sig: The signature to check
+ *
+ * Returns 0 if successful or else an error.
+ */
+int verify_signature(const struct key *key,
+		     const struct public_key_signature *sig)
+{
+	const struct asymmetric_key_subtype *subtype;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return -EINVAL;
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype ||
+	    !key->payload.data)
+		return -EINVAL;
+	if (!subtype->verify_signature)
+		return -ENOTSUPP;
+
+	ret = subtype->verify_signature(key, sig);
+
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(verify_signature);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 65d9879..eb25eb2 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -106,4 +106,8 @@ struct public_key_signature {
 	};
 };
 
+struct key;
+extern int verify_signature(const struct key *key,
+			    const struct public_key_signature *sig);
+
 #endif /* _LINUX_PUBLIC_KEY_H */

