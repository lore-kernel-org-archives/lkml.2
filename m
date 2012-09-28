Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2I1Jlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:41:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60959 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2I1JkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:23 -0400
X-AuditID: 9c930197-b7b6dae000000e70-75-50657083a6b1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 10/12] perf tools: Convert to DEMANGLE_SUPPORT
Date: Fri, 28 Sep 2012 18:32:06 +0900
Message-Id: <1348824728-14025-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without name demangling, we can set NO_DEMANGLE=1 as
a argument of make.  It then defines NO_DEMANGLE macro for C code to
do the proper handling.  However it usually used in a negative
semantics - e.g. #ifndef - so we saw double negations which can be
misleading.  Convert it to a positive form to make it more readable.

Also add _SUPPORT suffix for consistency and make PACKAGE variable has
a string value "perf".

Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile      | 12 +++++++-----
 tools/perf/util/symbol.h | 19 +++++++++++--------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 45f8920bab2b..dd5b9a0507c7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -696,36 +696,38 @@ else
   endif
 endif
 
-ifdef NO_DEMANGLE
-	BASIC_CFLAGS += -DNO_DEMANGLE
-else
+ifndef NO_DEMANGLE
         ifdef HAVE_CPLUS_DEMANGLE
 		EXTLIBS += -liberty
+		BASIC_CFLAGS += -DDEMANGLE_SUPPORT
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='"perf"' -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
 			EXTLIBS += -lbfd
+			BASIC_CFLAGS += -DDEMANGLE_SUPPORT
 		else
 			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
 			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
 			ifeq ($(has_bfd_iberty),y)
 				EXTLIBS += -lbfd -liberty
+				BASIC_CFLAGS += -DDEMANGLE_SUPPORT
 			else
 				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
 				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
 				ifeq ($(has_bfd_iberty_z),y)
 					EXTLIBS += -lbfd -liberty -lz
+					BASIC_CFLAGS += -DDEMANGLE_SUPPORT
 				else
 					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
 					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))
 					ifeq ($(has_cplus_demangle),y)
 						EXTLIBS += -liberty
+						BASIC_CFLAGS += -DDEMANGLE_SUPPORT
 						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 					else
 						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
 					endif
 				endif
 			endif
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 8b6ef7fac745..e1484bb080e6 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -18,26 +18,29 @@
 #include <elf.h>
 #endif
 
-#ifdef HAVE_CPLUS_DEMANGLE
+#ifdef DEMANGLE_SUPPORT
+
+# ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
 static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
 {
 	return cplus_demangle(c, i);
 }
-#else
-#ifdef NO_DEMANGLE
+# else /* HAVE_CPLUS_DEMANGLE */
+#  define PACKAGE "perf"
+#  include <bfd.h>
+# endif /* HAVE_CPLUS_DEMANGLE */
+
+#else /* DEMANGLE_SUPPORT */
+
 static inline char *bfd_demangle(void __maybe_unused *v,
 				 const char __maybe_unused *c,
 				 int __maybe_unused i)
 {
 	return NULL;
 }
-#else
-#define PACKAGE 'perf'
-#include <bfd.h>
-#endif
-#endif
+#endif /* DEMANGLE_SUPPORT */
 
 int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
-- 
1.7.11.4

