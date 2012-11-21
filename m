Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2KUHSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:18:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42610 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2KUHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:16:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 08/12] x86, boot: Don't check if cmd_line_ptr is accessible in misc/decompressor()
Date: Tue, 20 Nov 2012 23:16:06 -0800
Message-Id: <1353482170-10160-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At that stage, it is already in 32bit protected mode or 64bit mode.
so we do not need to check if ptr less 1M.

When go from other boot loader (kexec) instead of boot/ code path.

Move out accessible checking out __cmdline_find_option....

So misc.c will parse cmdline and have debug print out.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/boot.h    |   14 ++++++++++++--
 arch/x86/boot/cmdline.c |    8 ++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 18997e5..7fadf80 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -289,12 +289,22 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
 int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	return __cmdline_find_option(boot_params.hdr.cmd_line_ptr, option, buffer, bufsize);
+	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	if (cmd_line_ptr >= 0x100000)
+		return -1;      /* inaccessible */
+
+	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
 }
 
 static inline int cmdline_find_option_bool(const char *option)
 {
-	return __cmdline_find_option_bool(boot_params.hdr.cmd_line_ptr, option);
+	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+
+	if (cmd_line_ptr >= 0x100000)
+		return -1;      /* inaccessible */
+
+	return __cmdline_find_option_bool(cmd_line_ptr, option);
 }
 
 
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 6b3b6f7..768f00f 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -41,8 +41,8 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
 		st_bufcpy	/* Copying this to buffer */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
@@ -111,8 +111,8 @@ int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
 		st_wordskip,	/* Miscompare, skip */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
-- 
1.7.7

