Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab0HURpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:45:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0HURpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:45:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: add test for strlcpy()
Date: Sat, 21 Aug 2010 14:45:12 -0300
Message-Id: <1282412712-3547-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282412712-3547-1-git-send-email-acme@infradead.org>
References: <1282412712-3547-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Some Linux distributions like ALT Linux provides patched glibc with
contains strlcpy(). It's confilcts with strlcpy() from perf.

Let's add check for strlcpy().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    9 +++++++++
 tools/perf/feature-tests.mak |   11 +++++++++++
 tools/perf/util/cache.h      |    2 ++
 tools/perf/util/path.c       |    3 ++-
 4 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dcb9700..7473de0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -647,6 +647,15 @@ else
 	endif
 endif
 
+
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
index ddb68e6..ef3d0d6 100644
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
index 58a470d..bd74977 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,6 +22,7 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
+#ifdef NO_STRLCPY
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
1.6.2.5

