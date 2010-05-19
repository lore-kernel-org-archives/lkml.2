Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0ESBoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:44:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:41201 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab0ESBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:19 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jan Kiszka <jan.kiszka@web.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/7] x86, kgdb: early trap init for early debug
Date: Tue, 18 May 2010 20:39:56 -0500
Message-Id: <1274233202-3734-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:06.0423 (UTC) FILETIME=[358AEA70:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Allow the x86 arch to have early exception processing for the purpose
of debugging via the kgdb.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/setup.c          |    1 +
 arch/x86/kernel/traps.c          |   14 ++++++++++----
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b753ea5..543f48a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -793,6 +793,8 @@ static inline void wbinvd_halt(void)
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
+extern void early_trap_init(void);
+
 /* Defined in head.S */
 extern struct desc_ptr		early_gdt_descr;
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4851ef..e802989 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -725,6 +725,7 @@ void __init setup_arch(char **cmdline_p)
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
+	early_trap_init();
 	early_cpu_init();
 	early_ioremap_init();
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7296bd2..94b604b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -885,6 +885,16 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 }
 #endif
 
+/* Set of traps needed for early debugging. */
+void __init early_trap_init(void)
+{
+	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	/* int3 can be called from all */
+	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
+	set_intr_gate(14, &page_fault);
+	load_idt(&idt_descr);
+}
+
 void __init trap_init(void)
 {
 	int i;
@@ -898,10 +908,7 @@ void __init trap_init(void)
 #endif
 
 	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
 	set_intr_gate_ist(2, &nmi, NMI_STACK);
-	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
 	/* int4 can be called from all */
 	set_system_intr_gate(4, &overflow);
 	set_intr_gate(5, &bounds);
@@ -917,7 +924,6 @@ void __init trap_init(void)
 	set_intr_gate(11, &segment_not_present);
 	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
 	set_intr_gate(13, &general_protection);
-	set_intr_gate(14, &page_fault);
 	set_intr_gate(15, &spurious_interrupt_bug);
 	set_intr_gate(16, &coprocessor_error);
 	set_intr_gate(17, &alignment_check);
-- 
1.6.3.3

