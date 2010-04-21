Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0DUOVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:21:54 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39447 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0DUOVx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 21 Apr 2010 10:21:53 -0400
Message-Id: <4BCF261F020000780003B33C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 15:21:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: introduce and use percpu_inc()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... generating slightly smaller code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/hardirq.h   |    2 +-
 arch/x86/include/asm/percpu.h    |   24 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 3 files changed, 27 insertions(+), 3 deletions(-)

--- linux-2.6.34-rc5/arch/x86/include/asm/hardirq.h	2010-02-24 19:52:17.000000000 +0100
+++ 2.6.34-rc5-x86-inc-percpu/arch/x86/include/asm/hardirq.h	2010-04-15 11:58:06.000000000 +0200
@@ -35,7 +35,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
+#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
 
 #define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
 
--- linux-2.6.34-rc5/arch/x86/include/asm/percpu.h	2010-04-20 16:07:41.000000000 +0200
+++ 2.6.34-rc5-x86-inc-percpu/arch/x86/include/asm/percpu.h	2010-04-15 11:58:06.000000000 +0200
@@ -190,6 +190,29 @@ do {									\
 	pfo_ret__;					\
 })
 
+#define percpu_unary_op(op, var)			\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
@@ -207,6 +230,7 @@ do {									\
 #define percpu_and(var, val)		percpu_to_op("and", var, val)
 #define percpu_or(var, val)		percpu_to_op("or", var, val)
 #define percpu_xor(var, val)		percpu_to_op("xor", var, val)
+#define percpu_inc(var)		percpu_unary_op("inc", var)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
--- linux-2.6.34-rc5/arch/x86/kernel/cpu/mcheck/mce.c	2010-04-20 16:07:42.000000000 +0200
+++ 2.6.34-rc5-x86-inc-percpu/arch/x86/kernel/cpu/mcheck/mce.c	2010-04-15 11:58:06.000000000 +0200
@@ -539,7 +539,7 @@ void machine_check_poll(enum mcp_flags f
 	struct mce m;
 	int i;
 
-	__get_cpu_var(mce_poll_count)++;
+	percpu_inc(mce_poll_count);
 
 	mce_setup(&m);
 
@@ -934,7 +934,7 @@ void do_machine_check(struct pt_regs *re
 
 	atomic_inc(&mce_entry);
 
-	__get_cpu_var(mce_exception_count)++;
+	percpu_inc(mce_exception_count);
 
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)



