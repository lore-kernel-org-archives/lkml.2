Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2AFMxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:53:35 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64058 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab2AFMxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:53:34 -0500
Date: Fri, 6 Jan 2012 13:33:06 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        suresh.b.siddha@intel.com, jkosina@suse.cz, pebolle@tiscali.nl
Subject: [PATCH 3/6] x86: introduce CONFIG_X86_DMA_REMAP
Message-ID: <ea676f9ba914fadaf3fa2e728cfff99bf9d08276.1325852059.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
In-Reply-To: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default functions phys_to_dma, dma_to_phys implement identity
mapping as fast inline functions.  Some systems, however, may need a
custom function to implement its own mapping between CPU addresses and
device addresses. This new configuration option allows the functions
to be external when needed (such as for the ConneXt device)

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/Kconfig                   |    3 +++
 arch/x86/include/asm/dma-mapping.h |    7 +++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b630740..1e4bfe3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2240,6 +2240,9 @@ config X86_DEV_DMA_OPS
 	bool
 	depends on X86_64
 
+config X86_DMA_REMAP
+	bool
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 53fb9dc..dd841da 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -61,6 +61,12 @@ extern int dma_set_mask(struct device *dev, u64 mask);
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag);
 
+#ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code */
+extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
+extern dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
+extern phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
+#else
+
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
@@ -78,6 +84,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
 	return daddr;
 }
+#endif /* CONFIG_X86_DMA_REMAP */
 
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-- 
1.7.7.2
