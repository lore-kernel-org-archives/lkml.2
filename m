Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784Ab2FAWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:16:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:59510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab2FAWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/15] perf tool: Build fix, remove duplicate declarations
Date: Fri,  1 Jun 2012 19:16:39 -0300
Message-Id: <1338588999-32509-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

I'm sure I have some gremlins running around today, but I am
consistently hitting this compile failure on Fedora 14 and 16:

In file included from util/sort.h:12:0,
                 from builtin-diff.c:15:
util/string.h:7:5: error: redundant redeclaration of ‘hex2u64’ [-Werror=redundant-decls]
util/symbol.h:32:5: note: previous declaration of ‘hex2u64’ was here
util/string.h:8:7: error: redundant redeclaration of ‘strxfrchar’ [-Werror=redundant-decls]
util/symbol.h:33:7: note: previous declaration of ‘strxfrchar’ was here
util/string.h:9:5: error: redundant redeclaration of ‘perf_atoll’ [-Werror=redundant-decls]
util/util.h:238:5: note: previous declaration of ‘perf_atoll’ was here
util/string.h:10:8: error: redundant redeclaration of ‘argv_split’ [-Werror=redundant-decls]
util/util.h:239:8: note: previous declaration of ‘argv_split’ was here
util/string.h:11:6: error: redundant redeclaration of ‘argv_free’ [-Werror=redundant-decls]
util/util.h:240:6: note: previous declaration of ‘argv_free’ was here
util/string.h:12:6: error: redundant redeclaration of ‘strglobmatch’ [-Werror=redundant-decls]
util/util.h:241:6: note: previous declaration of ‘strglobmatch’ was here
util/string.h:13:6: error: redundant redeclaration of ‘strlazymatch’ [-Werror=redundant-decls]
util/util.h:242:6: note: previous declaration of ‘strlazymatch’ was here
cc1: all warnings being treated as errors
make: *** [/tmp/pbuild/builtin-diff.o] Error 1
make: *** Waiting for unfinished jobs....
make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'

Fix it by removing duplicates.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1338563000-93294-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.h |    4 +---
 tools/perf/util/util.h   |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index af0752b..bf4b679 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,6 +10,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <byteswap.h>
+#include "string.h"
 
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
@@ -30,9 +31,6 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
 #endif
 #endif
 
-int hex2u64(const char *ptr, u64 *val);
-char *strxfrchar(char *s, char from, char to);
-
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 2daaedb..5152592 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -78,6 +78,7 @@
 #include "../../../include/linux/magic.h"
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include "string.h"
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -235,11 +236,6 @@ static inline int sane_case(int x, int high)
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 
-s64 perf_atoll(const char *str);
-char **argv_split(const char *str, int *argcp);
-void argv_free(char **argv);
-bool strglobmatch(const char *str, const char *pat);
-bool strlazymatch(const char *str, const char *pat);
 int strtailcmp(const char *s1, const char *s2);
 unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
-- 
1.7.1

