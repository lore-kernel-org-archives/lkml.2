Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0ESCId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:08:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab0ESCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:08:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/5] perf tools: remove xstrndup, xmalloc, xzalloc
Date: Tue, 18 May 2010 23:08:20 -0300
Message-Id: <1274234900-12162-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274234900-12162-1-git-send-email-acme@infradead.org>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

All the functions that call this can handle the equivalent, non
panic'ing wrapped routines.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/exec_cmd.c |    4 ++--
 tools/perf/util/path.c     |    2 +-
 tools/perf/util/util.h     |    8 --------
 tools/perf/util/wrapper.c  |   40 ----------------------------------------
 4 files changed, 3 insertions(+), 51 deletions(-)

diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index c1b3d34..67eeff5 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -53,8 +53,8 @@ const char *perf_extract_argv0_path(const char *argv0)
 		slash--;
 
 	if (slash >= argv0) {
-		argv0_path = xstrndup(argv0, slash - argv0);
-		return slash + 1;
+		argv0_path = strndup(argv0, slash - argv0);
+		return argv0_path ? slash + 1 : NULL;
 	}
 
 	return argv0;
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index b276c18..58a470d 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -152,5 +152,5 @@ char *strip_path_suffix(const char *path, const char *suffix)
 
 	if (path_len && !is_dir_sep(path[path_len - 1]))
 		return NULL;
-	return xstrndup(path, chomp_trailing_dir_sep(path, path_len));
+	return strndup(path, chomp_trailing_dir_sep(path, path_len));
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 52118a0..45b9655 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -179,16 +179,8 @@ static inline char *gitstrchrnul(const char *s, int c)
  * Wrappers:
  */
 extern char *xstrdup(const char *str);
-extern void *xmalloc(size_t size) __attribute__((weak));
-extern char *xstrndup(const char *str, size_t len);
 extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
-static inline void *xzalloc(size_t size)
-{
-	void *buf = xmalloc(size);
-
-	return memset(buf, 0, size);
-}
 
 static inline void *zalloc(size_t size)
 {
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index c4ced7c..73e900e 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -23,46 +23,6 @@ char *xstrdup(const char *str)
 	return ret;
 }
 
-void *xmalloc(size_t size)
-{
-	void *ret = malloc(size);
-	if (!ret && !size)
-		ret = malloc(1);
-	if (!ret) {
-		release_pack_memory(size, -1);
-		ret = malloc(size);
-		if (!ret && !size)
-			ret = malloc(1);
-		if (!ret)
-			die("Out of memory, malloc failed");
-	}
-#ifdef XMALLOC_POISON
-	memset(ret, 0xA5, size);
-#endif
-	return ret;
-}
-
-/*
- * xmemdupz() allocates (len + 1) bytes of memory, duplicates "len" bytes of
- * "data" to the allocated memory, zero terminates the allocated memory,
- * and returns a pointer to the allocated memory. If the allocation fails,
- * the program dies.
- */
-static void *xmemdupz(const void *data, size_t len)
-{
-	char *p = xmalloc(len + 1);
-	memcpy(p, data, len);
-	p[len] = '\0';
-	return p;
-}
-
-char *xstrndup(const char *str, size_t len)
-{
-	char *p = memchr(str, '\0', len);
-
-	return xmemdupz(str, p ? (size_t)(p - str) : len);
-}
-
 void *xrealloc(void *ptr, size_t size)
 {
 	void *ret = realloc(ptr, size);
-- 
1.6.2.5

