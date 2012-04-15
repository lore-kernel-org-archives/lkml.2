Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab2DOTAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 15:00:23 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:33593 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2DOTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 15:00:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Make sure {read,write}s[bwl]() are always defined
Date: Sun, 15 Apr 2012 21:00:10 +0200
Message-Id: <1334516410-5777-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_ATARI_ROM_ISA is defined (e.g. allmodconfig), musb fails to
compile with:

In file included from drivers/usb/musb/musb_core.h:68,
                 from drivers/usb/musb/musb_core.c:104:
drivers/usb/musb/musb_io.h:45: error: conflicting types for ‘raw_insl’
arch/m68k/include/asm/raw_io.h:200: error: previous definition of ‘raw_insl’ was here
drivers/usb/musb/musb_io.h:47: error: conflicting types for ‘raw_insw’
arch/m68k/include/asm/raw_io.h:121: error: previous definition of ‘raw_insw’ was here
drivers/usb/musb/musb_io.h:52: error: conflicting types for ‘raw_outsl’
arch/m68k/include/asm/raw_io.h:240: error: previous definition of ‘raw_outsl’ was here
drivers/usb/musb/musb_io.h:54: error: conflicting types for ‘raw_outsw’
arch/m68k/include/asm/raw_io.h:161: error: previous definition of ‘raw_outsw’ was here
make[4]: *** [drivers/usb/musb/musb_core.o] Error 1

This happens because musb_io.h provides default implementations for
{read,write}s[bwl]() on most platforms, some of which conflict with their
Atari ROM ISA counterparts.

To avoid adding a check for CONFIG_ATARI_ROM_ISA to musb_io.h, make sure
{read,write}s[bwl]() are always defined on m68k, and disable the default
implementations in musb_io.h on m68k, like is already done for several
other architectures.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Ungerer <gerg@uclinux.org>
--
Felipe: OK if I carry this through the m68k tree, as CONFIG_ATARI_ROM_ISA
        (and this compile problem) is not yet in mainline, and fixing only
        musb_io.h now would introduce a regression in mainline?
        I could also proactively have m68k provide {read,write}s[bwl]() in
        mainline before pushing out Atari ROM ISA support.
Greg: Do you want a similar change for asm/io_no.h? Or move it to asm/io.h?
      Or do you want musb_io.h to check for
      "!(defined(CONFIG_M68K) && defined(CONFIG_MMU))" instead?
      Or don't you care, as allmodconfig never selects nommu anyway?
---
 arch/m68k/include/asm/io_mm.h |   12 +++++++-----
 drivers/usb/musb/musb_io.h    |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index eff3f83..73dc331 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -371,11 +371,6 @@ static inline void isa_delay(void)
 #define writeb(val,addr) out_8((addr),(val))
 #define readw(addr)      in_le16(addr)
 #define writew(val,addr) out_le16((addr),(val))
-
-#define readsw  raw_insw
-#define writesw raw_outsw
-#define readsl  raw_insl
-#define writesl raw_outsl
 #endif /* CONFIG_ATARI_ROM_ISA */
 
 #if !defined(CONFIG_ISA) && !defined(CONFIG_ATARI_ROM_ISA)
@@ -415,6 +410,13 @@ static inline void isa_delay(void)
 #define readl(addr)      in_le32(addr)
 #define writel(val,addr) out_le32((addr),(val))
 
+#define readsb(port, buf, nr)     raw_insb((port), (u8 *)(buf), (nr))
+#define readsw(port, buf, nr)     raw_insw((port), (u16 *)(buf), (nr))
+#define readsl(port, buf, nr)     raw_insl((port), (u32 *)(buf), (nr))
+#define writesb(port, buf, nr)    raw_outsb((port), (u8 *)(buf), (nr))
+#define writesw(port, buf, nr)    raw_outsw((port), (u16 *)(buf), (nr))
+#define writesl(port, buf, nr)    raw_outsl((port), (u32 *)(buf), (nr))
+
 #define mmiowb()
 
 static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
index 1d5eda2..f7c1c8e 100644
--- a/drivers/usb/musb/musb_io.h
+++ b/drivers/usb/musb/musb_io.h
@@ -40,7 +40,7 @@
 #if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
 	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
 	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN) \
-	&& !defined(CONFIG_MIPS)
+	&& !defined(CONFIG_MIPS) && !defined(CONFIG_M68K)
 static inline void readsl(const void __iomem *addr, void *buf, int len)
 	{ insl((unsigned long)addr, buf, len); }
 static inline void readsw(const void __iomem *addr, void *buf, int len)
-- 
1.7.0.4

