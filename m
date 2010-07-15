Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0GOAoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:44:23 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57100 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab0GOAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:15 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 07/13] AppArmor: userspace interfaces
Date: Wed, 14 Jul 2010 17:43:35 -0700
Message-Id: <1279154621-25868-8-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/<pid>/attr/* interface is used for process introspection and
commands.  While the apparmorfs interface is used for global introspection
and loading and removing policy.

The interface currently only contains the files necessary for loading
policy, and will be extended in the future to include sysfs style
single per file introspection inteface.

The old AppArmor 2.4 interface files have been removed into a compatibility
patch, that distros can use to maintain backwards compatibility.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/apparmorfs.c         |  287 ++++++++++++++++++++++++++++++++
 security/apparmor/include/apparmorfs.h |   23 +++
 security/apparmor/include/procattr.h   |   26 +++
 security/apparmor/procattr.c           |  167 ++++++++++++++++++
 4 files changed, 503 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/apparmorfs.c
 create mode 100644 security/apparmor/include/apparmorfs.h
 create mode 100644 security/apparmor/include/procattr.h
 create mode 100644 security/apparmor/procattr.c

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
new file mode 100644
index 0000000..c6afe5c
--- /dev/null
+++ b/security/apparmor/apparmorfs.c
@@ -0,0 +1,287 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /sys/kernel/security/apparmor interface functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/security.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/namei.h>
+
+#include "include/apparmor.h"
+#include "include/apparmorfs.h"
+#include "include/audit.h"
+#include "include/context.h"
+#include "include/policy.h"
+
+/**
+ * kvmalloc - do allocation prefering kmalloc but falling back to vmalloc
+ * @size: size of allocation
+ *
+ * Return: allocated buffer or NULL if failed
+ *
+ * It is possible that policy being loaded from the user is larger than
+ * what can be allocated by kmalloc, in those cases fall back to vmalloc.
+ */
+static void *kvmalloc(size_t size)
+{
+	void *buffer = NULL;
+
+	if (size == 0)
+		return NULL;
+
+	/* do not attempt kmalloc if we need more than 16 pages at once */
+	if (size <= (16*PAGE_SIZE))
+		buffer = kmalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (!buffer)
+		buffer = vmalloc(size);
+	return buffer;
+}
+
+/**
+ * kvfree - free an allocation do by kvmalloc
+ * @buffer: buffer to free
+ *
+ * Free a buffer allocated by kvmalloc
+ */
+static void kvfree(void *buffer)
+{
+	if (!buffer)
+		return;
+
+	if (is_vmalloc_addr(buffer))
+		vfree(buffer);
+	else
+		kfree(buffer);
+}
+
+/**
+ * aa_simple_write_to_buffer - common routine for getting policy from user
+ * @op: operation doing the user buffer copy
+ * @userbuf: user buffer to copy data from  (NOT NULL)
+ * @alloc_size: size of user buffer
+ * @copy_size: size of data to copy from user buffer
+ * @pos: position write is at in the file
+ *
+ * Returns: kernel buffer containing copy of user buffer data or an
+ *          ERR_PTR on failure.
+ */
+static char *aa_simple_write_to_buffer(int op, const char __user *userbuf,
+				       size_t alloc_size, size_t copy_size,
+				       loff_t *pos)
+{
+	char *data;
+
+	if (*pos != 0) {
+		/* only writes from pos 0, that is complete writes */
+		data = ERR_PTR(-ESPIPE);
+		goto out;
+	}
+
+	/*
+	 * Don't allow profile load/replace/remove from profiles that don't
+	 * have CAP_MAC_ADMIN
+	 */
+	if (!aa_may_manage_policy(op))
+		return ERR_PTR(-EACCES);
+
+	/* freed by caller to simple_write_to_buffer */
+	data = kvmalloc(alloc_size);
+	if (data == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(data, userbuf, copy_size)) {
+		kvfree(data);
+		data = ERR_PTR(-EFAULT);
+		goto out;
+	}
+
+out:
+	return data;
+}
+
+
+/* .load file hook fn to load policy */
+static ssize_t profile_load(struct file *f, const char __user *buf, size_t size,
+			    loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	data = aa_simple_write_to_buffer(OP_PROF_LOAD, buf, size, size, pos);
+
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		error = aa_replace_profiles(data, size, PROF_ADD);
+		kvfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_load = {
+	.write = profile_load
+};
+
+/* .replace file hook fn to load and/or replace policy */
+static ssize_t profile_replace(struct file *f, const char __user *buf,
+			       size_t size, loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	data = aa_simple_write_to_buffer(OP_PROF_REPL, buf, size, size, pos);
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		error = aa_replace_profiles(data, size, PROF_REPLACE);
+		kvfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_replace = {
+	.write = profile_replace
+};
+
+/* .remove file hook fn to remove loaded policy */
+static ssize_t profile_remove(struct file *f, const char __user *buf,
+			      size_t size, loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	/*
+	 * aa_remove_profile needs a null terminated string so 1 extra
+	 * byte is allocated and the copied data is null terminated.
+	 */
+	data = aa_simple_write_to_buffer(OP_PROF_RM, buf, size + 1, size, pos);
+
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		data[size] = 0;
+		error = aa_remove_profiles(data, size);
+		kvfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_remove = {
+	.write = profile_remove
+};
+
+/** Base file system setup **/
+
+static struct dentry *aa_fs_dentry;
+struct dentry *aa_fs_null;
+struct vfsmount *aa_fs_mnt;
+
+static void aafs_remove(const char *name)
+{
+	struct dentry *dentry;
+
+	dentry = lookup_one_len(name, aa_fs_dentry, strlen(name));
+	if (!IS_ERR(dentry)) {
+		securityfs_remove(dentry);
+		dput(dentry);
+	}
+}
+
+/**
+ * aafs_create - create an entry in the apparmor filesystem
+ * @name: name of the entry
+ * @mask: file permission mask of the file
+ * @fops: file operations for the file
+ *
+ * Used aafs_remove to remove entries created with this fn.
+ */
+static int aafs_create(const char *name, int mask,
+		       const struct file_operations *fops)
+{
+	struct dentry *dentry;
+
+	dentry = securityfs_create_file(name, S_IFREG | mask, aa_fs_dentry,
+					NULL, fops);
+
+	return IS_ERR(dentry) ? PTR_ERR(dentry) : 0;
+}
+
+/**
+ * aa_destroy_aafs - cleanup and free aafs
+ *
+ * releases dentries allocated by aa_create_aafs
+ */
+void aa_destroy_aafs(void)
+{
+	if (aa_fs_dentry) {
+		aafs_remove(".remove");
+		aafs_remove(".replace");
+		aafs_remove(".load");
+		aafs_remove("profiles");
+
+		securityfs_remove(aa_fs_dentry);
+		aa_fs_dentry = NULL;
+	}
+}
+
+/**
+ * aa_create_aafs - create the apparmor security filesystem
+ *
+ * dentries created here are released by aa_destroy_aafs
+ *
+ * Returns: error on failure
+ */
+int aa_create_aafs(void)
+{
+	int error;
+
+	if (!apparmor_initialized)
+		return 0;
+
+	if (aa_fs_dentry) {
+		AA_ERROR("%s: AppArmor securityfs already exists\n", __func__);
+		return -EEXIST;
+	}
+
+	aa_fs_dentry = securityfs_create_dir("apparmor", NULL);
+	if (IS_ERR(aa_fs_dentry)) {
+		error = PTR_ERR(aa_fs_dentry);
+		aa_fs_dentry = NULL;
+		goto error;
+	}
+
+	error = aafs_create(".load", 0640, &aa_fs_profile_load);
+	if (error)
+		goto error;
+	error = aafs_create(".replace", 0640, &aa_fs_profile_replace);
+	if (error)
+		goto error;
+	error = aafs_create(".remove", 0640, &aa_fs_profile_remove);
+	if (error)
+		goto error;
+
+	/* TODO: add support for apparmorfs_null and apparmorfs_mnt */
+
+	/* Report that AppArmor fs is enabled */
+	aa_info_message("AppArmor Filesystem Enabled");
+	return 0;
+
+error:
+	aa_destroy_aafs();
+	AA_ERROR("Error creating AppArmor securityfs\n");
+	return error;
+}
+
+fs_initcall(aa_create_aafs);
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
new file mode 100644
index 0000000..fbc0439
--- /dev/null
+++ b/security/apparmor/include/apparmorfs.h
@@ -0,0 +1,23 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor filesystem definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_APPARMORFS_H
+#define __AA_APPARMORFS_H
+
+extern struct dentry *aa_fs_null;
+extern struct vfsmount *aa_fs_mnt;
+
+extern void aa_destroy_aafs(void);
+
+#endif /* __AA_APPARMORFS_H */
diff --git a/security/apparmor/include/procattr.h b/security/apparmor/include/procattr.h
new file mode 100644
index 0000000..6c6f271
--- /dev/null
+++ b/security/apparmor/include/procattr.h
@@ -0,0 +1,26 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /proc/<pid>/attr/ interface function defintions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_PROCATTR_H
+#define __AA_PROCATTR_H
+
+#define AA_DO_TEST 1
+#define AA_ONEXEC  1
+
+int aa_getprocattr(struct aa_profile *profile, char **string);
+int aa_setprocattr_changehat(char *args, size_t size, int test);
+int aa_setprocattr_changeprofile(char *fqname, int onexec, int test);
+int aa_setprocattr_permipc(char *fqname);
+
+#endif /* __AA_PROCATTR_H */
diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
new file mode 100644
index 0000000..fffc3ce
--- /dev/null
+++ b/security/apparmor/procattr.c
@@ -0,0 +1,167 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /proc/<pid>/attr/ interface functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include "include/apparmor.h"
+#include "include/context.h"
+#include "include/policy.h"
+#include "include/domain.h"
+
+
+/**
+ * aa_getprocattr - Return the profile information for @profile
+ * @profile: the profile to print profile info about  (NOT NULL)
+ * @string: the string that will contain the profile and namespace info (!NULL)
+ *
+ * Returns: length of @string on success else error on failure
+ *
+ * Requires: profile != NULL
+ *
+ * Creates a string containing the namespace_name://profile_name for
+ * @profile.
+ *
+ * Returns: size of string placed in @string else error code on failure
+ */
+int aa_getprocattr(struct aa_profile *profile, char **string)
+{
+	char *str;
+	int len = 0, mode_len = 0, ns_len = 0, name_len;
+	const char *mode_str = profile_mode_names[profile->mode];
+	const char *ns_name = NULL;
+	struct aa_namespace *ns = profile->ns;
+	struct aa_namespace *current_ns = __aa_current_profile()->ns;
+	char *s;
+
+	if (!aa_ns_visible(current_ns, ns))
+		return -EACCES;
+
+	ns_name = aa_ns_name(current_ns, ns);
+	ns_len = strlen(ns_name);
+
+	/* if the visible ns_name is > 0 increase size for : :// seperator */
+	if (ns_len)
+		ns_len += 4;
+
+	/* unconfined profiles don't have a mode string appended */
+	if (!unconfined(profile))
+		mode_len = strlen(mode_str) + 3;	/* + 3 for _() */
+
+	name_len = strlen(profile->base.hname);
+	len = mode_len + ns_len + name_len + 1;	    /*+ 1 for \n */
+	s = str = kmalloc(len + 1, GFP_KERNEL);	    /* + 1 \0 */
+	if (!str)
+		return -ENOMEM;
+
+	if (ns_len) {
+		/* skip over prefix current_ns->base.hname and seperating // */
+		sprintf(s, ":%s://", ns_name);
+		s += ns_len;
+	}
+	if (unconfined(profile))
+		/* mode string not being appended */
+		sprintf(s, "%s\n", profile->base.hname);
+	else
+		sprintf(s, "%s (%s)\n", profile->base.hname, mode_str);
+	*string = str;
+
+	/* NOTE: len does not include \0 of string, not saved as part of file */
+	return len;
+}
+
+/**
+ * split_token_from_name - separate a string of form  <token>^<name>
+ * @op: operation being checked
+ * @args: string to parse  (NOT NULL)
+ * @token: stores returned parsed token value  (NOT NULL)
+ *
+ * Returns: start position of name after token else NULL on failure
+ */
+static char *split_token_from_name(int op, char *args, u64 * token)
+{
+	char *name;
+
+	*token = simple_strtoull(args, &name, 16);
+	if ((name == args) || *name != '^') {
+		AA_ERROR("%s: Invalid input '%s'", op_table[op], args);
+		return ERR_PTR(-EINVAL);
+	}
+
+	name++;			/* skip ^ */
+	if (!*name)
+		name = NULL;
+	return name;
+}
+
+/**
+ * aa_setprocattr_chagnehat - handle procattr interface to change_hat
+ * @args: args received from writing to /proc/<pid>/attr/current (NOT NULL)
+ * @size: size of the args
+ * @test: true if this is a test of change_hat permissions
+ *
+ * Returns: %0 or error code if change_hat fails
+ */
+int aa_setprocattr_changehat(char *args, size_t size, int test)
+{
+	char *hat;
+	u64 token;
+	const char *hats[16];		/* current hard limit on # of names */
+	int count = 0;
+
+	hat = split_token_from_name(OP_CHANGE_HAT, args, &token);
+	if (IS_ERR(hat))
+		return PTR_ERR(hat);
+
+	if (!hat && !token) {
+		AA_ERROR("change_hat: Invalid input, NULL hat and NULL magic");
+		return -EINVAL;
+	}
+
+	if (hat) {
+		/* set up hat name vector, args guarenteed null terminated
+		 * at args[size]
+		 */
+		char *end = args + size;
+		for (count = 0; (hat < end) && count < 16; ++count) {
+			char *next = hat + strlen(hat) + 1;
+			hats[count] = hat;
+			hat = next;
+		}
+	}
+
+	AA_DEBUG("%s: Magic 0x%llx Hat '%s'\n",
+		 __func__, token, hat ? hat : NULL);
+
+	return aa_change_hat(hats, count, token, test);
+}
+
+/**
+ * aa_setprocattr_changeprofile - handle procattr interface to changeprofile
+ * @fqname: args received from writting to /proc/<pid>/attr/current (NOT NULL)
+ * @onexec: true if change_profile should be delayed until exec
+ * @test: true if this is a test of change_profile permissions
+ *
+ * Returns: %0 or error code if change_profile fails
+ */
+int aa_setprocattr_changeprofile(char *fqname, int onexec, int test)
+{
+	char *name, *ns_name;
+
+	name = aa_split_fqname(fqname, &ns_name);
+	return aa_change_profile(ns_name, name, onexec, test);
+}
+
+int aa_setprocattr_permipc(char *fqname)
+{
+	/* TODO: add ipc permission querying */
+	return -ENOTSUPP;
+}
-- 
1.7.0.4

