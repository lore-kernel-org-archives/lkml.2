Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2JBHuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:50:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49051 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2JBHuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:50:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org, hbabu@us.ibm.com,
        mingo@redhat.com, Takao Indoh <indou.takao@jp.fujitsu.com>,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, vgoyal@redhat.com
Message-Id: <20121002074442.204.61135.sendpatchset@indoh>
In-Reply-To: <20121002074434.204.47750.sendpatchset@indoh>
References: <20121002074434.204.47750.sendpatchset@indoh>
Subject: [PATCH v2 1/2] x86, pci: Reset PCIe devices at boot time
Date: Tue,  2 Oct 2012 16:50:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets PCIe devices at boot time by hot reset when
"reset_devices" is specified.


Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/include/asm/pci-direct.h |    1 
 arch/x86/kernel/setup.c           |    3 
 arch/x86/pci/early.c              |  302 ++++++++++++++++++++++++++++
 drivers/pci/pci.c                 |   18 -
 include/linux/pci.h               |   18 +
 init/main.c                       |    4 
 6 files changed, 326 insertions(+), 20 deletions(-)

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
index f4b9b80..24b011c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -988,6 +988,9 @@ void __init setup_arch(char **cmdline_p)
 	generic_apic_probe();
 
 	early_quirks();
+#ifdef CONFIG_PCI
+	early_reset_pcie_devices();
+#endif
 
 	/*
 	 * Read APIC and some other early information from ACPI tables.
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index d1067d5..2ca5f0e 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/bootmem.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/pci_x86.h>
@@ -109,3 +110,304 @@ void early_dump_pci_devices(void)
 		}
 	}
 }
+
+struct save_config {
+	u32 pci[16];
+	u16 pcie[PCI_EXP_SAVE_REGS];
+};
+
+struct devinfo {
+	int pcie_pos;   /* position of PCI Express capability */
+	int pcie_flags; /* PCI_EXP_FLAGS */
+	struct save_config *save;
+};
+
+static void pci_udelay(int loops)
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
+	pci_udelay(5000);
+
+	/* De-assert Secondary Bus Reset */
+	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
+
+	pci_udelay(500000);
+}
+
+static void __init save_state(unsigned bus, unsigned slot, unsigned func,
+		struct devinfo *info)
+{
+	int i;
+	int pcie, flags, pcie_type;
+	struct save_config *save;
+
+	pcie = info->pcie_pos;
+	flags = info->pcie_flags;
+	pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+	save = info->save;
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
+		struct devinfo *info)
+{
+	int i = 0;
+	int pcie, flags, pcie_type;
+	struct save_config *save;
+
+	pcie = info->pcie_pos;
+	flags = info->pcie_flags;
+	pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
+	save = info->save;
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
+static void __init reset_pcie_device(unsigned bus, unsigned slot, unsigned func)
+{
+	int f, count;
+	int pcie, pcie_type;
+	u8 type;
+	u16 vendor, flags;
+	u32 class;
+	int secondary;
+	struct devinfo child[8];
+	struct save_config *save, *pos;
+	int size;
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
+	memset(child, 0, sizeof(child));
+	for (count = 0, f = 0; f < 8; f++) {
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
+		child[f].pcie_pos = pcie;
+		child[f].pcie_flags = flags;
+	}
+
+	if (!count)
+		return;
+
+	/* alloc space to save config */
+	size = sizeof(struct save_config);
+	save = (struct save_config *)alloc_bootmem(size*count);
+	if (save == NULL) {
+		printk(KERN_ERR "reset_pcie: alloc_bootmem failed\n");
+		return;
+	}
+
+	/* save */
+	pos = save;
+	for (f = 0; f < 8; f++) {
+		if (child[f].pcie_pos) {
+			child[f].save = pos++;
+			save_state(secondary, 0, f, &child[f]);
+		}
+	}
+
+	do_reset(bus, slot, func);
+
+	/* restore */
+	for (f = 0; f < 8; f++)
+		if (child[f].pcie_pos)
+			restore_state(secondary, 0, f, &child[f]);
+
+	free_bootmem(__pa(save), size*count);
+}
+
+void __init early_reset_pcie_devices(void)
+{
+	unsigned bus, slot, func;
+
+	if (!early_pci_allowed() || !reset_devices)
+		return;
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u16 vendor;
+				u8 type;
+				vendor = read_pci_config_16(bus, slot, func,
+						PCI_VENDOR_ID);
+
+				if (vendor == 0xffff)
+					continue;
+
+				reset_pcie_device(bus, slot, func);
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
+}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ab4bf5a..a7a4125 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -852,24 +852,6 @@ pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
 
 EXPORT_SYMBOL(pci_choose_state);
 
-#define PCI_EXP_SAVE_REGS	7
-
-#define pcie_cap_has_devctl(type, flags)	1
-#define pcie_cap_has_lnkctl(type, flags)		\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
-		  type == PCI_EXP_TYPE_ENDPOINT ||	\
-		  type == PCI_EXP_TYPE_LEG_END))
-#define pcie_cap_has_sltctl(type, flags)		\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 ((type == PCI_EXP_TYPE_ROOT_PORT) ||	\
-		  (type == PCI_EXP_TYPE_DOWNSTREAM &&	\
-		   (flags & PCI_EXP_FLAGS_SLOT))))
-#define pcie_cap_has_rtctl(type, flags)			\
-		((flags & PCI_EXP_FLAGS_VERS) > 1 ||	\
-		 (type == PCI_EXP_TYPE_ROOT_PORT ||	\
-		  type == PCI_EXP_TYPE_RC_EC))
-
 static struct pci_cap_saved_state *pci_find_saved_cap(
 	struct pci_dev *pci_dev, char cap)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..8e10401 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1790,5 +1790,23 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
  */
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
 
+#define PCI_EXP_SAVE_REGS	7
+
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
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/init/main.c b/init/main.c
index b286730..ebaf067 100644
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

