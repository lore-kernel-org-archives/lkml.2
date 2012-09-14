Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2INQgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:36:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47330 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2INQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:36:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] x86: Use the new schedule_user API on userspace preemption
Date: Fri, 14 Sep 2012 18:35:39 +0200
Message-Id: <1347640539-8470-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347640539-8470-1-git-send-email-fweisbec@gmail.com>
References: <1347640539-8470-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can exit the RCU extended quiescent state before
we schedule a new task from irq/exception exit.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/rcu.h |   12 ++++++++++++
 arch/x86/kernel/entry_64.S |    9 +++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/rcu.h
index 439815b..d1ac07a 100644
--- a/arch/x86/include/asm/rcu.h
+++ b/arch/x86/include/asm/rcu.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_RCU_H
 #define _ASM_X86_RCU_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/rcupdate.h>
 #include <asm/ptrace.h>
 
@@ -17,4 +19,14 @@ static inline void exception_exit(struct pt_regs *regs)
 #endif
 }
 
+#else /* __ASSEMBLY__ */
+
+#ifdef CONFIG_RCU_USER_QS
+# define SCHEDULE_USER call schedule_user
+#else
+# define SCHEDULE_USER call schedule
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
 #endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..1a8f3cb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,6 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
+#include <asm/rcu.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -565,7 +566,7 @@ sysret_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	jmp sysret_check
 
@@ -678,7 +679,7 @@ int_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -974,7 +975,7 @@ retint_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call  schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1449,7 +1450,7 @@ paranoid_userspace:
 paranoid_schedule:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
+	SCHEDULE_USER
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
-- 
1.7.5.4

