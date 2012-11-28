Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918Ab2K1W56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:57:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59324 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab2K1W5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:57:55 -0500
Date: Wed, 28 Nov 2012 14:57:44 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com, Steve Grubb <sgrubb@redhat.com>,
        keescook@chromium.org
Subject: [PATCH] audit: fix event coverage of AUDIT_ANOM_LINK
Message-ID: <20121128225744.GA11697@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace audit tools didn't like the existing formatting of the
AUDIT_ANOM_LINK event. It needed to be expanded to emit an AUDIT_PATH
event as well, so this implements the change. The bulk of the patch is
moving code out of auditsc.c into audit.c and audit.h for general use.
It expands audit_log_name to include an optional "struct path" argument
for the simple case of just needing to report a pathname. This also makes
audit_log_task_info available when syscall auditing is not enabled so
an admin can make sense of the audit report (which would have only shown
path information, not process information).

Reported-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/audit.h |   16 ++-
 kernel/audit.c        |  247 ++++++++++++++++++++++++++++++++--
 kernel/audit.h        |  157 ++++++++++++++++++++++
 kernel/auditsc.c      |  354 +------------------------------------------------
 4 files changed, 406 insertions(+), 368 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index bce729a..ec23d40 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -183,8 +183,6 @@ static inline int audit_get_sessionid(struct task_struct *tsk)
 	return tsk->sessionid;
 }
 
-extern void audit_log_task_context(struct audit_buffer *ab);
-extern void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk);
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
 extern int __audit_bprm(struct linux_binprm *bprm);
@@ -338,11 +336,6 @@ static inline int audit_get_sessionid(struct task_struct *tsk)
 {
 	return -1;
 }
-static inline void audit_log_task_context(struct audit_buffer *ab)
-{ }
-static inline void audit_log_task_info(struct audit_buffer *ab,
-				       struct task_struct *tsk)
-{ }
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 { }
 static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
@@ -427,6 +420,10 @@ static inline void	    audit_log_secctx(struct audit_buffer *ab, u32 secid)
 { }
 #endif
 
+extern void audit_log_task_context(struct audit_buffer *ab);
+extern void audit_log_task_info(struct audit_buffer *ab,
+				struct task_struct *tsk);
+
 extern int		    audit_update_lsm_rules(void);
 
 				/* Private API (for audit.c only) */
@@ -474,6 +471,11 @@ static inline void audit_log_link_denied(const char *string,
 { }
 static inline void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 { }
+static inline void audit_log_task_context(struct audit_buffer *ab)
+{ }
+static inline void audit_log_task_info(struct audit_buffer *ab,
+				       struct task_struct *tsk)
+{ }
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
diff --git a/kernel/audit.c b/kernel/audit.c
index 40414e9..16585f5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/kthread.h>
+#include <linux/syscalls.h>
 
 #include <linux/audit.h>
 
@@ -1429,6 +1430,224 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 		audit_log_format(ab, "(null)");
 }
 
+void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
+{
+	int i;
+
+	audit_log_format(ab, " %s=", prefix);
+	CAP_FOR_EACH_U32(i) {
+		audit_log_format(ab, "%08x",
+				 cap->cap[(_KERNEL_CAPABILITY_U32S-1) - i]);
+	}
+}
+
+void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
+{
+	kernel_cap_t *perm = &name->fcap.permitted;
+	kernel_cap_t *inh = &name->fcap.inheritable;
+	int log = 0;
+
+	if (!cap_isclear(*perm)) {
+		audit_log_cap(ab, "cap_fp", perm);
+		log = 1;
+	}
+	if (!cap_isclear(*inh)) {
+		audit_log_cap(ab, "cap_fi", inh);
+		log = 1;
+	}
+
+	if (log)
+		audit_log_format(ab, " cap_fe=%d cap_fver=%x",
+				 name->fcap.fE, name->fcap_ver);
+}
+
+static inline int audit_copy_fcaps(struct audit_names *name,
+				   const struct dentry *dentry)
+{
+	struct cpu_vfs_cap_data caps;
+	int rc;
+
+	if (!dentry)
+		return 0;
+
+	rc = get_vfs_caps_from_disk(dentry, &caps);
+	if (rc)
+		return rc;
+
+	name->fcap.permitted = caps.permitted;
+	name->fcap.inheritable = caps.inheritable;
+	name->fcap.fE = !!(caps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
+	name->fcap_ver = (caps.magic_etc & VFS_CAP_REVISION_MASK) >>
+				VFS_CAP_REVISION_SHIFT;
+
+	return 0;
+}
+
+/* Copy inode data into an audit_names. */
+void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
+		      const struct inode *inode)
+{
+	name->ino   = inode->i_ino;
+	name->dev   = inode->i_sb->s_dev;
+	name->mode  = inode->i_mode;
+	name->uid   = inode->i_uid;
+	name->gid   = inode->i_gid;
+	name->rdev  = inode->i_rdev;
+	security_inode_getsecid(inode, &name->osid);
+	audit_copy_fcaps(name, dentry);
+}
+
+/**
+ * audit_log_name - produce AUDIT_PATH record from struct audit_names
+ * @context: audit_context for the task
+ * @n: audit_names structure with reportable details
+ * @path: optional path to report instead of audit_names->name
+ * @record_num: record number to report when handling a list of names
+ * @call_panic: optional pointer to int that will be updated if secid fails
+ */
+void audit_log_name(struct audit_context *context, struct audit_names *n,
+		    struct path *path, int record_num, int *call_panic)
+{
+	struct audit_buffer *ab;
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "item=%d", record_num);
+
+	if (path)
+		audit_log_d_path(ab, " name=", path);
+	else if (n->name) {
+		switch (n->name_len) {
+		case AUDIT_NAME_FULL:
+			/* log the full path */
+			audit_log_format(ab, " name=");
+			audit_log_untrustedstring(ab, n->name->name);
+			break;
+		case 0:
+			/* name was specified as a relative path and the
+			 * directory component is the cwd */
+			audit_log_d_path(ab, " name=", &context->pwd);
+			break;
+		default:
+			/* log the name's directory component */
+			audit_log_format(ab, " name=");
+			audit_log_n_untrustedstring(ab, n->name->name,
+						    n->name_len);
+		}
+	} else
+		audit_log_format(ab, " name=(null)");
+
+	if (n->ino != (unsigned long)-1) {
+		audit_log_format(ab, " inode=%lu" \
+				 " dev=%02x:%02x mode=%#ho" \
+				 " ouid=%u ogid=%u rdev=%02x:%02x",
+				 n->ino,
+				 MAJOR(n->dev),
+				 MINOR(n->dev),
+				 n->mode,
+				 from_kuid(&init_user_ns, n->uid),
+				 from_kgid(&init_user_ns, n->gid),
+				 MAJOR(n->rdev),
+				 MINOR(n->rdev));
+	}
+	if (n->osid != 0) {
+		char *ctx = NULL;
+		u32 len;
+		if (security_secid_to_secctx(
+			n->osid, &ctx, &len)) {
+			audit_log_format(ab, " osid=%u", n->osid);
+			if (call_panic)
+				*call_panic = 2;
+		} else {
+			audit_log_format(ab, " obj=%s", ctx);
+			security_release_secctx(ctx, len);
+		}
+	}
+
+	audit_log_fcaps(ab, n);
+	audit_log_end(ab);
+}
+
+void audit_log_task_context(struct audit_buffer *ab)
+{
+	char *ctx = NULL;
+	unsigned len;
+	int error;
+	u32 sid;
+
+	security_task_getsecid(current, &sid);
+	if (!sid)
+		return;
+
+	error = security_secid_to_secctx(sid, &ctx, &len);
+	if (error) {
+		if (error != -EINVAL)
+			goto error_path;
+		return;
+	}
+
+	audit_log_format(ab, " subj=%s", ctx);
+	security_release_secctx(ctx, len);
+	return;
+
+error_path:
+	audit_panic("error in audit_log_task_context");
+	return;
+}
+EXPORT_SYMBOL(audit_log_task_context);
+
+void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
+{
+	const struct cred *cred;
+	char name[sizeof(tsk->comm)];
+	struct mm_struct *mm = tsk->mm;
+	char *tty;
+
+	if (!ab)
+		return;
+
+	/* tsk == current */
+	cred = current_cred();
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
+		tty = tsk->signal->tty->name;
+	else
+		tty = "(none)";
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	audit_log_format(ab,
+			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
+			 " euid=%u suid=%u fsuid=%u"
+			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 sys_getppid(),
+			 tsk->pid,
+			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
+			 from_kuid(&init_user_ns, cred->uid),
+			 from_kgid(&init_user_ns, cred->gid),
+			 from_kuid(&init_user_ns, cred->euid),
+			 from_kuid(&init_user_ns, cred->suid),
+			 from_kuid(&init_user_ns, cred->fsuid),
+			 from_kgid(&init_user_ns, cred->egid),
+			 from_kgid(&init_user_ns, cred->sgid),
+			 from_kgid(&init_user_ns, cred->fsgid),
+			 audit_get_sessionid(tsk), tty);
+
+	get_task_comm(name, tsk);
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, name);
+
+	if (mm) {
+		down_read(&mm->mmap_sem);
+		if (mm->exe_file)
+			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
+		up_read(&mm->mmap_sem);
+	}
+	audit_log_task_context(ab);
+}
+EXPORT_SYMBOL(audit_log_task_info);
+
 /**
  * audit_log_link_denied - report a link restriction denial
  * @operation: specific link opreation
@@ -1437,19 +1656,31 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 void audit_log_link_denied(const char *operation, struct path *link)
 {
 	struct audit_buffer *ab;
+	struct audit_names *name;
+
+	name = kzalloc(sizeof(*name), GFP_NOFS);
+	if (!name)
+		return;
 
+	/* Generate AUDIT_ANOM_LINK with subject, operation, outcome. */
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
 			     AUDIT_ANOM_LINK);
 	if (!ab)
-		return;
-	audit_log_format(ab, "op=%s action=denied", operation);
-	audit_log_format(ab, " pid=%d comm=", current->pid);
-	audit_log_untrustedstring(ab, current->comm);
-	audit_log_d_path(ab, " path=", link);
-	audit_log_format(ab, " dev=");
-	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
-	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
+		goto out;
+	audit_log_format(ab, "op=%s", operation);
+#ifndef CONFIG_AUDITSYSCALL
+	/* This is needed if built without syscall auditing. */
+	audit_log_task_info(ab, current);
+#endif
+	audit_log_format(ab, " res=0");
 	audit_log_end(ab);
+
+	/* Generate AUDIT_PATH record with object. */
+	name->type = AUDIT_TYPE_NORMAL;
+	audit_copy_inode(name, link->dentry, link->dentry->d_inode);
+	audit_log_name(current->audit_context, name, link, 0, NULL);
+out:
+	kfree(name);
 }
 
 /**
diff --git a/kernel/audit.h b/kernel/audit.h
index d51cba8..2598b1e 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/audit.h>
 #include <linux/skbuff.h>
+#include <uapi/linux/mqueue.h>
 
 /* 0 = no checking
    1 = put_count checking
@@ -29,6 +30,11 @@
 */
 #define AUDIT_DEBUG 0
 
+/* AUDIT_NAMES is the number of slots we reserve in the audit_context
+ * for saving names from getname().  If we get more names we will allocate
+ * a name dynamically and also add those to the list anchored by names_list. */
+#define AUDIT_NAMES	5
+
 /* At task start time, the audit_state is set in the audit_context using
    a per-task filter.  At syscall entry, the audit_state is augmented by
    the syscall filter. */
@@ -59,9 +65,160 @@ struct audit_entry {
 	struct audit_krule	rule;
 };
 
+struct audit_cap_data {
+	kernel_cap_t		permitted;
+	kernel_cap_t		inheritable;
+	union {
+		unsigned int	fE;		/* effective bit of file cap */
+		kernel_cap_t	effective;	/* effective set of process */
+	};
+};
+
+/* When fs/namei.c:getname() is called, we store the pointer in name and
+ * we don't let putname() free it (instead we free all of the saved
+ * pointers at syscall exit time).
+ *
+ * Further, in fs/namei.c:path_lookup() we store the inode and device.
+ */
+struct audit_names {
+	struct list_head	list;		/* audit_context->names_list */
+
+	struct filename		*name;
+	int			name_len;	/* number of chars to log */
+	bool			name_put;	/* call __putname()? */
+
+	unsigned long		ino;
+	dev_t			dev;
+	umode_t			mode;
+	kuid_t			uid;
+	kgid_t			gid;
+	dev_t			rdev;
+	u32			osid;
+	struct audit_cap_data	fcap;
+	unsigned int		fcap_ver;
+	unsigned char		type;		/* record type */
+	/*
+	 * This was an allocated audit_names and not from the array of
+	 * names allocated in the task audit context.  Thus this name
+	 * should be freed on syscall exit.
+	 */
+	bool			should_free;
+};
+
+/* The per-task audit context. */
+struct audit_context {
+	int		    dummy;	/* must be the first element */
+	int		    in_syscall;	/* 1 if task is in a syscall */
+	enum audit_state    state, current_state;
+	unsigned int	    serial;     /* serial number for record */
+	int		    major;      /* syscall number */
+	struct timespec	    ctime;      /* time of syscall entry */
+	unsigned long	    argv[4];    /* syscall arguments */
+	long		    return_code;/* syscall return code */
+	u64		    prio;
+	int		    return_valid; /* return code is valid */
+	/*
+	 * The names_list is the list of all audit_names collected during this
+	 * syscall.  The first AUDIT_NAMES entries in the names_list will
+	 * actually be from the preallocated_names array for performance
+	 * reasons.  Except during allocation they should never be referenced
+	 * through the preallocated_names array and should only be found/used
+	 * by running the names_list.
+	 */
+	struct audit_names  preallocated_names[AUDIT_NAMES];
+	int		    name_count; /* total records in names_list */
+	struct list_head    names_list;	/* anchor for audit_names->list */
+	char		    *filterkey;	/* key for rule that triggered record */
+	struct path	    pwd;
+	struct audit_context *previous; /* For nested syscalls */
+	struct audit_aux_data *aux;
+	struct audit_aux_data *aux_pids;
+	struct sockaddr_storage *sockaddr;
+	size_t sockaddr_len;
+				/* Save things to print about task_struct */
+	pid_t		    pid, ppid;
+	kuid_t		    uid, euid, suid, fsuid;
+	kgid_t		    gid, egid, sgid, fsgid;
+	unsigned long	    personality;
+	int		    arch;
+
+	pid_t		    target_pid;
+	kuid_t		    target_auid;
+	kuid_t		    target_uid;
+	unsigned int	    target_sessionid;
+	u32		    target_sid;
+	char		    target_comm[TASK_COMM_LEN];
+
+	struct audit_tree_refs *trees, *first_trees;
+	struct list_head killed_trees;
+	int tree_count;
+
+	int type;
+	union {
+		struct {
+			int nargs;
+			long args[6];
+		} socketcall;
+		struct {
+			kuid_t			uid;
+			kgid_t			gid;
+			umode_t			mode;
+			u32			osid;
+			int			has_perm;
+			uid_t			perm_uid;
+			gid_t			perm_gid;
+			umode_t			perm_mode;
+			unsigned long		qbytes;
+		} ipc;
+		struct {
+			mqd_t			mqdes;
+			struct mq_attr		mqstat;
+		} mq_getsetattr;
+		struct {
+			mqd_t			mqdes;
+			int			sigev_signo;
+		} mq_notify;
+		struct {
+			mqd_t			mqdes;
+			size_t			msg_len;
+			unsigned int		msg_prio;
+			struct timespec		abs_timeout;
+		} mq_sendrecv;
+		struct {
+			int			oflag;
+			umode_t			mode;
+			struct mq_attr		attr;
+		} mq_open;
+		struct {
+			pid_t			pid;
+			struct audit_cap_data	cap;
+		} capset;
+		struct {
+			int			fd;
+			int			flags;
+		} mmap;
+	};
+	int fds[2];
+
+#if AUDIT_DEBUG
+	int		    put_count;
+	int		    ino_count;
+#endif
+};
+
 #ifdef CONFIG_AUDIT
 extern int audit_enabled;
 extern int audit_ever_enabled;
+
+extern void audit_copy_inode(struct audit_names *name,
+			     const struct dentry *dentry,
+			     const struct inode *inode);
+extern void audit_log_cap(struct audit_buffer *ab, char *prefix,
+			  kernel_cap_t *cap);
+extern void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name);
+extern void audit_log_name(struct audit_context *context,
+			   struct audit_names *n, struct path *path,
+			   int record_num, int *call_panic);
 #endif
 
 extern int audit_pid;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2f186ed..6ff826e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -76,11 +76,6 @@
 #define AUDITSC_SUCCESS 1
 #define AUDITSC_FAILURE 2
 
-/* AUDIT_NAMES is the number of slots we reserve in the audit_context
- * for saving names from getname().  If we get more names we will allocate
- * a name dynamically and also add those to the list anchored by names_list. */
-#define AUDIT_NAMES	5
-
 /* no execve audit message should be longer than this (userspace limits) */
 #define MAX_EXECVE_AUDIT_LEN 7500
 
@@ -90,44 +85,6 @@ int audit_n_rules;
 /* determines whether we collect data for signals sent */
 int audit_signals;
 
-struct audit_cap_data {
-	kernel_cap_t		permitted;
-	kernel_cap_t		inheritable;
-	union {
-		unsigned int	fE;		/* effective bit of a file capability */
-		kernel_cap_t	effective;	/* effective set of a process */
-	};
-};
-
-/* When fs/namei.c:getname() is called, we store the pointer in name and
- * we don't let putname() free it (instead we free all of the saved
- * pointers at syscall exit time).
- *
- * Further, in fs/namei.c:path_lookup() we store the inode and device.
- */
-struct audit_names {
-	struct list_head	list;		/* audit_context->names_list */
-	struct filename	*name;
-	unsigned long		ino;
-	dev_t			dev;
-	umode_t			mode;
-	kuid_t			uid;
-	kgid_t			gid;
-	dev_t			rdev;
-	u32			osid;
-	struct audit_cap_data	 fcap;
-	unsigned int		fcap_ver;
-	int			name_len;	/* number of name's characters to log */
-	unsigned char		type;		/* record type */
-	bool			name_put;	/* call __putname() for this name */
-	/*
-	 * This was an allocated audit_names and not from the array of
-	 * names allocated in the task audit context.  Thus this name
-	 * should be freed on syscall exit
-	 */
-	bool			should_free;
-};
-
 struct audit_aux_data {
 	struct audit_aux_data	*next;
 	int			type;
@@ -175,107 +132,6 @@ struct audit_tree_refs {
 	struct audit_chunk *c[31];
 };
 
-/* The per-task audit context. */
-struct audit_context {
-	int		    dummy;	/* must be the first element */
-	int		    in_syscall;	/* 1 if task is in a syscall */
-	enum audit_state    state, current_state;
-	unsigned int	    serial;     /* serial number for record */
-	int		    major;      /* syscall number */
-	struct timespec	    ctime;      /* time of syscall entry */
-	unsigned long	    argv[4];    /* syscall arguments */
-	long		    return_code;/* syscall return code */
-	u64		    prio;
-	int		    return_valid; /* return code is valid */
-	/*
-	 * The names_list is the list of all audit_names collected during this
-	 * syscall.  The first AUDIT_NAMES entries in the names_list will
-	 * actually be from the preallocated_names array for performance
-	 * reasons.  Except during allocation they should never be referenced
-	 * through the preallocated_names array and should only be found/used
-	 * by running the names_list.
-	 */
-	struct audit_names  preallocated_names[AUDIT_NAMES];
-	int		    name_count; /* total records in names_list */
-	struct list_head    names_list;	/* anchor for struct audit_names->list */
-	char *		    filterkey;	/* key for rule that triggered record */
-	struct path	    pwd;
-	struct audit_context *previous; /* For nested syscalls */
-	struct audit_aux_data *aux;
-	struct audit_aux_data *aux_pids;
-	struct sockaddr_storage *sockaddr;
-	size_t sockaddr_len;
-				/* Save things to print about task_struct */
-	pid_t		    pid, ppid;
-	kuid_t		    uid, euid, suid, fsuid;
-	kgid_t		    gid, egid, sgid, fsgid;
-	unsigned long	    personality;
-	int		    arch;
-
-	pid_t		    target_pid;
-	kuid_t		    target_auid;
-	kuid_t		    target_uid;
-	unsigned int	    target_sessionid;
-	u32		    target_sid;
-	char		    target_comm[TASK_COMM_LEN];
-
-	struct audit_tree_refs *trees, *first_trees;
-	struct list_head killed_trees;
-	int tree_count;
-
-	int type;
-	union {
-		struct {
-			int nargs;
-			long args[6];
-		} socketcall;
-		struct {
-			kuid_t			uid;
-			kgid_t			gid;
-			umode_t			mode;
-			u32			osid;
-			int			has_perm;
-			uid_t			perm_uid;
-			gid_t			perm_gid;
-			umode_t			perm_mode;
-			unsigned long		qbytes;
-		} ipc;
-		struct {
-			mqd_t			mqdes;
-			struct mq_attr 		mqstat;
-		} mq_getsetattr;
-		struct {
-			mqd_t			mqdes;
-			int			sigev_signo;
-		} mq_notify;
-		struct {
-			mqd_t			mqdes;
-			size_t			msg_len;
-			unsigned int		msg_prio;
-			struct timespec		abs_timeout;
-		} mq_sendrecv;
-		struct {
-			int			oflag;
-			umode_t			mode;
-			struct mq_attr		attr;
-		} mq_open;
-		struct {
-			pid_t			pid;
-			struct audit_cap_data	cap;
-		} capset;
-		struct {
-			int			fd;
-			int			flags;
-		} mmap;
-	};
-	int fds[2];
-
-#if AUDIT_DEBUG
-	int		    put_count;
-	int		    ino_count;
-#endif
-};
-
 static inline int open_arg(int flags, int mask)
 {
 	int n = ACC_MODE(flags);
@@ -1116,88 +972,6 @@ static inline void audit_free_context(struct audit_context *context)
 		printk(KERN_ERR "audit: freed %d contexts\n", count);
 }
 
-void audit_log_task_context(struct audit_buffer *ab)
-{
-	char *ctx = NULL;
-	unsigned len;
-	int error;
-	u32 sid;
-
-	security_task_getsecid(current, &sid);
-	if (!sid)
-		return;
-
-	error = security_secid_to_secctx(sid, &ctx, &len);
-	if (error) {
-		if (error != -EINVAL)
-			goto error_path;
-		return;
-	}
-
-	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
-	return;
-
-error_path:
-	audit_panic("error in audit_log_task_context");
-	return;
-}
-
-EXPORT_SYMBOL(audit_log_task_context);
-
-void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
-{
-	const struct cred *cred;
-	char name[sizeof(tsk->comm)];
-	struct mm_struct *mm = tsk->mm;
-	char *tty;
-
-	if (!ab)
-		return;
-
-	/* tsk == current */
-	cred = current_cred();
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
-		tty = tsk->signal->tty->name;
-	else
-		tty = "(none)";
-	spin_unlock_irq(&tsk->sighand->siglock);
-
-
-	audit_log_format(ab,
-			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
-			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
-			 sys_getppid(),
-			 tsk->pid,
-			 from_kuid(&init_user_ns, tsk->loginuid),
-			 from_kuid(&init_user_ns, cred->uid),
-			 from_kgid(&init_user_ns, cred->gid),
-			 from_kuid(&init_user_ns, cred->euid),
-			 from_kuid(&init_user_ns, cred->suid),
-			 from_kuid(&init_user_ns, cred->fsuid),
-			 from_kgid(&init_user_ns, cred->egid),
-			 from_kgid(&init_user_ns, cred->sgid),
-			 from_kgid(&init_user_ns, cred->fsgid),
-			 tsk->sessionid, tty);
-
-	get_task_comm(name, tsk);
-	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, name);
-
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		if (mm->exe_file)
-			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
-		up_read(&mm->mmap_sem);
-	}
-	audit_log_task_context(ab);
-}
-
-EXPORT_SYMBOL(audit_log_task_info);
-
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 kuid_t auid, kuid_t uid, unsigned int sessionid,
 				 u32 sid, char *comm)
@@ -1413,35 +1187,6 @@ static void audit_log_execve_info(struct audit_context *context,
 	kfree(buf);
 }
 
-static void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
-{
-	int i;
-
-	audit_log_format(ab, " %s=", prefix);
-	CAP_FOR_EACH_U32(i) {
-		audit_log_format(ab, "%08x", cap->cap[(_KERNEL_CAPABILITY_U32S-1) - i]);
-	}
-}
-
-static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
-{
-	kernel_cap_t *perm = &name->fcap.permitted;
-	kernel_cap_t *inh = &name->fcap.inheritable;
-	int log = 0;
-
-	if (!cap_isclear(*perm)) {
-		audit_log_cap(ab, "cap_fp", perm);
-		log = 1;
-	}
-	if (!cap_isclear(*inh)) {
-		audit_log_cap(ab, "cap_fi", inh);
-		log = 1;
-	}
-
-	if (log)
-		audit_log_format(ab, " cap_fe=%d cap_fver=%x", name->fcap.fE, name->fcap_ver);
-}
-
 static void show_special(struct audit_context *context, int *call_panic)
 {
 	struct audit_buffer *ab;
@@ -1539,68 +1284,6 @@ static void show_special(struct audit_context *context, int *call_panic)
 	audit_log_end(ab);
 }
 
-static void audit_log_name(struct audit_context *context, struct audit_names *n,
-			   int record_num, int *call_panic)
-{
-	struct audit_buffer *ab;
-	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
-	if (!ab)
-		return; /* audit_panic has been called */
-
-	audit_log_format(ab, "item=%d", record_num);
-
-	if (n->name) {
-		switch (n->name_len) {
-		case AUDIT_NAME_FULL:
-			/* log the full path */
-			audit_log_format(ab, " name=");
-			audit_log_untrustedstring(ab, n->name->name);
-			break;
-		case 0:
-			/* name was specified as a relative path and the
-			 * directory component is the cwd */
-			audit_log_d_path(ab, " name=", &context->pwd);
-			break;
-		default:
-			/* log the name's directory component */
-			audit_log_format(ab, " name=");
-			audit_log_n_untrustedstring(ab, n->name->name,
-						    n->name_len);
-		}
-	} else
-		audit_log_format(ab, " name=(null)");
-
-	if (n->ino != (unsigned long)-1) {
-		audit_log_format(ab, " inode=%lu"
-				 " dev=%02x:%02x mode=%#ho"
-				 " ouid=%u ogid=%u rdev=%02x:%02x",
-				 n->ino,
-				 MAJOR(n->dev),
-				 MINOR(n->dev),
-				 n->mode,
-				 from_kuid(&init_user_ns, n->uid),
-				 from_kgid(&init_user_ns, n->gid),
-				 MAJOR(n->rdev),
-				 MINOR(n->rdev));
-	}
-	if (n->osid != 0) {
-		char *ctx = NULL;
-		u32 len;
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
-			audit_log_format(ab, " osid=%u", n->osid);
-			*call_panic = 2;
-		} else {
-			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
-		}
-	}
-
-	audit_log_fcaps(ab, n);
-
-	audit_log_end(ab);
-}
-
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -1718,7 +1401,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	i = 0;
 	list_for_each_entry(n, &context->names_list, list)
-		audit_log_name(context, n, i++, &call_panic);
+		audit_log_name(context, n, NULL, i++, &call_panic);
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -2126,41 +1809,6 @@ void audit_putname(struct filename *name)
 #endif
 }
 
-static inline int audit_copy_fcaps(struct audit_names *name, const struct dentry *dentry)
-{
-	struct cpu_vfs_cap_data caps;
-	int rc;
-
-	if (!dentry)
-		return 0;
-
-	rc = get_vfs_caps_from_disk(dentry, &caps);
-	if (rc)
-		return rc;
-
-	name->fcap.permitted = caps.permitted;
-	name->fcap.inheritable = caps.inheritable;
-	name->fcap.fE = !!(caps.magic_etc & VFS_CAP_FLAGS_EFFECTIVE);
-	name->fcap_ver = (caps.magic_etc & VFS_CAP_REVISION_MASK) >> VFS_CAP_REVISION_SHIFT;
-
-	return 0;
-}
-
-
-/* Copy inode data into an audit_names. */
-static void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
-			     const struct inode *inode)
-{
-	name->ino   = inode->i_ino;
-	name->dev   = inode->i_sb->s_dev;
-	name->mode  = inode->i_mode;
-	name->uid   = inode->i_uid;
-	name->gid   = inode->i_gid;
-	name->rdev  = inode->i_rdev;
-	security_inode_getsecid(inode, &name->osid);
-	audit_copy_fcaps(name, dentry);
-}
-
 /**
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
