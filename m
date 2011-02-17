Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1BQPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:00:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:37948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1BQPAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:00:09 -0500
Date: Thu, 17 Feb 2011 14:59:51 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1296703645-18718-5-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-5-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Allow arch specific syscall symbol matching
Message-ID: <tip-b2d55496818d64310b9f5486d4eea76ea614d7f8@git.kernel.org>
Git-Commit-ID: b2d55496818d64310b9f5486d4eea76ea614d7f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 14:59:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2d55496818d64310b9f5486d4eea76ea614d7f8
Gitweb:     http://git.kernel.org/tip/b2d55496818d64310b9f5486d4eea76ea614d7f8
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 3 Feb 2011 14:27:23 +1100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Feb 2011 21:29:03 -0500

tracing/syscalls: Allow arch specific syscall symbol matching

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
