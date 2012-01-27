Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2A0CpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:53813 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2A0CpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:45:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/7] x86: relocate get/set debugreg fcns to include/asm/debugreg.
Date: Thu, 26 Jan 2012 21:44:26 -0500
Message-Id: <1327632272-12928-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we already have a debugreg.h header file, move the
assoc. get/set functions to it.  In addition to it being the
logical home for them, it has a secondary advantage.  The
functions that are moved use BUG().  So we really need to
have linux/bug.h in scope.  But asm/processor.h is used about
600 times, vs. only about 15 for debugreg.h -- so adding bug.h
to the latter reduces the amount of time we'll be processing
it during a compile.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/debugreg.h  |   67 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h |   63 -----------------------------------
 arch/x86/kernel/cpu/common.c     |    1 +
 3 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b903d5e..2d91580 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -78,8 +78,75 @@
  */
 #ifdef __KERNEL__
 
+#include <linux/bug.h>
+
 DECLARE_PER_CPU(unsigned long, cpu_dr7);
 
+#ifndef CONFIG_PARAVIRT
+/*
+ * These special macros can be used to get or set a debugging register
+ */
+#define get_debugreg(var, register)				\
+	(var) = native_get_debugreg(register)
+#define set_debugreg(value, register)				\
+	native_set_debugreg(register, value)
+#endif
+
+static inline unsigned long native_get_debugreg(int regno)
+{
+	unsigned long val = 0;	/* Damn you, gcc! */
+
+	switch (regno) {
+	case 0:
+		asm("mov %%db0, %0" :"=r" (val));
+		break;
+	case 1:
+		asm("mov %%db1, %0" :"=r" (val));
+		break;
+	case 2:
+		asm("mov %%db2, %0" :"=r" (val));
+		break;
+	case 3:
+		asm("mov %%db3, %0" :"=r" (val));
+		break;
+	case 6:
+		asm("mov %%db6, %0" :"=r" (val));
+		break;
+	case 7:
+		asm("mov %%db7, %0" :"=r" (val));
+		break;
+	default:
+		BUG();
+	}
+	return val;
+}
+
+static inline void native_set_debugreg(int regno, unsigned long value)
+{
+	switch (regno) {
+	case 0:
+		asm("mov %0, %%db0"	::"r" (value));
+		break;
+	case 1:
+		asm("mov %0, %%db1"	::"r" (value));
+		break;
+	case 2:
+		asm("mov %0, %%db2"	::"r" (value));
+		break;
+	case 3:
+		asm("mov %0, %%db3"	::"r" (value));
+		break;
+	case 6:
+		asm("mov %0, %%db6"	::"r" (value));
+		break;
+	case 7:
+		asm("mov %0, %%db7"	::"r" (value));
+		break;
+	default:
+		BUG();
+	}
+}
+
 static inline void hw_breakpoint_disable(void)
 {
 	/* Zero the control register for HW Breakpoint */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..b6f7d5a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -472,61 +472,6 @@ struct thread_struct {
 	unsigned		io_bitmap_max;
 };
 
-static inline unsigned long native_get_debugreg(int regno)
-{
-	unsigned long val = 0;	/* Damn you, gcc! */
-
-	switch (regno) {
-	case 0:
-		asm("mov %%db0, %0" :"=r" (val));
-		break;
-	case 1:
-		asm("mov %%db1, %0" :"=r" (val));
-		break;
-	case 2:
-		asm("mov %%db2, %0" :"=r" (val));
-		break;
-	case 3:
-		asm("mov %%db3, %0" :"=r" (val));
-		break;
-	case 6:
-		asm("mov %%db6, %0" :"=r" (val));
-		break;
-	case 7:
-		asm("mov %%db7, %0" :"=r" (val));
-		break;
-	default:
-		BUG();
-	}
-	return val;
-}
-
-static inline void native_set_debugreg(int regno, unsigned long value)
-{
-	switch (regno) {
-	case 0:
-		asm("mov %0, %%db0"	::"r" (value));
-		break;
-	case 1:
-		asm("mov %0, %%db1"	::"r" (value));
-		break;
-	case 2:
-		asm("mov %0, %%db2"	::"r" (value));
-		break;
-	case 3:
-		asm("mov %0, %%db3"	::"r" (value));
-		break;
-	case 6:
-		asm("mov %0, %%db6"	::"r" (value));
-		break;
-	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
-		break;
-	default:
-		BUG();
-	}
-}
-
 /*
  * Set IOPL bits in EFLAGS from given mask
  */
@@ -572,14 +517,6 @@ static inline void native_swapgs(void)
 #define __cpuid			native_cpuid
 #define paravirt_enabled()	0
 
-/*
- * These special macros can be used to get or set a debugging register
- */
-#define get_debugreg(var, register)				\
-	(var) = native_get_debugreg(register)
-#define set_debugreg(value, register)				\
-	native_set_debugreg(register, value)
-
 static inline void load_sp0(struct tss_struct *tss,
 			    struct thread_struct *thread)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..1925d2b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -18,6 +18,7 @@
 #include <asm/archrandom.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
+#include <asm/debugreg.h>
 #include <asm/sections.h>
 #include <linux/topology.h>
 #include <linux/cpumask.h>
-- 
1.7.7.2

