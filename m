Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab2IJLlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:41:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41934 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2IJLlu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 07:41:50 -0400
Message-Id: <504DEE19020000780009A285@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 12:41:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: kconfig cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main goal here is to have the resulting .config no carry any
options that aren't enabled and can't be (i.e such where the default
is "no" and can't be changed), so that if any such option later gets
a user visible prompt, the user will actually be prompted on a "make
...oldconfig" rather than keeping the previously invisible option
disabled.

There's a little bit of other trivial cleanup mixed in here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/Kconfig     |   50 ++++++++++++++++++++++++++++++--------------------
 arch/x86/Kconfig.cpu |    5 +++--
 2 files changed, 33 insertions(+), 22 deletions(-)

--- 3.6-rc5/arch/x86/Kconfig
+++ 3.6-rc5-kconfig-cleanup-x86/arch/x86/Kconfig
@@ -7,11 +7,13 @@ config 64BIT
 	  Say no to build a 32-bit kernel - formerly known as i386
 
 config X86_32
-	def_bool !64BIT
+	def_bool y
+	depends on !64BIT
 	select CLKSRC_I8253
 
 config X86_64
-	def_bool 64BIT
+	def_bool y
+	depends on 64BIT
 	select X86_DEV_DMA_OPS
 
 ### Arch settings
@@ -99,7 +101,8 @@ config X86
 	select GENERIC_STRNLEN_USER
 
 config INSTRUCTION_DECODER
-	def_bool (KPROBES || PERF_EVENTS || UPROBES)
+	def_bool y
+	depends on KPROBES || PERF_EVENTS || UPROBES
 
 config OUTPUT_FORMAT
 	string
@@ -127,13 +130,15 @@ config SBUS
 	bool
 
 config NEED_DMA_MAP_STATE
-       def_bool (X86_64 || INTEL_IOMMU || DMA_API_DEBUG)
+	def_bool y
+	depends on X86_64 || INTEL_IOMMU || DMA_API_DEBUG
 
 config NEED_SG_DMA_LENGTH
 	def_bool y
 
 config GENERIC_ISA_DMA
-	def_bool ISA_DMA_API
+	def_bool y
+	depends on ISA_DMA_API
 
 config GENERIC_BUG
 	def_bool y
@@ -150,13 +155,16 @@ config GENERIC_GPIO
 	bool
 
 config ARCH_MAY_HAVE_PC_FDC
-	def_bool ISA_DMA_API
+	def_bool y
+	depends on ISA_DMA_API
 
 config RWSEM_GENERIC_SPINLOCK
-	def_bool !X86_XADD
+	def_bool y
+	depends on !X86_XADD
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD
+	def_bool y
+	depends on X86_XADD
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
@@ -752,7 +760,8 @@ config SWIOTLB
 	  3 GB of memory. If unsure, say Y.
 
 config IOMMU_HELPER
-	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
+	def_bool y
+	depends on CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU
 
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
@@ -1159,10 +1168,12 @@ config X86_PAE
 	  consumes more pagetable space per process.
 
 config ARCH_PHYS_ADDR_T_64BIT
-	def_bool X86_64 || X86_PAE
+	def_bool y
+	depends on X86_64 || X86_PAE
 
 config ARCH_DMA_ADDR_T_64BIT
-	def_bool X86_64 || HIGHMEM64G
+	def_bool y
+	depends on X86_64 || HIGHMEM64G
 
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EXPERT
@@ -1285,8 +1296,8 @@ config ARCH_SELECT_MEMORY_MODEL
 	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool X86_64
-	depends on MEMORY_HOTPLUG
+	def_bool y
+	depends on X86_64 && MEMORY_HOTPLUG
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
@@ -1975,7 +1986,6 @@ config PCI_MMCONFIG
 
 config PCI_CNB20LE_QUIRK
 	bool "Read CNB20LE Host Bridge Windows" if EXPERT
-	default n
 	depends on PCI && EXPERIMENTAL
 	help
 	  Read the PCI windows out of the CNB20LE host bridge. This allows
@@ -2186,18 +2196,18 @@ config COMPAT
 	depends on IA32_EMULATION || X86_X32
 	select ARCH_WANT_OLD_COMPAT_IPC
 
+if COMPAT
 config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-	depends on X86_64
+	def_bool y
 
 config SYSVIPC_COMPAT
 	def_bool y
-	depends on COMPAT && SYSVIPC
+	depends on SYSVIPC
 
 config KEYS_COMPAT
-	bool
-	depends on COMPAT && KEYS
-	default y
+	def_bool y
+	depends on KEYS
+endif
 
 endmenu
 
--- 3.6-rc5/arch/x86/Kconfig.cpu
+++ 3.6-rc5-kconfig-cleanup-x86/arch/x86/Kconfig.cpu
@@ -306,7 +306,8 @@ config X86_INTERNODE_CACHE_SHIFT
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
-	def_bool X86_64 || (X86_32 && !M386)
+	def_bool y
+	depends on X86_64 || (X86_32 && !M386)
 
 config X86_L1_CACHE_SHIFT
 	int
@@ -317,7 +318,7 @@ config X86_L1_CACHE_SHIFT
 
 config X86_XADD
 	def_bool y
-	depends on X86_64 || !M386
+	depends on !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"


