Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2GTBFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:05:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2GTBFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:05:01 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCH 2/7] x86/boot: Wrap debug printing in a new debug_putstr function
Date: Thu, 19 Jul 2012 18:04:37 -0700
Message-Id: <1342746282-28497-3-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all instances of if (debug) putstr(...) to a new debug_putstr(...).
This allows a future change to conditionally stub out debug_putstr to save
space.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/misc.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8f2355d..49c6d56 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -223,6 +223,12 @@ void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
+static void debug_putstr(const char *s)
+{
+	if (debug)
+		putstr(s);
+}
+
 void *memset(void *s, int c, size_t n)
 {
 	int i;
@@ -293,8 +299,7 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	if (debug)
-		putstr("Parsing ELF... ");
+	debug_putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
 	if (!phdrs)
@@ -346,8 +351,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	cols = real_mode->screen_info.orig_video_cols;
 
 	console_init();
-	if (debug)
-		putstr("early console in decompress_kernel\n");
+	debug_putstr("early console in decompress_kernel\n");
 
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -366,11 +370,9 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 		error("Wrong destination address");
 #endif
 
-	if (debug)
-		putstr("\nDecompressing Linux... ");
+	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	if (debug)
-		putstr("done.\nBooting the kernel.\n");
+	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
-- 
1.7.9.5

