Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0DILAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:00:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60724 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927Ab0DILAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:00:39 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] IPC driver for Intel Mobile Internet Device (MID) platforms
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Fri, 09 Apr 2010 11:29:23 +0100
Message-ID: <20100409102629.22832.30883.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to get this into the tree in some form as a pile of the
driver stuff pending from Intel depends upon it. It's currently slotted into
arch/x86 as the IPC interface is very much part of the hardware, so don't
be fooled by its apparent PCI interface.

--

From: Sreedhara DS <sreedhara.ds@intel.com>

The IPC is used to bridge the communications between kernel and SCU on
some embedded Intel x86 platforms.

(Some API tweaking Alan Cox)

Signed-off-by: Sreedhara DS <sreedhara.ds@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                     |    8 
 arch/x86/include/asm/intel_scu_ipc.h |   93 ++++
 arch/x86/kernel/Makefile             |    1 
 arch/x86/kernel/intel_scu_ipc.c      |  882 ++++++++++++++++++++++++++++++++++
 4 files changed, 984 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_scu_ipc.h
 create mode 100644 arch/x86/kernel/intel_scu_ipc.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e9d7bf7..f423aea 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -410,6 +410,14 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+config INTEL_SCU_IPC
+       bool "Intel SCU IPC Support"
+	depends on X86_MRST
+	default y
+	---help---
+	 IPC is used to bridge the communications between kernel and SCU on
+	 some embedded Intel x86 platforms.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
diff --git a/arch/x86/include/asm/intel_scu_ipc.h b/arch/x86/include/asm/intel_scu_ipc.h
new file mode 100644
index 0000000..0d96dda
--- /dev/null
+++ b/arch/x86/include/asm/intel_scu_ipc.h
@@ -0,0 +1,93 @@
+#ifndef __INTEL_SCU_IPC_H__
+#define  __INTEL_SCU_IPC_H__
+
+struct scu_fw_version {
+	u8 rtMinorVer;		/* SCU RT Firmware Minor Revision */
+	u8 rtMajorVer;		/* SCU RT Firmware Major Revision */
+	u8 romMinorVer;		/* SCU ROM Firmware Minor Revision */
+	u8 romMajorVer;		/* SCU ROM Firmware Major Revision */
+	u8 punitMinorVer;	/* P-unit Microcode Minor Revision */
+	u8 punitMajorVer;	/* P-unit Microcode Major Revision */
+	u8 iaMinorVer;		/* IA-32 Firmware Minor Revision */
+	u8 iaMajorVer;		/* IA-32 Firmware Major Revision */
+	u8 ftlMinorVer;		/* FTL Driver Minor Revision */
+	u8 ftlMajorVer;		/* FTL Driver Major Revision */
+	u8 valMinorVer;		/* Validation Hooks Minor Revision */
+	u8 valMajorVer;		/* Validation Hooks Major Revision */
+	u8 ifwiMinorVer;	/* IFWI Minor Revision */
+	u8 ifwiMajorVer;	/* IFWI Major Revision */
+} ;
+
+struct battery_property {
+	u32 capacity;	/* Charger capacity */
+	u8  crnt;	/* Quick charge current value*/
+	u8  volt;	/* Fine adjustment of constant charge voltage */
+	u8  prot;	/* CHRGPROT register value */
+	u8  prot2;	/* CHRGPROT1 register value */
+	u8 timer;	/* Charging timer */
+} __attribute__((packed));
+
+/* Read single register */
+int intel_scu_ipc_ioread8(u16 addr, u8 *data);
+
+/* Read two registers */
+int intel_scu_ipc_ioread16(u16 addr, u16 *data);
+
+/* Read four registers */
+int intel_scu_ipc_ioread32(u16 addr, u32 *data);
+
+/* Write single register */
+int intel_scu_ipc_iowrite8(u16 addr, u8 data);
+
+/* Write two registers */
+int intel_scu_ipc_iowrite16(u16 addr, u16 data);
+
+/* Write four registers */
+int intel_scu_ipc_iowrite32(u16 addr, u32 data);
+
+/*
+ * Update single register based on the mask
+ * First element of data is register value and second element is mask value
+ */
+int intel_scu_ipc_update_register(u16 addr, u8 data[2]);
+
+/*
+ * Indirect register read
+ * Can be used when SCCB(System Controller Configuration Block) register
+ * HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ */
+int intel_scu_ipc_register_read(u32 addr, u32 *data);
+
+/*
+ * Indirect register write
+ * Can be used when SCCB(System Controller Configuration Block) register
+ * HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ */
+int intel_scu_ipc_register_write(u32 addr, u32 data);
+
+/* Read the coulomb counter accumulator to monitor the battery charge level */
+int intel_scu_ipc_battery_cc_read(u32 *value);
+
+/* Write the coulomb counter accumulator */
+int intel_scu_ipc_battery_cc_write(u32 value);
+
+/* Read battery properties */
+int intel_scu_ipc_battery_property(struct battery_property *prop);
+
+/*
+ * Used to enable Timer Services for Kernel Watchdog Operation permitting
+ * automatic reset or reboot of the system if tripped.
+ * Set watchdog timer value, returns 0 on success, 1 on error
+ */
+int intel_scu_ipc_set_watchdog(u32 warn_threshold, u32 reset_threshold);
+
+/* I2C control api */
+int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data);
+
+/* Read FW version */
+int intel_scu_ipc_fw_version(struct scu_fw_version *version);
+
+/* Update FW version */
+int intel_scu_ipc_fw_update(u8 *buffer, u32 length);
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c58352..7aecd44 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -107,6 +107,7 @@ scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
diff --git a/arch/x86/kernel/intel_scu_ipc.c b/arch/x86/kernel/intel_scu_ipc.c
new file mode 100644
index 0000000..258a88a
--- /dev/null
+++ b/arch/x86/kernel/intel_scu_ipc.c
@@ -0,0 +1,882 @@
+/*
+ * intel_scu_ipc.c: Driver for the Intel SCU IPC mechanism
+ *
+ * (C) Copyright 2008-2010 Intel Corporation
+ * Author: Sreedhara DS (sreedhara.ds@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * SCU runing in ARC processor communicates with other entity running in IA
+ * core through IPC mechanism which in turn messaging between IA core ad SCU.
+ * SCU has two IPC mechanism IPC-1 and IPC-2. IPC-1 is used between IA32 and
+ * SCU where IPC-2 is used between P-Unit and SCU. This driver delas with
+ * IPC-1 Driver provides an API for power control unit registers (e.g. MSIC)
+ * along with other APIs.
+ */
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/sysdev.h>
+#include <linux/pm.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <asm/setup.h>
+#include <asm/intel_scu_ipc.h>
+
+/* IPC defines the following message types */
+#define IPCMSG_WATCHDOG_TIMER 0xF8 /* Set Kernel Watchdog Threshold */
+#define IPCMSG_BATTERY        0xEF /* Coulomb Counter Accumulator */
+#define IPCMSG_FW_UPDATE      0xFE /* Firmware update */
+#define IPCMSG_PCNTRL         0xFF /* Power controller unit read/write */
+#define IPCMSG_FW_REVISION    0xF4 /* Get firmware revision */
+
+/* Command id associated with message IPCMSG_PCNTRL */
+#define IPC_CMD_PCNTRL_W      0 /* Register write */
+#define IPC_CMD_PCNTRL_R      1 /* Register read */
+#define IPC_CMD_PCNTRL_M      2 /* Register read-modify-write */
+
+/* Miscelaneous Command ids */
+#define IPC_CMD_INDIRECT_RD   2 /* 32bit indirect read */
+#define IPC_CMD_INDIRECT_WR   5 /* 32bit indirect write */
+
+/*
+ * IPC register summary
+ *
+ * IPC register blocks are memory mapped at fixed address of 0xFF11C000
+ * To read or write information to the SCU, driver writes to IPC-1 memory
+ * mapped registers (base address 0xFF11C000). The following is the IPC
+ * mechanism
+ *
+ * 1. IA core cDMI interface claims this transaction and converts it to a
+ *    Transaction Layer Packet (TLP) message which is sent across the cDMI.
+ *
+ * 2. South Complex cDMI block receives this message and writes it to
+ *    the IPC-1 register block, causing an interrupt to the SCU
+ *
+ * 3. SCU firmware decodes this interrupt and IPC message and the appropriate
+ *    message handler is called within firmware.
+ */
+
+#define IPC_BASE_ADDR     0xFF11C000	/* IPC1 base register address */
+#define IPC_MAX_ADDR      0x100		/* Maximum IPC regisers */
+#define IPC_WWBUF_SIZE    16		/* IPC Write buffer Size */
+#define IPC_RWBUF_SIZE    16		/* IPC Read buffer Size */
+#define IPC_I2C_BASE      0xFF12B000	/* I2C control register base address */
+#define IPC_I2C_MAX_ADDR  0x10		/* Maximum I2C regisers */
+
+static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id);
+static void ipc_remove(struct pci_dev *pdev);
+
+struct intel_scu_ipc_dev {
+	struct pci_dev *pdev;
+	void __iomem *ipc_base;
+	void __iomem *i2c_base;
+	void __iomem *pci_base;
+};
+
+static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */
+
+static int platform = 1;
+module_param(platform, int, 0);
+MODULE_PARM_DESC(platform, "1 for moorestown platform");
+
+/*
+ * Command Register (Write Only):
+ * A write to this register results in an interrupt to the SCU core processor
+ * Format:
+ * |rfu2(8) | size(8) | command id(4) | rfu1(3) | ioc(1) | command(8)|
+ */
+#define IPC_COMMAND_REG		ipcdev.ipc_base
+
+/*
+ * Status Register (Read Only):
+ * Driver will read this register to get the ready/busy status of the IPC
+ * block and error status of the IPC command that was just processed by SCU
+ * Format:
+ * |rfu3(8)|error code(8)|initiator id(8)|cmd id(4)|rfu1(2)|error(1)|busy(1)|
+ */
+#define IPC_STATUS_REG		(ipcdev.ipc_base + 0x04)
+
+/*
+ * IPC Source Pointer (Write Only):
+ * Use content as pointer for read location
+*/
+#define IPC_SPTR_REG		(ipcdev.ipc_base + 0x08)
+
+/*
+ * IPC destination Pointer (Write Only):
+ * Use content as pointer for destination write
+*/
+#define IPC_DPTR_REG		(ipcdev.ipc_base + 0x0C)
+
+/*
+ * IPC Write Buffer (Write Only):
+ * 16-byte buffer for sending data associated with IPC command to
+ * SCU. Size of the data is specified in the IPC_COMMAND_REG register
+*/
+#define IPC_WRITE_BUFFER	(ipcdev.ipc_base + 0x80)
+
+/*
+ * IPC Read Buffer (Read Only):
+ * 16 byte buffer for receiving data from SCU, if IPC command
+ * processing results in response data
+*/
+#define IPC_READ_BUFFER		(ipcdev.ipc_base + 0x90)
+
+#define IPC_I2C_CNTRL_ADDR	ipcdev.i2c_base
+#define I2C_DATA_ADDR		(ipcdev.i2c_base + 0x04)
+
+static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU */
+
+static inline void ipc_command(u32 cmd) /* Send ipc command */
+{
+	writel(cmd, IPC_COMMAND_REG);
+}
+
+static inline void ipc_write(u32 data, u32 offset) /* Write ipc data */
+{
+	writel(data, IPC_WRITE_BUFFER + offset);
+}
+
+static inline void ipc_write_dptr(u32 data) /* Write dptr data */
+{
+	writel(data, IPC_DPTR_REG);
+}
+
+static inline void ipc_write_sptr(u32 data) /* Write dptr data */
+{
+	writel(data, IPC_SPTR_REG);
+}
+
+static inline u8 ipc_readb(u32 offset) /* Read ipc byte data */
+{
+	return readb(IPC_READ_BUFFER + offset);
+}
+
+static inline u8 ipc_readl(u32 offset) /* Read ipc u32 data */
+{
+	return readl(IPC_READ_BUFFER + offset);
+}
+
+static inline int busy_loop(void) /* Wait till scu status is busy */
+{
+	u32 status = 0;
+	u32 loop_count = 0;
+
+	status = __raw_readl(IPC_STATUS_REG);
+	while (status & 1) {
+		udelay(1); /* scu processing time is in few u secods */
+		status = __raw_readl(IPC_STATUS_REG);
+		loop_count++;
+		/* break if scu doesn't reset busy bit after huge retry */
+		if (loop_count > 100000)
+			return -ETIMEDOUT;
+	}
+	return (status >> 1) & 1;
+}
+
+/* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
+static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
+{
+	int nc;
+	u32 offset = 0;
+	u32 err = 0;
+	u8 cbuf[IPC_WWBUF_SIZE] = { '\0' };
+	u32 *wbuf = (u32 *)&cbuf;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+
+	if (platform == 1) {
+		/* Entry is 4 bytes for read/write, 5 bytes for read modify */
+		for (nc = 0; nc < count; nc++) {
+			cbuf[offset] = addr[nc];
+			cbuf[offset + 1] = addr[nc] >> 8;
+			if (id != IPC_CMD_PCNTRL_R)
+				cbuf[offset + 2] = data[nc];
+			if (id == IPC_CMD_PCNTRL_M) {
+				cbuf[offset + 3] = data[nc + 1];
+				offset += 1;
+			}
+			offset += 3;
+		}
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
+			ipc_write(wbuf[nc], offset); /* Write wbuff */
+
+	} else {
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 2)
+			ipc_write(addr[nc], offset); /* Write addresses */
+		if (id != IPC_CMD_PCNTRL_R) {
+			for (nc = 0; nc < count; nc++, offset++)
+				ipc_write(data[nc], offset); /* Write data */
+			if (id == IPC_CMD_PCNTRL_M)
+				ipc_write(data[nc + 1], offset); /* Mask value*/
+		}
+	}
+
+	if (id != IPC_CMD_PCNTRL_M)
+		ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
+	else
+		ipc_command((count*4) << 16 |  id << 12 | 0 << 8 | op);
+
+	err = busy_loop();
+
+	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
+		/* Workaround: values are read as 0 without memcpy_fromio */
+		memcpy_fromio(cbuf, IPC_READ_BUFFER, 16);
+		if (platform == 1) {
+			for (nc = 0, offset = 2; nc < count; nc++, offset += 3)
+				data[nc] = ipc_readb(offset);
+		} else {
+			for (nc = 0; nc < count; nc++)
+				data[nc] = ipc_readb(nc);
+		}
+	}
+	mutex_unlock(&ipclock);
+	return err;
+}
+
+/**
+ *	intel_scu_ipc_ioread8		-	read a word via the SCU
+ *	@addr: register on SCU
+ *	@data: return pointer for read byte
+ *
+ *	Read a single register. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_ioread8(u16 addr, u8 *data)
+{
+	return pwr_reg_rdwr(&addr, data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R);
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread8);
+
+/**
+ *	intel_scu_ipc_ioread16		-	read a word via the SCU
+ *	@addr: register on SCU
+ *	@data: return pointer for read word
+ *
+ *	Read a register pair. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_ioread16(u16 addr, u16 *data)
+{
+	u16 x[2] = {addr, addr + 1 };
+	return pwr_reg_rdwr(x, (u8 *)data, 2, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R);
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread16);
+
+/**
+ *	intel_scu_ipc_ioread32		-	read a dword via the SCU
+ *	@addr: register on SCU
+ *	@data: return pointer for read dword
+ *
+ *	Read four registers. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_ioread32(u16 addr, u32 *data)
+{
+	u16 x[4] = {addr, addr + 1, addr + 2, addr + 3};
+	return pwr_reg_rdwr(x, (u8 *)data, 4, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R);
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread32);
+
+/**
+ *	intel_scu_ipc_iowrite8		-	write a byte via the SCU
+ *	@addr: register on SCU
+ *	@data: byte to write
+ *
+ *	Write a single register. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_iowrite8(u16 addr, u8 data)
+{
+	return pwr_reg_rdwr(&addr, &data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W);
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite8);
+
+/**
+ *	intel_scu_ipc_iowrite16		-	write a word via the SCU
+ *	@addr: register on SCU
+ *	@data: word to write
+ *
+ *	Write two registers. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_iowrite16(u16 addr, u16 data)
+{
+	u16 x[2] = {addr, addr + 1 };
+	return pwr_reg_rdwr(x, (u8 *)&data, 2, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W);
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite16);
+
+/**
+ *	intel_scu_ipc_iowrite32		-	write a dword via the SCU
+ *	@addr: register on SCU
+ *	@data: dword to write
+ *
+ *	Write four registers. Returns 0 on success or an error code. All
+ *	locking between SCU accesses is handled for the caller.
+ *
+ *	This function may sleep.
+ */
+int intel_scu_ipc_iowrite32(u16 addr, u32 data)
+{
+	u16 x[4] = {addr, addr + 1, addr + 2, addr + 3};
+	return pwr_reg_rdwr(x, (u8 *)&data, 4, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W);
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite32);
+
+/**
+ *	intel_scu_ipc_update_register	-	r/m/w a register
+ *	@addr: register address
+ *	@data: bits to update and mask
+ *
+ *	Read-modify-write power control unit register. The first byte of the
+ *	data argument must be register value and second is mask value
+ *	mask is a bitmap that indicates which bits to update.
+ *	0 = masked. Don't modify this bit, 1 = modify this bit.
+ *	returns 0 on success or an error code.
+ *
+ *	This function may sleep. Locking between SCU accesses is handled
+ *	for the caller.
+ */
+int intel_scu_ipc_update_register(u16 addr, u8 data[2])
+{
+	return pwr_reg_rdwr(&addr, data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_M);
+}
+EXPORT_SYMBOL(intel_scu_ipc_update_register);
+
+/**
+ *	intel_scu_ipc_register_read	-	32bit indirect read
+ *	@addr: register address
+ *	@value: 32bit value return
+ *
+ *	Performs IA 32 bit indirect read, returns 0 on success, or an
+ *	error code.
+ *
+ *	Can be used when SCCB(System Controller Configuration Block) register
+ *	HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_register_read(u32 addr, u32 *value)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_write_sptr(addr);
+	ipc_command(4 << 16 | IPC_CMD_INDIRECT_RD);
+	err = busy_loop();
+	*value = ipc_readl(0);
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_register_read);
+
+/**
+ *	intel_scu_ipc_register_write	-	32bit indirect write
+ *	@addr: register address
+ *	@value: 32bit value to write
+ *
+ *	Performs IA 32 bit indirect write, returns 0 on success, or an
+ *	error code.
+ *
+ *	Can be used when SCCB(System Controller Configuration Block) register
+ *	HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_register_write(u32 addr, u32 value)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_write_dptr(addr);
+	ipc_write(value, 0);
+	ipc_command(4 << 16 | IPC_CMD_INDIRECT_WR);
+	err = busy_loop();
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_register_write);
+
+/* Battery coulomb counter accumulator commands */
+#define IPC_CMD_CC_WR  0 /* Update coulomb counter value */
+#define IPC_CMD_CC_RD  1 /* Read coulomb counter value */
+#define IPC_CMD_BATTERY_PROPERTY 2 /* Read Battery property */
+
+/**
+ *	intel_scu_ipc_battery_cc_read	-	read battery cc
+ *	@value: battery coulomb counter read
+ *
+ *	Reads the battery couloumb counter value, returns 0 on success, or
+ *	an error code
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_battery_cc_read(u32 *value)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_command(IPC_CMD_CC_RD << 12 | IPCMSG_BATTERY);
+	err = busy_loop();
+	*value = ipc_readl(0);
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_cc_read);
+
+/**
+ *	intel_scu_ipc_battery_property_get	-	fetch properties
+ *	@prop: battery properties
+ *
+ *	Retrieve the battery properties from the power management
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_battery_cc_write(u32 data)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_write(data, 0);
+	ipc_command(IPC_CMD_CC_WR << 12 | IPCMSG_BATTERY);
+	err = busy_loop();
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_cc_write);
+
+/**
+ *	intel_scu_ipc_battery_property_get	-	fetch properties
+ *	@prop: battery properties
+ *
+ *	Retrieve the battery properties from the power management
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_battery_property_get(struct battery_property *prop)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_command(IPC_CMD_BATTERY_PROPERTY << 12 | IPCMSG_BATTERY);
+	err = busy_loop();
+	prop->capacity = ipc_readb(0);
+	prop->crnt = ipc_readb(4);
+	prop->volt = ipc_readb(5);
+	prop->prot = ipc_readb(6);
+	prop->prot2 = ipc_readb(7);
+	prop->timer = ipc_readb(8);
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_property_get);
+
+/**
+ *	intel_scu_ipc_set_watchdog	-	watchdog configuration
+ *	@warn_threshold - warning timeout
+ *	@reset_threshold - reset timeout
+ *
+ *	Used to enable Timer Services for Kernel Watchdog Operation permitting
+ *	automatic reset or reboot of the system if tripped.
+ *	Set watchdog timer value, returns 0 on success, 1 on error
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_set_watchdog(u32 warn_threshold, u32 reset_threshold)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_write(warn_threshold, 0);
+	ipc_write(reset_threshold, 4);
+	ipc_command(2 << 16 | IPCMSG_WATCHDOG_TIMER);
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_set_watchdog);
+
+/**
+ *	intel_scu_ipc_fw_version	-	firmware information
+ *	@version: retrieved firmware version information
+ *
+ *	Read the firmware information from the SCU.
+ *
+ *	This function may sleep. Locking for SCU accesses is handled for
+ *	the caller.
+ */
+int intel_scu_ipc_fw_version(struct scu_fw_version *version)
+{
+	u32 err = 0;
+
+	mutex_lock(&ipclock);
+	if (ipcdev.pdev == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENODEV;
+	}
+	ipc_command(IPCMSG_FW_REVISION);
+	err = busy_loop();
+	version->rtMinorVer = ipc_readb(0);
+	version->rtMajorVer = ipc_readb(1);
+	version->romMinorVer = ipc_readb(2);
+	version->romMajorVer = ipc_readb(3);
+	version->punitMinorVer = ipc_readb(4);
+	version->punitMajorVer = ipc_readb(5);
+	version->iaMinorVer = ipc_readb(6);
+	version->iaMajorVer = ipc_readb(7);
+	version->ftlMinorVer = ipc_readb(8);
+	version->ftlMajorVer = ipc_readb(9);
+	version->valMinorVer = ipc_readb(10);
+	version->valMajorVer = ipc_readb(11);
+	/* Bytes 12 and 13 are unused */
+	version->ifwiMinorVer = ipc_readb(14);
+	version->ifwiMajorVer = ipc_readb(15);
+	mutex_unlock(&ipclock);
+	return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_fw_version);
+
+/*I2C commands */
+#define IPC_I2C_WRITE 1 /* I2C Write command */
+#define IPC_I2C_READ  2 /* I2C Read command */
+
+/**
+ *	intel_scu_ipc_i2c_cntrl		-	I2C read/write operations
+ *	@addr: I2C address + command bits
+ *	@data: data to read/write
+ *
+ *	Perform an an I2C read/write operation via the SCU. All locking is
+ *	handled for the caller. This function may sleep.
+ *
+ *	Returns an error code or 0 on success.
+ */
+int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data)
+{
+	u32 cmd = 0;
+
+	mutex_lock(&ipclock);
+	cmd = (addr >> 24) & 0xFF;
+	if (cmd == IPC_I2C_READ) {
+		writel(addr, IPC_I2C_CNTRL_ADDR);
+		mdelay(1);/*Write Not getting updated without delay*/
+		*data = readl(I2C_DATA_ADDR);
+	} else if (cmd == IPC_I2C_WRITE) {
+		writel(addr, I2C_DATA_ADDR);
+		mdelay(1);
+		writel(addr, IPC_I2C_CNTRL_ADDR);
+	} else {
+		dev_err(&ipcdev.pdev->dev,
+			"intel_scu_ipc: I2C INVALID_CMD = 0x%x\n", cmd);
+
+		mutex_unlock(&ipclock);
+		return -1;
+	}
+	mutex_unlock(&ipclock);
+	return 0;
+}
+EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
+
+#define IPC_FW_LOAD_ADDR 0xFFFC0000 /* Storage location for FW image */
+#define IPC_FW_UPDATE_MBOX_ADDR 0xFFFFDFF4 /* Mailbox between ipc and scu */
+#define IPC_MAX_FW_SIZE 262144 /* 256K storage size for loading the FW image */
+#define IPC_FW_MIP_HEADER_SIZE 2048 /* Firmware MIP header size */
+/* IPC inform SCU to get ready for update process */
+#define IPC_CMD_FW_UPDATE_READY  0x10FE
+/* IPC inform SCU to go for update process */
+#define IPC_CMD_FW_UPDATE_GO     0x20FE
+/* Status code for fw update */
+#define IPC_FW_UPDATE_SUCCESS	0x444f4e45 /* Status code 'DONE' */
+#define IPC_FW_UPDATE_BADN	0x4241444E /* Status code 'BADN' */
+#define IPC_FW_TXHIGH		0x54784849 /* Status code 'IPC_FW_TXHIGH' */
+#define IPC_FW_TXLOW		0x54784c4f /* Status code 'IPC_FW_TXLOW' */
+
+struct fw_update_mailbox {
+	u32    status;
+	u32    scu_flag;
+	u32    driver_flag;
+};
+
+
+/**
+ *	intel_scu_ipc_fw_update	-	 Firmware update utility
+ *	@buffer: firmware buffer
+ *	@length: size of firmware buffer
+ *
+ *	This function provides an interface to load the firmware into
+ *	the SCU. Returns 0 on success or -1 on failure
+ */
+int intel_scu_ipc_fw_update(u8 *buffer, u32 length)
+{
+	void __iomem *fw_update_base;
+	void __iomem *mailbox_base;
+	int retry_cnt = 0;
+
+	struct fw_update_mailbox *mailbox = NULL;
+
+	mutex_lock(&ipclock);
+	fw_update_base = ioremap_nocache(IPC_FW_LOAD_ADDR, (128*1024));
+	if (fw_update_base == NULL) {
+		mutex_unlock(&ipclock);
+		return -ENOMEM;
+	}
+	mailbox_base = ioremap_nocache(IPC_FW_UPDATE_MBOX_ADDR,
+					sizeof(struct fw_update_mailbox));
+	if (mailbox_base == NULL) {
+		iounmap(fw_update_base);
+		mutex_unlock(&ipclock);
+		return -ENOMEM;
+	}
+
+	mailbox = (struct fw_update_mailbox *)mailbox_base;
+
+	ipc_command(IPC_CMD_FW_UPDATE_READY);
+
+	/* Intitialize mailbox */
+	mailbox->status = 0;
+	mailbox->scu_flag = 0;
+	mailbox->driver_flag = 0;
+
+	/* Driver copies the 2KB MIP header to SRAM at 0xFFFC0000*/
+	memcpy_toio((u8 *)(fw_update_base), buffer, 0x800);
+
+	/* Driver sends "FW Update" IPC command (CMD_ID 0xFE; MSG_ID 0x02).
+	* Upon receiving this command, SCU will write the 2K MIP header
+	* from 0xFFFC0000 into NAND.
+	* SCU will write a status code into the Mailbox, and then set scu_flag.
+	*/
+
+	ipc_command(IPC_CMD_FW_UPDATE_GO);
+
+	/*Driver stalls until scu_flag is set */
+	while (mailbox->scu_flag != 1) {
+		rmb();
+		mdelay(1);
+	}
+
+	/* Driver checks Mailbox status.
+	 * If the status is 'BADN', then abort (bad NAND).
+	 * If the status is 'IPC_FW_TXLOW', then continue.
+	 */
+	while (mailbox->status != IPC_FW_TXLOW) {
+		rmb();
+		mdelay(10);
+	}
+	mdelay(10);
+
+update_retry:
+	if (retry_cnt > 5)
+		goto update_end;
+
+	if (mailbox->status != IPC_FW_TXLOW)
+		goto update_end;
+	buffer = buffer+0x800;
+	memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
+	mailbox->driver_flag = 0x1;
+	while (mailbox->scu_flag == 1) {
+		rmb();
+		mdelay(1);
+	}
+
+	/* check for 'BADN' */
+	if (mailbox->status == IPC_FW_UPDATE_BADN)
+		goto update_end;
+
+	while (mailbox->status != IPC_FW_TXHIGH) {
+		rmb();
+		mdelay(10);
+	}
+	mdelay(10);
+
+	if (mailbox->status != IPC_FW_TXHIGH)
+		goto update_end;
+	buffer = buffer+0x20000;
+	memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
+	mailbox->driver_flag = 0;
+	while (mailbox->scu_flag == 0) {
+		rmb();
+		mdelay(1);
+	}
+
+	/* check for 'BADN' */
+	if (mailbox->status == IPC_FW_UPDATE_BADN)
+		goto update_end;
+
+	if (mailbox->status == IPC_FW_TXLOW) {
+		++retry_cnt;
+		goto update_retry;
+	}
+
+update_end:
+	iounmap(fw_update_base);
+	iounmap(mailbox_base);
+	mutex_unlock(&ipclock);
+	if (mailbox->status == IPC_FW_UPDATE_SUCCESS)
+		return 0;
+	return -1;
+}
+EXPORT_SYMBOL(intel_scu_ipc_fw_update);
+
+/*
+ * Interrupt handler gets called when ioc bit of IPC_COMMAND_REG set to 1
+ * When ioc bit is set to 1, caller api must wait for interrupt handler called
+ * which in turn unlocks the caller api. Currently this is not used
+ *
+ * This is edge triggered so we need take no action to clear anything
+ */
+static irqreturn_t ioc(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
+/**
+ *	ipc_probe	-	probe an Intel SCU IPC
+ *	@dev: the PCI device matching
+ *	@id: entry in the match table
+ *
+ *	Enable and install an intel SCU IPC. This appears in the PCI space
+ *	but uses some hard coded addresses as well.
+ */
+static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	int err;
+	resource_size_t pci_resource;
+
+	if (ipcdev.pdev)		/* We support only one SCU */
+		return -EBUSY;
+
+	ipcdev.pdev = pci_dev_get(dev);
+
+	err = pci_enable_device(dev);
+	if (err)
+		return err;
+
+	err = pci_request_regions(dev, "ipc_mrst");
+	if (err)
+		return err;
+
+	pci_resource = pci_resource_start(dev, 0);
+	if (!pci_resource)
+		return -ENOMEM;
+
+	if (request_irq(dev->irq, ioc, 0, "ipc_mrst", &ipcdev))
+		return -EBUSY;
+
+	ipcdev.ipc_base = ioremap_nocache(IPC_BASE_ADDR, IPC_MAX_ADDR);
+	if (!ipcdev.ipc_base)
+		return -ENOMEM;
+
+	ipcdev.i2c_base = ioremap_nocache(IPC_I2C_BASE, IPC_I2C_MAX_ADDR);
+	if (!ipcdev.i2c_base) {
+		iounmap(ipcdev.ipc_base);
+		return -ENOMEM;
+	}
+
+	ipcdev.pci_base = ioremap_nocache(pci_resource, 0x1000);
+	if (!ipcdev.pci_base) {
+		iounmap(ipcdev.ipc_base);
+		iounmap(ipcdev.i2c_base);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ *	ipc_remove	-	remove a bound IPC device
+ *	@pdev: PCI device
+ *
+ *	In practice the SCU is not removable but this function is also
+ *	called for each device on a module unload or cleanup which is the
+ *	path that will get used.
+ *
+ *	Free up the mappings and release the PCI resources
+ */
+static void ipc_remove(struct pci_dev *pdev)
+{
+	free_irq(pdev->irq, &ipcdev);
+	pci_release_regions(pdev);
+	pci_dev_put(ipcdev.pdev);
+	iounmap(ipcdev.ipc_base);
+	iounmap(ipcdev.i2c_base);
+	iounmap(ipcdev.pci_base);
+	ipcdev.pdev = NULL;
+}
+
+static const struct pci_device_id pci_ids[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e)},
+	{ 0,}
+};
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+static struct pci_driver ipc_driver = {
+	.name = "ipc_mrst",
+	.id_table = pci_ids,
+	.probe = ipc_probe,
+	.remove = ipc_remove,
+};
+
+
+static int __init intel_scu_ipc_init(void)
+{
+	return  pci_register_driver(&ipc_driver);
+}
+
+static void __exit intel_scu_ipc_exit(void)
+{
+	pci_unregister_driver(&ipc_driver);
+}
+
+MODULE_AUTHOR("Sreedhara DS <sreedhara.ds@intel.com>");
+MODULE_DESCRIPTION("Intel SCU IPC driver");
+MODULE_LICENSE("GPL");
+
+module_init(intel_scu_ipc_init);
+module_exit(intel_scu_ipc_exit);

