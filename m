Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2GVA7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:59:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2GVA73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:59:29 -0400
Date: Sat, 21 Jul 2012 17:59:10 -0700
From: tip-bot for Gokul Caushik <gcaushik@pdx.edu>
Message-ID: <tip-bd448d4d0a1bd88dc6fdc41217b2c25383fa8529@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gcaushik@pdx.edu, hpa@zytor.com,
        mingo@kernel.org, caushik1@gmail.com, jmillenbach@gmail.com,
        tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, gcaushik@pdx.edu,
        linux-kernel@vger.kernel.org, caushik1@gmail.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <1342746282-28497-8-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-8-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Exclude cmdline.c if you can't use it
Git-Commit-ID: bd448d4d0a1bd88dc6fdc41217b2c25383fa8529
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:59:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd448d4d0a1bd88dc6fdc41217b2c25383fa8529
Gitweb:     http://git.kernel.org/tip/bd448d4d0a1bd88dc6fdc41217b2c25383fa8529
Author:     Gokul Caushik <gcaushik@pdx.edu>
AuthorDate: Thu, 19 Jul 2012 18:04:42 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:39 -0700

x86, boot: Exclude cmdline.c if you can't use it

CONFIG_EARLY_PRINTK is the only feature that might use command line
parsing in the decompression stage.  If it is disabled then we can
exclude the related code to save space. This can result in an estimated
space savings of 2240 bytes from the compressed kernel image.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-8-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
