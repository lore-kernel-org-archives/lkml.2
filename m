Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2KMJIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:08:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53123 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2KMJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:08:13 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org,
        mingo@redhat.com, Takao Indoh <indou.takao@jp.fujitsu.com>,
        khalid@gonehiking.org
Message-Id: <20121113090251.1180.77695.sendpatchset@indoh>
In-Reply-To: <20121113090212.1180.12233.sendpatchset@indoh>
References: <20121113090212.1180.12233.sendpatchset@indoh>
Subject: [PATCH v6 4/5] x86, pci: Reset PCIe devices at boot time
Date: Tue, 13 Nov 2012 18:08:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets PCIe devices at boot time by hot reset when
"reset_devices" is specified.

Kdump with intel_iommu=on fails becasue ongoing DMA from first kernel
causes DMAR fault when page table of DMAR is initialized while kdump
kernel is booting up. To solve this problem, this patch resets PCIe
devices by hot reset and its DMA is stopped when reset_devices is
specified.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/include/asm/pci-direct.h |    1 +
 arch/x86/kernel/setup.c           |    3 +
 arch/x86/pci/early.c              |  228 +++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
index b6360d3..5620070 100644
--- a/arch/x86/include/asm/pci-direct.h
+++ b/arch/x86/include/asm/pci-direct.h
@@ -18,6 +18,7 @@ extern int early_pci_allowed(void);
 extern unsigned int pci_early_dump_regs;
 extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
 extern void early_dump_pci_devices(void);
+extern void early_reset_pcie_devices(void);
 
 struct pci_dev *get_early_pci_dev(int num, int slot, int func);
 #endif /* _ASM_X86_PCI_DIRECT_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..2e7928e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1001,6 +1001,9 @@ void __init setup_arch(char **cmdline_p)
 	generic_apic_probe();
 
 	early_quirks();
+#ifdef CONFIG_PCI
+	early_reset_pcie_devices();
+#endif
 
 	/*
 	 * Read APIC and some other early information from ACPI tables.
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index aea6b2b..32b02c6 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/bootmem.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/pci_x86.h>
@@ -184,3 +185,230 @@ __init struct pci_dev *get_early_pci_dev(int num, int slot, int func)
 
 	return pdev;
 }
+
+struct save_config {
+	u32 pci[16];
+	u16 pcie[7];
+	int saved;
+};
+
+struct pcie_port {
+	struct list_head dev;
+	u8 bus;
+	u8 slot;
+	u8 func;
+	u8 secondary;
+	struct save_config save[PCI_MAX_FUNCTIONS];
+};
+
+static __initdata LIST_HEAD(device_list);
+static void __init early_udelay(int loops)
+{
+	while (loops--) {
+		/* Approximately 1 us */
+		native_io_delay();
+	}
+}
+
+struct pci_dev * __init early_pci_dev_init(int bus, int slot, int func)
+{
+	u16 vendor;
+	u8 type;
+	struct pci_dev *pdev;
+
+	pdev = get_early_pci_dev(bus, slot, func);
+	pci_read_config_word(pdev, PCI_VENDOR_ID, &vendor);
+	if (vendor == 0xffff)
+		return NULL;
+
+	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &type);
+	pdev->hdr_type = type;
+	set_pcie_port_type(pdev);
+
+	return pdev;
+}
+
+static void __init do_reset(u8 bus, u8 slot, u8 func)
+{
+	u16 ctrl;
+	struct pci_dev *dev;
+
+	dev = get_early_pci_dev(bus, slot, func);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d reset\n", bus, slot, func);
+
+	/* Assert Secondary Bus Reset */
+	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
+	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+
+	/*
+	 * PCIe spec requires software to ensure a minimum reset duration
+	 * (Trst == 1ms). We have here 5ms safety margin because early_udelay
+	 * is not precise.
+	 */
+	early_udelay(5000);
+
+	/* De-assert Secondary Bus Reset */
+	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+}
+
+static void __init save_state(unsigned bus, unsigned slot, unsigned func,
+			      struct save_config *save)
+{
+	struct pci_dev *dev;
+	int i;
+
+	dev = get_early_pci_dev(bus, slot, func);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d save state\n", bus, slot, func);
+
+	for (i = 0; i < 16; i++)
+		pci_read_config_dword(dev, i * 4, save->pci + i);
+	i = 0;
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_SLTCTL, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_RTCTL, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &save->pcie[i++]);
+	pcie_capability_read_word(dev, PCI_EXP_SLTCTL2, &save->pcie[i++]);
+
+	save->saved = true;
+}
+
+static void __init restore_state(unsigned bus, unsigned slot, unsigned func,
+				 struct save_config *save)
+{
+	struct pci_dev *dev;
+	int i = 0;
+
+	dev = get_early_pci_dev(bus, slot, func);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d restore state\n",
+	       bus, slot, func);
+
+	pcie_capability_write_word(dev, PCI_EXP_DEVCTL, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_LNKCTL, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_SLTCTL, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_RTCTL, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_DEVCTL2, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, save->pcie[i++]);
+	pcie_capability_write_word(dev, PCI_EXP_SLTCTL2, save->pcie[i++]);
+
+	for (i = 15; i >= 0; i--)
+		pci_write_config_dword(dev, i * 4, save->pci[i]);
+}
+
+static void __init find_pcie_device(unsigned bus, unsigned slot, unsigned func)
+{
+	struct pci_dev *dev;
+	int f, pcie_type, count;
+	u8 secondary;
+	u32 class;
+	struct pcie_port *port;
+	int children[PCI_MAX_FUNCTIONS];
+
+	dev = early_pci_dev_init(bus, slot, func);
+	if (!dev || !pci_is_pcie(dev))
+		return;
+
+	pcie_type = pci_pcie_type(dev);
+	if ((pcie_type != PCI_EXP_TYPE_ROOT_PORT) &&
+	    (pcie_type != PCI_EXP_TYPE_DOWNSTREAM))
+		return;
+
+	if ((dev->hdr_type & 0x7f) != PCI_HEADER_TYPE_BRIDGE)
+		return;
+	pci_read_config_byte(dev, PCI_SECONDARY_BUS, &secondary);
+
+	memset(children, 0, sizeof(children));
+	for (count = 0, f = 0; f < PCI_MAX_FUNCTIONS; f++) {
+		dev = early_pci_dev_init(secondary, 0, f);
+		if (!dev || !pci_is_pcie(dev))
+			continue;
+
+		pcie_type = pci_pcie_type(dev);
+		if ((pcie_type == PCI_EXP_TYPE_UPSTREAM) ||
+		    (pcie_type == PCI_EXP_TYPE_PCI_BRIDGE))
+			/* Don't reset switch, bridge */
+			return;
+
+		pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
+		if ((class >> 24) == PCI_BASE_CLASS_DISPLAY)
+			/* Don't reset VGA device */
+			return;
+
+		count++;
+		children[f] = 1;
+	}
+
+	if (!count)
+		return;
+
+	port = (struct pcie_port *)alloc_bootmem(sizeof(struct pcie_port));
+	if (port == NULL) {
+		printk(KERN_ERR "pci 0000:%02x:%02x.%d alloc_bootmem failed\n",
+		       bus, slot, func);
+		return;
+	}
+	memset(port, 0, sizeof(*port));
+	port->bus = bus;
+	port->slot = slot;
+	port->func = func;
+	port->secondary = secondary;
+	for (f = 0; f < PCI_MAX_FUNCTIONS; f++)
+		if (children[f])
+			save_state(secondary, 0, f, &port->save[f]);
+	list_add_tail(&port->dev, &device_list);
+}
+
+void __init early_reset_pcie_devices(void)
+{
+	unsigned bus, slot, func;
+	struct pcie_port *port, *tmp;
+	struct pci_dev *dev;
+
+	if (!early_pci_allowed() || !reset_devices)
+		return;
+
+	/* Find PCIe port and save config registers of its downstream devices */
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < PCI_MAX_FUNCTIONS; func++) {
+				u8 type;
+
+				dev = early_pci_dev_init(bus, slot, func);
+				if (!dev)
+					continue;
+
+				type = dev->hdr_type;
+				find_pcie_device(bus, slot, func);
+
+				if ((func == 0) && !(type & 0x80))
+					break;
+			}
+		}
+	}
+
+	if (list_empty(&device_list))
+		return;
+
+	/* Do bus reset */
+	list_for_each_entry(port, &device_list, dev)
+		do_reset(port->bus, port->slot, port->func);
+
+	/*
+	 * According to PCIe spec, software must wait a minimum of 100 ms
+	 * before sending a configuration request. We have 500ms safety margin
+	 * here.
+	 */
+	early_udelay(500000);
+
+	/* Restore config registers and free memory */
+	list_for_each_entry_safe(port, tmp, &device_list, dev) {
+		for (func = 0; func < PCI_MAX_FUNCTIONS; func++)
+			if (port->save[func].saved)
+				restore_state(port->secondary, 0, func,
+					      &port->save[func]);
+		free_bootmem(__pa(port), sizeof(*port));
+	}
+}
-- 
1.7.1


