Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2LRHVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:21:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38990 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2LRHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 10/27] x86, boot: add get_cmd_line_ptr()
Date: Mon, 17 Dec 2012 23:15:42 -0800
Message-Id: <1355814959-10573-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
index 0aff120..fe9037d 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -102,13 +102,22 @@ static void __init clear_bss(void)
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
1.7.10.4

