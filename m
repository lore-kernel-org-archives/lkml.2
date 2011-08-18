Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1HRTOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:14:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48456 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1HRTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:14:00 -0400
Date: Thu, 18 Aug 2011 20:14:00 +0100
To: richard@nod.at
Subject: Subject: [PATCH 90/91] um: kill system-um.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu82S-00089S-2u@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


most of it belonged in irqflags.h, actually

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/irqflags.h  |   38 ++++++++++++++++++++++++++++++++-
 arch/um/include/asm/system-um.h |   45 ---------------------------------------
 arch/x86/um/asm/system.h        |    4 ++-
 3 files changed, 40 insertions(+), 47 deletions(-)
 delete mode 100644 arch/um/include/asm/system-um.h

diff --git a/arch/um/include/asm/irqflags.h b/arch/um/include/asm/irqflags.h
index 659b9ab..c780d8a 100644
--- a/arch/um/include/asm/irqflags.h
+++ b/arch/um/include/asm/irqflags.h
@@ -1,6 +1,42 @@
 #ifndef __UM_IRQFLAGS_H
 #define __UM_IRQFLAGS_H
 
-/* Empty for now */
+extern int get_signals(void);
+extern int set_signals(int enable);
+extern void block_signals(void);
+extern void unblock_signals(void);
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	return get_signals();
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	set_signals(flags);
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	unblock_signals();
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	block_signals();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_local_save_flags() == 0;
+}
 
 #endif
diff --git a/arch/um/include/asm/system-um.h b/arch/um/include/asm/system-um.h
deleted file mode 100644
index 0eec245..0000000
--- a/arch/um/include/asm/system-um.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef __UM_SYSTEM_GENERIC_H
-#define __UM_SYSTEM_GENERIC_H
-
-extern int get_signals(void);
-extern int set_signals(int enable);
-extern void block_signals(void);
-extern void unblock_signals(void);
-
-static inline unsigned long arch_local_save_flags(void)
-{
-	return get_signals();
-}
-
-static inline void arch_local_irq_restore(unsigned long flags)
-{
-	set_signals(flags);
-}
-
-static inline void arch_local_irq_enable(void)
-{
-	unblock_signals();
-}
-
-static inline void arch_local_irq_disable(void)
-{
-	block_signals();
-}
-
-static inline unsigned long arch_local_irq_save(void)
-{
-	unsigned long flags;
-	flags = arch_local_save_flags();
-	arch_local_irq_disable();
-	return flags;
-}
-
-static inline bool arch_irqs_disabled(void)
-{
-	return arch_local_save_flags() == 0;
-}
-
-extern void *_switch_to(void *prev, void *next, void *last);
-#define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
-
-#endif
diff --git a/arch/x86/um/asm/system.h b/arch/x86/um/asm/system.h
index a89113b..a459fd9 100644
--- a/arch/x86/um/asm/system.h
+++ b/arch/x86/um/asm/system.h
@@ -6,7 +6,6 @@
 #include <asm/cpufeature.h>
 #include <asm/cmpxchg.h>
 #include <asm/nops.h>
-#include <asm/system-um.h>
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
@@ -130,4 +129,7 @@ static inline void rdtsc_barrier(void)
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
 }
 
+extern void *_switch_to(void *prev, void *next, void *last);
+#define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
+
 #endif
-- 
1.7.2.5


