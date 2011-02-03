Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1BCD2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:28:00 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47750 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1BCD1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:27:47 -0500
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
Date: Thu,  3 Feb 2011 14:27:23 +1100
Message-Id: <1296703645-18718-5-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
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
index 33360b9..7b76a65 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -60,6 +60,19 @@ extern unsigned long __stop_syscalls_metadata[];
 
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
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
 	struct syscall_metadata *start;
@@ -72,13 +85,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
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

