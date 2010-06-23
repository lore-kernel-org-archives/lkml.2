Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0FWKNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:13:06 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51532 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0FWKEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:13 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 06/40] x86: add arch_compat_syscall_addr()
Date: Wed, 23 Jun 2010 20:02:47 +1000
Message-Id: <1277287401-28571-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add arch_compat_syscall_addr(int nr) for x86_64. This is in preparation for adding
compat syscall support to the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/x86/include/asm/syscall.h |    5 +++++
 arch/x86/kernel/ftrace.c       |    8 ++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..4e462cc 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,7 +16,12 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
+#if defined(CONFIG_COMPAT) && defined(CONFIG_FTRACE_SYSCALLS)
+ #define __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+#endif
+
 extern const unsigned long sys_call_table[];
+extern const unsigned long *ia32_sys_call_table;
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cd37469..4b36a0b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -26,6 +26,7 @@
 #include <asm/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>
+#include <asm/syscall.h>
 
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -510,3 +511,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+unsigned long __init arch_compat_syscall_addr(int nr)
+{
+	return (unsigned long)(&ia32_sys_call_table)[nr];
+}
+#endif
-- 
1.7.1

