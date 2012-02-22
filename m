Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2BVWOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:14:39 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:65328 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab2BVWOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:14:30 -0500
Date: Wed, 22 Feb 2012 23:14:10 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH V3 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <6864850475e2fab50ed6b2b115561f6e34dce50d.1329947638.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1329947637.git.rubini@gnudd.com>
In-Reply-To: <cover.1329947637.git.rubini@gnudd.com>
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
index a61db6d..1832f0b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -12,6 +12,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select X86_DEV_DMA_OPS
 
 ### Arch settings
 config X86
@@ -2233,6 +2234,10 @@ config HAVE_TEXT_POKE_SMP
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
