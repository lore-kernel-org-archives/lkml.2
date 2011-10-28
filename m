Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab1J1VtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:49:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab1J1VtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:49:07 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 10/16] PCI: Pull PCI 'latency timer' setup up into the core
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:38 -0600
Message-ID: <20111028214838.20088.38904.stgit@amt.stowe>
In-Reply-To: <20111028214726.20088.30551.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

The 'latency timer' of PCI devices, both Type 0 and Type 1,
is setup in architecture-specific code [see: 'pcibios_set_master()'].
There are two approaches being taken by all the architectures - check
if the 'latency timer' is currently set between 16 and 255 and if not
bring it within bounds, or, do nothing (and then there is the
gratuitously different PA-RISC implementation).

There is nothing architecture-specific about PCI's 'latency timer' so
this patch pulls its setup functionality up into the PCI core by
creating a generic 'pcibios_set_master()' function using the '__weak'
attribute which can be used by all architectures as a default which,
if necessary, can then be over-ridden by architecture-specific code.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/blackfin/include/asm/pci.h         |    4 ----
 arch/frv/mb93090-mb00/pci-frv.c         |    6 ------
 arch/frv/mb93090-mb00/pci-frv.h         |    2 --
 arch/h8300/include/asm/pci.h            |    5 -----
 arch/mips/pci/pci.c                     |    6 ------
 arch/mn10300/unit-asb2305/pci-asb2305.c |    6 ------
 arch/mn10300/unit-asb2305/pci-asb2305.h |    2 --
 arch/sh/drivers/pci/pci.c               |    6 ------
 arch/x86/include/asm/pci_x86.h          |    2 --
 arch/x86/pci/i386.c                     |    6 ------
 drivers/pci/pci.c                       |   29 +++++++++++++++++++++++++++++
 include/linux/pci.h                     |    3 +++
 12 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/arch/blackfin/include/asm/pci.h b/arch/blackfin/include/asm/pci.h
index 99cae2e..74352c4 100644
--- a/arch/blackfin/include/asm/pci.h
+++ b/arch/blackfin/include/asm/pci.h
@@ -10,10 +10,6 @@
 #define PCIBIOS_MIN_IO 0x00001000
 #define PCIBIOS_MIN_MEM 0x10000000
 
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
 static inline void pcibios_penalize_isa_irq(int irq)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index 6b4fb28..6a0cd64 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -195,12 +195,6 @@ void __init pcibios_resource_survey(void)
 	pcibios_assign_resources();
 }
 
-/*
- *  If we set up a device for bus mastering, we need to check the latency
- *  timer as certain crappy BIOSes forget to set it properly.
- */
-unsigned int pcibios_max_latency = 255;
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/arch/frv/mb93090-mb00/pci-frv.h b/arch/frv/mb93090-mb00/pci-frv.h
index f3fe559..089eeba 100644
--- a/arch/frv/mb93090-mb00/pci-frv.h
+++ b/arch/frv/mb93090-mb00/pci-frv.h
@@ -26,8 +26,6 @@ extern unsigned int __nongpreldata pci_probe;
 
 /* pci-frv.c */
 
-extern unsigned int pcibios_max_latency;
-
 void pcibios_resource_survey(void);
 
 /* pci-vdk.c */
diff --git a/arch/h8300/include/asm/pci.h b/arch/h8300/include/asm/pci.h
index cc97620..0b2acaa 100644
--- a/arch/h8300/include/asm/pci.h
+++ b/arch/h8300/include/asm/pci.h
@@ -9,11 +9,6 @@
 
 #define pcibios_assign_all_busses()	0
 
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-
 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..a6de9b8 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -204,12 +204,6 @@ static int pcibios_enable_resources(struct pci_dev *dev, int mask)
 	return 0;
 }
 
-/*
- *  If we set up a device for bus mastering, we need to check the latency
- *  timer as certain crappy BIOSes forget to set it properly.
- */
-static unsigned int pcibios_max_latency = 255;
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index 8e6763e..2b299c4 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -213,12 +213,6 @@ void __init pcibios_resource_survey(void)
 	pcibios_allocate_resources(1);
 }
 
-/*
- *  If we set up a device for bus mastering, we need to check the latency
- *  timer as certain crappy BIOSes forget to set it properly.
- */
-unsigned int pcibios_max_latency = 255;
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.h b/arch/mn10300/unit-asb2305/pci-asb2305.h
index c3fa294..1194fe4 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.h
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.h
@@ -31,8 +31,6 @@ extern unsigned int pci_probe;
 
 /* pci-asb2305.c */
 
-extern unsigned int pcibios_max_latency;
-
 extern void pcibios_resource_survey(void);
 
 /* pci.c */
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 194231c..a0c92fd 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -242,12 +242,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-/*
- *  If we set up a device for bus mastering, we need to check and set
- *  the latency timer as it may not be properly set.
- */
-static unsigned int pcibios_max_latency = 255;
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 7045267..497c8a3 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -44,8 +44,6 @@ enum pci_bf_sort_state {
 
 /* pci-i386.c */
 
-extern unsigned int pcibios_max_latency;
-
 void pcibios_resource_survey(void);
 void pcibios_set_cache_line_size(void);
 
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 494f2e7..5663bc2 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -253,12 +253,6 @@ void __init pcibios_resource_survey(void)
  */
 fs_initcall(pcibios_assign_resources);
 
-/*
- *  If we set up a device for bus mastering, we need to check the latency
- *  timer as certain crappy BIOSes forget to set it properly.
- */
-unsigned int pcibios_max_latency = 255;
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 466fad6..a50e643 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -88,6 +88,12 @@ enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
 u8 pci_dfl_cache_line_size __devinitdata = L1_CACHE_BYTES >> 2;
 u8 pci_cache_line_size;
 
+/*
+ * If we set up a device for bus mastering, we need to check the latency
+ * timer as certain BIOSes forget to set it properly.
+ */
+unsigned int pcibios_max_latency = 255;
+
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
@@ -2590,6 +2596,29 @@ static void __pci_set_master(struct pci_dev *dev, bool enable)
 }
 
 /**
+ * pcibios_set_master - enable PCI bus-mastering for device dev
+ * @dev: the PCI device to enable
+ *
+ * Enables PCI bus-mastering for the device.  This is the default
+ * implementation.  Architecture specific implementations can override
+ * this if necessary.
+ */
+void __weak pcibios_set_master(struct pci_dev *dev)
+{
+	u8 lat;
+
+	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
+	if (lat < 16)
+		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;
+	else if (lat > pcibios_max_latency)
+		lat = pcibios_max_latency;
+	else
+		return;
+	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
+	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
+}
+
+/**
  * pci_set_master - enables bus-mastering for device dev
  * @dev: the PCI device to enable
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index abbd8b6..182b93d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -790,8 +790,11 @@ static inline int pci_is_managed(struct pci_dev *pdev)
 }
 
 void pci_disable_device(struct pci_dev *dev);
+
+extern unsigned int pcibios_max_latency;
 void pci_set_master(struct pci_dev *dev);
 void pci_clear_master(struct pci_dev *dev);
+
 int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
 int pci_set_cacheline_size(struct pci_dev *dev);
 #define HAVE_PCI_SET_MWI

