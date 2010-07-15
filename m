Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0GOApu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:45:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57148 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab0GOAoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:18 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 08/13] AppArmor: file enforcement routines
Date: Wed, 14 Jul 2010 17:43:36 -0700
Message-Id: <1279154621-25868-9-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AppArmor does files enforcement via pathname matching.  Matching is done
at file open using a dfa match engine.  Permission is against the final
file object not parent directories, ie. the traversal of directories
as part of the file match is implicitly allowed.  In the case of nonexistant
files (creation) permissions are checked against the target file not the
directory.  eg. In case of creating the file /dir/new, permissions are
checked against the match /dir/new not against /dir/.

The permissions for matches are currently stored in the dfa accept table,
but this will change to allow for dfa reuse and also to allow for sharing
of wider accept states.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/file.c         |  483 ++++++++++++++++++++++++++++++++++++++
 security/apparmor/include/file.h |  224 ++++++++++++++++++
 2 files changed, 707 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/file.c
 create mode 100644 security/apparmor/include/file.h

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
new file mode 100644
index 0000000..555b879
--- /dev/null
+++ b/security/apparmor/file.c
@@ -0,0 +1,483 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor mediation of files
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
+#include "include/audit.h"
+#include "include/file.h"
+#include "include/match.h"
+#include "include/path.h"
+#include "include/policy.h"
+
+struct file_perms nullperms;
+
+
+/**
+ * audit_file_mask - convert mask to owner::other string
+ * @buffer: buffer to write string to (NOT NULL)
+ * @mask: permission mask to convert
+ * @owner: if the mask is for owner or other
+ */
+static void audit_file_mask(struct audit_buffer *ab, u32 mask)
+{
+	char str[10];
+
+	char *m = str;
+
+	if (mask & AA_EXEC_MMAP)
+		*m++ = 'm';
+	if (mask & (MAY_READ | AA_MAY_META_READ))
+		*m++ = 'r';
+	if (mask & (MAY_WRITE | AA_MAY_META_WRITE | AA_MAY_CHMOD |
+		    AA_MAY_CHOWN))
+		*m++ = 'w';
+	else if (mask & MAY_APPEND)
+		*m++ = 'a';
+	if (mask & AA_MAY_CREATE)
+		*m++ = 'c';
+	if (mask & AA_MAY_DELETE)
+		*m++ = 'd';
+	if (mask & AA_MAY_LINK)
+		*m++ = 'l';
+	if (mask & AA_MAY_LOCK)
+		*m++ = 'k';
+	if (mask & MAY_EXEC)
+		*m++ = 'x';
+	*m++ = '\0';
+
+	audit_log_string(ab, str);
+}
+
+/**
+ * file_audit_cb - call back for file specific audit fields
+ * @ab: audit_buffer  (NOT NULL)
+ * @va: audit struct to audit values of  (NOT NULL)
+ */
+static void file_audit_cb(struct audit_buffer *ab, void *va)
+{
+	struct common_audit_data *sa = va;
+	uid_t fsuid = current_fsuid();
+
+	if (sa->aad.fs.request & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " requested_mask=");
+		audit_file_mask(ab, sa->aad.fs.request);
+	}
+	if (sa->aad.fs.denied & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " denied_mask=");
+		audit_file_mask(ab, sa->aad.fs.denied);
+	}
+	if (sa->aad.fs.request & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " fsuid=%d", fsuid);
+		audit_log_format(ab, " ouid=%d", sa->aad.fs.ouid);
+	}
+
+	if (sa->aad.fs.target) {
+		audit_log_format(ab, " target=");
+		audit_log_untrustedstring(ab, sa->aad.fs.target);
+	}
+}
+
+/**
+ * aa_audit_file - handle the auditing of file operations
+ * @profile: the profile being enforced  (NOT NULL)
+ * @perms: the permissions computed for the request (NOT NULL)
+ * @gfp: allocation flags
+ * @op: operation being mediated
+ * @request: permissions requested
+ * @name: name of object being mediated (MAYBE NULL)
+ * @target: name of target (MAYBE NULL)
+ * @ouid: object uid
+ * @info: extra information message (MAYBE NULL)
+ * @error: 0 if operation allowed else failure error code
+ * Returns: %0 or error on failure
+ */
+int aa_audit_file(struct aa_profile *profile, struct file_perms *perms,
+		  gfp_t gfp, int op, u32 request, const char *name,
+		  const char *target, uid_t ouid, const char *info, int error)
+{
+	int type = AUDIT_APPARMOR_AUTO;
+	struct common_audit_data sa;
+	COMMON_AUDIT_DATA_INIT_NONE(&sa);
+	sa.aad.op = op,
+	sa.aad.fs.request = request;
+	sa.aad.name = name;
+	sa.aad.fs.target = target;
+	sa.aad.fs.ouid = ouid;
+	sa.aad.info = info;
+	sa.aad.error = error;
+
+	if (likely(!sa.aad.error)) {
+		u32 mask = perms->audit;
+
+		if (unlikely(AUDIT_MODE(profile) == AUDIT_ALL))
+			mask = 0xffff;
+
+		/* mask off perms that are not being force audited */
+		sa.aad.fs.request &= mask;
+
+		if (likely(!sa.aad.fs.request))
+			return 0;
+		type = AUDIT_APPARMOR_AUDIT;
+	} else {
+		/* only report permissions that were denied */
+		sa.aad.fs.request = sa.aad.fs.request & ~perms->allow;
+
+		if (sa.aad.fs.request & perms->kill)
+			type = AUDIT_APPARMOR_KILL;
+
+		/* quiet known rejects, assumes quiet and kill do not overlap */
+		if ((sa.aad.fs.request & perms->quiet) &&
+		    AUDIT_MODE(profile) != AUDIT_NOQUIET &&
+		    AUDIT_MODE(profile) != AUDIT_ALL)
+			sa.aad.fs.request &= ~perms->quiet;
+
+		if (!sa.aad.fs.request)
+			return COMPLAIN_MODE(profile) ? 0 : sa.aad.error;
+	}
+
+	sa.aad.fs.denied = sa.aad.fs.request & ~perms->allow;
+	return aa_audit(type, profile, gfp, &sa, file_audit_cb);
+}
+
+/**
+ * map_old_perms - map old file perms layout to the new layout
+ * @old: permission set in old mapping
+ *
+ * Returns: new permission mapping
+ */
+static u32 map_old_perms(u32 old)
+{
+	u32 new = old & 0xf;
+	if (old & MAY_READ)
+		new |= AA_MAY_META_READ;
+	if (old & MAY_WRITE)
+		new |= AA_MAY_META_WRITE | AA_MAY_CREATE | AA_MAY_DELETE |
+			AA_MAY_CHMOD | AA_MAY_CHOWN;
+	if (old & 0x10)
+		new |= AA_MAY_LINK;
+	/* the old mapping lock and link_subset flags where overlaid
+	 * and use was determined by part of a pair that they were in
+	 */
+	if (old & 0x20)
+		new |= AA_MAY_LOCK | AA_LINK_SUBSET;
+	if (old & 0x40)	/* AA_EXEC_MMAP */
+		new |= AA_EXEC_MMAP;
+
+	return new;
+}
+
+/**
+ * compute_perms - convert dfa compressed perms to internal perms
+ * @dfa: dfa to compute perms for   (NOT NULL)
+ * @state: state in dfa
+ * @cond:  conditions to consider  (NOT NULL)
+ *
+ * TODO: convert from dfa + state to permission entry, do computation conversion
+ *       at load time.
+ *
+ * Returns: computed permission set
+ */
+static struct file_perms compute_perms(struct aa_dfa *dfa, unsigned int state,
+				       struct path_cond *cond)
+{
+	struct file_perms perms;
+
+	/* FIXME: change over to new dfa format
+	 * currently file perms are encoded in the dfa, new format
+	 * splits the permissions from the dfa.  This mapping can be
+	 * done at profile load
+	 */
+	perms.kill = 0;
+	perms.dindex = 0;
+
+	if (current_fsuid() == cond->uid) {
+		perms.allow = map_old_perms(dfa_user_allow(dfa, state));
+		perms.audit = map_old_perms(dfa_user_audit(dfa, state));
+		perms.quiet = map_old_perms(dfa_user_quiet(dfa, state));
+		perms.xindex = dfa_user_xindex(dfa, state);
+	} else {
+		perms.allow = map_old_perms(dfa_other_allow(dfa, state));
+		perms.audit = map_old_perms(dfa_other_audit(dfa, state));
+		perms.quiet = map_old_perms(dfa_other_quiet(dfa, state));
+		perms.xindex = dfa_other_xindex(dfa, state);
+	}
+
+	/* change_profile wasn't determined by ownership in old mapping */
+	if (ACCEPT_TABLE(dfa)[state] & 0x80000000)
+		perms.allow |= AA_MAY_CHANGE_PROFILE;
+
+	return perms;
+}
+
+/**
+ * aa_str_perms - find permission that match @name
+ * @dfa: to match against  (NOT NULL)
+ * @state: state to start matching in
+ * @name: string to match against dfa  (NOT NULL)
+ * @cond: conditions to consider for permission set computation  (NOT NULL)
+ * @perms: Returns - the permissions found when matching @name
+ *
+ * Returns: the final state in @dfa when beginning @start and walking @name
+ */
+unsigned int aa_str_perms(struct aa_dfa *dfa, unsigned int start,
+			  const char *name, struct path_cond *cond,
+			  struct file_perms *perms)
+{
+	unsigned int state;
+	if (!dfa) {
+		*perms = nullperms;
+		return DFA_NOMATCH;
+	}
+
+	state = aa_dfa_match(dfa, start, name);
+	*perms = compute_perms(dfa, state, cond);
+
+	return state;
+}
+
+/**
+ * aa_pathstr_perm - do permission check & audit for @name
+ * @op: operation being checked
+ * @profile: profile being enforced  (NOT NULL)
+ * @name: path string to check permission for  (NOT NULL)
+ * @request: requested permissions
+ * @cond: conditional info for this request  (NOT NULL)
+ *
+ * Do permission check for paths that are predefined.  This fn will
+ * be removed once security_sysctl goes away.
+ *
+ * Returns: %0 else error if access denied or other error
+ */
+int aa_pathstr_perm(int op, struct aa_profile *profile, const char *name,
+		    u32 request, struct path_cond *cond)
+{
+	struct file_perms perms = { };
+	int error = 0;
+
+	aa_str_perms(profile->file.dfa, profile->file.start, name, cond,
+		     &perms);
+	if (request & ~perms.allow)
+		error = -EACCES;
+	return aa_audit_file(profile, &perms, GFP_KERNEL, op, request, name,
+			     NULL, cond->uid, NULL, error);
+}
+
+/**
+ * is_deleted - test if a file has been completely unlinked
+ * @dentry: dentry of file to test for deletion  (NOT NULL)
+ *
+ * Returns: %1 if deleted else %0
+ */
+static inline bool is_deleted(struct dentry *dentry)
+{
+	if (d_unlinked(dentry) && dentry->d_inode->i_nlink == 0)
+		return 1;
+	return 0;
+}
+
+/**
+ * aa_path_perm - do permissions check & audit for @path
+ * @op: operation being checked
+ * @profile: profile being enforced  (NOT NULL)
+ * @path: path to check permissions of  (NOT NULL)
+ * @flags: any additional path flags beyond what the profile specifies
+ * @request: requested permissions
+ * @cond: conditional info for this request  (NOT NULL)
+ *
+ * Returns: %0 else error if access denied or other error
+ */
+int aa_path_perm(int op, struct aa_profile *profile, struct path *path,
+		 int flags, u32 request, struct path_cond *cond)
+{
+	char *buffer = NULL;
+	struct file_perms perms = {};
+	const char *name, *info = NULL;
+	int error;
+
+	flags |= profile->path_flags | (S_ISDIR(cond->mode) ? PATH_IS_DIR : 0);
+	error = aa_get_name(path, flags, &buffer, &name);
+	if (error) {
+		if (error == -ENOENT && is_deleted(path->dentry)) {
+			/* Access to open files that are deleted are
+			 * give a pass (implicit delegation)
+			 */
+			error = 0;
+			perms.allow = request;
+		} else if (error == -ENOENT)
+			info = "Failed name lookup - deleted entry";
+		else if (error == -ESTALE)
+			info = "Failed name lookup - disconnected path";
+		else if (error == -ENAMETOOLONG)
+			info = "Failed name lookup - name too long";
+		else
+			info = "Failed name lookup";
+	} else {
+		aa_str_perms(profile->file.dfa, profile->file.start, name, cond,
+			     &perms);
+		if (request & ~perms.allow)
+			error = -EACCES;
+	}
+	error = aa_audit_file(profile, &perms, GFP_KERNEL, op, request, name,
+			      NULL, cond->uid, info, error);
+	kfree(buffer);
+
+	return error;
+}
+
+/**
+ * xindex_is_subset - helper for aa_path_link
+ * @link: link permission set
+ * @target: target permission set
+ *
+ * test target x permissions are equal OR a subset of link x permissions
+ * this is done as part of the subset test, where a hardlink must have
+ * a subset of permissions that the target has.
+ *
+ * Returns: %1 if subset else %0
+ */
+static inline bool xindex_is_subset(u32 link, u32 target)
+{
+	if (((link & ~AA_X_UNSAFE) != (target & ~AA_X_UNSAFE)) ||
+	    ((link & AA_X_UNSAFE) && !(target & AA_X_UNSAFE)))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * aa_path_link - Handle hard link permission check
+ * @profile: the profile being enforced  (NOT NULL)
+ * @old_dentry: the target dentry  (NOT NULL)
+ * @new_dir: directory the new link will be created in  (NOT NULL)
+ * @new_dentry: the link being created  (NOT NULL)
+ *
+ * Handle the permission test for a link & target pair.  Permission
+ * is encoded as a pair where the link permission is determined
+ * first, and if allowed, the target is tested.  The target test
+ * is done from the point of the link match (not start of DFA)
+ * making the target permission dependent on the link permission match.
+ *
+ * The subset test if required forces that permissions granted
+ * on link are a subset of the permission granted to target.
+ *
+ * Returns: %0 if allowed else error
+ */
+int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
+		 struct path *new_dir, struct dentry *new_dentry)
+{
+	struct path link = { new_dir->mnt, new_dentry };
+	struct path target = { new_dir->mnt, old_dentry };
+	struct path_cond cond = {
+		old_dentry->d_inode->i_uid,
+		old_dentry->d_inode->i_mode
+	};
+	char *buffer = NULL, *buffer2 = NULL;
+	const char *lname, *tname = NULL, *info = NULL;
+	struct file_perms lperms, perms;
+	u32 request = AA_MAY_LINK;
+	unsigned int state;
+	int error;
+
+	lperms = nullperms;
+
+	/* buffer freed below, lname is pointer in buffer */
+	error = aa_get_name(&link, profile->path_flags, &buffer, &lname);
+	if (error)
+		goto audit;
+
+	/* buffer2 freed below, tname is pointer in buffer2 */
+	error = aa_get_name(&target, profile->path_flags, &buffer2, &tname);
+	if (error)
+		goto audit;
+
+	error = -EACCES;
+	/* aa_str_perms - handles the case of the dfa being NULL */
+	state = aa_str_perms(profile->file.dfa, profile->file.start, lname,
+			     &cond, &lperms);
+
+	if (!(lperms.allow & AA_MAY_LINK))
+		goto audit;
+
+	/* test to see if target can be paired with link */
+	state = aa_dfa_null_transition(profile->file.dfa, state);
+	aa_str_perms(profile->file.dfa, state, tname, &cond, &perms);
+
+	/* force audit/quiet masks for link are stored in the second entry
+	 * in the link pair.
+	 */
+	lperms.audit = perms.audit;
+	lperms.quiet = perms.quiet;
+	lperms.kill = perms.kill;
+
+	if (!(perms.allow & AA_MAY_LINK)) {
+		info = "target restricted";
+		goto audit;
+	}
+
+	/* done if link subset test is not required */
+	if (!(perms.allow & AA_LINK_SUBSET))
+		goto done_tests;
+
+	/* Do link perm subset test requiring allowed permission on link are a
+	 * subset of the allowed permissions on target.
+	 */
+	aa_str_perms(profile->file.dfa, profile->file.start, tname, &cond,
+		     &perms);
+
+	/* AA_MAY_LINK is not considered in the subset test */
+	request = lperms.allow & ~AA_MAY_LINK;
+	lperms.allow &= perms.allow | AA_MAY_LINK;
+
+	request |= AA_AUDIT_FILE_MASK & (lperms.allow & ~perms.allow);
+	if (request & ~lperms.allow) {
+		goto audit;
+	} else if ((lperms.allow & MAY_EXEC) &&
+		   !xindex_is_subset(lperms.xindex, perms.xindex)) {
+		lperms.allow &= ~MAY_EXEC;
+		request |= MAY_EXEC;
+		info = "link not subset of target";
+		goto audit;
+	}
+
+done_tests:
+	error = 0;
+
+audit:
+	error = aa_audit_file(profile, &lperms, GFP_KERNEL, OP_LINK, request,
+			      lname, tname, cond.uid, info, error);
+	kfree(buffer);
+	kfree(buffer2);
+
+	return error;
+}
+
+/**
+ * aa_file_perm - do permission revalidation check & audit for @file
+ * @op: operation being checked
+ * @profile: profile being enforced   (NOT NULL)
+ * @file: file to revalidate access permissions on  (NOT NULL)
+ * @request: requested permissions
+ *
+ * Returns: %0 if access allowed else error
+ */
+int aa_file_perm(int op, struct aa_profile *profile, struct file *file,
+		 u32 request)
+{
+	struct path_cond cond = {
+		.uid = file->f_path.dentry->d_inode->i_uid,
+		.mode = file->f_path.dentry->d_inode->i_mode
+	};
+
+	return aa_path_perm(op, profile, &file->f_path, PATH_DELEGATE_DELETED,
+			    request, &cond);
+}
diff --git a/security/apparmor/include/file.h b/security/apparmor/include/file.h
new file mode 100644
index 0000000..d89ee18
--- /dev/null
+++ b/security/apparmor/include/file.h
@@ -0,0 +1,224 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor file mediation function definitions.
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
+#ifndef __AA_FILE_H
+#define __AA_FILE_H
+
+#include <linux/path.h>
+
+#include "domain.h"
+#include "match.h"
+
+struct aa_profile;
+
+/*
+ * We use MAY_EXEC, MAY_WRITE, MAY_READ, MAY_APPEND and the following flags
+ * for profile permissions
+ */
+#define AA_MAY_CREATE                  0x0010
+#define AA_MAY_DELETE                  0x0020
+#define AA_MAY_META_WRITE              0x0040
+#define AA_MAY_META_READ               0x0080
+
+#define AA_MAY_CHMOD                   0x0100
+#define AA_MAY_CHOWN                   0x0200
+#define AA_MAY_LOCK                    0x0400
+#define AA_EXEC_MMAP                   0x0800
+
+#define AA_MAY_LINK			0x1000
+#define AA_LINK_SUBSET			AA_MAY_LOCK	/* overlayed */
+#define AA_MAY_ONEXEC			0x40000000	/* exec allows onexec */
+#define AA_MAY_CHANGE_PROFILE		0x80000000
+#define AA_MAY_CHANGEHAT		0x80000000	/* ctrl auditing only */
+
+#define AA_AUDIT_FILE_MASK	(MAY_READ | MAY_WRITE | MAY_EXEC | MAY_APPEND |\
+				 AA_MAY_CREATE | AA_MAY_DELETE |	\
+				 AA_MAY_META_READ | AA_MAY_META_WRITE | \
+				 AA_MAY_CHMOD | AA_MAY_CHOWN | AA_MAY_LOCK | \
+				 AA_EXEC_MMAP | AA_MAY_LINK)
+
+/*
+ * The xindex is broken into 3 parts
+ * - index - an index into either the exec name table or the variable table
+ * - exec type - which determines how the executable name and index are used
+ * - flags - which modify how the destination name is applied
+ */
+#define AA_X_INDEX_MASK		0x03ff
+
+#define AA_X_TYPE_MASK		0x0c00
+#define AA_X_TYPE_SHIFT		10
+#define AA_X_NONE		0x0000
+#define AA_X_NAME		0x0400	/* use executable name px */
+#define AA_X_TABLE		0x0800	/* use a specified name ->n# */
+
+#define AA_X_UNSAFE		0x1000
+#define AA_X_CHILD		0x2000	/* make >AA_X_NONE apply to children */
+#define AA_X_INHERIT		0x4000
+#define AA_X_UNCONFINED		0x8000
+
+/* AA_SECURE_X_NEEDED - is passed in the bprm->unsafe field */
+#define AA_SECURE_X_NEEDED	0x8000
+
+/* need to conditionalize which ones are being set */
+struct path_cond {
+	uid_t uid;
+	umode_t mode;
+};
+
+/* struct file_perms - file permission fo
+ * @allow: mask of permissions that are allowed
+ * @audit: mask of permissions to force an audit message for
+ * @quiet: mask of permissions to quiet audit messages for
+ * @kill: mask of permissions that when matched will kill the task
+ * @xindex: exec transition index if @allow contains MAY_EXEC
+ * @xdelegate: used by exec to determine set of delegates allowed
+ * @dindex: delegate table index, 0 if no delegation allowed
+ *
+ * The @audit and @queit mask should be mutually exclusive.
+ */
+struct file_perms {
+	u32 allow;
+	u32 audit;
+	u32 quiet;
+	u32 kill;
+	u16 xindex;
+	u16 xdelegate;
+	u16 dindex;
+};
+
+extern struct file_perms nullperms;
+
+#define COMBINED_PERM_MASK(X) ((X).allow | (X).audit | (X).quiet | (X).kill)
+
+/* FIXME: split perms from dfa and match this to description
+ *        also add delegation info.
+ */
+static inline u16 dfa_map_xindex(u16 mask)
+{
+	u16 old_index = (mask >> 10) & 0xf;
+	u16 index = 0;
+
+	if (mask & 0x100)
+		index |= AA_X_UNSAFE;
+	if (mask & 0x200)
+		index |= AA_X_INHERIT;
+	if (mask & 0x80)
+		index |= AA_X_UNCONFINED;
+
+	if (old_index == 1) {
+		index |= AA_X_UNCONFINED;
+	} else if (old_index == 2) {
+		index |= AA_X_NAME;
+	} else if (old_index == 3) {
+		index |= AA_X_NAME | AA_X_CHILD;
+	} else {
+		index |= AA_X_TABLE;
+		index |= old_index - 4;
+	}
+
+	return index;
+}
+
+/*
+ * map old dfa inline permissions to new format
+ */
+#define dfa_user_allow(dfa, state) (((ACCEPT_TABLE(dfa)[state]) & 0x7f) | \
+				    ((ACCEPT_TABLE(dfa)[state]) & 0x80000000))
+#define dfa_user_audit(dfa, state) ((ACCEPT_TABLE2(dfa)[state]) & 0x7f)
+#define dfa_user_quiet(dfa, state) (((ACCEPT_TABLE2(dfa)[state]) >> 7) & 0x7f)
+#define dfa_user_xindex(dfa, state) \
+	(dfa_map_xindex(ACCEPT_TABLE(dfa)[state] & 0x3fff))
+
+#define dfa_other_allow(dfa, state) ((((ACCEPT_TABLE(dfa)[state]) >> 14) & \
+				      0x7f) |				\
+				     ((ACCEPT_TABLE(dfa)[state]) & 0x80000000))
+#define dfa_other_audit(dfa, state) (((ACCEPT_TABLE2(dfa)[state]) >> 14) & 0x7f)
+#define dfa_other_quiet(dfa, state) \
+	((((ACCEPT_TABLE2(dfa)[state]) >> 7) >> 14) & 0x7f)
+#define dfa_other_xindex(dfa, state) \
+	dfa_map_xindex((ACCEPT_TABLE(dfa)[state] >> 14) & 0x3fff)
+
+int aa_audit_file(struct aa_profile *profile, struct file_perms *perms,
+		  gfp_t gfp, int op, u32 request, const char *name,
+		  const char *target, uid_t ouid, const char *info, int error);
+
+/**
+ * struct aa_file_rules - components used for file rule permissions
+ * @dfa: dfa to match path names and conditionals against
+ * @perms: permission table indexed by the matched state accept entry of @dfa
+ * @trans: transition table for indexed by named x transitions
+ *
+ * File permission are determined by matching a path against @dfa and then
+ * then using the value of the accept entry for the matching state as
+ * an index into @perms.  If a named exec transition is required it is
+ * looked up in the transition table.
+ */
+struct aa_file_rules {
+	unsigned int start;
+	struct aa_dfa *dfa;
+	/* struct perms perms; */
+	struct aa_domain trans;
+	/* TODO: add delegate table */
+};
+
+unsigned int aa_str_perms(struct aa_dfa *dfa, unsigned int start,
+			  const char *name, struct path_cond *cond,
+			  struct file_perms *perms);
+
+int aa_pathstr_perm(int op, struct aa_profile *profile, const char *name,
+		    u32 request, struct path_cond *cond);
+
+int aa_path_perm(int op, struct aa_profile *profile, struct path *path,
+		 int flags, u32 request, struct path_cond *cond);
+
+int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
+		 struct path *new_dir, struct dentry *new_dentry);
+
+int aa_file_perm(int op, struct aa_profile *profile, struct file *file,
+		 u32 request);
+
+static inline void aa_free_file_rules(struct aa_file_rules *rules)
+{
+	aa_put_dfa(rules->dfa);
+	aa_free_domain_entries(&rules->trans);
+}
+
+#define ACC_FMODE(x) (("\000\004\002\006"[(x)&O_ACCMODE]) | (((x) << 1) & 0x40))
+
+/* from namei.c */
+#define MAP_OPEN_FLAGS(x) ((((x) + 1) & O_ACCMODE) ? (x) + 1 : (x))
+
+/**
+ * aa_map_file_perms - map file flags to AppArmor permissions
+ * @file: open file to map flags to AppArmor permissions
+ *
+ * Returns: apparmor permission set for the file
+ */
+static inline u32 aa_map_file_to_perms(struct file *file)
+{
+	int flags = MAP_OPEN_FLAGS(file->f_flags);
+	u32 perms = ACC_FMODE(file->f_mode);
+
+	if ((flags & O_APPEND) && (perms & MAY_WRITE))
+		perms = (perms & ~MAY_WRITE) | MAY_APPEND;
+	/* trunc implies write permission */
+	if (flags & O_TRUNC)
+		perms |= MAY_WRITE;
+	if (flags & O_CREAT)
+		perms |= AA_MAY_CREATE;
+
+	return perms;
+}
+
+#endif /* __AA_FILE_H */
-- 
1.7.0.4

