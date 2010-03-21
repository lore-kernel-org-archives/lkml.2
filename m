Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0CUHRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:17:51 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:45401 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0CUHQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:16:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/20] x86/pci: ioh new version read all at same time
Date: Sun, 21 Mar 2010 00:13:20 -0700
Message-Id: <1269155601-18247-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA5C78B.0179,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also it will add back default range to legacy IOH

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci_x86.h |    5 +
 arch/x86/pci/Makefile          |    1 +
 arch/x86/pci/init.c            |    2 +
 arch/x86/pci/intel_bus.c       |  281 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/pci/intel_bus.c

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 8d8797e..e52c02a 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -107,6 +107,11 @@ extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
 extern void __init dmi_check_pciprobe(void);
 extern void __init dmi_check_skip_isa_align(void);
+#ifdef CONFIG_PCI_MMCONFIG
+int intel_postarch_init(void);
+#else
+static inline int intel_postarch_init(void) { return 0; }
+#endif
 
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index b110d97..08e76bc 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o bus_numa.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= intel_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index adb62aa..08d5dcf 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -39,6 +39,8 @@ static __init int pci_arch_init(void)
 
 	dmi_check_skip_isa_align();
 
+	intel_postarch_init();
+
 	return 0;
 }
 arch_initcall(pci_arch_init);
diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
new file mode 100644
index 0000000..190c2c5
--- /dev/null
+++ b/arch/x86/pci/intel_bus.c
@@ -0,0 +1,281 @@
+/*
+ * to read io range from IOH pci conf, need to do it after mmconfig is there
+ */
+
+#include <linux/delay.h>
+#include <linux/dmi.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/range.h>
+
+#include <asm/pci_x86.h>
+
+#include "bus_numa.h"
+
+static inline void print_ioh_resources(struct pci_root_info *info)
+{
+	int res_num;
+	int busnum;
+	int i;
+
+	printk(KERN_DEBUG "IOH bus: [%02x, %02x]\n",
+			info->bus_min, info->bus_max);
+	res_num = info->res_num;
+	busnum = info->bus_min;
+	for (i = 0; i < res_num; i++) {
+		struct resource *res;
+
+		res = &info->res[i];
+		printk(KERN_DEBUG "IOH bus: %02x index %x %pR\n",
+				busnum, i, res);
+	}
+}
+
+static void __devinit subtract_mmconf(struct range *range, int nr)
+{
+	struct pci_mmcfg_region *cfg;
+
+	if (list_empty(&pci_mmcfg_list))
+		return;
+
+	list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		subtract_range(range, nr, cfg->res.start, cfg->res.end + 1);
+}
+
+#define IOH_LIO			0x108
+#define IOH_LMMIOL		0x10c
+#define IOH_LMMIOH		0x110
+#define IOH_LMMIOH_BASEU	0x114
+#define IOH_LMMIOH_LIMITU	0x118
+#define IOH_LCFGBUS		0x11c
+
+#define IOH_VTBAR		0x180
+#define IOH_VTSIZE		0x2000  /* Fixed HW size (not programmable) */
+
+#define RANGE_NUM		16
+
+#define RANGE_IO_NUM		16
+#define RANGE_MMIO_NUM		32
+static struct range range_io[RANGE_IO_NUM] __initdata;
+static struct range range_mmio[RANGE_MMIO_NUM] __initdata;
+static int def_ioh __initdata = -1;
+
+static void __init check_ioh_tom(int num, int slot, int func)
+{
+	u32 dword;
+	u64 tocm, tolm, tohm;
+
+	raw_pci_read(0, num, (slot<<3)|func, 0x98, 4, &dword);
+	/* is Legacy IOH with ESI? */
+	if ((dword & (3<<10)) == 0) {
+		if (def_ioh < 0)
+			def_ioh = pci_root_num;
+		else
+			printk(KERN_DEBUG "Multiple legacy IOHs ?\n");
+	}
+
+	/* top of address */
+	tocm = 1ULL<<(((dword >> 3) & 0x1f) + (37 - 5));
+	subtract_range(range_mmio, RANGE_MMIO_NUM, tocm, -1ULL);
+	/* private CSR 64G */
+	subtract_range(range_mmio, RANGE_MMIO_NUM, tocm - (64ULL<<30), tocm);
+	/* top of low mem */
+	raw_pci_read(0, num, (slot<<3)|func, 0xd0, 4, &dword);
+	tolm = dword & (0x3f<<26);
+	tolm += 1<<26;
+	subtract_range(range_mmio, RANGE_MMIO_NUM, 0, tolm);
+	/* top of high mem */
+	raw_pci_read(0, num, (slot<<3)|func, 0xd8, 4, &dword);
+	tohm = dword;
+	tohm <<= 32;
+	raw_pci_read(0, num, (slot<<3)|func, 0xd4, 4, &dword);
+	tohm |= dword & (0x3f<<26);
+	tohm += 1<<26;
+	subtract_range(range_mmio, RANGE_MMIO_NUM, 1ULL<<32, tohm);
+	printk(KERN_DEBUG "IOH bus 0x%02x tolm: 0x%llxM, tohm: 0x%llxM, tocm: 0x%llxM\n",
+			 num, tolm>>20, tohm>>20, tocm>>20);
+}
+
+static void __init read_ioh_res(int num, int slot, int func)
+{
+	u32 dword;
+	struct pci_root_info *info;
+	u16 io_base, io_end;
+	u32 mmiol_base, mmiol_end;
+	u64 mmioh_base, mmioh_end;
+	int bus_base, bus_end;
+	struct range range[RANGE_NUM];
+	int i;
+
+
+	if (pci_root_num >= PCI_ROOT_NR) {
+		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
+		return;
+	}
+
+	check_ioh_tom(num, slot, func);
+
+	info = &pci_root_info[pci_root_num];
+	pci_root_num++;
+
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LCFGBUS, 2, &dword);
+	bus_base = (dword & 0xff);
+	bus_end = (dword & 0xff00) >> 8;
+	sprintf(info->name, "PCI Bus #%02x", bus_base);
+	info->bus_min = bus_base;
+	info->bus_max = bus_end;
+
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LIO, 2, &dword);
+	io_base = (dword & 0xf0) << (12 - 4);
+	io_end = (dword & 0xf000) | 0xfff;
+	update_res(info, io_base, io_end, IORESOURCE_IO, 0);
+	subtract_range(range_io, RANGE_IO_NUM, io_base, io_end + 1);
+
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LMMIOL, 4, &dword);
+	mmiol_base = (dword & 0xff00) << (24 - 8);
+	mmiol_end = (dword & 0xff000000) | 0xffffff;
+	subtract_range(range_mmio, RANGE_MMIO_NUM, mmiol_base, mmiol_end + 1);
+	memset(range, 0, sizeof(range));
+	add_range(range, RANGE_NUM, 0, mmiol_base, (u64)mmiol_end + 1);
+	raw_pci_read(0, num, (slot<<3)|func, IOH_VTBAR, 4, &dword);
+	if (dword & 0x1) {
+		u32 vt_base, vt_end;
+
+		vt_base = dword & 0xfffffffe;
+		vt_end = vt_base + IOH_VTSIZE - 1;
+
+		subtract_range(range, RANGE_NUM, vt_base, vt_end + 1);
+		subtract_range(range_mmio, RANGE_MMIO_NUM, vt_base, vt_end + 1);
+	}
+	for (i = 0; i < RANGE_NUM; i++) {
+		if (!range[i].end)
+			continue;
+
+		update_res(info, cap_resource(range[i].start),
+				cap_resource(range[i].end - 1),
+				IORESOURCE_MEM, 0);
+	}
+
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LMMIOH, 4, &dword);
+	mmioh_base = ((u64)(dword & 0xfc00)) << (26 - 10);
+	mmioh_end = ((u64)(dword & 0xfc000000) | 0x3ffffff);
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LMMIOH_BASEU, 4, &dword);
+	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
+	raw_pci_read(0, num, (slot<<3)|func, IOH_LMMIOH_LIMITU, 4, &dword);
+	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
+	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
+			 IORESOURCE_MEM, 0);
+	subtract_range(range_mmio, RANGE_MMIO_NUM, mmioh_base, mmioh_end + 1);
+
+	print_ioh_resources(info);
+}
+
+struct pci_check_probe {
+	u32 vendor;
+	u32 device;
+	void (*f)(int num, int slot, int func);
+};
+
+static struct pci_check_probe early_qrk[] __initdata = {
+	{ PCI_VENDOR_ID_INTEL, 0x342e, read_ioh_res }, /* intel IOH */
+	{}
+};
+
+static void __init postarch_check_pci_dev(int num, int slot, int func)
+{
+	u32 vendor;
+	u32 device;
+	int i;
+
+	raw_pci_read(0, num, (slot<<3)|func, PCI_VENDOR_ID, 2, &vendor);
+	raw_pci_read(0, num, (slot<<3)|func, PCI_DEVICE_ID, 2, &device);
+
+	for (i = 0; early_qrk[i].f != NULL; i++) {
+		if (((early_qrk[i].vendor == PCI_ANY_ID) ||
+			(early_qrk[i].vendor == vendor)) &&
+			((early_qrk[i].device == PCI_ANY_ID) ||
+			(early_qrk[i].device == device)))
+				early_qrk[i].f(num, slot, func);
+	}
+}
+
+static void __init postarch_check_pci_devs(void)
+{
+	unsigned bus, slot, func;
+	struct pci_root_info *info;
+	int i;
+
+	memset(range_io, 0, sizeof(range_io));
+	add_range(range_io, RANGE_IO_NUM, 0, 0, 0xffff + 1);
+
+	memset(range_mmio, 0, sizeof(range_mmio));
+	add_range(range_mmio, RANGE_MMIO_NUM, 0, 0, -1ULL);
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u32 class;
+				u32 type;
+
+				raw_pci_read(0, bus, (slot<<3)|func,
+						PCI_CLASS_REVISION, 4, &class);
+				if (class == 0xffffffff)
+					continue;
+
+				postarch_check_pci_dev(bus, slot, func);
+
+				if (func == 0) {
+					raw_pci_read(0, bus, (slot<<3)|func,
+					       PCI_HEADER_TYPE, 1, &type);
+					if (!(type & 0x80))
+						break;
+				}
+			}
+		}
+	}
+
+	if (def_ioh < 0)
+		return;
+
+	/* add default io */
+	info = &pci_root_info[def_ioh];
+	for (i = 0; i < RANGE_IO_NUM; i++) {
+		if (!range_io[i].end)
+			continue;
+
+		update_res(info, range_io[i].start, range_io[i].end - 1,
+			   IORESOURCE_IO, 0);
+	}
+
+	subtract_mmconf(range_mmio, RANGE_MMIO_NUM);
+
+	/* add default default mmio */
+	for (i = 0; i < RANGE_MMIO_NUM; i++) {
+		if (!range_mmio[i].end)
+			continue;
+
+		update_res(info, cap_resource(range_mmio[i].start),
+			   cap_resource(range_mmio[i].end - 1),
+			   IORESOURCE_MEM, 0);
+	}
+	printk(KERN_DEBUG "IOH Legacy final with default routing:\n");
+	print_ioh_resources(info);
+}
+
+/*
+ * need to call it just after pci_arch_init
+ * so we can have mmconf ready
+ */
+int __init intel_postarch_init(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	if (!pci_ext_cfg_avail(NULL))
+		return 0;
+
+	postarch_check_pci_devs();
+
+	return 0;
+}
+
-- 
1.6.4.2

