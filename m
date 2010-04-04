Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0DDOos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:44:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:56601 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0DDOo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:26 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de
Subject: [PATCH -mm 2/5] asm-generic: add NEED_SG_DMA_LENGTH to define sg_dma_len()
Date: Sun,  4 Apr 2010 23:25:50 +0900
Message-Id: <1270391153-17519-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are only two ways to define sg_dma_len(); use sg->dma_length or
sg->length. This patch introduces NEED_SG_DMA_LENGTH that enables
architectures to choose sg->dma_length or sg->length.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/ia64/Kconfig                    |    3 +++
 arch/sh/Kconfig                      |    3 +++
 arch/sparc/Kconfig                   |    3 +++
 arch/sparc/include/asm/scatterlist.h |    2 --
 arch/x86/Kconfig                     |    3 +++
 include/asm-generic/scatterlist.h    |   13 +++++--------
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 0e5919f..0873a10 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -56,6 +56,9 @@ config MMU
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config SWIOTLB
        bool
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index e2e5b3b..5e2ee0c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -183,6 +183,9 @@ config DMA_NONCOHERENT
 config NEED_DMA_MAP_STATE
 	def_bool DMA_NONCOHERENT
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 54ce709..5b751a5 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -127,6 +127,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
index 0fa0d6d..69d21bb 100644
--- a/arch/sparc/include/asm/scatterlist.h
+++ b/arch/sparc/include/asm/scatterlist.h
@@ -1,8 +1,6 @@
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
-#define sg_dma_len(sg)     	((sg)->dma_length)
-
 #define ISA_DMA_THRESHOLD	(~0UL)
 
 #include <asm-generic/scatterlist.h>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8b182ea..6dc69c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -102,6 +102,9 @@ config SBUS
 config NEED_DMA_MAP_STATE
        def_bool (X86_64 || DMAR || DMA_API_DEBUG)
 
+config NEED_SG_DMA_LENGTH
+	def_bool X86_64
+
 config GENERIC_ISA_DMA
 	def_bool y
 
diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 51a7a43..5e08794 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -11,7 +11,9 @@ struct scatterlist {
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
+#endif
 };
 
 /*
@@ -22,17 +24,12 @@ struct scatterlist {
  * is 0.
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
-#ifndef sg_dma_len
-/*
- * Normally, you have an iommu on 64 bit machines, but not on 32 bit
- * machines. Architectures that are differnt should override this.
- */
-#if __BITS_PER_LONG == 64
+
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 #define sg_dma_len(sg)		((sg)->dma_length)
 #else
 #define sg_dma_len(sg)		((sg)->length)
-#endif /* 64 bit */
-#endif /* sg_dma_len */
+#endif
 
 #define ARCH_HAS_SG_CHAIN
 
-- 
1.7.0

