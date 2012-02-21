Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2BURbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:31:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64293 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2BURb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:31:28 -0500
MIME-Version: 1.0
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v10 04/11] arch/x86: add syscall_get_arch to syscall.h
Date: Tue, 21 Feb 2012 11:30:28 -0600
Message-Id: <1329845435-2313-4-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329845435-2313-1-git-send-email-wad@chromium.org>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add syscall_get_arch() to export the current AUDIT_ARCH_* based on system call
entry path.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/include/asm/syscall.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d962e56..1d713e4 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -13,6 +13,7 @@
 #ifndef _ASM_X86_SYSCALL_H
 #define _ASM_X86_SYSCALL_H
 
+#include <linux/audit.h>
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <asm/asm-offsets.h>	/* For NR_syscalls */
@@ -87,6 +88,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->bx + i, args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	return AUDIT_ARCH_I386;
+}
+
 #else	 /* CONFIG_X86_64 */
 
 static inline void syscall_get_arguments(struct task_struct *task,
@@ -211,6 +218,22 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		}
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	/*
+	 * TS_COMPAT is set for 32-bit syscall entries and then
+	 * remains set until we return to user mode.
+	 *
+	 * TIF_IA32 tasks should always have TS_COMPAT set at
+	 * system call time.
+	 */
+	if (task_thread_info(task)->status & TS_COMPAT)
+		return AUDIT_ARCH_I386;
+#endif
+	return AUDIT_ARCH_X86_64;
+}
 #endif	/* CONFIG_X86_32 */
 
 #endif	/* _ASM_X86_SYSCALL_H */
-- 
1.7.5.4

