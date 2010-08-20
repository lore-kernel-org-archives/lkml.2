Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0HTIsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:48:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab0HTIrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:47:01 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 15/19] Add key wrapping operations
Date: Fri, 20 Aug 2010 10:45:59 +0200
Message-Id: <1282293963-27807-17-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes:
- ncr_key_wrap
- ncr_key_unwrap
- ncr_key_storage_wrap
- ncr_key_storage_unwrap
---
 crypto/userspace/Makefile          |    5 +-
 crypto/userspace/ncr-key-storage.c |  136 +++++++
 crypto/userspace/ncr-key-wrap.c    |  763 ++++++++++++++++++++++++++++++++++++
 crypto/userspace/ncr.c             |   29 ++
 4 files changed, 931 insertions(+), 2 deletions(-)
 create mode 100644 crypto/userspace/ncr-key-storage.c
 create mode 100644 crypto/userspace/ncr-key-wrap.c
 create mode 100644 crypto/userspace/ncr.c

diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
index 454ed9d..689ee0d 100644
--- a/crypto/userspace/Makefile
+++ b/crypto/userspace/Makefile
@@ -63,8 +63,9 @@ TOMCRYPT_OBJECTS = libtomcrypt/misc/zeromem.o libtomcrypt/misc/crypt/crypt_argch
 	libtomcrypt/misc/pk_get_oid.o libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.o \
 	libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.o
 
-cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr-key.o ncr-limits.o \
-	ncr-pk.o ncr-sessions.o ncr-dh.o utils.o $(TOMMATH_OBJECTS) \
+cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr.o \
+	ncr-key.o ncr-limits.o  ncr-pk.o ncr-sessions.o ncr-dh.o \
+	ncr-key-wrap.o ncr-key-storage.o utils.o $(TOMMATH_OBJECTS) \
 	$(TOMCRYPT_OBJECTS)
 
 
diff --git a/crypto/userspace/ncr-key-storage.c b/crypto/userspace/ncr-key-storage.c
new file mode 100644
index 0000000..4d0cb87
--- /dev/null
+++ b/crypto/userspace/ncr-key-storage.c
@@ -0,0 +1,136 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
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
+#include <linux/ioctl.h>
+#include <linux/mm.h>
+#include <linux/ncr.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/scatterlist.h>
+#include "ncr-int.h"
+#include "cryptodev_int.h"
+
+struct packed_key {
+	uint32_t version;
+	uint8_t type;
+	uint32_t flags;
+	uint8_t algorithm[32];	/* NUL-terminated */
+	uint8_t key_id[MAX_KEY_ID_SIZE];
+	uint8_t key_id_size;
+
+	uint8_t raw[KEY_DATA_MAX_SIZE];
+	uint32_t raw_size;
+} __attribute__((__packed__));
+
+#define THIS_VERSION 1
+
+int key_to_storage_data( uint8_t** sdata, size_t * sdata_size, const struct key_item_st *key)
+{
+	struct packed_key * pkey;
+	int ret;
+
+	pkey = kmalloc(sizeof(*pkey), GFP_KERNEL);
+	if (pkey == NULL) {
+		err();
+		return -ENOMEM;
+	}
+
+	pkey->version = THIS_VERSION;
+	pkey->type = key->type;
+	pkey->flags = key->flags;
+	BUG_ON(strlen(key->algorithm->kstr) > sizeof(pkey->algorithm) - 1);
+	strcpy(pkey->algorithm, key->algorithm->kstr);
+	pkey->key_id_size = key->key_id_size;
+	memcpy(pkey->key_id, key->key_id, key->key_id_size);
+
+	if (key->type == NCR_KEY_TYPE_SECRET) {
+		pkey->raw_size = key->key.secret.size;
+		memcpy(pkey->raw, key->key.secret.data, pkey->raw_size);
+	} else if (key->type == NCR_KEY_TYPE_PRIVATE || key->type == NCR_KEY_TYPE_PUBLIC) {
+		pkey->raw_size = sizeof(pkey->raw);
+		ret = ncr_pk_pack( key, pkey->raw, &pkey->raw_size);
+		if (ret < 0) {
+			err();
+			goto fail;
+		}
+	} else {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	*sdata = (void*)pkey;
+	*sdata_size = sizeof(*pkey);
+
+	return 0;
+fail:
+	kfree(pkey);
+
+	return ret;
+}
+
+int key_from_storage_data(struct key_item_st* key, const void* data, size_t data_size)
+{
+	const struct packed_key * pkey = data;
+	int ret;
+
+	if (data_size != sizeof(*pkey) || pkey->version != THIS_VERSION
+	    || memchr(pkey->algorithm, '\0', sizeof(pkey->algorithm)) == NULL
+	    || pkey->key_id_size > MAX_KEY_ID_SIZE) {
+		err();
+		return -EINVAL;
+	}
+
+	key->type = pkey->type;
+	key->flags = pkey->flags;
+
+	key->algorithm = _ncr_algo_to_properties(pkey->algorithm);
+	if (key->algorithm == NULL) {
+		err();
+		return -EINVAL;
+	}
+	key->key_id_size = pkey->key_id_size;
+	memcpy(key->key_id, pkey->key_id, pkey->key_id_size);
+
+	if (key->type == NCR_KEY_TYPE_SECRET) {
+		if (pkey->raw_size > NCR_CIPHER_MAX_KEY_LEN) {
+			err();
+			return -EINVAL;
+		}
+		key->key.secret.size = pkey->raw_size;
+		memcpy(key->key.secret.data, pkey->raw, pkey->raw_size);
+	} else if (key->type == NCR_KEY_TYPE_PUBLIC 
+		|| key->type == NCR_KEY_TYPE_PRIVATE) {
+		ret = ncr_pk_unpack( key, pkey->raw, pkey->raw_size);
+		if (ret < 0) {
+			err();
+			return ret;
+		}
+	} else {
+		err();
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/crypto/userspace/ncr-key-wrap.c b/crypto/userspace/ncr-key-wrap.c
new file mode 100644
index 0000000..df96a79
--- /dev/null
+++ b/crypto/userspace/ncr-key-wrap.c
@@ -0,0 +1,763 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
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
+#include <linux/ioctl.h>
+#include <linux/mm.h>
+#include <linux/ncr.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/random.h>
+#include <linux/uaccess.h>
+#include <linux/scatterlist.h>
+#include <net/netlink.h>
+#include "ncr-int.h"
+#include "cryptodev_int.h"
+
+typedef uint8_t val64_t[8];
+
+static const val64_t initA = "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6";
+
+
+static void val64_xor( val64_t val, uint32_t x)
+{
+	val[7] ^= x & 0xff;
+	val[6] ^= (x >> 8) & 0xff;
+	val[5] ^= (x >> 16) & 0xff;
+	val[4] ^= (x >> 24) & 0xff;
+}
+
+static int rfc3394_wrap(val64_t *R, unsigned int n, struct cipher_data* ctx,
+	uint8_t* output, size_t *output_size, const uint8_t iv[8])
+{
+val64_t A;
+uint8_t aes_block[16];
+int i,j;
+
+	if (*output_size < (n+1)*8) {
+		err();
+		return -ERANGE;
+	}
+
+	memcpy(A, iv, 8);
+
+	for (i=0;i<6*n;i++) {
+		memcpy(aes_block, A, 8);
+		memcpy(&aes_block[8], R[0], 8);
+
+		_cryptodev_cipher_encrypt(ctx, aes_block, sizeof(aes_block),
+			aes_block, sizeof(aes_block));
+
+		memcpy(A, aes_block, 8); /* A = MSB64(AES(A^{t-1}|R_{1}^{t-1})) */
+		val64_xor(A, i+1); /* A ^= t */
+
+		for (j=0;j<n-1;j++)
+			memcpy(R[j], R[j+1], sizeof(R[j]));
+		memcpy(R[n-1], &aes_block[8], 8); /* R[n-1] = LSB64(AES(A^{t-1}|R_{1}^{t-1})) */
+	}
+
+	memcpy(output, A, sizeof(A));
+	for (j=0;j<n;j++)
+		memcpy(&output[(j+1)*8], R[j], 8);
+	*output_size = (n+1)*8;
+
+	return 0;
+}
+
+static int rfc3394_unwrap(const uint8_t *wrapped_key, val64_t R[], unsigned int n, val64_t A, struct cipher_data *ctx)
+{
+	int i, j;
+	uint8_t aes_block[16];
+
+	memcpy(A, wrapped_key, 8); /* A = C[0] */
+	for (i=0;i<n;i++)
+		memcpy(R[i], &wrapped_key[(i+1)*8], 8);
+
+	for (i=(6*n)-1;i>=0;i--) {
+		val64_xor(A, i+1);
+
+		memcpy(aes_block, A, 8);
+		memcpy(&aes_block[8], R[n-1], 8);
+
+		_cryptodev_cipher_decrypt(ctx, aes_block, sizeof(aes_block),
+			aes_block, sizeof(aes_block));
+
+		memcpy(A, aes_block, 8);
+
+		for (j=n-1;j>=1;j--)
+			memcpy(R[j], R[j-1], sizeof(R[j]));
+
+		memcpy(R[0], &aes_block[8], 8);
+	}
+
+	return 0;
+}
+
+#define RFC5649_IV "\xA6\x59\x59\xA6"
+static int _wrap_aes_rfc5649(void* kdata, size_t kdata_size, struct key_item_st* kek,
+	void* output, size_t* output_size, const void* _iv, size_t iv_size)
+{
+size_t n;
+int i, ret;
+struct cipher_data ctx;
+uint8_t iv[8];
+val64_t *R = NULL;
+
+	if (iv_size != 4) {
+		memcpy(iv, RFC5649_IV, 4);
+	} else {
+		memcpy(iv, _iv, 4);
+	}
+	iv_size = 8;
+	iv[4] = (kdata_size >> 24) & 0xff;
+	iv[5] = (kdata_size >> 16) & 0xff;
+	iv[6] = (kdata_size >> 8) & 0xff;
+	iv[7] = (kdata_size) & 0xff;
+
+	n = (kdata_size+7)/8;
+	if (n==1) { /* unimplemented */
+		err();
+		return -EINVAL;
+	}
+
+	ret = cryptodev_cipher_init(&ctx, "ecb(aes)", kek->key.secret.data, kek->key.secret.size);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	R = kmalloc(n * sizeof (*R), GFP_KERNEL);
+	if (R == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	/* R = P */
+	for (i=0;i<kdata_size;i++) {
+		R[i/8][i%8] = ((uint8_t*)kdata)[i];
+	}
+
+	for (;i<n*8;i++) {
+		R[i/8][i%8] = 0;
+	}
+
+	ret = rfc3394_wrap( R, n, &ctx, output, output_size, iv);
+	if (ret < 0) {
+		err();
+		goto cleanup;
+	}
+
+	ret = 0;
+
+cleanup:
+	kfree(R);
+	cryptodev_cipher_deinit(&ctx);
+
+	return ret;
+}
+
+static int _unwrap_aes_rfc5649(void* kdata, size_t *kdata_size, struct key_item_st* kek,
+	const void *wrapped_key, size_t wrapped_key_size, const void* _iv, size_t iv_size)
+{
+size_t n;
+int i, ret;
+struct cipher_data ctx;
+uint8_t iv[4];
+size_t size;
+val64_t *R = NULL, A;
+
+	if (iv_size != 4) {
+		memcpy(iv, RFC5649_IV, 4);
+	} else {
+		memcpy(iv, _iv, 4);
+	}
+	iv_size = 4;
+
+	ret = cryptodev_cipher_init(&ctx, "ecb(aes)", kek->key.secret.data, kek->key.secret.size);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	if (wrapped_key_size % 8 != 0) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	n = wrapped_key_size/8 - 1;
+
+	if (*kdata_size < (n-1)*8) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	R = kmalloc(n * sizeof (*R), GFP_KERNEL);
+	if (R == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	ret = rfc3394_unwrap(wrapped_key, R, n, A, &ctx);
+	if (ret < 0) {
+		err();
+		goto cleanup;
+	}
+
+	if (memcmp(A, iv, 4)!= 0) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	size = (A[4] << 24) | (A[5] << 16) | (A[6] << 8) | A[7];
+	if (size > n*8 || size < (n-1)*8 || *kdata_size < size) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	memset(kdata, 0, size);
+	*kdata_size = size;
+	for (i=0;i<size;i++) {
+		((uint8_t*)kdata)[i] = R[i/8][i%8];
+	}
+
+	ret = 0;
+
+cleanup:
+	kfree(R);
+	cryptodev_cipher_deinit(&ctx);
+
+	return ret;
+}
+
+
+static int wrap_aes_rfc5649(struct key_item_st* tobewrapped, struct key_item_st *kek,
+	void* output, size_t* output_size, const void* iv, size_t iv_size)
+{
+	if (tobewrapped->type != NCR_KEY_TYPE_SECRET) {
+		err();
+		return -EINVAL;
+	}
+
+	return _wrap_aes_rfc5649(tobewrapped->key.secret.data, tobewrapped->key.secret.size,
+		kek, output, output_size, iv, iv_size);
+	
+}
+
+static int unwrap_aes_rfc5649(struct key_item_st* output, struct key_item_st *kek,
+	void* wrapped, size_t wrapped_size, const void* iv, size_t iv_size)
+{
+	output->type = NCR_KEY_TYPE_SECRET;
+
+	return _unwrap_aes_rfc5649(output->key.secret.data, &output->key.secret.size, kek, 
+		wrapped, wrapped_size, iv, iv_size);
+}
+		
+
+/* Wraps using the RFC3394 way.
+ */
+static int wrap_aes(struct key_item_st* tobewrapped, struct key_item_st *kek,
+	void* output, size_t *output_size, const void* iv, size_t iv_size)
+{
+size_t key_size, n;
+uint8_t *raw_key;
+int i, ret;
+struct cipher_data ctx;
+val64_t *R = NULL;
+
+	if (tobewrapped->type != NCR_KEY_TYPE_SECRET) {
+		err();
+		return -EINVAL;
+	}
+	
+	if (iv_size < sizeof(initA)) {
+		iv_size = sizeof(initA);
+		iv = initA;
+	}
+
+	ret = cryptodev_cipher_init(&ctx, "ecb(aes)", kek->key.secret.data, kek->key.secret.size);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	raw_key = tobewrapped->key.secret.data;
+	key_size = tobewrapped->key.secret.size;
+
+	if (key_size % 8 != 0) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	n = key_size/8;
+
+
+	R = kmalloc(sizeof(*R)*n, GFP_KERNEL);
+	if (R == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	/* R = P */
+	for (i=0;i<n;i++) {
+		memcpy(R[i], &raw_key[i*8], 8);
+	}
+
+	ret = rfc3394_wrap( R, n, &ctx, output, output_size, iv);
+	if (ret < 0) {
+		err();
+		goto cleanup;
+	}
+
+	ret = 0;
+
+cleanup:
+	kfree(R);
+	cryptodev_cipher_deinit(&ctx);
+
+	return ret;
+}
+
+#if 0
+/* for debugging */
+void print_val64(char* str, val64_t val)
+{
+	int i;
+	printk("%s: ",str);
+	for (i=0;i<8;i++)
+	  printk("%.2x", val[i]);
+	printk("\n");
+	
+}
+#endif
+
+static int unwrap_aes(struct key_item_st* output, struct key_item_st *kek,
+	void* wrapped_key, size_t wrapped_key_size, const void* iv, size_t iv_size)
+{
+size_t n;
+val64_t A;
+int i, ret;
+struct cipher_data ctx;
+val64_t * R = NULL;
+
+	if (iv_size < sizeof(initA)) {
+		iv_size = sizeof(initA);
+		iv = initA;
+	}
+
+	ret = cryptodev_cipher_init(&ctx, "ecb(aes)", kek->key.secret.data, kek->key.secret.size);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	output->type = NCR_KEY_TYPE_SECRET;
+
+	if (wrapped_key_size % 8 != 0) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	n = wrapped_key_size/8 - 1;
+
+	if (NCR_CIPHER_MAX_KEY_LEN < (n-1)*8) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	R = kmalloc(sizeof(*R)*n, GFP_KERNEL);
+	if (R == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	ret = rfc3394_unwrap(wrapped_key, R, n, A, &ctx);
+	if (ret < 0) {
+		err();
+		goto cleanup;
+	}
+
+	if (memcmp(A, iv, 8)!= 0) {
+		err();
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	memset(&output->key, 0, sizeof(output->key));
+	for (i=0;i<n;i++) {
+		memcpy(&output->key.secret.data[i*8], R[i], sizeof(R[i]));
+	}
+	output->key.secret.size = n*8;
+	output->flags = NCR_KEY_FLAG_WRAPPABLE;
+	output->type = NCR_KEY_TYPE_SECRET;
+
+	ret = 0;
+
+cleanup:
+	kfree(R);
+	cryptodev_cipher_deinit(&ctx);
+
+	return ret;
+}
+
+static const char *ncr_wrap_name(struct nlattr *tb[])
+{
+	const struct nlattr *nla;
+
+	nla = tb[NCR_ATTR_WRAPPING_ALGORITHM];
+	if (nla != NULL)
+		return nla_data(nla);
+	return "unknown";
+}
+
+int ncr_key_wrap(struct ncr_lists *lst, const struct ncr_key_wrap *wrap,
+		 struct nlattr *tb[])
+{
+const struct nlattr *nla;
+struct key_item_st* wkey = NULL;
+struct key_item_st* key = NULL;
+void* data = NULL;
+const void *iv;
+size_t data_size, iv_size;
+int ret;
+
+	if (wrap->buffer_size < 0) {
+		err();
+		return -EINVAL;
+	}
+
+	ret = ncr_key_item_get_read(&wkey, lst, wrap->source_key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	if (!(wkey->flags & NCR_KEY_FLAG_WRAPPABLE)) {
+		err();
+		ret = -EPERM;
+		goto fail;
+	}
+
+	ret = ncr_key_item_get_read(&key, lst, wrap->wrapping_key);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	data_size = wrap->buffer_size;
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (data == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+	
+	nla = tb[NCR_ATTR_IV];
+	if (nla != NULL) {
+		iv = nla_data(nla);
+		iv_size = nla_len(nla);
+	} else {
+		iv = NULL;
+		iv_size = 0;
+	}
+
+	nla = tb[NCR_ATTR_WRAPPING_ALGORITHM];
+	if (nla == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	if (nla_strcmp(nla, NCR_WALG_AES_RFC3394) == 0)
+		ret = wrap_aes(wkey, key, data, &data_size, iv, iv_size);
+	else if (nla_strcmp(nla, NCR_WALG_AES_RFC5649) == 0)
+		ret = wrap_aes_rfc5649(wkey, key, data, &data_size, iv,
+				       iv_size);
+	else {
+		err();
+		ret = -EINVAL;
+	}
+	
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ret = copy_to_user(wrap->buffer, data, data_size);
+	if (unlikely(ret)) {
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	ret = data_size;
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_WRAP, lst->id, -1, NULL,
+			    ncr_wrap_name(tb), wrap->wrapping_key,
+			    key != NULL ? key->key_id : NULL,
+			    key != NULL ? key->key_id_size : 0,
+			    wrap->source_key,
+			    wkey != NULL ? wkey->key_id : NULL,
+			    wkey != NULL ? wkey->key_id_size : 0);
+
+	if (wkey != NULL) _ncr_key_item_put(wkey);
+	if (key != NULL) _ncr_key_item_put(key);
+	kfree(data);
+
+	return ret;
+}
+
+/* Unwraps keys. All keys unwrapped are not accessible by 
+ * userspace.
+ */
+int ncr_key_unwrap(struct ncr_lists *lst, const struct ncr_key_unwrap *wrap,
+		   struct nlattr *tb[])
+{
+const struct nlattr *nla;
+struct key_item_st* wkey = NULL;
+struct key_item_st* key = NULL;
+void* data = NULL;
+const void *iv;
+size_t data_size, iv_size;
+int ret;
+
+	ret = ncr_key_item_get_write(&wkey, lst, wrap->dest_key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	ret = ncr_key_item_get_read(&key, lst, wrap->wrapping_key);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	data_size = wrap->data_size;
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (data == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (unlikely(copy_from_user(data, wrap->data, data_size))) {
+		err();
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	nla = tb[NCR_ATTR_IV];
+	if (nla != NULL) {
+		iv = nla_data(nla);
+		iv_size = nla_len(nla);
+	} else {
+		iv = NULL;
+		iv_size = 0;
+	}
+
+	nla = tb[NCR_ATTR_WRAPPING_ALGORITHM];
+	if (nla == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	if (nla_strcmp(nla, NCR_WALG_AES_RFC3394) == 0)
+		ret = unwrap_aes(wkey, key, data, data_size, iv, iv_size);
+	else if (nla_strcmp(nla, NCR_WALG_AES_RFC5649) == 0)
+		ret = unwrap_aes_rfc5649(wkey, key, data, data_size, iv,
+					 iv_size);
+	else {
+		err();
+		ret = -EINVAL;
+	}
+	
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_UNWRAP, lst->id, -1, NULL,
+			    ncr_wrap_name(tb), wrap->wrapping_key,
+			    key != NULL ? key->key_id : NULL,
+			    key != NULL ? key->key_id_size : 0, wrap->dest_key,
+			    wkey != NULL ? wkey->key_id : NULL,
+			    wkey != NULL ? wkey->key_id_size : 0);
+
+	if (wkey != NULL) _ncr_key_item_put(wkey);
+	if (key != NULL) _ncr_key_item_put(key);
+	if (data != NULL) kfree(data);
+
+	return ret;
+}
+
+int ncr_key_storage_wrap(struct ncr_lists *lst,
+			 const struct ncr_key_storage_wrap *wrap,
+			 struct nlattr *tb[])
+{
+struct key_item_st* wkey = NULL;
+void* data = NULL;
+size_t data_size;
+uint8_t * sdata = NULL;
+size_t sdata_size = 0;
+int ret;
+
+	if (master_key.type != NCR_KEY_TYPE_SECRET) {
+		err();
+		return -ENOKEY;
+	}
+
+	if (wrap->buffer_size < 0) {
+		err();
+		return -EINVAL;
+	}
+
+	ret = ncr_key_item_get_read(&wkey, lst, wrap->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	if (!(wkey->flags & NCR_KEY_FLAG_WRAPPABLE)) {
+		err();
+		ret = -EPERM;
+		goto fail;
+	}
+
+	data_size = wrap->buffer_size;
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (data == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+	
+	ret = key_to_storage_data(&sdata, &sdata_size, wkey);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ret = _wrap_aes_rfc5649(sdata, sdata_size, &master_key, data, &data_size, NULL, 0);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ret = copy_to_user(wrap->buffer, data, data_size);
+	if (unlikely(ret)) {
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	ret = data_size;
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_WRAP, lst->id, -1, NULL, NULL,
+			    -1, NULL, 0, wrap->key,
+			    wkey != NULL ? wkey->key_id : NULL,
+			    wkey != NULL ? wkey->key_id_size : 0);
+
+	if (wkey != NULL) _ncr_key_item_put(wkey);
+	if (data != NULL) kfree(data);
+	if (sdata != NULL) kfree(sdata);
+
+	return ret;
+}
+
+int ncr_key_storage_unwrap(struct ncr_lists *lst,
+			   const struct ncr_key_storage_unwrap *wrap,
+			   struct nlattr *tb[])
+{
+struct key_item_st* wkey = NULL;
+void* data = NULL;
+uint8_t * sdata = NULL;
+size_t sdata_size = 0, data_size;
+int ret;
+
+	if (master_key.type != NCR_KEY_TYPE_SECRET) {
+		err();
+		return -ENOKEY;
+	}
+
+	ret = ncr_key_item_get_write(&wkey, lst, wrap->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	data_size = wrap->data_size;
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (data == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (unlikely(copy_from_user(data, wrap->data, data_size))) {
+		err();
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	sdata_size = data_size;
+	sdata = kmalloc(sdata_size, GFP_KERNEL);
+	if (sdata == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	wkey->flags = NCR_KEY_FLAG_WRAPPABLE;
+
+	ret = _unwrap_aes_rfc5649(sdata, &sdata_size, &master_key, data, data_size, NULL, 0);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ret = key_from_storage_data(wkey, sdata, sdata_size);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+	
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_UNWRAP, lst->id, -1, NULL, NULL,
+			    -1, NULL, 0, wrap->key,
+			    wkey != NULL ? wkey->key_id : NULL,
+			    wkey != NULL ? wkey->key_id_size : 0);
+
+	if (wkey != NULL) _ncr_key_item_put(wkey);
+	if (data != NULL) kfree(data);
+	if (sdata != NULL) kfree(sdata);
+
+	return ret;
+}
diff --git a/crypto/userspace/ncr.c b/crypto/userspace/ncr.c
new file mode 100644
index 0000000..1838aab
--- /dev/null
+++ b/crypto/userspace/ncr.c
@@ -0,0 +1,29 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+ *
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
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
+#include "ncr-int.h"
+
+/* This is the master wrapping key for storage of keys
+ */
+struct key_item_st master_key;
-- 
1.7.2.1

