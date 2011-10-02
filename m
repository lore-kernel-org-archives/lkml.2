Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1JBOsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54434 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1JBOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 17/30] usb/musb: allow building USB_MUSB_TUSB6010 as a module
Date: Sun,  2 Oct 2011 16:45:47 +0200
Message-Id: <1317566760-25681-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hSQANcII0Bs4BqmbONBBr/nNaSbIq6dmkBGjFsMuxIL
 g3U2SwJbEISkrUvzhrw74qY1V0eLjJd8h96KSrBE8h1K/OutrZ
 k38FkwF6FuGdMZiaRyN+JmWgSaXqy+wvYNL0onKCrLHhjL2THr
 6f49T8xRgNQQUd+dgwhnQ4CSxcHIROFU600bjNk8EJ07ZRDsYY
 5C9+pY7qlM5m/AuAOfivqfTQ5/aPyp1ehdIQWsyBY7jb3dFFyT
 ZFNF9BcdTGcY4cdIeDyZR99nrky9BHEVLxVLhLqnjF1QNDonZG
 kA/aIsOjWwFpByOIo3/f/f6T24+B/9l3pemVC3JrQgEqMlCihW
 wn80y+xbLSmGy55toeBGhMD//9+DCGOYCR9BZb4qX1IIFOxv9M
 5wPqA9j8qGSoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1376d92f9 "usb: musb: allow musb and glue layers to be modules"
made the USB_MUSB_TUSB6010 option modular, but actually building
the driver as a module does not work, so various randconfig builds
actually fail. This changes all code that depends on the
option to also check for modular builds, and exports the necessary
symbols.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-n8x0.c |    2 +-
 drivers/usb/musb/musb_core.c     |    3 ++-
 drivers/usb/musb/musb_io.h       |    2 +-
 drivers/usb/musb/tusb6010.c      |    1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 403325d..c096dc2 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -46,7 +46,7 @@ static struct device *mmc_device;
 #define TUSB6010_GPIO_ENABLE	0
 #define TUSB6010_DMACHAN	0x3f
 
-#ifdef CONFIG_USB_MUSB_TUSB6010
+#if defined(CONFIG_USB_MUSB_TUSB6010) || defined(CONFIG_USB_MUSB_TUSB6010_MODULE)
 /*
  * Enable or disable power to TUSB6010. When enabling, turn on 3.3 V and
  * 1.5 V voltage regulators of PM companion chip. Companion chip will then
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 20a2873..9fa2596 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1432,7 +1432,7 @@ static int __init musb_core_init(u16 musb_type, struct musb *musb)
 		struct musb_hw_ep	*hw_ep = musb->endpoints + i;
 
 		hw_ep->fifo = MUSB_FIFO_OFFSET(i) + mbase;
-#ifdef CONFIG_USB_MUSB_TUSB6010
+#if defined(CONFIG_USB_MUSB_TUSB6010) || defined (CONFIG_USB_MUSB_TUSB6010_MODULE)
 		hw_ep->fifo_async = musb->async + 0x400 + MUSB_FIFO_OFFSET(i);
 		hw_ep->fifo_sync = musb->sync + 0x400 + MUSB_FIFO_OFFSET(i);
 		hw_ep->fifo_sync_va =
@@ -1632,6 +1632,7 @@ void musb_dma_completion(struct musb *musb, u8 epnum, u8 transmit)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(musb_dma_completion);
 
 #else
 #define use_dma			0
diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
index 03c6ccd..e61aa95 100644
--- a/drivers/usb/musb/musb_io.h
+++ b/drivers/usb/musb/musb_io.h
@@ -74,7 +74,7 @@ static inline void musb_writel(void __iomem *addr, unsigned offset, u32 data)
 	{ __raw_writel(data, addr + offset); }
 
 
-#ifdef CONFIG_USB_MUSB_TUSB6010
+#if defined(CONFIG_USB_MUSB_TUSB6010) || defined (CONFIG_USB_MUSB_TUSB6010_MODULE)
 
 /*
  * TUSB6010 doesn't allow 8-bit access; 16-bit access is the minimum.
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index ec14801..1f40561 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -56,6 +56,7 @@ u8 tusb_get_revision(struct musb *musb)
 
 	return rev;
 }
+EXPORT_SYMBOL_GPL(tusb_get_revision);
 
 static int tusb_print_revision(struct musb *musb)
 {
-- 
1.7.5.4

