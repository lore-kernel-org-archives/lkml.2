Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2DUUQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:16:23 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:37400 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2DUUQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:16:21 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] m68k/video: Create <asm/vga.h>
Date: Sat, 21 Apr 2012 22:16:11 +0200
Message-Id: <1335039371-10805-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, it just contains the hack for cirrusfb on Amiga, which is moved
out of <video/vga.h> with some slight modifications (use raw_*() instead of
z_*(), which are defined on all m68k platforms).

This makes it safe to include <video/vga.h> in all contexts. Before it
could fail to compile with

include/video/vga.h: In function ‘vga_mm_r’:
include/video/vga.h:242: error: implicit declaration of function ‘z_readb’
include/video/vga.h: In function ‘vga_mm_w’:
include/video/vga.h:247: error: implicit declaration of function ‘z_writeb’
include/video/vga.h: In function ‘vga_mm_w_fast’:
include/video/vga.h:253: error: implicit declaration of function ‘z_writew’

or

include/video/vga.h:23:21: error: asm/vga.h: No such file or directory

depending on the value of CONFIG_AMIGA.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
---
Will queue for 3.5, cfr.
http://kisskb.ellerman.id.au/kisskb/buildresult/6127136/
---
 arch/m68k/include/asm/vga.h |   27 +++++++++++++++++++++++++++
 include/video/vga.h         |   22 ----------------------
 2 files changed, 27 insertions(+), 22 deletions(-)
 create mode 100644 arch/m68k/include/asm/vga.h

diff --git a/arch/m68k/include/asm/vga.h b/arch/m68k/include/asm/vga.h
new file mode 100644
index 0000000..d3aa140
--- /dev/null
+++ b/arch/m68k/include/asm/vga.h
@@ -0,0 +1,27 @@
+#ifndef _ASM_M68K_VGA_H
+#define _ASM_M68K_VGA_H
+
+#include <asm/raw_io.h>
+
+/*
+ * FIXME
+ * Ugh, we don't have PCI space, so map readb() and friends to use raw I/O
+ * accessors, which are identical to the z_*() Zorro bus accessors.
+ * This should make cirrusfb work again on Amiga
+ */
+#undef inb_p
+#undef inw_p
+#undef outb_p
+#undef outw
+#undef readb
+#undef writeb
+#undef writew
+#define inb_p(port)		0
+#define inw_p(port)		0
+#define outb_p(port, val)	do { } while (0)
+#define outw(port, val)		do { } while (0)
+#define readb			raw_inb
+#define writeb			raw_outb
+#define writew			raw_outw
+
+#endif /* _ASM_M68K_VGA_H */
diff --git a/include/video/vga.h b/include/video/vga.h
index 2b8691f..cac567f 100644
--- a/include/video/vga.h
+++ b/include/video/vga.h
@@ -19,29 +19,7 @@
 
 #include <linux/types.h>
 #include <asm/io.h>
-#ifndef CONFIG_AMIGA
 #include <asm/vga.h>
-#else
-/*
- * FIXME
- * Ugh, we don't have PCI space, so map readb() and friends to use Zorro space
- * for MMIO accesses. This should make cirrusfb work again on Amiga
- */
-#undef inb_p
-#undef inw_p
-#undef outb_p
-#undef outw
-#undef readb
-#undef writeb
-#undef writew
-#define inb_p(port)	0
-#define inw_p(port)	0
-#define outb_p(port, val)	do { } while (0)
-#define outw(port, val)		do { } while (0)
-#define readb		z_readb
-#define writeb		z_writeb
-#define writew		z_writew
-#endif
 #include <asm/byteorder.h>
 
 
-- 
1.7.0.4

