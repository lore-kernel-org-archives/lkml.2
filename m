Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1DDQbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:31:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1DDQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:31:01 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Get early printk console earlier
Date: Mon,  4 Apr 2011 18:30:55 +0200
Message-Id: <1301934655-20495-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1301934655-20495-1-git-send-email-monstr@monstr.eu>
References: <1301934655-20495-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Register early console as standard console
2. Enable CON_BOOT console flag to ensure auto-unregistering by the kernel
3. remap_early_printk function remap physical console baseaddr to virtual space

Usage specific function for console remap is done after memory initialization
with IRQ turn off that's why there is not necessary to protect it.

The reason for remapping is that the kernel use TLB 63 for 1:1 address mapping
to be able to use console in very early boot-up phase. But allocating one TLB
just for console caused performance degression that's why ioremaps create new
mapping and TLB 63 is automatically released and ready to use.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/setup.h   |    1 +
 arch/microblaze/kernel/early_printk.c |   17 +++++++++++++----
 arch/microblaze/kernel/setup.c        |    5 +++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/include/asm/setup.h b/arch/microblaze/include/asm/setup.h
index 8f39689..904e5ef 100644
--- a/arch/microblaze/include/asm/setup.h
+++ b/arch/microblaze/include/asm/setup.h
@@ -23,6 +23,7 @@ extern char cmd_line[COMMAND_LINE_SIZE];
 void early_printk(const char *fmt, ...);
 
 int setup_early_printk(char *opt);
+void remap_early_printk(void);
 void disable_early_printk(void);
 
 #if defined(CONFIG_EARLY_PRINTK)
diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index c3616a0..1c11191 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -60,7 +60,7 @@ static void early_printk_uartlite_write(struct console *unused,
 static struct console early_serial_uartlite_console = {
 	.name = "earlyser",
 	.write = early_printk_uartlite_write,
-	.flags = CON_PRINTBUFFER,
+	.flags = CON_PRINTBUFFER | CON_BOOT,
 	.index = -1,
 };
 #endif /* CONFIG_SERIAL_UARTLITE_CONSOLE */
@@ -104,7 +104,7 @@ static void early_printk_uart16550_write(struct console *unused,
 static struct console early_serial_uart16550_console = {
 	.name = "earlyser",
 	.write = early_printk_uart16550_write,
-	.flags = CON_PRINTBUFFER,
+	.flags = CON_PRINTBUFFER | CON_BOOT,
 	.index = -1,
 };
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
@@ -141,7 +141,7 @@ int __init setup_early_printk(char *opt)
 		early_printk("early_printk_console is enabled at 0x%08x\n",
 							base_addr);
 
-		/* register_console(early_console); */
+		register_console(early_console);
 
 		return 0;
 	}
@@ -160,7 +160,7 @@ int __init setup_early_printk(char *opt)
 		early_printk("early_printk_console is enabled at 0x%08x\n",
 							base_addr);
 
-		/* register_console(early_console); */
+		register_console(early_console);
 
 		return 0;
 	}
@@ -169,6 +169,15 @@ int __init setup_early_printk(char *opt)
 	return 1;
 }
 
+/* Remap early console to virtual address and do not allocate one TLB
+ * only for early console because of performance degression */
+void remap_early_printk(void)
+{
+	printk("early_printk_console remaping from 0x%x to ", base_addr);
+	base_addr = (u32) ioremap(base_addr, PAGE_SIZE);
+	printk("0x%x\n", base_addr);
+}
+
 void __init disable_early_printk(void)
 {
 	if (!early_console_initialized || !early_console)
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 8e2c09b..0e654a1 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -59,6 +59,11 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_memory();
 
+#ifdef CONFIG_EARLY_PRINTK
+	/* remap early console to virtual address */
+	remap_early_printk();
+#endif
+
 	xilinx_pci_init();
 
 #if defined(CONFIG_SELFMOD_INTC) || defined(CONFIG_SELFMOD_TIMER)
-- 
1.5.5.6

