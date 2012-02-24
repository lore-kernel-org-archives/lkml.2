Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2BXPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:19:24 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:31050
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982Ab2BXPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:19:22 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZWL83-01-FF2-02
X-M-MSG: 
Date: Fri, 24 Feb 2012 16:19:12 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86/amd: Restore early_fill_mp_bus_to_node
Message-ID: <20120224151912.GA28921@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Once upon a time this function was overloaded with quirky stuff to fix
resource detection on systems w/ _CRS defects (seems that some Sun and
HP systems were affected).

See commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
(x86: multi pci root bus with different io resource range, on 64-bit)

Restore the old function and thus decouple it from the quirk that is
CPU family specific (e.g. it won't work on AMD family 15h CPUs). BTW,
I assume that the _CRS stuff is working on current systems.

This is required to properly initilize the numa_node information of
PCI busses and associated devices.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/pci/amd_bus.c |   84 +++++++++++++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 0567df3..0384e69 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -30,36 +30,19 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
 };
 
-#define RANGE_NUM 16
-
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
  * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
  * Registers found in the K8 northbridge
  */
-static int __init early_fill_mp_bus_info(void)
+static int __init early_fill_mp_bus_to_node(void)
 {
-	int i;
-	int j;
-	unsigned bus;
-	unsigned slot;
-	int node;
-	int link;
-	int def_node;
-	int def_link;
+	int i, j, node, link;
+	unsigned bus, slot;
 	struct pci_root_info *info;
 	u32 reg;
-	struct resource *res;
-	u64 start;
-	u64 end;
-	struct range range[RANGE_NUM];
-	u64 val;
-	u32 address;
 	bool found;
-	struct resource fam10h_mmconf_res, *fam10h_mmconf;
-	u64 fam10h_mmconf_start;
-	u64 fam10h_mmconf_end;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -67,8 +50,7 @@ static int __init early_fill_mp_bus_info(void)
 	found = false;
 	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
 		u32 id;
-		u16 device;
-		u16 vendor;
+		u16 device, vendor;
 
 		bus = pci_probes[i].bus;
 		slot = pci_probes[i].slot;
@@ -88,8 +70,7 @@ static int __init early_fill_mp_bus_info(void)
 
 	pci_root_num = 0;
 	for (i = 0; i < 4; i++) {
-		int min_bus;
-		int max_bus;
+		int min_bus, max_bus;
 		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
 
 		/* Check if that register is enabled for bus range */
@@ -111,9 +92,50 @@ static int __init early_fill_mp_bus_info(void)
 		info->node = node;
 		info->link = link;
 		sprintf(info->name, "PCI Bus #%02x", min_bus);
+		printk(KERN_DEBUG "bus: [%02x, %02x] on node %x link %x\n",
+		       info->bus_min, info->bus_max, info->node, info->link);
 		pci_root_num++;
 	}
 
+	return 0;
+}
+
+
+#define RANGE_NUM 16
+static int __init early_fill_mp_bus_info(void)
+{
+	int i, j, node, link, def_node, def_link;
+	unsigned bus, slot;
+	struct pci_root_info *info;
+	struct resource *res;
+	struct resource fam10h_mmconf_res, *fam10h_mmconf;
+	struct range range[RANGE_NUM];
+	u64 fam10h_mmconf_start, fam10h_mmconf_end;
+	u64 start, end, val;
+	u32 reg, address;
+	bool found;
+
+	found = false;
+	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+		u32 id;
+		u16 device, vendor;
+
+		bus = pci_probes[i].bus;
+		slot = pci_probes[i].slot;
+		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+
+		vendor = id & 0xffff;
+		device = (id>>16) & 0xffff;
+		if (pci_probes[i].vendor == vendor &&
+		    pci_probes[i].device == device) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return 0;
+
 	/* get the default node and link for left over res */
 	reg = read_pci_config(bus, slot, 0, 0x60);
 	def_node = (reg >> 8) & 0x07;
@@ -310,14 +332,11 @@ static int __init early_fill_mp_bus_info(void)
 	}
 
 	for (i = 0; i < pci_root_num; i++) {
-		int res_num;
-		int busnum;
+		int res_num, busnum;
 
 		info = &pci_root_info[i];
 		res_num = info->res_num;
 		busnum = info->bus_min;
-		printk(KERN_DEBUG "bus: [%02x, %02x] on node %x link %x\n",
-		       info->bus_min, info->bus_max, info->node, info->link);
 		for (j = 0; j < res_num; j++) {
 			res = &info->res[j];
 			printk(KERN_DEBUG "bus: %02x index %x %pR\n",
@@ -412,7 +431,14 @@ static int __init amd_postcore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	early_fill_mp_bus_info();
+	if ((early_fill_mp_bus_to_node() == 0) &&
+	    (boot_cpu_data.x86 < 0x11)) {
+		/*
+		 * call this only on older systems w/o _CRS for "multi
+		 * pci root bus"
+		 */
+		early_fill_mp_bus_info();
+	}
 	pci_io_ecs_init();
 
 	return 0;
-- 
1.7.8.4


