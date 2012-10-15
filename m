Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2JOHAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:00:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45572 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2JOHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:00:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org, hbabu@us.ibm.com,
        andi@firstfloor.org, ddutile@redhat.com,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com,
        khalid@gonehiking.org
Message-Id: <20121015065526.2832.90867.sendpatchset@indoh>
In-Reply-To: <20121015065516.2832.42378.sendpatchset@indoh>
References: <20121015065516.2832.42378.sendpatchset@indoh>
Subject: [PATCH v4 1/2] x86, pci: Reset PCIe devices at boot time
Date: Mon, 15 Oct 2012 16:00:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets PCIe devices at boot time by hot reset when
"reset_devices" is specified.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/include/asm/pci-direct.h |    1 
 arch/x86/kernel/setup.c           |    3 
 arch/x86/pci/early.c              |  344 ++++++++++++++++++++++++++++
 include/linux/pci.h               |    2 
 init/main.c                       |    4 
 5 files changed, 352 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
index b1e7a45..de30db2 100644
--- a/arch/x86/include/asm/pci-direct.h
+++ b/arch/x86/include/asm/pci-direct.h
@@ -18,4 +18,5 @@ extern int early_pci_allowed(void);
 extern unsigned int pci_early_dump_regs;
 extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
 extern void early_dump_pci_devices(void);
+extern void early_reset_pcie_devices(void);
 #endif /* _ASM_X86_PCI_DIRECT_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a2bb18e..73d3425 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -987,6 +987,9 @@ void __init setup_arch(char **cmdline_p)
 	generic_apic_probe();
 
 	early_quirks();
+#ifdef CONFIG_PCI
+	early_reset_pcie_devices();
+#endif
 
 	/*
 	 * Read APIC and some other early information from ACPI tables.
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index d1067d5..683b30f 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/bootmem.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/pci_x86.h>
@@ -109,3 +110,346 @@ void early_dump_pci_devices(void)
 		}
 	}
 }
+
+#define PCI_EXP_SAVE_REGS	7
+#define pcie_cap_has_devctl(type, flags)	1
+#define pcie_cap_has_lnkctl(type, flags)		\
+		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
+		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
+		  type == PCI_EXP_TYPE_ENDPOINT ||	\
+		  type == PCI_EXP_TYPE_LEG_END))
+#define pcie_cap_has_sltctl(type, flags)		\
+		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
+		 ((type == PCI_EXP_TYPE_ROOT_PORT) ||	\
+		  (type == PCI_EXP_TYPE_DOWNSTREAM &&	\
+		   (flags & PCI_EXP_FLAGS_SLOT))))
+#define pcie_cap_has_rtctl(type, flags)			\
+		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
+		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
+		  type == PCI_EXP_TYPE_RC_EC))
+
+struct save_config {
+	u32 pci[16];
+	u16 pcie[PCI_EXP_SAVE_REGS];
+};
+
+struct pcie_dev {
+	int cap;   /* position of PCI Express capability */
+	int flags; /* PCI_EXP_FLAGS */
+	struct save_config save; /* saved configration register */
+};
+
+struct pcie_port {
+	struct list_head dev;
+	u8 secondary;
+	struct pcie_dev child[PCI_MAX_FUNCTIONS];
+};
+
+static LIST_HEAD(device_list);
+static void __init pci_udelay(int loops)
+{
+	while (loops--) {
+		/* Approximately 1 us */
+		native_io_delay();
+	}
+}
+
+/* Derived from drivers/pci/pci.c */
+#define PCI_FIND_CAP_TTL	48
+static int __init __pci_find_next_cap_ttl(u8 bus, u8 slot, u8 func,
+					  u8 pos, int cap, int *ttl)
+{
+	u8 id;
+
+	while ((*ttl)--) {
+		pos = read_pci_config_byte(bus, slot, func, pos);
+		if (pos < 0x40)
+			break;
+		pos &= ~3;
+		id = read_pci_config_byte(bus, slot, func,
+					pos + PCI_CAP_LIST_ID);
+		if (id == 0xff)
+			break;
+		if (id == cap)
+			return pos;
+		pos += PCI_CAP_LIST_NEXT;
+	}
+	return 0;
+}
+
+static int __init __pci_find_next_cap(u8 bus, u8 slot, u8 func, u8 pos, int cap)
+{
+	int ttl = PCI_FIND_CAP_TTL;
+
+	return __pci_find_next_cap_ttl(bus, slot, func, pos, cap, &ttl);
+}
+
+static int __init __pci_bus_find_cap_start(u8 bus, u8 slot, u8 func,
+					   u8 hdr_type)
+{
+	u16 status;
+
+	status = read_pci_config_16(bus, slot, func, PCI_STATUS);
+	if (!(status & PCI_STATUS_CAP_LIST))
+		return 0;
+
+	switch (hdr_type) {
+	case PCI_HEADER_TYPE_NORMAL:
+	case PCI_HEADER_TYPE_BRIDGE:
+		return PCI_CAPABILITY_LIST;
+	case PCI_HEADER_TYPE_CARDBUS:
+		return PCI_CB_CAPABILITY_LIST;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static int __init early_pci_find_capability(u8 bus, u8 slot, u8 func, int cap)
+{
+	int pos;
+	u8 type = read_pci_config_byte(bus, slot, func, PCI_HEADER_TYPE);
+
+	pos = __pci_bus_find_cap_start(bus, slot, func, type & 0x7f);
+	if (pos)
+		pos = __pci_find_next_cap(bus, slot, func, pos, cap);
+
+	return pos;
+}
+
+static void __init do_reset(u8 bus, u8 slot, u8 func)
+{
+	u16 ctrl;
+
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d reset\n", bus, slot, func);
+
+	/* Assert Secondary Bus Reset */
+	ctrl = read_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL);
+	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
+	write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
+
+	/*
+	 * PCIe spec requires software to ensure a minimum reset duration
+	 * (Trst == 1ms). We have here 5ms safety margin because pci_udelay is
+	 * not precise.
+	 */
+	pci_udelay(5000);
+
+	/* De-assert Secondary Bus Reset */
+	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
+}
+
+static void __init save_state(unsigned bus, unsigned slot, unsigned func,
+		struct pcie_dev *dev)
+{
+	int i;
+	int pcie, flags, pcie_type;
+	struct save_config *save;
+
+	pcie = dev->cap;
+	flags = dev->flags;
+	pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+	save = &dev->save;
+
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d save state\n", bus, slot, func);
+
+	for (i = 0; i < 16; i++)
+		save->pci[i] = read_pci_config(bus, slot, func, i * 4);
+	i = 0;
+	if (pcie_cap_has_devctl(pcie_type, flags))
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_DEVCTL);
+	if (pcie_cap_has_lnkctl(pcie_type, flags))
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_LNKCTL);
+	if (pcie_cap_has_sltctl(pcie_type, flags))
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_SLTCTL);
+	if (pcie_cap_has_rtctl(pcie_type, flags))
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_RTCTL);
+
+	if ((flags & PCI_EXP_FLAGS_VERS) >= 2) {
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_DEVCTL2);
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_LNKCTL2);
+		save->pcie[i++] = read_pci_config_16(bus, slot, func,
+						      pcie + PCI_EXP_SLTCTL2);
+	}
+}
+
+static void __init restore_state(unsigned bus, unsigned slot, unsigned func,
+		struct pcie_dev *dev)
+{
+	int i = 0;
+	int pcie, flags, pcie_type;
+	struct save_config *save;
+
+	pcie = dev->cap;
+	flags = dev->flags;
+	pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+	save = &dev->save;
+
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d restore state\n",
+	       bus, slot, func);
+
+	if (pcie_cap_has_devctl(pcie_type, flags))
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_DEVCTL, save->pcie[i++]);
+	if (pcie_cap_has_lnkctl(pcie_type, flags))
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_LNKCTL, save->pcie[i++]);
+	if (pcie_cap_has_sltctl(pcie_type, flags))
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_SLTCTL, save->pcie[i++]);
+	if (pcie_cap_has_rtctl(pcie_type, flags))
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_RTCTL, save->pcie[i++]);
+
+	if ((flags & PCI_EXP_FLAGS_VERS) >= 2) {
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_DEVCTL2, save->pcie[i++]);
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_LNKCTL2, save->pcie[i++]);
+		write_pci_config_16(bus, slot, func,
+				    pcie + PCI_EXP_SLTCTL2, save->pcie[i++]);
+	}
+
+	for (i = 15; i >= 0; i--)
+		write_pci_config(bus, slot, func, i * 4, save->pci[i]);
+}
+
+static void __init find_pcie_device(unsigned bus, unsigned slot, unsigned func)
+{
+	int f, count;
+	int pcie, pcie_type;
+	u8 type;
+	u16 vendor, flags;
+	u32 class;
+	int secondary;
+	struct pcie_port *port;
+	int pcie_cap[PCI_MAX_FUNCTIONS];
+	int pcie_flags[PCI_MAX_FUNCTIONS];
+
+	pcie = early_pci_find_capability(bus, slot, func, PCI_CAP_ID_EXP);
+	if (!pcie)
+		return;
+
+	flags = read_pci_config_16(bus, slot, func, pcie + PCI_EXP_FLAGS);
+	pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+	if ((pcie_type != PCI_EXP_TYPE_ROOT_PORT) &&
+	    (pcie_type != PCI_EXP_TYPE_DOWNSTREAM))
+		return;
+
+	type = read_pci_config_byte(bus, slot, func, PCI_HEADER_TYPE);
+	if ((type & 0x7f) != PCI_HEADER_TYPE_BRIDGE)
+		return;
+	secondary = read_pci_config_byte(bus, slot, func, PCI_SECONDARY_BUS);
+
+	memset(pcie_cap, 0, sizeof(pcie_cap));
+	memset(pcie_flags, 0, sizeof(pcie_flags));
+	for (count = 0, f = 0; f < PCI_MAX_FUNCTIONS; f++) {
+		vendor = read_pci_config_16(secondary, 0, f, PCI_VENDOR_ID);
+		if (vendor == 0xffff)
+			continue;
+
+		pcie = early_pci_find_capability(secondary, 0, f,
+				PCI_CAP_ID_EXP);
+		if (!pcie)
+			continue;
+
+		flags = read_pci_config_16(secondary, 0, f,
+				pcie + PCI_EXP_FLAGS);
+		pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+		if ((pcie_type == PCI_EXP_TYPE_UPSTREAM) ||
+		    (pcie_type == PCI_EXP_TYPE_PCI_BRIDGE))
+			/* Don't reset switch, bridge */
+			return;
+
+		class = read_pci_config(secondary, 0, f, PCI_CLASS_REVISION);
+		if ((class >> 24) == PCI_BASE_CLASS_DISPLAY)
+			/* Don't reset VGA device */
+			return;
+
+		count++;
+		pcie_cap[f] = pcie;
+		pcie_flags[f] = flags;
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
+	port->secondary = secondary;
+	for (f = 0; f < PCI_MAX_FUNCTIONS; f++) {
+		if (pcie_cap[f] != 0) {
+			port->child[f].cap = pcie_cap[f];
+			port->child[f].flags = pcie_flags[f];
+			save_state(secondary, 0, f, &port->child[f]);
+		}
+	}
+	do_reset(bus, slot, func);
+	list_add_tail(&port->dev, &device_list);
+}
+
+void __init early_reset_pcie_devices(void)
+{
+	unsigned bus, slot, func;
+	struct pcie_port *port, *tmp;
+
+	if (!early_pci_allowed() || !reset_devices)
+		return;
+
+	/* Find PCIe port and reset its downstream devices */
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < PCI_MAX_FUNCTIONS; func++) {
+				u16 vendor;
+				u8 type;
+				vendor = read_pci_config_16(bus, slot, func,
+						PCI_VENDOR_ID);
+
+				if (vendor == 0xffff)
+					continue;
+
+				find_pcie_device(bus, slot, func);
+
+				if (func == 0) {
+					type = read_pci_config_byte(bus, slot,
+								    func,
+							       PCI_HEADER_TYPE);
+					if (!(type & 0x80))
+						break;
+				}
+			}
+		}
+	}
+
+	if (list_empty(&device_list))
+		return;
+
+	/*
+	 * According to PCIe spec, software must wait a minimum of 100 ms
+	 * before sending a configuration request. We have 500ms safety margin
+	 * here.
+	 */
+	pci_udelay(500000);
+
+	/* Restore config registers and free memory */
+	list_for_each_entry_safe(port, tmp, &device_list, dev) {
+		for (func = 0; func < PCI_MAX_FUNCTIONS; func++)
+			if (port->child[func].cap)
+				restore_state(port->secondary, 0, func,
+					      &port->child[func]);
+		free_bootmem(__pa(port), sizeof(*port));
+	}
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ee21795..eca3231 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -35,6 +35,8 @@
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+#define PCI_MAX_FUNCTIONS 8
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
diff --git a/init/main.c b/init/main.c
index 9cf77ab..0eb7430 100644
--- a/init/main.c
+++ b/init/main.c
@@ -144,10 +144,10 @@ EXPORT_SYMBOL(reset_devices);
 static int __init set_reset_devices(char *str)
 {
 	reset_devices = 1;
-	return 1;
+	return 0;
 }
 
-__setup("reset_devices", set_reset_devices);
+early_param("reset_devices", set_reset_devices);
 
 static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
 const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };

