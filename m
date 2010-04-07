Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab0DGBwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:52:46 -0400
Received: from imr1.ericy.com ([198.24.6.9]:53841 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab0DGBwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:52:39 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
CC: mingo@redhat.com, x86@kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2] x86: Call setup_early_printk before first call to early_printk
Date: Tue, 6 Apr 2010 18:42:32 -0700
Message-ID: <1270604552-10051-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code calls setup_early_printk() too late to catch the initial calls
to early_printk(). This results in those early messages not to be printed on a
serial console. Also, if there is no VGA device in the system, it will cause
bad writes into VGA memory space. This can cause problems if the VGA memory
space is used by another device in such a system.

Fix the problem by calling setup_early_printk() immediately after the boot
command line is available, and by preventing early_printk() to print anything
before setup_early_printk() was executed.

Also removed conditional output "Kernel alive".

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
The first version of this patch used the headline
    x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE is undefined
I changed the headline to reflect its expanded scope.

I removed the "Kernel alive" message because I don't see how console_loglevel
can ever be equal to 10 when the code is executed. An alternative might be
(if that possibility exists after all) to move it after the call to
setup_early_printk().

 arch/x86/include/asm/setup.h   |    2 ++
 arch/x86/kernel/early_printk.c |    5 ++++-
 arch/x86/kernel/head32.c       |    4 ++++
 arch/x86/kernel/head64.c       |    7 ++++---
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..83847af 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -93,6 +93,8 @@ void *extend_brk(size_t size, size_t align);
 			: : "i" (sz));					\
 	}
 
+int __init setup_early_printk(char *buf);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b9c830c..873f1cd 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -170,6 +170,9 @@ asmlinkage void early_printk(const char *fmt, ...)
 	int n;
 	va_list ap;
 
+	if (!early_console_initialized)
+		return;
+
 	va_start(ap, fmt);
 	n = vscnprintf(buf, sizeof(buf), fmt, ap);
 	early_console->write(early_console, buf, n);
@@ -191,7 +194,7 @@ static inline void early_console_register(struct console *con, int keep_early)
 	register_console(early_console);
 }
 
-static int __init setup_early_printk(char *buf)
+int __init setup_early_printk(char *buf)
 {
 	int keep;
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index b2e2460..e2e9c2b 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -30,6 +30,10 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
+#ifdef CONFIG_EARLY_PRINTK
+	setup_early_printk(boot_command_line);
+#endif
+
 #ifdef CONFIG_X86_TRAMPOLINE
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7147143..1b4d6b2 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -88,9 +88,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
-	if (console_loglevel == 10)
-		early_printk("Kernel alive\n");
-
 	x86_64_start_reservations(real_mode_data);
 }
 
@@ -98,6 +95,10 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
+#ifdef CONFIG_EARLY_PRINTK
+	setup_early_printk(boot_command_line);
+#endif
+
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.7.0.87.g0901d

