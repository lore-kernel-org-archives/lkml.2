Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1JLQsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:48:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JLQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:48:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/7] Add assertion support with annotated oopsing
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:47:17 +0100
Message-ID: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to create an annotated oops report.  This is useful for
displaying the output of assertion failures where direct display of the values
being checked is of greater value than the register dump.

This could technically be done simply by issuing one or more printk() calls
followed by a BUG() but in practice this has a serious disadvantage in that
people reporting a bug usually seem to take the "cut here" line literally and
discard everything prior to it when making a report - thus eliminating the most
important bit of information after the file/line number.

There are number of possible solutions to this.  I've used the last in this
list:

 (1) Emit the "cut here" line early, suppressing the one produced by the BUG()
     handler.  This would allow the annotation to be formed of multiple
     printk() calls.

 (2) Get rid of the "cut here" line entirely.

 (3) Pass the annotation through to the exception handler.  For practical
     reasons, this limits the number of annotations to a single format string
     and parameters.  This means that a va_list has to be passed through and
     thence to vprintk() - which should be okay.  It also requires arch support
     to retrieve the annotation data.


This facility can be made use of by #including <linux/assert.h> and then
calling:

	void assertion_failed(const char *fmt, ...);

This prints a report that looks like:

	------------[ cut here ]------------
	ASSERTION FAILED at fs/dcache.c:863!
	invalid opcode: 0000 [#1] SMP
	...

if fmt is NULL and:

	------------[ cut here ]------------
	ASSERTION FAILED at fs/dcache.c:863!
	Dentry 0xffff880032675ed8{i=242,n=Documents} still in use (1) [unmount of nfs 12:01]
	invalid opcode: 0000 [#1] SMP
	...

otherwise.

For this to work the arch code must provide two things:

	#define arch_assertion_failed(struct assertion_failure *desc)

to perform the oops and:

	#define arch_assertion_failure(struct pt_regs *regs)

for report_bug() to find whether or not an assertion failure occurred and, if
so, return a pointer to its description as passed to arch_assertion_failure().

If arch_assertion_failed() is not defined, then the code will fall back to
doing a printk() and a BUG().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/bug.h |   14 ++++++++++++++
 include/asm-generic/bug.h  |    1 +
 include/linux/assert.h     |   36 ++++++++++++++++++++++++++++++++++++
 kernel/panic.c             |   31 +++++++++++++++++++++++++++++++
 lib/bug.c                  |   16 ++++++++++++++++
 5 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/assert.h

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index f654d1b..ef2208a 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -33,6 +33,20 @@ do {								\
 } while (0)
 #endif
 
+extern const void __arch_assertion_failed;
+#define arch_assertion_failed(desc)				\
+do {								\
+	asm volatile(".globl __arch_assertion_failed\n"	\
+		     "__arch_assertion_failed:\n"		\
+		     "	ud2\n"					\
+		     : : "d" (desc));				\
+	unreachable();						\
+} while (0)
+
+#define arch_assertion_failure(regs) \
+	({ ((const void *)regs->ip == &__arch_assertion_failed) ?	\
+			(struct assertion_failure *)regs->dx : NULL; })
+
 #endif /* !CONFIG_BUG */
 
 #include <asm-generic/bug.h>
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index dfb0ec6..c5924c9 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <stdarg.h>
 
 #ifdef CONFIG_BUG
 
diff --git a/include/linux/assert.h b/include/linux/assert.h
new file mode 100644
index 0000000..739ebf7
--- /dev/null
+++ b/include/linux/assert.h
@@ -0,0 +1,36 @@
+/* Assertion checking
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_ASSERT_H
+#define _LINUX_ASSERT_H
+
+#include <linux/bug.h>
+
+/*
+ * Data for assertion failure report.
+ */
+struct assertion_failure {
+	const char	*file;
+	const char	*fmt;
+	va_list		args;
+	int		line;
+};
+
+extern
+void do_assertion_failed(const char *file, int line, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+
+#define assertion_failed(FMT, ...)					\
+	do {								\
+		do_assertion_failed(__FILE__, __LINE__, FMT, ## __VA_ARGS__); \
+	} while (0)
+
+#endif /* _LINUX_ASSERT_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index d7bb697..518b02b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/assert.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -445,3 +446,33 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
+
+/*
+ * Default assertion failure handler.
+ */
+#ifndef arch_assertion_failed
+static void arch_assertion_failed(struct assertion_failure *desc)
+{
+	printk(KERN_CRIT "ASSERTION FAILED at %s:%u!\n",
+	       assert_fail->file, assert_fail->line);
+	if (assert_fail->fmt)
+		vprintk(assert_fail->fmt, assert_fail->args);
+	BUG();
+}
+#endif
+
+/*
+ * Display assertion failure and exit with SIGSEGV.
+ */
+void do_assertion_failed(const char *file, int line, const char *fmt, ...)
+{
+	struct assertion_failure desc = {
+		.file	= file,
+		.fmt	= fmt,
+		.line	= line,
+	};
+
+	va_start(desc.args, fmt);
+	arch_assertion_failed(&desc);
+}
+EXPORT_SYMBOL(do_assertion_failed);
diff --git a/lib/bug.c b/lib/bug.c
index 1955209..b8459d0 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -41,6 +41,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
+#include <linux/assert.h>
 #include <linux/sched.h>
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
@@ -125,6 +126,7 @@ const struct bug_entry *find_bug(unsigned long bugaddr)
 
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
+	struct assertion_failure *assert_fail;
 	const struct bug_entry *bug;
 	const char *file;
 	unsigned line, warning;
@@ -132,6 +134,20 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	if (!is_valid_bugaddr(bugaddr))
 		return BUG_TRAP_TYPE_NONE;
 
+#ifdef arch_assertion_failure
+	assert_fail = arch_assertion_failure(regs);
+	if (assert_fail) {
+		printk(KERN_EMERG "------------[ cut here ]------------\n");
+
+		printk(KERN_CRIT "ASSERTION FAILED at %s:%u!\n",
+		       assert_fail->file, assert_fail->line);
+		if (assert_fail->fmt)
+			vprintk(assert_fail->fmt, assert_fail->args);
+
+		return BUG_TRAP_TYPE_BUG;
+	}
+#endif
+
 	bug = find_bug(bugaddr);
 
 	file = NULL;

