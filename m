Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1AISm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 13:42:59 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:35186 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1AISm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 13:42:58 -0500
Date: Sun, 9 Jan 2011 19:42:57 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] m68k: Uninline strchr()
Message-ID: <alpine.DEB.2.00.1101091942230.26296@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of gcc replace calls to strstr() with single-character
"needle" string parameters by calls to strchr() behind our back.

If strchr() is defined as an inline function, this causes linking errors
like

	ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!

As m68k is the only architecture that has an inline strchr() and this
inline version is not an optimized asm version, uninline strchr() and use
the standard out-of-line C version in lib/string.c instead.

This also decreases the defconfig/allmodconfig kernel image sizes by a few
hundred bytes.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index 2936dda..65b1312 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -81,18 +81,6 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
 	strcpy(__d + strlen(__d), (s));		\
 })
 
-#define __HAVE_ARCH_STRCHR
-static inline char *strchr(const char *s, int c)
-{
-	char sc, ch = c;
-
-	for (; (sc = *s++) != ch; ) {
-		if (!sc)
-			return NULL;
-	}
-	return (char *)s - 1;
-}
-
 #ifndef CONFIG_COLDFIRE
 #define __HAVE_ARCH_STRCMP
 static inline int strcmp(const char *cs, const char *ct)
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
