Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101Ab2CNQ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:58:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:59639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2CNQ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:58:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools, x86: Build perf on older user-space as well
Date: Wed, 14 Mar 2012 13:58:42 -0300
Message-Id: <1331744322-18917-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331744322-18917-1-git-send-email-acme@infradead.org>
References: <1331744322-18917-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

On ancient systems I get this build failure:

  util/../../../arch/x86/include/asm/unistd.h:67:29: error: asm/unistd_64.h: No such file or directory
  In file included from util/cache.h:7,
                   from builtin-test.c:8:
  util/../perf.h: In function ‘sys_perf_event_open’:In file included from util/../perf.h:16
  perf.h:170: error: ‘__NR_perf_event_open’ undeclared (first use in this function)

The reason is that this old system does not have the split
unistd.h headers yet, from which to pick up the syscall
definitions.

Add the syscall numbers to the already existing i386 and x86_64
blocks in perf.h, and also provide empty include file stubs.

With this patch perf builds and works fine on 5 years old
user-space as well.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-jctwg64le1w47tuaoeyftsg9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                     |    2 ++
 tools/perf/perf.h                       |    6 ++++++
 tools/perf/util/include/asm/unistd_32.h |    1 +
 tools/perf/util/include/asm/unistd_64.h |    1 +
 4 files changed, 10 insertions(+)
 create mode 100644 tools/perf/util/include/asm/unistd_32.h
 create mode 100644 tools/perf/util/include/asm/unistd_64.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7c12650..8a4b9bc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -249,6 +249,8 @@ LIB_H += util/include/asm/uaccess.h
 LIB_H += util/include/dwarf-regs.h
 LIB_H += util/include/asm/dwarf2.h
 LIB_H += util/include/asm/cpufeature.h
+LIB_H += util/include/asm/unistd_32.h
+LIB_H += util/include/asm/unistd_64.h
 LIB_H += perf.h
 LIB_H += util/annotate.h
 LIB_H += util/cache.h
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 16e7d20..3afa39a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -10,6 +10,9 @@ void get_term_dimensions(struct winsize *ws);
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 336
+#endif
 #endif
 
 #if defined(__x86_64__)
@@ -17,6 +20,9 @@ void get_term_dimensions(struct winsize *ws);
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 298
+#endif
 #endif
 
 #ifdef __powerpc__
diff --git a/tools/perf/util/include/asm/unistd_32.h b/tools/perf/util/include/asm/unistd_32.h
new file mode 100644
index 0000000..8b13789
--- /dev/null
+++ b/tools/perf/util/include/asm/unistd_32.h
@@ -0,0 +1 @@
+
diff --git a/tools/perf/util/include/asm/unistd_64.h b/tools/perf/util/include/asm/unistd_64.h
new file mode 100644
index 0000000..8b13789
--- /dev/null
+++ b/tools/perf/util/include/asm/unistd_64.h
@@ -0,0 +1 @@
+
-- 
1.7.9.2.358.g22243

