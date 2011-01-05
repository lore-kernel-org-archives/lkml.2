Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1AEWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:25:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1AEWZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:25:44 -0500
Subject: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: serue@us.ibm.com, sgrubb@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 17:25:37 -0500
Message-ID: <1294266337.3237.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not so long ago the global capability bounding set was removed from the
kernel.  Instead we created a new per task capability bounding set which
was inherited by children.  This feature is quite reasonable if you want
to start some task and its descendants in a limited capability box but
it is completely useless if you want to make system wide changes.  This
is the reason we had to add the /proc/sys/kernel/modules_disabled
tunable even though CAP_SYS_MODULE controls the operation.  There is
absolutely no way to eliminate a capability from the system.  At first I
thought maybe we could do something smart, like, drop the capability in
question by init before anything else ran, thus it would be gone from
the bounding set of every process.  But this is not even possible!  All
one must do it cause the kernel to attempt to auto load a module and
viola, you win!  The kernel will upcall to userspace
(maybe /sbin/modprobe, maybe something root dropped there, or maybe root
rewrote what's called with /proc/sys/kernel/modprobe) from a kernel
thread which has a full capability bounding set.  Thus whatever gets
called has everything.  And you can't drop privs.  Period.  We just
can't do it.

This patch reintroduces the global bounding set.  It's global.  Period.
Unlike the old days not even init can put things back.  It's a one way
street.  Notice that it only applies at the exec boundary, so programs
running before the bounding set is lowered are still able to use those
caps, but they cannot be passed onto children.  This does allow us to
drop caps very early by init and never have them come back.  Sure kernel
threads may still have them, but they will not be able to pass them onto
child tasks (like modprobe)

Signed-off-by: Eric Paris <eparis@redhat.com>
---
I'd love to hear comments.....

 include/linux/capability.h |    1 
 include/linux/security.h   |    5 ++++
 include/linux/sysctl.h     |    3 ++
 kernel/sysctl.c            |   56 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl_binary.c     |    2 +
 security/commoncap.c       |   17 ++++++++++---
 6 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 90012b9..2aebcb1 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -224,6 +224,7 @@ struct cpu_vfs_cap_data {
 #define CAP_IPC_OWNER        15
 
 /* Insert and remove kernel modules - modify kernel without limit */
+/* Remove from the global cap_bset */
 #define CAP_SYS_MODULE       16
 
 /* Allow ioperm/iopl access */
diff --git a/include/linux/security.h b/include/linux/security.h
index 02fcc0e..522d387 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,6 +49,11 @@ struct ctl_table;
 struct audit_krule;
 
 /*
+ * Global bounding set
+ */
+extern kernel_cap_t global_cap_bset;
+
+/*
  * These functions are in security/capability.c and are used
  * as the default capabilities functions
  */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 7bb5cb6..4e80767 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -153,6 +153,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_CAP_BSET=77,	/* int: global capability bset */
 };
 
 
@@ -968,6 +969,8 @@ extern int proc_dostring(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
+extern int proc_dointvec_bset(struct ctl_table *, int, struct file *,
+			      void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5abfa15..6843f85 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -166,6 +166,8 @@ static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_cap_bset(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -428,6 +430,12 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cap-bound",
+		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
+		.mode		= 0600,
+		.proc_handler	= proc_cap_bset,
+	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
@@ -2365,6 +2373,54 @@ int proc_dointvec(struct ctl_table *table, int write,
 }
 
 /*
+ * CAP_SYS_MODULE needed to drop bits.
+ */
+static int proc_cap_bset(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	unsigned long bset[_KERNEL_CAPABILITY_U32S];
+	kernel_cap_t new_bset;
+	int err, i;
+
+	if (write && !capable(CAP_SYS_MODULE))
+		return -EPERM;
+
+	/*
+	 * convert from the global kernel_cap_t to the ulong array to print to
+	 * userspace if this is a read.
+	 */
+	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
+		bset[i] = global_cap_bset.cap[i];
+
+	t = *table;
+	t.data = &bset;
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
+		new_bset.cap[i] = bset[i];
+
+	/*
+	 * Drop everything not in the new_bset (but don't add things)
+	 */
+	if (write)
+		global_cap_bset = cap_intersect(global_cap_bset, new_bset);
+
+	return 0;
+}
+
+/*
  * Taint values can only be increased
  * This means we can safely use a temporary.
  */
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..6486633 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -71,6 +71,8 @@ static const struct bin_table bin_kern_table[] = {
 	{ CTL_STR,	KERN_NODENAME,			"hostname" },
 	{ CTL_STR,	KERN_DOMAINNAME,		"domainname" },
 
+	{ CTL_INT,	KERN_CAP_BSET,			"cap-bound" },
+
 	{ CTL_INT,	KERN_PANIC,			"panic" },
 	{ CTL_INT,	KERN_REALROOTDEV,		"real-root-dev" },
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 64c2ed9..e615224 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -11,6 +11,7 @@
 #include <linux/audit.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/init_task.h> /* CAP_INIT_BSET */
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/file.h>
@@ -28,6 +29,8 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 
+kernel_cap_t global_cap_bset = CAP_INIT_BSET;    /* systemwide capability bound */
+
 /*
  * If a non-root user executes a setuid-root binary in
  * !secure(SECURE_NOROOT) mode, then we raise capabilities.
@@ -201,6 +204,9 @@ int cap_capset(struct cred *new,
 	       const kernel_cap_t *inheritable,
 	       const kernel_cap_t *permitted)
 {
+	kernel_cap_t bset = cap_intersect(old->cap_bset,
+					  global_cap_bset);
+
 	if (cap_inh_is_capped() &&
 	    !cap_issubset(*inheritable,
 			  cap_combine(old->cap_inheritable,
@@ -209,8 +215,7 @@ int cap_capset(struct cred *new,
 		return -EPERM;
 
 	if (!cap_issubset(*inheritable,
-			  cap_combine(old->cap_inheritable,
-				      old->cap_bset)))
+			  cap_combine(old->cap_inheritable, bset)))
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
 
@@ -305,6 +310,8 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
 		new->cap_permitted.cap[i] =
 			(new->cap_bset.cap[i] & permitted) |
 			(new->cap_inheritable.cap[i] & inheritable);
+		/* the global set is global damn it */
+		new->cap_permitted.cap[i] &= global_cap_bset.cap[i];
 
 		if (permitted & ~new->cap_permitted.cap[i])
 			/* insufficient to execute correctly */
@@ -438,6 +445,9 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 		return ret;
 
 	if (!issecure(SECURE_NOROOT)) {
+		kernel_cap_t bset = cap_intersect(old->cap_bset,
+						  global_cap_bset);
+
 		/*
 		 * If the legacy file capability is set, then don't set privs
 		 * for a setuid root binary run by a non-root user.  Do set it
@@ -456,8 +466,7 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 		 */
 		if (new->euid == 0 || new->uid == 0) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
-			new->cap_permitted = cap_combine(old->cap_bset,
-							 old->cap_inheritable);
+			new->cap_permitted = cap_combine(bset, old->cap_inheritable);
 		}
 		if (new->euid == 0)
 			effective = true;


