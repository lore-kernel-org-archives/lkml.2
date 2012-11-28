Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2K1Hwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:52:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40377 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2K1Hv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 09/13] x86: use io_remap to access real_mode_data
Date: Tue, 27 Nov 2012 23:50:38 -0800
Message-Id: <1354089042-10023-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 64bit bootloader put real mode data above 4g, We can not
access real mode data directly yet.

because in arch/x86/kernel/head_64.S, only set ident mapping
for 0-1g, and kernel code/data/bss.

So need to move early_ioremap_init() calling early from setup_arch()
to x86_64_start_kernel().

Also use rsi/rdi instead of esi/edi for real_data pointer passing
between asm code and c code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head64.c  |   17 ++++++++++++++---
 arch/x86/kernel/head_64.S |    4 ++--
 arch/x86/kernel/setup.c   |    2 ++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 3ac6cad..735cd47 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -52,12 +52,21 @@ static void __init copy_bootdata(char *real_mode_data)
 {
 	char * command_line;
 	unsigned long cmd_line_ptr;
+	char *p;
 
-	memcpy(&boot_params, real_mode_data, sizeof boot_params);
+	/*
+	 * for 64bit bootload path, those data could be above 4G,
+	 * and we do set ident mapping for them in head_64.S.
+	 * So need to ioremap to access them.
+	 */
+	p = early_memremap((unsigned long)real_mode_data, sizeof(boot_params));
+	memcpy(&boot_params, p, sizeof(boot_params));
+	early_iounmap(p, sizeof(boot_params));
 	cmd_line_ptr = get_cmd_line_ptr();
 	if (cmd_line_ptr) {
-		command_line = __va(cmd_line_ptr);
+		command_line = early_memremap(cmd_line_ptr, COMMAND_LINE_SIZE);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+		early_iounmap(command_line, COMMAND_LINE_SIZE);
 	}
 }
 
@@ -104,7 +113,9 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	early_ioremap_init();
+
+	copy_bootdata(real_mode_data);
 
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 338799a..9f6526a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -409,9 +409,9 @@ ENTRY(secondary_startup_64)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
-	/* esi is pointer to real mode structure with interesting info.
+	/* rsi is pointer to real mode structure with interesting info.
 	   pass it to C */
-	movl	%esi, %edi
+	movq	%rsi, %rdi
 	
 	/* Finally jump to run C code and to be on real kernel address
 	 * Since we are running on identity-mapped space we have to jump
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 194e151..573fa7d7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -718,7 +718,9 @@ void __init setup_arch(char **cmdline_p)
 
 	early_trap_init();
 	early_cpu_init();
+#ifdef CONFIG_X86_32
 	early_ioremap_init();
+#endif
 
 	setup_olpc_ofw_pgd();
 
-- 
1.7.7

