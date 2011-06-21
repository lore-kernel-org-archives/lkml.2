Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1FUHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:22:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1FUHWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:12 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 3/8] omap: add carveout memory support for remoteproc
Date: Tue, 21 Jun 2011 10:18:29 +0300
Message-Id: <1308640714-17961-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a temporary patch to get things going, and is by no means
a suggestion for inclusion (read only if interested, but don't waste
much review energies here).

The way to go forward here is to use CMA (together with the generic
DMA API, so we also get IOMMU programming "for free").

This patch also breaks tidspbridge. Use it only if you want to try out
rpmsg/remoteproc on OMAP4, and you don't care too much about multi-board
kernels.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/Kconfig            |    8 ++++++++
 arch/arm/plat-omap/devices.c          |   14 ++++++++++++--
 arch/arm/plat-omap/include/plat/dsp.h |    6 +++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 1c3acb5..09c91d1 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -211,6 +211,14 @@ config OMAP_SERIAL_WAKE
 	  to data on the serial RX line. This allows you to wake the
 	  system from serial console.
 
+config OMAP_CARVEOUT_MEMPOOL_SIZE
+	hex "Physical carveout memory pool size (Byte)"
+	depends on OMAP_REMOTE_PROC
+	default 0x3300000
+	help
+	  Allocate specified size of memory at boot time so we can ioremap
+	  it safely.
+
 choice
 	prompt "OMAP PM layer selection"
 	depends on ARCH_OMAP
diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index ea28f98..6922f3b 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -234,13 +234,16 @@ static void omap_init_uwire(void)
 static inline void omap_init_uwire(void) {}
 #endif
 
-#if defined(CONFIG_TIDSPBRIDGE) || defined(CONFIG_TIDSPBRIDGE_MODULE)
+#if defined(CONFIG_TIDSPBRIDGE) || defined(CONFIG_TIDSPBRIDGE_MODULE) || \
+	defined(CONFIG_OMAP_REMOTE_PROC)
 
 static phys_addr_t omap_dsp_phys_mempool_base;
+static phys_addr_t omap_dsp_phys_mempool_size;
 
 void __init omap_dsp_reserve_sdram_memblock(void)
 {
-	phys_addr_t size = CONFIG_TIDSPBRIDGE_MEMPOOL_SIZE;
+	/* ignoring TIDSPBRIDGE for a moment here... */
+	phys_addr_t size = CONFIG_OMAP_CARVEOUT_MEMPOOL_SIZE;
 	phys_addr_t paddr;
 
 	if (!size)
@@ -256,6 +259,7 @@ void __init omap_dsp_reserve_sdram_memblock(void)
 	memblock_remove(paddr, size);
 
 	omap_dsp_phys_mempool_base = paddr;
+	omap_dsp_phys_mempool_size = size;
 }
 
 phys_addr_t omap_dsp_get_mempool_base(void)
@@ -263,6 +267,12 @@ phys_addr_t omap_dsp_get_mempool_base(void)
 	return omap_dsp_phys_mempool_base;
 }
 EXPORT_SYMBOL(omap_dsp_get_mempool_base);
+
+phys_addr_t omap_dsp_get_mempool_size(void)
+{
+	return omap_dsp_phys_mempool_size;
+}
+EXPORT_SYMBOL(omap_dsp_get_mempool_size);
 #endif
 
 /*
diff --git a/arch/arm/plat-omap/include/plat/dsp.h b/arch/arm/plat-omap/include/plat/dsp.h
index 9c604b3..31ee386 100644
--- a/arch/arm/plat-omap/include/plat/dsp.h
+++ b/arch/arm/plat-omap/include/plat/dsp.h
@@ -22,10 +22,14 @@ struct omap_dsp_platform_data {
 	phys_addr_t phys_mempool_size;
 };
 
-#if defined(CONFIG_TIDSPBRIDGE) || defined(CONFIG_TIDSPBRIDGE_MODULE)
+#if defined(CONFIG_TIDSPBRIDGE) || defined(CONFIG_TIDSPBRIDGE_MODULE) || \
+	defined(CONFIG_OMAP_REMOTE_PROC)
 extern void omap_dsp_reserve_sdram_memblock(void);
 #else
 static inline void omap_dsp_reserve_sdram_memblock(void) { }
 #endif
 
+phys_addr_t omap_dsp_get_mempool_size(void);
+phys_addr_t omap_dsp_get_mempool_base(void);
+
 #endif
-- 
1.7.1

