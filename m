Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2GVA4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:56:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2GVA4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:56:48 -0400
Date: Sat, 21 Jul 2012 17:56:34 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-7aac3015b533add3e85222f9fd2ab66216b38746@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-5-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-5-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Switch output functions from command-line flags to conditional compilation
Git-Commit-ID: 7aac3015b533add3e85222f9fd2ab66216b38746
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:56:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7aac3015b533add3e85222f9fd2ab66216b38746
Gitweb:     http://git.kernel.org/tip/7aac3015b533add3e85222f9fd2ab66216b38746
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:39 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:25 -0700

x86, boot: Switch output functions from command-line flags to conditional compilation

Changed putstr flagging from parameter to conditional compilation for puts,
debug_putstr, and error_putstr. This allows for space savings since most
configurations won't use this feature.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-5-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |   12 +-----------
 arch/x86/boot/compressed/misc.h |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index de1d54d..8c29f82 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -169,15 +169,11 @@ static void serial_putchar(int ch)
 	outb(ch, early_serial_base + TXR);
 }
 
-void __putstr(int error, const char *s)
+void __putstr(const char *s)
 {
 	int x, y, pos;
 	char c;
 
-#ifndef CONFIG_X86_VERBOSE_BOOTUP
-	if (!error)
-		return;
-#endif
 	if (early_serial_base) {
 		const char *str = s;
 		while (*str) {
@@ -223,12 +219,6 @@ void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-static void debug_putstr(const char *s)
-{
-	if (debug)
-		putstr(s);
-}
-
 void *memset(void *s, int c, size_t n)
 {
 	int i;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4c1bfb6..618e5c8 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -24,10 +24,19 @@
 
 /* misc.c */
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
-void __putstr(int error, const char *s);
-#define putstr(__x)  __putstr(0, __x)
-#define error_putstr(__x)  __putstr(1, __x)
-#define puts(__x)  __putstr(0, __x)
+void __putstr(const char *s);
+#define error_putstr(__x)  __putstr(__x)
+
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+
+#define debug_putstr(__x)  __putstr(__x)
+
+#else
+
+static inline void debug_putstr(const char *s)
+{ }
+
+#endif
 
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
