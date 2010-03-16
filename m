Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938066Ab0CPRqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938040Ab0CPRqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:46:48 -0400
Date: Tue, 16 Mar 2010 13:46:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <371f973b778391a685e63986193b54f87a8c64b3.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 02/14] x86: add arch_compat_syscall_addr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch_compat_syscall_addr(int nr) for x86_64. This is in preparation for adding
compat syscall support to the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
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
1.6.5.1

