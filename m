Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1CCC6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:58:08 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44378 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1CCC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:58:07 -0500
Date: Wed, 2 Mar 2011 20:58:02 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, Nathan Lynch <ntl@pobox.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH mmotm 3/3] userns: make has_capability* into real functions
Message-ID: <20110303025802.GB10138@peq.hallyn.com>
References: <20110303025603.GA10071@peq.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303025603.GA10071@peq.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we can let type safety keep things sane, and as a bonus we can
remove the declaration of init_user_ns in capability.h.

---
 include/linux/capability.h |   34 +++-----------------------
 kernel/capability.c        |   57 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 30 deletions(-)

Index: linux-2.6/include/linux/capability.h
===================================================================
--- linux-2.6.orig/include/linux/capability.h	2011-03-03 02:17:17.533467959 +0000
+++ linux-2.6/include/linux/capability.h	2011-03-03 02:26:56.524786760 +0000
@@ -371,8 +371,6 @@
 struct dentry;
 struct user_namespace;
 
-extern struct user_namespace init_user_ns;
-
 struct user_namespace *current_user_ns(void);
 
 extern const kernel_cap_t __cap_empty_set;
@@ -541,34 +539,10 @@
 			   cap_intersect(permitted, __cap_nfsd_set));
 }
 
-/**
- * has_capability - Determine if a task has a superior capability available
- * @t: The task in question
- * @cap: The capability to be tested for
- *
- * Return true if the specified task has the given superior capability
- * currently in effect, false if not.
- *
- * Note that this does not set PF_SUPERPRIV on the task.
- */
-#define has_capability(t, cap) (security_real_capable((t), &init_user_ns, (cap)) == 0)
-
-#define has_ns_capability(t, ns, cap) (security_real_capable((t), (ns), (cap)) == 0)
-
-/**
- * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
- * @t: The task in question
- * @cap: The capability to be tested for
- *
- * Return true if the specified task has the given superior capability
- * currently in effect, false if not, but don't write an audit message for the
- * check.
- *
- * Note that this does not set PF_SUPERPRIV on the task.
- */
-#define has_capability_noaudit(t, cap) \
-	(security_real_capable_noaudit((t), &init_user_ns, (cap)) == 0)
-
+extern bool has_capability(struct task_struct *t, int cap);
+extern bool has_ns_capability(struct task_struct *t,
+			      struct user_namespace *ns, int cap);
+extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool capable(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
 extern bool task_ns_capable(struct task_struct *t, int cap);
Index: linux-2.6/kernel/capability.c
===================================================================
--- linux-2.6.orig/kernel/capability.c	2011-03-03 02:17:17.523467247 +0000
+++ linux-2.6/kernel/capability.c	2011-03-03 02:52:11.652778780 +0000
@@ -291,6 +291,60 @@
 }
 
 /**
+ * has_capability - Does a task have a capability in init_user_ns
+ * @t: The task in question
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to the initial user namespace, false if not.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_capability(struct task_struct *t, int cap)
+{
+	int ret = security_real_capable(t, &init_user_ns, cap);
+
+	return (ret == 0);
+}
+
+/**
+ * has_capability - Does a task have a capability in a specific user ns
+ * @t: The task in question
+ * @ns: target user namespace
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to the specified user namespace, false if not.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_ns_capability(struct task_struct *t,
+		       struct user_namespace *ns, int cap)
+{
+	int ret = security_real_capable(t, ns, cap);
+
+	return (ret == 0);
+}
+
+/**
+ * has_capability_noaudit - Does a task have a capability (unaudited)
+ * @t: The task in question
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to init_user_ns, false if not.  Don't write an
+ * audit message for the check.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_capability_noaudit(struct task_struct *t, int cap)
+{
+	int ret = security_real_capable_noaudit(t, &init_user_ns, cap);
+
+	return (ret == 0);
+}
+
+/**
  * capable - Determine if the current task has a superior capability in effect
  * @cap: The capability to be tested for
  *
