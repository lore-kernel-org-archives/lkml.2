Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1LULSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:43591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1LULSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:24 -0500
Message-Id: <20111221111143.346150952@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/7] arch, early_printk: Consolidate early_printk() implementations
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=tglx-early-printk-consolidate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ expose early_vprintk(), change return values ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/early_printk.c        |   17 ++--------------
 arch/blackfin/kernel/early_printk.c   |    2 -
 arch/microblaze/kernel/early_printk.c |   24 ++---------------------
 arch/mips/kernel/early_printk.c       |   10 +++------
 arch/powerpc/kernel/udbg.c            |    6 +----
 arch/sh/kernel/sh_bios.c              |    2 -
 arch/sparc/kernel/setup_32.c          |    1 
 arch/sparc/kernel/setup_64.c          |    8 ++++++-
 arch/tile/kernel/early_printk.c       |   26 +++----------------------
 arch/um/kernel/early_printk.c         |    8 ++++---
 arch/unicore32/kernel/early_printk.c  |   12 +++--------
 arch/x86/kernel/early_printk.c        |   21 +-------------------
 include/linux/console.h               |    1 
 include/linux/printk.h                |   13 +++++++++++-
 kernel/printk.c                       |   35 +++++++++++++++++++++++++++-------
 15 files changed, 76 insertions(+), 110 deletions(-)
--- a/arch/arm/kernel/early_printk.c
+++ b/arch/arm/kernel/early_printk.c
@@ -29,28 +29,17 @@ static void early_console_write(struct c
 	early_write(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name =		"earlycon",
 	.write =	early_console_write,
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
 
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_write(buf, n);
-	va_end(ap);
-}
-
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	early_console = &early_console_dev;
+	register_console(&early_console_dev);
 	return 0;
 }
 
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -25,8 +25,6 @@ extern struct console *bfin_earlyserial_
 extern struct console *bfin_jc_early_init(void);
 #endif
 
-static struct console *early_console;
-
 /* Default console */
 #define DEFAULT_PORT 0
 #define DEFAULT_CFLAG CS8|B57600
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 
-static u32 early_console_initialized;
 static u32 base_addr;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
@@ -109,27 +108,11 @@ static struct console early_serial_uart1
 };
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
-static struct console *early_console;
-
-void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	if (early_console_initialized) {
-		va_start(ap, fmt);
-		n = vscnprintf(buf, 512, fmt, ap);
-		early_console->write(early_console, buf, n);
-		va_end(ap);
-	}
-}
-
 int __init setup_early_printk(char *opt)
 {
 	int version = 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	base_addr = of_early_console(&version);
@@ -159,7 +142,6 @@ int __init setup_early_printk(char *opt)
 		}
 
 		register_console(early_console);
-		early_console_initialized = 1;
 		return 0;
 	}
 	return 1;
@@ -179,9 +161,9 @@ void __init remap_early_printk(void)
 
 void __init disable_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	printk(KERN_WARNING "disabling early console\n");
 	unregister_console(early_console);
-	early_console_initialized = 0;
+	early_console = NULL;
 }
--- a/arch/mips/kernel/early_printk.c
+++ b/arch/mips/kernel/early_printk.c
@@ -25,20 +25,18 @@ early_console_write(struct console *con,
 	}
 }
 
-static struct console early_console __initdata = {
+static struct console early_console_prom = {
 	.name	= "early",
 	.write	= early_console_write,
 	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1
 };
 
-static int early_console_initialized __initdata;
-
 void __init setup_early_printk(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
-	early_console_initialized = 1;
+	early_console = &early_console_prom;
 
-	register_console(&early_console);
+	register_console(&early_console_prom);
 }
--- a/arch/powerpc/kernel/udbg.c
+++ b/arch/powerpc/kernel/udbg.c
@@ -182,15 +182,13 @@ static struct console udbg_console = {
 	.index	= 0,
 };
 
-static int early_console_initialized;
-
 /*
  * Called by setup_system after ppc_md->probe and ppc_md->early_init.
  * Call it again after setting udbg_putc in ppc_md->setup_arch.
  */
 void __init register_early_udbg_console(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
 
 	if (!udbg_putc)
@@ -200,7 +198,7 @@ void __init register_early_udbg_console(
 		printk(KERN_INFO "early console immortal !\n");
 		udbg_console.flags &= ~CON_BOOT;
 	}
-	early_console_initialized = 1;
+	early_console = &udbg_console;
 	register_console(&udbg_console);
 }
 
--- a/arch/sh/kernel/sh_bios.c
+++ b/arch/sh/kernel/sh_bios.c
@@ -144,8 +144,6 @@ static struct console bios_console = {
 	.index		= -1,
 };
 
-static struct console *early_console;
-
 static int __init setup_early_printk(char *buf)
 {
 	int keep_early = 0;
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -221,6 +221,7 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
+	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 
 	/* Set sparc_cpu_model */
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -487,6 +487,12 @@ static void __init init_sparc64_elf_hwca
 		popc_patch();
 }
 
+static inline void register_prom_console(void)
+{
+	early_console = &prom_early_console;
+	register_console(&prom_early_console);
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -498,7 +504,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EARLYFB
 	if (btext_find_display())
 #endif
-		register_console(&prom_early_console);
+		register_prom_console();
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -32,25 +32,8 @@ static struct console early_hv_console =
 };
 
 /* Direct interface for emergencies */
-static struct console *early_console = &early_hv_console;
-static int early_console_initialized;
 static int early_console_complete;
 
-static void early_vprintk(const char *fmt, va_list ap)
-{
-	char buf[512];
-	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-}
-
-void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
@@ -68,14 +51,13 @@ static int __initdata keep_early;
 
 static int __init setup_early_printk(char *str)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	if (str != NULL && strncmp(str, "keep", 4) == 0)
 		keep_early = 1;
 
 	early_console = &early_hv_console;
-	early_console_initialized = 1;
 	register_console(early_console);
 
 	return 0;
@@ -84,12 +66,12 @@ static int __init setup_early_printk(cha
 void __init disable_early_printk(void)
 {
 	early_console_complete = 1;
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	if (!keep_early) {
 		early_printk("disabling early console\n");
 		unregister_console(early_console);
-		early_console_initialized = 0;
+		early_console = NULL;
 	} else {
 		early_printk("keeping early console\n");
 	}
@@ -97,7 +79,7 @@ void __init disable_early_printk(void)
 
 void warn_early_printk(void)
 {
-	if (early_console_complete || early_console_initialized)
+	if (early_console_complete || early_console)
 		return;
 	early_printk("\
 Machine shutting down before console output is fully initialized.\n\
--- a/arch/um/kernel/early_printk.c
+++ b/arch/um/kernel/early_printk.c
@@ -16,7 +16,7 @@ static void early_console_write(struct c
 	um_early_printk(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name = "earlycon",
 	.write = early_console_write,
 	.flags = CON_BOOT,
@@ -25,8 +25,10 @@ static struct console early_console = {
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
-
+	if (!early_console) {
+		early_console = &early_console_dev;
+		register_console(&early_console_dev);
+	}
 	return 0;
 }
 
--- a/arch/unicore32/kernel/early_printk.c
+++ b/arch/unicore32/kernel/early_printk.c
@@ -33,21 +33,17 @@ static struct console early_ocd_console 
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_ocd_console;
-
-static int __initdata keep_early;
-
 static int __init setup_early_printk(char *buf)
 {
-	if (!buf)
+	int keep_early;
+
+	if (!buf || early_console)
 		return 0;
 
 	if (strstr(buf, "keep"))
 		keep_early = 1;
 
-	if (!strncmp(buf, "ocd", 3))
-		early_console = &early_ocd_console;
+	early_console = &early_ocd_console;
 
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -169,25 +169,9 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
-static int __initdata early_console_initialized;
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-	va_end(ap);
-}
-
 static inline void early_console_register(struct console *con, int keep_early)
 {
-	if (early_console->index != -1) {
+	if (con->index != -1) {
 		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
 		       con->name);
 		return;
@@ -207,9 +191,8 @@ static int __init setup_early_printk(cha
 	if (!buf)
 		return 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 0;
-	early_console_initialized = 1;
 
 	keep = (strstr(buf, "keep") != NULL);
 
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -133,6 +133,7 @@ struct console {
 	for (con = console_drivers; con != NULL; con = con->next)
 
 extern int console_set_on_cmdline;
+extern struct console *early_console;
 
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -88,8 +88,19 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
-void early_printk(const char *fmt, ...);
+int early_printk(const char *fmt, ...);
+
+extern asmlinkage __printf(1, 0)
+int early_vprintk(const char *fmt, va_list args);
+#else
+static inline __printf(1, 2) __cold
+int early_printk(const char *s, ...) { return 0; }
+
+static inline __printf(1, 0) __cold
+int early_vprintk(const char *fmt, va_list args) { return 0; }
+#endif
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -44,13 +44,6 @@
 
 #include <asm/uaccess.h>
 
-/*
- * Architectures can override it:
- */
-void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
-{
-}
-
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
@@ -521,6 +514,34 @@ static void __call_console_drivers(unsig
 	}
 }
 
+#ifdef CONFIG_EARLY_PRINTK
+struct console *early_console;
+
+asmlinkage int early_vprintk(const char *fmt, va_list ap)
+{
+	char buf[512];
+	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	if (early_console)
+		early_console->write(early_console, buf, n);
+	else
+		n = 0;
+
+	return n;
+}
+
+asmlinkage int early_printk(const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = early_vprintk(fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+#endif
+
 static int __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)


