Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0DKHZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 03:25:34 -0400
Received: from imr1.ericy.com ([198.24.6.9]:34093 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0DKHZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 03:25:33 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH][RESEND/RFC] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE is undefined
Date: Tue, 30 Mar 2010 22:28:25 -0700
Message-ID: <1270013305-25904-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current early_printk code writes into VGA memory space even
if CONFIG_VGA_CONSOLE is undefined. This can cause problems
if there is no VGA device in the system, especially if the memory
is used by another device.

Fix problem by redirecting output to early_serial_console
if CONFIG_VGA_CONSOLE is undefined.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 arch/x86/kernel/early_printk.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b9c830c..1942039 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -160,8 +160,16 @@ static struct console early_serial_console = {
 	.index =	-1,
 };
 
+#ifdef CONFIG_VGA_CONSOLE
+#define EARLY_CONSOLE	early_vga_console
+static const int have_vga_console = 1;
+#else
+#define EARLY_CONSOLE	early_serial_console
+static const int have_vga_console;
+#endif
+
 /* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
+static struct console *early_console = &EARLY_CONSOLE;
 static int __initdata early_console_initialized;
 
 asmlinkage void early_printk(const char *fmt, ...)
@@ -216,7 +224,7 @@ static int __init setup_early_printk(char *buf)
 			early_serial_init(buf + 4);
 			early_console_register(&early_serial_console, keep);
 		}
-		if (!strncmp(buf, "vga", 3) &&
+		if (have_vga_console && !strncmp(buf, "vga", 3) &&
 		    boot_params.screen_info.orig_video_isVGA == 1) {
 			max_xpos = boot_params.screen_info.orig_video_cols;
 			max_ypos = boot_params.screen_info.orig_video_lines;
-- 
1.7.0.87.g0901d

