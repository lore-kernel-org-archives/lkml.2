Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0HTIrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0HTIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:39 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: =?UTF-8?q?=5BPATCH=2006/19=5D=20Add=20ioctl=28=29=20argument=20and=20attribute=20handling=20utils?=
Date: Fri, 20 Aug 2010 10:45:49 +0200
Message-Id: <1282293963-27807-7-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Main entry points:

NCR_GET_INPUT_ARGS:
	Read a fixed struct and any attached attributes from userspace

NCR_GET_INPUT_ARGS_NO_OUTPUT:
	Same as above, and inform the users the kernel will attach no
	additional attributes.

NCR_OUT_INIT/ncr_out_free:
	Allocate and free a context that allows operation handlers to
	return attributes to userspace.

ncr_out_finish:
	Write the attributes from the context to userspace.  Split like
	this so that only NCR_OUT_INIT (in future "ncr.c") deals with
	the raw ioctl() argument, but the specific operation can use
	this call to detect errors and perhaps clean up.

ncr_out_*:
	Add attributes to the context.
---
 crypto/userspace/Makefile |    5 +
 crypto/userspace/utils.c  |  297 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/userspace/utils.h  |   98 +++++++++++++++
 3 files changed, 400 insertions(+), 0 deletions(-)
 create mode 100644 crypto/userspace/utils.c
 create mode 100644 crypto/userspace/utils.h

diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
index b607b90..f7f3ea2 100644
--- a/crypto/userspace/Makefile
+++ b/crypto/userspace/Makefile
@@ -1 +1,6 @@
 ccflags-y += -I$(src)/libtommath -I$(src)/libtomcrypt/headers -I$(src) -DLTC_SOURCE
+
+cryptodev-objs := utils.o
+
+
+obj-$(CONFIG_CRYPTO_USERSPACE) += cryptodev.o
diff --git a/crypto/userspace/utils.c b/crypto/userspace/utils.c
new file mode 100644
index 0000000..514833c
--- /dev/null
+++ b/crypto/userspace/utils.c
@@ -0,0 +1,297 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+ *
+ * Copyright (c) 2010 Red Hat Inc.
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
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ *
+ * Red Hat Author: Miloslav Trmač
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <net/netlink.h>
+#include "ncr-int.h"
+#include "utils.h"
+
+#ifdef CONFIG_COMPAT
+/* max() is too clever for compile-time constants */
+#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
+
+#define MAX_SESSION_INPUT_DATA_SIZE					\
+	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
+		   sizeof(struct compat_ncr_session_input_data)))
+#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
+	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
+		   sizeof(struct compat_ncr_session_output_buffer)))
+
+#else /* !CONFIG_COMPAT */
+
+#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_input_data))
+#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
+	(sizeof(struct ncr_session_output_buffer))
+
+#endif /* !CONFIG_COMPAT */
+
+static const struct nla_policy ncr_attr_policy[NCR_ATTR_MAX + 1] = {
+	[NCR_ATTR_ALGORITHM] = { NLA_NUL_STRING, 0 },
+	[NCR_ATTR_DERIVATION_ALGORITHM] = { NLA_NUL_STRING, 0 },
+	[NCR_ATTR_SIGNATURE_HASH_ALGORITHM] = { NLA_NUL_STRING, 0 },
+	[NCR_ATTR_WRAPPING_ALGORITHM] = { NLA_NUL_STRING, 0 },
+	[NCR_ATTR_UPDATE_INPUT_DATA] = {
+		NLA_BINARY, MAX_SESSION_INPUT_DATA_SIZE
+	},
+	[NCR_ATTR_UPDATE_OUTPUT_BUFFER] = {
+		NLA_BINARY, MAX_SESSION_OUTPUT_BUFFER_SIZE
+	},
+	[NCR_ATTR_UPDATE_INPUT_KEY_AS_DATA] = { NLA_U32, 0 },
+	[NCR_ATTR_FINAL_INPUT_DATA] = {
+		NLA_BINARY, MAX_SESSION_INPUT_DATA_SIZE
+	},
+	[NCR_ATTR_FINAL_OUTPUT_BUFFER] = {
+		NLA_BINARY, MAX_SESSION_OUTPUT_BUFFER_SIZE
+	},
+	[NCR_ATTR_KEY] = { NLA_U32, 0 },
+	[NCR_ATTR_KEY_FLAGS] = { NLA_U32, 0 },
+	[NCR_ATTR_KEY_ID] = { NLA_BINARY, 0 },
+	[NCR_ATTR_KEY_TYPE] = { NLA_U32, 0 },
+	[NCR_ATTR_IV] = { NLA_BINARY, 0 },
+	[NCR_ATTR_SECRET_KEY_BITS] = { NLA_U32, 0 },
+	[NCR_ATTR_RSA_MODULUS_BITS] = { NLA_U32, 0 },
+	[NCR_ATTR_RSA_E] = { NLA_BINARY, 0 },
+	[NCR_ATTR_RSA_ENCODING_METHOD] = { NLA_U32, 0 },
+	[NCR_ATTR_RSA_OAEP_HASH_ALGORITHM] = { NLA_NUL_STRING, 0 },
+	[NCR_ATTR_RSA_PSS_SALT_LENGTH] = { NLA_U32, 0 },
+	[NCR_ATTR_DSA_P_BITS] = { NLA_U32, 0 },
+	[NCR_ATTR_DSA_Q_BITS] = { NLA_U32, 0 },
+	[NCR_ATTR_DH_PRIME] = { NLA_BINARY, 0 },
+	[NCR_ATTR_DH_BASE] = { NLA_BINARY, 0 },
+	[NCR_ATTR_DH_PUBLIC] = { NLA_BINARY, 0 },
+	[NCR_ATTR_WANTED_ATTRS] = { NLA_BINARY, 0 },
+};
+
+void *__ncr_get_input_args(void *fixed, struct nlattr *tb[], size_t fixed_size,
+			   u32 *input_size_ptr, const void __user *arg)
+{
+	size_t input_size, buf_size;
+	void *buf;
+	int ret;
+
+	if (unlikely(copy_from_user(fixed, arg, fixed_size))) {
+		err();
+		return ERR_PTR(-EFAULT);
+	}
+	input_size = *input_size_ptr;
+
+	/* NCR_GET_INPUT_ARGS/NCR_GET_INPUT_ARGS_NO_OUTPUT has verified
+	   fixed_size is correctly aligned for a struct nlattr. */
+	if (input_size == 0)
+		input_size = fixed_size;
+	else if (unlikely(input_size < fixed_size)) {
+		err();
+		return ERR_PTR(-EINVAL);
+	}
+	buf_size = input_size - fixed_size;
+	if (unlikely(buf_size > NCR_MAX_ATTR_SIZE)) {
+		err();
+		return ERR_PTR(-EOVERFLOW);
+	}
+
+	if (buf_size == 0)
+		buf = NULL;
+	else {
+		const char __user *var_arg;
+
+		buf = kmalloc(buf_size, GFP_KERNEL);
+		if (unlikely(buf == NULL)) {
+			err();
+			return ERR_PTR(-ENOMEM);
+		}
+		var_arg = (const char __user *)arg + fixed_size;
+		if (unlikely(copy_from_user(buf, var_arg, buf_size))) {
+			err();
+			ret = -EFAULT;
+			goto err_buf;
+		}
+	}
+
+	ret = nla_parse(tb, NCR_ATTR_MAX, buf, buf_size, ncr_attr_policy);
+	if (ret != 0) {
+		err();
+		goto err_buf;
+	}
+
+	return buf;
+
+err_buf:
+	kfree(buf);
+	return ERR_PTR(ret);
+}
+
+static int update_output_size(void __user *arg, size_t output_size_offset,
+			      u32 old_value, u32 new_value)
+{
+	if (old_value != 0 && old_value != new_value) {
+		u32 __user *dest;
+
+		dest = (u32 __user *)((char __user *)arg + output_size_offset);
+		return put_user(new_value, dest);
+	}
+	return 0;
+}
+
+void *__ncr_get_input_args_no_output(void *fixed, struct nlattr *tb[],
+				     size_t fixed_size, u32 *input_size_ptr,
+				     size_t output_size_offset,
+				     void __user *arg)
+{
+	void *attr_buf;
+	u32 output_size;
+	int ret;
+
+	attr_buf = __ncr_get_input_args(fixed, tb, fixed_size, input_size_ptr,
+					arg);
+	if (IS_ERR(attr_buf))
+		return attr_buf;
+
+	output_size = *(const u32 *)((const char *)fixed + output_size_offset);
+	ret = update_output_size(arg, output_size_offset, output_size,
+				 fixed_size);
+	if (ret != 0) {
+		kfree(attr_buf);
+		return ERR_PTR(ret);
+	}
+	return attr_buf;
+}
+
+int __ncr_out_init(struct ncr_out *out, const void *fixed, size_t fixed_size,
+		   size_t output_size_offset, void __user *arg)
+{
+	u32 output_size;
+
+	/* NCR_OUT_INIT has verified fixed_size is correctly aligned for a
+	   struct nlattr. */
+	output_size = *(const u32 *)((const char *)fixed + output_size_offset);
+	if (output_size == 0)
+		out->left = 0;
+	else {
+		/* NCR_OUT_INIT has verified fixed_size is correctly aligned for
+		   a struct nlattr. */
+		if (output_size < fixed_size)
+			return -EINVAL;
+		out->left = min_t(size_t, output_size - fixed_size,
+				  NCR_MAX_ATTR_SIZE);
+	}
+	out->buf = kmalloc(out->left, GFP_KERNEL);
+	if (out->buf == NULL)
+		return -ENOMEM;
+	out->p = out->buf;
+	out->arg = arg;
+	out->output_size_offset = output_size_offset;
+	out->fixed_size = fixed_size;
+	out->orig_output_size = output_size;
+	return 0;
+}
+
+int ncr_out_finish(struct ncr_out *out)
+{
+	size_t buf_size;
+
+	buf_size = (char *)out->p - (char *)out->buf;
+	if (buf_size != 0) {
+		if (unlikely(copy_to_user((char __user *)out->arg
+					  + out->fixed_size,
+					  out->buf, buf_size)))
+			return -EFAULT;
+	}
+
+	return update_output_size(out->arg, out->output_size_offset,
+				  out->orig_output_size,
+				  out->fixed_size + buf_size);
+}
+
+void ncr_out_free(struct ncr_out *out)
+{
+	kfree(out->buf);
+}
+
+struct nlattr *ncr_out_reserve(struct ncr_out *out, int attrtype, int attrlen)
+{
+	size_t needed;
+	struct nlattr *nla;
+
+	needed = nla_total_size(attrlen);
+	if (out->left < needed)
+		ERR_PTR(-ERANGE);
+	nla = out->p;
+	out->p = (char *)out->p + needed;
+	out->left -= needed;
+
+	nla->nla_len = nla_attr_size(attrlen);
+	nla->nla_type = attrtype;
+	memset((unsigned char *)nla + nla->nla_len, 0, nla_padlen(attrlen));
+	return nla;
+}
+
+int ncr_out_put(struct ncr_out *out, int attrtype, int attrlen, const void *data)
+{
+	struct nlattr *nla;
+
+	nla = ncr_out_reserve(out, attrtype, attrlen);
+	if (IS_ERR(nla))
+		return PTR_ERR(nla);
+	memcpy(nla_data(nla), data, attrlen);
+	return 0;
+}
+
+/**
+ * Initialize a nlattr with @attrtype as a buffer of maximum possible size in
+ * @out.  The buffer must be finalized using ncr_out_commit_buffer.
+ */
+struct nlattr *ncr_out_begin_buffer(struct ncr_out *out, int attrtype)
+{
+	struct nlattr *nla;
+
+	if (out->left < NLA_HDRLEN)
+		return ERR_PTR(-ERANGE);
+	nla = out->p;
+
+	/* Ensure the rounding down of out->left does not decrease it below
+	   NLA_HDRLEN. */
+	BUILD_BUG_ON(NLA_ALIGN(NLA_HDRLEN) != NLA_HDRLEN);
+	nla->nla_len = out->left & ~(NLA_ALIGNTO - 1);
+	nla->nla_type = attrtype;
+	return nla;
+}
+
+/**
+ * Set the length of buffer initialied in @out with ncr_out_begin_buffer() to
+ * @attrlen and allow adding more attributes.
+ */
+void ncr_out_commit_buffer(struct ncr_out *out, int attrlen)
+{
+	struct nlattr *nla;
+	size_t total;
+
+	nla = out->p;
+	nla->nla_len = nla_attr_size(attrlen);
+	memset((unsigned char *)nla + nla->nla_len, 0, nla_padlen(attrlen));
+	total = nla_total_size(attrlen);
+
+	out->p = (char *)out->p + total;
+	out->left -= total;
+}
diff --git a/crypto/userspace/utils.h b/crypto/userspace/utils.h
new file mode 100644
index 0000000..2802afa
--- /dev/null
+++ b/crypto/userspace/utils.h
@@ -0,0 +1,98 @@
+#ifndef NCR_UTILS_H
+#define  NCR_UTILS_H
+
+#include <linux/kernel.h>
+#include <linux/netlink.h>
+
+#define NCR_MAX_ATTR_SIZE 4096
+
+struct nlattr;
+
+struct ncr_out {
+	void *buf, *p;
+	size_t left;
+	void __user *arg;
+	size_t output_size_offset, fixed_size;
+	u32 orig_output_size;
+};
+
+#define __NCR_VERIFY_FIXED_SIZE(fixed)					\
+	(BUILD_BUG_ON(sizeof(*(fixed)) != NLA_ALIGN(sizeof(*(fixed)))))
+#define __NCR_VERIFY_TB(tb) (BUILD_BUG_ON(ARRAY_SIZE(tb) != NCR_ATTR_MAX + 1))
+
+extern u32 __ncr_u32_type_check;
+#define __OUT_SIZE_OFF(fixed)						\
+	((void)(&(fixed)->output_size == &__ncr_u32_type_check),	\
+	 (char *)&(fixed)->output_size - (char *)(fixed))
+
+
+/**
+ * Load *@fixed and a sequence of netlink-like attributes from @arg.  @fixed
+ * contains "input_size", which is an u32 filled with total input size,
+ * including the attributes, which are parsed into @tb.
+ */
+#define NCR_GET_INPUT_ARGS(fixed, tb, arg)			\
+	(__NCR_VERIFY_FIXED_SIZE(fixed),			\
+	 __NCR_VERIFY_TB(tb),					\
+	 __ncr_get_input_args(fixed, tb, sizeof(*(fixed)),	\
+			      &(fixed)->input_size, arg))
+void *__ncr_get_input_args(void *fixed, struct nlattr *tb[], size_t fixed_size,
+			   u32 *input_size_ptr, const void __user *arg);
+
+/**
+ * Load *@fixed and a sequence of netlink-like attributes from @arg.  @fixed
+ * contains "input_size", which is an u32 filled with total input size,
+ * including the attributes, which are parsed into @tb.  In addition, indicate
+ * to the user through u32 "output_size" that no output attributes will be
+ * returned.
+ */
+#define NCR_GET_INPUT_ARGS_NO_OUTPUT(fixed, tb, arg)			\
+	(__NCR_VERIFY_FIXED_SIZE(fixed),				\
+	 __NCR_VERIFY_TB(tb),						\
+	 __ncr_get_input_args_no_output(fixed, tb, sizeof(*(fixed)),	\
+					&(fixed)->input_size,		\
+					__OUT_SIZE_OFF(fixed), arg))
+void *__ncr_get_input_args_no_output(void *fixed, struct nlattr *tb[],
+				     size_t fixed_size, u32 *input_size_ptr,
+				     size_t output_size_offset,
+				     void __user *arg);
+
+/**
+ * Return a new output attribute context for attributes of *@fixed.  @fixed
+ * contains "output_size", an u32 containing total output size, including
+ * @fixed.  Store @arg for later ncr_out_finish().
+ */
+#define NCR_OUT_INIT(out, fixed, arg)				\
+	(__NCR_VERIFY_FIXED_SIZE(fixed),			\
+	 __ncr_out_init((out), (fixed), sizeof(*(fixed)),	\
+			__OUT_SIZE_OFF(fixed), (arg)))
+int __ncr_out_init(struct ncr_out *out, const void *fixed, size_t fixed_size,
+		   size_t output_size_offset, void __user *arg);
+
+/**
+ * Write attributes from @out to user space and update user-space output_size.
+ */
+int ncr_out_finish(struct ncr_out *out);
+
+void ncr_out_free(struct ncr_out *out);
+
+int ncr_out_put(struct ncr_out *out, int attrtype, int attrlen,
+		const void *data);
+
+static inline int ncr_out_put_u32(struct ncr_out *out, int attrtype, u32 value)
+{
+	return ncr_out_put(out, attrtype, sizeof(value), &value);
+}
+
+static inline int ncr_out_put_string(struct ncr_out *out, int attrtype,
+				     const char *value)
+{
+	return ncr_out_put(out, attrtype, strlen(value) + 1, value);
+}
+
+struct nlattr *ncr_out_reserve(struct ncr_out *out, int attrtype, int attrlen);
+
+struct nlattr *ncr_out_begin_buffer(struct ncr_out *out, int attrtype);
+void ncr_out_commit_buffer(struct ncr_out *out, int attrlen);
+
+#endif
-- 
1.7.2.1

