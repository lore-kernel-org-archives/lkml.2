Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0EMHoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:44:37 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44467 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab0EMHoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:44:07 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 3/4] ftrace syscalls: Allow arch specific syscall symbol matching
Date: Thu, 13 May 2010 17:43:13 +1000
Message-Id: <1273736594-19320-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Some architectures have unusual symbol names and the generic code to
match the symbol name with the function name for the syscall metadata
will fail. For example, symbols on PPC64 start with a period and the
generic code will fail to match them.

This patch splits out the match logic into a standalone weak function
that can be overridden on archs with unusual symbol names.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 Documentation/trace/ftrace-design.txt |    3 +++
 include/linux/ftrace.h                |    1 +
 kernel/trace/trace_syscalls.c         |   19 ++++++++++++-------
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 8369a1c..3936d5f 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -247,6 +247,9 @@ You need very few things to get the syscalls tracing in an arch.
 - If the system call table on this arch is more complicated than a simple array
   of addresses of the system calls, implement an arch_syscall_addr to return
   the address of a given system call.
+- If the symbol names of the system calls do not match the function names on
+  this arch, implement an arch_syscall_match_sym_name with the appropriate
+  logic to return true if the function name corresponds with the symbol name.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e0ae83b..26ad1f5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -534,6 +534,7 @@ static inline void trace_hw_branch_oops(void) {}
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 unsigned long arch_syscall_addr(int nr);
+bool arch_syscall_match_sym_name(const char *sym, const char *name);
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1c231d0..ebbc74d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -32,13 +32,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
 	for ( ; start < stop; start++) {
-		/*
-		 * Only compare after the "sys" prefix. Archs that use
-		 * syscall wrappers may have syscalls symbols aliases prefixed
-		 * with "SyS" instead of "sys", leading to an unwanted
-		 * mismatch.
-		 */
-		if (start->name && !strcmp(start->name + 3, str + 3))
+		if (start->name && arch_syscall_match_sym_name(str, start->name))
 			return start;
 	}
 	return NULL;
@@ -408,6 +402,17 @@ unsigned long __init __weak arch_syscall_addr(int nr)
 	return (unsigned long)sys_call_table[nr];
 }
 
+bool __weak arch_syscall_match_sym_name(const char *sym, const char *name)
+{
+	/*
+	 * Only compare after the "sys" prefix. Archs that use
+	 * syscall wrappers may have syscalls symbols aliases prefixed
+	 * with "SyS" instead of "sys", leading to an unwanted
+	 * mismatch.
+	 */
+	return (!strcmp(sym + 3, name + 3));
+}
+
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
-- 
1.7.1

