Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0KITyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:54:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62153 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0KITyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jA4NVXmfPpwcW2Yd/NlfvScK8x8+vPDAvm/5fP0nXehegdLonxddxWcrY7QpaKxfys
         bO29a6ecZTTecLjBJgP5/sTyow4xOIBr5cu8DAVu7uiprzmgma0Z+q5CMFywD1Dl5OAQ
         g2Zg6IbvwAWPQ+P6isz0Vto2AMk2eCbgB2KHg=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>, x86@kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 2/6] ce4100: add PCI register emulation for CE4100
Date: Tue,  9 Nov 2010 12:08:05 -0800
Message-Id: <40b6751381c2275dc359db5a17989cce22ad8db7.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289331834.git.dirk.brandewie@gmail.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

This patch access methods for PCI registers that mis-behave on
the CE4100. Each register can be assigned a private init, read and
write routine. The exception to this is the bridge device.  The
bridge device is the only device on bus zero (0) that requires any
fixup so it is a special case.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/pci/Makefile |    1 +
 arch/x86/pci/ce4100.c |  333 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 334 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/pci/ce4100.c

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index effd96e..6b8759f 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 obj-$(CONFIG_PCI_XEN)		+= xen.o
 
 obj-y				+= fixup.o
+obj-$(CONFIG_X86_INTEL_CE)      += ce4100.o
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-y				+= legacy.o irq.o
 
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
new file mode 100644
index 0000000..5801b15
--- /dev/null
+++ b/arch/x86/pci/ce4100.c
@@ -0,0 +1,333 @@
+/*
+ *  GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *  The full GNU General Public License is included in this distribution
+ *  in the file called LICENSE.GPL.
+ *
+ *  Contact Information:
+ *    Intel Corporation
+ *    2200 Mission College Blvd.
+ *    Santa Clara, CA  97052
+ *
+ */
+
+/*
+* This provides access methods for PCI registers that mis-behave on
+* the CE4100. Each register can be assigned a private init, read and
+* write routine. The exception to this is the bridge device.  The
+* bridge device is the only device on bus zero (0) that requires any
+* fixup so it is a special case ATM
+*/
+
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <asm/pci_x86.h>
+
+struct sim_reg {
+	u32 value;
+	u32 mask;
+};
+
+struct sim_dev_reg {
+	int dev_func;
+	int reg;
+	void (*init)(struct sim_dev_reg *reg);
+	void (*read)(struct sim_dev_reg *reg, u32 *value);
+	void (*write)(struct sim_dev_reg *reg, u32 value);
+	struct sim_reg sim_reg;
+};
+
+struct sim_reg_op {
+	void (*init)(struct sim_dev_reg *reg);
+	void (*read)(struct sim_dev_reg *reg, u32 value);
+	void (*write)(struct sim_dev_reg *reg, u32 value);
+};
+
+
+#define MB (1024 * 1024)
+#define KB (1024)
+#define SIZE_TO_MASK(size) (~(size - 1))
+
+#define DEFINE_REG(device, func, offset, size, init_op, read_op, write_op)\
+{ PCI_DEVFN(device, func), offset, init_op, read_op, write_op,\
+	{0, SIZE_TO_MASK(size)} },
+
+static void reg_init(struct sim_dev_reg *reg)
+{
+	pci_direct_conf1.read(0, 1, reg->dev_func, reg->reg, 4,
+			&reg->sim_reg.value);
+}
+
+static void reg_read(struct sim_dev_reg *reg, u32 *value)
+{
+	unsigned long flags;
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	*value = reg->sim_reg.value;
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
+static void reg_write(struct sim_dev_reg *reg, u32 value)
+{
+	unsigned long flags;
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	reg->sim_reg.value = (value & reg->sim_reg.mask) |
+		(reg->sim_reg.value & ~reg->sim_reg.mask);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
+static void sata_reg_init(struct sim_dev_reg *reg)
+{
+	pci_direct_conf1.read(0, 1, PCI_DEVFN(14, 0), 0x10, 4,
+			&reg->sim_reg.value);
+	reg->sim_reg.value += 0x400;
+}
+
+static void ehci_reg_read(struct sim_dev_reg *reg, u32 *value)
+{
+	reg_read(reg, value);
+	if (*value != reg->sim_reg.mask)
+		*value |= 0x100;
+}
+
+void sata_revid_init(struct sim_dev_reg *reg)
+{
+	reg->sim_reg.value = 0x01060100;
+	reg->sim_reg.mask = 0;
+}
+
+static void sata_revid_read(struct sim_dev_reg *reg, u32 *value)
+{
+	reg_read(reg, value);
+}
+
+static struct sim_dev_reg bus1_fixups[] = {
+	DEFINE_REG(2, 0, 0x10, (16*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(2, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(2, 1, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(3, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(4, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(4, 1, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 0, 0x10, (512*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 1, 0x10, (512*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 2, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 0, 0x10, (1*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 1, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 2, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(9, 0, 0x10 , (1*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(9, 0, 0x14, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(10, 0, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(10, 0, 0x14, (256*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 0, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 1, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x18, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 3, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 3, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 4, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 5, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 6, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 7, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 1, 0x10, (1024), reg_init, reg_read, reg_write)
+	DEFINE_REG(13, 0, 0x10, (32*KB), reg_init, ehci_reg_read, reg_write)
+	DEFINE_REG(13, 1, 0x10, (32*KB), reg_init, ehci_reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x8,  0, sata_revid_init, sata_revid_read, 0)
+	DEFINE_REG(14, 0, 0x10, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x14, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x18, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x1C, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x20, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x24, (0x200), sata_reg_init, reg_read, reg_write)
+	DEFINE_REG(15, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(15, 0, 0x14, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x14, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x18, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(17, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(18, 0, 0x10, (1*KB), reg_init, reg_read, reg_write)
+};
+
+static const int num_bus1_fixups = sizeof(bus1_fixups) / sizeof(bus1_fixups[0]);
+
+static void init_sim_regs(void)
+{
+	int i;
+
+	for (i = 0; i < num_bus1_fixups; i++) {
+		if (bus1_fixups[i].init)
+			bus1_fixups[i].init(&bus1_fixups[i]);
+	}
+}
+
+
+static inline void extract_bytes(u32 *value, int reg, int len)
+{
+	uint32_t mask;
+
+	*value >>= ((reg & 3) * 8);
+	mask = 0xFFFFFFFF >> ((4 - len) * 8);
+	*value &= mask;
+}
+
+int bridge_read(unsigned int devfn, int reg, int len, u32 *value)
+{
+	int retval = 0;
+	u32 av_bridge_base, av_bridge_limit;
+
+	switch (reg) {
+	/* Make BARs appear to not request any memory. */
+	case PCI_BASE_ADDRESS_0:
+	case PCI_BASE_ADDRESS_0 + 1:
+	case PCI_BASE_ADDRESS_0 + 2:
+	case PCI_BASE_ADDRESS_0 + 3:
+		*value = 0;
+		break;
+
+		/* Since subordinate bus number register is hardwired
+		 * to zero and read only, so do the simulation.
+		 */
+	case PCI_PRIMARY_BUS:
+		if (len == 4)
+			*value = 0x00010100;
+		break;
+
+	case PCI_SUBORDINATE_BUS:
+		*value = 1;
+		break;
+
+	case PCI_MEMORY_BASE:
+	case PCI_MEMORY_LIMIT:
+		/* Get the A/V bridge base address. */
+		pci_direct_conf1.read(0, 0, devfn,
+				PCI_BASE_ADDRESS_0, 4, &av_bridge_base);
+
+		av_bridge_limit = av_bridge_base + (512*MB - 1);
+		av_bridge_limit >>= 16;
+		av_bridge_limit &= 0xFFF0;
+
+		av_bridge_base >>= 16;
+		av_bridge_base &= 0xFFF0;
+
+		if (reg == PCI_MEMORY_LIMIT)
+			*value = av_bridge_limit;
+		else if (len == 2)
+			*value = av_bridge_base;
+		else
+			*value = (av_bridge_limit << 16) | av_bridge_base;
+		break;
+		/* Make prefetchable memory limit smaller than prefetchable
+		 * memory base, so not claim prefetchable memory space.
+		 */
+	case PCI_PREF_MEMORY_BASE:
+		*value = 0xFFF0;
+		break;
+	case PCI_PREF_MEMORY_LIMIT:
+		*value = 0x0;
+		break;
+		/* Make IO limit smaller than IO base, so not claim IO space. */
+	case PCI_IO_BASE:
+		*value = 0xF0;
+		break;
+	case PCI_IO_LIMIT:
+		*value = 0;
+		break;
+	default:
+		retval = 1;
+	}
+	return retval;
+}
+
+
+
+
+static int ce4100_conf_read(unsigned int seg, unsigned int bus,
+			  unsigned int devfn, int reg, int len, u32 *value)
+{
+	int retval = 1;
+	int i;
+
+	if (bus == 0 && (PCI_DEVFN(1, 0) == devfn))
+		retval = bridge_read(devfn, reg, len, value);
+
+	if (bus == 1) {
+		for (i = 0; i < num_bus1_fixups; i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+				bus1_fixups[i].reg == (reg & ~3) &&
+				bus1_fixups[i].read) {
+				bus1_fixups[i].read(&(bus1_fixups[i]),
+					value);
+				extract_bytes(value, reg, len);
+				retval = 0;
+			}
+		}
+	}
+	if (retval)
+		retval = pci_direct_conf1.read(seg, bus, devfn, reg,
+					len, value);
+	return retval;
+}
+
+
+static int ce4100_conf_write(unsigned int seg, unsigned int bus,
+			   unsigned int devfn, int reg, int len, u32 value)
+{
+	int retval = 1;
+	int i;
+
+	if (bus == 1) {
+		for (i = 0; i < num_bus1_fixups; i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+				bus1_fixups[i].reg == (reg & ~3) &&
+				bus1_fixups[i].write) {
+				bus1_fixups[i].write(&(bus1_fixups[i]),
+					value);
+				retval = 0;
+			}
+		}
+	}
+
+	/* Discard writes to A/V bridge BAR. */
+	if (bus == 0 && PCI_DEVFN(1, 0) == devfn &&
+		((reg & ~3) == PCI_BASE_ADDRESS_0))
+		retval = 0;
+
+	if (retval)
+		retval = pci_direct_conf1.write(seg, bus, devfn, reg,
+						len, value);
+	return retval;
+}
+
+
+struct pci_raw_ops ce4100_pci_conf = {
+	.read =	ce4100_conf_read,
+	.write = ce4100_conf_write,
+};
+
+static int __init ce4100_pci_init(void)
+{
+	init_sim_regs();
+	raw_pci_ops = &ce4100_pci_conf;
+	return 0;
+}
+
+
+subsys_initcall(ce4100_pci_init);
-- 
1.7.2.3

