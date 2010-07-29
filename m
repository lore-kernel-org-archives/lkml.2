Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0G2VsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:48:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43355 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0G2VsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:48:18 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 01/13] AppArmor: misc. base functions and defines
Date: Thu, 29 Jul 2010 14:47:57 -0700
Message-Id: <1280440089-3203-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous functions and defines needed by AppArmor, including
the base path resolution routines.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/apparmor.h |   92 +++++++++++++
 security/apparmor/include/path.h     |   31 +++++
 security/apparmor/lib.c              |  133 +++++++++++++++++++
 security/apparmor/path.c             |  235 ++++++++++++++++++++++++++++++++++
 4 files changed, 491 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/apparmor.h
 create mode 100644 security/apparmor/include/path.h
 create mode 100644 security/apparmor/lib.c
 create mode 100644 security/apparmor/path.c

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
new file mode 100644
index 0000000..38ccaea
--- /dev/null
+++ b/security/apparmor/include/apparmor.h
@@ -0,0 +1,92 @@
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
+/* Control parameters settable through module/boot flags */
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
+extern int apparmor_initialized __initdata;
+
+/* fn's in lib */
+char *aa_split_fqname(char *args, char **ns_name);
+void aa_info_message(const char *str);
+void *kvmalloc(size_t size);
+void kvfree(void *buffer);
+
+
+/**
+ * aa_strneq - compare null terminated @str to a non null terminated substring
+ * @str: a null terminated string
+ * @sub: a substring, not necessarily null terminated
+ * @len: length of @sub to compare
+ *
+ * The @str string must be full consumed for this to be considered a match
+ */
+static inline bool aa_strneq(const char *str, const char *sub, int len)
+{
+	return !strncmp(str, sub, len) && !str[len];
+}
+
+/**
+ * aa_dfa_null_transition - step to next state after null character
+ * @dfa: the dfa to match against
+ * @start: the state of the dfa to start matching in
+ *
+ * aa_dfa_null_transition transitions to the next state after a null
+ * character which is not used in standard matching and is only
+ * used to separate pairs.
+ */
+static inline unsigned int aa_dfa_null_transition(struct aa_dfa *dfa,
+						  unsigned int start)
+{
+	/* the null transition only needs the string's null terminator byte */
+	return aa_dfa_match_len(dfa, start, "", 1);
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
index 0000000..27b327a
--- /dev/null
+++ b/security/apparmor/include/path.h
@@ -0,0 +1,31 @@
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
+
+#endif /* __AA_PATH_H */
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
new file mode 100644
index 0000000..6e85cdb
--- /dev/null
+++ b/security/apparmor/lib.c
@@ -0,0 +1,133 @@
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
+#include <linux/vmalloc.h>
+
+#include "include/audit.h"
+
+
+/**
+ * aa_split_fqname - split a fqname into a profile and namespace name
+ * @fqname: a full qualified name in namespace profile format (NOT NULL)
+ * @ns_name: pointer to portion of the string containing the ns name (NOT NULL)
+ *
+ * Returns: profile name or NULL if one is not specified
+ *
+ * Split a namespace name from a profile name (see policy.c for naming
+ * description).  If a portion of the name is missing it returns NULL for
+ * that portion.
+ *
+ * NOTE: may modify the @fqname string.  The pointers returned point
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
+ * aa_info_message - log a none profile related status message
+ * @str: message to log
+ */
+void aa_info_message(const char *str)
+{
+	if (audit_enabled) {
+		struct common_audit_data sa;
+		COMMON_AUDIT_DATA_INIT(&sa, NONE);
+		sa.aad.info = str;
+		aa_audit_msg(AUDIT_APPARMOR_STATUS, &sa, NULL);
+	}
+	printk(KERN_INFO "AppArmor: %s\n", str);
+}
+
+/**
+ * kvmalloc - do allocation preferring kmalloc but falling back to vmalloc
+ * @size: size of allocation
+ *
+ * Return: allocated buffer or NULL if failed
+ *
+ * It is possible that policy being loaded from the user is larger than
+ * what can be allocated by kmalloc, in those cases fall back to vmalloc.
+ */
+void *kvmalloc(size_t size)
+{
+	void *buffer = NULL;
+
+	if (size == 0)
+		return NULL;
+
+	/* do not attempt kmalloc if we need more than 16 pages at once */
+	if (size <= (16*PAGE_SIZE))
+		buffer = kmalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (!buffer) {
+		/* see kvfree for why size must be at least work_struct size
+		 * when allocated via vmalloc
+		 */
+		if (size < sizeof(struct work_struct))
+			size = sizeof(struct work_struct);
+		buffer = vmalloc(size);
+	}
+	return buffer;
+}
+
+/**
+ * do_vfree - workqueue routine for freeing vmalloced memory
+ * @work: data to be freed
+ *
+ * The work_struct is overlaid to the data being freed, as at the point
+ * the work is scheduled the data is no longer valid, be its freeing
+ * needs to be delayed until safe.
+ */
+static void do_vfree(struct work_struct *work)
+{
+	vfree(work);
+}
+
+/**
+ * kvfree - free an allocation do by kvmalloc
+ * @buffer: buffer to free (MAYBE_NULL)
+ *
+ * Free a buffer allocated by kvmalloc
+ */
+void kvfree(void *buffer)
+{
+	if (is_vmalloc_addr(buffer)) {
+		/* Data is no longer valid so just use the allocated space
+		 * as the work_struct
+		 */
+		struct work_struct *work = (struct work_struct *) buffer;
+		INIT_WORK(work, do_vfree);
+		schedule_work(work);
+	} else
+		kfree(buffer);
+}
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
new file mode 100644
index 0000000..96bab94
--- /dev/null
+++ b/security/apparmor/path.c
@@ -0,0 +1,235 @@
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
+#include <linux/magic.h>
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
+
+/* modified from dcache.c */
+static int prepend(char **buffer, int buflen, const char *str, int namelen)
+{
+	buflen -= namelen;
+	if (buflen < 0)
+		return -ENAMETOOLONG;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
+#define CHROOT_NSCONNECT (PATH_CHROOT_REL | PATH_CHROOT_NSCONNECT)
+
+/**
+ * d_namespace_path - lookup a name associated with a given path
+ * @path: path to lookup  (NOT NULL)
+ * @buf:  buffer to store path to  (NOT NULL)
+ * @buflen: length of @buf
+ * @name: Returns - pointer for start of path name with in @buf (NOT NULL)
+ * @flags: flags controlling path lookup
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
+		 * guaranteed to be added in this case, so just strip it.
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
+	/* If the path is not connected,
+	 * check if it is a sysctl and handle specially else remove any
+	 * leading / that __d_path may have returned.
+	 * Unless
+	 *     specifically directed to connect the path,
+	 * OR
+	 *     if in a chroot and doing chroot relative paths and the path
+	 *     resolves to the namespace root (would be connected outside
+	 *     of chroot) and specifically directed to connect paths to
+	 *     namespace root.
+	 */
+	if (!connected) {
+		/* is the disconnect path a sysctl? */
+		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
+		    strncmp(*name, "/sys/", 5) == 0) {
+			/* TODO: convert over to using a per namespace
+			 * control instead of hard coded /proc
+			 */
+			error = prepend(name, *name - buf, "/proc", 5);
+		} else if (!(flags & PATH_CONNECT_PATH) &&
+			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
+			     (tmp.mnt == current->nsproxy->mnt_ns->root &&
+			      tmp.dentry == tmp.mnt->mnt_root))) {
+			/* disconnected path, don't return pathname starting
+			 * with '/'
+			 */
+			error = -ESTALE;
+			if (*res == '/')
+				*name = res + 1;
+		}
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
+ * @name: Returns - contains position of path name in @buffer (NOT NULL)
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
+ * @flags: flags controlling path name generation
+ * @buffer: buffer that aa_get_name() allocated  (NOT NULL)
+ * @name: Returns - the generated path name if !error (NOT NULL)
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
-- 
1.7.1

