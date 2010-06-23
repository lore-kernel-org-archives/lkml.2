Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0FWKJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:09:16 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47771 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0FWKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Grant Likely <grant.likely@secretlab.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Christoph Hellwig <hch@lst.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 21/40] trace syscalls, PPC: Add ftrace compat syscall support for PPC64
Date: Wed, 23 Jun 2010 20:03:02 +1000
Message-Id: <1277287401-28571-22-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds the necessary infrastructure to trace 32bit compat
syscalls on PowerPC64.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/Kconfig              |    1 +
 arch/powerpc/include/asm/unistd.h |    4 ++++
 arch/powerpc/kernel/ftrace.c      |    7 +++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 0d5c28d..a724c93 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -142,6 +142,7 @@ config PPC
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_COMPAT_FTRACE_SYSCALLS if PPC64
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index f0a1026..f584b71 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -353,6 +353,10 @@
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
 
+#ifdef CONFIG_PPC64
+#define NR_syscalls_compat NR_syscalls
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index f5fadbb..dddbc33 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -619,3 +619,10 @@ inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
 	return (!strcmp(sym + 4, name + 3));
 }
 #endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 */
+
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
+unsigned long __init arch_compat_syscall_addr(int nr)
+{
+	return sys_call_table[nr*2+1];
+}
+#endif
-- 
1.7.1

