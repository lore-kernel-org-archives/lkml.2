Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1AFMHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:07:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62225 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1AFMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=e3BkOG9D2GJ5ZpFPgOBivalM1Tbako0Y62LQSMiolNy+gBzWD9sWUSAkG6P7+R/Ho3
         Wi4rLGUgVlPYtLkeV99/sM+W0jKJXMTa1Zt7R6p7X7VGXebH/4NVN+NPN4rvYIS6U5ia
         ZL91pb0To+71yAppzNvE09b+4d53MKNc8PyxU=
Message-ID: <4D25AF95.6010103@gmail.com>
Date: Thu, 06 Jan 2011 13:03:33 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 11/17] pramfs: ACL management
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

ACL operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff --git a/fs/pramfs/acl.c b/fs/pramfs/acl.c
new file mode 100644
index 0000000..53090a5
--- /dev/null
+++ b/fs/pramfs/acl.c
@@ -0,0 +1,433 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * POSIX ACL operations
+ *
+ * Copyright 2010 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * based on fs/ext2/acl.c with the following copyright:
+ *
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/capability.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include "pram.h"
+#include "xattr.h"
+#include "acl.h"
+
+/*
+ * Load ACL information from filesystem.
+ */
+static struct posix_acl *pram_acl_load(const void *value, size_t size)
+{
+	const char *end = (char *)value + size;
+	int n, count;
+	struct posix_acl *acl;
+
+	if (!value)
+		return NULL;
+	if (size < sizeof(struct pram_acl_header))
+		 return ERR_PTR(-EINVAL);
+	if (((struct pram_acl_header *)value)->a_version !=
+	    cpu_to_be32(PRAM_ACL_VERSION))
+		return ERR_PTR(-EINVAL);
+	value = (char *)value + sizeof(struct pram_acl_header);
+	count = pram_acl_count(size);
+	if (count < 0)
+		return ERR_PTR(-EINVAL);
+	if (count == 0)
+		return NULL;
+	acl = posix_acl_alloc(count, GFP_KERNEL);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+	for (n = 0; n < count; n++) {
+		struct pram_acl_entry *entry = (struct pram_acl_entry *)value;
+		if ((char *)value + sizeof(struct pram_acl_entry_short) > end)
+			goto fail;
+		acl->a_entries[n].e_tag  = be16_to_cpu(entry->e_tag);
+		acl->a_entries[n].e_perm = be16_to_cpu(entry->e_perm);
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			value = (char *)value +
+				sizeof(struct pram_acl_entry_short);
+			acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
+			break;
+		case ACL_USER:
+		case ACL_GROUP:
+			value = (char *)value + sizeof(struct pram_acl_entry);
+			if ((char *)value > end)
+				goto fail;
+			acl->a_entries[n].e_id =
+				be32_to_cpu(entry->e_id);
+			break;
+		default:
+			goto fail;
+		}
+	}
+	if (value != end)
+		goto fail;
+	return acl;
+
+fail:
+	posix_acl_release(acl);
+	return ERR_PTR(-EINVAL);
+}
+
+/*
+ * Save ACL information into the filesystem.
+ */
+static void *pram_acl_save(const struct posix_acl *acl, size_t *size)
+{
+	struct pram_acl_header *ext_acl;
+	char *e;
+	size_t n;
+
+	*size = pram_acl_size(acl->a_count);
+	ext_acl = kmalloc(sizeof(struct pram_acl_header) + acl->a_count *
+			sizeof(struct pram_acl_entry), GFP_KERNEL);
+	if (!ext_acl)
+		return ERR_PTR(-ENOMEM);
+	ext_acl->a_version = cpu_to_be32(PRAM_ACL_VERSION);
+	e = (char *)ext_acl + sizeof(struct pram_acl_header);
+	for (n = 0; n < acl->a_count; n++) {
+		struct pram_acl_entry *entry = (struct pram_acl_entry *)e;
+		entry->e_tag  = cpu_to_be16(acl->a_entries[n].e_tag);
+		entry->e_perm = cpu_to_be16(acl->a_entries[n].e_perm);
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			entry->e_id =
+				cpu_to_be32(acl->a_entries[n].e_id);
+			e += sizeof(struct pram_acl_entry);
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			e += sizeof(struct pram_acl_entry_short);
+			break;
+		default:
+			goto fail;
+		}
+	}
+	return (char *)ext_acl;
+
+fail:
+	kfree(ext_acl);
+	return ERR_PTR(-EINVAL);
+}
+
+/*
+ * inode->i_mutex: don't care
+ */
+static struct posix_acl *pram_get_acl(struct inode *inode, int type)
+{
+	int name_index;
+	char *value = NULL;
+	struct posix_acl *acl;
+	int retval;
+
+	if (!test_opt(inode->i_sb, POSIX_ACL))
+		return NULL;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = PRAM_XATTR_INDEX_POSIX_ACL_ACCESS;
+		break;
+	case ACL_TYPE_DEFAULT:
+		name_index = PRAM_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		break;
+	default:
+		BUG();
+	}
+	retval = pram_xattr_get(inode, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_KERNEL);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = pram_xattr_get(inode, name_index, "", value, retval);
+	}
+	if (retval > 0)
+		acl = pram_acl_load(value, retval);
+	else if (retval == -ENODATA || retval == -ENOSYS)
+		acl = NULL;
+	else
+		acl = ERR_PTR(retval);
+	kfree(value);
+
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
+
+	return acl;
+}
+
+/*
+ * inode->i_mutex: down
+ */
+static int pram_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	int name_index;
+	void *value = NULL;
+	size_t size = 0;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	if (!test_opt(inode->i_sb, POSIX_ACL))
+		return 0;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = PRAM_XATTR_INDEX_POSIX_ACL_ACCESS;
+		if (acl) {
+			mode_t mode = inode->i_mode;
+			error = posix_acl_equiv_mode(acl, &mode);
+			if (error < 0)
+				return error;
+			else {
+				inode->i_mode = mode;
+				inode->i_ctime = CURRENT_TIME_SEC;
+				mark_inode_dirty(inode);
+				if (error == 0)
+					acl = NULL;
+			}
+		}
+		break;
+	case ACL_TYPE_DEFAULT:
+		name_index = PRAM_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (acl) {
+		value = pram_acl_save(acl, &size);
+		if (IS_ERR(value))
+			return (int)PTR_ERR(value);
+	}
+
+	error = pram_xattr_set(inode, name_index, "", value, size, 0);
+
+	kfree(value);
+	if (!error)
+		set_cached_acl(inode, type, acl);
+	return error;
+}
+
+int pram_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl = pram_get_acl(inode, ACL_TYPE_ACCESS);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		int error = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+		return error;
+	}
+
+	return -EAGAIN;
+}
+
+/*
+ * Initialize the ACLs of a new inode. Called from pram_new_inode.
+ *
+ * dir->i_mutex: down
+ * inode->i_mutex: up (access to inode is still exclusive)
+ */
+int pram_init_acl(struct inode *inode, struct inode *dir)
+{
+	struct posix_acl *acl = NULL;
+	int error = 0;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		if (test_opt(dir->i_sb, POSIX_ACL)) {
+			acl = pram_get_acl(dir, ACL_TYPE_DEFAULT);
+			if (IS_ERR(acl))
+				return PTR_ERR(acl);
+		}
+		if (!acl)
+			inode->i_mode &= ~current_umask();
+	}
+
+	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
+		struct posix_acl *clone;
+		mode_t mode;
+
+		if (S_ISDIR(inode->i_mode)) {
+			error = pram_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+			if (error)
+				goto cleanup;
+		}
+		clone = posix_acl_clone(acl, GFP_KERNEL);
+		error = -ENOMEM;
+		if (!clone)
+			goto cleanup;
+		mode = inode->i_mode;
+		error = posix_acl_create_masq(clone, &mode);
+		if (error >= 0) {
+			inode->i_mode = mode;
+			if (error > 0) {
+				/* This is an extended ACL */
+				error = pram_set_acl(inode,
+						     ACL_TYPE_ACCESS, clone);
+			}
+		}
+		posix_acl_release(clone);
+	}
+cleanup:
+       posix_acl_release(acl);
+       return error;
+}
+
+/*
+ * Does chmod for an inode that may have an Access Control List. The
+ * inode->i_mode field must be updated to the desired value by the caller
+ * before calling this function.
+ * Returns 0 on success, or a negative error number.
+ *
+ * We change the ACL rather than storing some ACL entries in the file
+ * mode permission bits (which would be more efficient), because that
+ * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
+ * for directories) are added. There are no more bits available in the
+ * file mode.
+ *
+ * inode->i_mutex: down
+ */
+int pram_acl_chmod(struct inode *inode)
+{
+	struct posix_acl *acl, *clone;
+	int error;
+
+	if (!test_opt(inode->i_sb, POSIX_ACL))
+		return 0;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = pram_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+	error = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!error)
+		error = pram_set_acl(inode, ACL_TYPE_ACCESS, clone);
+	posix_acl_release(clone);
+	return error;
+}
+
+/*
+ * Extended attribut handlers
+ */
+static size_t pram_xattr_list_acl_access(struct dentry *dentry, char *list,
+					size_t list_size, const char *name,
+					size_t name_len, int type)
+{
+	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
+
+	if (!test_opt(dentry->d_sb, POSIX_ACL))
+		return 0;
+	if (list && size <= list_size)
+		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
+	return size;
+}
+
+static size_t pram_xattr_list_acl_default(struct dentry *dentry, char *list,
+					  size_t list_size, const char *name,
+					  size_t name_len, int type)
+{
+	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
+
+	if (!test_opt(dentry->d_sb, POSIX_ACL))
+		return 0;
+	if (list && size <= list_size)
+		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
+	return size;
+}
+
+static int pram_xattr_get_acl(struct dentry *dentry, const char *name,
+			      void *buffer, size_t size, int type)
+{
+	struct posix_acl *acl;
+	int error;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	if (!test_opt(dentry->d_sb, POSIX_ACL))
+		return -EOPNOTSUPP;
+
+	acl = pram_get_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = posix_acl_to_xattr(acl, buffer, size);
+	posix_acl_release(acl);
+
+	return error;
+}
+
+static int pram_xattr_set_acl(struct dentry *dentry, const char *name,
+			      const void *value, size_t size, int flags, int type)
+{
+	struct posix_acl *acl;
+	int error;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	if (!test_opt(dentry->d_sb, POSIX_ACL))
+		return -EOPNOTSUPP;
+	if (!is_owner_or_cap(dentry->d_inode))
+		return -EPERM;
+
+	if (value) {
+		acl = posix_acl_from_xattr(value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		else if (acl) {
+			error = posix_acl_valid(acl);
+			if (error)
+				goto release_and_out;
+		}
+	} else
+		acl = NULL;
+
+	error = pram_set_acl(dentry->d_inode, type, acl);
+
+release_and_out:
+	posix_acl_release(acl);
+	return error;
+}
+
+const struct xattr_handler pram_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.list	= pram_xattr_list_acl_access,
+	.get	= pram_xattr_get_acl,
+	.set	= pram_xattr_set_acl,
+};
+
+const struct xattr_handler pram_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.list	= pram_xattr_list_acl_default,
+	.get	= pram_xattr_get_acl,
+	.set	= pram_xattr_set_acl,
+};
diff --git a/fs/pramfs/acl.h b/fs/pramfs/acl.h
new file mode 100644
index 0000000..3970dbe
--- /dev/null
+++ b/fs/pramfs/acl.h
@@ -0,0 +1,86 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * POSIX ACL operations
+ *
+ * Copyright 2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Based on fs/ext2/acl.h with the following copyright:
+ *
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
+ *
+ */
+
+#include <linux/posix_acl_xattr.h>
+
+#define PRAM_ACL_VERSION	0x0001
+
+struct pram_acl_entry {
+	__be16		e_tag;
+	__be16		e_perm;
+	__be32		e_id;
+};
+
+struct pram_acl_entry_short {
+	__be16		e_tag;
+	__be16		e_perm;
+};
+
+struct pram_acl_header {
+	__be32		a_version;
+};
+
+static inline size_t pram_acl_size(int count)
+{
+	if (count <= 4) {
+		return sizeof(struct pram_acl_header) +
+		       count * sizeof(struct pram_acl_entry_short);
+	} else {
+		return sizeof(struct pram_acl_header) +
+		       4 * sizeof(struct pram_acl_entry_short) +
+		       (count - 4) * sizeof(struct pram_acl_entry);
+	}
+}
+
+static inline int pram_acl_count(size_t size)
+{
+	ssize_t s;
+	size -= sizeof(struct pram_acl_header);
+	s = size - 4 * sizeof(struct pram_acl_entry_short);
+	if (s < 0) {
+		if (size % sizeof(struct pram_acl_entry_short))
+			return -1;
+		return size / sizeof(struct pram_acl_entry_short);
+	} else {
+		if (s % sizeof(struct pram_acl_entry))
+			return -1;
+		return s / sizeof(struct pram_acl_entry) + 4;
+	}
+}
+
+#ifdef CONFIG_PRAMFS_POSIX_ACL
+
+/* acl.c */
+extern int pram_check_acl(struct inode *, int);
+extern int pram_acl_chmod(struct inode *);
+extern int pram_init_acl(struct inode *, struct inode *);
+
+#else
+#include <linux/sched.h>
+#define pram_check_acl	NULL
+#define pram_get_acl	NULL
+#define pram_set_acl	NULL
+
+static inline int pram_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int pram_init_acl(struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+#endif
