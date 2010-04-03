Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0DCSff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:35:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab0DCSf3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:35:29 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 03 Apr 2010 19:34:56 +0100
Message-ID: <1270319696.12516.321.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/4] panic: Allow warnings to set different taint flags
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN() is used in some places to report firmware or hardware bugs that
are then worked-around.  These bugs do not affect the stability of the
kernel and should not set the flag for TAINT_WARN.  To allow for this,
add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint number
as argument.

Architectures that implement warnings using trap instructions instead
of calls to warn_slowpath_*() now implement __WARN_TAINT(taint)
instead of __WARN().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Changes since the previous version:
- Added note to Documentation/oops-tracing.txt
- Changed the commit message to distinguish taint numbers from taint
  flags
- Removed 'must' from last sentence of commit message; this patch
  converts all mainline architectures

Ben.

 Documentation/oops-tracing.txt |    1 +
 arch/parisc/include/asm/bug.h  |    8 ++++----
 arch/powerpc/include/asm/bug.h |    6 +++---
 arch/s390/include/asm/bug.h    |    8 ++++----
 arch/sh/include/asm/bug.h      |    4 ++--
 include/asm-generic/bug.h      |   34 ++++++++++++++++++++++++++++++++--
 kernel/panic.c                 |   24 ++++++++++++++++++++----
 lib/bug.c                      |    2 +-
 8 files changed, 67 insertions(+), 20 deletions(-)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index c10c022..069fab3 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -256,6 +256,7 @@ characters, each representing a particular tainted value.
   9: 'A' if the ACPI table has been overridden.
 
  10: 'W' if a warning has previously been issued by the kernel.
+     (Though some warnings may set more specific taint flags.)
 
  11: 'C' if a staging driver has been loaded.
 
diff --git a/arch/parisc/include/asm/bug.h b/arch/parisc/include/asm/bug.h
index 75e46c5..72cfdb0 100644
--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -44,7 +44,7 @@
 #endif
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-#define __WARN()							\
+#define __WARN_TAINT(taint)						\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
@@ -54,11 +54,11 @@
 			     "\t.org 2b+%c3\n"				\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (BUGFLAG_WARNING),			\
+			     "i" (BUGFLAG_TAINT(taint)), 		\
 			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #else
-#define __WARN()							\
+#define __WARN_TAINT(taint)						\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
@@ -67,7 +67,7 @@
 			     "\t.short %c0\n"				\
 			     "\t.org 2b+%c1\n"				\
 			     "\t.popsection"				\
-			     : : "i" (BUGFLAG_WARNING),			\
+			     : : "i" (BUGFLAG_TAINT(taint)),		\
 			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #endif
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 2c15212..065c590 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -85,12 +85,12 @@
 	}							\
 } while (0)
 
-#define __WARN() do {						\
+#define __WARN_TAINT(taint) do {				\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
+		  "i" (BUGFLAG_TAINT(taint)),			\
 		  "i" (sizeof(struct bug_entry)));		\
 } while (0)
 
@@ -104,7 +104,7 @@
 		"1:	"PPC_TLNEI"	%4,0\n"			\
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
+		  "i" (BUGFLAG_TAINT(TAINT_WARN)),		\
 		  "i" (sizeof(struct bug_entry)),		\
 		  "r" (__ret_warn_on));				\
 	}							\
diff --git a/arch/s390/include/asm/bug.h b/arch/s390/include/asm/bug.h
index 9beeb9d..bf90d1f 100644
--- a/arch/s390/include/asm/bug.h
+++ b/arch/s390/include/asm/bug.h
@@ -46,18 +46,18 @@
 	unreachable();					\
 } while (0)
 
-#define __WARN() do {					\
-	__EMIT_BUG(BUGFLAG_WARNING);			\
+#define __WARN_TAINT(taint) do {			\
+	__EMIT_BUG(BUGFLAG_TAINT(taint));		\
 } while (0)
 
 #define WARN_ON(x) ({					\
 	int __ret_warn_on = !!(x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
-			__EMIT_BUG(BUGFLAG_WARNING);	\
+			__WARN();			\
 	} else {					\
 		if (unlikely(__ret_warn_on))		\
-			__EMIT_BUG(BUGFLAG_WARNING);	\
+			__WARN();			\
 	}						\
 	unlikely(__ret_warn_on);			\
 })
diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
index d02c01b..6323f86 100644
--- a/arch/sh/include/asm/bug.h
+++ b/arch/sh/include/asm/bug.h
@@ -48,7 +48,7 @@ do {							\
 		   "i" (sizeof(struct bug_entry)));	\
 } while (0)
 
-#define __WARN()					\
+#define __WARN_TAINT(taint)				\
 do {							\
 	__asm__ __volatile__ (				\
 		"1:\t.short %O0\n"			\
@@ -57,7 +57,7 @@ do {							\
 		 : "n" (TRAPA_BUG_OPCODE),		\
 		   "i" (__FILE__),			\
 		   "i" (__LINE__),			\
-		   "i" (BUGFLAG_WARNING),		\
+		   "i" (BUGFLAG_TAINT(taint)),		\
 		   "i" (sizeof(struct bug_entry)));	\
 } while (0)
 
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..c2c9ba0 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -25,7 +25,10 @@ struct bug_entry {
 };
 #endif		/* __ASSEMBLY__ */
 
-#define BUGFLAG_WARNING	(1<<0)
+#define BUGFLAG_WARNING		(1 << 0)
+#define BUGFLAG_TAINT(taint)	(BUGFLAG_WARNING | ((taint) << 8))
+#define BUG_GET_TAINT(bug)	((bug)->flags >> 8)
+
 #endif	/* CONFIG_GENERIC_BUG */
 
 /*
@@ -56,17 +59,25 @@ struct bug_entry {
  * appear at runtime.  Use the versions with printk format strings
  * to provide better diagnostics.
  */
-#ifndef __WARN
+#ifndef __WARN_TAINT
 #ifndef __ASSEMBLY__
 extern void warn_slowpath_fmt(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+extern void warn_slowpath_fmt_taint(const char *file, const int line,
+				    unsigned taint, const char *fmt, ...)
+	__attribute__((format(printf, 4, 5)));
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
+#define __WARN_printf_taint(taint, arg...)				\
+	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
+#define __WARN()		__WARN_TAINT(TAINT_WARN)
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
+#define __WARN_printf_taint(taint, arg...)				\
+	do { printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
 #ifndef WARN_ON
@@ -87,6 +98,13 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 #endif
 
+#define WARN_TAINT(condition, taint, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_taint(taint, format);			\
+	unlikely(__ret_warn_on);					\
+})
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -110,6 +128,8 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 #endif
 
+#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
@@ -132,6 +152,16 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
+	static bool __warned;					\
+	int __ret_warn_once = !!(condition);			\
+								\
+	if (unlikely(__ret_warn_once))				\
+		if (WARN_TAINT(!__warned, taint, format))	\
+			__warned = true;			\
+	unlikely(__ret_warn_once);				\
+})
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 13d966b..8b821bc 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -365,7 +365,8 @@ struct slowpath_args {
 	va_list args;
 };
 
-static void warn_slowpath_common(const char *file, int line, void *caller, struct slowpath_args *args)
+static void warn_slowpath_common(const char *file, int line, void *caller,
+				 unsigned taint, struct slowpath_args *args)
 {
 	const char *board;
 
@@ -381,7 +382,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller, struc
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
-	add_taint(TAINT_WARN);
+	add_taint(taint);
 }
 
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
@@ -390,14 +391,29 @@ void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 
 	args.fmt = fmt;
 	va_start(args.args, fmt);
-	warn_slowpath_common(file, line, __builtin_return_address(0), &args);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     TAINT_WARN, &args);
 	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
+void warn_slowpath_fmt_taint(const char *file, int line,
+			     unsigned taint, const char *fmt, ...)
+{
+	struct slowpath_args args;
+
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     taint, &args);
+	va_end(args.args);
+}
+EXPORT_SYMBOL(warn_slowpath_fmt_taint);
+
 void warn_slowpath_null(const char *file, int line)
 {
-	warn_slowpath_common(file, line, __builtin_return_address(0), NULL);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     TAINT_WARN, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
diff --git a/lib/bug.c b/lib/bug.c
index 300e41a..f13daf4 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -165,7 +165,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 			       (void *)bugaddr);
 
 		show_regs(regs);
-		add_taint(TAINT_WARN);
+		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
 
-- 
1.7.0.3



