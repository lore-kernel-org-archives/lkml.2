Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594Ab2DLTl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:41:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2DLTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:41:25 -0400
Date: Thu, 12 Apr 2012 12:41:00 -0700
From: tip-bot for Alessandro Rubini <rubini@gnudd.com>
Message-ID: <tip-4692d77fc3c8978a36406a3cf9e8b899f86f68f1@git.kernel.org>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rubini@gnudd.com, tglx@linutronix.de,
        giancarlo.asnaghi@st.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, rubini@gnudd.com, tglx@linutronix.de,
        giancarlo.asnaghi@st.com
In-Reply-To: <f79fcc1a2e17ef942e1b798b92aac43a80202532.1333560789.git.rubini@gnudd.com>
References: <f79fcc1a2e17ef942e1b798b92aac43a80202532.1333560789.git.rubini@gnudd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86-32: Introduce CONFIG_X86_DEV_DMA_OPS
Git-Commit-ID: 4692d77fc3c8978a36406a3cf9e8b899f86f68f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 12 Apr 2012 12:41:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4692d77fc3c8978a36406a3cf9e8b899f86f68f1
Gitweb:     http://git.kernel.org/tip/4692d77fc3c8978a36406a3cf9e8b899f86f68f1
Author:     Alessandro Rubini <rubini@gnudd.com>
AuthorDate: Wed, 4 Apr 2012 19:39:58 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Apr 2012 11:09:56 -0700

x86-32: Introduce CONFIG_X86_DEV_DMA_OPS

32-bit x86 systems may need their own DMA operations, so add
a new config option, which is turned on for 64-bit systems. This
patch has no functional effect but it paves the way for supporting
the STA2x11 I/O Hub and possibly other chips.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Link: http://lkml.kernel.org/r/f79fcc1a2e17ef942e1b798b92aac43a80202532.1333560789.git.rubini@gnudd.com
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig                   |    5 +++++
 arch/x86/include/asm/device.h      |    4 ++--
 arch/x86/include/asm/dma-mapping.h |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..07b412a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -12,6 +12,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select X86_DEV_DMA_OPS
 
 ### Arch settings
 config X86
@@ -2215,6 +2216,10 @@ config HAVE_TEXT_POKE_SMP
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
