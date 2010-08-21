Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0HUUTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0HUUTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:19:42 -0400
Date: Sat, 21 Aug 2010 20:19:13 GMT
From: "tip-bot for Kirill A. Shutemov" <kirill@shutemov.name>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, kirill@shutemov.name, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, kirill@shutemov.name, mingo@elte.hu
In-Reply-To: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
References: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: add test for strlcpy()
Message-ID: <tip-f4e7ac0a233a4dc9b51345546ab69c64bb43e2c1@git.kernel.org>
Git-Commit-ID: f4e7ac0a233a4dc9b51345546ab69c64bb43e2c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 21 Aug 2010 20:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4e7ac0a233a4dc9b51345546ab69c64bb43e2c1
Gitweb:     http://git.kernel.org/tip/f4e7ac0a233a4dc9b51345546ab69c64bb43e2c1
Author:     Kirill A. Shutemov <kirill@shutemov.name>
AuthorDate: Sat, 21 Aug 2010 03:38:20 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 21 Aug 2010 11:22:47 -0300

perf tools: add test for strlcpy()

Some Linux distributions like ALT Linux provides patched glibc with
contains strlcpy(). It's confilcts with strlcpy() from perf.

Let's add check for strlcpy().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
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
