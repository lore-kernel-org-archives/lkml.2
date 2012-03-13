Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2CMQy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:54:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47586 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab2CMQyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:54 -0400
Date: Tue, 13 Mar 2012 17:54:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf tools, x86: Build perf on older user-space as well
Message-ID: <20120313165448.GA5144@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fa04340..74fd7f8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -266,6 +266,8 @@ LIB_H += util/include/asm/uaccess.h
 LIB_H += util/include/dwarf-regs.h
 LIB_H += util/include/asm/dwarf2.h
 LIB_H += util/include/asm/cpufeature.h
+LIB_H += util/include/asm/unistd_32.h
+LIB_H += util/include/asm/unistd_64.h
 LIB_H += perf.h
 LIB_H += util/annotate.h
 LIB_H += util/cache.h
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index eec392e..89e3355 100644
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
