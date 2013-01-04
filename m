Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3ADAuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3ADAuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:09 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 15/31] x86, boot: pass cmd_line_ptr with unsigned long instead
Date: Thu,  3 Jan 2013 16:48:35 -0800
Message-Id: <1357260531-11115-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

boot/compressed/misc.c is used for bzImage in 64bit and 32bit, and
cmd_line_ptr could point to buffer that is above 4g, cmd_line_ptr
should be 64bit otherwise high 32bit will be capped out.

So need to change data type to unsigned long, that will be 64bit get
correct address of command line buffer.

and it is still ok with 32bit bzImage, because unsigned long for them
is still 32bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/boot.h    |    8 ++++----
 arch/x86/boot/cmdline.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 7fadf80..5b75319 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -285,11 +285,11 @@ struct biosregs {
 void intcall(u8 int_no, const struct biosregs *ireg, struct biosregs *oreg);
 
 /* cmdline.c */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize);
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize);
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
@@ -299,7 +299,7 @@ static inline int cmdline_find_option(const char *option, char *buffer, int bufs
 
 static inline int cmdline_find_option_bool(const char *option)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 768f00f..625d21b 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -27,7 +27,7 @@ static inline int myisspace(u8 c)
  * Returns the length of the argument (regardless of if it was
  * truncated to fit in the buffer), or -1 on not found.
  */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize)
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize)
 {
 	addr_t cptr;
 	char c;
@@ -99,7 +99,7 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
  * Returns the position of that option (starts counting with 1)
  * or 0 on not found
  */
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 {
 	addr_t cptr;
 	char c;
-- 
1.7.10.4

