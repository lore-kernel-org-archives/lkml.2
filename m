Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1BBHNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:13:33 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57778 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1BBHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:12:23 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Steven Rostedt <rostedt@goodmis.org>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall symbol matching
Date: Wed,  2 Feb 2011 18:11:56 +1100
Message-Id: <1296630718-17537-5-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
References: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Some architectures have unusual symbol names and the generic code to
match the symbol name with the function name for the syscall metadata
will fail. For example, symbols on PPC64 start with a period and the
generic code will fail to match them.

This patch moves the match logic out into a macro which can be
overridden by defining arch_syscall_match_sym_name in an archs
asm/ftrace.h if needed.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 Documentation/trace/ftrace-design.txt |    4 ++++
 include/linux/ftrace.h                |    9 +++++++++
 kernel/trace/trace_syscalls.c         |    8 +-------
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 6fca17b..e1eaeb1 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -250,6 +250,10 @@ You need very few things to get the syscalls tracing in an arch.
 - If the system call table on this arch is more complicated than a simple array
   of addresses of the system calls, implement an arch_syscall_addr to return
   the address of a given system call.
+- If the symbol names of the system calls do not match the function names on
+  this arch, define the arch_syscall_match_sym_name macro in asm/ftrace.h with
+  the appropriate logic to return non zero if the function name corresponds
+  with the symbol name.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dcd6a7c..0d0e109 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -527,6 +527,15 @@ extern enum ftrace_dump_mode ftrace_dump_on_oops;
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 unsigned long arch_syscall_addr(int nr);
+#ifndef arch_syscall_match_sym_name
+/*
+ * Only compare after the "sys" prefix. Archs that use
+ * syscall wrappers may have syscalls symbols aliases prefixed
+ * with "SyS" instead of "sys", leading to an unwanted
+ * mismatch.
+ */
+#define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name + 3)
+#endif
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 33360b9..76bffba 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -72,13 +72,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
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
-- 
1.7.2.3

