Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0ESBld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:41:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:41377 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0ESBla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:41:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH 17/25] x86,kgdb: Add low level debug hook
Date: Tue, 18 May 2010 20:39:27 -0500
Message-Id: <1274233175-3675-18-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:56.0047 (UTC) FILETIME=[2F5BA9F0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a triple fault is
to have a low level "first opportunity handler" in the int3 exception
handler.

Generally this will be something the vast majority of folks will not
need, but for those who need it, it is added as a kernel .config
option called KGDB_LOW_LEVEL_TRAP.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: H. Peter Anvin <hpa@zytor.com>
CC: x86@kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/include/asm/kgdb.h |    3 +++
 arch/x86/kernel/kgdb.c      |   22 +++++++++++++++++++++-
 arch/x86/kernel/traps.c     |    6 ++++++
 include/linux/kgdb.h        |    1 +
 kernel/debug/debug_core.c   |    2 +-
 lib/Kconfig.kgdb            |    9 +++++++++
 6 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index e6c6c80..006da36 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -76,4 +76,7 @@ static inline void arch_kgdb_breakpoint(void)
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
 
+extern int kgdb_ll_trap(int cmd, const char *str,
+			struct pt_regs *regs, long err, int trap, int sig);
+
 #endif /* _ASM_X86_KGDB_H */
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index acba571..95b89d4 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -538,7 +538,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 			return NOTIFY_DONE;
 	}
 
-	if (kgdb_handle_exception(args->trapnr, args->signr, args->err, regs))
+	if (kgdb_handle_exception(args->trapnr, args->signr, cmd, regs))
 		return NOTIFY_DONE;
 
 	/* Must touch watchdog before return to normal operation */
@@ -546,6 +546,26 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 	return NOTIFY_STOP;
 }
 
+#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
+int kgdb_ll_trap(int cmd, const char *str,
+		 struct pt_regs *regs, long err, int trap, int sig)
+{
+	struct die_args args = {
+		.regs	= regs,
+		.str	= str,
+		.err	= err,
+		.trapnr	= trap,
+		.signr	= sig,
+
+	};
+
+	if (!kgdb_io_module_registered)
+		return NOTIFY_DONE;
+
+	return __kgdb_notify(&args, cmd);
+}
+#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
+
 static int
 kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..7296bd2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/kgdb.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
@@ -460,6 +461,11 @@ void restart_nmi(void)
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
+		return;
+#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 #ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 406f6f9..19d1b29 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -60,6 +60,7 @@ struct uart_port;
 void kgdb_breakpoint(void);
 
 extern int kgdb_connected;
+extern int kgdb_io_module_registered;
 
 extern atomic_t			kgdb_setting_breakpoint;
 extern atomic_t			kgdb_cpu_doing_single_step;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 88a83a2..375e42f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -66,7 +66,7 @@ int				kgdb_connected;
 EXPORT_SYMBOL_GPL(kgdb_connected);
 
 /* All the KGDB handlers are installed */
-static int			kgdb_io_module_registered;
+int			kgdb_io_module_registered;
 
 /* Guard for recursive entry */
 static int			exception_level;
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index ee8ae71..c56ccb4 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -57,6 +57,15 @@ config KGDB_TESTS_BOOT_STRING
 	  information about other strings you could use beyond the
 	  default of V1F100.
 
+config KGDB_LOW_LEVEL_TRAP
+       bool "KGDB: Allow debugging with traps in notifiers"
+       depends on X86
+       default n
+       help
+         This will add an extra call back to kgdb for the breakpoint
+         exception handler on which will will allow kgdb to step
+         through a notify handler.
+
 config KGDB_KDB
 	bool "KGDB_KDB: include kdb frontend for kgdb"
 	default n
-- 
1.6.3.3

