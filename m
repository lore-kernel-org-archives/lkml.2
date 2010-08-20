Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0HTIu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HTIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:51 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 11/19] Add algorithm properties table.
Date: Fri, 20 Aug 2010 10:45:55 +0200
Message-Id: <1282293963-27807-13-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers to this table are used to identify algorithms throughout the
code.
---
 crypto/userspace/Makefile       |    2 +-
 crypto/userspace/ncr-sessions.c |  150 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+), 1 deletions(-)
 create mode 100644 crypto/userspace/ncr-sessions.c

diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
index 81e4122..0891c2b 100644
--- a/crypto/userspace/Makefile
+++ b/crypto/userspace/Makefile
@@ -64,7 +64,7 @@ TOMCRYPT_OBJECTS = libtomcrypt/misc/zeromem.o libtomcrypt/misc/crypt/crypt_argch
 	libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.o
 
 cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr-limits.o \
-	utils.o $(TOMMATH_OBJECTS) \
+	ncr-sessions.o utils.o $(TOMMATH_OBJECTS) \
 	$(TOMCRYPT_OBJECTS)
 
 
diff --git a/crypto/userspace/ncr-sessions.c b/crypto/userspace/ncr-sessions.c
new file mode 100644
index 0000000..e6fd995
--- /dev/null
+++ b/crypto/userspace/ncr-sessions.c
@@ -0,0 +1,150 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
+ * Portions Copyright (c) 2010 Phil Sutter
+ * 
+ * Author: Nikos Mavrogiannopoulos <nmav@gnutls.org>
+ *
+ * This file is part of linux cryptodev.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/audit.h>
+#include <linux/crypto.h>
+#include <linux/mutex.h>
+#include <linux/ncr.h>
+#include "ncr-int.h"
+#include <linux/mm_types.h>
+#include <linux/scatterlist.h>
+#include <net/netlink.h>
+
+static const struct algo_properties_st algo_properties[] = {
+#define KSTR(x) .kstr = x, .kstr_len = sizeof(x) - 1
+	{ .algo = NCR_ALG_NULL, KSTR("ecb(cipher_null)"),
+		.needs_iv = 0, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ KSTR("cbc(des3_ede)"),
+		.needs_iv = 1, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("cbc(aes)"),
+		.needs_iv = 1, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("cbc(camelia)"),
+		.needs_iv = 1, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("ctr(aes)"),
+		.needs_iv = 1, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("ctr(camelia)"),
+		.needs_iv = 1, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("ecb(aes)"),
+		.needs_iv = 0, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ KSTR("ecb(camelia)"),
+		.needs_iv = 0, .is_symmetric=1, .can_encrypt=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .algo = NCR_ALG_SHA1, KSTR("sha1"),
+		.digest_size = 20, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .algo = NCR_ALG_MD5, KSTR("md5"),
+		.digest_size = 16, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .algo = NCR_ALG_SHA2_224, KSTR("sha224"),
+		.digest_size = 28, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .algo = NCR_ALG_SHA2_256, KSTR("sha256"),
+		.digest_size = 32, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .algo = NCR_ALG_SHA2_384, KSTR("sha384"),
+		.digest_size = 48, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .algo = NCR_ALG_SHA2_512, KSTR("sha512"),
+		.digest_size = 64, .can_digest=1,
+		.key_type = NCR_KEY_TYPE_INVALID },
+	{ .is_hmac = 1, KSTR("hmac(sha1)"),
+		.digest_size = 20, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .is_hmac = 1, KSTR("hmac(md5)"),
+		.digest_size = 16, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .is_hmac = 1, KSTR("hmac(sha224)"),
+		.digest_size = 28, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .is_hmac = 1, KSTR("hmac(sha256)"),
+		.digest_size = 32, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .is_hmac = 1, KSTR("hmac(sha384)"),
+		.digest_size = 48, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	{ .is_hmac = 1, KSTR("hmac(sha512)"),
+		.digest_size = 64, .can_sign=1,
+		.key_type = NCR_KEY_TYPE_SECRET },
+	/* NOTE: These algorithm names are not available through the kernel API
+	   (yet). */
+	{ .algo = NCR_ALG_RSA, KSTR("rsa"), .is_pk = 1,
+		.can_encrypt=1, .can_sign=1, .key_type = NCR_KEY_TYPE_PUBLIC },
+	{ .algo = NCR_ALG_DSA, KSTR("dsa"), .is_pk = 1,
+		.can_sign=1, .key_type = NCR_KEY_TYPE_PUBLIC },
+	{ .algo = NCR_ALG_DH, KSTR("dh"), .is_pk = 1,
+		.can_kx=1, .key_type = NCR_KEY_TYPE_PUBLIC },
+#undef KSTR
+};
+
+/* The lookups by string are inefficient - can we look up all we need from
+   crypto API? */
+const struct algo_properties_st *_ncr_algo_to_properties(const char *algo)
+{
+	const struct algo_properties_st *a;
+	size_t name_len;
+
+	name_len = strlen(algo);
+	for (a = algo_properties;
+	     a < algo_properties + ARRAY_SIZE(algo_properties); a++) {
+		if (a->kstr_len == name_len
+		    && memcmp(a->kstr, algo, name_len) == 0)
+			return a;
+	}
+
+	return NULL;
+}
+
+const struct algo_properties_st *_ncr_nla_to_properties(const struct nlattr *nla)
+{
+	const struct algo_properties_st *a;
+	size_t name_len;
+
+	if (nla == NULL)
+		return NULL;
+
+	/* nla_len() >= 1 ensured by validate_nla() case NLA_NUL_STRING */
+	name_len = nla_len(nla) - 1;
+	for (a = algo_properties;
+	     a < algo_properties + ARRAY_SIZE(algo_properties); a++) {
+		if (a->kstr_len == name_len
+		    && memcmp(a->kstr, nla_data(nla), name_len + 1) == 0)
+			return a;
+	}
+	return NULL;
+}
+
+const char *ncr_algorithm_name(const struct algo_properties_st *algo)
+{
+	if (algo != NULL && algo->kstr != NULL)
+		return algo->kstr;
+	return "unknown";
+}
-- 
1.7.2.1

