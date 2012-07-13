Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2GMVUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:20:45 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35775 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2GMVUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/6] m32r: Add memcpy() for CONFIG_KERNEL_GZIP=y
Date: Fri, 13 Jul 2012 23:20:26 +0200
Message-Id: <1342214427-17607-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
References: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  LD      arch/m32r/boot/compressed/vmlinux
arch/m32r/boot/compressed/misc.o: In function `zlib_updatewindow':
misc.c:(.text+0x190): undefined reference to `memcpy'
misc.c:(.text+0x190): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x1e0): undefined reference to `memcpy'
misc.c:(.text+0x1e0): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x218): undefined reference to `memcpy'
misc.c:(.text+0x218): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
arch/m32r/boot/compressed/misc.o: In function `zlib_inflate':
misc.c:(.text+0x171c): undefined reference to `memcpy'
misc.c:(.text+0x171c): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
make[5]: *** [arch/m32r/boot/compressed/vmlinux] Error 1

Add our own implementation of memcpy() to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m32r/boot/compressed/misc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/boot/compressed/misc.c b/arch/m32r/boot/compressed/misc.c
index 370d608..3147aa2 100644
--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -39,6 +39,16 @@ static void *memset(void *s, int c, size_t n)
 #endif
 
 #ifdef CONFIG_KERNEL_GZIP
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	char *d = dest;
+	const char *s = src;
+	while (n--)
+		*d++ = *s++;
+
+	return dest;
+}
+
 #define BOOT_HEAP_SIZE             0x10000
 #include "../../../../lib/decompress_inflate.c"
 #endif
-- 
1.7.0.4

