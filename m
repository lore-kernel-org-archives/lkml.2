Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0HTIrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0HTIrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:47:07 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 18/19] Add ioctl handlers
Date: Fri, 20 Aug 2010 10:46:02 +0200
Message-Id: <1282293963-27807-20-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl and compat_ioctl handling.  This is the only file that
directly accesses structured data from userspace (other files may access
unformated data such as cipher input or multiple-precision integers).

Also add the last operation, ncr_master_key_set.
---
 crypto/userspace/ncr.c |  405 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 405 insertions(+), 0 deletions(-)

diff --git a/crypto/userspace/ncr.c b/crypto/userspace/ncr.c
index 9fb56ad..ee812ab 100644
--- a/crypto/userspace/ncr.c
+++ b/crypto/userspace/ncr.c
@@ -44,6 +44,411 @@
  */
 struct key_item_st master_key;
 
+static struct mutex lists_ida_mutex;
+static DEFINE_IDA(lists_ida);
+
+struct ncr_lists *ncr_init_lists(void)
+{
+	struct ncr_lists *lst;
+
+	lst = kmalloc(sizeof(*lst), GFP_KERNEL);
+	if(!lst) {
+		err();
+		return NULL;
+	}
+
+	memset(lst, 0, sizeof(*lst));
+
+	mutex_init(&lists_ida_mutex);
+	mutex_lock(&lists_ida_mutex);
+	/* ida_pre_get() should preallocate enough, and, due to lists_ida_mutex,
+	   nobody else can use the preallocated data.  Therefore the loop
+	   recommended in idr_get_new() documentation is not necessary. */
+	if (ida_pre_get(&lists_ida, GFP_KERNEL) == 0 ||
+	    ida_get_new(&lists_ida, &lst->id) != 0) {
+		mutex_unlock(&lists_ida_mutex);
+		kfree(lst);
+		return NULL;
+	}
+	mutex_unlock(&lists_ida_mutex);
+
+	mutex_init(&lst->key_idr_mutex);
+	idr_init(&lst->key_idr);
+
+	mutex_init(&lst->session_idr_mutex);
+	idr_init(&lst->session_idr);
+
+	return lst;
+}
+
+void ncr_deinit_lists(struct ncr_lists *lst)
+{
+	if(lst) {
+		ncr_key_list_deinit(lst);
+		ncr_sessions_list_deinit(lst);
+
+		mutex_lock(&lists_ida_mutex);
+		ida_remove(&lists_ida, lst->id);
+		mutex_unlock(&lists_ida_mutex);
+
+		kfree(lst);
+	}
+}
+
+void ncr_master_key_reset(void)
+{
+	memset(&master_key, 0, sizeof(master_key));
+}
+
+static int ncr_master_key_set(const struct ncr_master_key_set *st,
+			      struct nlattr *tb[])
+{
+struct audit_buffer *ab;
+int ret;
+
+	/* This will also cause auditing of the syscall, including information
+	   about the process, and success/failure indication.  Note that on
+	   error the AUDIT_CRYPTO_STORAGE_KEY record will be empty. */
+	ab = audit_log_start(current->audit_context, GFP_KERNEL,
+			     AUDIT_CRYPTO_STORAGE_KEY);
+
+	if (current_euid() != 0 && !capable(CAP_SYS_ADMIN)) {
+		err();
+		ret = -EPERM;
+		goto end;
+	}
+
+	if (st->key_size > sizeof(master_key.key.secret.data)) {
+		err();
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (st->key_size != 16 && st->key_size != 24 && st->key_size != 32) {
+		dprintk(0, KERN_DEBUG, "Master key size must be 16,24 or 32.\n");
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (master_key.type != NCR_KEY_TYPE_INVALID) {
+		dprintk(0, KERN_DEBUG, "Master key was previously initialized.\n");
+	}
+
+	if (unlikely(copy_from_user(master_key.key.secret.data, st->key,
+				    st->key_size))) {
+		err();
+		ret = -EFAULT;
+		goto end;
+	}
+
+	dprintk(0, KERN_INFO, "Initializing master key.\n");
+	/* Not much we can reveal... */
+	audit_log_format(ab, "key_size=%u", (unsigned)st->key_size);
+
+	master_key.type = NCR_KEY_TYPE_SECRET;
+	master_key.key.secret.size = st->key_size;
+
+	ret = 0;
+
+end:
+	audit_log_end(ab);
+
+	return ret;
+}
+
+int
+ncr_ioctl(struct ncr_lists *lst, unsigned int cmd, unsigned long arg_)
+{
+	void __user *arg = (void __user *)arg_;
+	struct nlattr *tb[NCR_ATTR_MAX + 1];
+	void *attr_buf;
+	int ret;
+
+	if (unlikely(!lst))
+		BUG();
+
+	switch (cmd) {
+#define CASE_(LABEL, STRUCT, FUNCTION, ARGS)				\
+	case (LABEL): {							\
+		struct STRUCT data;					\
+									\
+		attr_buf = NCR_GET_INPUT_ARGS_NO_OUTPUT(&data, tb, arg); \
+		if (IS_ERR(attr_buf)) {					\
+			err();						\
+			return PTR_ERR(attr_buf);			\
+		}							\
+		ret = (FUNCTION)ARGS;					\
+		break;							\
+	}
+#define CASE_NO_OUTPUT(LABEL, STRUCT, FUNCTION)				\
+		CASE_(LABEL, STRUCT, FUNCTION, (lst, &data, tb))
+#define CASE_NO_OUTPUT_COMPAT(LABEL, STRUCT, FUNCTION)			\
+		CASE_(LABEL, STRUCT, FUNCTION, (lst, &data, tb, 0))
+
+	case NCRIO_KEY_INIT:
+		return ncr_key_init(lst);
+	CASE_NO_OUTPUT(NCRIO_KEY_GENERATE, ncr_key_generate, ncr_key_generate);
+	CASE_NO_OUTPUT(NCRIO_KEY_GENERATE_PAIR, ncr_key_generate_pair,
+		       ncr_key_generate_pair);
+	CASE_NO_OUTPUT(NCRIO_KEY_DERIVE, ncr_key_derive, ncr_key_derive);
+	case NCRIO_KEY_GET_INFO: {
+		struct ncr_key_get_info data;
+		struct ncr_out out;
+
+		attr_buf = NCR_GET_INPUT_ARGS(&data, tb, arg);
+		if (IS_ERR(attr_buf)) {
+			err();
+			return PTR_ERR(attr_buf);
+		}
+		ret = NCR_OUT_INIT(&out, &data, arg);
+		if (ret != 0) {
+			err();
+			break;
+		}
+		ret = ncr_key_get_info(lst, &out, &data, tb);
+		ncr_out_free(&out);
+		break;
+	}
+	CASE_NO_OUTPUT(NCRIO_KEY_EXPORT, ncr_key_export, ncr_key_export);
+	CASE_NO_OUTPUT(NCRIO_KEY_IMPORT, ncr_key_import, ncr_key_import);
+	case NCRIO_KEY_DEINIT: {
+		ncr_key_t key;
+
+		ret = get_user(key, (const ncr_key_t __user *)arg);
+		if (unlikely(ret)) {
+			err();
+			return ret;
+		}
+		return ncr_key_deinit(lst, key);
+	}
+	CASE_NO_OUTPUT(NCRIO_KEY_WRAP, ncr_key_wrap, ncr_key_wrap);
+	CASE_NO_OUTPUT(NCRIO_KEY_UNWRAP, ncr_key_unwrap, ncr_key_unwrap);
+	CASE_NO_OUTPUT(NCRIO_KEY_STORAGE_WRAP, ncr_key_storage_wrap,
+		       ncr_key_storage_wrap);
+	CASE_NO_OUTPUT(NCRIO_KEY_STORAGE_UNWRAP, ncr_key_storage_unwrap,
+		       ncr_key_storage_unwrap);
+	CASE_NO_OUTPUT(NCRIO_SESSION_INIT, ncr_session_init, ncr_session_init);
+	CASE_NO_OUTPUT_COMPAT(NCRIO_SESSION_UPDATE, ncr_session_update,
+			      ncr_session_update);
+	CASE_NO_OUTPUT_COMPAT(NCRIO_SESSION_FINAL, ncr_session_final,
+			      ncr_session_final);
+	CASE_NO_OUTPUT_COMPAT(NCRIO_SESSION_ONCE, ncr_session_once,
+			      ncr_session_once);
+	CASE_(NCRIO_MASTER_KEY_SET, ncr_master_key_set, ncr_master_key_set,
+	      (&data, tb));
+	default:
+		return -EINVAL;
+#undef CASE_
+#undef CASE_NO_OUTPUT
+#undef CASE_NO_OUTPUT_COMPAT
+	}
+	kfree(attr_buf);
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_ncr_key_export {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	compat_uptr_t buffer;
+	compat_int_t buffer_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_EXPORT _IOWR('c', 209, struct compat_ncr_key_export)
+
+static void convert_ncr_key_export(struct ncr_key_export *new,
+				   const struct compat_ncr_key_export *old)
+{
+	new->key = old->key;
+	new->buffer = compat_ptr(old->buffer);
+	new->buffer_size = old->buffer_size;
+}
+
+struct compat_ncr_key_import {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	compat_uptr_t data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_IMPORT _IOWR('c', 210, struct compat_ncr_key_import)
+
+static void convert_ncr_key_import(struct ncr_key_import *new,
+				   const struct compat_ncr_key_import *old)
+{
+	new->key = old->key;
+	new->data = compat_ptr(old->data);
+	new->data_size = old->data_size;
+}
+
+struct compat_ncr_key_wrap {
+	__u32 input_size, output_size;
+	ncr_key_t wrapping_key;
+	ncr_key_t source_key;
+	compat_uptr_t buffer;
+	compat_int_t buffer_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_WRAP _IOWR('c', 250, struct compat_ncr_key_wrap)
+
+static void convert_ncr_key_wrap(struct ncr_key_wrap *new,
+				 const struct compat_ncr_key_wrap *old)
+{
+	new->wrapping_key = old->wrapping_key;
+	new->source_key = old->source_key;
+	new->buffer = compat_ptr(old->buffer);
+	new->buffer_size = old->buffer_size;
+}
+
+struct compat_ncr_key_unwrap {
+	__u32 input_size, output_size;
+	ncr_key_t wrapping_key;
+	ncr_key_t dest_key;
+	compat_uptr_t data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_UNWRAP _IOWR('c', 251, struct compat_ncr_key_unwrap)
+
+static void convert_ncr_key_unwrap(struct ncr_key_unwrap *new,
+				   const struct compat_ncr_key_unwrap *old)
+{
+	new->wrapping_key = old->wrapping_key;
+	new->dest_key = old->dest_key;
+	new->data = compat_ptr(old->data);
+	new->data_size = old->data_size;
+}
+
+struct compat_ncr_key_storage_wrap {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	compat_uptr_t buffer;
+	compat_int_t buffer_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_STORAGE_WRAP				\
+	_IOWR('c', 261, struct compat_ncr_key_storage_wrap)
+
+static void convert_ncr_key_storage_wrap(struct ncr_key_storage_wrap *new,
+					 const struct compat_ncr_key_storage_wrap *old)
+{
+	new->key = old->key;
+	new->buffer = compat_ptr(old->buffer);
+	new->buffer_size = old->buffer_size;
+}
+
+struct compat_ncr_key_storage_unwrap {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	compat_uptr_t data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_KEY_STORAGE_UNWRAP				\
+	_IOWR('c', 262, struct compat_ncr_key_storage_wrap)
+
+static void convert_ncr_key_storage_unwrap(struct ncr_key_storage_unwrap *new,
+					   const struct compat_ncr_key_storage_unwrap *old)
+{
+	new->key = old->key;
+	new->data = compat_ptr(old->data);
+	new->data_size = old->data_size;
+}
+
+struct compat_ncr_master_key_set {
+	__u32 input_size, output_size;
+	compat_uptr_t key;
+	__u32 key_size;
+	__NL_ATTRIBUTES;
+};
+#define COMPAT_NCRIO_MASTER_KEY_SET				\
+	_IOWR('c', 260, struct compat_ncr_master_key_set)
+
+static void convert_ncr_master_key_set(struct ncr_master_key_set *new,
+				       const struct compat_ncr_master_key_set *old)
+{
+	new->key = compat_ptr(old->key);
+	new->key_size = old->key_size;
+}
+
+long
+ncr_compat_ioctl(struct ncr_lists *lst, unsigned int cmd, unsigned long arg_)
+{
+	void __user *arg = (void __user *)arg_;
+	struct nlattr *tb[NCR_ATTR_MAX + 1];
+	void *attr_buf;
+	int ret;
+
+	if (unlikely(!lst))
+		BUG();
+
+	switch (cmd) {
+	case NCRIO_KEY_INIT:
+	case NCRIO_KEY_GENERATE:
+	case NCRIO_KEY_GENERATE_PAIR:
+	case NCRIO_KEY_DERIVE:
+	case NCRIO_KEY_GET_INFO:
+	case NCRIO_KEY_DEINIT:
+	case NCRIO_SESSION_INIT:
+		return ncr_ioctl(lst, cmd, arg_);
+
+#define CASE_(LABEL, STRUCT, FUNCTION, ARGS)				\
+	case (LABEL): {							\
+		struct compat_##STRUCT old;				\
+		struct STRUCT new;					\
+									\
+		attr_buf = NCR_GET_INPUT_ARGS_NO_OUTPUT(&old, tb, arg);	\
+		if (IS_ERR(attr_buf)) {					\
+			err();						\
+			return PTR_ERR(attr_buf);			\
+		}							\
+		convert_##STRUCT(&new, &old);				\
+		ret = (FUNCTION)ARGS;					\
+		break;							\
+	}
+#define CASE_NO_OUTPUT(LABEL, STRUCT, FUNCTION)			\
+		CASE_(LABEL, STRUCT, FUNCTION, (lst, &new, tb))
+
+#define CASE_COMPAT_ONLY(LABEL, STRUCT, FUNCTION)			\
+	case (LABEL): {							\
+		struct STRUCT data;					\
+									\
+		attr_buf = NCR_GET_INPUT_ARGS_NO_OUTPUT(&data, tb, arg); \
+		if (IS_ERR(attr_buf)) {					\
+			err();						\
+			return PTR_ERR(attr_buf);			\
+		}							\
+		ret = (FUNCTION)(lst, &data, tb, 1);			\
+		break;							\
+	}
+
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_EXPORT, ncr_key_export, ncr_key_export);
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_IMPORT, ncr_key_import, ncr_key_import);
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_WRAP, ncr_key_wrap, ncr_key_wrap);
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_UNWRAP, ncr_key_unwrap, ncr_key_unwrap);
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_STORAGE_WRAP, ncr_key_storage_wrap,
+		       ncr_key_storage_wrap);
+	CASE_NO_OUTPUT(COMPAT_NCRIO_KEY_STORAGE_UNWRAP, ncr_key_storage_unwrap,
+		       ncr_key_storage_unwrap);
+	CASE_COMPAT_ONLY(NCRIO_SESSION_UPDATE, ncr_session_update,
+			 ncr_session_update);
+	CASE_COMPAT_ONLY(NCRIO_SESSION_FINAL, ncr_session_final,
+			 ncr_session_final);
+	CASE_COMPAT_ONLY(NCRIO_SESSION_ONCE, ncr_session_once,
+			 ncr_session_once);
+	CASE_(COMPAT_NCRIO_MASTER_KEY_SET, ncr_master_key_set,
+	      ncr_master_key_set, (&new, tb));
+	default:
+		return -EINVAL;
+#undef CASE_
+#undef CASE_NO_OUTPUT
+#undef CASE_COMPAT_ONLY
+	}
+	kfree(attr_buf);
+	return ret;
+}
+#endif
+
 int ncr_session_input_data_from_nla(struct ncr_session_input_data *dest,
 				    const struct nlattr *nla, int compat)
 {
-- 
1.7.2.1

