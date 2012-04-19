Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2DSJ0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:26:48 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51219 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2DSJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:26:45 -0400
Date: Thu, 19 Apr 2012 11:26:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/3] x86, extable: Handle early exceptions
Message-ID: <20120419092630.GD29542@aftab>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419092255.GA29542@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sun, 1 Apr 2012 11:33:29 +0200
Subject: [PATCH 3/3] x86, extable: Handle early exceptions

Now that all is in place, wire in exception handling into the early IDT
handler.

Also, move the sorting of the main exception table earlier in the boot
process now that we handle exceptions in the early IDT handler too.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/head64.c  |    6 ++++++
 arch/x86/kernel/head_64.S |    5 +++++
 arch/x86/mm/extable.c     |   12 ++++++++++++
 init/main.c               |    1 -
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 3a3b779f41d3..20860aa44747 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -13,6 +13,7 @@
 #include <linux/start_kernel.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/module.h>	/* sort_main_extable() */
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -79,6 +80,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
+	/* We're going to enable the initial exception handlers and we need the
+	 * exception table sorted prior to that.
+	 */
+	sort_main_extable();
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3766d1..7e6661d97e9d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -282,6 +282,11 @@ early_idt_handlers:
 #endif
 
 ENTRY(early_idt_handler)
+	call early_fixup_exception
+	cmpq $0, %rax
+	jz 2f
+	retq
+2:
 #ifdef CONFIG_EARLY_PRINTK
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 08aecb0d3132..f8ed1ce07f4c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -19,6 +19,18 @@ static void pnp_bios_is_crap(unsigned long cs)
 #endif
 }
 
+asmlinkage int early_fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_main_extable(regs->ip);
+	if (!fixup)
+		return 0;
+
+	regs->ip = fixup->fixup;
+	return 1;
+}
+
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
diff --git a/init/main.c b/init/main.c
index ff49a6dacfbb..8ef10a2e2892 100644
--- a/init/main.c
+++ b/init/main.c
@@ -517,7 +517,6 @@ asmlinkage void __init start_kernel(void)
 	setup_log_buf(0);
 	pidhash_init();
 	vfs_caches_init_early();
-	sort_main_extable();
 	trap_init();
 	mm_init();
 
-- 
1.7.5.3.401.gfb674

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
