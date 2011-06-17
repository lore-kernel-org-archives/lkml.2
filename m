Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab1FQOvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:51:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64494 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296Ab1FQOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ajTyOOfoT/HVr2X7JognIHcsNx3wq2wM4pa+VPCjZGw2tPsk1Nx2y+qYdcF5JvcrPk
         u8qlvZBhM+QujSknPHUoqqnKWVmKeNll7AcvUEVUL7y/u49WDdzp54XQKRagelsiovhU
         yY05FFinfxDd6fVeh2N3+xigFLNyCf0DiZYQw=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] ptrace: introduce ptrace_event_enabled() and simplify ptrace_event() and tracehook_prepare_clone()
Date: Fri, 17 Jun 2011 16:50:35 +0200
Message-Id: <1308322240-8247-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements ptrace_event_enabled() which tests whether a
given PTRACE_EVENT_* is enabled and use it to simplify ptrace_event()
and tracehook_prepare_clone().

PT_EVENT_FLAG() macro is added which calculates PT_TRACE_* flag from
PTRACE_EVENT_*.  This is used to define PT_TRACE_* flags and by
ptrace_event_enabled() to find the matching flag.

This is used to make ptrace_event() and tracehook_prepare_clone()
simpler.

* ptrace_event() callers were responsible for providing mask to test
  whether the event was enabled.  This patch implements
  ptrace_event_enabled() and make ptrace_event() drop @mask and
  determine whether the event is enabled from @event.  Note that
  @event is constant and this conversion doesn't add runtime overhead.

  All conversions except tracehook_report_clone_complete() are
  trivial.  tracehook_report_clone_complete() used to use 0 for @mask
  (always enabled) but now tests whether the specified event is
  enabled.  This doesn't cause any behavior difference as it's
  guaranteed that the event specified by @trace is enabled.

* tracehook_prepare_clone() now only determines which event is
  applicable and use ptrace_event_enabled() for enable test.

This doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h    |   46 +++++++++++++++++++++++++++++++-------------
 include/linux/tracehook.h |   26 ++++++++++++------------
 2 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 3ff20b3..18feac6 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -90,12 +90,17 @@
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 #define PT_TRACESYSGOOD	0x00000004
 #define PT_PTRACE_CAP	0x00000008	/* ptracer can follow suid-exec */
-#define PT_TRACE_FORK	0x00000010
-#define PT_TRACE_VFORK	0x00000020
-#define PT_TRACE_CLONE	0x00000040
-#define PT_TRACE_EXEC	0x00000080
-#define PT_TRACE_VFORK_DONE	0x00000100
-#define PT_TRACE_EXIT	0x00000200
+
+/* PT_TRACE_* event enable flags */
+#define PT_EVENT_FLAG_SHIFT	4
+#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
+
+#define PT_TRACE_FORK		PT_EVENT_FLAG(PTRACE_EVENT_FORK)
+#define PT_TRACE_VFORK		PT_EVENT_FLAG(PTRACE_EVENT_VFORK)
+#define PT_TRACE_CLONE		PT_EVENT_FLAG(PTRACE_EVENT_CLONE)
+#define PT_TRACE_EXEC		PT_EVENT_FLAG(PTRACE_EVENT_EXEC)
+#define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
+#define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 
 #define PT_TRACE_MASK	0x000003f4
 
@@ -146,25 +151,38 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
 			    unsigned long data);
 
 /**
+ * ptrace_event_enabled - test whether a ptrace event is enabled
+ * @task: ptracee of interest
+ * @event: %PTRACE_EVENT_* to test
+ *
+ * Test whether @event is enabled for ptracee @task.
+ *
+ * Returns %true if @event is enabled, %false otherwise.
+ */
+static inline bool ptrace_event_enabled(struct task_struct *task, int event)
+{
+	return task->ptrace & PT_EVENT_FLAG(event);
+}
+
+/**
  * ptrace_event - possibly stop for a ptrace event notification
- * @mask:	%PT_* bit to check in @current->ptrace
- * @event:	%PTRACE_EVENT_* value to report if @mask is set
+ * @event:	%PTRACE_EVENT_* value to report
  * @message:	value for %PTRACE_GETEVENTMSG to return
  *
- * This checks the @mask bit to see if ptrace wants stops for this event.
- * If so we stop, reporting @event and @message to the ptrace parent.
+ * Check whether @event is enabled and, if so, report @event and @message
+ * to the ptrace parent.
  *
  * Returns nonzero if we did a ptrace notification, zero if not.
  *
  * Called without locks.
  */
-static inline int ptrace_event(int mask, int event, unsigned long message)
+static inline int ptrace_event(int event, unsigned long message)
 {
-	if (mask && likely(!(current->ptrace & mask)))
-		return 0;
+	if (likely(!ptrace_event_enabled(current, event)))
+		return false;
 	current->ptrace_message = message;
 	ptrace_notify((event << 8) | SIGTRAP);
-	return 1;
+	return true;
 }
 
 /**
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index a3e8387..7d38571 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -201,7 +201,7 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 					 struct linux_binprm *bprm,
 					 struct pt_regs *regs)
 {
-	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
+	if (!ptrace_event(PTRACE_EVENT_EXEC, 0) &&
 	    unlikely(current->ptrace & PT_PTRACED))
 		send_sig(SIGTRAP, current, 0);
 }
@@ -218,7 +218,7 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
  */
 static inline void tracehook_report_exit(long *exit_code)
 {
-	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+	ptrace_event(PTRACE_EVENT_EXIT, *exit_code);
 }
 
 /**
@@ -232,19 +232,19 @@ static inline void tracehook_report_exit(long *exit_code)
  */
 static inline int tracehook_prepare_clone(unsigned clone_flags)
 {
+	int event = 0;
+
 	if (clone_flags & CLONE_UNTRACED)
 		return 0;
 
-	if (clone_flags & CLONE_VFORK) {
-		if (current->ptrace & PT_TRACE_VFORK)
-			return PTRACE_EVENT_VFORK;
-	} else if ((clone_flags & CSIGNAL) != SIGCHLD) {
-		if (current->ptrace & PT_TRACE_CLONE)
-			return PTRACE_EVENT_CLONE;
-	} else if (current->ptrace & PT_TRACE_FORK)
-		return PTRACE_EVENT_FORK;
+	if (clone_flags & CLONE_VFORK)
+		event = PTRACE_EVENT_VFORK;
+	else if ((clone_flags & CSIGNAL) != SIGCHLD)
+		event = PTRACE_EVENT_CLONE;
+	else
+		event = PTRACE_EVENT_FORK;
 
-	return 0;
+	return ptrace_event_enabled(current, event) ? event : 0;
 }
 
 /**
@@ -318,7 +318,7 @@ static inline void tracehook_report_clone_complete(int trace,
 						   struct task_struct *child)
 {
 	if (unlikely(trace))
-		ptrace_event(0, trace, pid);
+		ptrace_event(trace, pid);
 }
 
 /**
@@ -336,7 +336,7 @@ static inline void tracehook_report_clone_complete(int trace,
 static inline void tracehook_report_vfork_done(struct task_struct *child,
 					       pid_t pid)
 {
-	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
+	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
 }
 
 /**
-- 
1.7.5.4

