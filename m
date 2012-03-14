Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910Ab2CNUBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:01:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2CNUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:01:19 -0400
Date: Wed, 14 Mar 2012 13:00:55 -0700
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-jctwg64le1w47tuaoeyftsg9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools, x86:
  Build perf on older user-space as well
Git-Commit-ID: eae7a755ee81129370c8f555b0d5672e6673735d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Mar 2012 13:01:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eae7a755ee81129370c8f555b0d5672e6673735d
Gitweb:     http://git.kernel.org/tip/eae7a755ee81129370c8f555b0d5672e6673735d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 14 Mar 2012 12:42:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Mar 2012 12:42:34 -0300

perf tools, x86: Build perf on older user-space as well

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
 tools/perf/Makefile                                |    2 ++
 tools/perf/perf.h                                  |    6 ++++++
 .../perf/util/include/asm/unistd_32.h              |    0
 .../perf/util/include/asm/unistd_64.h              |    0
 4 files changed, 8 insertions(+), 0 deletions(-)

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
diff --git a/arch/microblaze/include/asm/auxvec.h b/tools/perf/util/include/asm/unistd_32.h
similarity index 100%
copy from arch/microblaze/include/asm/auxvec.h
copy to tools/perf/util/include/asm/unistd_32.h
diff --git a/arch/microblaze/include/asm/auxvec.h b/tools/perf/util/include/asm/unistd_64.h
similarity index 100%
copy from arch/microblaze/include/asm/auxvec.h
copy to tools/perf/util/include/asm/unistd_64.h
