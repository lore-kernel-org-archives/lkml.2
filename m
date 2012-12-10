Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2LJTM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:12:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55667 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976Ab2LJTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:53 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Matthew Leach <matthew@mattleach.net>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 09/10] usb: musb: use io{read,write}*_rep accessors
Date: Mon, 10 Dec 2012 19:12:41 +0000
Message-Id: <1355166762-15133-10-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew@mattleach.net>

The {read,write}s{b,w,l} operations are not defined by all
architectures and are being removed from the asm-generic/io.h
interface.

This patch replaces the usage of these string functions in the musb
accessors with io{read,write}{8,16,32}_rep calls instead.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/usb/musb/musb_core.c | 12 ++++++------
 drivers/usb/musb/musb_io.h   | 21 ---------------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index bb56a0e..4f45e97 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -281,7 +281,7 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 		/* best case is 32bit-aligned source address */
 		if ((0x02 & (unsigned long) src) == 0) {
 			if (len >= 4) {
-				writesl(fifo, src + index, len >> 2);
+				iowrite32_rep(fifo, src + index, len >> 2);
 				index += len & ~0x03;
 			}
 			if (len & 0x02) {
@@ -290,7 +290,7 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 			}
 		} else {
 			if (len >= 2) {
-				writesw(fifo, src + index, len >> 1);
+				iowrite16_rep(fifo, src + index, len >> 1);
 				index += len & ~0x01;
 			}
 		}
@@ -298,7 +298,7 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 			musb_writeb(fifo, 0, src[index]);
 	} else  {
 		/* byte aligned */
-		writesb(fifo, src, len);
+		iowrite8_rep(fifo, src, len);
 	}
 }
 
@@ -324,7 +324,7 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 		/* best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) dst) == 0) {
 			if (len >= 4) {
-				readsl(fifo, dst, len >> 2);
+				ioread32_rep(fifo, dst, len >> 2);
 				index = len & ~0x03;
 			}
 			if (len & 0x02) {
@@ -333,7 +333,7 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 			}
 		} else {
 			if (len >= 2) {
-				readsw(fifo, dst, len >> 1);
+				ioread16_rep(fifo, dst, len >> 1);
 				index = len & ~0x01;
 			}
 		}
@@ -341,7 +341,7 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 			dst[index] = musb_readb(fifo, 0);
 	} else  {
 		/* byte aligned */
-		readsb(fifo, dst, len);
+		ioread8_rep(fifo, dst, len);
 	}
 }
 #endif
diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
index 565ad16..eebeed7 100644
--- a/drivers/usb/musb/musb_io.h
+++ b/drivers/usb/musb/musb_io.h
@@ -37,27 +37,6 @@
 
 #include <linux/io.h>
 
-#if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
-	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
-	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN) \
-	&& !defined(CONFIG_MIPS) && !defined(CONFIG_M68K) \
-	&& !defined(CONFIG_XTENSA)
-static inline void readsl(const void __iomem *addr, void *buf, int len)
-	{ insl((unsigned long)addr, buf, len); }
-static inline void readsw(const void __iomem *addr, void *buf, int len)
-	{ insw((unsigned long)addr, buf, len); }
-static inline void readsb(const void __iomem *addr, void *buf, int len)
-	{ insb((unsigned long)addr, buf, len); }
-
-static inline void writesl(const void __iomem *addr, const void *buf, int len)
-	{ outsl((unsigned long)addr, buf, len); }
-static inline void writesw(const void __iomem *addr, const void *buf, int len)
-	{ outsw((unsigned long)addr, buf, len); }
-static inline void writesb(const void __iomem *addr, const void *buf, int len)
-	{ outsb((unsigned long)addr, buf, len); }
-
-#endif
-
 #ifndef CONFIG_BLACKFIN
 
 /* NOTE:  these offsets are all in bytes */
-- 
1.8.0

