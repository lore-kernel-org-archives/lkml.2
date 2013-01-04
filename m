Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3ADAuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3ADAuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 14/31] x86, boot: move checking of cmd_line_ptr out of common path
Date: Thu,  3 Jan 2013 16:48:34 -0800
Message-Id: <1357260531-11115-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmdline.c::__cmdline_find_option... are shared between 16-bit setup code
and 32/64 bit decompressor code.

for 32/64 only path via kexec, we should not check if ptr is less 1M.
as those cmdline could be put above 1M, or even 4G.

Move out accessible checking out of __cmdline_find_option()
So decompressor in misc.c can parse cmdline correctly.

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
1.7.10.4

