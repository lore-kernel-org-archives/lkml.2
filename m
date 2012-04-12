Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635Ab2DLTmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:42:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762609Ab2DLTmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:42:05 -0400
Date: Thu, 12 Apr 2012 12:41:51 -0700
From: tip-bot for Alessandro Rubini <rubini@gnudd.com>
Message-ID: <tip-f7219a5300ba753b0c762d631763bd878b8bb00c@git.kernel.org>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rubini@gnudd.com, tglx@linutronix.de,
        giancarlo.asnaghi@st.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, rubini@gnudd.com, tglx@linutronix.de,
        giancarlo.asnaghi@st.com
In-Reply-To: <6e4329b772df675f1c442f68e59e844e4dd8c965.1333560789.git.rubini@gnudd.com>
References: <6e4329b772df675f1c442f68e59e844e4dd8c965.1333560789.git.rubini@gnudd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Introduce CONFIG_X86_DMA_REMAP
Git-Commit-ID: f7219a5300ba753b0c762d631763bd878b8bb00c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 12 Apr 2012 12:41:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7219a5300ba753b0c762d631763bd878b8bb00c
Gitweb:     http://git.kernel.org/tip/f7219a5300ba753b0c762d631763bd878b8bb00c
Author:     Alessandro Rubini <rubini@gnudd.com>
AuthorDate: Wed, 4 Apr 2012 19:40:10 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Apr 2012 11:10:18 -0700

x86: Introduce CONFIG_X86_DMA_REMAP

The default functions phys_to_dma, dma_to_phys implement identity
mapping as fast inline functions.  Some systems, however, may need a
custom function to implement its own mapping between CPU addresses and
device addresses. This new configuration option allows the functions
to be external when needed (such as for the ConneXt device)

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Link: http://lkml.kernel.org/r/6e4329b772df675f1c442f68e59e844e4dd8c965.1333560789.git.rubini@gnudd.com
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig                   |    3 +++
 arch/x86/include/asm/dma-mapping.h |    7 +++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 07b412a..95ca560 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2220,6 +2220,9 @@ config X86_DEV_DMA_OPS
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
