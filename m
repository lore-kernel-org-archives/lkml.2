Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1KPK4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:56:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1KPK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:56:12 -0500
From: Rene Bolldorf <xsecute@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Rene Bolldorf <xsecute@googlemail.com>
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=20Initial=20PCI=20support=20for=20Atheros=20724x=20SoCs=2E?=
Date: Wed, 16 Nov 2011 11:55:39 +0100
Message-Id: <1321440940-20246-2-git-send-email-xsecute@googlemail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321440940-20246-1-git-send-email-xsecute@googlemail.com>
References: <1321440940-20246-1-git-send-email-xsecute@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
---
 arch/mips/pci/Makefile      |    1 +
 arch/mips/pci/ops-ath724x.c |  109 +++++++++++++++++++++++++++++++++++++++++++
 arch/mips/pci/pci-ath724x.c |   45 ++++++++++++++++++
 3 files changed, 155 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/pci/ops-ath724x.c
 create mode 100644 arch/mips/pci/pci-ath724x.c

diff --git a/arch/mips/pci/Makefile b/arch/mips/pci/Makefile
index bb82cbd..5180b38 100644
--- a/arch/mips/pci/Makefile
+++ b/arch/mips/pci/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_BCM47XX)		+= pci-bcm47xx.o
 obj-$(CONFIG_BCM63XX)		+= pci-bcm63xx.o fixup-bcm63xx.o \
 					ops-bcm63xx.o
 obj-$(CONFIG_MIPS_ALCHEMY)	+= pci-alchemy.o
+obj-$(CONFIG_SOC_AR724X)	+= ops-ath724x.o pci-ath724x.o
 
 #
 # These are still pretty much in the old state, watch, go blind.
diff --git a/arch/mips/pci/ops-ath724x.c b/arch/mips/pci/ops-ath724x.c
new file mode 100644
index 0000000..bd3cf15
--- /dev/null
+++ b/arch/mips/pci/ops-ath724x.c
@@ -0,0 +1,109 @@
+/*
+ *  Atheros 724x PCI support
+ *
+ *  Copyright (C) 2011 René Bolldorf <xsecute@googlemail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ */
+
+#include <linux/pci.h>
+
+#define reg_read(_phys)		(*(volatile unsigned int *) KSEG1ADDR(_phys))
+#define reg_write(_phys, _val)	((*(volatile unsigned int *) KSEG1ADDR(_phys)) = (_val))
+
+#define ATH724X_PCI_DEV_BASE	0x14000000
+
+static DEFINE_SPINLOCK(ath724x_pci_lock);
+
+static int ath724x_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+			    int size, uint32_t *value)
+{
+	unsigned long flags, addr, tval, mask;
+
+	if(devfn)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	if(where & (size - 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	spin_lock_irqsave(&ath724x_pci_lock, flags);
+
+	switch (size) {
+	case 1:
+		addr = where & ~3;
+		mask = 0xff000000 >> ((where % 4) * 8);
+		tval = reg_read(ATH724X_PCI_DEV_BASE + addr);
+		tval = tval & ~mask;
+		*value = (tval >> ((4 - (where % 4))*8));
+	break;
+	case 2:
+		addr = where & ~3;
+		mask = 0xffff0000 >> ((where % 4)*8);
+		tval = reg_read(ATH724X_PCI_DEV_BASE + addr);
+		tval = tval & ~mask;
+		*value = (tval >> ((4 - (where % 4))*8));
+	break;
+	case 4:
+		*value = reg_read(ATH724X_PCI_DEV_BASE + where);
+	break;
+	default:
+		spin_unlock_irqrestore(&ath724x_pci_lock, flags);
+
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	}
+
+	spin_unlock_irqrestore(&ath724x_pci_lock, flags);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int ath724x_pci_write(struct pci_bus *bus,  unsigned int devfn, int where,
+			     int size, uint32_t value)
+{
+	unsigned long flags, tval, addr, mask;
+
+	if(devfn)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	if(where & (size - 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	spin_lock_irqsave(&ath724x_pci_lock, flags);
+
+	switch (size) {
+	case 1:
+		addr = (ATH724X_PCI_DEV_BASE + where) & ~3;
+		mask = 0xff000000 >> ((where % 4)*8);
+		tval = reg_read(addr);
+		tval = tval & ~mask;
+		tval |= (value << ((4 - (where % 4))*8)) & mask;
+		reg_write(addr,tval);
+	break;
+	case 2:
+		addr = (ATH724X_PCI_DEV_BASE + where) & ~3;
+		mask = 0xffff0000 >> ((where % 4)*8);
+		tval = reg_read(addr);
+		tval = tval & ~mask;
+		tval |= (value << ((4 - (where % 4))*8)) & mask;
+		reg_write(addr,tval);
+	break;
+	case 4:
+		reg_write((ATH724X_PCI_DEV_BASE + where),value);
+	break;
+	default:
+		spin_unlock_irqrestore(&ath724x_pci_lock, flags);
+
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	}
+
+	spin_unlock_irqrestore(&ath724x_pci_lock, flags);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+struct pci_ops ath724x_pci_ops = {
+	.read	= ath724x_pci_read,
+	.write	= ath724x_pci_write,
+};
diff --git a/arch/mips/pci/pci-ath724x.c b/arch/mips/pci/pci-ath724x.c
new file mode 100644
index 0000000..6c6c483
--- /dev/null
+++ b/arch/mips/pci/pci-ath724x.c
@@ -0,0 +1,45 @@
+/*
+ *  Atheros 724x PCI support
+ *
+ *  Copyright (C) 2011 René Bolldorf <xsecute@googlemail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ */
+
+#include <linux/pci.h>
+
+#define ATH724X_PCI_MEM_BASE    0x10000000
+#define ATH724X_PCI_MEM_SIZE    0x08000000
+
+static struct resource ath724x_io_resource = {
+	.name	= "PCI IO space",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_IO,
+};
+
+static struct resource ath724x_mem_resource = {
+	.name	= "PCI memory space",
+	.start	= ATH724X_PCI_MEM_BASE,
+	.end	= ATH724X_PCI_MEM_BASE + ATH724X_PCI_MEM_SIZE - 1,
+	.flags	= IORESOURCE_MEM,
+};
+
+extern struct pci_ops ath724x_pci_ops;
+
+static struct pci_controller ath724x_pci_controller = {
+	.pci_ops	= &ath724x_pci_ops,
+	.mem_resource	= &ath724x_mem_resource,
+	.io_resource	= &ath724x_io_resource,
+};
+
+static int __init ath724x_pcibios_init(void)
+{
+	register_pci_controller(&ath724x_pci_controller);
+
+	return 0;
+}
+
+arch_initcall(ath724x_pcibios_init);
-- 
1.7.7.1

