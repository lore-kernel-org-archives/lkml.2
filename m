Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab0J2QBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:01:47 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61293 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab0J2QBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:01:45 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, "Ma Ling:" <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
Date: Sat, 30 Oct 2010 01:01:37 +0900
Message-Id: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ports arch/x86/lib/memcpy_64.S to "perf bench mem".
When PERF_BENCH is defined at preprocessor level,
memcpy_64.S is preprocessed to includable form from the sources
under tools/perf for benchmarking programs.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ma Ling: <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/memcpy_64.S |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..72c6dfe 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -1,10 +1,23 @@
 /* Copyright 2002 Andi Kleen */
 
+/*
+ * perf bench adoption by Hitoshi Mitake
+ * PERF_BENCH means that this file is included from
+ * the source files under tools/perf/ for benchmark programs.
+ *
+ * You don't have to care about PERF_BENCH when
+ * you are working on the kernel.
+ */
+
+#ifndef PERF_BENCH
+
 #include <linux/linkage.h>
 
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
 
+#endif /* PERF_BENCH */
+
 /*
  * memcpy - Copy a memory block.
  *
@@ -23,8 +36,13 @@
  * This gets patched over the unrolled variant (below) via the
  * alternative instructions framework:
  */
+#ifndef PERF_BENCH
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c:
+#else
+	.globl memcpy_x86_64_rep
+memcpy_x86_64_rep:
+#endif
 	movq %rdi, %rax
 
 	movl %edx, %ecx
@@ -34,12 +52,19 @@
 	movl %edx, %ecx
 	rep movsb
 	ret
+#ifndef PERF_BENCH
 .Lmemcpy_e:
 	.previous
+#endif
 
+#ifndef PERF_BENCH
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
+#else
+	.globl	memcpy_x86_64_unrolled
+memcpy_x86_64_unrolled:
+#endif
 	movq %rdi, %rax
 
 	/*
@@ -166,6 +191,9 @@ ENTRY(memcpy)
 
 .Lend:
 	retq
+
+#ifndef PERF_BENCH
+
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)
@@ -189,3 +217,5 @@ ENDPROC(__memcpy)
 	.byte .Lmemcpy_e - .Lmemcpy_c
 	.byte .Lmemcpy_e - .Lmemcpy_c
 	.previous
+
+#endif
-- 
1.7.1.1

