Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0JKR7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:59:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49417 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0JKR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:59:17 -0400
Message-ID: <4CB35050.7060207@kernel.org>
Date: Mon, 11 Oct 2010 10:58:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v4] x86: Setup early console as early as possible in x86_start_kernel()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
and call setup_early_serial8250_console() to init early serial console.

Only can handle io port kind of 8250, because mmio need ioremap.

Use boot_params.hdr.version instead of adding another variable, Suggested by hpa.
Also need to apply this one after x86 memblock patchset.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/setup.h |    2 ++
 arch/x86/kernel/head.c       |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/head32.c     |    2 ++
 arch/x86/kernel/head64.c     |   13 ++++++++++++-
 kernel/printk.c              |    4 ++++
 5 files changed, 46 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -42,6 +42,8 @@ static inline void visws_early_detect(vo
 #endif
 
 extern unsigned long saved_video_mode;
+int setup_early_serial8250_console(char *cmdline);
+void setup_early_console(void);
 
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
Index: linux-2.6/arch/x86/kernel/head.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head.c
+++ linux-2.6/arch/x86/kernel/head.c
@@ -54,3 +54,29 @@ void __init reserve_ebda_region(void)
 	/* reserve all memory between lowmem and the 1MB mark */
 	memblock_x86_reserve_range(lowmem, 0x100000, "* BIOS reserved");
 }
+
+void __init setup_early_console(void)
+{
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+	char constr[64], *p, *q;
+
+	/* Can not handle mmio type 8250 uart yet, too early */
+	p = strstr(boot_command_line, "console=uart8250,io,");
+	if (!p)
+		p = strstr(boot_command_line, "console=uart,io,");
+	if (!p)
+		return;
+
+	p += 8;	/* sizeof "console=" */
+	q = strchr(p, ' ');
+	if ((q - p) >= sizeof(constr))
+		return;
+
+	memset(constr, 0, sizeof(constr));
+	memcpy(constr, p, q - p);
+
+	lockdep_init();
+
+	setup_early_serial8250_console(constr);
+#endif
+}
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -31,6 +31,8 @@ static void __init i386_default_early_se
 
 void __init i386_start_kernel(void)
 {
+	setup_early_console();
+
 	memblock_init();
 
 #ifdef CONFIG_X86_TRAMPOLINE
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -74,6 +74,10 @@ void __init x86_64_start_kernel(char * r
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/* boot_params is in bss */
+	copy_bootdata(__va(real_mode_data));
+	setup_early_console();
+
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
@@ -97,7 +101,14 @@ void __init x86_64_start_kernel(char * r
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/*
+	 * hdr.version is always not 0, so check it to see
+	 *  if boot_params is copied or not.
+	 */
+	if (!boot_params.hdr.version) {
+		copy_bootdata(__va(real_mode_data));
+		setup_early_console();
+	}
 
 	memblock_init();
 
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1232,6 +1232,10 @@ void register_console(struct console *ne
 	if (console_drivers && newcon->flags & CON_BOOT) {
 		/* find the last or real console */
 		for_each_console(bcon) {
+			/* not again */
+			if (bcon == newcon)
+				return;
+
 			if (!(bcon->flags & CON_BOOT)) {
 				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
 					newcon->name, newcon->index);
