Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2KXUic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 15:38:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18264 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2KXUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 15:36:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 06/11] x86, boot: add get_cmd_line_ptr()
Date: Sat, 24 Nov 2012 12:35:32 -0800
Message-Id: <1353789337-19409-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353789337-19409-1-git-send-email-yinghai@kernel.org>
References: <1353789337-19409-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

later will check ext_cmd_line_ptr at the same time.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/cmdline.c |   10 ++++++++--
 arch/x86/kernel/head64.c           |   13 +++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index 10f6b11..b4c913c 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -13,13 +13,19 @@ static inline char rdfs8(addr_t addr)
 	return *((char *)(fs + addr));
 }
 #include "../cmdline.c"
+static unsigned long get_cmd_line_ptr(void)
+{
+	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
+
+	return cmd_line_ptr;
+}
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
+	return __cmdline_find_option(get_cmd_line_ptr(), option, buffer, bufsize);
 }
 int cmdline_find_option_bool(const char *option)
 {
-	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
+	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
 }
 
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 00e612a..3ac6cad 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -41,13 +41,22 @@ static void __init clear_bss(void)
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
 }
 
+static unsigned long get_cmd_line_ptr(void)
+{
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	return cmd_line_ptr;
+}
+
 static void __init copy_bootdata(char *real_mode_data)
 {
 	char * command_line;
+	unsigned long cmd_line_ptr;
 
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
-	if (boot_params.hdr.cmd_line_ptr) {
-		command_line = __va(boot_params.hdr.cmd_line_ptr);
+	cmd_line_ptr = get_cmd_line_ptr();
+	if (cmd_line_ptr) {
+		command_line = __va(cmd_line_ptr);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
 }
-- 
1.7.7

