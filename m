Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1JNE3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:29:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab1JNE3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:29:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qC8Ryh8V+Ua87vZhOKiJ/ticVfqfzZgUh6m5QpSXjspS5eLxGywk0ZmLQ+klWeT4W
	IwTUmCWUWivme/q5t9vYg==
Subject: [PATCH v2 25/29] arm/PCI: convert to pci_scan_root_bus() for correct
	root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:29:14 -0600
Message-ID: <20111014042914.23504.30487.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from pci_scan_bus() to pci_scan_root_bus() and remove root bus
resource fixups.  This fixes the problem of "early" and "header" quirks
seeing incorrect root bus resources.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/arm/common/it8152.c              |    6 +++---
 arch/arm/common/via82c505.c           |    3 ++-
 arch/arm/include/asm/mach/pci.h       |    2 +-
 arch/arm/kernel/bios32.c              |   27 ++++++++-------------------
 arch/arm/mach-cns3xxx/pcie.c          |    8 ++++----
 arch/arm/mach-dove/pcie.c             |    9 ++++-----
 arch/arm/mach-footbridge/dc21285.c    |    8 ++++----
 arch/arm/mach-integrator/pci_v3.c     |   19 ++++++++++---------
 arch/arm/mach-iop13xx/pci.c           |   17 ++++++++---------
 arch/arm/mach-ixp2000/enp2611.c       |    3 ++-
 arch/arm/mach-ixp2000/pci.c           |    8 ++++----
 arch/arm/mach-ixp23xx/pci.c           |    8 ++++----
 arch/arm/mach-ixp4xx/common-pci.c     |    8 ++++----
 arch/arm/mach-kirkwood/pcie.c         |    8 ++++----
 arch/arm/mach-ks8695/pci.c            |    8 ++++----
 arch/arm/mach-mv78xx0/pcie.c          |    8 ++++----
 arch/arm/mach-orion5x/pci.c           |   16 ++++++++--------
 arch/arm/mach-sa1100/pci-nanoengine.c |    9 +++++----
 arch/arm/mach-tegra/pcie.c            |    9 +++++----
 arch/arm/mach-versatile/pci.c         |   19 ++++++++++---------
 arch/arm/plat-iop/pci.c               |    8 ++++----
 21 files changed, 102 insertions(+), 109 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index a7934ba..e663a41 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -298,8 +298,8 @@ int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 		goto err1;
 	}
 
-	sys->resource[0] = &it8152_io;
-	sys->resource[1] = &it8152_mem;
+	pci_add_resource(&sys->resources, &it8152_io);
+	pci_add_resource(&sys->resources, &it8152_mem);
 
 	if (platform_notify || platform_notify_remove) {
 		printk(KERN_ERR "PCI: Can't use platform_notify\n");
@@ -351,7 +351,7 @@ void pcibios_set_master(struct pci_dev *dev)
 
 struct pci_bus * __init it8152_pci_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(nr, &it8152_ops, sys);
+	return pci_scan_root_bus(NULL, nr, &it8152_ops, sys, &sys->resources);
 }
 
 EXPORT_SYMBOL(dma_set_coherent_mask);
diff --git a/arch/arm/common/via82c505.c b/arch/arm/common/via82c505.c
index 8421d39..67dd2af 100644
--- a/arch/arm/common/via82c505.c
+++ b/arch/arm/common/via82c505.c
@@ -86,7 +86,8 @@ int __init via82c505_setup(int nr, struct pci_sys_data *sys)
 struct pci_bus * __init via82c505_scan_bus(int nr, struct pci_sys_data *sysdata)
 {
 	if (nr == 0)
-		return pci_scan_bus(0, &via82c505_ops, sysdata);
+		return pci_scan_root_bus(NULL, 0, &via82c505_ops, sysdata,
+					 &sysdata->resources);
 
 	return NULL;
 }
diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 186efd4..d943b7d 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -40,7 +40,7 @@ struct pci_sys_data {
 	u64		mem_offset;	/* bus->cpu memory mapping offset	*/
 	unsigned long	io_offset;	/* bus->cpu IO mapping offset		*/
 	struct pci_bus	*bus;		/* PCI bus				*/
-	struct resource *resource[3];	/* Primary PCI bus resources		*/
+	struct list_head resources;	/* root bus resources (apertures)       */
 					/* Bridge swizzling			*/
 	u8		(*swizzle)(struct pci_dev *, u8 *);
 					/* IRQ mapping				*/
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index d6df359..ebdeb3b 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -316,21 +316,6 @@ pdev_fixup_device_resources(struct pci_sys_data *root, struct pci_dev *dev)
 	}
 }
 
-static void __devinit
-pbus_assign_bus_resources(struct pci_bus *bus, struct pci_sys_data *root)
-{
-	struct pci_dev *dev = bus->self;
-	int i;
-
-	if (!dev) {
-		/*
-		 * Assign root bus resources.
-		 */
-		for (i = 0; i < 3; i++)
-			bus->resource[i] = root->resource[i];
-	}
-}
-
 /*
  * pcibios_fixup_bus - Called after each bus is probed,
  * but before its children are examined.
@@ -341,8 +326,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 	struct pci_dev *dev;
 	u16 features = PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
 
-	pbus_assign_bus_resources(bus, root);
-
 	/*
 	 * Walk the devices on this bus, working out what we can
 	 * and can't support.
@@ -509,12 +492,18 @@ static void __init pcibios_init_hw(struct hw_pci *hw)
 		sys->busnr   = busnr;
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
-		sys->resource[0] = &ioport_resource;
-		sys->resource[1] = &iomem_resource;
+		INIT_LIST_HEAD(&sys->resources);
 
 		ret = hw->setup(nr, sys);
 
 		if (ret > 0) {
+			if (list_empty(&sys->resources)) {
+				pci_add_resource(&sys->resources,
+						 &ioport_resource);
+				pci_add_resource(&sys->resources,
+						 &iomem_resource);
+			}
+
 			sys->bus = hw->scan(nr, sys);
 
 			if (!sys->bus)
diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index 0f8fca4..e159d69 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -151,13 +151,12 @@ static int cns3xxx_pci_setup(int nr, struct pci_sys_data *sys)
 	struct cns3xxx_pcie *cnspci = sysdata_to_cnspci(sys);
 	struct resource *res_io = &cnspci->res_io;
 	struct resource *res_mem = &cnspci->res_mem;
-	struct resource **sysres = sys->resource;
 
 	BUG_ON(request_resource(&iomem_resource, res_io) ||
 	       request_resource(&iomem_resource, res_mem));
 
-	sysres[0] = res_io;
-	sysres[1] = res_mem;
+	pci_add_resource(&sys->resources, res_io);
+	pci_add_resource(&sys->resources, res_mem);
 
 	return 1;
 }
@@ -169,7 +168,8 @@ static struct pci_ops cns3xxx_pcie_ops = {
 
 static struct pci_bus *cns3xxx_pci_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &cns3xxx_pcie_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &cns3xxx_pcie_ops, sys,
+				 &sys->resources);
 }
 
 static int cns3xxx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index aa2b3a0..d5b5dce 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -69,7 +69,7 @@ static int __init dove_pcie_setup(int nr, struct pci_sys_data *sys)
 	pp->res[0].flags = IORESOURCE_IO;
 	if (request_resource(&ioport_resource, &pp->res[0]))
 		panic("Request PCIe IO resource failed\n");
-	sys->resource[0] = &pp->res[0];
+	pci_add_resource(&sys->resources, &pp->res[0]);
 
 	/*
 	 * IORESOURCE_MEM
@@ -88,9 +88,7 @@ static int __init dove_pcie_setup(int nr, struct pci_sys_data *sys)
 	pp->res[1].flags = IORESOURCE_MEM;
 	if (request_resource(&iomem_resource, &pp->res[1]))
 		panic("Request PCIe Memory resource failed\n");
-	sys->resource[1] = &pp->res[1];
-
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &pp->res[1]);
 
 	return 1;
 }
@@ -184,7 +182,8 @@ dove_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	struct pci_bus *bus;
 
 	if (nr < num_pcie_ports) {
-		bus = pci_scan_bus(sys->busnr, &pcie_ops, sys);
+		bus = pci_scan_root_bus(NULL, sys->busnr, &pcie_ops, sys,
+					&sys->resources);
 	} else {
 		bus = NULL;
 		BUG();
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 18c32a5..f685650 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -275,9 +275,9 @@ int __init dc21285_setup(int nr, struct pci_sys_data *sys)
 	allocate_resource(&iomem_resource, &res[0], 0x40000000,
 			  0x80000000, 0xffffffff, 0x40000000, NULL, NULL);
 
-	sys->resource[0] = &ioport_resource;
-	sys->resource[1] = &res[0];
-	sys->resource[2] = &res[1];
+	pci_add_resource(&sys->resources, &ioport_resource);
+	pci_add_resource(&sys->resources, &res[0]);
+	pci_add_resource(&sys->resources, &res[1]);
 	sys->mem_offset  = DC21285_PCI_MEM;
 
 	return 1;
@@ -285,7 +285,7 @@ int __init dc21285_setup(int nr, struct pci_sys_data *sys)
 
 struct pci_bus * __init dc21285_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(0, &dc21285_ops, sys);
+	return pci_scan_root_bus(NULL, 0, &dc21285_ops, sys, &sys->resources);
 }
 
 #define dc21285_request_irq(_a, _b, _c, _d, _e) \
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 11b86e5..a8c0abb 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -359,7 +359,7 @@ static struct resource pre_mem = {
 	.flags	= IORESOURCE_MEM | IORESOURCE_PREFETCH,
 };
 
-static int __init pci_v3_setup_resources(struct resource **resource)
+static int __init pci_v3_setup_resources(struct list_head *resources)
 {
 	if (request_resource(&iomem_resource, &non_mem)) {
 		printk(KERN_ERR "PCI: unable to allocate non-prefetchable "
@@ -374,13 +374,13 @@ static int __init pci_v3_setup_resources(struct resource **resource)
 	}
 
 	/*
-	 * bus->resource[0] is the IO resource for this bus
-	 * bus->resource[1] is the mem resource for this bus
-	 * bus->resource[2] is the prefetch mem resource for this bus
+	 * the IO resource for this bus
+	 * the mem resource for this bus
+	 * the prefetch mem resource for this bus
 	 */
-	resource[0] = &ioport_resource;
-	resource[1] = &non_mem;
-	resource[2] = &pre_mem;
+	pci_add_resource(resources, &ioport_resource);
+	pci_add_resource(resources, &non_mem);
+	pci_add_resource(resources, &pre_mem);
 
 	return 1;
 }
@@ -481,7 +481,7 @@ int __init pci_v3_setup(int nr, struct pci_sys_data *sys)
 
 	if (nr == 0) {
 		sys->mem_offset = PHYS_PCI_MEM_BASE;
-		ret = pci_v3_setup_resources(sys->resource);
+		ret = pci_v3_setup_resources(&sys->resources);
 	}
 
 	return ret;
@@ -489,7 +489,8 @@ int __init pci_v3_setup(int nr, struct pci_sys_data *sys)
 
 struct pci_bus * __init pci_v3_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &pci_v3_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &pci_v3_ops, sys,
+				 &sys->resources);
 }
 
 /*
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 251c408..3738a28 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -536,14 +536,14 @@ struct pci_bus *iop13xx_scan_bus(int nr, struct pci_sys_data *sys)
 			while(time_before(jiffies, atux_trhfa_timeout))
 				udelay(100);
 
-		bus = pci_bus_atux = pci_scan_bus(sys->busnr,
-						  &iop13xx_atux_ops,
-						  sys);
+		bus = pci_bus_atux = pci_scan_root_bus(NULL, sys->busnr,
+						       &iop13xx_atux_ops,
+						       sys, &sys->resources);
 		break;
 	case IOP13XX_INIT_ATU_ATUE:
-		bus = pci_bus_atue = pci_scan_bus(sys->busnr,
-						  &iop13xx_atue_ops,
-						  sys);
+		bus = pci_bus_atue = pci_scan_root_bus(NULL, sys->busnr,
+						       &iop13xx_atue_ops,
+						       sys, &sys->resources);
 		break;
 	}
 
@@ -1083,9 +1083,8 @@ int iop13xx_pci_setup(int nr, struct pci_sys_data *sys)
 	request_resource(&ioport_resource, &res[0]);
 	request_resource(&iomem_resource, &res[1]);
 
-	sys->resource[0] = &res[0];
-	sys->resource[1] = &res[1];
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &res[0]);
+	pci_add_resource(&sys->resources, &res[1]);
 
 	return 1;
 }
diff --git a/arch/arm/mach-ixp2000/enp2611.c b/arch/arm/mach-ixp2000/enp2611.c
index 62c60ad..2f5dd72 100644
--- a/arch/arm/mach-ixp2000/enp2611.c
+++ b/arch/arm/mach-ixp2000/enp2611.c
@@ -145,7 +145,8 @@ static struct pci_ops enp2611_pci_ops = {
 static struct pci_bus * __init enp2611_pci_scan_bus(int nr,
 						struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &enp2611_pci_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &enp2611_pci_ops, sys,
+				 &sys->resources);
 }
 
 static int __init enp2611_pci_map_irq(const struct pci_dev *dev, u8 slot,
diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index f5098b3..626fda4 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -132,7 +132,8 @@ static struct pci_ops ixp2000_pci_ops = {
 
 struct pci_bus *ixp2000_pci_scan_bus(int nr, struct pci_sys_data *sysdata)
 {
-	return pci_scan_bus(sysdata->busnr, &ixp2000_pci_ops, sysdata);
+	return pci_scan_root_bus(NULL, sysdata->busnr, &ixp2000_pci_ops,
+				 sysdata, &sysdata->resources);
 }
 
 
@@ -242,9 +243,8 @@ int ixp2000_pci_setup(int nr, struct pci_sys_data *sys)
 	if (nr >= 1)
 		return 0;
 
-	sys->resource[0] = &ixp2000_pci_io_space;
-	sys->resource[1] = &ixp2000_pci_mem_space;
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &ixp2000_pci_io_space);
+	pci_add_resource(&sys->resources, &ixp2000_pci_mem_space);
 
 	return 1;
 }
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index e6be571..25b5c46 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -143,7 +143,8 @@ struct pci_ops ixp23xx_pci_ops = {
 
 struct pci_bus *ixp23xx_pci_scan_bus(int nr, struct pci_sys_data *sysdata)
 {
-	return pci_scan_bus(sysdata->busnr, &ixp23xx_pci_ops, sysdata);
+	return pci_scan_root_bus(NULL, sysdata->busnr, &ixp23xx_pci_ops,
+				 sysdata, &sysdata->resources);
 }
 
 int ixp23xx_pci_abort_handler(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
@@ -280,9 +281,8 @@ int ixp23xx_pci_setup(int nr, struct pci_sys_data *sys)
 	if (nr >= 1)
 		return 0;
 
-	sys->resource[0] = &ixp23xx_pci_io_space;
-	sys->resource[1] = &ixp23xx_pci_mem_space;
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &ixp23xx_pci_io_space);
+	pci_add_resource(&sys->resources, &ixp23xx_pci_mem_space);
 
 	return 1;
 }
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 2131832..b81dedb 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -470,9 +470,8 @@ int ixp4xx_setup(int nr, struct pci_sys_data *sys)
 	request_resource(&ioport_resource, &res[0]);
 	request_resource(&iomem_resource, &res[1]);
 
-	sys->resource[0] = &res[0];
-	sys->resource[1] = &res[1];
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &res[0]);
+	pci_add_resource(&sys->resources, &res[1]);
 
 	platform_notify = ixp4xx_pci_platform_notify;
 	platform_notify_remove = ixp4xx_pci_platform_notify_remove;
@@ -482,7 +481,8 @@ int ixp4xx_setup(int nr, struct pci_sys_data *sys)
 
 struct pci_bus * __devinit ixp4xx_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &ixp4xx_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &ixp4xx_ops, sys,
+				 &sys->resources);
 }
 
 int dma_set_coherent_mask(struct device *dev, u64 mask)
diff --git a/arch/arm/mach-kirkwood/pcie.c b/arch/arm/mach-kirkwood/pcie.c
index 74b992d..9ca38de 100644
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -198,9 +198,8 @@ static int __init kirkwood_pcie_setup(int nr, struct pci_sys_data *sys)
 	if (request_resource(&iomem_resource, &pp->res[1]))
 		panic("Request PCIe%d Memory resource failed\n", index);
 
-	sys->resource[0] = &pp->res[0];
-	sys->resource[1] = &pp->res[1];
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &pp->res[0]);
+	pci_add_resource(&sys->resources, &pp->res[1]);
 	sys->io_offset = 0;
 
 	/*
@@ -236,7 +235,8 @@ kirkwood_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	struct pci_bus *bus;
 
 	if (nr < num_pcie_ports) {
-		bus = pci_scan_bus(sys->busnr, &pcie_ops, sys);
+		bus = pci_scan_root_bus(NULL, sys->busnr, &pcie_ops, sys,
+					&sys->resources);
 	} else {
 		bus = NULL;
 		BUG();
diff --git a/arch/arm/mach-ks8695/pci.c b/arch/arm/mach-ks8695/pci.c
index c7c9a18..b26f992 100644
--- a/arch/arm/mach-ks8695/pci.c
+++ b/arch/arm/mach-ks8695/pci.c
@@ -143,7 +143,8 @@ static struct pci_ops ks8695_pci_ops = {
 
 static struct pci_bus* __init ks8695_pci_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &ks8695_pci_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &ks8695_pci_ops, sys,
+				 &sys->resources);
 }
 
 static struct resource pci_mem = {
@@ -168,9 +169,8 @@ static int __init ks8695_pci_setup(int nr, struct pci_sys_data *sys)
 	request_resource(&iomem_resource, &pci_mem);
 	request_resource(&ioport_resource, &pci_io);
 
-	sys->resource[0] = &pci_io;
-	sys->resource[1] = &pci_mem;
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &pci_io);
+	pci_add_resource(&sys->resources, &pci_mem);
 
 	/* Assign and enable processor bridge */
 	ks8695_local_writeconfig(PCI_BASE_ADDRESS_0, KS8695_PCIMEM_PA);
diff --git a/arch/arm/mach-mv78xx0/pcie.c b/arch/arm/mach-mv78xx0/pcie.c
index c51af1c..c701135 100644
--- a/arch/arm/mach-mv78xx0/pcie.c
+++ b/arch/arm/mach-mv78xx0/pcie.c
@@ -155,9 +155,8 @@ static int __init mv78xx0_pcie_setup(int nr, struct pci_sys_data *sys)
 	orion_pcie_set_local_bus_nr(pp->base, sys->busnr);
 	orion_pcie_setup(pp->base, &mv78xx0_mbus_dram_info);
 
-	sys->resource[0] = &pp->res[0];
-	sys->resource[1] = &pp->res[1];
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &pp->res[0]);
+	pci_add_resource(&sys->resources, &pp->res[1]);
 
 	return 1;
 }
@@ -251,7 +250,8 @@ mv78xx0_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	struct pci_bus *bus;
 
 	if (nr < num_pcie_ports) {
-		bus = pci_scan_bus(sys->busnr, &pcie_ops, sys);
+		bus = pci_scan_root_bus(NULL, sys->busnr, &pcie_ops, sys,
+					&sys->resources);
 	} else {
 		bus = NULL;
 		BUG();
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index bc4a920..4eb9364 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -176,7 +176,7 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 	res[0].end = res[0].start + ORION5X_PCIE_IO_SIZE - 1;
 	if (request_resource(&ioport_resource, &res[0]))
 		panic("Request PCIe IO resource failed\n");
-	sys->resource[0] = &res[0];
+	pci_add_resource(&sys->resources, &res[0]);
 
 	/*
 	 * IORESOURCE_MEM
@@ -187,9 +187,8 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 	res[1].end = res[1].start + ORION5X_PCIE_MEM_SIZE - 1;
 	if (request_resource(&iomem_resource, &res[1]))
 		panic("Request PCIe Memory resource failed\n");
-	sys->resource[1] = &res[1];
+	pci_add_resource(&sys->resources, &res[1]);
 
-	sys->resource[2] = NULL;
 	sys->io_offset = 0;
 
 	return 1;
@@ -505,7 +504,7 @@ static int __init pci_setup(struct pci_sys_data *sys)
 	res[0].end = res[0].start + ORION5X_PCI_IO_SIZE - 1;
 	if (request_resource(&ioport_resource, &res[0]))
 		panic("Request PCI IO resource failed\n");
-	sys->resource[0] = &res[0];
+	pci_add_resource(&sys->resources, &res[0]);
 
 	/*
 	 * IORESOURCE_MEM
@@ -516,9 +515,8 @@ static int __init pci_setup(struct pci_sys_data *sys)
 	res[1].end = res[1].start + ORION5X_PCI_MEM_SIZE - 1;
 	if (request_resource(&iomem_resource, &res[1]))
 		panic("Request PCI Memory resource failed\n");
-	sys->resource[1] = &res[1];
+	pci_add_resource(&sys->resources, &res[1]);
 
-	sys->resource[2] = NULL;
 	sys->io_offset = 0;
 
 	return 1;
@@ -579,9 +577,11 @@ struct pci_bus __init *orion5x_pci_sys_scan_bus(int nr, struct pci_sys_data *sys
 	struct pci_bus *bus;
 
 	if (nr == 0) {
-		bus = pci_scan_bus(sys->busnr, &pcie_ops, sys);
+		bus = pci_scan_root_bus(NULL, sys->busnr, &pcie_ops, sys,
+					&sys->resources);
 	} else if (nr == 1 && !orion5x_pci_disabled) {
-		bus = pci_scan_bus(sys->busnr, &pci_ops, sys);
+		bus = pci_scan_root_bus(NULL, sys->busnr, &pci_ops, sys,
+					&sys->resources);
 	} else {
 		bus = NULL;
 		BUG();
diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
index dd39fee..f9b20d3 100644
--- a/arch/arm/mach-sa1100/pci-nanoengine.c
+++ b/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -131,7 +131,8 @@ static int __init pci_nanoengine_map_irq(const struct pci_dev *dev, u8 slot,
 
 struct pci_bus * __init pci_nanoengine_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &pci_nano_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &pci_nano_ops, sys,
+				 &sys->resources);
 }
 
 static struct resource pci_io_ports = {
@@ -243,9 +244,9 @@ static int __init pci_nanoengine_setup_resources(struct resource **resource)
 		printk(KERN_ERR "PCI: unable to allocate prefetchable\n");
 		return -EBUSY;
 	}
-	resource[0] = &pci_io_ports;
-	resource[1] = &pci_non_prefetchable_memory;
-	resource[2] = &pci_prefetchable_memory;
+	pci_add_resource(&sys->resources, &pci_io_ports);
+	pci_add_resource(&sys->resources, &pci_non_prefetchable_memory);
+	pci_add_resource(&sys->resources, &pci_prefetchable_memory);
 
 	return 1;
 }
diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index f1f699d..e3f0d15 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -406,7 +406,7 @@ static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 	pp->res[0].flags = IORESOURCE_IO;
 	if (request_resource(&ioport_resource, &pp->res[0]))
 		panic("Request PCIe IO resource failed\n");
-	sys->resource[0] = &pp->res[0];
+	pci_add_resource(&sys->resources, &pp->res[0]);
 
 	/*
 	 * IORESOURCE_MEM
@@ -425,7 +425,7 @@ static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 	pp->res[1].flags = IORESOURCE_MEM;
 	if (request_resource(&iomem_resource, &pp->res[1]))
 		panic("Request PCIe Memory resource failed\n");
-	sys->resource[1] = &pp->res[1];
+	pci_add_resource(&sys->resources, &pp->res[1]);
 
 	/*
 	 * IORESOURCE_MEM | IORESOURCE_PREFETCH
@@ -444,7 +444,7 @@ static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 	pp->res[2].flags = IORESOURCE_MEM | IORESOURCE_PREFETCH;
 	if (request_resource(&iomem_resource, &pp->res[2]))
 		panic("Request PCIe Prefetch Memory resource failed\n");
-	sys->resource[2] = &pp->res[2];
+	pci_add_resource(&sys->resources, &pp->res[2]);
 
 	return 1;
 }
@@ -465,7 +465,8 @@ static struct pci_bus __init *tegra_pcie_scan_bus(int nr,
 	pp = tegra_pcie.port + nr;
 	pp->root_bus_nr = sys->busnr;
 
-	return pci_scan_bus(sys->busnr, &tegra_pcie_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &tegra_pcie_ops, sys,
+				 &sys->resources);
 }
 
 static struct hw_pci tegra_pcie_hw __initdata = {
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index c898deb..90069bc 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -191,7 +191,7 @@ static struct resource pre_mem = {
 	.flags	= IORESOURCE_MEM | IORESOURCE_PREFETCH,
 };
 
-static int __init pci_versatile_setup_resources(struct resource **resource)
+static int __init pci_versatile_setup_resources(struct list_head *resources)
 {
 	int ret = 0;
 
@@ -215,13 +215,13 @@ static int __init pci_versatile_setup_resources(struct resource **resource)
 	}
 
 	/*
-	 * bus->resource[0] is the IO resource for this bus
-	 * bus->resource[1] is the mem resource for this bus
-	 * bus->resource[2] is the prefetch mem resource for this bus
+	 * the IO resource for this bus
+	 * the mem resource for this bus
+	 * the prefetch mem resource for this bus
 	 */
-	resource[0] = &io_mem;
-	resource[1] = &non_mem;
-	resource[2] = &pre_mem;
+	pci_add_resource(resources, &io_mem);
+	pci_add_resource(resources, &non_mem);
+	pci_add_resource(resources, &pre_mem);
 
 	goto out;
 
@@ -250,7 +250,7 @@ int __init pci_versatile_setup(int nr, struct pci_sys_data *sys)
 
 	if (nr == 0) {
 		sys->mem_offset = 0;
-		ret = pci_versatile_setup_resources(sys->resource);
+		ret = pci_versatile_setup_resources(&sys->resources);
 		if (ret < 0) {
 			printk("pci_versatile_setup: resources... oops?\n");
 			goto out;
@@ -306,7 +306,8 @@ int __init pci_versatile_setup(int nr, struct pci_sys_data *sys)
 
 struct pci_bus * __init pci_versatile_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &pci_versatile_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &pci_versatile_ops, sys,
+				 &sys->resources);
 }
 
 void __init pci_versatile_preinit(void)
diff --git a/arch/arm/plat-iop/pci.c b/arch/arm/plat-iop/pci.c
index 845549c..f4d40a2 100644
--- a/arch/arm/plat-iop/pci.c
+++ b/arch/arm/plat-iop/pci.c
@@ -215,16 +215,16 @@ int iop3xx_pci_setup(int nr, struct pci_sys_data *sys)
 	sys->mem_offset = IOP3XX_PCI_LOWER_MEM_PA - *IOP3XX_OMWTVR0;
 	sys->io_offset  = IOP3XX_PCI_LOWER_IO_PA - *IOP3XX_OIOWTVR;
 
-	sys->resource[0] = &res[0];
-	sys->resource[1] = &res[1];
-	sys->resource[2] = NULL;
+	pci_add_resource(&sys->resources, &res[0]);
+	pci_add_resource(&sys->resources, &res[1]);
 
 	return 1;
 }
 
 struct pci_bus *iop3xx_pci_scan_bus(int nr, struct pci_sys_data *sys)
 {
-	return pci_scan_bus(sys->busnr, &iop3xx_ops, sys);
+	return pci_scan_root_bus(NULL, sys->busnr, &iop3xx_ops, sys,
+				 &sys->resources);
 }
 
 void __init iop3xx_atu_setup(void)

