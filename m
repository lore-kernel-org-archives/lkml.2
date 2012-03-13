Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab2CMHbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:31:00 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63421 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab2CMHa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:30:58 -0400
Date: Tue, 13 Mar 2012 08:30:38 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH V4 2/3] x86: introduce CONFIG_X86_DMA_REMAP
Message-ID: <6ee0095901fd5cb5a84997a8a4553e2e8caf0727.1331622735.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1331622735.git.rubini@gnudd.com>
In-Reply-To: <cover.1331622735.git.rubini@gnudd.com>
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
index c06a8a3..9f6255b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2253,6 +2253,9 @@ config X86_DEV_DMA_OPS
 	bool
 	depends on X86_64
 
+config X86_DMA_REMAP
+	bool
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
