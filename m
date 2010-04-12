Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0DLGGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:06:14 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11117 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0DLGGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:06:10 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVwkurRN+J/2dsb2JhbACbM3GhN5gUhQwEgyU
X-IronPort-AV: E=Sophos;i="4.52,188,1270425600"; 
   d="scan'208";a="113731706"
Date: Sun, 11 Apr 2010 23:06:09 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: [PATCH 1/23] Make register values available to panic notifiers
Message-ID: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes panic() and die() registers available to, for example,
panic notifier functions.  Panic notifier functions are quite useful
for recording crash information, but they don't get passed the register
values. This makes it hard to print register contents, do stack
backtraces, etc. The changes in this patch save the register state when
panic() is called and introduce a function for die() to call that allows
it to pass in the registers it was passed.

Following this patch are more patches, one per architecture. These include
two types of changes:
o  A save_ptregs() function for the processor. I've taken a whack at
   doing this for all of the processors. I have tested x86 and MIPS
   versions. I was able to find cross compilers for ARM, ... and the
   code compiles cleanly. Everything else, well, what you see is sheer
   fantasy. You are welcome to chortle with merriment.
o  When I could figure it out, I replaced the calls to panic() in
   exception handling functions with calls to panic_with_regs() so
   that everyone can leverage these changes without much effort. Again,
   not all the code was transparent, so there are likely some places
   that should have additional work done.

Note that the pointer to the struct pt_regs may be NULL. This is to
accomodate those processors which don't have a working save_ptregs(). I'd
love to eliminate this case by providing a save_ptregs() for all
architectures, but I'll need help to so.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 include/linux/kernel.h |    5 ++
 include/linux/ptrace.h |    9 ++++
 include/linux/ptreg.h  |   62 +++++++++++++++++++++++++++++++
 kernel/panic.c         |   96 +++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 159 insertions(+), 13 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 328bca6..d73ae5c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -162,6 +162,11 @@ extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+NORET_TYPE void panic_with_regs(const struct pt_regs *regs,
+	const char *fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 2, 3))) __cold;
+const struct pt_regs *get_panic_regs(void);
+extern const struct pt_regs *set_panic_regs(const struct pt_regs *regs);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 56f2d63..8f477ff 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -336,6 +336,15 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
+#ifndef arch_has_save_ptregs
+#warning save_ptregs undefined for this architecture; please define it soon
+
+static const struct pt_regs *save_ptregs(const struct pt_regs *regs)
+{
+	return NULL;
+}
+#endif
+
 #endif
 
 #endif
diff --git a/include/linux/ptreg.h b/include/linux/ptreg.h
new file mode 100644
index 0000000..f8cc2ea
--- /dev/null
+++ b/include/linux/ptreg.h
@@ -0,0 +1,62 @@
+/*
+ * Define macros for saving registers in a struct pt_regs structure
+ *
+ * Copyright (C) 2009 Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef _LINUX_PTREG_H_
+#define _LINUX_PTREG_H_
+/*
+ * Define macros useful for writing save_ptregs(). Each architecture will
+ * need to define some macros, and some architectures have special cases
+ * that are most easily done as a special case. Macros that must be defined
+ * per architecture are:
+ *
+ * PTREG_SAVE - Save a register in a named location
+ * @r:		Name of the register to save
+ * @name:	%[name] of the location
+ *
+ * This is used in cases where the entry in the struct pt_regs is a simple
+ * string that doesn't end with a digit, e.g. pc.
+ *
+ * PTREG_INDIRECT_SAVE - move register to another register for saving
+ * @tmp_r:	Name of a temporary register
+ * @r:		Name of the register to be saved
+ * @name:	%[name] of the location
+ *
+ * This is used for cases where the register can't be saved directly,
+ * but must first be moved to another register that can be saved
+ * directly. The second register must already have been saved
+ * by the time this macro is used.
+ */
+
+/* Register save macro where the pt_regs item is an array, e.g. r[0] */
+#define _PTREG_SAVE_IDX(r, name, i)	PTREG_SAVE(r##i, name##i)
+
+/* Save register where the pt_regs item ends with a digit, e.g. r0. */
+#define _PTREG_SAVE_I(r, name, i)	PTREG_SAVE(r##i, name##i)
+
+/* Save register where it must first be copied to another register and where
+ * the pt_regs element ends with a digit, e.g. a2 */
+#define _PTREG_INDIRECT_SAVE_I(tmp, r, name, i) \
+					PTREG_INDIRECT_SAVE(tmp, r##i, name##i)
+
+/* Output specification */
+#define PTREG_OUT(rp, r, name)		[name] "=m" (rp->r)
+#define _PTREG_OUT_IDX(rp, r, name, i)	PTREG_OUT(rp, r[i], name##i)
+#define _PTREG_OUT_I(rp, r, name, i)	PTREG_OUT(rp, r##i, name##i)
+#endif
diff --git a/kernel/panic.c b/kernel/panic.c
index c787333..ef500c7 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -46,28 +46,22 @@ long (*panic_blink)(long time);
 EXPORT_SYMBOL(panic_blink);
 
 /**
- *	panic - halt the system
- *	@fmt: The text string to print
- *
- *	Display a message, then perform cleanups.
- *
- *	This function never returns.
+ * vpanic_with_regs - panic with specific register values and a argument array
+ * @regs:	Pointer to a &struct pt_reg with the register values
+ * @fmt:	Format for the panic message
+ * @args:	Arguments for the panic message as a va_list
  */
-NORET_TYPE void panic(const char * fmt, ...)
+static NORET_TYPE void vpanic_with_regs(const struct pt_regs *regs,
+	const char *fmt, va_list args)
 {
 	static char buf[1024];
-	va_list args;
 	long i;
-
 	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
 	 */
-	preempt_disable();
-
-	bust_spinlocks(1);
-	va_start(args, fmt);
+	set_panic_regs(regs);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
@@ -143,8 +137,84 @@ NORET_TYPE void panic(const char * fmt, ...)
 	}
 }
 
+/* Registers stored in calls to panic() */
+static DEFINE_PER_CPU(struct pt_regs, panic_panic_regs);
+static DEFINE_PER_CPU(const struct pt_regs *, panic_regs);
+
+/**
+ * get_panic_regs - return the current pointer to panic register values
+ */
+const struct pt_regs *get_panic_regs()
+{
+	return __get_cpu_var(panic_regs);
+}
+EXPORT_SYMBOL(get_panic_regs);
+
+/**
+ * set_panic_regs - Set a pointer to the values of registers on panic()
+ * @new_regs:	Pointer to register values
+ *
+ * Returns: Pointer to the previous panic registers, if any.
+ */
+const struct pt_regs *set_panic_regs(const struct pt_regs *new_regs)
+{
+	const struct pt_regs *old_regs, **pp_regs;
+
+	pp_regs = &__get_cpu_var(panic_regs);
+	old_regs = *pp_regs;
+	*pp_regs = new_regs;
+	return old_regs;
+}
+
+/**
+ *	panic - halt the system
+ *	@fmt: The text string to print
+ *
+ *	Display a message, then perform cleanups.
+ *
+ *	This function never returns.
+ */
+NORET_TYPE void panic(const char *fmt, ...)
+{
+	va_list args;
+	const struct pt_regs *regs;
+	int i;
+
+	preempt_disable();
+	bust_spinlocks(1);
+	regs = save_ptregs(&__get_cpu_var(panic_panic_regs));
+	va_start(args, fmt);
+	vpanic_with_regs(regs, fmt, args);
+	/* Since vpanic_with_regs doesn't return, we skip va_end() */
+	/* Infinite loop so compiler doesn't complain about this returning */
+	for (i = 0; ; )
+		mdelay(1);
+}
 EXPORT_SYMBOL(panic);
 
+/**
+ * panic_with_regs - panic with specific register values
+ * @regs:	Pointer to a &struct pt_reg with the register values
+ * @fmt:	Format for the panic message
+ * @...:	Arguments for the panic message
+ */
+NORET_TYPE void panic_with_regs(const struct pt_regs *regs, const char *fmt,
+	...)
+{
+	va_list args;
+	int i;
+
+	preempt_disable();
+	bust_spinlocks(1);
+	va_start(args, fmt);
+	vpanic_with_regs(regs, fmt, args);
+	/* Since vpanic_with_regs doesn't return, we skip va_end() */
+	/* Infinite loop so compiler doesn't complain about this returning */
+	for (i = 0; ; )
+		mdelay(1);
+}
+EXPORT_SYMBOL(panic_with_regs);
+
 
 struct tnt {
 	u8	bit;
