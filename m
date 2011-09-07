Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1IGEr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:47:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38461 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1IGErX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:47:23 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v3] Fix clearing of task->ptrace if PTRACE_SETOPTIONS fails
Date: Wed, 7 Sep 2011 06:45:00 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
References: <201109042311.18793.vda.linux@googlemail.com> <1315327963.29637.1.camel@dhcp-25-63.brq.redhat.com> <20110906184346.GA25904@redhat.com>
In-Reply-To: <20110906184346.GA25904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109070645.00481.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix clearing of task->ptrace if PTRACE_SETOPTIONS fails.
    
If PTRACE_SETOPTIONS fails, options should not be affected.
This patch makes it so.
    
Every PTRACE_O_TRACEevent is defined to (1 << PTRACE_EVENT_event)
instead of using explicit numeric constants, to ensure we don't
mess up relationship between bit positions and event ids.
    
While at it, simplify a few things:
    
Exchange PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which makes
PT_option bits contiguous and therefore makes code in ptrace_setoptions()
much simpler.
    
PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
value of PT_EVENT_FLAG_SHIFT-1 is easier to use.
    
PT_TRACE_MASK constant is nuked, the only its use is replaced by
(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).
    
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 800f113..0911100 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -54,17 +54,6 @@
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD	0x00000001
-#define PTRACE_O_TRACEFORK	0x00000002
-#define PTRACE_O_TRACEVFORK	0x00000004
-#define PTRACE_O_TRACECLONE	0x00000008
-#define PTRACE_O_TRACEEXEC	0x00000010
-#define PTRACE_O_TRACEVFORKDONE	0x00000020
-#define PTRACE_O_TRACEEXIT	0x00000040
-
-#define PTRACE_O_MASK		0x0000007f
-
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
@@ -74,6 +63,17 @@
 #define PTRACE_EVENT_EXIT	6
 #define PTRACE_EVENT_STOP	7
 
+/* options set using PTRACE_SETOPTIONS */
+#define PTRACE_O_TRACESYSGOOD	1
+#define PTRACE_O_TRACEFORK	(1 << PTRACE_EVENT_FORK)
+#define PTRACE_O_TRACEVFORK	(1 << PTRACE_EVENT_VFORK)
+#define PTRACE_O_TRACECLONE	(1 << PTRACE_EVENT_CLONE)
+#define PTRACE_O_TRACEEXEC	(1 << PTRACE_EVENT_EXEC)
+#define PTRACE_O_TRACEVFORKDONE	(1 << PTRACE_EVENT_VFORK_DONE)
+#define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
+
+#define PTRACE_O_MASK		0x0000007f
+
 #include <asm/ptrace.h>
 
 #ifdef __KERNEL__
@@ -88,13 +88,12 @@
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
-#define PT_TRACESYSGOOD	0x00000004
-#define PT_PTRACE_CAP	0x00000008	/* ptracer can follow suid-exec */
+#define PT_PTRACE_CAP	0x00000004	/* ptracer can follow suid-exec */
 
+#define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */
-#define PT_EVENT_FLAG_SHIFT	4
-#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
-
+#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))
+#define PT_TRACESYSGOOD		PT_EVENT_FLAG(0)
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
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9de3ecf..665ee93 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -243,7 +243,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	/*
 	 * Protect exec's credential calculations against our interference;
-	 * interference; SUID, SGID and LSM creds get determined differently
+	 * SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
@@ -509,30 +509,13 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 
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
