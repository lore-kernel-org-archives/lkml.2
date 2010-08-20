Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0HTIsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0HTIq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:59 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 14/19] Add most operations on key objects.
Date: Fri, 20 Aug 2010 10:45:58 +0200
Message-Id: <1282293963-27807-16-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes:
- ncr_key_init
- ncr_key_deinit
- ncr_key_export (as plaintext)
- ncr_key_import
- ncr_key_generate
- ncr_key_generate_pair
- ncr_key_derive
- ncr_key_get_info
and supporting infrastructure.
---
 crypto/userspace/Makefile  |    2 +-
 crypto/userspace/ncr-key.c |  689 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 690 insertions(+), 1 deletions(-)
 create mode 100644 crypto/userspace/ncr-key.c

diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
index fa4168d..454ed9d 100644
--- a/crypto/userspace/Makefile
+++ b/crypto/userspace/Makefile
@@ -63,7 +63,7 @@ TOMCRYPT_OBJECTS = libtomcrypt/misc/zeromem.o libtomcrypt/misc/crypt/crypt_argch
 	libtomcrypt/misc/pk_get_oid.o libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.o \
 	libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.o
 
-cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr-limits.o \
+cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr-key.o ncr-limits.o \
 	ncr-pk.o ncr-sessions.o ncr-dh.o utils.o $(TOMMATH_OBJECTS) \
 	$(TOMCRYPT_OBJECTS)
 
diff --git a/crypto/userspace/ncr-key.c b/crypto/userspace/ncr-key.c
new file mode 100644
index 0000000..b90a4fc
--- /dev/null
+++ b/crypto/userspace/ncr-key.c
@@ -0,0 +1,689 @@
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
+#include <linux/audit.h>
+#include <linux/ioctl.h>
+#include <linux/mm.h>
+#include <linux/ncr.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/uaccess.h>
+#include <linux/scatterlist.h>
+#include <net/netlink.h>
+#include "ncr-int.h"
+#include "utils.h"
+
+static void ncr_key_clear(struct key_item_st* item);
+
+static int key_list_deinit_fn(int id, void *item, void *unused)
+{
+	(void)unused;
+	_ncr_key_item_put(item);
+	return 0;
+}
+
+void ncr_key_list_deinit(struct ncr_lists *lst)
+{
+	/* The mutex is not necessary, but doesn't hurt and makes it easier to
+	   verify locking correctness. */
+	mutex_lock(&lst->key_idr_mutex);
+	idr_for_each(&lst->key_idr, key_list_deinit_fn, NULL);
+	idr_remove_all(&lst->key_idr);
+	idr_destroy(&lst->key_idr);
+	mutex_unlock(&lst->key_idr_mutex);
+}
+
+/* returns the data item corresponding to desc */
+int ncr_key_item_get_read(struct key_item_st**st, struct ncr_lists *lst,
+	ncr_key_t desc)
+{
+struct key_item_st* item;
+int ret;
+	
+	*st = NULL;
+	
+	mutex_lock(&lst->key_idr_mutex);
+	item = idr_find(&lst->key_idr, desc);
+	if (item == NULL) {
+		err();
+		ret = -EINVAL;
+		goto exit;
+	}
+	atomic_inc(&item->refcnt);
+
+	if (atomic_read(&item->writer) != 0) {
+		/* writer in place busy */
+		atomic_dec(&item->refcnt);
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	*st = item;
+	ret = 0;
+
+exit:
+	mutex_unlock(&lst->key_idr_mutex);
+	return ret;
+}
+
+/* as above but will never return anything that
+ * is in use.
+ */
+int ncr_key_item_get_write( struct key_item_st** st, 
+	struct ncr_lists *lst, ncr_key_t desc)
+{
+struct key_item_st* item;
+int ret;
+
+	*st = NULL;
+
+	mutex_lock(&lst->key_idr_mutex);
+	item = idr_find(&lst->key_idr, desc);
+	if (item == NULL) {
+		err();
+		ret = -EINVAL;
+		goto exit;
+	}
+	/* do not return items that are in use already */
+
+	if (atomic_add_unless(&item->writer, 1, 1)==0) {
+		/* another writer so busy */
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	if (atomic_add_unless(&item->refcnt, 1, 2)==0) {
+		/* some reader is active so busy */
+		atomic_dec(&item->writer);
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	*st = item;
+	ret = 0;
+
+exit:
+	mutex_unlock(&lst->key_idr_mutex);
+	return ret;
+}
+
+void _ncr_key_item_put( struct key_item_st* item)
+{
+	if (atomic_read(&item->writer) > 0)
+		atomic_dec(&item->writer);
+	if (atomic_dec_and_test(&item->refcnt)) {
+			ncr_limits_remove(item->uid, item->pid, LIMIT_TYPE_KEY);
+			ncr_key_clear(item);
+			kfree(item);
+	}
+}
+
+static void _ncr_key_remove(struct ncr_lists *lst, ncr_key_t desc)
+{
+	struct key_item_st * item;
+
+	mutex_lock(&lst->key_idr_mutex);
+	item = idr_find(&lst->key_idr, desc);
+	if (item != NULL)
+		idr_remove(&lst->key_idr, desc); /* Steal the reference */
+	mutex_unlock(&lst->key_idr_mutex);
+
+	if (item != NULL)
+		_ncr_key_item_put(item);
+}
+
+int ncr_key_init(struct ncr_lists *lst)
+{
+	ncr_key_t desc;
+	struct key_item_st* key;
+	int ret;
+
+	ret = ncr_limits_add_and_check(current_euid(), task_pid_nr(current), LIMIT_TYPE_KEY);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	key = kmalloc(sizeof(*key), GFP_KERNEL);
+	if (key == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto err_limits;
+	}
+
+	memset(key, 0, sizeof(*key));
+
+	atomic_set(&key->refcnt, 1);
+	atomic_set(&key->writer, 0);
+	key->uid = current_euid();
+	key->pid = task_pid_nr(current);
+	key->context_id = lst->id;
+
+	mutex_lock(&lst->key_idr_mutex);
+	/* idr_pre_get() should preallocate enough, and, due to key_idr_mutex,
+	   nobody else can use the preallocated data.  Therefore the loop
+	   recommended in idr_get_new() documentation is not necessary. */
+	if (idr_pre_get(&lst->key_idr, GFP_KERNEL) == 0 ||
+	    idr_get_new(&lst->key_idr, key, &key->desc) != 0) {
+		mutex_unlock(&lst->key_idr_mutex);
+		_ncr_key_item_put(key);
+		return -ENOMEM;
+	}
+	desc = key->desc;
+	mutex_unlock(&lst->key_idr_mutex);
+
+	return desc;
+
+err_limits:
+	ncr_limits_remove(current_euid(), task_pid_nr(current), LIMIT_TYPE_KEY);
+	return ret;
+}
+
+int ncr_key_deinit(struct ncr_lists *lst, ncr_key_t desc)
+{
+	_ncr_key_remove(lst, desc);
+	return 0;
+}
+
+int ncr_key_export(struct ncr_lists *lst, const struct ncr_key_export *data,
+		   struct nlattr *tb[])
+{
+struct key_item_st* item = NULL;
+void* tmp = NULL;
+uint32_t tmp_size;
+int ret;
+
+	if (data->buffer_size < 0) {
+		err();
+		return -EINVAL;
+	}
+
+	ret = ncr_key_item_get_read(&item, lst, data->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	if (!(item->flags & NCR_KEY_FLAG_EXPORTABLE)) {
+		err();
+		ret = -EPERM;
+		goto fail;
+	}
+
+	switch (item->type) {
+		case NCR_KEY_TYPE_SECRET:
+			if (item->key.secret.size > data->buffer_size) {
+				err();
+				ret = -ERANGE;
+				goto fail;
+			}
+
+			/* found */
+			if (item->key.secret.size > 0) {
+				ret = copy_to_user(data->buffer, item->key.secret.data, item->key.secret.size);
+				if (unlikely(ret)) {
+					err();
+					ret = -EFAULT;
+					goto fail;
+				}
+			}
+
+			ret = item->key.secret.size;
+			break;
+		case NCR_KEY_TYPE_PUBLIC:
+		case NCR_KEY_TYPE_PRIVATE:
+			tmp_size = data->buffer_size;
+			
+			tmp = kmalloc(tmp_size, GFP_KERNEL);
+			if (tmp == NULL) {
+				err();
+				ret = -ENOMEM;
+				goto fail;
+			}
+
+			ret = ncr_pk_pack(item, tmp, &tmp_size);
+			if (ret < 0) {
+				err();
+				goto fail;
+			}
+
+			ret = copy_to_user(data->buffer, tmp, tmp_size);
+			if (unlikely(ret)) {
+				err();
+				ret = -EFAULT;
+				goto fail;
+			}
+			
+			ret = tmp_size;
+			break;
+		default:
+			err();
+			ret = -EINVAL;
+			goto fail;
+	}
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_EXPORT, lst->id, -1, NULL,
+			    ncr_algorithm_name(item->algorithm), item->desc,
+			    item->key_id, item->key_id_size, -1, NULL, 0);
+
+	kfree(tmp);
+	_ncr_key_item_put(item);
+	return ret;
+	
+}
+
+int ncr_key_import(struct ncr_lists *lst, const struct ncr_key_import *data,
+		   struct nlattr *tb[])
+{
+const struct nlattr *nla;
+struct key_item_st* item = NULL;
+int ret;
+void* tmp = NULL;
+size_t tmp_size;
+
+	ret = ncr_key_item_get_write( &item, lst, data->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	ncr_key_clear(item);
+
+	tmp = kmalloc(data->data_size, GFP_KERNEL);
+	if (tmp == NULL) {
+		err();
+		ret = -ENOMEM;
+		goto fail;
+	}
+	
+	if (unlikely(copy_from_user(tmp, data->data, data->data_size))) {
+		err();
+		ret = -EFAULT;
+		goto fail;
+	}
+	tmp_size = data->data_size;
+
+	nla = tb[NCR_ATTR_KEY_TYPE];
+	if (tb == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	item->type = nla_get_u32(nla);
+
+	item->algorithm = _ncr_nla_to_properties(tb[NCR_ATTR_ALGORITHM]);
+	if (item->algorithm == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	nla = tb[NCR_ATTR_KEY_FLAGS];
+	if (nla != NULL)
+		item->flags = nla_get_u32(nla);
+
+	nla = tb[NCR_ATTR_KEY_ID];
+	if (nla != NULL) {
+		if (nla_len(nla) > MAX_KEY_ID_SIZE) {
+			err();
+			ret = -EOVERFLOW;
+			goto fail;
+		}
+
+		item->key_id_size = nla_len(nla);
+		memcpy(item->key_id, nla_data(nla), item->key_id_size);
+	}
+
+	switch(item->type) {
+		case NCR_KEY_TYPE_SECRET:
+
+			if (tmp_size > NCR_CIPHER_MAX_KEY_LEN) {
+				err();
+				ret = -EINVAL;
+				goto fail;
+			}
+			
+			memcpy(item->key.secret.data, tmp, tmp_size);
+			item->key.secret.size = tmp_size;
+			break;
+		case NCR_KEY_TYPE_PRIVATE:
+		case NCR_KEY_TYPE_PUBLIC:
+			ret = ncr_pk_unpack( item, tmp, tmp_size);
+			if (ret < 0) {
+				err();
+				goto fail;
+			}
+			break;
+
+		default:
+			err();
+			ret = -EINVAL;
+			goto fail;
+	}
+
+	ret = 0;
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_IMPORT, lst->id, -1, NULL,
+			    ncr_algorithm_name(item->algorithm), item->desc,
+			    item->key_id, item->key_id_size, -1, NULL, 0);
+
+	_ncr_key_item_put(item);
+	kfree(tmp);
+
+	return ret;
+}
+
+static void ncr_key_clear(struct key_item_st* item)
+{
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_ZEROIZE, item->context_id, -1,
+			    NULL, ncr_algorithm_name(item->algorithm),
+			    item->desc, item->key_id, item->key_id_size, -1,
+			    NULL, 0);
+
+	/* clears any previously allocated parameters */
+	if (item->type == NCR_KEY_TYPE_PRIVATE ||
+		item->type == NCR_KEY_TYPE_PUBLIC) {
+		
+		ncr_pk_clear(item);
+	}
+	memset(&item->key, 0, sizeof(item->key));
+	memset(item->key_id, 0, sizeof(item->key_id));
+	item->key_id_size = 0;
+	item->flags = 0;
+	
+	return;
+}
+
+/* Generate a secret key
+ */
+int ncr_key_generate(struct ncr_lists *lst, const struct ncr_key_generate *gen,
+		     struct nlattr *tb[])
+{
+const struct nlattr *nla;
+struct key_item_st* item = NULL;
+const struct algo_properties_st *algo;
+int ret;
+size_t size;
+
+	ret = ncr_key_item_get_write(&item, lst, gen->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	ncr_key_clear(item);
+
+	/* we generate only secret keys */
+	nla = tb[NCR_ATTR_KEY_FLAGS];
+	if (nla != NULL)
+		item->flags = nla_get_u32(nla);
+
+	algo = _ncr_nla_to_properties(tb[NCR_ATTR_ALGORITHM]);
+	if (algo == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	item->type = algo->key_type;
+	if (item->type == NCR_KEY_TYPE_SECRET) {
+		u32 key_bits;
+
+		item->algorithm = algo;
+
+		nla = tb[NCR_ATTR_SECRET_KEY_BITS];
+		if (nla == NULL) {
+			err();
+			ret = -EINVAL;
+			goto fail;
+		}
+		key_bits = nla_get_u32(nla);
+		size = key_bits / 8;
+		if (key_bits % 8 != 0 || size > NCR_CIPHER_MAX_KEY_LEN) {
+			err();
+			ret = -EINVAL;
+			goto fail;
+		}
+
+		get_random_bytes(item->key.secret.data, size);
+		item->key.secret.size = size;
+
+		/* generate random key id */
+		item->key_id_size = 5;
+		get_random_bytes(item->key_id, item->key_id_size);
+	} else {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	
+	ret = 0;
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_GEN, lst->id, -1, NULL,
+			    ncr_algorithm_name(algo), item->desc, item->key_id,
+			    item->key_id_size, -1, NULL, 0);
+
+	if (ret < 0) item->type = NCR_KEY_TYPE_INVALID;
+	_ncr_key_item_put(item);
+	return ret;
+}
+
+int ncr_key_get_info(struct ncr_lists *lst, struct ncr_out *out,
+		     const struct ncr_key_get_info *info, struct nlattr *tb[])
+{
+const struct nlattr *nla;
+const u16 *attr, *attr_end;
+struct key_item_st* item = NULL;
+int ret;
+
+	ret = ncr_key_item_get_read(&item, lst, info->key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+	
+	if (item->type == NCR_KEY_TYPE_INVALID) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	nla = tb[NCR_ATTR_WANTED_ATTRS];
+	if (nla == NULL || nla_len(nla) % sizeof(u16) != 0) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	attr = nla_data(nla);
+	attr_end = attr + nla_len(nla) / sizeof(u16);
+	while (attr < attr_end) {
+		switch (*attr) {
+		case NCR_ATTR_KEY_FLAGS:
+			ret = ncr_out_put_u32(out, *attr, item->flags);
+			break;
+		case NCR_ATTR_KEY_TYPE:
+			ret = ncr_out_put_u32(out, *attr, item->type);
+			break;
+		case NCR_ATTR_ALGORITHM:
+			ret = ncr_out_put_string(out, *attr,
+						 item->algorithm->kstr);
+			break;
+		default:
+			break; /* Silently ignore */
+		}
+		if (ret != 0) {
+			err();
+			goto fail;
+		}
+		attr++;
+	}
+
+	ret = ncr_out_finish(out);
+	if (ret != 0) {
+		err();
+		goto fail;
+	}
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_GET_INFO, lst->id, -1, NULL,
+			    ncr_algorithm_name(item->algorithm), item->desc,
+			    item->key_id, item->key_id_size, -1, NULL, 0);
+
+	_ncr_key_item_put( item);
+
+	return ret;
+}
+
+int ncr_key_generate_pair(struct ncr_lists *lst,
+			  const struct ncr_key_generate_pair *gen,
+			  struct nlattr *tb[])
+{
+const struct nlattr *nla;
+struct key_item_st* private = NULL;
+struct key_item_st* public = NULL;
+int ret;
+
+	ret = ncr_key_item_get_write(&private, lst, gen->private_key);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ret = ncr_key_item_get_write(&public, lst, gen->public_key);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ncr_key_clear(public);
+	ncr_key_clear(private);
+
+	/* we generate only secret keys */
+	nla = tb[NCR_ATTR_KEY_FLAGS];
+	if (nla != NULL)
+		private->flags = public->flags = nla_get_u32(nla);
+
+	private->algorithm = public->algorithm
+		= _ncr_nla_to_properties(tb[NCR_ATTR_ALGORITHM]);
+	if (private->algorithm == NULL) {
+		err();
+		ret = -EINVAL;
+		goto fail;
+	}
+	public->type = public->algorithm->key_type;
+	private->type = NCR_KEY_TYPE_PRIVATE;
+	public->flags |= (NCR_KEY_FLAG_EXPORTABLE|NCR_KEY_FLAG_WRAPPABLE);
+	
+	if (public->type == NCR_KEY_TYPE_PUBLIC) {
+		ret = ncr_pk_generate(public->algorithm, tb, private, public);
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
+	ret = 0;
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_GEN, lst->id, -1, NULL,
+			    ncr_algorithm_name(private != NULL
+					       ? private->algorithm : NULL),
+			    gen->private_key,
+			    private != NULL ? private->key_id : NULL,
+			    private != NULL ? private->key_id_size : 0,
+			    gen->public_key,
+			    public != NULL ? public->key_id : NULL,
+			    public != NULL ? public->key_id_size : 0);
+
+	if (public) {
+		if (ret < 0) public->type = NCR_KEY_TYPE_INVALID;
+		_ncr_key_item_put(public);
+	}
+	if (private) {
+		if (ret < 0) private->type = NCR_KEY_TYPE_INVALID;
+		_ncr_key_item_put(private);
+	}
+	return ret;
+}
+
+int ncr_key_derive(struct ncr_lists *lst, const struct ncr_key_derive *data,
+		   struct nlattr *tb[])
+{
+const struct nlattr *nla;
+int ret;
+struct key_item_st* key = NULL;
+struct key_item_st* newkey = NULL;
+
+	ret = ncr_key_item_get_read(&key, lst, data->input_key);
+	if (ret < 0) {
+		err();
+		return ret;
+	}
+
+	ret = ncr_key_item_get_write(&newkey, lst, data->new_key);
+	if (ret < 0) {
+		err();
+		goto fail;
+	}
+
+	ncr_key_clear(newkey);
+
+	nla = tb[NCR_ATTR_KEY_FLAGS];
+	if (nla != NULL)
+		newkey->flags = nla_get_u32(nla);
+
+	switch (key->type) {
+		case NCR_KEY_TYPE_PUBLIC:
+		case NCR_KEY_TYPE_PRIVATE:
+			ret = ncr_pk_derive(newkey, key, tb);
+			if (ret < 0) {
+				err();
+				goto fail;
+			}
+			break;
+		default:
+			err();
+			ret = -EINVAL;
+			goto fail;
+	}
+
+fail:
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_KEY_DERIVE, lst->id, -1, NULL,
+			    ncr_algorithm_name(key->algorithm), key->desc,
+			    key->key_id, key->key_id_size, data->new_key,
+			    newkey != NULL ? newkey->key_id : NULL,
+			    newkey != NULL ? newkey->key_id_size : 0);
+
+	_ncr_key_item_put(key);
+	if (newkey)
+		_ncr_key_item_put(newkey);
+	return ret;
+	
+}
+
-- 
1.7.2.1

