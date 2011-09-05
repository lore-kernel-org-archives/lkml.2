Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab1IEQvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1IEQvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:51:15 -0400
Subject: [PATCH 1/2] Fix pollution of task->ptrace if PTRACE_SETOPTIONS
 fails.
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Sep 2011 18:51:03 +0200
References: <201109042311.18793.vda.linux@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315241465.1888.49.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A crude patch is below. It rolls points 1-4 from above into a single
> new option, PTRACE_O_TRACESTOP.


For easier review, split it into two parts. Part 1 follows.
(It is still not even compile-tested).
-- 
vda


Fix pollution of task->ptrace if PTRACE_SETOPTIONS fails.


If PTRACE_SETOPTIONS fails, options should not be affected.

While at it, simplified ptrace_setoptions():

Exchanged PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which made
PT_option bits contiguous and therefore made ptrace_setoptions much
simpler.

PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
value of PT_EVENT_FLAG_SHIFT-1 is easier to use.

PT_TRACE_MASK constant is nuked, the only its use is replaced by
(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>


diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 800f113..9aa669c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -88,13 +88,12 @@
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
-#define PT_TRACESYSGOOD	0x00000004
-#define PT_PTRACE_CAP	0x00000008	/* ptracer can follow suid-exec */
+#define PT_PTRACE_CAP	0x00000004	/* ptracer can follow suid-exec */
 
+#define PT_OPT_FLAG_SHIFT	3
+#define PT_TRACESYSGOOD	0x00000008	/* must be directly before PT_TRACE_event bits! */
 /* PT_TRACE_* event enable flags */
-#define PT_EVENT_FLAG_SHIFT	4
-#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
-
+#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))
 #define PT_TRACE_FORK		PT_EVENT_FLAG(PTRACE_EVENT_FORK)
 #define PT_TRACE_VFORK		PT_EVENT_FLAG(PTRACE_EVENT_VFORK)
 #define PT_TRACE_CLONE		PT_EVENT_FLAG(PTRACE_EVENT_CLONE)
@@ -102,8 +101,6 @@
 #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 
-#define PT_TRACE_MASK	0x000003f4
-
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
@@ -228,7 +225,7 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 
-		if (child->ptrace & PT_SEIZED)
+		if (child->ptrace & PTRACE_EVENT_STOP)
 			task_set_jobctl_pending(child, JOBCTL_TRAP_STOP);
 		else
 			sigaddset(&child->pending.signal, SIGSTOP);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9de3ecf..9c3536d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -219,19 +219,23 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	/*
 	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL is used to prevent applications
+	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
 	 * expecting full SEIZE behaviors trapping on kernel commits which
 	 * are still in the process of implementing them.
 	 *
 	 * Only test programs for new ptrace behaviors being implemented
 	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
 	 *
-	 * Once SEIZE behaviors are completely implemented, this flag and
-	 * the following test will be removed.
+	 * Once SEIZE behaviors are completely implemented, this flag
+	 * will be removed.
 	 */
 	retval = -EIO;
-	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
-		goto out;
+	if (seize) {
+		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
+			goto out;
+		flags &= ~PTRACE_SEIZE_DEVEL;
+	} else
+		flags = 0;
 
 	audit_ptrace(task);
 
@@ -243,7 +247,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	/*
 	 * Protect exec's credential calculations against our interference;
-	 * interference; SUID, SGID and LSM creds get determined differently
+	 * SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
@@ -509,30 +513,13 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
-	child->ptrace &= ~PT_TRACE_MASK;
-
-	if (data & PTRACE_O_TRACESYSGOOD)
-		child->ptrace |= PT_TRACESYSGOOD;
-
-	if (data & PTRACE_O_TRACEFORK)
-		child->ptrace |= PT_TRACE_FORK;
-
-	if (data & PTRACE_O_TRACEVFORK)
-		child->ptrace |= PT_TRACE_VFORK;
-
-	if (data & PTRACE_O_TRACECLONE)
-		child->ptrace |= PT_TRACE_CLONE;
-
-	if (data & PTRACE_O_TRACEEXEC)
-		child->ptrace |= PT_TRACE_EXEC;
-
-	if (data & PTRACE_O_TRACEVFORKDONE)
-		child->ptrace |= PT_TRACE_VFORK_DONE;
+	if (data & ~(long)PTRACE_O_MASK)
+		return -EINVAL;
 
-	if (data & PTRACE_O_TRACEEXIT)
-		child->ptrace |= PT_TRACE_EXIT;
+	child->ptrace &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
+	child->ptrace |= (data << PT_OPT_FLAG_SHIFT);
 
-	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
+	return 0;
 }
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)



