Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0HUAlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 20:41:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0HUAlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 20:41:01 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] perf: add test for strlcpy()
Date: Sat, 21 Aug 2010 03:38:20 +0300
Message-Id: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Linux distributions like ALT Linux provides patched glibc with
contains strlcpy(). It's confilcts with strlcpy() from perf.

Let's add check for strlcpy().

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/Makefile          |    8 ++++++++
 tools/perf/feature-tests.mak |   11 +++++++++++
 tools/perf/util/cache.h      |    2 ++
 tools/perf/util/path.c       |    3 ++-
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4f1fa77..496a0d6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -653,6 +653,14 @@ else
 	endif
 endif
 
+ifdef NO_STRLCPY
+	BASIC_CFLAGS += -DNO_STRLCPY
+else
+	ifneq ($(call try-cc,$(SOURCE_STRLCPY),),y)
+		BASIC_CFLAGS += -DNO_STRLCPY
+	endif
+endif
+
 ifndef CC_LD_DYNPATH
 	ifdef NO_R_TO_GCC_LINKER
 		# Some gcc does not accept and pass -R to the linker to specify
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index 7a7b608..b253db6 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -110,6 +110,17 @@ int main(void)
 }
 endef
 
+define SOURCE_STRLCPY
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
+endef
+
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 27e9ebe..a772979 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -82,6 +82,8 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
+#ifdef NO_STRLCPY
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#endif
 
 #endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index 58a470d..029661c 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,6 +22,7 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
+#ifdef STRLCPY
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
@@ -33,7 +34,7 @@ size_t strlcpy(char *dest, const char *src, size_t size)
 	}
 	return ret;
 }
-
+#endif
 
 static char *get_pathname(void)
 {
-- 
1.7.2.1

