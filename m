Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3AHCSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:18:22 -0500
Received: from nm11-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.124]:24200
	"EHLO nm11-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab3AHCJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:04 -0500
X-Yahoo-Newman-Id: 468761.31857.bm@smtp107.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fIZX5YYVM1nHZcdGLn1Apaed1BLYcUYJReXncYxkz9jVUFd
 ZPfJvtncjZCKGCiaw4euItzbRY11_2esJlo0_7ZZA93bp06hzwxXsZeTZv2k
 0KgeeB5RmE4ITM.uomMfgcwE3xxKlmqc39cAL_e99PHZMTmgCySrdmGFJuEZ
 r4SgS29w5_V5H4CTIKYpwMW.pkeW.tCzAZN3S.Ln_os_Ybr2ZLxL7XdPy7cg
 43sF8JX5eefqsdP7SglVK2lcrnqkn6fjulalBaJwmGgugIwjOaAc0s1dyWv2
 xOrmaU4RkgVWLbi1a5Uz3aVjd5YQi4oaeFmlSbRaWWdalSkYpTSQSugxJfZ8
 4sCYLNOvtnUyhfSIxhdclleXJ.PO8dATEND.03KtzQ9Frs3SiKP78b2NE3JW
 58EkUJo_apIiW3daBi11qd4psBEivlDBPSXzaaVqA0ek2JB9yZdq.zVFqyux
 OqTfE
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FCD.3030107@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:17 -0800
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
Subject: [PATCH v12 3/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 3/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Handle any preconditions in the hooks directly.
Treat allocation and procattr hooks specially.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/security.c | 1496 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 1191 insertions(+), 305 deletions(-)

diff --git a/security/security.c b/security/security.c
index daa97f4..72bf9dc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -25,30 +25,287 @@
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
 #include <net/flow.h>
+#include <linux/lsm.h>
+#include <linux/shm.h>
+#include <linux/string.h>
 
 #define MAX_LSM_EVM_XATTR	2
+#define PRESENT_FIRST		"FIRSTLSM"
 
 /* Boot-time LSM user choice */
-static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
-	CONFIG_DEFAULT_SECURITY;
 
-static struct security_operations *security_ops;
-static struct security_operations default_security_ops = {
-	.name	= "default",
-};
+static __initdata char specified_lsms[COMPOSER_MAX][SECURITY_NAME_MAX + 1];
+static __initdata char allowed_lsms[COMPOSER_NAMES_MAX];
+static __initdata char present_lsm[SECURITY_NAME_MAX + 1] =
+	CONFIG_PRESENT_SECURITY;
 
-static inline int __init verify(struct security_operations *ops)
+struct list_head lsm_hooks[LSM_MAX_HOOKS];
+struct security_operations *lsm_present;
+
+static int (*present_getprocattr)
+		(struct task_struct *p, char *name, char **value);
+static int (*present_setprocattr)
+		(struct task_struct *p, char *name, void *value, size_t size);
+
+static int lsm_count;
+
+#define for_each_hook(SOP, HOOK) \
+	list_for_each_entry(SOP, &lsm_hooks[lsm_##HOOK], list[lsm_##HOOK])
+
+/*
+ * Add an entry to a list of security operation vectors.
+ * The "interesting" logic is included here rather than in the
+ * caller to reduce the volume of the calling code.
+ */
+static void __init lsm_enlist(struct security_operations *ops,
+				const enum lsm_hooks_index index,
+				void *interesting)
 {
-	/* verify the security_operations structure exists */
-	if (!ops)
-		return -EINVAL;
-	security_fixup_ops(ops);
-	return 0;
+	struct security_operations *sop;
+
+	if (!interesting) {
+		INIT_LIST_HEAD(&ops->list[index]);
+		return;
+	}
+
+	if (list_empty(&lsm_hooks[index])) {
+		list_add_rcu(&ops->list[index], &lsm_hooks[index]);
+		return;
+	}
+
+	list_for_each_entry(sop, &lsm_hooks[index], list[index]) {
+		if (ops->order < sop->order) {
+			list_add_tail_rcu(&ops->list[index], &sop->list[index]);
+			return;
+		}
+		if (list_is_last(&sop->list[index], &lsm_hooks[index])) {
+			list_add_rcu(&ops->list[index], &sop->list[index]);
+			return;
+		}
+	}
+}
+
+static void __init lsm_enlist_ops(struct security_operations *sop)
+{
+	lsm_enlist(sop, lsm_ptrace_access_check, sop->ptrace_access_check);
+	lsm_enlist(sop, lsm_ptrace_traceme, sop->ptrace_traceme);
+	lsm_enlist(sop, lsm_capget, sop->capget);
+	lsm_enlist(sop, lsm_capset, sop->capset);
+	lsm_enlist(sop, lsm_capable, sop->capable);
+	lsm_enlist(sop, lsm_quotactl, sop->quotactl);
+	lsm_enlist(sop, lsm_quota_on, sop->quota_on);
+	lsm_enlist(sop, lsm_syslog, sop->syslog);
+	lsm_enlist(sop, lsm_settime, sop->settime);
+	lsm_enlist(sop, lsm_vm_enough_memory, sop->vm_enough_memory);
+	lsm_enlist(sop, lsm_bprm_set_creds, sop->bprm_set_creds);
+	lsm_enlist(sop, lsm_bprm_check_security, sop->bprm_check_security);
+	lsm_enlist(sop, lsm_bprm_committing_creds, sop->bprm_committing_creds);
+	lsm_enlist(sop, lsm_bprm_committed_creds, sop->bprm_committed_creds);
+	lsm_enlist(sop, lsm_bprm_secureexec, sop->bprm_secureexec);
+	lsm_enlist(sop, lsm_sb_alloc_security, sop->sb_alloc_security);
+	lsm_enlist(sop, lsm_sb_free_security, sop->sb_free_security);
+	lsm_enlist(sop, lsm_sb_copy_data, sop->sb_copy_data);
+	lsm_enlist(sop, lsm_sb_remount, sop->sb_remount);
+	lsm_enlist(sop, lsm_sb_kern_mount, sop->sb_kern_mount);
+	lsm_enlist(sop, lsm_sb_show_options, sop->sb_show_options);
+	lsm_enlist(sop, lsm_sb_statfs, sop->sb_statfs);
+	lsm_enlist(sop, lsm_sb_mount, sop->sb_mount);
+	lsm_enlist(sop, lsm_sb_umount, sop->sb_umount);
+	lsm_enlist(sop, lsm_sb_pivotroot, sop->sb_pivotroot);
+	lsm_enlist(sop, lsm_sb_set_mnt_opts, sop->sb_set_mnt_opts);
+	lsm_enlist(sop, lsm_sb_clone_mnt_opts, sop->sb_clone_mnt_opts);
+	lsm_enlist(sop, lsm_sb_parse_opts_str, sop->sb_parse_opts_str);
+	lsm_enlist(sop, lsm_inode_alloc_security, sop->inode_alloc_security);
+	lsm_enlist(sop, lsm_inode_free_security, sop->inode_free_security);
+	lsm_enlist(sop, lsm_inode_init_security, sop->inode_init_security);
+#ifdef CONFIG_SECURITY_PATH
+	lsm_enlist(sop, lsm_path_mknod, sop->path_mknod);
+	lsm_enlist(sop, lsm_path_mkdir, sop->path_mkdir);
+	lsm_enlist(sop, lsm_path_rmdir, sop->path_rmdir);
+	lsm_enlist(sop, lsm_path_unlink, sop->path_unlink);
+	lsm_enlist(sop, lsm_path_symlink, sop->path_symlink);
+	lsm_enlist(sop, lsm_path_link, sop->path_link);
+	lsm_enlist(sop, lsm_path_rename, sop->path_rename);
+	lsm_enlist(sop, lsm_path_truncate, sop->path_truncate);
+	lsm_enlist(sop, lsm_path_chmod, sop->path_chmod);
+	lsm_enlist(sop, lsm_path_chown, sop->path_chown);
+	lsm_enlist(sop, lsm_path_chroot, sop->path_chroot);
+#endif
+	lsm_enlist(sop, lsm_inode_create, sop->inode_create);
+	lsm_enlist(sop, lsm_inode_link, sop->inode_link);
+	lsm_enlist(sop, lsm_inode_unlink, sop->inode_unlink);
+	lsm_enlist(sop, lsm_inode_symlink, sop->inode_symlink);
+	lsm_enlist(sop, lsm_inode_mkdir, sop->inode_mkdir);
+	lsm_enlist(sop, lsm_inode_rmdir, sop->inode_rmdir);
+	lsm_enlist(sop, lsm_inode_mknod, sop->inode_mknod);
+	lsm_enlist(sop, lsm_inode_rename, sop->inode_rename);
+	lsm_enlist(sop, lsm_inode_readlink, sop->inode_readlink);
+	lsm_enlist(sop, lsm_inode_follow_link, sop->inode_follow_link);
+	lsm_enlist(sop, lsm_inode_permission, sop->inode_permission);
+	lsm_enlist(sop, lsm_inode_setattr, sop->inode_setattr);
+	lsm_enlist(sop, lsm_inode_getattr, sop->inode_getattr);
+	lsm_enlist(sop, lsm_inode_setxattr, sop->inode_setxattr);
+	lsm_enlist(sop, lsm_inode_post_setxattr, sop->inode_post_setxattr);
+	lsm_enlist(sop, lsm_inode_getxattr, sop->inode_getxattr);
+	lsm_enlist(sop, lsm_inode_listxattr, sop->inode_listxattr);
+	lsm_enlist(sop, lsm_inode_removexattr, sop->inode_removexattr);
+	lsm_enlist(sop, lsm_inode_need_killpriv, sop->inode_need_killpriv);
+	lsm_enlist(sop, lsm_inode_killpriv, sop->inode_killpriv);
+	lsm_enlist(sop, lsm_inode_getsecurity, sop->inode_getsecurity);
+	lsm_enlist(sop, lsm_inode_setsecurity, sop->inode_setsecurity);
+	lsm_enlist(sop, lsm_inode_listsecurity, sop->inode_listsecurity);
+	lsm_enlist(sop, lsm_inode_getsecid, sop->inode_getsecid);
+	lsm_enlist(sop, lsm_file_permission, sop->file_permission);
+	lsm_enlist(sop, lsm_file_alloc_security, sop->file_alloc_security);
+	lsm_enlist(sop, lsm_file_free_security, sop->file_free_security);
+	lsm_enlist(sop, lsm_file_ioctl, sop->file_ioctl);
+	lsm_enlist(sop, lsm_mmap_file, sop->mmap_file);
+	lsm_enlist(sop, lsm_mmap_addr, sop->mmap_addr);
+	lsm_enlist(sop, lsm_file_mprotect, sop->file_mprotect);
+	lsm_enlist(sop, lsm_file_lock, sop->file_lock);
+	lsm_enlist(sop, lsm_file_fcntl, sop->file_fcntl);
+	lsm_enlist(sop, lsm_file_set_fowner, sop->file_set_fowner);
+	lsm_enlist(sop, lsm_file_send_sigiotask, sop->file_send_sigiotask);
+	lsm_enlist(sop, lsm_file_receive, sop->file_receive);
+	lsm_enlist(sop, lsm_file_open, sop->file_open);
+	lsm_enlist(sop, lsm_task_create, sop->task_create);
+	lsm_enlist(sop, lsm_task_free, sop->task_free);
+	lsm_enlist(sop, lsm_cred_alloc_blank, sop->cred_alloc_blank);
+	lsm_enlist(sop, lsm_cred_free, sop->cred_free);
+	lsm_enlist(sop, lsm_cred_prepare, sop->cred_prepare);
+	lsm_enlist(sop, lsm_cred_transfer, sop->cred_transfer);
+	lsm_enlist(sop, lsm_kernel_act_as, sop->kernel_act_as);
+	lsm_enlist(sop, lsm_kernel_create_files_as,
+			sop->kernel_create_files_as);
+	lsm_enlist(sop, lsm_kernel_module_request, sop->kernel_module_request);
+	lsm_enlist(sop, lsm_kernel_module_from_file,
+			sop->kernel_module_from_file);
+	lsm_enlist(sop, lsm_task_fix_setuid, sop->task_fix_setuid);
+	lsm_enlist(sop, lsm_task_setpgid, sop->task_setpgid);
+	lsm_enlist(sop, lsm_task_getpgid, sop->task_getpgid);
+	lsm_enlist(sop, lsm_task_getsid, sop->task_getsid);
+	lsm_enlist(sop, lsm_task_getsecid, sop->task_getsecid);
+	lsm_enlist(sop, lsm_task_setnice, sop->task_setnice);
+	lsm_enlist(sop, lsm_task_setioprio, sop->task_setioprio);
+	lsm_enlist(sop, lsm_task_getioprio, sop->task_getioprio);
+	lsm_enlist(sop, lsm_task_setrlimit, sop->task_setrlimit);
+	lsm_enlist(sop, lsm_task_setscheduler, sop->task_setscheduler);
+	lsm_enlist(sop, lsm_task_getscheduler, sop->task_getscheduler);
+	lsm_enlist(sop, lsm_task_movememory, sop->task_movememory);
+	lsm_enlist(sop, lsm_task_kill, sop->task_kill);
+	lsm_enlist(sop, lsm_task_wait, sop->task_wait);
+	lsm_enlist(sop, lsm_task_prctl, sop->task_prctl);
+	lsm_enlist(sop, lsm_task_to_inode, sop->task_to_inode);
+	lsm_enlist(sop, lsm_ipc_permission, sop->ipc_permission);
+	lsm_enlist(sop, lsm_ipc_getsecid, sop->ipc_getsecid);
+	lsm_enlist(sop, lsm_msg_msg_alloc_security,
+			sop->msg_msg_alloc_security);
+	lsm_enlist(sop, lsm_msg_msg_free_security, sop->msg_msg_free_security);
+	lsm_enlist(sop, lsm_msg_queue_alloc_security,
+			sop->msg_queue_alloc_security);
+	lsm_enlist(sop, lsm_msg_queue_free_security,
+			sop->msg_queue_free_security);
+	lsm_enlist(sop, lsm_msg_queue_associate, sop->msg_queue_associate);
+	lsm_enlist(sop, lsm_msg_queue_msgctl, sop->msg_queue_msgctl);
+	lsm_enlist(sop, lsm_msg_queue_msgsnd, sop->msg_queue_msgsnd);
+	lsm_enlist(sop, lsm_msg_queue_msgrcv, sop->msg_queue_msgrcv);
+	lsm_enlist(sop, lsm_shm_alloc_security, sop->shm_alloc_security);
+	lsm_enlist(sop, lsm_shm_free_security, sop->shm_free_security);
+	lsm_enlist(sop, lsm_shm_associate, sop->shm_associate);
+	lsm_enlist(sop, lsm_shm_shmctl, sop->shm_shmctl);
+	lsm_enlist(sop, lsm_shm_shmat, sop->shm_shmat);
+	lsm_enlist(sop, lsm_sem_alloc_security, sop->sem_alloc_security);
+	lsm_enlist(sop, lsm_sem_free_security, sop->sem_free_security);
+	lsm_enlist(sop, lsm_sem_associate, sop->sem_associate);
+	lsm_enlist(sop, lsm_sem_semctl, sop->sem_semctl);
+	lsm_enlist(sop, lsm_sem_semop, sop->sem_semop);
+	lsm_enlist(sop, lsm_d_instantiate, sop->d_instantiate);
+	lsm_enlist(sop, lsm_getprocattr, sop->getprocattr);
+	lsm_enlist(sop, lsm_setprocattr, sop->setprocattr);
+	lsm_enlist(sop, lsm_netlink_send, sop->netlink_send);
+	lsm_enlist(sop, lsm_secid_to_secctx, sop->secid_to_secctx);
+	lsm_enlist(sop, lsm_secctx_to_secid, sop->secctx_to_secid);
+	lsm_enlist(sop, lsm_release_secctx, sop->release_secctx);
+	lsm_enlist(sop, lsm_inode_notifysecctx, sop->inode_notifysecctx);
+	lsm_enlist(sop, lsm_inode_setsecctx, sop->inode_setsecctx);
+	lsm_enlist(sop, lsm_inode_getsecctx, sop->inode_getsecctx);
+#ifdef CONFIG_SECURITY_NETWORK
+	lsm_enlist(sop, lsm_unix_stream_connect, sop->unix_stream_connect);
+	lsm_enlist(sop, lsm_unix_may_send, sop->unix_may_send);
+	lsm_enlist(sop, lsm_socket_create, sop->socket_create);
+	lsm_enlist(sop, lsm_socket_post_create, sop->socket_post_create);
+	lsm_enlist(sop, lsm_socket_bind, sop->socket_bind);
+	lsm_enlist(sop, lsm_socket_connect, sop->socket_connect);
+	lsm_enlist(sop, lsm_socket_listen, sop->socket_listen);
+	lsm_enlist(sop, lsm_socket_accept, sop->socket_accept);
+	lsm_enlist(sop, lsm_socket_sendmsg, sop->socket_sendmsg);
+	lsm_enlist(sop, lsm_socket_recvmsg, sop->socket_recvmsg);
+	lsm_enlist(sop, lsm_socket_getsockname, sop->socket_getsockname);
+	lsm_enlist(sop, lsm_socket_getpeername, sop->socket_getpeername);
+	lsm_enlist(sop, lsm_socket_getsockopt, sop->socket_getsockopt);
+	lsm_enlist(sop, lsm_socket_setsockopt, sop->socket_setsockopt);
+	lsm_enlist(sop, lsm_socket_shutdown, sop->socket_shutdown);
+	lsm_enlist(sop, lsm_socket_sock_rcv_skb, sop->socket_sock_rcv_skb);
+	lsm_enlist(sop, lsm_socket_getpeersec_stream,
+			sop->socket_getpeersec_stream);
+	lsm_enlist(sop, lsm_socket_getpeersec_dgram,
+			sop->socket_getpeersec_dgram);
+	lsm_enlist(sop, lsm_sk_alloc_security, sop->sk_alloc_security);
+	lsm_enlist(sop, lsm_sk_free_security, sop->sk_free_security);
+	lsm_enlist(sop, lsm_sk_clone_security, sop->sk_clone_security);
+	lsm_enlist(sop, lsm_req_classify_flow, sop->req_classify_flow);
+	lsm_enlist(sop, lsm_sock_graft, sop->sock_graft);
+	lsm_enlist(sop, lsm_inet_conn_request, sop->inet_conn_request);
+	lsm_enlist(sop, lsm_inet_csk_clone, sop->inet_csk_clone);
+	lsm_enlist(sop, lsm_inet_conn_established, sop->inet_conn_established);
+	lsm_enlist(sop, lsm_secmark_relabel_packet,
+			sop->secmark_relabel_packet);
+	lsm_enlist(sop, lsm_secmark_refcount_inc, sop->secmark_refcount_inc);
+	lsm_enlist(sop, lsm_secmark_refcount_dec, sop->secmark_refcount_dec);
+	lsm_enlist(sop, lsm_tun_dev_create, sop->tun_dev_create);
+	lsm_enlist(sop, lsm_tun_dev_post_create, sop->tun_dev_post_create);
+	lsm_enlist(sop, lsm_tun_dev_attach, sop->tun_dev_attach);
+#endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	lsm_enlist(sop, lsm_xfrm_policy_alloc_security,
+			sop->xfrm_policy_alloc_security);
+	lsm_enlist(sop, lsm_xfrm_policy_clone_security,
+			sop->xfrm_policy_clone_security);
+	lsm_enlist(sop, lsm_xfrm_policy_free_security,
+			sop->xfrm_policy_free_security);
+	lsm_enlist(sop, lsm_xfrm_policy_delete_security,
+			sop->xfrm_policy_delete_security);
+	lsm_enlist(sop, lsm_xfrm_state_alloc_security,
+			sop->xfrm_state_alloc_security);
+	lsm_enlist(sop, lsm_xfrm_state_delete_security,
+			sop->xfrm_state_delete_security);
+	lsm_enlist(sop, lsm_xfrm_state_free_security,
+			sop->xfrm_state_free_security);
+	lsm_enlist(sop, lsm_xfrm_policy_lookup, sop->xfrm_policy_lookup);
+	lsm_enlist(sop, lsm_xfrm_state_pol_flow_match,
+			sop->xfrm_state_pol_flow_match);
+	lsm_enlist(sop, lsm_xfrm_decode_session, sop->xfrm_decode_session);
+#endif
+#ifdef CONFIG_KEYS
+	lsm_enlist(sop, lsm_key_alloc, sop->key_alloc);
+	lsm_enlist(sop, lsm_key_free, sop->key_free);
+	lsm_enlist(sop, lsm_key_permission, sop->key_permission);
+	lsm_enlist(sop, lsm_key_getsecurity, sop->key_getsecurity);
+#endif
+#ifdef CONFIG_AUDIT
+	lsm_enlist(sop, lsm_audit_rule_init, sop->audit_rule_init);
+	lsm_enlist(sop, lsm_audit_rule_known, sop->audit_rule_known);
+	lsm_enlist(sop, lsm_audit_rule_free, sop->audit_rule_free);
+	lsm_enlist(sop, lsm_audit_rule_match, sop->audit_rule_match);
+#endif
+
+	lsm_enlist(sop, lsm_name, sop->name);
 }
 
 static void __init do_security_initcalls(void)
 {
 	initcall_t *call;
+
 	call = __security_initcall_start;
 	while (call < __security_initcall_end) {
 		(*call) ();
@@ -63,24 +320,71 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
-	printk(KERN_INFO "Security Framework initialized\n");
+	enum lsm_hooks_index i;
+
+	for (i = 0; i < LSM_MAX_HOOKS; i++)
+		INIT_LIST_HEAD(&lsm_hooks[i]);
+
+	pr_info("Security Framework initialized\n");
 
-	security_fixup_ops(&default_security_ops);
-	security_ops = &default_security_ops;
 	do_security_initcalls();
 
 	return 0;
 }
 
-void reset_security_ops(void)
+/*
+ * Only SELinux calls reset_security_ops.
+ */
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+
+static void lsm_delist_ops(struct security_operations *sop)
 {
-	security_ops = &default_security_ops;
+	enum lsm_hooks_index i;
+
+	for (i = 0; i < LSM_MAX_HOOKS; i++)
+		if (sop->list[i].next && !list_empty(&sop->list[i]))
+			list_del_rcu(&sop->list[i]);
+	return;
 }
 
-/* Save user chosen LSM */
+int reset_security_ops(struct security_operations *ops)
+{
+	/*
+	 * This LSM is configured to own /proc/.../attr.
+	 */
+	if (lsm_present == ops)
+		lsm_present = NULL;
+
+	lsm_delist_ops(ops);
+
+	return 0;
+}
+
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
+
+/* Save user chosen LSM(s) */
 static int __init choose_lsm(char *str)
 {
-	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
+	char *cp;
+	char *ep;
+	int i;
+
+	strncpy(allowed_lsms, str, COMPOSER_NAMES_MAX);
+	cp = allowed_lsms;
+
+	for (i = 0; i < COMPOSER_MAX; i++) {
+		ep = strchr(cp, ',');
+		if (ep != NULL)
+			*ep = '\0';
+		if (strlen(cp) > SECURITY_NAME_MAX)
+			pr_warn("LSM \"%s\" is invalid and ignored.\n", cp);
+		else
+			strncpy(specified_lsms[i], cp, SECURITY_NAME_MAX);
+		if (ep == NULL)
+			break;
+		cp = ep + 1;
+	}
+
 	return 1;
 }
 __setup("security=", choose_lsm);
@@ -94,74 +398,303 @@ __setup("security=", choose_lsm);
  * to check if your LSM is currently loaded during kernel initialization.
  *
  * Return true if:
- *	-The passed LSM is the one chosen by user at boot time,
- *	-or the passed LSM is configured as the default and the user did not
- *	 choose an alternate LSM at boot time.
+ *	-The passed LSM is on the list of LSMs specified at boot time,
+ *	-or no boot list was specified.
  * Otherwise, return false.
  */
 int __init security_module_enable(struct security_operations *ops)
 {
-	return !strcmp(ops->name, chosen_lsm);
-}
+	struct security_operations *sop;
+	int i;
 
-/**
- * register_security - registers a security framework with the kernel
- * @ops: a pointer to the struct security_options that is to be registered
- *
- * This function allows a security module to register itself with the
- * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function. You'll need to check first if your LSM
- * is allowed to register its @ops by calling security_module_enable(@ops).
- *
- * If there is already a security module registered with the kernel,
- * an error will be returned.  Otherwise %0 is returned on success.
- */
-int __init register_security(struct security_operations *ops)
-{
-	if (verify(ops)) {
-		printk(KERN_DEBUG "%s could not verify "
-		       "security_operations structure.\n", __func__);
-		return -EINVAL;
+	/*
+	 * Set up the operation vector early, but only once.
+	 * This allows LSM specific file systems to check to see if they
+	 * should come on line.
+	 */
+	if (ops == NULL) {
+		pr_debug("%s could not verify security_operations.\n",
+				__func__);
+		return 0;
 	}
+	/*
+	 * Return success if the LSM is already resistered
+	 */
+	for_each_hook(sop, name)
+		if (sop == ops)
+			return 1;
 
-	if (security_ops != &default_security_ops)
-		return -EAGAIN;
+	/*
+	 * This LSM has not yet been ordered.
+	 */
+	ops->order = -1;
 
-	security_ops = ops;
+	if (lsm_count >= COMPOSER_MAX) {
+		pr_warn("Too many security modules. %s not loaded.\n",
+				ops->name);
+		return 0;
+	}
 
-	return 0;
+	if (specified_lsms[0][0] != '\0') {
+		for (i = 0; specified_lsms[i][0] != '\0'; i++) {
+			if (strcmp(ops->name, specified_lsms[i]) == 0) {
+				ops->order = i;
+				break;
+			}
+		}
+		if (ops->order == -1) {
+			pr_notice("LSM %s declined by boot options.\n",
+					ops->name);
+			return 0;
+		}
+	}
+	/*
+	 * Check for conflicting LSMs.
+	 */
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	if (ops->xfrm_policy_alloc_security &&
+	    !list_empty(&lsm_hooks[lsm_xfrm_policy_alloc_security])) {
+		pr_warn("LSM conflict on %s. %s not loaded.\n",
+				"xfrm_policy_alloc_security", ops->name);
+		return 0;
+	}
+#endif
+	if (ops->secid_to_secctx &&
+	    !list_empty(&lsm_hooks[lsm_secid_to_secctx])) {
+		pr_warn("LSM conflict on %s. %s not loaded.\n",
+			"secid_to_secctx", ops->name);
+		return 0;
+	}
+
+	/*
+	 * The order will already be set if the command line
+	 * includes "security=".
+	 *
+	 * Do this before the enlisting. If there is an error
+	 * (Very unlikely!) that prevents the enlisting from
+	 * completing it is still necessary to have a blob slot
+	 * for it.
+	 */
+	if (ops->order == -1)
+		ops->order = lsm_count;
+	lsm_count++;
+
+	/*
+	 * Use the LSM specified by CONFIG_SECURITY_PRESENT for
+	 * [gs]etprocattr. If the LSM specified is PRESENT_FIRST
+	 * use the first LSM to register that has the hooks.
+	 * If the specified LSM lacks the hooks treat it as if
+	 * there is no LSM registered that supplied them.
+	 */
+	if (ops->getprocattr && ops->setprocattr &&
+	    (!strcmp(ops->name, present_lsm) ||
+	     (!lsm_present && !strcmp(PRESENT_FIRST, present_lsm)))) {
+		lsm_present = ops;
+		present_getprocattr = ops->getprocattr;
+		present_setprocattr = ops->setprocattr;
+		pr_info("Security Module %s is presented in /proc.\n",
+			ops->name);
+	}
+	/*
+	 * Return success after registering the LSM.
+	 */
+	lsm_enlist_ops(ops);
+
+	return 1;
 }
 
 /* Security operations */
 
+/*
+ * Because so many of the cases are treated the same it
+ * cleans things up to use these macros instead of having
+ * duplicate text all over the place.
+ *
+ * call_void_hook:
+ *	This is a hook that does not return a value.
+ *
+ * call_int_hook:
+ *	This is hook that returns a value. Return the last
+ *	non-zero return.
+ *
+ * call_int_must:
+ *	Returns 1 if any LSMs actually had hooks and one
+ *	or more got called. The return value goes into RC.
+ *
+ * call_int_cap_first:
+ *	Like cap_int_hook, but call the cap_hook first and
+ *	bail on fail.
+ *
+ * call_int_cap_last:
+ *	Like cap_int_cap_first, but call the cap_hook last.
+ *
+ * call_alloc_hook:
+ *	Allocate not only the LSM security blobs, but a blob
+ *	to hold pointers to all of them as well.
+ *
+ */
+#define call_void_hook(FUNC, ...)					\
+	do {								\
+		struct security_operations *sop;			\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC])		\
+			sop->FUNC(__VA_ARGS__);				\
+	} while (0)							\
+
+#define call_int_hook(FUNC, ...) ({					\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+	} while (0);							\
+	rc;								\
+})
+
+#define call_int_must(RC, FUNC, ...) ({					\
+	int called = 0;							\
+	RC = 0;								\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				RC = thisrc;				\
+			called = 1;					\
+		}							\
+	} while (0);							\
+	called;								\
+})
+
+#define call_int_cap_first(FUNC, ...) ({				\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		thisrc = cap_##FUNC(__VA_ARGS__);			\
+		if (thisrc) {						\
+			rc = thisrc;					\
+			break;						\
+		}							\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+	} while (0);							\
+	rc;								\
+})
+
+#define call_int_cap_last(FUNC, ...) ({					\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+									\
+		if (!rc)						\
+			rc = cap_##FUNC(__VA_ARGS__);			\
+	} while (0);							\
+	rc;								\
+})
+
+
+#define call_alloc_hook(ALLOC, FREE, FIELD, GFP, ARG) ({		\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		struct security_operations *note[COMPOSER_MAX];		\
+		struct lsm_blob tblob;					\
+		struct lsm_blob *bp = NULL;				\
+		int successes = 0;					\
+									\
+		memset(&tblob, 0, sizeof(tblob));			\
+		FIELD = &tblob;						\
+		for_each_hook(sop, ALLOC) {				\
+			rc = sop->ALLOC(ARG);				\
+			if (rc)						\
+				break;					\
+			note[successes++] = sop;			\
+		}							\
+		if (tblob.lsm_setcount != 0) {				\
+			if (rc == 0)					\
+				bp = kmemdup(&tblob, sizeof(tblob), GFP); \
+			if (bp == NULL) {				\
+				if (rc == 0)				\
+					rc = -ENOMEM;			\
+				while (successes > 0)			\
+					note[--successes]->FREE(ARG);	\
+			}						\
+		}							\
+		FIELD = bp;						\
+	} while (0);							\
+	rc;								\
+})
+
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_ptrace_access_check(child, mode);
-	if (rc)
-		return rc;
-#endif
-	return security_ops->ptrace_access_check(child, mode);
+	return call_int_cap_first(ptrace_access_check, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_ptrace_traceme(parent);
-	if (rc)
-		return rc;
-#endif
-	return security_ops->ptrace_traceme(parent);
+	return call_int_cap_first(ptrace_traceme, parent);
 }
 
+/*
+ * Odd duck hook handling.
+ * This hook returns the set of capabilities available to
+ * the "target" task. Apparmor restricts the capabilities
+ * based on profile and SELinux may deny the ability to
+ * look and see what they are. cap_capget never fails.
+ */
 int security_capget(struct task_struct *target,
 		     kernel_cap_t *effective,
 		     kernel_cap_t *inheritable,
 		     kernel_cap_t *permitted)
 {
-	return security_ops->capget(target, effective, inheritable, permitted);
+	struct security_operations *sop;
+	kernel_cap_t cap[3];
+	kernel_cap_t this[3];
+	int rc;
+	int i;
+
+	rc = cap_capget(target, &cap[0], &cap[1], &cap[2]);
+	if (rc != 0)
+		return rc;
+
+	for_each_hook(sop, capget) {
+		rc = sop->capget(target, &this[0], &this[1], &this[2]);
+		if (rc != 0)
+			return rc;
+		for (i = 0; i < 3; i++)
+			cap[i] = cap_intersect(cap[i], this[i]);
+	}
+
+	*effective = cap[0];
+	*inheritable = cap[1];
+	*permitted = cap[2];
+
+	return 0;
 }
 
 int security_capset(struct cred *new, const struct cred *old,
@@ -169,195 +702,214 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted)
 {
-	return security_ops->capset(new, old,
-				    effective, inheritable, permitted);
+	return call_int_cap_first(capset, new, old, effective,
+				  inheritable, permitted);
 }
 
 int security_capable(const struct cred *cred, struct user_namespace *ns,
 		     int cap)
 {
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_AUDIT);
+	return call_int_cap_first(capable, cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
 int security_capable_noaudit(const struct cred *cred, struct user_namespace *ns,
 			     int cap)
 {
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_NOAUDIT);
+	return call_int_cap_first(capable, cred, ns, cap, SECURITY_CAP_NOAUDIT);
 }
 
 int security_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
-	return security_ops->quotactl(cmds, type, id, sb);
+	return call_int_hook(quotactl, cmds, type, id, sb);
 }
 
 int security_quota_on(struct dentry *dentry)
 {
-	return security_ops->quota_on(dentry);
+	return call_int_hook(quota_on, dentry);
 }
 
 int security_syslog(int type)
 {
-	return security_ops->syslog(type);
+	return call_int_hook(syslog, type);
 }
 
 int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
-	return security_ops->settime(ts, tz);
+	return call_int_cap_first(settime, ts, tz);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
-	return security_ops->vm_enough_memory(mm, pages);
+	return call_int_cap_first(vm_enough_memory, mm, pages);
 }
 
 int security_bprm_set_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_set_creds(bprm);
+	return call_int_cap_first(bprm_set_creds, bprm);
 }
 
 int security_bprm_check(struct linux_binprm *bprm)
 {
-	int ret;
+	int rc = call_int_hook(bprm_check_security, bprm);
+
+	if (rc)
+		return rc;
 
-	ret = security_ops->bprm_check_security(bprm);
-	if (ret)
-		return ret;
 	return ima_bprm_check(bprm);
 }
 
+
 void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	security_ops->bprm_committing_creds(bprm);
+	call_void_hook(bprm_committing_creds, bprm);
 }
 
 void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	security_ops->bprm_committed_creds(bprm);
+	call_void_hook(bprm_committed_creds, bprm);
 }
 
 int security_bprm_secureexec(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_secureexec(bprm);
+	return call_int_cap_last(bprm_secureexec, bprm);
 }
 
 int security_sb_alloc(struct super_block *sb)
 {
-	return security_ops->sb_alloc_security(sb);
+	return call_alloc_hook(sb_alloc_security, sb_free_security,
+			sb->s_security, GFP_KERNEL, sb);
 }
 
 void security_sb_free(struct super_block *sb)
 {
-	security_ops->sb_free_security(sb);
+	call_void_hook(sb_free_security, sb);
+
+	kfree(sb->s_security);
+	sb->s_security = NULL;
 }
 
 int security_sb_copy_data(char *orig, char *copy)
 {
-	return security_ops->sb_copy_data(orig, copy);
+	return call_int_hook(sb_copy_data, orig, copy);
 }
 EXPORT_SYMBOL(security_sb_copy_data);
 
 int security_sb_remount(struct super_block *sb, void *data)
 {
-	return security_ops->sb_remount(sb, data);
+	return call_int_hook(sb_remount, sb, data);
 }
 
 int security_sb_kern_mount(struct super_block *sb, int flags, void *data)
 {
-	return security_ops->sb_kern_mount(sb, flags, data);
+	return call_int_hook(sb_kern_mount, sb, flags, data);
 }
 
 int security_sb_show_options(struct seq_file *m, struct super_block *sb)
 {
-	return security_ops->sb_show_options(m, sb);
+	return call_int_hook(sb_show_options, m, sb);
 }
 
 int security_sb_statfs(struct dentry *dentry)
 {
-	return security_ops->sb_statfs(dentry);
+	return call_int_hook(sb_statfs, dentry);
 }
 
 int security_sb_mount(const char *dev_name, struct path *path,
                        const char *type, unsigned long flags, void *data)
 {
-	return security_ops->sb_mount(dev_name, path, type, flags, data);
+	return call_int_hook(sb_mount, dev_name, path, type, flags, data);
 }
 
 int security_sb_umount(struct vfsmount *mnt, int flags)
 {
-	return security_ops->sb_umount(mnt, flags);
+	return call_int_hook(sb_umount, mnt, flags);
 }
 
 int security_sb_pivotroot(struct path *old_path, struct path *new_path)
 {
-	return security_ops->sb_pivotroot(old_path, new_path);
+	return call_int_hook(sb_pivotroot, old_path, new_path);
 }
 
 int security_sb_set_mnt_opts(struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
-	return security_ops->sb_set_mnt_opts(sb, opts);
+	int rc;
+
+	if (call_int_must(rc, sb_set_mnt_opts, sb, opts))
+		return rc;
+
+	if (unlikely(opts->num_mnt_opts))
+		return -EOPNOTSUPP;
+	return 0;
 }
 EXPORT_SYMBOL(security_sb_set_mnt_opts);
 
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb)
 {
-	security_ops->sb_clone_mnt_opts(oldsb, newsb);
+	call_void_hook(sb_clone_mnt_opts, oldsb, newsb);
 }
 EXPORT_SYMBOL(security_sb_clone_mnt_opts);
 
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
 {
-	return security_ops->sb_parse_opts_str(options, opts);
+	return call_int_hook(sb_parse_opts_str, options, opts);
 }
 EXPORT_SYMBOL(security_sb_parse_opts_str);
 
 int security_inode_alloc(struct inode *inode)
 {
-	inode->i_security = NULL;
-	return security_ops->inode_alloc_security(inode);
+	return call_alloc_hook(inode_alloc_security, inode_free_security,
+			inode->i_security, GFP_KERNEL, inode);
 }
 
 void security_inode_free(struct inode *inode)
 {
 	integrity_inode_free(inode);
-	security_ops->inode_free_security(inode);
+
+	call_void_hook(inode_free_security, inode);
+
+	kfree(inode->i_security);
+	inode->i_security = NULL;
 }
 
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				 const struct qstr *qstr,
 				 const initxattrs initxattrs, void *fs_data)
 {
+	int rc;
 	struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
 	struct xattr *lsm_xattr, *evm_xattr, *xattr;
-	int ret;
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
 	memset(new_xattrs, 0, sizeof new_xattrs);
 	if (!initxattrs)
-		return security_ops->inode_init_security(inode, dir, qstr,
-							 NULL, NULL, NULL);
+		return call_int_hook(inode_init_security, inode, dir, qstr,
+				NULL, NULL, NULL);
+
 	lsm_xattr = new_xattrs;
-	ret = security_ops->inode_init_security(inode, dir, qstr,
-						&lsm_xattr->name,
-						&lsm_xattr->value,
-						&lsm_xattr->value_len);
-	if (ret)
+
+	if (!call_int_must(rc, inode_init_security, inode, dir, qstr,
+			&lsm_xattr->name, &lsm_xattr->value,
+			&lsm_xattr->value_len))
+		rc = -EOPNOTSUPP;
+
+	if (rc)
 		goto out;
 
 	evm_xattr = lsm_xattr + 1;
-	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
-	if (ret)
+	rc = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
+	if (rc)
 		goto out;
-	ret = initxattrs(inode, new_xattrs, fs_data);
+	rc = initxattrs(inode, new_xattrs, fs_data);
 out:
 	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
 		kfree(xattr->name);
 		kfree(xattr->value);
 	}
-	return (ret == -EOPNOTSUPP) ? 0 : ret;
+	return (rc == -EOPNOTSUPP) ? 0 : rc;
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
@@ -367,8 +919,9 @@ int security_old_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_init_security(inode, dir, qstr, name, value,
-						 len);
+
+	return call_int_hook(inode_init_security, inode, dir, qstr, name,
+							value, len);
 }
 EXPORT_SYMBOL(security_old_inode_init_security);
 
@@ -378,7 +931,8 @@ int security_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mknod(dir, dentry, mode, dev);
+
+	return call_int_hook(path_mknod, dir, dentry, mode, dev);
 }
 EXPORT_SYMBOL(security_path_mknod);
 
@@ -386,7 +940,8 @@ int security_path_mkdir(struct path *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mkdir(dir, dentry, mode);
+
+	return call_int_hook(path_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL(security_path_mkdir);
 
@@ -394,14 +949,16 @@ int security_path_rmdir(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_rmdir(dir, dentry);
+
+	return call_int_hook(path_rmdir, dir, dentry);
 }
 
 int security_path_unlink(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_unlink(dir, dentry);
+
+	return call_int_hook(path_unlink, dir, dentry);
 }
 EXPORT_SYMBOL(security_path_unlink);
 
@@ -410,7 +967,8 @@ int security_path_symlink(struct path *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_symlink(dir, dentry, old_name);
+
+	return call_int_hook(path_symlink, dir, dentry, old_name);
 }
 
 int security_path_link(struct dentry *old_dentry, struct path *new_dir,
@@ -418,7 +976,8 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->path_link(old_dentry, new_dir, new_dentry);
+
+	return call_int_hook(path_link, old_dentry, new_dir, new_dentry);
 }
 
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
@@ -427,8 +986,9 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->path_rename(old_dir, old_dentry, new_dir,
-					 new_dentry);
+
+	return call_int_hook(path_rename, old_dir, old_dentry, new_dir,
+						new_dentry);
 }
 EXPORT_SYMBOL(security_path_rename);
 
@@ -436,26 +996,29 @@ int security_path_truncate(struct path *path)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_truncate(path);
+
+	return call_int_hook(path_truncate, path);
 }
 
 int security_path_chmod(struct path *path, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chmod(path, mode);
+
+	return call_int_hook(path_chmod, path, mode);
 }
 
 int security_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chown(path, uid, gid);
+
+	return call_int_hook(path_chown, path, uid, gid);
 }
 
 int security_path_chroot(struct path *path)
 {
-	return security_ops->path_chroot(path);
+	return call_int_hook(path_chroot, path);
 }
 #endif
 
@@ -463,7 +1026,8 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_create(dir, dentry, mode);
+
+	return call_int_hook(inode_create, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_create);
 
@@ -472,14 +1036,16 @@ int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->inode_link(old_dentry, dir, new_dentry);
+
+	return call_int_hook(inode_link, old_dentry, dir, new_dentry);
 }
 
 int security_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink(dir, dentry);
+
+	return call_int_hook(inode_unlink, dir, dentry);
 }
 
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
@@ -487,14 +1053,16 @@ int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_symlink(dir, dentry, old_name);
+
+	return call_int_hook(inode_symlink, dir, dentry, old_name);
 }
 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mkdir(dir, dentry, mode);
+
+	return call_int_hook(inode_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
@@ -502,14 +1070,16 @@ int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir(dir, dentry);
+
+	return call_int_hook(inode_rmdir, dir, dentry);
 }
 
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mknod(dir, dentry, mode, dev);
+
+	return call_int_hook(inode_mknod, dir, dentry, mode, dev);
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -518,40 +1088,45 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename(old_dir, old_dentry,
-					   new_dir, new_dentry);
+
+	return call_int_hook(inode_rename, old_dir, old_dentry, new_dir,
+						new_dentry);
 }
 
 int security_inode_readlink(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink(dentry);
+
+	return call_int_hook(inode_readlink, dentry);
 }
 
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_follow_link(dentry, nd);
+
+	return call_int_hook(inode_follow_link, dentry, nd);
 }
 
 int security_inode_permission(struct inode *inode, int mask)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask);
+
+	return call_int_hook(inode_permission, inode, mask);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setattr(dentry, attr);
-	if (ret)
-		return ret;
+
+	rc = call_int_hook(inode_setattr, dentry, attr);
+	if (rc)
+		return rc;
 	return evm_inode_setattr(dentry, attr);
 }
 EXPORT_SYMBOL_GPL(security_inode_setattr);
@@ -560,22 +1135,25 @@ int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getattr(mnt, dentry);
+
+	return call_int_hook(inode_getattr, mnt, dentry);
 }
 
 int security_inode_setxattr(struct dentry *dentry, const char *name,
 			    const void *value, size_t size, int flags)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
-	if (ret)
-		return ret;
-	ret = ima_inode_setxattr(dentry, name, value, size);
-	if (ret)
-		return ret;
+
+	rc = call_int_hook(inode_setxattr, dentry, name, value, size, flags);
+
+	if (rc)
+		return rc;
+	rc = ima_inode_setxattr(dentry, name, value, size);
+	if (rc)
+		return rc;
 	return evm_inode_setxattr(dentry, name, value, size);
 }
 
@@ -584,7 +1162,9 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+
+	call_void_hook(inode_post_setxattr, dentry, name, value, size, flags);
+
 	evm_inode_post_setxattr(dentry, name, value, size);
 }
 
@@ -592,91 +1172,145 @@ int security_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, name);
+
+	return call_int_hook(inode_getxattr, dentry, name);
 }
 
 int security_inode_listxattr(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry);
+
+	return call_int_hook(inode_listxattr, dentry);
 }
 
 int security_inode_removexattr(struct dentry *dentry, const char *name)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_removexattr(dentry, name);
-	if (ret)
-		return ret;
-	ret = ima_inode_removexattr(dentry, name);
-	if (ret)
-		return ret;
+
+	if (!call_int_must(rc, inode_removexattr, dentry, name))
+		rc = cap_inode_removexattr(dentry, name);
+
+	if (rc)
+		return rc;
+
+	rc = ima_inode_removexattr(dentry, name);
+	if (rc)
+		return rc;
 	return evm_inode_removexattr(dentry, name);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
 {
-	return security_ops->inode_need_killpriv(dentry);
+	return call_int_cap_first(inode_need_killpriv, dentry);
 }
 
 int security_inode_killpriv(struct dentry *dentry)
 {
-	return security_ops->inode_killpriv(dentry);
+	return call_int_cap_first(inode_killpriv, dentry);
 }
 
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
 {
+	struct security_operations *sop;
+	int rc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
+
+	/*
+	 * Only one LSM will supply a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * provide a value for the provided name.
+	 */
+	for_each_hook(sop, inode_getsecurity) {
+		rc = sop->inode_getsecurity(inode, name, buffer, alloc);
+		if (rc != -EOPNOTSUPP)
+			return rc;
+	}
+	return -EOPNOTSUPP;
 }
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
+	struct security_operations *sop;
+	int rc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_setsecurity(inode, name, value, size, flags);
+
+	/*
+	 * Only one LSM will set a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * set a value for the provided name.
+	 */
+	for_each_hook(sop, inode_setsecurity) {
+		rc = sop->inode_setsecurity(inode, name, value, size, flags);
+		if (rc != -EOPNOTSUPP)
+			return rc;
+	}
+	return -EOPNOTSUPP;
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
+	struct security_operations *sop;
+	int rc = 0;
+	int thisrc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
+
+	/*
+	 * inode_listsecurity hooks never return negative values.
+	 */
+	for_each_hook(sop, inode_listsecurity) {
+		thisrc = sop->inode_listsecurity(inode, buffer, buffer_size);
+		buffer += thisrc;
+		buffer_size -= thisrc;
+		rc += thisrc;
+	}
+	return rc;
 }
 
 void security_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	security_ops->inode_getsecid(inode, secid);
+	*secid = 0;
+	call_void_hook(inode_getsecid, inode, secid);
 }
 
 int security_file_permission(struct file *file, int mask)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->file_permission(file, mask);
-	if (ret)
-		return ret;
+	rc = call_int_hook(file_permission, file, mask);
+
+	if (rc)
+		return rc;
 
 	return fsnotify_perm(file, mask);
 }
 
 int security_file_alloc(struct file *file)
 {
-	return security_ops->file_alloc_security(file);
+	return call_alloc_hook(file_alloc_security, file_free_security,
+			file->f_security, GFP_KERNEL, file);
 }
 
 void security_file_free(struct file *file)
 {
-	security_ops->file_free_security(file);
+	call_void_hook(file_free_security, file);
+
+	kfree(file->f_security);
+	file->f_security = NULL;
 }
 
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_ioctl(file, cmd, arg);
+	return call_int_hook(file_ioctl, file, cmd, arg);
 }
 
 static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
@@ -716,370 +1350,528 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
-	int ret;
-	ret = security_ops->mmap_file(file, prot,
-					mmap_prot(file, prot), flags);
-	if (ret)
-		return ret;
+	int rc;
+
+	rc = call_int_hook(mmap_file, file, prot, mmap_prot(file, prot),
+			   flags);
+
+	if (rc)
+		return rc;
 	return ima_file_mmap(file, prot);
 }
 
 int security_mmap_addr(unsigned long addr)
 {
-	return security_ops->mmap_addr(addr);
+	return call_int_cap_last(mmap_addr, addr);
 }
 
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			    unsigned long prot)
 {
-	return security_ops->file_mprotect(vma, reqprot, prot);
+	return call_int_hook(file_mprotect, vma, reqprot, prot);
 }
 
 int security_file_lock(struct file *file, unsigned int cmd)
 {
-	return security_ops->file_lock(file, cmd);
+	return call_int_hook(file_lock, file, cmd);
 }
 
 int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_fcntl(file, cmd, arg);
+	return call_int_hook(file_fcntl, file, cmd, arg);
 }
 
 int security_file_set_fowner(struct file *file)
 {
-	return security_ops->file_set_fowner(file);
+	return call_int_hook(file_set_fowner, file);
 }
 
 int security_file_send_sigiotask(struct task_struct *tsk,
 				  struct fown_struct *fown, int sig)
 {
-	return security_ops->file_send_sigiotask(tsk, fown, sig);
+	return call_int_hook(file_send_sigiotask, tsk, fown, sig);
 }
 
 int security_file_receive(struct file *file)
 {
-	return security_ops->file_receive(file);
+	return call_int_hook(file_receive, file);
 }
 
 int security_file_open(struct file *file, const struct cred *cred)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->file_open(file, cred);
-	if (ret)
-		return ret;
+	rc = call_int_hook(file_open, file, cred);
+
+	if (rc)
+		return rc;
 
 	return fsnotify_perm(file, MAY_OPEN);
 }
 
 int security_task_create(unsigned long clone_flags)
 {
-	return security_ops->task_create(clone_flags);
+	return call_int_hook(task_create, clone_flags);
 }
 
 void security_task_free(struct task_struct *task)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	yama_task_free(task);
-#endif
-	security_ops->task_free(task);
+	call_void_hook(task_free, task);
 }
 
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
-	return security_ops->cred_alloc_blank(cred, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	cred->security = &tblob;
+
+	for_each_hook(sop, cred_alloc_blank) {
+		rc = sop->cred_alloc_blank(cred, gfp);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(cred);
+		}
+	}
+	cred->security = bp;
+	return rc;
 }
 
 void security_cred_free(struct cred *cred)
 {
-	security_ops->cred_free(cred);
+	call_void_hook(cred_free, cred);
+
+	if (cred->security == NULL)
+		return;
+
+	kfree(cred->security);
+	cred->security = NULL;
 }
 
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp)
 {
-	return security_ops->cred_prepare(new, old, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	/*
+	 * new->security will be NULL on entry.
+	 */
+	memset(&tblob, 0, sizeof(tblob));
+	new->security = &tblob;
+
+	for_each_hook(sop, cred_prepare) {
+		rc = sop->cred_prepare(new, old, gfp);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(new);
+		}
+	}
+	new->security = bp;
+	return rc;
 }
 
 void security_transfer_creds(struct cred *new, const struct cred *old)
 {
-	security_ops->cred_transfer(new, old);
+	call_void_hook(cred_transfer, new, old);
 }
 
 int security_kernel_act_as(struct cred *new, u32 secid)
 {
-	return security_ops->kernel_act_as(new, secid);
+	return call_int_hook(kernel_act_as, new, secid);
 }
 
 int security_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
-	return security_ops->kernel_create_files_as(new, inode);
+	return call_int_hook(kernel_create_files_as, new, inode);
 }
 
 int security_kernel_module_request(char *kmod_name)
 {
-	return security_ops->kernel_module_request(kmod_name);
+	return call_int_hook(kernel_module_request, kmod_name);
 }
 
 int security_kernel_module_from_file(struct file *file)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->kernel_module_from_file(file);
-	if (ret)
-		return ret;
+	rc = call_int_hook(kernel_module_from_file, file);
+	if (rc)
+		return rc;
 	return ima_module_check(file);
 }
 
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags)
 {
-	return security_ops->task_fix_setuid(new, old, flags);
+	return call_int_cap_first(task_fix_setuid, new, old, flags);
 }
 
 int security_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return security_ops->task_setpgid(p, pgid);
+	return call_int_hook(task_setpgid, p, pgid);
 }
 
 int security_task_getpgid(struct task_struct *p)
 {
-	return security_ops->task_getpgid(p);
+	return call_int_hook(task_getpgid, p);
 }
 
 int security_task_getsid(struct task_struct *p)
 {
-	return security_ops->task_getsid(p);
+	return call_int_hook(task_getsid, p);
 }
 
 void security_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	security_ops->task_getsecid(p, secid);
+	*secid = 0;
+	call_void_hook(task_getsecid, p, secid);
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
 int security_task_setnice(struct task_struct *p, int nice)
 {
-	return security_ops->task_setnice(p, nice);
+	return call_int_cap_first(task_setnice, p, nice);
 }
 
 int security_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return security_ops->task_setioprio(p, ioprio);
+	return call_int_cap_first(task_setioprio, p, ioprio);
 }
 
 int security_task_getioprio(struct task_struct *p)
 {
-	return security_ops->task_getioprio(p);
+	return call_int_hook(task_getioprio, p);
 }
 
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 		struct rlimit *new_rlim)
 {
-	return security_ops->task_setrlimit(p, resource, new_rlim);
+	return call_int_hook(task_setrlimit, p, resource, new_rlim);
 }
 
 int security_task_setscheduler(struct task_struct *p)
 {
-	return security_ops->task_setscheduler(p);
+	return call_int_cap_first(task_setscheduler, p);
 }
 
 int security_task_getscheduler(struct task_struct *p)
 {
-	return security_ops->task_getscheduler(p);
+	return call_int_hook(task_getscheduler, p);
 }
 
 int security_task_movememory(struct task_struct *p)
 {
-	return security_ops->task_movememory(p);
+	return call_int_hook(task_movememory, p);
 }
 
 int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid)
 {
-	return security_ops->task_kill(p, info, sig, secid);
+	return call_int_hook(task_kill, p, info, sig, secid);
 }
 
 int security_task_wait(struct task_struct *p)
 {
-	return security_ops->task_wait(p);
+	return call_int_hook(task_wait, p);
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
+	struct security_operations *sop;
 	int rc;
-	rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
+
+	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
 	if (rc != -ENOSYS)
 		return rc;
-#endif
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+
+	for_each_hook(sop, task_prctl) {
+		rc = sop->task_prctl(option, arg2, arg3, arg4, arg5);
+		/*
+		 * -ENOSYS returned if the lsm doesn't handle that control.
+		 * If the LSM does handle the control return the result.
+		 * The assumption for the time being is that no two LSMs
+		 * will handle a control.
+		 */
+		if (rc != -ENOSYS)
+			return rc;
+	}
+	return -ENOSYS;
 }
 
 void security_task_to_inode(struct task_struct *p, struct inode *inode)
 {
-	security_ops->task_to_inode(p, inode);
+	call_void_hook(task_to_inode, p, inode);
 }
 
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
-	return security_ops->ipc_permission(ipcp, flag);
+	return call_int_hook(ipc_permission, ipcp, flag);
 }
 
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
 {
-	security_ops->ipc_getsecid(ipcp, secid);
+	*secid = 0;
+	call_void_hook(ipc_getsecid, ipcp, secid);
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
 {
-	return security_ops->msg_msg_alloc_security(msg);
+	return call_alloc_hook(msg_msg_alloc_security, msg_msg_free_security,
+			msg->security, GFP_KERNEL, msg);
 }
 
 void security_msg_msg_free(struct msg_msg *msg)
 {
-	security_ops->msg_msg_free_security(msg);
+	call_void_hook(msg_msg_free_security, msg);
+
+	kfree(msg->security);
+	msg->security = NULL;
 }
 
 int security_msg_queue_alloc(struct msg_queue *msq)
 {
-	return security_ops->msg_queue_alloc_security(msq);
+	struct kern_ipc_perm *kp = &msq->q_perm;
+
+	return call_alloc_hook(msg_queue_alloc_security,
+			msg_queue_free_security, kp->security, GFP_KERNEL,
+			msq);
 }
 
 void security_msg_queue_free(struct msg_queue *msq)
 {
-	security_ops->msg_queue_free_security(msq);
+	call_void_hook(msg_queue_free_security, msq);
+
+	kfree(msq->q_perm.security);
+	msq->q_perm.security = NULL;
 }
 
 int security_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	return security_ops->msg_queue_associate(msq, msqflg);
+	return call_int_hook(msg_queue_associate, msq, msqflg);
 }
 
 int security_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	return security_ops->msg_queue_msgctl(msq, cmd);
+	return call_int_hook(msg_queue_msgctl, msq, cmd);
 }
 
 int security_msg_queue_msgsnd(struct msg_queue *msq,
 			       struct msg_msg *msg, int msqflg)
 {
-	return security_ops->msg_queue_msgsnd(msq, msg, msqflg);
+	return call_int_hook(msg_queue_msgsnd, msq, msg, msqflg);
 }
 
 int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 			       struct task_struct *target, long type, int mode)
 {
-	return security_ops->msg_queue_msgrcv(msq, msg, target, type, mode);
+	return call_int_hook(msg_queue_msgrcv, msq, msg, target, type, mode);
 }
 
 int security_shm_alloc(struct shmid_kernel *shp)
 {
-	return security_ops->shm_alloc_security(shp);
+	struct kern_ipc_perm *kp = &shp->shm_perm;
+
+	return call_alloc_hook(shm_alloc_security, shm_free_security,
+			kp->security, GFP_KERNEL, shp);
 }
 
 void security_shm_free(struct shmid_kernel *shp)
 {
-	security_ops->shm_free_security(shp);
+	call_void_hook(shm_free_security, shp);
+
+	kfree(shp->shm_perm.security);
+	shp->shm_perm.security = NULL;
 }
 
 int security_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	return security_ops->shm_associate(shp, shmflg);
+	return call_int_hook(shm_associate, shp, shmflg);
 }
 
 int security_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	return security_ops->shm_shmctl(shp, cmd);
+	return call_int_hook(shm_shmctl, shp, cmd);
 }
 
 int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg)
 {
-	return security_ops->shm_shmat(shp, shmaddr, shmflg);
+	return call_int_hook(shm_shmat, shp, shmaddr, shmflg);
 }
 
 int security_sem_alloc(struct sem_array *sma)
 {
-	return security_ops->sem_alloc_security(sma);
+	struct kern_ipc_perm *kp = &sma->sem_perm;
+
+	return call_alloc_hook(sem_alloc_security, sem_free_security,
+			kp->security, GFP_KERNEL, sma);
 }
 
 void security_sem_free(struct sem_array *sma)
 {
-	security_ops->sem_free_security(sma);
+	call_void_hook(sem_free_security, sma);
+
+	kfree(sma->sem_perm.security);
+	sma->sem_perm.security = NULL;
 }
 
 int security_sem_associate(struct sem_array *sma, int semflg)
 {
-	return security_ops->sem_associate(sma, semflg);
+	return call_int_hook(sem_associate, sma, semflg);
 }
 
 int security_sem_semctl(struct sem_array *sma, int cmd)
 {
-	return security_ops->sem_semctl(sma, cmd);
+	return call_int_hook(sem_semctl, sma, cmd);
 }
 
 int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			unsigned nsops, int alter)
 {
-	return security_ops->sem_semop(sma, sops, nsops, alter);
+	return call_int_hook(sem_semop, sma, sops, nsops, alter);
 }
 
 void security_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (unlikely(inode && IS_PRIVATE(inode)))
 		return;
-	security_ops->d_instantiate(dentry, inode);
+
+	call_void_hook(d_instantiate, dentry, inode);
 }
 EXPORT_SYMBOL(security_d_instantiate);
 
 int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	return security_ops->getprocattr(p, name, value);
+	struct security_operations *sop;
+	char *lsm;
+	int lsmlen;
+
+	/*
+	 * Names will either be in the legacy form containing
+	 * no periods (".") or they will be the LSM name followed
+	 * by the legacy suffix.
+	 * "current" or "selinux.current"
+	 *
+	 * Legacy names are handled by the presenting LSM.
+	 * Suffixed names are handled by the named LSM.
+	 */
+	if (lsm_present && !strchr(name, '.'))
+		return present_getprocattr(p, name, value);
+
+	for_each_hook(sop, getprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->getprocattr(p, name + lsmlen + 1, value);
+	}
+	return -EINVAL;
 }
 
-int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
+int security_setprocattr(struct task_struct *p, char *name, void *value,
+				size_t size)
 {
-	return security_ops->setprocattr(p, name, value, size);
+	struct security_operations *sop;
+	char *lsm;
+	int lsmlen;
+
+	/*
+	 * Names will either be in the legacy form containing
+	 * no periods (".") or they will be the LSM name followed
+	 * by the legacy suffix.
+	 * "current" or "selinux.current"
+	 *
+	 * Legacy names are handled by the presenting LSM.
+	 * Suffixed names are handled by the named LSM.
+	 */
+	if (lsm_present && !strchr(name, '.'))
+		return present_setprocattr(p, name, value, size);
+
+	for_each_hook(sop, setprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->setprocattr(p, name + lsmlen + 1, value,
+						size);
+	}
+	return -EINVAL;
 }
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	return security_ops->netlink_send(sk, skb);
+	return call_int_cap_first(netlink_send, sk, skb);
 }
 
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
-	return security_ops->secid_to_secctx(secid, secdata, seclen);
+	int rc;
+
+	if (call_int_must(rc, secid_to_secctx, secid, secdata, seclen))
+		return rc;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
-	return security_ops->secctx_to_secid(secdata, seclen, secid);
+	int rc;
+
+	if (call_int_must(rc, secctx_to_secid, secdata, seclen, secid))
+		return rc;
+	*secid = 0;
+	return 0;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
 void security_release_secctx(char *secdata, u32 seclen)
 {
-	security_ops->release_secctx(secdata, seclen);
+	call_void_hook(release_secctx, secdata, seclen);
 }
 EXPORT_SYMBOL(security_release_secctx);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 {
-	return security_ops->inode_notifysecctx(inode, ctx, ctxlen);
+	return call_int_hook(inode_notifysecctx, inode, ctx, ctxlen);
 }
 EXPORT_SYMBOL(security_inode_notifysecctx);
 
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return security_ops->inode_setsecctx(dentry, ctx, ctxlen);
+	return call_int_hook(inode_setsecctx, dentry, ctx, ctxlen);
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 {
-	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
+	return call_int_hook(inode_getsecctx, inode, ctx, ctxlen);
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
@@ -1087,188 +1879,228 @@ EXPORT_SYMBOL(security_inode_getsecctx);
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
 {
-	return security_ops->unix_stream_connect(sock, other, newsk);
+	return call_int_hook(unix_stream_connect, sock, other, newsk);
 }
 EXPORT_SYMBOL(security_unix_stream_connect);
 
 int security_unix_may_send(struct socket *sock,  struct socket *other)
 {
-	return security_ops->unix_may_send(sock, other);
+	return call_int_hook(unix_may_send, sock, other);
 }
 EXPORT_SYMBOL(security_unix_may_send);
 
 int security_socket_create(int family, int type, int protocol, int kern)
 {
-	return security_ops->socket_create(family, type, protocol, kern);
+	return call_int_hook(socket_create, family, type, protocol, kern);
 }
 
 int security_socket_post_create(struct socket *sock, int family,
 				int type, int protocol, int kern)
 {
-	return security_ops->socket_post_create(sock, family, type,
-						protocol, kern);
+	return call_int_hook(socket_post_create, sock, family, type,
+			protocol, kern);
 }
 
 int security_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
 {
-	return security_ops->socket_bind(sock, address, addrlen);
+	return call_int_hook(socket_bind, sock, address, addrlen);
 }
 
 int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
 {
-	return security_ops->socket_connect(sock, address, addrlen);
+	return call_int_hook(socket_connect, sock, address, addrlen);
 }
 
 int security_socket_listen(struct socket *sock, int backlog)
 {
-	return security_ops->socket_listen(sock, backlog);
+	return call_int_hook(socket_listen, sock, backlog);
 }
 
 int security_socket_accept(struct socket *sock, struct socket *newsock)
 {
-	return security_ops->socket_accept(sock, newsock);
+	return call_int_hook(socket_accept, sock, newsock);
 }
 
 int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
 {
-	return security_ops->socket_sendmsg(sock, msg, size);
+	return call_int_hook(socket_sendmsg, sock, msg, size);
 }
 
 int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags)
 {
-	return security_ops->socket_recvmsg(sock, msg, size, flags);
+	return call_int_hook(socket_recvmsg, sock, msg, size, flags);
 }
 
 int security_socket_getsockname(struct socket *sock)
 {
-	return security_ops->socket_getsockname(sock);
+	return call_int_hook(socket_getsockname, sock);
 }
 
 int security_socket_getpeername(struct socket *sock)
 {
-	return security_ops->socket_getpeername(sock);
+	return call_int_hook(socket_getpeername, sock);
 }
 
 int security_socket_getsockopt(struct socket *sock, int level, int optname)
 {
-	return security_ops->socket_getsockopt(sock, level, optname);
+	return call_int_hook(socket_getsockopt, sock, level, optname);
 }
 
 int security_socket_setsockopt(struct socket *sock, int level, int optname)
 {
-	return security_ops->socket_setsockopt(sock, level, optname);
+	return call_int_hook(socket_setsockopt, sock, level, optname);
 }
 
 int security_socket_shutdown(struct socket *sock, int how)
 {
-	return security_ops->socket_shutdown(sock, how);
+	return call_int_hook(socket_shutdown, sock, how);
 }
 
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
-	return security_ops->socket_sock_rcv_skb(sk, skb);
+	return call_int_hook(socket_sock_rcv_skb, sk, skb);
 }
 EXPORT_SYMBOL(security_sock_rcv_skb);
 
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len)
 {
-	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
+	int rc;
+
+	if (call_int_must(rc, socket_getpeersec_stream, sock, optval,
+				optlen, len))
+		return rc;
+	return -ENOPROTOOPT;
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
 {
-	return security_ops->socket_getpeersec_dgram(sock, skb, secid);
+	int rc;
+
+	if (call_int_must(rc, socket_getpeersec_dgram, sock, skb, secid))
+		return rc;
+	return -ENOPROTOOPT;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
 {
-	return security_ops->sk_alloc_security(sk, family, priority);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	sk->sk_security = &tblob;
+
+	for_each_hook(sop, sk_alloc_security) {
+		rc = sop->sk_alloc_security(sk, family, priority);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), priority);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->sk_free_security(sk);
+		}
+	}
+	sk->sk_security = bp;
+	return rc;
 }
 
 void security_sk_free(struct sock *sk)
 {
-	security_ops->sk_free_security(sk);
+	call_void_hook(sk_free_security, sk);
+
+	kfree(sk->sk_security);
+	sk->sk_security = NULL;
 }
 
 void security_sk_clone(const struct sock *sk, struct sock *newsk)
 {
-	security_ops->sk_clone_security(sk, newsk);
+	call_void_hook(sk_clone_security, sk, newsk);
 }
 EXPORT_SYMBOL(security_sk_clone);
 
 void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
 {
-	security_ops->sk_getsecid(sk, &fl->flowi_secid);
+	call_void_hook(sk_getsecid, sk, &fl->flowi_secid);
 }
 EXPORT_SYMBOL(security_sk_classify_flow);
 
 void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
 {
-	security_ops->req_classify_flow(req, fl);
+	call_void_hook(req_classify_flow, req, fl);
 }
 EXPORT_SYMBOL(security_req_classify_flow);
 
 void security_sock_graft(struct sock *sk, struct socket *parent)
 {
-	security_ops->sock_graft(sk, parent);
+	call_void_hook(sock_graft, sk, parent);
 }
 EXPORT_SYMBOL(security_sock_graft);
 
 int security_inet_conn_request(struct sock *sk,
 			struct sk_buff *skb, struct request_sock *req)
 {
-	return security_ops->inet_conn_request(sk, skb, req);
+	return call_int_hook(inet_conn_request, sk, skb, req);
 }
 EXPORT_SYMBOL(security_inet_conn_request);
 
 void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req)
 {
-	security_ops->inet_csk_clone(newsk, req);
+	call_void_hook(inet_csk_clone, newsk, req);
 }
 
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb)
 {
-	security_ops->inet_conn_established(sk, skb);
+	call_void_hook(inet_conn_established, sk, skb);
 }
 
 int security_secmark_relabel_packet(u32 secid)
 {
-	return security_ops->secmark_relabel_packet(secid);
+	return call_int_hook(secmark_relabel_packet, secid);
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
 void security_secmark_refcount_inc(void)
 {
-	security_ops->secmark_refcount_inc();
+	call_void_hook(secmark_refcount_inc);
 }
 EXPORT_SYMBOL(security_secmark_refcount_inc);
 
 void security_secmark_refcount_dec(void)
 {
-	security_ops->secmark_refcount_dec();
+	call_void_hook(secmark_refcount_dec);
 }
 EXPORT_SYMBOL(security_secmark_refcount_dec);
 
 int security_tun_dev_create(void)
 {
-	return security_ops->tun_dev_create();
+	return call_int_hook(tun_dev_create);
 }
 EXPORT_SYMBOL(security_tun_dev_create);
 
 void security_tun_dev_post_create(struct sock *sk)
 {
-	return security_ops->tun_dev_post_create(sk);
+	call_void_hook(tun_dev_post_create, sk);
 }
 EXPORT_SYMBOL(security_tun_dev_post_create);
 
 int security_tun_dev_attach(struct sock *sk)
 {
-	return security_ops->tun_dev_attach(sk);
+	return call_int_hook(tun_dev_attach, sk);
 }
 EXPORT_SYMBOL(security_tun_dev_attach);
 
@@ -1276,78 +2108,94 @@ EXPORT_SYMBOL(security_tun_dev_attach);
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
+/*
+ * The xfrm hooks present special issues for composition
+ * as they don't use the usual scheme for passing in blobs.
+ * LSM registration checks ensure that only one xfrm using
+ * security module is loaded at a time.
+ * This shouldn't be much of an issue since SELinux is the
+ * only security module ever expected to use xfrm.
+ */
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
 {
-	return security_ops->xfrm_policy_alloc_security(ctxp, sec_ctx);
+	return call_int_hook(xfrm_policy_alloc_security, ctxp, sec_ctx);
 }
 EXPORT_SYMBOL(security_xfrm_policy_alloc);
 
 int security_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
 			      struct xfrm_sec_ctx **new_ctxp)
 {
-	return security_ops->xfrm_policy_clone_security(old_ctx, new_ctxp);
+	return call_int_hook(xfrm_policy_clone_security, old_ctx, new_ctxp);
 }
 
 void security_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
 {
-	security_ops->xfrm_policy_free_security(ctx);
+	call_void_hook(xfrm_policy_free_security, ctx);
 }
 EXPORT_SYMBOL(security_xfrm_policy_free);
 
 int security_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	return security_ops->xfrm_policy_delete_security(ctx);
+	return call_int_hook(xfrm_policy_delete_security, ctx);
 }
 
 int security_xfrm_state_alloc(struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx)
 {
-	return security_ops->xfrm_state_alloc_security(x, sec_ctx, 0);
+	return call_int_hook(xfrm_state_alloc_security, x, sec_ctx, 0);
 }
 EXPORT_SYMBOL(security_xfrm_state_alloc);
 
 int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				      struct xfrm_sec_ctx *polsec, u32 secid)
 {
-	if (!polsec)
-		return 0;
 	/*
 	 * We want the context to be taken from secid which is usually
 	 * from the sock.
 	 */
-	return security_ops->xfrm_state_alloc_security(x, NULL, secid);
+
+	if (!polsec)
+		return 0;
+
+	return call_int_hook(xfrm_state_alloc_security, x, NULL, secid);
 }
 
 int security_xfrm_state_delete(struct xfrm_state *x)
 {
-	return security_ops->xfrm_state_delete_security(x);
+	return call_int_hook(xfrm_state_delete_security, x);
 }
 EXPORT_SYMBOL(security_xfrm_state_delete);
 
 void security_xfrm_state_free(struct xfrm_state *x)
 {
-	security_ops->xfrm_state_free_security(x);
+	call_void_hook(xfrm_state_free_security, x);
 }
 
 int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 {
-	return security_ops->xfrm_policy_lookup(ctx, fl_secid, dir);
+	return call_int_hook(xfrm_policy_lookup, ctx, fl_secid, dir);
 }
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
 				       const struct flowi *fl)
 {
-	return security_ops->xfrm_state_pol_flow_match(x, xp, fl);
+	int rc;
+
+	if (call_int_must(rc, xfrm_state_pol_flow_match, x, xp, fl))
+		return rc;
+	return 1;
 }
 
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
 {
-	return security_ops->xfrm_decode_session(skb, secid, 1);
+	return call_int_hook(xfrm_decode_session, skb, secid, 1);
 }
 
 void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
 {
-	int rc = security_ops->xfrm_decode_session(skb, &fl->flowi_secid, 0);
+	int rc;
+
+	rc = call_int_hook(xfrm_decode_session, skb, &fl->flowi_secid, 0);
 
 	BUG_ON(rc);
 }
@@ -1360,23 +2208,60 @@ EXPORT_SYMBOL(security_skb_classify_flow);
 int security_key_alloc(struct key *key, const struct cred *cred,
 		       unsigned long flags)
 {
-	return security_ops->key_alloc(key, cred, flags);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	key->security = &tblob;
+
+	for_each_hook(sop, key_alloc) {
+		rc = sop->key_alloc(key, cred, flags);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), GFP_KERNEL);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->key_free(key);
+		}
+	}
+
+	key->security = bp;
+	return rc;
 }
 
 void security_key_free(struct key *key)
 {
-	security_ops->key_free(key);
+	call_void_hook(key_free, key);
+
+	kfree(key->security);
+	key->security = NULL;
 }
 
 int security_key_permission(key_ref_t key_ref,
 			    const struct cred *cred, key_perm_t perm)
 {
-	return security_ops->key_permission(key_ref, cred, perm);
+	return call_int_hook(key_permission, key_ref, cred, perm);
 }
 
 int security_key_getsecurity(struct key *key, char **_buffer)
 {
-	return security_ops->key_getsecurity(key, _buffer);
+	int rc;
+
+	if (call_int_must(rc, key_getsecurity, key, _buffer))
+		return rc;
+	*_buffer = NULL;
+	return 0;
 }
 
 #endif	/* CONFIG_KEYS */
@@ -1385,23 +2270,24 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
 {
-	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
+	return call_int_hook(audit_rule_init, field, op, rulestr, lsmrule);
 }
 
 int security_audit_rule_known(struct audit_krule *krule)
 {
-	return security_ops->audit_rule_known(krule);
+	return call_int_hook(audit_rule_known, krule);
 }
 
 void security_audit_rule_free(void *lsmrule)
 {
-	security_ops->audit_rule_free(lsmrule);
+	call_void_hook(audit_rule_free, lsmrule);
 }
 
 int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 			      struct audit_context *actx)
 {
-	return security_ops->audit_rule_match(secid, field, op, lsmrule, actx);
+	return call_int_hook(audit_rule_match, secid, field, op, lsmrule,
+				actx);
 }
 
 #endif /* CONFIG_AUDIT */

