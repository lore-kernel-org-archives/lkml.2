Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3AHCP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:15:56 -0500
Received: from nm11.access.bullet.mail.mud.yahoo.com ([66.94.237.212]:35683
	"EHLO nm11.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab3AHCPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:15:54 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 21:15:54 EST
X-Yahoo-Newman-Id: 266701.70327.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: evFVjDMVM1laeVgQr.XKcIsdrjWao4M4RwqDQrZE14qhWI5
 ekZrOj2pQYqEGZNIyoQY.vw4ehf9GG4ITEy60WjlYUghBBvFbxFexb9sgX2v
 N4kGa6fg6a1wyS7ZDIwFV6wmDW8Ns2DDjs3hsDGzBpJ3TZGpVymriCcZeFN5
 ChGEF0M_Oi57uawJceO5qtIQO1mYX0gnRSp.ENkQoh.ETvJZ9GEROcQpfKU6
 p2heQM4UjBH6GSOKzZQUhaV5tVMHlA3D3uTeXtjU2bM8H2PN5FrRk0H8GAfC
 hGKCGRDij8VgbxrtFgdxTwkFdgNhUwBR2yzTPBZqebQegn1grQZ4FBJcTsJf
 FozR4KIcva80E5EzrdOVsp.MQYGFXGu17AN8pVCuJSgbuq57L2eZYlIWOzE_
 ZFLGpagc23thSOET01pspPAerlCvDA5O58Um9s9EBehTM97LxhSleRx1qOJe
 LESZi
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FD3.3040007@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:23 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 4/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 4/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Configuration changes.
Headers files. Add securityfs files to report the
registered and present LSMs.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/lsm.h      |  174 +++++++++++++++++++++++++++++++
 include/linux/security.h |  255 +++++++++++++++++++++++++++++++++++++++-------
 security/Kconfig         |   79 +++++++++-----
 security/inode.c         |   79 +++++++++++++-
 4 files changed, 521 insertions(+), 66 deletions(-)

diff --git a/include/linux/lsm.h b/include/linux/lsm.h
new file mode 100644
index 0000000..5f36b6b
--- /dev/null
+++ b/include/linux/lsm.h
@@ -0,0 +1,174 @@
+/*
+ *
+ * Copyright (C) 2012 Casey Schaufler <casey@schaufler-ca.com>
+ * Copyright (C) 2012 Intel Corporation
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation, version 2.
+ *
+ * Author:
+ *	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ */
+#ifndef _LINUX_LSM_H
+#define _LINUX_LSM_H
+
+#include <linux/cred.h>
+#include <linux/fs.h>
+#include <linux/msg.h>
+#include <linux/key.h>
+#include <net/sock.h>
+
+/*
+ * Maximum number of LSMs that can be used at a time.
+ */
+#define COMPOSER_MAX		CONFIG_SECURITY_COMPOSER_MAX
+#define COMPOSER_NAMES_MAX	((SECURITY_NAME_MAX + 1) * COMPOSER_MAX)
+
+#include <linux/security.h>
+
+/*
+ * Just a set of slots for each LSM to keep its blob in.
+ */
+struct lsm_blob {
+	int	lsm_setcount;			/* Number of blobs set */
+	void	*lsm_blobs[COMPOSER_MAX];	/* LSM specific blobs */
+};
+
+static inline struct lsm_blob *lsm_alloc_blob(gfp_t gfp)
+{
+	return kzalloc(sizeof(struct lsm_blob), gfp);
+}
+
+static inline void *lsm_get_blob(const struct lsm_blob *bp, const int lsm)
+{
+	if (bp == NULL)
+		return NULL;
+	return bp->lsm_blobs[lsm];
+}
+
+static inline void lsm_set_blob(void **vpp, void *value, const int lsm)
+{
+	struct lsm_blob *bp = *vpp;
+
+	if (value == NULL && bp->lsm_blobs[lsm] != NULL)
+		bp->lsm_setcount--;
+	if (value != NULL && bp->lsm_blobs[lsm] == NULL)
+		bp->lsm_setcount++;
+
+	bp->lsm_blobs[lsm] = value;
+}
+
+static inline void *lsm_get_cred(const struct cred *cred,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(cred->security, sop->order);
+}
+
+static inline void lsm_set_cred(struct cred *cred, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&cred->security, value, sop->order);
+}
+
+static inline int lsm_set_init_cred(struct cred *cred, void *value,
+					const struct security_operations *sop)
+{
+	if (cred->security == NULL) {
+		cred->security = lsm_alloc_blob(GFP_KERNEL);
+		if (cred->security == NULL)
+			return -ENOMEM;
+	}
+
+	lsm_set_blob(&cred->security, value, sop->order);
+	return 0;
+}
+
+static inline void *lsm_get_file(const struct file *file,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(file->f_security, sop->order);
+}
+
+static inline void lsm_set_file(struct file *file, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&file->f_security, value, sop->order);
+}
+
+static inline void *lsm_get_inode(const struct inode *inode,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(inode->i_security, sop->order);
+}
+
+static inline void lsm_set_inode(struct inode *inode, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&inode->i_security, value, sop->order);
+}
+
+static inline void *lsm_get_super(const struct super_block *super,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(super->s_security, sop->order);
+}
+
+static inline void lsm_set_super(struct super_block *super, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&super->s_security, value, sop->order);
+}
+
+static inline void *lsm_get_ipc(const struct kern_ipc_perm *ipc,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(ipc->security, sop->order);
+}
+
+static inline void lsm_set_ipc(struct kern_ipc_perm *ipc, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&ipc->security, value, sop->order);
+}
+
+static inline void *lsm_get_msg(const struct msg_msg *msg,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(msg->security, sop->order);
+}
+
+static inline void lsm_set_msg(struct msg_msg *msg, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&msg->security, value, sop->order);
+}
+
+#ifdef CONFIG_KEYS
+static inline void *lsm_get_key(const struct key *key,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(key->security, sop->order);
+}
+
+static inline void lsm_set_key(struct key *key, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&key->security, value, sop->order);
+}
+#endif
+
+static inline void *lsm_get_sock(const struct sock *sock,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(sock->sk_security, sop->order);
+}
+
+static inline void lsm_set_sock(struct sock *sock, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&sock->sk_security, value, sop->order);
+}
+
+#endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 0f6afc6..535a967 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -87,8 +87,6 @@ extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_mmap_addr(unsigned long addr);
-extern int cap_mmap_file(struct file *file, unsigned long reqprot,
-			 unsigned long prot, unsigned long flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -112,8 +110,6 @@ struct seq_file;
 
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 
-void reset_security_ops(void);
-
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
@@ -184,15 +180,223 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 	opts->num_mnt_opts = 0;
 }
 
+/*
+ * Index for LSM operations.
+ */
+enum lsm_hooks_index {
+	lsm_ptrace_access_check,
+	lsm_ptrace_traceme,
+	lsm_capget,
+	lsm_capset,
+	lsm_capable,
+	lsm_quotactl,
+	lsm_quota_on,
+	lsm_syslog,
+	lsm_settime,
+	lsm_vm_enough_memory,
+	lsm_bprm_set_creds,
+	lsm_bprm_check_security,
+	lsm_bprm_secureexec,
+	lsm_bprm_committing_creds,
+	lsm_bprm_committed_creds,
+	lsm_sb_alloc_security,
+	lsm_sb_free_security,
+	lsm_sb_copy_data,
+	lsm_sb_remount,
+	lsm_sb_kern_mount,
+	lsm_sb_show_options,
+	lsm_sb_statfs,
+	lsm_sb_mount,
+	lsm_sb_umount,
+	lsm_sb_pivotroot,
+	lsm_sb_set_mnt_opts,
+	lsm_sb_clone_mnt_opts,
+	lsm_sb_parse_opts_str,
+	lsm_path_unlink,
+	lsm_path_mkdir,
+	lsm_path_rmdir,
+	lsm_path_mknod,
+	lsm_path_truncate,
+	lsm_path_symlink,
+	lsm_path_link,
+	lsm_path_rename,
+	lsm_path_chmod,
+	lsm_path_chown,
+	lsm_path_chroot,
+	lsm_inode_alloc_security,
+	lsm_inode_free_security,
+	lsm_inode_init_security,
+	lsm_inode_create,
+	lsm_inode_link,
+	lsm_inode_unlink,
+	lsm_inode_symlink,
+	lsm_inode_mkdir,
+	lsm_inode_rmdir,
+	lsm_inode_mknod,
+	lsm_inode_rename,
+	lsm_inode_readlink,
+	lsm_inode_follow_link,
+	lsm_inode_permission,
+	lsm_inode_setattr,
+	lsm_inode_getattr,
+	lsm_inode_setxattr,
+	lsm_inode_post_setxattr,
+	lsm_inode_getxattr,
+	lsm_inode_listxattr,
+	lsm_inode_removexattr,
+	lsm_inode_need_killpriv,
+	lsm_inode_killpriv,
+	lsm_inode_getsecurity,
+	lsm_inode_setsecurity,
+	lsm_inode_listsecurity,
+	lsm_inode_getsecid,
+	lsm_file_permission,
+	lsm_file_alloc_security,
+	lsm_file_free_security,
+	lsm_file_ioctl,
+	lsm_mmap_addr,
+	lsm_mmap_file,
+	lsm_file_mprotect,
+	lsm_file_lock,
+	lsm_file_fcntl,
+	lsm_file_set_fowner,
+	lsm_file_send_sigiotask,
+	lsm_file_receive,
+	lsm_file_open,
+	lsm_task_create,
+	lsm_task_free,
+	lsm_cred_alloc_blank,
+	lsm_cred_free,
+	lsm_cred_prepare,
+	lsm_cred_transfer,
+	lsm_kernel_act_as,
+	lsm_kernel_create_files_as,
+	lsm_kernel_module_request,
+	lsm_kernel_module_from_file,
+	lsm_task_fix_setuid,
+	lsm_task_setpgid,
+	lsm_task_getpgid,
+	lsm_task_getsid,
+	lsm_task_getsecid,
+	lsm_task_setnice,
+	lsm_task_setioprio,
+	lsm_task_getioprio,
+	lsm_task_setrlimit,
+	lsm_task_setscheduler,
+	lsm_task_getscheduler,
+	lsm_task_movememory,
+	lsm_task_kill,
+	lsm_task_wait,
+	lsm_task_prctl,
+	lsm_task_to_inode,
+	lsm_ipc_permission,
+	lsm_ipc_getsecid,
+	lsm_msg_msg_alloc_security,
+	lsm_msg_msg_free_security,
+	lsm_msg_queue_alloc_security,
+	lsm_msg_queue_free_security,
+	lsm_msg_queue_associate,
+	lsm_msg_queue_msgctl,
+	lsm_msg_queue_msgsnd,
+	lsm_msg_queue_msgrcv,
+	lsm_shm_alloc_security,
+	lsm_shm_free_security,
+	lsm_shm_associate,
+	lsm_shm_shmctl,
+	lsm_shm_shmat,
+	lsm_sem_alloc_security,
+	lsm_sem_free_security,
+	lsm_sem_associate,
+	lsm_sem_semctl,
+	lsm_sem_semop,
+	lsm_netlink_send,
+	lsm_d_instantiate,
+	lsm_getprocattr,
+	lsm_setprocattr,
+	lsm_secid_to_secctx,
+	lsm_secctx_to_secid,
+	lsm_release_secctx,
+	lsm_inode_notifysecctx,
+	lsm_inode_setsecctx,
+	lsm_inode_getsecctx,
+	lsm_unix_stream_connect,
+	lsm_unix_may_send,
+	lsm_socket_create,
+	lsm_socket_post_create,
+	lsm_socket_bind,
+	lsm_socket_connect,
+	lsm_socket_listen,
+	lsm_socket_accept,
+	lsm_socket_sendmsg,
+	lsm_socket_recvmsg,
+	lsm_socket_getsockname,
+	lsm_socket_getpeername,
+	lsm_socket_getsockopt,
+	lsm_socket_setsockopt,
+	lsm_socket_shutdown,
+	lsm_socket_sock_rcv_skb,
+	lsm_socket_getpeersec_stream,
+	lsm_socket_getpeersec_dgram,
+	lsm_sk_alloc_security,
+	lsm_sk_free_security,
+	lsm_sk_clone_security,
+	lsm_sk_getsecid,
+	lsm_sock_graft,
+	lsm_inet_conn_request,
+	lsm_inet_csk_clone,
+	lsm_inet_conn_established,
+	lsm_secmark_relabel_packet,
+	lsm_secmark_refcount_inc,
+	lsm_secmark_refcount_dec,
+	lsm_req_classify_flow,
+	lsm_tun_dev_create,
+	lsm_tun_dev_post_create,
+	lsm_tun_dev_attach,
+	lsm_xfrm_policy_alloc_security,
+	lsm_xfrm_policy_clone_security,
+	lsm_xfrm_policy_free_security,
+	lsm_xfrm_policy_delete_security,
+	lsm_xfrm_state_alloc_security,
+	lsm_xfrm_state_free_security,
+	lsm_xfrm_state_delete_security,
+	lsm_xfrm_policy_lookup,
+	lsm_xfrm_state_pol_flow_match,
+	lsm_xfrm_decode_session,
+	lsm_key_alloc,
+	lsm_key_free,
+	lsm_key_permission,
+	lsm_key_getsecurity,
+	lsm_audit_rule_init,
+	lsm_audit_rule_known,
+	lsm_audit_rule_match,
+	lsm_audit_rule_free,
+	lsm_name, /* Used by security/inode.c */
+	LSM_MAX_HOOKS
+};
+
+/*
+ * There is a list for each hook.
+ */
+extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
+
 /**
  * struct security_operations - main security structure
  *
  * Security module identifier.
  *
+ * @list:
+ *	An array of lists of hooks. These are traversed on
+ *	hook execution.
+ *
  * @name:
  *	A string that acts as a unique identifier for the LSM with max number
  *	of characters = SECURITY_NAME_MAX.
  *
+ * @order:
+ *	The numeric order in which this LSM will be invoked.
+ *	Set during LSM initialization. Used to identify
+ *	which security blob to use when there is more than one LSM.
+ *
  * Security hooks for program execution operations.
  *
  * @bprm_set_creds:
@@ -1384,7 +1588,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * This is the main security structure.
  */
 struct security_operations {
+	struct list_head list[LSM_MAX_HOOKS];
 	char name[SECURITY_NAME_MAX + 1];
+	int order;
 
 	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
@@ -1662,12 +1868,18 @@ struct security_operations {
 #endif /* CONFIG_AUDIT */
 };
 
+/*
+ * The security operations vector for /proc interfaces.
+ */
+extern struct security_operations *lsm_present;
+
 /* prototypes */
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
-extern int register_security(struct security_operations *ops);
-extern void __init security_fixup_ops(struct security_operations *ops);
 
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+extern int reset_security_ops(struct security_operations *ops);
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
 /* Security operations */
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
@@ -3035,36 +3247,5 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
-#ifdef CONFIG_SECURITY_YAMA
-extern int yama_ptrace_access_check(struct task_struct *child,
-				    unsigned int mode);
-extern int yama_ptrace_traceme(struct task_struct *parent);
-extern void yama_task_free(struct task_struct *task);
-extern int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			   unsigned long arg4, unsigned long arg5);
-#else
-static inline int yama_ptrace_access_check(struct task_struct *child,
-					   unsigned int mode)
-{
-	return 0;
-}
-
-static inline int yama_ptrace_traceme(struct task_struct *parent)
-{
-	return 0;
-}
-
-static inline void yama_task_free(struct task_struct *task)
-{
-}
-
-static inline int yama_task_prctl(int option, unsigned long arg2,
-				  unsigned long arg3, unsigned long arg4,
-				  unsigned long arg5)
-{
-	return -ENOSYS;
-}
-#endif /* CONFIG_SECURITY_YAMA */
-
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..83415b6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -123,49 +123,74 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/yama/Kconfig
 
+config SECURITY_COMPOSER_MAX
+	int "Maximum allowed security modules (1 to 12)"
+	depends on SECURITY
+	default 6
+	range 1 12
+	help
+	  The number of security modules that can be loaded.
+	  The default value allows for all of the upstream modules.
+	  The maximum allowed value is 12.
+
 source security/integrity/Kconfig
 
 choice
-	prompt "Default security module"
-	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
-	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
-	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
-	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
-	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
-	default DEFAULT_SECURITY_DAC
+	depends on SECURITY
+	prompt "Presented security module"
+	default PRESENT_SECURITY_SELINUX \
+		if SECURITY_SELINUX && !(SECURITY_APPARMOR || SECURITY_SMACK)
+	default PRESENT_SECURITY_SMACK \
+		if SECURITY_SMACK && !(SECURITY_APPARMOR || SECURITY_SELINUX)
+	default PRESENT_SECURITY_APPARMOR \
+		if SECURITY_APPARMOR && !(SECURITY_SMACK || SECURITY_SELINUX)
+	default PRESENT_SECURITY_FIRST \
+		if SECURITY_APPARMOR || SECURITY_SMACK || SECURITY_SELINUX
+	default PRESENT_SECURITY_NONE
 
 	help
-	  Select the security module that will be used by default if the
-	  kernel parameter security= is not specified.
+	  Select the security module that will be presented
+	  with the /proc/*/attr interface.
+	  If not specified the first registered LSM that uses
+	  the /proc/*/attr interface will be chosen.
 
-	config DEFAULT_SECURITY_SELINUX
+	config PRESENT_SECURITY_SELINUX
 		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Present SELinux context information in the
+		  files in /proc/*/attr
 
-	config DEFAULT_SECURITY_SMACK
+	config PRESENT_SECURITY_SMACK
 		bool "Simplified Mandatory Access Control" if SECURITY_SMACK=y
+		help
+		  Present Smack process label information
+		  in /proc/*/attr/current
 
-	config DEFAULT_SECURITY_TOMOYO
-		bool "TOMOYO" if SECURITY_TOMOYO=y
-
-	config DEFAULT_SECURITY_APPARMOR
+	config PRESENT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
+		help
+		  Present AppArmor context information in the
+		  files in /proc/*/attr
 
-	config DEFAULT_SECURITY_YAMA
-		bool "Yama" if SECURITY_YAMA=y
+	config PRESENT_SECURITY_FIRST
+		bool "Use first registered LSM"
+		help
+		  Present information from the first LSM that uses
+		  /proc/*/attr in the files in /proc/*/attr
 
-	config DEFAULT_SECURITY_DAC
-		bool "Unix Discretionary Access Controls"
+	config PRESENT_SECURITY_NONE
+		bool "Present Nothing"
+		help
+		  Do not present LSM information in /proc/*/attr
 
 endchoice
 
-config DEFAULT_SECURITY
+config PRESENT_SECURITY
 	string
-	default "selinux" if DEFAULT_SECURITY_SELINUX
-	default "smack" if DEFAULT_SECURITY_SMACK
-	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
-	default "apparmor" if DEFAULT_SECURITY_APPARMOR
-	default "yama" if DEFAULT_SECURITY_YAMA
-	default "" if DEFAULT_SECURITY_DAC
+	default "selinux" if PRESENT_SECURITY_SELINUX
+	default "smack" if PRESENT_SECURITY_SMACK
+	default "apparmor" if PRESENT_SECURITY_APPARMOR
+	default "FIRSTLSM" if PRESENT_SECURITY_FIRST
+	default "NOTHING"
 
 endmenu
-
diff --git a/security/inode.c b/security/inode.c
index 43ce6e1..1ca6aaf 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -21,6 +21,9 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/magic.h>
+#ifdef CONFIG_SECURITY
+#include <linux/lsm.h>
+#endif
 
 static struct vfsmount *mount;
 static int mount_count;
@@ -215,6 +218,70 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+#ifdef CONFIG_SECURITY
+static struct dentry *lsm_dentry;
+static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	struct security_operations *sop;
+	char *data;
+	int len;
+
+	data = kzalloc(COMPOSER_NAMES_MAX + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	list_for_each_entry(sop, &lsm_hooks[lsm_name], list[lsm_name]) {
+		strcat(data, sop->name);
+		strcat(data, ",");
+	}
+	len = strlen(data);
+	if (len > 1)
+		data[len-1] = '\n';
+
+	len = simple_read_from_buffer(buf, count, ppos, data, len);
+	kfree(data);
+
+	return len;
+}
+
+static const struct file_operations lsm_ops = {
+	.read = lsm_read,
+	.llseek = generic_file_llseek,
+};
+
+static struct dentry *present_dentry;
+static ssize_t present_read(struct file *filp, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	struct security_operations *sop = lsm_present;
+	char *raw;
+	char *data;
+	int len;
+
+	if (sop)
+		raw = sop->name;
+	else
+		raw = "(none)";
+	len = strlen(raw);
+
+	data = kstrdup(raw, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data[len] = '\n';
+	len = simple_read_from_buffer(buf, count, ppos, data, len + 1);
+	kfree(data);
+
+	return len;
+}
+
+static const struct file_operations present_ops = {
+	.read = present_read,
+	.llseek = generic_file_llseek,
+};
+#endif /* CONFIG_SECURITY */
+
 static struct kobject *security_kobj;
 
 static int __init securityfs_init(void)
@@ -226,9 +293,17 @@ static int __init securityfs_init(void)
 		return -EINVAL;
 
 	retval = register_filesystem(&fs_type);
-	if (retval)
+	if (retval) {
 		kobject_put(security_kobj);
-	return retval;
+		return retval;
+	}
+#ifdef CONFIG_SECURITY
+	lsm_dentry = securityfs_create_file("lsm", S_IRUGO, NULL, NULL,
+		&lsm_ops);
+	present_dentry = securityfs_create_file("present", S_IRUGO, NULL, NULL,
+		&present_ops);
+#endif /* CONFIG_SECURITY */
+	return 0;
 }
 
 core_initcall(securityfs_init);

