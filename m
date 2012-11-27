Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2K0Aml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:42:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52109 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab2K0Amj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:42:39 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, yinghai@kernel.org, mingo@redhat.com,
        vgoyal@redhat.com, khalid@gonehiking.org
Message-Id: <20121127004154.3604.89729.sendpatchset@tindoh.g01.fujitsu.local>
In-Reply-To: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
Subject: [PATCH v7 1/5] x86, pci: add dummy pci device for early stage
Date: Tue, 27 Nov 2012 09:42:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can pass pci_dev *dev to reuse some generic pci functions.

The original patch was written by Yinghai Lu.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/include/asm/pci-direct.h |    2 +
 arch/x86/pci/early.c              |   74 +++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
index b1e7a45..b6360d3 100644
--- a/arch/x86/include/asm/pci-direct.h
+++ b/arch/x86/include/asm/pci-direct.h
@@ -18,4 +18,6 @@ extern int early_pci_allowed(void);
 extern unsigned int pci_early_dump_regs;
 extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
 extern void early_dump_pci_devices(void);
+
+struct pci_dev *get_early_pci_dev(int num, int slot, int func);
 #endif /* _ASM_X86_PCI_DIRECT_H */
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index d1067d5..024def7 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -109,3 +109,77 @@ void early_dump_pci_devices(void)
 		}
 	}
 }
+
+static __init int
+early_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 *value)
+{
+	int num, slot, func;
+
+	num = bus->number;
+	slot = PCI_SLOT(devfn);
+	func = PCI_FUNC(devfn);
+	switch (size) {
+	case 1:
+		*value = read_pci_config_byte(num, slot, func, where);
+		break;
+	case 2:
+		*value = read_pci_config_16(num, slot, func, where);
+		break;
+	case 4:
+		*value = read_pci_config(num, slot, func, where);
+		break;
+	}
+
+	return 0;
+}
+
+static __init int
+early_pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 value)
+{
+	int num, slot, func;
+
+	num = bus->number;
+	slot = PCI_SLOT(devfn);
+	func = PCI_FUNC(devfn);
+	switch (size) {
+	case 1:
+		write_pci_config_byte(num, slot, func, where, (u8)value);
+		break;
+	case 2:
+		write_pci_config_16(num, slot, func, where, (u16)value);
+		break;
+	case 4:
+		write_pci_config(num, slot, func, where, (u32)value);
+		break;
+	}
+
+	return 0;
+}
+
+static __initdata struct pci_ops pci_early_ops = {
+	.read  = early_pci_read,
+	.write = early_pci_write,
+};
+static __initdata struct pci_bus pci_early_bus = {
+	.ops = &pci_early_ops,
+};
+static __initdata char pci_early_init_name[8];
+static __initdata struct pci_dev pci_early_dev;
+
+__init struct pci_dev *get_early_pci_dev(int num, int slot, int func)
+{
+	struct pci_dev *pdev;
+
+	pdev = &pci_early_dev;
+	memset(pdev, 0, sizeof(*pdev));
+
+	pdev->bus = &pci_early_bus,
+	pdev->dev.init_name = pci_early_init_name;
+	pdev->bus->number = num;
+	pdev->devfn = PCI_DEVFN(slot, func);
+	sprintf((char *)pdev->dev.init_name, "%02x:%02x.%01x", num, slot, func);
+
+	return pdev;
+}
-- 
1.7.1


