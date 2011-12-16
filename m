Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab1LPOOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:14:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491Ab1LPOOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:14:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/7] Add conditional oopsing with annotation
To: linux-arch@vger.kernel.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 16 Dec 2011 14:13:57 +0000
Message-ID: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
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


This facility can be made use of by one of:

	ANNOTATED_BUG(const char *fmt, ...);
	ANNOTATED_BUG_ON(bool condition, const char *fmt, ...);

This prints a report that looks like:

	------------[ cut here ]------------
	kernel BUG at fs/dcache.c:863!
	invalid opcode: 0000 [#1] SMP
	...

if fmt is NULL and:

	------------[ cut here ]------------
	kernel BUG at fs/dcache.c:863!
	Dentry 0xffff880032675ed8{i=242,n=Documents} still in use (1) [unmount of nfs 12:01]
	invalid opcode: 0000 [#1] SMP
	...

otherwise.

For this to work the arch code must provide two things:

	#define arch_annotated_bug(struct annotated_bug *desc)

to perform the oops and:

	#define is_arch_annotated_bug(struct pt_regs *regs)

for report_bug() to find whether or not an annotated bug occurred and, if so,
return a pointer to its description as passed to arch_annotated_bug().

If arch_annotated_bug() is not defined, then the code will fall back to doing
a printk() and a BUG().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/bug.h |   14 ++++++++++++++
 include/asm-generic/bug.h  |   32 ++++++++++++++++++++++++++++++++
 include/linux/bug.h        |   15 +++++++++++++++
 kernel/panic.c             |   35 +++++++++++++++++++++++++++++++++++
 lib/bug.c                  |   14 ++++++++++++++
 5 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index f654d1b..d6c109d 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -33,6 +33,20 @@ do {								\
 } while (0)
 #endif
 
+extern const void __arch_annotated_bug;
+#define arch_annotated_bug(desc)				\
+	do {							\
+		asm volatile(".globl __arch_annotated_bug\n"	\
+			     "__arch_annotated_bug:\n"		\
+			     "	ud2\n"				\
+			     : : "d" (desc));			\
+		unreachable();					\
+	} while (0)
+
+#define is_arch_annotated_bug(regs)					\
+	({ ((const void *)regs->ip == &__arch_annotated_bug) ?		\
+			(struct annotated_bug *)regs->dx : NULL; })
+
 #endif /* !CONFIG_BUG */
 
 #include <asm-generic/bug.h>
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 84458b0..05db3fe 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <stdarg.h>
 
 #ifdef CONFIG_BUG
 
@@ -202,4 +203,35 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
+/**
+ * ANNOTATED_BUG - Give annotated oops
+ * FMT: The annotation format (as printk)
+ */
+#ifdef CONFIG_BUG
+
+#define ANNOTATED_BUG(FMT, ...)						\
+	do {								\
+		annotated_bug(__FILE__, __LINE__, FMT, ## __VA_ARGS__); \
+	} while (0)
+
+#else
+
+#define ANNOTATED_BUG(FMT, ...)		\
+	do {					\
+		no_printk(FMT, ## __VA_ARGS__);	\
+	} while (0)
+
 #endif
+
+/**
+ * ANNOTATED_BUG_ON - Give annotated oops if the given expression is not true
+ * X: The expression to check
+ * FMT: The annotation format (as printk)
+ */
+#define ANNOTATED_BUG_ON(X, FMT, ...)				\
+	do {							\
+		if (unlikely(!(X)))				\
+			ANNOTATED_BUG(FMT, ## __VA_ARGS__);	\
+	} while (0)
+
+#endif /* _ASM_GENERIC_BUG_H */
diff --git a/include/linux/bug.h b/include/linux/bug.h
index d276b55..6498861 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -35,4 +35,19 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 }
 
 #endif	/* CONFIG_GENERIC_BUG */
+
+
+/*
+ * Data for annotated bug (assertion failure) report.
+ */
+struct annotated_bug {
+	const char	*file;
+	const char	*fmt;
+	va_list		args;
+	int		line;
+};
+
+extern void annotated_bug(const char *file, int line, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+
 #endif	/* _LINUX_BUG_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index b2659360..91e22c5 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/bug.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -447,3 +448,37 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
+
+/*
+ * Default annotated bug handler.
+ */
+#ifndef arch_annotated_bug
+static void arch_annotated_bug(struct annotated_bug *bug)
+{
+	printk(KERN_EMERG "------------[ cut here ]------------\n");
+	printk(KERN_CRIT "kernel BUG at %s:%u!\n", bug->file, bug->line);
+	if (bug->fmt)
+		vprintk(bug->fmt, bug->args);
+
+	/* We don't really want to call BUG() here as it'll emit another "cut
+	 * here" line, so the arches really need to override this.
+	 */
+	BUG();
+}
+#endif
+
+/*
+ * Display assertion failure and exit with SIGSEGV.
+ */
+void annotated_bug(const char *file, int line, const char *fmt, ...)
+{
+	struct annotated_bug bug = {
+		.file	= file,
+		.line	= line,
+		.fmt	= fmt,
+	};
+
+	va_start(bug.args, fmt);
+	arch_annotated_bug(&bug);
+}
+EXPORT_SYMBOL(annotated_bug);
diff --git a/lib/bug.c b/lib/bug.c
index 1955209..f551fe5 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -126,12 +126,26 @@ const struct bug_entry *find_bug(unsigned long bugaddr)
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	const struct bug_entry *bug;
+	struct annotated_bug *anno;
 	const char *file;
 	unsigned line, warning;
 
 	if (!is_valid_bugaddr(bugaddr))
 		return BUG_TRAP_TYPE_NONE;
 
+#ifdef arch_annotated_bug
+	anno = is_arch_annotated_bug(regs);
+	if (anno) {
+		printk(KERN_EMERG "------------[ cut here ]------------\n");
+
+		printk(KERN_CRIT "kernel BUG at %s:%u!\n", anno->file, anno->line);
+		if (anno->fmt)
+			vprintk(anno->fmt, anno->args);
+
+		return BUG_TRAP_TYPE_BUG;
+	}
+#endif
+
 	bug = find_bug(bugaddr);
 
 	file = NULL;

