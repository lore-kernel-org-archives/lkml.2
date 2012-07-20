Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2GTBFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:05:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2GTBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:05:18 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com, Gokul Caushik <gcaushik@pdx.edu>
Subject: [PATCH 7/7] x86/boot: Exclude cmdline.c if you can't use it
Date: Thu, 19 Jul 2012 18:04:42 -0700
Message-Id: <1342746282-28497-8-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gokul Caushik <gcaushik@pdx.edu>

CONFIG_EARLY_PRINTK is the only feature that might use command line
parsing in the decompression stage.  If it is disabled then we can
exclude the related code to save space. This can result in an estimated
space savings of 2240 bytes from the compressed kernel image.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/cmdline.c |    4 ++++
 arch/x86/boot/compressed/misc.h    |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index cb62f78..10f6b11 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -1,5 +1,7 @@
 #include "misc.h"
 
+#ifdef CONFIG_EARLY_PRINTK
+
 static unsigned long fs;
 static inline void set_fs(unsigned long seg)
 {
@@ -19,3 +21,5 @@ int cmdline_find_option_bool(const char *option)
 {
 	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
 }
+
+#endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3ffee6e..0e6dc0e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -38,18 +38,19 @@ static inline void debug_putstr(const char *s)
 
 #endif
 
+#ifdef CONFIG_EARLY_PRINTK
+
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 
 /* early_serial_console.c */
-#ifdef CONFIG_EARLY_PRINTK
-
 extern int early_serial_base;
 void console_init(void);
 
 #else
 
+/* early_serial_console.c */
 static const int early_serial_base;
 static inline void console_init(void)
 { }
-- 
1.7.9.5

