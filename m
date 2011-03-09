Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab1CITdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:33:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1CITdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:33:38 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2] capabilites: allow the application of capability limits
	to usermode helpers
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
Date: Wed, 09 Mar 2011 14:33:31 -0500
Message-ID: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way to limit the capabilities of usermodehelpers. This problem
reared its head recently when someone complained that any user with
cap_net_admin was able to load arbitrary kernel modules, even though the user
didn't have cap_sys_module.  The reason is because the actual load is done by
a usermode helper and those always have the full cap set.  This patch addes new
sysctls which allow us to bound the permissions of usermode helpers.

/proc/sys/kernel/usermodehelper/bset
/proc/sys/kernel/usermodehelper/inheritable

You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
When the kernel launches a usermodehelper it will do so with these as
the bset and pI.

-v2:	make globals static
	create spinlock to protect globals

Signed-off-by: Eric Paris <eparis@redhat.com>
No-objection-from: Serge E. Hallyn <serge.hallyn@canonical.com>
---

 include/linux/kmod.h |    3 ++
 kernel/kmod.c        |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c      |    6 +++
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 6efd7a7..79bb98d 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/compiler.h>
 #include <linux/workqueue.h>
+#include <linux/sysctl.h>
 
 #define KMOD_PATH_LEN 256
 
@@ -109,6 +110,8 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 				       NULL, NULL, NULL);
 }
 
+extern struct ctl_table usermodehelper_table[];
+
 extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9cd0591..c1faee7 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -25,6 +25,7 @@
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/workqueue.h>
@@ -43,6 +44,13 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
+#define CAP_BSET	(void *)1
+#define CAP_PI		(void *)2
+
+static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
+static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
+static DEFINE_SPINLOCK(umh_sysctl_lock);
+
 #ifdef CONFIG_MODULES
 
 /*
@@ -132,6 +140,7 @@ EXPORT_SYMBOL(__request_module);
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
+	struct cred *new;
 	int retval;
 
 	spin_lock_irq(&current->sighand->siglock);
@@ -153,6 +162,19 @@ static int ____call_usermodehelper(void *data)
 			goto fail;
 	}
 
+	retval = -ENOMEM;
+	new = prepare_kernel_cred(current);
+	if (!new)
+		goto fail;
+
+	spin_lock(&umh_sysctl_lock);
+	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
+	new->cap_inheritable = cap_intersect(usermodehelper_inheritable,
+					     new->cap_inheritable);
+	spin_unlock(&umh_sysctl_lock);
+
+	commit_creds(new);
+
 	retval = kernel_execve(sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);
@@ -418,6 +440,83 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
+static int proc_cap_handler(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
+	kernel_cap_t new_cap;
+	int err, i;
+
+	if (write && !capable(CAP_SYS_MODULE))
+		return -EPERM;
+
+	/*
+	 * convert from the global kernel_cap_t to the ulong array to print to
+	 * userspace if this is a read.
+	 */
+	spin_lock(&umh_sysctl_lock);
+	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
+		if (table->data == CAP_BSET)
+			cap_array[i] = usermodehelper_bset.cap[i];
+		else if (table->data == CAP_PI)
+			cap_array[i] = usermodehelper_inheritable.cap[i];
+		else
+			BUG();
+	}
+	spin_unlock(&umh_sysctl_lock);
+
+	t = *table;
+	t.data = &cap_array;
+
+	/*
+	 * actually read or write and array of ulongs from userspace.  Remember
+	 * these are least significant 32 bits first
+	 */
+	err = proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	/*
+	 * convert from the sysctl array of ulongs to the kernel_cap_t
+	 * internal representation
+	 */
+	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
+		new_cap.cap[i] = cap_array[i];
+
+	/*
+	 * Drop everything not in the new_cap (but don't add things)
+	 */
+	spin_lock(&umh_sysctl_lock);
+	if (write) {
+		if (table->data == CAP_BSET)
+			usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
+		if (table->data == CAP_PI)
+			usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
+	}
+	spin_unlock(&umh_sysctl_lock);
+
+	return 0;
+}
+
+struct ctl_table usermodehelper_table[] = {
+	{
+		.procname	= "bset",
+		.data		= CAP_BSET,
+		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
+		.mode		= 0600,
+		.proc_handler	= proc_cap_handler,
+	},
+	{
+		.procname	= "inheritable",
+		.data		= CAP_PI,
+		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
+		.mode		= 0600,
+		.proc_handler	= proc_cap_handler,
+	},
+	{ }
+};
+
 void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 79268ee..f8ecc96 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -56,6 +56,7 @@
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
+#include <linux/kmod.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -610,6 +611,11 @@ static struct ctl_table kern_table[] = {
 		.child		= random_table,
 	},
 	{
+		.procname	= "usermodehelper",
+		.mode		= 0555,
+		.child		= usermodehelper_table,
+	},
+	{
 		.procname	= "overflowuid",
 		.data		= &overflowuid,
 		.maxlen		= sizeof(int),

