Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1JZX76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:59:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33059 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1JZX7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:59:03 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 19:59:03 EDT
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 2/3] security: create task_free security callback
Date: Wed, 26 Oct 2011 16:49:15 -0700
Message-Id: <1319672956-17114-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current LSM interface to cred_free is not sufficient for allowing
an LSM to track the life and death of a task. This patch adds the
task_free hook so that an LSM can clean up resources on task death.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/security.h |    9 +++++++++
 kernel/fork.c            |    1 +
 security/capability.c    |    4 ++++
 security/security.c      |    5 +++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 19d8e04..256befc 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -650,6 +650,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
+ * @task_free:
+ *	@task task being freed
+ *	Handle release of task-related resources. (Note that this can be called
+ *  from interrupt context.)
  * @cred_alloc_blank:
  *	@cred points to the credentials.
  *	@gfp indicates the atomicity of any memory allocations.
@@ -1500,6 +1504,7 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
+	void (*task_free) (struct task_struct *task);
 	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
@@ -1762,6 +1767,7 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
@@ -2273,6 +2279,9 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline void security_task_free(struct task_struct *task)
+{ }
+
 static inline int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..6371378 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -190,6 +190,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
diff --git a/security/capability.c b/security/capability.c
index 2984ea4..e4206b5 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -359,6 +359,9 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static void cap_task_free(struct task_struct *task)
+{ }
+
 static int cap_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
@@ -955,6 +958,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
+	set_to_cap_if_null(ops, task_free);
 	set_to_cap_if_null(ops, cred_alloc_blank);
 	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, cred_prepare);
diff --git a/security/security.c b/security/security.c
index 0c6cc69..49a7227 100644
--- a/security/security.c
+++ b/security/security.c
@@ -749,6 +749,11 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
+void security_task_free(struct task_struct *task)
+{
+	security_ops->task_free(task);
+}
+
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return security_ops->cred_alloc_blank(cred, gfp);
-- 
1.7.5.4

