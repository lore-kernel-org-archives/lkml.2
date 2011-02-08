Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1BHWR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:17:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1BHWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:23 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=1pt1xNAsmFoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=6mJaMgxvitTUPu_o8w4A:9 a=IW7Ln_FEvjvrRije5W4A:7 a=ATNV7eMnFecrMncLqFTIKPnj_04A:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221719.829336875@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 04/10] tracing/syscalls: Allow arch specific syscall symbol matching
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-syscalls-Allow-arch-specific-syscall-symbol-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Some architectures have unusual symbol names and the generic code to
match the symbol name with the function name for the syscall metadata
will fail. For example, symbols on PPC64 start with a period and the
generic code will fail to match them.

This patch moves the match logic out into a separate function which an
arch can override by defining ARCH_HAS_SYSCALL_MATCH_SYM_NAME in
asm/ftrace.h and implementing arch_syscall_match_sym_name.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
LKML-Reference: <1296703645-18718-5-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace-design.txt |    4 ++++
 kernel/trace/trace_syscalls.c         |   21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 6fca17b..79fcafc 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -250,6 +250,10 @@ You need very few things to get the syscalls tracing in an arch.
 - If the system call table on this arch is more complicated than a simple array
   of addresses of the system calls, implement an arch_syscall_addr to return
   the address of a given system call.
+- If the symbol names of the system calls do not match the function names on
+  this arch, define ARCH_HAS_SYSCALL_MATCH_SYM_NAME in asm/ftrace.h and
+  implement arch_syscall_match_sym_name with the appropriate logic to return
+  true if the function name corresponds with the symbol name.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index af83154..86a23e7 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -60,6 +60,19 @@ extern struct syscall_metadata *__stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
 
+#ifndef ARCH_HAS_SYSCALL_MATCH_SYM_NAME
+static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
+{
+	/*
+	 * Only compare after the "sys" prefix. Archs that use
+	 * syscall wrappers may have syscalls symbols aliases prefixed
+	 * with "SyS" instead of "sys", leading to an unwanted
+	 * mismatch.
+	 */
+	return !strcmp(sym + 3, name + 3);
+}
+#endif
+
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
 {
@@ -73,13 +86,7 @@ find_syscall_meta(unsigned long syscall)
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
 	for ( ; start < stop; start++) {
-		/*
-		 * Only compare after the "sys" prefix. Archs that use
-		 * syscall wrappers may have syscalls symbols aliases prefixed
-		 * with "SyS" instead of "sys", leading to an unwanted
-		 * mismatch.
-		 */
-		if ((*start)->name && !strcmp((*start)->name + 3, str + 3))
+		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
 			return *start;
 	}
 	return NULL;
-- 
1.7.2.3


