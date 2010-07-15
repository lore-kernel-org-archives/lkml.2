Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0GOAn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:43:58 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56791 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab0GOAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:43:54 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 01/13] AppArmor: misc. base functions and defines
Date: Wed, 14 Jul 2010 17:43:29 -0700
Message-Id: <1279154621-25868-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous functions and defines needed by AppArmor, including
the base path resolution routines.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/apparmor.h |   78 +++++++++++
 security/apparmor/include/path.h     |   32 +++++
 security/apparmor/lib.c              |   84 ++++++++++++
 security/apparmor/path.c             |  243 ++++++++++++++++++++++++++++++++++
 4 files changed, 437 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/apparmor.h
 create mode 100644 security/apparmor/include/path.h
 create mode 100644 security/apparmor/lib.c
 create mode 100644 security/apparmor/path.c

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
new file mode 100644
index 0000000..3b253af
--- /dev/null
+++ b/security/apparmor/include/apparmor.h
@@ -0,0 +1,78 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor basic global and lib definitions
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
+#ifndef __APPARMOR_H
+#define __APPARMOR_H
+
+#include <linux/fs.h>
+
+#include "match.h"
+
+/* Control parameters settable thru module/boot flags or
+ * via /sys/kernel/security/apparmor/control */
+extern enum audit_mode aa_g_audit;
+extern int aa_g_audit_header;
+extern int aa_g_debug;
+extern int aa_g_lock_policy;
+extern int aa_g_logsyscall;
+extern int aa_g_paranoid_load;
+extern unsigned int aa_g_path_max;
+
+/*
+ * DEBUG remains global (no per profile flag) since it is mostly used in sysctl
+ * which is not related to profile accesses.
+ */
+
+#define AA_DEBUG(fmt, args...)						\
+	do {								\
+		if (aa_g_debug && printk_ratelimit())			\
+			printk(KERN_DEBUG "AppArmor: " fmt, ##args);	\
+	} while (0)
+
+#define AA_ERROR(fmt, args...)						\
+	do {								\
+		if (printk_ratelimit())					\
+			printk(KERN_ERR "AppArmor: " fmt, ##args);	\
+	} while (0)
+
+/* Flag indicating whether initialization completed */
+extern int apparmor_initialized;
+void apparmor_disable(void);
+
+/* fn's in lib */
+char *aa_split_fqname(char *args, char **ns_name);
+bool aa_strneq(const char *str, const char *sub, int len);
+void aa_info_message(const char *str);
+
+/**
+ * aa_dfa_null_transition - step to next state after null character
+ * @dfa: the dfa to match against
+ * @start: the state of the dfa to start matching in
+ *
+ * aa_dfa_null_transition transitions to the next state after a null
+ * character which is not used in standard matching and is only
+ * used to seperate pairs.
+ */
+static inline unsigned int aa_dfa_null_transition(struct aa_dfa *dfa,
+						  unsigned int start)
+{
+	return aa_dfa_match_len(dfa, start, "\0", 1);
+}
+
+static inline bool mediated_filesystem(struct inode *inode)
+{
+	return !(inode->i_sb->s_flags & MS_NOUSER);
+}
+
+#endif /* __APPARMOR_H */
diff --git a/security/apparmor/include/path.h b/security/apparmor/include/path.h
new file mode 100644
index 0000000..746a322
--- /dev/null
+++ b/security/apparmor/include/path.h
@@ -0,0 +1,32 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor basic path manipulation function definitions.
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
+#ifndef __AA_PATH_H
+#define __AA_PATH_H
+
+
+enum path_flags {
+	PATH_IS_DIR = 0x1,		/* path is a directory */
+	PATH_CONNECT_PATH = 0x4,	/* connect disconnected paths to / */
+	PATH_CHROOT_REL = 0x8,		/* do path lookup relative to chroot */
+	PATH_CHROOT_NSCONNECT = 0x10,	/* connect paths that are at ns root */
+
+	PATH_DELEGATE_DELETED = 0x08000, /* delegate deleted files */
+	PATH_MEDIATE_DELETED = 0x10000,	/* mediate deleted paths */
+};
+
+int aa_get_name(struct path *path, int flags, char **buffer, const char **name);
+char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen);
+
+#endif /* __AA_PATH_H */
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
new file mode 100644
index 0000000..035d8ee
--- /dev/null
+++ b/security/apparmor/lib.c
@@ -0,0 +1,84 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains basic common functions used in AppArmor
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
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "include/audit.h"
+
+
+/**
+ * aa_split_fqname - split a fqname into a profile and namespace name
+ * @fqname: a full qualified name in namespace profile format
+ * @ns_name: pointer to portion of the string containing the ns name
+ *
+ * Returns: profile name or NULL if one is not specified
+ *
+ * Split a namespace name from a profile name (see policy.c for naming
+ * description).  If a portion of the name is missing it returns NULL for
+ * that portion.
+ *
+ * NOTE: may modifiy the @fqname string.  The pointers returned point
+ *       into the @fqname string.
+ */
+char *aa_split_fqname(char *fqname, char **ns_name)
+{
+	char *name = strim(fqname);
+
+	*ns_name = NULL;
+	if (name[0] == ':') {
+		char *split = strchr(&name[1], ':');
+		if (split) {
+			/* overwrite ':' with \0 */
+			*split = 0;
+			name = skip_spaces(split + 1);
+		} else
+			/* a ns name without a following profile is allowed */
+			name = NULL;
+		*ns_name = &name[1];
+	}
+	if (name && *name == 0)
+		name = NULL;
+
+	return name;
+}
+
+/**
+ * aa_strneq - compare null terminated @str to a non null terminated substring
+ * @str: a null terminated string
+ * @sub: a substring, not necessarily null terminated
+ * @len: length of @sub to compare
+ *
+ * The @str string must be full consumed for this to be considered a match
+ */
+bool aa_strneq(const char *str, const char *sub, int len)
+{
+	int res = strncmp(str, sub, len);
+	if (res)
+		return 0;
+	if (str[len] == 0)
+		return 1;
+	return 0;
+}
+
+void aa_info_message(const char *str)
+{
+	struct common_audit_data sa;
+	COMMON_AUDIT_DATA_INIT_NONE(&sa);
+	sa.aad.info = str,
+	printk(KERN_INFO "AppArmor: %s\n", str);
+	if (audit_enabled)
+		aa_audit(AUDIT_APPARMOR_STATUS, NULL, GFP_KERNEL, &sa, NULL);
+}
+
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
new file mode 100644
index 0000000..3a694bc
--- /dev/null
+++ b/security/apparmor/path.c
@@ -0,0 +1,243 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor function for pathnames
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
+#include <linux/mnt_namespace.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/nsproxy.h>
+#include <linux/path.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/fs_struct.h>
+
+#include "include/apparmor.h"
+#include "include/path.h"
+#include "include/policy.h"
+
+/**
+ * d_namespace_path - lookup a name associated with a given path
+ * @path: path to lookup  (NOT NULL)
+ * @buf:  buffer to store path to  (NOT NULL)
+ * @buflen: length of @buf
+ * @name: return pointer for start of path name with in @buf  (NOT NULL)
+ * @flags: flags controling path lookup
+ *
+ * Handle path name lookup.
+ *
+ * Returns: %0 else error code if path lookup fails
+ *          When no error the path name is returned in @name which points to
+ *          to a position in @buf
+ */
+static int d_namespace_path(struct path *path, char *buf, int buflen,
+			    char **name, int flags)
+{
+	struct path root, tmp;
+	char *res;
+	int deleted, connected;
+	int error = 0;
+
+	/* Get the root we want to resolve too */
+	if (flags & PATH_CHROOT_REL) {
+		/* resolve paths relative to chroot */
+		read_lock(&current->fs->lock);
+		root = current->fs->root;
+		/* released below */
+		path_get(&root);
+		read_unlock(&current->fs->lock);
+	} else {
+		/* resolve paths relative to namespace */
+		root.mnt = current->nsproxy->mnt_ns->root;
+		root.dentry = root.mnt->mnt_root;
+		/* released below */
+		path_get(&root);
+	}
+
+	spin_lock(&dcache_lock);
+	/* There is a race window between path lookup here and the
+	 * need to strip the " (deleted) string that __d_path applies
+	 * Detect the race and relookup the path
+	 *
+	 * The stripping of (deleted) is a hack that could be removed
+	 * with an updated __d_path
+	 */
+	do {
+		tmp = root;
+		deleted = d_unlinked(path->dentry);
+		res = __d_path(path, &tmp, buf, buflen);
+
+	} while (deleted != d_unlinked(path->dentry));
+	spin_unlock(&dcache_lock);
+
+	*name = res;
+	/* handle error conditions - and still allow a partial path to
+	 * be returned.
+	 */
+	if (IS_ERR(res)) {
+		error = PTR_ERR(res);
+		*name = buf;
+		goto out;
+	}
+	if (deleted) {
+		/* On some filesystems, newly allocated dentries appear to the
+		 * security_path hooks as a deleted dentry except without an
+		 * inode allocated.
+		 *
+		 * Remove the appended deleted text and return as string for
+		 * normal mediation, or auditing.  The (deleted) string is
+		 * guarenteed to be added in this case, so just strip it.
+		 */
+		buf[buflen - 11] = 0;	/* - (len(" (deleted)") +\0) */
+
+		if (path->dentry->d_inode && !(flags & PATH_MEDIATE_DELETED)) {
+			error = -ENOENT;
+			goto out;
+		}
+	}
+
+	/* Determine if the path is connected to the expected root */
+	connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
+
+	/* If the path is not connected, then remove any leading / that
+	 * __d_path may have returned.
+	 * Unless
+	 *     specifically directed to connect the path,
+	 * OR
+	 *     if in a chroot and doing chroot relative paths and the path
+	 *     resolves to the namespace root (would be connected outside
+	 *     of chroot) and specifically directed to connect paths to
+	 *     namespace root.
+	 */
+	if (!connected &&
+	    !(flags & PATH_CONNECT_PATH) &&
+	    !((flags & PATH_CHROOT_REL) && (flags & PATH_CHROOT_NSCONNECT) &&
+	      (tmp.mnt == current->nsproxy->mnt_ns->root &&
+	       tmp.dentry == current->nsproxy->mnt_ns->root->mnt_root))) {
+		/* disconnected path, don't return pathname starting with '/' */
+		error = -ESTALE;
+		if (*res == '/')
+			*name = res + 1;
+	}
+
+out:
+	path_put(&root);
+
+	return error;
+}
+
+/**
+ * get_name_to_buffer - get the pathname to a buffer ensure dir / is appended
+ * @path: path to get name for  (NOT NULL)
+ * @flags: flags controlling path lookup
+ * @buffer: buffer to put name in  (NOT NULL)
+ * @size: size of buffer
+ * @name: on return contains position of path name in @buffer  (NOT NULL)
+ *
+ * Returns: %0 else error on failure
+ */
+static int get_name_to_buffer(struct path *path, int flags, char *buffer,
+			      int size, char **name)
+{
+	int adjust = (flags & PATH_IS_DIR) ? 1 : 0;
+	int error = d_namespace_path(path, buffer, size - adjust, name, flags);
+
+	if (!error && (flags & PATH_IS_DIR) && (*name)[1] != '\0')
+		/*
+		 * Append "/" to the pathname.  The root directory is a special
+		 * case; it already ends in slash.
+		 */
+		strcpy(&buffer[size - 2], "/");
+
+	return error;
+}
+
+/**
+ * aa_get_name - compute the pathname of a file
+ * @path: path the file  (NOT NULL)
+ * @flags: flags controling path name generation
+ * @buffer: buffer that aa_get_name() allocated  (NOT NULL)
+ * @name: the generated path name if !error
+ *
+ * @name is a pointer to the beginning of the pathname (which usually differs
+ * from the beginning of the buffer), or NULL.  If there is an error @name
+ * may contain a partial or invalid name that can be used for audit purposes,
+ * but it can not be used for mediation.
+ *
+ * We need PATH_IS_DIR to indicate whether the file is a directory or not
+ * because the file may not yet exist, and so we cannot check the inode's
+ * file type.
+ *
+ * Returns: %0 else error code if could retrieve name
+ */
+int aa_get_name(struct path *path, int flags, char **buffer, const char **name)
+{
+	char *buf, *str = NULL;
+	int size = 256;
+	int error;
+
+	*name = NULL;
+	*buffer = NULL;
+	for (;;) {
+		/* freed by caller */
+		buf = kmalloc(size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		error = get_name_to_buffer(path, flags, buf, size, &str);
+		if (error != -ENAMETOOLONG)
+			break;
+
+		kfree(buf);
+		size <<= 1;
+		if (size > aa_g_path_max)
+			return -ENAMETOOLONG;
+	}
+	*buffer = buf;
+	*name = str;
+
+	return error;
+}
+
+/**
+ * sysctl_pathname - generate a pathname for a sysctl
+ * @table: sysctl name table  (NOT NULL)
+ * @buffer: buffer to put name in  (NOT NULL)
+ * @buflen: length of @buffer
+ *
+ * Returns: sysctl path name in @buffer or NULL on error
+ */
+char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen)
+{
+	if (buflen < 1)
+		return NULL;
+	buffer += --buflen;
+	*buffer = '\0';
+
+	while (table) {
+		int namelen = strlen(table->procname);
+
+		if (buflen < namelen + 1)
+			return NULL;
+		buflen -= namelen + 1;
+		buffer -= namelen;
+		memcpy(buffer, table->procname, namelen);
+		*--buffer = '/';
+		table = table->parent;
+	}
+	if (buflen < 4)
+		return NULL;
+	buffer -= 4;
+	memcpy(buffer, "/sys", 4);
+
+	return buffer;
+}
-- 
1.7.0.4

