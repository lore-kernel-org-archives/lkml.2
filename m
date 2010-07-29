Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0G2VsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:48:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43435 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0G2VsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:48:21 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 02/13] AppArmor: basic auditing infrastructure.
Date: Thu, 29 Jul 2010 14:47:58 -0700
Message-Id: <1280440089-3203-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update lsm_audit for AppArmor specific data, and add the core routines for
AppArmor uses for auditing.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 include/linux/lsm_audit.h         |   27 +++++
 security/apparmor/audit.c         |  215 +++++++++++++++++++++++++++++++++++++
 security/apparmor/include/audit.h |  123 +++++++++++++++++++++
 3 files changed, 365 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/audit.c
 create mode 100644 security/apparmor/include/audit.h

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 6907251..13b5c9a 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -94,6 +94,33 @@ struct common_audit_data {
 			int result;
 		} selinux_audit_data;
 #endif
+#ifdef CONFIG_SECURITY_APPARMOR
+		struct {
+			int error;
+			int op;
+			int type;
+			void *profile;
+			const char *name;
+			const char *info;
+			union {
+				void *target;
+				struct {
+					long pos;
+					void *target;
+				} iface;
+				struct {
+					int rlim;
+					unsigned long max;
+				} rlim;
+				struct {
+					const char *target;
+					u32 request;
+					u32 denied;
+					uid_t ouid;
+				} fs;
+			};
+		} apparmor_audit_data;
+#endif
 	};
 	/* these callback will be implemented by a specific LSM */
 	void (*lsm_pre_audit)(struct audit_buffer *, void *);
diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
new file mode 100644
index 0000000..96502b2
--- /dev/null
+++ b/security/apparmor/audit.c
@@ -0,0 +1,215 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor auditing functions
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
+#include <linux/audit.h>
+#include <linux/socket.h>
+
+#include "include/apparmor.h"
+#include "include/audit.h"
+#include "include/policy.h"
+
+const char *op_table[] = {
+	"null",
+
+	"sysctl",
+	"capable",
+
+	"unlink",
+	"mkdir",
+	"rmdir",
+	"mknod",
+	"truncate",
+	"link",
+	"symlink",
+	"rename_src",
+	"rename_dest",
+	"chmod",
+	"chown",
+	"getattr",
+	"open",
+
+	"file_perm",
+	"file_lock",
+	"file_mmap",
+	"file_mprotect",
+
+	"create",
+	"post_create",
+	"bind",
+	"connect",
+	"listen",
+	"accept",
+	"sendmsg",
+	"recvmsg",
+	"getsockname",
+	"getpeername",
+	"getsockopt",
+	"setsockopt",
+	"socket_shutdown",
+
+	"ptrace",
+
+	"exec",
+	"change_hat",
+	"change_profile",
+	"change_onexec",
+
+	"setprocattr",
+	"setrlimit",
+
+	"profile_replace",
+	"profile_load",
+	"profile_remove"
+};
+
+const char *audit_mode_names[] = {
+	"normal",
+	"quiet_denied",
+	"quiet",
+	"noquiet",
+	"all"
+};
+
+static char *aa_audit_type[] = {
+	"AUDIT",
+	"ALLOWED",
+	"DENIED",
+	"HINT",
+	"STATUS",
+	"ERROR",
+	"KILLED"
+};
+
+/*
+ * Currently AppArmor auditing is fed straight into the audit framework.
+ *
+ * TODO:
+ * netlink interface for complain mode
+ * user auditing, - send user auditing to netlink interface
+ * system control of whether user audit messages go to system log
+ */
+
+/**
+ * audit_base - core AppArmor function.
+ * @ab: audit buffer to fill (NOT NULL)
+ * @ca: audit structure containing data to audit (NOT NULL)
+ *
+ * Record common AppArmor audit data from @sa
+ */
+static void audit_pre(struct audit_buffer *ab, void *ca)
+{
+	struct common_audit_data *sa = ca;
+	struct task_struct *tsk = sa->tsk ? sa->tsk : current;
+
+	if (aa_g_audit_header) {
+		audit_log_format(ab, "apparmor=");
+		audit_log_string(ab, aa_audit_type[sa->aad.type]);
+	}
+
+	if (sa->aad.op) {
+		audit_log_format(ab, " operation=");
+		audit_log_string(ab, op_table[sa->aad.op]);
+	}
+
+	if (sa->aad.info) {
+		audit_log_format(ab, " info=");
+		audit_log_string(ab, sa->aad.info);
+		if (sa->aad.error)
+			audit_log_format(ab, " error=%d", sa->aad.error);
+	}
+
+	if (sa->aad.profile) {
+		struct aa_profile *profile = sa->aad.profile;
+		pid_t pid;
+		rcu_read_lock();
+		pid = tsk->real_parent->pid;
+		rcu_read_unlock();
+		audit_log_format(ab, " parent=%d", pid);
+		if (profile->ns != root_ns) {
+			audit_log_format(ab, " namespace=");
+			audit_log_untrustedstring(ab, profile->ns->base.hname);
+		}
+		audit_log_format(ab, " profile=");
+		audit_log_untrustedstring(ab, profile->base.hname);
+	}
+
+	if (sa->aad.name) {
+		audit_log_format(ab, " name=");
+		audit_log_untrustedstring(ab, sa->aad.name);
+	}
+}
+
+/**
+ * aa_audit_msg - Log a message to the audit subsystem
+ * @sa: audit event structure (NOT NULL)
+ * @cb: optional callback fn for type specific fields (MAYBE NULL)
+ */
+void aa_audit_msg(int type, struct common_audit_data *sa,
+		  void (*cb) (struct audit_buffer *, void *))
+{
+	sa->aad.type = type;
+	sa->lsm_pre_audit = audit_pre;
+	sa->lsm_post_audit = cb;
+	common_lsm_audit(sa);
+}
+
+/**
+ * aa_audit - Log a profile based audit event to the audit subsystem
+ * @type: audit type for the message
+ * @profile: profile to check against (NOT NULL)
+ * @gfp: allocation flags to use
+ * @sa: audit event (NOT NULL)
+ * @cb: optional callback fn for type specific fields (MAYBE NULL)
+ *
+ * Handle default message switching based off of audit mode flags
+ *
+ * Returns: error on failure
+ */
+int aa_audit(int type, struct aa_profile *profile, gfp_t gfp,
+	     struct common_audit_data *sa,
+	     void (*cb) (struct audit_buffer *, void *))
+{
+	BUG_ON(!profile);
+
+	if (type == AUDIT_APPARMOR_AUTO) {
+		if (likely(!sa->aad.error)) {
+			if (AUDIT_MODE(profile) != AUDIT_ALL)
+				return 0;
+			type = AUDIT_APPARMOR_AUDIT;
+		} else if (COMPLAIN_MODE(profile))
+			type = AUDIT_APPARMOR_ALLOWED;
+		else
+			type = AUDIT_APPARMOR_DENIED;
+	}
+	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
+	    (type == AUDIT_APPARMOR_DENIED &&
+	     AUDIT_MODE(profile) == AUDIT_QUIET))
+		return sa->aad.error;
+
+	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)
+		type = AUDIT_APPARMOR_KILL;
+
+	if (!unconfined(profile))
+		sa->aad.profile = profile;
+
+	aa_audit_msg(type, sa, cb);
+
+	if (sa->aad.type == AUDIT_APPARMOR_KILL)
+		(void)send_sig_info(SIGKILL, NULL, sa->tsk ? sa->tsk : current);
+
+	if (sa->aad.type == AUDIT_APPARMOR_ALLOWED)
+		return complain_error(sa->aad.error);
+
+	return sa->aad.error;
+}
diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
new file mode 100644
index 0000000..1951786
--- /dev/null
+++ b/security/apparmor/include/audit.h
@@ -0,0 +1,123 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor auditing function definitions.
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
+#ifndef __AA_AUDIT_H
+#define __AA_AUDIT_H
+
+#include <linux/audit.h>
+#include <linux/fs.h>
+#include <linux/lsm_audit.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include "file.h"
+
+struct aa_profile;
+
+extern const char *audit_mode_names[];
+#define AUDIT_MAX_INDEX 5
+
+#define AUDIT_APPARMOR_AUTO 0	/* auto choose audit message type */
+
+enum audit_mode {
+	AUDIT_NORMAL,		/* follow normal auditing of accesses */
+	AUDIT_QUIET_DENIED,	/* quiet all denied access messages */
+	AUDIT_QUIET,		/* quiet all messages */
+	AUDIT_NOQUIET,		/* do not quiet audit messages */
+	AUDIT_ALL		/* audit all accesses */
+};
+
+enum audit_type {
+	AUDIT_APPARMOR_AUDIT,
+	AUDIT_APPARMOR_ALLOWED,
+	AUDIT_APPARMOR_DENIED,
+	AUDIT_APPARMOR_HINT,
+	AUDIT_APPARMOR_STATUS,
+	AUDIT_APPARMOR_ERROR,
+	AUDIT_APPARMOR_KILL
+};
+
+extern const char *op_table[];
+enum aa_ops {
+	OP_NULL,
+
+	OP_SYSCTL,
+	OP_CAPABLE,
+
+	OP_UNLINK,
+	OP_MKDIR,
+	OP_RMDIR,
+	OP_MKNOD,
+	OP_TRUNC,
+	OP_LINK,
+	OP_SYMLINK,
+	OP_RENAME_SRC,
+	OP_RENAME_DEST,
+	OP_CHMOD,
+	OP_CHOWN,
+	OP_GETATTR,
+	OP_OPEN,
+
+	OP_FPERM,
+	OP_FLOCK,
+	OP_FMMAP,
+	OP_FMPROT,
+
+	OP_CREATE,
+	OP_POST_CREATE,
+	OP_BIND,
+	OP_CONNECT,
+	OP_LISTEN,
+	OP_ACCEPT,
+	OP_SENDMSG,
+	OP_RECVMSG,
+	OP_GETSOCKNAME,
+	OP_GETPEERNAME,
+	OP_GETSOCKOPT,
+	OP_SETSOCKOPT,
+	OP_SOCK_SHUTDOWN,
+
+	OP_PTRACE,
+
+	OP_EXEC,
+	OP_CHANGE_HAT,
+	OP_CHANGE_PROFILE,
+	OP_CHANGE_ONEXEC,
+
+	OP_SETPROCATTR,
+	OP_SETRLIMIT,
+
+	OP_PROF_REPL,
+	OP_PROF_LOAD,
+	OP_PROF_RM,
+};
+
+
+/* define a short hand for apparmor_audit_data portion of common_audit_data */
+#define aad apparmor_audit_data
+
+void aa_audit_msg(int type, struct common_audit_data *sa,
+		  void (*cb) (struct audit_buffer *, void *));
+int aa_audit(int type, struct aa_profile *profile, gfp_t gfp,
+	     struct common_audit_data *sa,
+	     void (*cb) (struct audit_buffer *, void *));
+
+static inline int complain_error(int error)
+{
+	if (error == -EPERM || error == -EACCES)
+		return 0;
+	return error;
+}
+
+#endif /* __AA_AUDIT_H */
-- 
1.7.1

