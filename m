Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1IIG3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:29:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1IIG3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:29:37 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
Date: Fri, 9 Sep 2011 08:29:34 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
References: <201109090822.30063.vda.linux@googlemail.com> <201109090824.37366.vda.linux@googlemail.com>
In-Reply-To: <201109090824.37366.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109090829.34222.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code

Exchange PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which makes
PT_option bits contiguous and therefore makes code in ptrace_setoptions()
much simpler.

Every PTRACE_O_TRACEevent is defined to (1 << PTRACE_EVENT_event)
instead of using explicit numeric constants, to ensure we don't
mess up relationship between bit positions and event ids.

PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
value of PT_EVENT_FLAG_SHIFT-1 is easier to use.

PT_TRACE_MASK constant is nuked, the only its use is replaced by
(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---

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
index 02df3c1..6664923 100644
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
@@ -509,31 +509,16 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
+	unsigned flags;
+
 	if (data & ~(unsigned long)PTRACE_O_MASK)
 		return -EINVAL;
 
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
-
-	if (data & PTRACE_O_TRACEEXIT)
-		child->ptrace |= PT_TRACE_EXIT;
+	/* Avoid intermediate state when all opts are cleared */
+	flags = child->ptrace;
+	flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
+	flags |= (data << PT_OPT_FLAG_SHIFT);
+	child->ptrace = flags;
 
 	return 0;
 }
