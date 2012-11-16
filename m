Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2KPQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:36:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33279 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2KPQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:36:22 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:42 -0800
Message-Id: <1353083750-3621-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/se1HyNLDhP//bYxWMVVvEMb8rbUO9Oo0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0032]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 03/11] pidns: Capture the user namespace and filter ns_last_pid
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Capture the the user namespace that creates the pid namespace
- Use that user namespace to test if it is ok to write to
  /proc/sys/kernel/ns_last_pid.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/pid_namespace.h |    8 +++++---
 kernel/nsproxy.c              |    2 +-
 kernel/pid.c                  |    1 +
 kernel/pid_namespace.c        |   16 +++++++++++-----
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 65e3e87..c89c9cf 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -31,6 +31,7 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	struct user_namespace *user_ns;
 	kgid_t pid_gid;
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
@@ -46,7 +47,8 @@ static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 	return ns;
 }
 
-extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
+extern struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct pid_namespace *ns);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
 extern void put_pid_ns(struct pid_namespace *ns);
@@ -59,8 +61,8 @@ static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 	return ns;
 }
 
-static inline struct pid_namespace *
-copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
+static inline struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct pid_namespace *ns)
 {
 	if (flags & CLONE_NEWPID)
 		ns = ERR_PTR(-EINVAL);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..5fe88e1 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -84,7 +84,7 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_ipc;
 	}
 
-	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
+	new_nsp->pid_ns = copy_pid_ns(flags, task_cred_xxx(tsk, user_ns), task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
 		err = PTR_ERR(new_nsp->pid_ns);
 		goto out_pid;
diff --git a/kernel/pid.c b/kernel/pid.c
index aebd4f5..2a624f1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -78,6 +78,7 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.level = 0,
 	.child_reaper = &init_task,
+	.user_ns = &init_user_ns,
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 7b07cc0..7580aa0 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -10,6 +10,7 @@
 
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/err.h>
 #include <linux/acct.h>
@@ -74,7 +75,8 @@ err_alloc:
 /* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
 #define MAX_PID_NS_LEVEL 32
 
-static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
+static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns,
+	struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
@@ -102,6 +104,7 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	kref_init(&ns->kref);
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
+	ns->user_ns = get_user_ns(user_ns);
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
@@ -117,6 +120,7 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 
 out_put_parent_pid_ns:
 	put_pid_ns(parent_pid_ns);
+	put_user_ns(user_ns);
 out_free_map:
 	kfree(ns->pidmap[0].page);
 out_free:
@@ -134,13 +138,14 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 	kmem_cache_free(pid_ns_cachep, ns);
 }
 
-struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
+struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct pid_namespace *old_ns)
 {
 	if (!(flags & CLONE_NEWPID))
 		return get_pid_ns(old_ns);
 	if (flags & (CLONE_THREAD|CLONE_PARENT))
 		return ERR_PTR(-EINVAL);
-	return create_pid_namespace(old_ns);
+	return create_pid_namespace(user_ns, old_ns);
 }
 
 static void free_pid_ns(struct kref *kref)
@@ -239,9 +244,10 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
 	struct ctl_table tmp = *table;
 
-	if (write && !capable(CAP_SYS_ADMIN))
+	if (write && !ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/*
@@ -250,7 +256,7 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 	 * it should synchronize its usage with external means.
 	 */
 
-	tmp.data = &current->nsproxy->pid_ns->last_pid;
+	tmp.data = &pid_ns->last_pid;
 	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 }
 
-- 
1.7.5.4

