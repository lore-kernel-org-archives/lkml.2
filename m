Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2GTBGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:06:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2GTBFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:05:09 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCH 4/7] x86/boot: Switch output functions from command-line flags to conditional compilation
Date: Thu, 19 Jul 2012 18:04:39 -0700
Message-Id: <1342746282-28497-5-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed putstr flagging from parameter to conditional compilation for puts,
debug_putstr, and error_putstr. This allows for space savings since most
configurations won't use this feature.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
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
-- 
1.7.9.5

