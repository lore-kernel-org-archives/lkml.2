Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2HPNRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:17:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36621 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2HPNRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:48 -0400
MIME-Version: 1.0
Date: Thu, 16 Aug 2012 15:17:47 +0200
X-Google-Sender-Auth: LTkv_EjG7FFBVhyrSVHXkyyc8vQ
Message-ID: <CAMuHMdVEKpVYn+Yr5rzdOvV5zUWrD12Fas197Mn2oVDC5YgVgw@mail.gmail.com>
Subject: Regression: Spurious "^A" in UML output
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.6-rc1 UML, I see spurious "^A" (ASCII 1, SOH) characters in some kernel
messages:

Calibrating delay loop... 4640.76 BogoMIPS (lpj=23203840)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
^AChecking that host ptys support output SIGIO...Yes
^AChecking that host ptys support SIGIO on close...No, enabling workaround
^AUsing 2.6 host AIO
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource itimer

This happens for all output using the "printk(UM_KERN_XXX ...)" idiom.

The "UM_KERN_XXX" defines are generated from the KERN_XXX defines in
arch/um/include/shared/common-offsets.h using:

DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
DEFINE_STR(UM_KERN_ALERT, KERN_ALERT);
DEFINE_STR(UM_KERN_CRIT, KERN_CRIT);
DEFINE_STR(UM_KERN_ERR, KERN_ERR);
DEFINE_STR(UM_KERN_WARNING, KERN_WARNING);
DEFINE_STR(UM_KERN_NOTICE, KERN_NOTICE);
DEFINE_STR(UM_KERN_INFO, KERN_INFO);
DEFINE_STR(UM_KERN_DEBUG, KERN_DEBUG);
DEFINE_STR(UM_KERN_CONT, KERN_CONT);

Before commit 04d2c8c83d0e3ac5f78aeede51babb3236200112 ("printk: convert
the format for KERN_<LEVEL> to a 2 byte pattern"), these were expanded in
include/generated/asm-offsets.h to:

#define UM_KERN_EMERG "<0>" /* KERN_EMERG */
#define UM_KERN_ALERT "<1>" /* KERN_ALERT */
#define UM_KERN_CRIT "<2>" /* KERN_CRIT */
#define UM_KERN_ERR "<3>" /* KERN_ERR */
#define UM_KERN_WARNING "<4>" /* KERN_WARNING */
#define UM_KERN_NOTICE "<5>" /* KERN_NOTICE */
#define UM_KERN_INFO "<6>" /* KERN_INFO */
#define UM_KERN_DEBUG "<7>" /* KERN_DEBUG */
#define UM_KERN_CONT "<c>" /* KERN_CONT */

In v3.6-rc1, they expand to:

#define UM_KERN_EMERG "\001" /* "0" KERN_EMERG */
#define UM_KERN_ALERT "\001" /* "1" KERN_ALERT */
#define UM_KERN_CRIT "\001" /* "2" KERN_CRIT */
#define UM_KERN_ERR "\001" /* "3" KERN_ERR */
#define UM_KERN_WARNING "\001" /* "4" KERN_WARNING */
#define UM_KERN_NOTICE "\001" /* "5" KERN_NOTICE */
#define UM_KERN_INFO "\001" /* "6" KERN_INFO */
#define UM_KERN_DEBUG "\001" /* "7" KERN_DEBUG */
#define UM_KERN_CONT "\001" /* "c" KERN_CONT */

I.e. only the SOH character is retained in the actual define, the remainder ends
up in the comment.

Apparently the combo of DEFINE_STR() in
arch/x86/um/shared/sysdep/kernel-offsets.h
and sed-y in Kbuild doesn't support string constants consisting of
multiple parts.

A quick fix is the (whitespace-damaged) patch below, but this would reduce
readability. And I'm afraid my sed-foo is not good enough to fix it better.
Any takers?

diff --git a/include/linux/kern_levels.h b/include/linux/kern_levels.h
index 866caaa..1c43b52 100644
--- a/include/linux/kern_levels.h
+++ b/include/linux/kern_levels.h
@@ -4,16 +4,16 @@
 #define KERN_SOH       "\001"          /* ASCII Start Of Header */
 #define KERN_SOH_ASCII '\001'

-#define KERN_EMERG     KERN_SOH "0"    /* system is unusable */
-#define KERN_ALERT     KERN_SOH "1"    /* action must be taken immediately */
-#define KERN_CRIT      KERN_SOH "2"    /* critical conditions */
-#define KERN_ERR       KERN_SOH "3"    /* error conditions */
-#define KERN_WARNING   KERN_SOH "4"    /* warning conditions */
-#define KERN_NOTICE    KERN_SOH "5"    /* normal but significant condition */
-#define KERN_INFO      KERN_SOH "6"    /* informational */
-#define KERN_DEBUG     KERN_SOH "7"    /* debug-level messages */
+#define KERN_EMERG     "\0010"         /* system is unusable */
+#define KERN_ALERT     "\0011"         /* action must be taken immediately */
+#define KERN_CRIT      "\0012"         /* critical conditions */
+#define KERN_ERR       "\0013"         /* error conditions */
+#define KERN_WARNING   "\0014"         /* warning conditions */
+#define KERN_NOTICE    "\0015"         /* normal but significant condition */
+#define KERN_INFO      "\0016"         /* informational */
+#define KERN_DEBUG     "\0017"         /* debug-level messages */

-#define KERN_DEFAULT   KERN_SOH "d"    /* the default kernel loglevel */
+#define KERN_DEFAULT   "\001d"         /* the default kernel loglevel */

 /*
  * Annotation for a "continued" line of log printout (only done after a

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
