Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2BPKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:40:48 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61567 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2BPKko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:40:44 -0500
Date: Thu, 16 Feb 2012 11:40:27 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, andrzej.p@samsung.com,
        mingo@elte.hu, jbarnes@virtuousgeek.org
Subject: [PATCH 3/3] x86: introduce CONFIG_X86_DMA_REMAP
Message-ID: <60eae1275eab92e527ac19f40b56f703fd6c6c5a.1329387617.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1329387617.git.rubini@gnudd.com>
In-Reply-To: <cover.1329387617.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default functions phys_to_dma, dma_to_phys implement identity
mapping as fast inline functions.  Some systems, however, need a
custom function to implement its own mapping between CPU addresses and
device addresses. This option is needed to support the sta2x11 I/O Hub,
whose support has been accepted but won't compile without this patch.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/Kconfig                   |    5 +++++
 arch/x86/include/asm/dma-mapping.h |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bb23c3..5426833 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -512,6 +512,7 @@ config STA2X11
 	depends on X86_32_NON_STANDARD && PCI
 	select SWIOTLB
 	select X86_DEV_DMA_OPS
+	select X86_DMA_REMAP
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
 	default n
@@ -2255,6 +2256,10 @@ config X86_DEV_DMA_OPS
 	bool
 	depends on X86_64 || STA2X11
 
+config X86_DMA_REMAP
+	bool
+	depends on STA2X11
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 09aa473..61c0bd2 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -62,6 +62,12 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
 					struct dma_attrs *attrs);
 
+#ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code */
+extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
+extern dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
+extern phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
+#else
+
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
@@ -79,6 +85,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
 	return daddr;
 }
+#endif /* CONFIG_X86_DMA_REMAP */
 
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-- 
1.7.7.2
