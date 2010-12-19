Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0LSKHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 05:07:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55997 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0LSKG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 05:06:59 -0500
Message-ID: <4D0DD916.4040609@kernel.org>
Date: Sun, 19 Dec 2010 02:06:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, boot: Don't check if cmd_line_ptr is accessible in misc/decompressor()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At that stage, it is already in 32bit protected mode or 64bit mode.
so we do not need to check if ptr less 1M.

When go from other boot loader (kdump) instead of boot/ code path.

Try to move out accessiable checking out __cmdline_find_option....

So misc.c will parse cmdline and have debug print out.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/boot.h    |   14 ++++++++++++--
 arch/x86/boot/cmdline.c |    8 ++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/boot/boot.h
===================================================================
--- linux-2.6.orig/arch/x86/boot/boot.h
+++ linux-2.6/arch/x86/boot/boot.h
@@ -289,12 +289,22 @@ int __cmdline_find_option(u32 cmdline_pt
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
 
 
Index: linux-2.6/arch/x86/boot/cmdline.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/cmdline.c
+++ linux-2.6/arch/x86/boot/cmdline.c
@@ -41,8 +41,8 @@ int __cmdline_find_option(u32 cmdline_pt
 		st_bufcpy	/* Copying this to buffer */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
@@ -111,8 +111,8 @@ int __cmdline_find_option_bool(u32 cmdli
 		st_wordskip,	/* Miscompare, skip */
 	} state = st_wordstart;
 
-	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-		return -1;	/* No command line, or inaccessible */
+	if (!cmdline_ptr)
+		return -1;      /* No command line */
 
 	cptr = cmdline_ptr & 0xf;
 	set_fs(cmdline_ptr >> 4);
