Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2HMU2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:28:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2HMUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 77/82] Yama: higher restrictions should block PTRACE_TRACEME
Date: Mon, 13 Aug 2012 13:19:53 -0700
Message-Id: <20120813201753.196829407@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 9d8dad742ad1c74d7e7210ee05d0b44961d5ea16 upstream.

The higher ptrace restriction levels should be blocking even
PTRACE_TRACEME requests. The comments in the LSM documentation are
misleading about when the checks happen (the parent does not go through
security_ptrace_access_check() on a PTRACE_TRACEME call).

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/security/Yama.txt |   14 ++++++-------
 include/linux/security.h        |    2 -
 security/yama/yama_lsm.c        |   41 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 9 deletions(-)

--- a/Documentation/security/Yama.txt
+++ b/Documentation/security/Yama.txt
@@ -46,14 +46,13 @@ restrictions, it can call prctl(PR_SET_P
 so that any otherwise allowed process (even those in external pid namespaces)
 may attach.
 
-These restrictions do not change how ptrace via PTRACE_TRACEME operates.
-
-The sysctl settings are:
+The sysctl settings (writable only with CAP_SYS_PTRACE) are:
 
 0 - classic ptrace permissions: a process can PTRACE_ATTACH to any other
     process running under the same uid, as long as it is dumpable (i.e.
     did not transition uids, start privileged, or have called
-    prctl(PR_SET_DUMPABLE...) already).
+    prctl(PR_SET_DUMPABLE...) already). Similarly, PTRACE_TRACEME is
+    unchanged.
 
 1 - restricted ptrace: a process must have a predefined relationship
     with the inferior it wants to call PTRACE_ATTACH on. By default,
@@ -61,12 +60,13 @@ The sysctl settings are:
     classic criteria is also met. To change the relationship, an
     inferior can call prctl(PR_SET_PTRACER, debugger, ...) to declare
     an allowed debugger PID to call PTRACE_ATTACH on the inferior.
+    Using PTRACE_TRACEME is unchanged.
 
 2 - admin-only attach: only processes with CAP_SYS_PTRACE may use ptrace
-    with PTRACE_ATTACH.
+    with PTRACE_ATTACH, or through children calling PTRACE_TRACEME.
 
-3 - no attach: no processes may use ptrace with PTRACE_ATTACH. Once set,
-    this sysctl cannot be changed to a lower value.
+3 - no attach: no processes may use ptrace with PTRACE_ATTACH nor via
+    PTRACE_TRACEME. Once set, this sysctl value cannot be changed.
 
 The original children-only logic was based on the restrictions in grsecurity.
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1242,8 +1242,6 @@ static inline void security_free_mnt_opt
  *	Check that the @parent process has sufficient permission to trace the
  *	current process before allowing the current process to present itself
  *	to the @parent process for tracing.
- *	The parent process will still have to undergo the ptrace_access_check
- *	checks before it is allowed to trace this one.
  *	@parent contains the task_struct structure for debugger process.
  *	Return 0 if permission is granted.
  * @capget:
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -290,10 +290,51 @@ static int yama_ptrace_access_check(stru
 	return rc;
 }
 
+/**
+ * yama_ptrace_traceme - validate PTRACE_TRACEME calls
+ * @parent: task that will become the ptracer of the current task
+ *
+ * Returns 0 if following the ptrace is allowed, -ve on error.
+ */
+static int yama_ptrace_traceme(struct task_struct *parent)
+{
+	int rc;
+
+	/* If standard caps disallows it, so does Yama.  We should
+	 * only tighten restrictions further.
+	 */
+	rc = cap_ptrace_traceme(parent);
+	if (rc)
+		return rc;
+
+	/* Only disallow PTRACE_TRACEME on more aggressive settings. */
+	switch (ptrace_scope) {
+	case YAMA_SCOPE_CAPABILITY:
+		if (!ns_capable(task_user_ns(parent), CAP_SYS_PTRACE))
+			rc = -EPERM;
+		break;
+	case YAMA_SCOPE_NO_ATTACH:
+		rc = -EPERM;
+		break;
+	}
+
+	if (rc) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_NOTICE
+			"ptraceme of pid %d was attempted by: %s (pid %d)\n",
+			current->pid,
+			get_task_comm(name, parent),
+			parent->pid);
+	}
+
+	return rc;
+}
+
 static struct security_operations yama_ops = {
 	.name =			"yama",
 
 	.ptrace_access_check =	yama_ptrace_access_check,
+	.ptrace_traceme =	yama_ptrace_traceme,
 	.task_prctl =		yama_task_prctl,
 	.task_free =		yama_task_free,
 };


