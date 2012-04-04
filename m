Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2DDRkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:40:24 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64179 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab2DDRkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:40:22 -0400
Date: Wed, 4 Apr 2012 19:39:58 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH V5 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <f79fcc1a2e17ef942e1b798b92aac43a80202532.1333560789.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1333560789.git.rubini@gnudd.com>
In-Reply-To: <cover.1333560789.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit x86 systems may need their own DMA operations, so add
a new config option, which is turned on for 64-bit systems. This
patch has no functional effect but it paves the way for supporting
the STA2x11 I/O Hub and possibly other chips.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/Kconfig                   |    5 +++++
 arch/x86/include/asm/device.h      |    4 ++--
 arch/x86/include/asm/dma-mapping.h |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b3baf10..a3ce2e7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -12,6 +12,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select X86_DEV_DMA_OPS
 
 ### Arch settings
 config X86
@@ -2249,6 +2250,10 @@ config HAVE_TEXT_POKE_SMP
 	bool
 	select STOP_MACHINE if SMP
 
+config X86_DEV_DMA_OPS
+	bool
+	depends on X86_64
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 63a2a03..93e1c55 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -5,8 +5,8 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
-#ifdef CONFIG_X86_64
-struct dma_map_ops *dma_ops;
+#ifdef CONFIG_X86_DEV_DMA_OPS
+	struct dma_map_ops *dma_ops;
 #endif
 #if defined(CONFIG_INTEL_IOMMU) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 4b4331d..09aa473 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -30,7 +30,7 @@ extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-#ifdef CONFIG_X86_32
+#ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
 #else
 	if (unlikely(!dev) || !dev->archdata.dma_ops)
-- 
1.7.7.2
