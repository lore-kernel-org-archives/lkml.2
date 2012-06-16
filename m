Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2FPUt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:49:27 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20851 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab2FPUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:49:24 -0400
Message-ID: <201206162049.q5GKnN74019488@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 16 Jun 2012 16:41:05 -0400
Subject: [PATCH 3/3] bounce: allow use of bounce pool via config option
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-usb@vger.kernel.org>
In-Reply-To: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tilegx USB OHCI support needs the bounce pool since we're not
using the IOMMU to handle 32-bit addresses.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |    6 ++++++
 mm/bounce.c       |    8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index cf4bb69e..932e443 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -406,6 +406,12 @@ config TILE_USB
 	  Provides USB host adapter support for the built-in EHCI and OHCI
 	  interfaces on TILE-Gx chips.
 
+# USB OHCI needs the bounce pool since tilegx will often have more
+# than 4GB of memory, but we don't currently use the IOTLB to present
+# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
+config NEED_BOUNCE_POOL
+	def_bool USB_OHCI_HCD
+
 config HOTPLUG
 	bool "Support for hot-pluggable devices"
 	---help---
diff --git a/mm/bounce.c b/mm/bounce.c
index d1be02c..0420867 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -24,23 +24,25 @@
 
 static mempool_t *page_pool, *isa_page_pool;
 
-#ifdef CONFIG_HIGHMEM
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_NEED_BOUNCE_POOL)
 static __init int init_emergency_pool(void)
 {
-#ifndef CONFIG_MEMORY_HOTPLUG
+#if defined(CONFIG_HIGHMEM) && !defined(CONFIG_MEMORY_HOTPLUG)
 	if (max_pfn <= max_low_pfn)
 		return 0;
 #endif
 
 	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
 	BUG_ON(!page_pool);
-	printk("highmem bounce pool size: %d pages\n", POOL_SIZE);
+	printk("bounce pool size: %d pages\n", POOL_SIZE);
 
 	return 0;
 }
 
 __initcall(init_emergency_pool);
+#endif
 
+#ifdef CONFIG_HIGHMEM
 /*
  * highmem version, map in to vec
  */
-- 
1.7.10.3

