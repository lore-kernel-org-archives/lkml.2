Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0CTXF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 19:05:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab0CTXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 19:05:53 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org
In-Reply-To: <1269126097.18314.111.camel@localhost>
References: <1269126097.18314.111.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oxeb4NvHNjpzIl0POm0M"
Date: Sat, 20 Mar 2010 23:05:40 +0000
Message-ID: <1269126340.18314.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/4] panic: Allow taint flag for warnings to be changed
 from TAINT_WARN
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oxeb4NvHNjpzIl0POm0M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

WARN() is used in some places to report firmware or hardware bugs that
are then worked-around.  These bugs do not affect the stability of the
kernel and should not set the usual TAINT_WARN flag.  To allow for
this, add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint
flag as argument.

Architectures that implement warnings using trap instructions instead
of calls to warn_slowpath_*() must now implement __WARN_TAINT(taint)
instead of __WARN().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The architecture-specific changes here are untested and need to be
reviewed by architecture maintainers.

Ben.

 arch/parisc/include/asm/bug.h  |    8 ++++----
 arch/powerpc/include/asm/bug.h |    6 +++---
 arch/s390/include/asm/bug.h    |    8 ++++----
 arch/sh/include/asm/bug.h      |    4 ++--
 include/asm-generic/bug.h      |   34 ++++++++++++++++++++++++++++++++--
 kernel/panic.c                 |   24 ++++++++++++++++++++----
 lib/bug.c                      |    2 +-
 7 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/arch/parisc/include/asm/bug.h b/arch/parisc/include/asm/bug.h
index 75e46c5..72cfdb0 100644
--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -44,7 +44,7 @@
 #endif
=20
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
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.=
h
index 2c15212..065c590 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -85,12 +85,12 @@
 	}							\
 } while (0)
=20
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
=20
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
=20
-#define __WARN() do {					\
-	__EMIT_BUG(BUGFLAG_WARNING);			\
+#define __WARN_TAINT(taint) do {			\
+	__EMIT_BUG(BUGFLAG_TAINT(taint));		\
 } while (0)
=20
 #define WARN_ON(x) ({					\
 	int __ret_warn_on =3D !!(x);			\
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
=20
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
=20
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..c2c9ba0 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -25,7 +25,10 @@ struct bug_entry {
 };
 #endif		/* __ASSEMBLY__ */
=20
-#define BUGFLAG_WARNING	(1<<0)
+#define BUGFLAG_WARNING		(1 << 0)
+#define BUGFLAG_TAINT(taint)	(BUGFLAG_WARNING | ((taint) << 8))
+#define BUG_GET_TAINT(bug)	((bug)->flags >> 8)
+
 #endif	/* CONFIG_GENERIC_BUG */
=20
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
=20
 #ifndef WARN_ON
@@ -87,6 +98,13 @@ extern void warn_slowpath_null(const char *file, const i=
nt line);
 })
 #endif
=20
+#define WARN_TAINT(condition, taint, format...) ({			\
+	int __ret_warn_on =3D !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_taint(taint, format);			\
+	unlikely(__ret_warn_on);					\
+})
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -110,6 +128,8 @@ extern void warn_slowpath_null(const char *file, const =
int line);
 })
 #endif
=20
+#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
+
 #endif
=20
 #define WARN_ON_ONCE(condition)	({				\
@@ -132,6 +152,16 @@ extern void warn_slowpath_null(const char *file, const=
 int line);
 	unlikely(__ret_warn_once);				\
 })
=20
+#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
+	static bool __warned;					\
+	int __ret_warn_once =3D !!(condition);			\
+								\
+	if (unlikely(__ret_warn_once))				\
+		if (WARN_TAINT(!__warned, taint, format))	\
+			__warned =3D true;			\
+	unlikely(__ret_warn_once);				\
+})
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
=20
diff --git a/kernel/panic.c b/kernel/panic.c
index 13d966b..8b821bc 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -365,7 +365,8 @@ struct slowpath_args {
 	va_list args;
 };
=20
-static void warn_slowpath_common(const char *file, int line, void *caller,=
 struct slowpath_args *args)
+static void warn_slowpath_common(const char *file, int line, void *caller,
+				 unsigned taint, struct slowpath_args *args)
 {
 	const char *board;
=20
@@ -381,7 +382,7 @@ static void warn_slowpath_common(const char *file, int =
line, void *caller, struc
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
-	add_taint(TAINT_WARN);
+	add_taint(taint);
 }
=20
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
@@ -390,14 +391,29 @@ void warn_slowpath_fmt(const char *file, int line, co=
nst char *fmt, ...)
=20
 	args.fmt =3D fmt;
 	va_start(args.args, fmt);
-	warn_slowpath_common(file, line, __builtin_return_address(0), &args);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     TAINT_WARN, &args);
 	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
=20
+void warn_slowpath_fmt_taint(const char *file, int line,
+			     unsigned taint, const char *fmt, ...)
+{
+	struct slowpath_args args;
+
+	args.fmt =3D fmt;
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
@@ -165,7 +165,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, st=
ruct pt_regs *regs)
 			       (void *)bugaddr);
=20
 		show_regs(regs);
-		add_taint(TAINT_WARN);
+		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
=20
--=20
1.7.0




--=-oxeb4NvHNjpzIl0POm0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6VUwue/yOyVhhEJAQJWrxAAjaQMiaV6XGUrV2kASfy82U3+z9Yyu2ZC
DaIIeQuTln99GUvfatWCxJuLJ/N7iub72+k5UioheHd0F7v3j/YwM7b68UPq4xYM
yZ1Fv7yKhItwEIX9YEgcNvPB/My+RMIi6LgwVQgv7Ey/hF8Pt81lYIYbcWyq5aO0
70Nwjh1YOTFWB7A3+B9rRnsgK9uzoBRk1E3iJHw4I52aisuq7ohHCDOkxpCcwpqm
4G5M+PmICToKp3mlQLG5WNiZ8EQzJ2tkI2NmaKEuLikcD9+h3fsuVgxNVNcfNknG
c6EcIPp3xSmhjWskjaB1+g7vrn2fmT0hNNzrSfoQDFNb8ikIkPqRSzmxpd+QGy4q
UJAQpF0VTjz57MlpAQbDgOicKNkbKbGNPDR9clo6x0bzdcpcXxCPDhr01KVGhyP5
UzckoQVtTyhol+OZWm5wgh4PvWNWfuriT8s1vrXg9Af981o2Kbgg8o8EoE68EKc8
1LoNvQ4WptvIKp+ZqqKKsLyqEWwYiK4RdxSWyG5Eg6hkO/EpP/O2hbz+n5K370E/
GvM30DQuucK593NdR5Y6SMMa9fWOixzmGVmwjdHvITy3RMKseF+msfuHroC9OcUG
poUKjLL19CRhxXHOAcXTTXwmT8EqUirXZx21LPuiyVyasNlGv49JOJ1pDQiFA1qX
EJqfY1uABH0=
=CzPe
-----END PGP SIGNATURE-----

--=-oxeb4NvHNjpzIl0POm0M--
