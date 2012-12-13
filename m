Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2LMWIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:08:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50455 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2LMWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:50 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 12/27] x86: use io_remap to access real_mode_data
Date: Thu, 13 Dec 2012 14:02:06 -0800
Message-Id: <1355436141-8668-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 64bit bootloader put real mode data above 4g, We can not
access real mode data directly yet.

because in arch/x86/kernel/head_64.S, only set ident mapping
for 0-1g, and kernel code/data/bss.

Move early_ioremap_init() calling as early as possible to
x86_64_start_kernel.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head64.c |   26 +++++++++++++++++++++++---
 arch/x86/kernel/setup.c  |    2 ++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 0e83fc9..16eb325 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -62,12 +62,21 @@ static void __init copy_bootdata(char *real_mode_data)
 {
 	char * command_line;
 	unsigned long cmd_line_ptr;
+	char *p;
 
-	memcpy(&boot_params, real_mode_data, sizeof boot_params);
+	/*
+	 * for 64bit bootloader path, those data could be above 4G,
+	 * and we do not set ident mapping for them in head_64.S.
+	 * So need to use ioremap to access them.
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
 
@@ -92,6 +101,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/* boot_params is in bss */
+	early_ioremap_init();
+	copy_bootdata(real_mode_data);
+
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
@@ -114,7 +127,14 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/*
+	 * hdr.version is always not 0, so check it to see
+	 *  if boot_params is copied or not.
+	 */
+	if (!boot_params.hdr.version) {
+		early_ioremap_init();
+		copy_bootdata(real_mode_data);
+	}
 
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9546c90..e636c83 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -714,7 +714,9 @@ void __init setup_arch(char **cmdline_p)
 
 	early_trap_init();
 	early_cpu_init();
+#ifdef CONFIG_X86_32
 	early_ioremap_init();
+#endif
 
 	setup_olpc_ofw_pgd();
 
-- 
1.7.10.4

