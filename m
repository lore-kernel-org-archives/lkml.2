Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0F3Ajf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:39:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45883 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0F3Aje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:39:34 -0400
Date: Tue, 29 Jun 2010 17:39:33 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] security: create task_free security callback
Message-ID: <20100630003933.GF4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630003844.GE4837@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current LSM interface to cred_free is not sufficient for allowing
an LSM to track the life and death of a task.  This patch adds the
task_free hook so that an LSM can clean up resources on task death.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 include/linux/security.h |    8 ++++++++
 kernel/fork.c            |    1 +
 security/capability.c    |    4 ++++
 security/security.c      |    5 +++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 723a93d..8007495 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -637,6 +637,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
+ * @task_free:
+ *	@task task being freed
+ *	Handle release of task-related resources.
  * @cred_alloc_blank:
  *	@cred points to the credentials.
  *	@gfp indicates the atomicity of any memory allocations.
@@ -1481,6 +1484,7 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
+	void (*task_free) (struct task_struct *task);
 	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
@@ -1732,6 +1736,7 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
@@ -2232,6 +2237,9 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline int security_task_free(struct task_struct *task)
+{ }
+
 static inline int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index b6cce14..7fbc5e3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -183,6 +183,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
diff --git a/security/capability.c b/security/capability.c
index 4aeb699..3649d4b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -353,6 +353,9 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static void cap_task_free(struct task_struct *task)
+{ }
+
 static int cap_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
 	return 0;
@@ -936,6 +939,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
+	set_to_cap_if_null(ops, task_free);
 	set_to_cap_if_null(ops, cred_alloc_blank);
 	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, cred_prepare);
diff --git a/security/security.c b/security/security.c
index e8c87b8..103c35f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -691,6 +691,11 @@ int security_task_create(unsigned long clone_flags)
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
1.7.1


-- 
Kees Cook
Ubuntu Security Team
