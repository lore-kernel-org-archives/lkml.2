Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0DAHDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:03:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:1267 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0DAHCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:02:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,346,1267430400"; 
   d="scan'208,223";a="785683183"
From: "Ds, Sreedhara" <sreedhara.ds@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>
Date: Thu, 1 Apr 2010 12:29:42 +0530
Subject: Emailing:
 0001-IPC-driver-for-Intel-Mobile-Internet-Device-MID-pl.patch
Thread-Topic: Emailing:
 0001-IPC-driver-for-Intel-Mobile-Internet-Device-MID-pl.patch
Thread-Index: AcrRaOemSdR51f3xRCuJTeTLjwkJ/g==
Message-ID: <0AE3E14D83C76F4994657326177D1FF9042A1A849E@bgsmsx501.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_0AE3E14D83C76F4994657326177D1FF9042A1A849Ebgsmsx501garc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_0AE3E14D83C76F4994657326177D1FF9042A1A849Ebgsmsx501garc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

  Hi,

Please review and Accept the patch.
This patch is IPC driver for Intel Mobile Internet Device (MID) platforms l=
ike Moorestown

>From 4a9cede42c1e71d34d9dd9e606346674b24a5e71 Mon Sep 17 00:00:00 2001
From: Sreedhara DS <sreedhara.ds@intel.com>
Date: Wed, 31 Mar 2010 00:30:47 +0530
Subject: [PATCH] IPC driver for Intel Mobile Internet Device (MID) platform=
s
 IPC is used to bridge the communications between kernel and SCU on
 some embedded Intel x86 platforms

        modified:   Kconfig
        new file:   include/asm/intel_scu_ipc.h
        modified:   kernel/Makefile
        new file:   kernel/intel_scu_ipc.c

Signed-off-by: Sreedhara DS <sreedhara.ds@intel.com>
---
 arch/x86/Kconfig                     |    8 +
 arch/x86/include/asm/intel_scu_ipc.h |  102 ++++
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/intel_scu_ipc.c      |  877 ++++++++++++++++++++++++++++++=
++++
 4 files changed, 988 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_scu_ipc.h
 create mode 100644 arch/x86/kernel/intel_scu_ipc.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0eacb1f..bc7ec5c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -410,6 +410,14 @@ config X86_MRST
          nor standard legacy replacement devices/features. e.g. Moorestown=
 does
          not contain i8259, i8254, HPET, legacy BIOS, most of the io ports=
.

+config INTEL_SCU_IPC
+       bool "Intel SCU IPC Support"
+       depends on X86_MRST
+       default y
+       ---help---
+        IPC is used to bridge the communications between kernel and SCU on
+        some embedded Intel x86 platforms.
+
 config X86_RDC321X
        bool "RDC R-321x SoC"
        depends on X86_32
diff --git a/arch/x86/include/asm/intel_scu_ipc.h b/arch/x86/include/asm/in=
tel_scu_ipc.h
new file mode 100644
index 0000000..fb29d79
--- /dev/null
+++ b/arch/x86/include/asm/intel_scu_ipc.h
@@ -0,0 +1,102 @@
+#ifndef __INTEL_SCU_IPC_H__
+#define  __INTEL_SCU_IPC_H__
+
+enum scu_ipc_error_t {
+       IPC_NO_ERROR,                   /* No Error */
+       IPC_COMMAND_NOT_SUPPORTED,      /* Command not supported */
+       IPC_COMMAND_NOT_SERVICED,       /* Command not serviced */
+       IPC_UNABLE_TO_SERVICE,          /* Unable to service */
+       IPC_COMMAND_INVALID,            /* Command invalid */
+       IPC_COMMAND_FAILED,             /* Command failed */
+};
+
+struct scu_fw_version {
+       u8 rtMinorVer;          /* SCU RT Firmware Minor Revision */
+       u8 rtMajorVer;          /* SCU RT Firmware Major Revision */
+       u8 romMinorVer;         /* SCU ROM Firmware Minor Revision */
+       u8 romMajorVer;         /* SCU ROM Firmware Major Revision */
+       u8 punitMinorVer;       /* P-unit Microcode Minor Revision */
+       u8 punitMajorVer;       /* P-unit Microcode Major Revision */
+       u8 iaMinorVer;          /* IA-32 Firmware Minor Revision */
+       u8 iaMajorVer;          /* IA-32 Firmware Major Revision */
+       u8 ftlMinorVer;         /* FTL Driver Minor Revision */
+       u8 ftlMajorVer;         /* FTL Driver Major Revision */
+       u8 valMinorVer;         /* Validation Hooks Minor Revision */
+       u8 valMajorVer;         /* Validation Hooks Major Revision */
+       u8 ifwiMinorVer;        /* IFWI Minor Revision */
+       u8 ifwiMajorVer;        /* IFWI Major Revision */
+} ;
+
+struct battery_property {
+       u32 capacity;   /* Charger capacity */
+       u8  crnt;       /* Quick charge current value*/
+       u8  volt;       /* Fine adjustment of constant charge voltage */
+       u8  prot;       /* CHRGPROT register value */
+       u8  prot2;      /* CHRGPROT1 register value */
+       u8 timer;       /* Charging timer */
+} __attribute__((packed));
+
+/* Read single register */
+int intel_scu_ipc_ioread8(u16 *addr, u8 *data);
+
+/* Read two registers */
+int intel_scu_ipc_ioread16(u16 *addr, u8 *data);
+
+/* Read four registers */
+int intel_scu_ipc_ioread32(u16 *addr, u8 *data);
+
+/* Write single register */
+int intel_scu_ipc_iowrite8(u16 *addr, u8 *data);
+
+/* Write two registers */
+int intel_scu_ipc_iowrite16(u16 *addr, u8 *data);
+
+/* Write four registers */
+int intel_scu_ipc_iowrite32(u16 *addr, u8 *data);
+
+/*
+ * Update single register based on the mask
+ * First element of data is register value and second element is mask valu=
e
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
+/* Read the coulomb counter accumulator to monitor the battery charge leve=
l */
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
@@ -107,6 +107,7 @@ scx200-y                    +=3D scx200_32.o

 obj-$(CONFIG_OLPC)             +=3D olpc.o
 obj-$(CONFIG_X86_MRST)         +=3D mrst.o
+obj-$(CONFIG_INTEL_SCU_IPC)    +=3D intel_scu_ipc.o

 microcode-y                            :=3D microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)    +=3D microcode_intel.o
diff --git a/arch/x86/kernel/intel_scu_ipc.c b/arch/x86/kernel/intel_scu_ip=
c.c
new file mode 100644
index 0000000..d209272
--- /dev/null
+++ b/arch/x86/kernel/intel_scu_ipc.c
@@ -0,0 +1,877 @@
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
+ * SCU runing in ARC processor communicates with other entity running in I=
A
+ * core through IPC mechanism which in turn messaging between IA core ad S=
CU.
+ * SCU has two IPC mechanism IPC-1 and IPC-2. IPC-1 is used between IA32 a=
nd
+ * SCU where IPC-2 is used between P-Unit and SCU. This driver delas with
+ * IPC-1 Driver provides an API for power control unit registers (e.g. MSI=
C)
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
+ *    Transaction Layer Packet (TLP) message which is sent across the cDMI=
.
+ *
+ * 2. South Complex cDMI block receives this message and writes it to
+ *    the IPC-1 register block, causing an interrupt to the SCU
+ *
+ * 3. SCU firmware decodes this interrupt and IPC message and the appropri=
ate
+ *    message handler is called within firmware.
+ */
+
+#define IPC_BASE_ADDR     0xFF11C000   /* IPC1 base register address */
+#define IPC_MAX_ADDR      0x100                /* Maximum IPC regisers */
+#define IPC_WWBUF_SIZE    16           /* IPC Write buffer Size */
+#define IPC_RWBUF_SIZE    16           /* IPC Read buffer Size */
+#define IPC_I2C_BASE      0xFF12B000   /* I2C control register base addres=
s */
+#define IPC_I2C_MAX_ADDR  0x10         /* Maximum I2C regisers */
+
+static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id);
+static void ipc_remove(struct pci_dev *pdev);
+
+struct intel_scu_ipc_dev {
+       struct pci_dev *pdev;
+       void __iomem *ipc_base;
+       void __iomem *i2c_base;
+       void __iomem *pci_base;
+};
+
+static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */
+
+static int platform =3D 1;
+module_param(platform, int, 0);
+MODULE_PARM_DESC(platform, "1 for moorestown platform");
+
+/*
+ * Command Register (Write Only):
+ * A write to this register results in an interrupt to the SCU core proces=
sor
+ * Format:
+ * |rfu2(8) | size(8) | command id(4) | rfu1(3) | ioc(1) | command(8)|
+ */
+#define IPC_COMMAND_REG                ipcdev.ipc_base
+
+/*
+ * Status Register (Read Only):
+ * Driver will read this register to get the ready/busy status of the IPC
+ * block and error status of the IPC command that was just processed by SC=
U
+ * Format:
+ * |rfu3(8)|error code(8)|initiator id(8)|cmd id(4)|rfu1(2)|error(1)|busy(=
1)|
+ */
+#define IPC_STATUS_REG         (ipcdev.ipc_base + 0x04)
+
+/*
+ * IPC Source Pointer (Write Only):
+ * Use content as pointer for read location
+*/
+#define IPC_SPTR_REG           (ipcdev.ipc_base + 0x08)
+
+/*
+ * IPC destination Pointer (Write Only):
+ * Use content as pointer for destination write
+*/
+#define IPC_DPTR_REG           (ipcdev.ipc_base + 0x0C)
+
+/*
+ * IPC Write Buffer (Write Only):
+ * 16-byte buffer for sending data associated with IPC command to
+ * SCU. Size of the data is specified in the IPC_COMMAND_REG register
+*/
+#define IPC_WRITE_BUFFER       (ipcdev.ipc_base + 0x80)
+
+/*
+ * IPC Read Buffer (Read Only):
+ * 16 byte buffer for receiving data from SCU, if IPC command
+ * processing results in response data
+*/
+#define IPC_READ_BUFFER                (ipcdev.ipc_base + 0x90)
+
+#define IPC_I2C_CNTRL_ADDR     ipcdev.i2c_base
+#define I2C_DATA_ADDR          (ipcdev.i2c_base + 0x04)
+
+static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU=
 */
+
+static inline void ipc_command(u32 cmd) /* Send ipc command */
+{
+       writel(cmd, IPC_COMMAND_REG);
+}
+
+static inline void ipc_write(u32 data, u32 offset) /* Write ipc data */
+{
+       writel(data, IPC_WRITE_BUFFER + offset);
+}
+
+static inline void ipc_write_dptr(u32 data) /* Write dptr data */
+{
+       writel(data, IPC_DPTR_REG);
+}
+
+static inline void ipc_write_sptr(u32 data) /* Write dptr data */
+{
+       writel(data, IPC_SPTR_REG);
+}
+
+static inline u8 ipc_readb(u32 offset) /* Read ipc byte data */
+{
+       return readb(IPC_READ_BUFFER + offset);
+}
+
+static inline u8 ipc_readl(u32 offset) /* Read ipc u32 data */
+{
+       return readl(IPC_READ_BUFFER + offset);
+}
+
+static inline int busy_loop(void) /* Wait till scu status is busy */
+{
+       u32 status =3D 0;
+       u32 loop_count =3D 0;
+
+       status =3D __raw_readl(IPC_STATUS_REG);
+       while (status & 1) {
+               udelay(1); /* scu processing time is in few u secods */
+               status =3D __raw_readl(IPC_STATUS_REG);
+               loop_count++;
+               /* break if scu doesn't reset busy bit after huge retry */
+               if (loop_count > 100000)
+                       return IPC_UNABLE_TO_SERVICE;
+       }
+       return (status >> 1) & 1;
+}
+
+/* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers *=
/
+static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
+{
+       int nc;
+       u32 offset =3D 0;
+       u32 err =3D 0;
+       u8 cbuf[IPC_WWBUF_SIZE] =3D { '\0' };
+       u32 *wbuf =3D (u32 *)&cbuf;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+
+       if (platform =3D=3D 1) {
+               /* Entry is 4 bytes for read/write, 5 bytes for read modify=
 */
+               for (nc =3D 0; nc < count; nc++) {
+                       cbuf[offset] =3D addr[nc];
+                       cbuf[offset + 1] =3D addr[nc] >> 8;
+                       if (id !=3D IPC_CMD_PCNTRL_R)
+                               cbuf[offset + 2] =3D data[nc];
+                       if (id =3D=3D IPC_CMD_PCNTRL_M) {
+                               cbuf[offset + 3] =3D data[nc + 1];
+                               offset +=3D 1;
+                       }
+                       offset +=3D 3;
+               }
+               for (nc =3D 0, offset =3D 0; nc < count; nc++, offset +=3D =
4)
+                       ipc_write(wbuf[nc], offset); /* Write wbuff */
+
+       } else {
+               for (nc =3D 0, offset =3D 0; nc < count; nc++, offset +=3D =
2)
+                       ipc_write(addr[nc], offset); /* Write addresses */
+               if (id !=3D IPC_CMD_PCNTRL_R) {
+                       for (nc =3D 0; nc < count; nc++, offset++)
+                               ipc_write(data[nc], offset); /* Write data =
*/
+                       if (id =3D=3D IPC_CMD_PCNTRL_M)
+                               ipc_write(data[nc + 1], offset); /* Mask va=
lue*/
+               }
+       }
+
+       if (id !=3D IPC_CMD_PCNTRL_M)
+               ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
+       else
+               ipc_command((count*4) << 16 |  id << 12 | 0 << 8 | op);
+
+       err =3D busy_loop();
+
+       if (id =3D=3D IPC_CMD_PCNTRL_R) { /* Read rbuf */
+               /* Workaround: values are read as 0 without memcpy_fromio *=
/
+               memcpy_fromio(cbuf, IPC_READ_BUFFER, 16);
+               if (platform =3D=3D 1) {
+                       for (nc =3D 0, offset =3D 2; nc < count; nc++, offs=
et +=3D 3)
+                               data[nc] =3D ipc_readb(offset);
+               } else {
+                       for (nc =3D 0; nc < count; nc++)
+                               data[nc] =3D ipc_readb(nc);
+               }
+       }
+       mutex_unlock(&ipclock);
+       return err;
+}
+
+/**
+ *     intel_scu_ipc_ioread8           -       read a word via the SCU
+ *     @addr: register on SCU
+ *     @data: return pointer for read byte
+ *
+ *     Read a single register. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_ioread8(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread8);
+
+/**
+ *     intel_scu_ipc_ioread16          -       read a word via the SCU
+ *     @addr: register on SCU
+ *     @data: return pointer for read word
+ *
+ *     Read a register pair. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_ioread16(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 2, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread16);
+
+/**
+ *     intel_scu_ipc_ioread32          -       read a dword via the SCU
+ *     @addr: register on SCU
+ *     @data: return pointer for read dword
+ *
+ *     Read four registers. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_ioread32(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 4, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_R)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_ioread32);
+
+/**
+ *     intel_scu_ipc_iowrite8          -       write a byte via the SCU
+ *     @addr: register on SCU
+ *     @data: byte to write
+ *
+ *     Write a single register. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_iowrite8(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite8);
+
+/**
+ *     intel_scu_ipc_iowrite16         -       write a word via the SCU
+ *     @addr: register on SCU
+ *     @data: word to write
+ *
+ *     Write two registers. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_iowrite16(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 2, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite16);
+
+/**
+ *     intel_scu_ipc_iowrite32         -       write a dword via the SCU
+ *     @addr: register on SCU
+ *     @data: dword to write
+ *
+ *     Write four registers. Returns 0 on success or an error code. All
+ *     locking between SCU accesses is handled for the caller.
+ *
+ *     This function may sleep.
+ */
+int intel_scu_ipc_iowrite32(u16 *addr, u8 *data)
+{
+       return pwr_reg_rdwr(addr, data, 4, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_W)=
;
+}
+EXPORT_SYMBOL(intel_scu_ipc_iowrite32);
+
+/**
+ *     intel_scu_ipc_update_register   -       r/m/w a register
+ *     @addr: register address
+ *     @data: bits to update and mask
+ *
+ *     Read-modify-write power control unit register. The first byte of th=
e
+ *     data argument must be register value and second is mask value
+ *     mask is a bitmap that indicates which bits to update.
+ *     0 =3D masked. Don't modify this bit, 1 =3D modify this bit.
+ *     returns 0 on success or an error code.
+ *
+ *     This function may sleep. Locking between SCU accesses is handled
+ *     for the caller.
+ */
+int intel_scu_ipc_update_register(u16 addr, u8 data[2])
+{
+       return pwr_reg_rdwr(&addr, data, 1, IPCMSG_PCNTRL, IPC_CMD_PCNTRL_M=
);
+}
+EXPORT_SYMBOL(intel_scu_ipc_update_register);
+
+/**
+ *     intel_scu_ipc_register_read     -       32bit indirect read
+ *     @addr: register address
+ *     @value: 32bit value return
+ *
+ *     Performs IA 32 bit indirect read, returns 0 on success, or an
+ *     error code.
+ *
+ *     Can be used when SCCB(System Controller Configuration Block) regist=
er
+ *     HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_register_read(u32 addr, u32 *value)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_write_sptr(addr);
+       ipc_command(4 << 16 | IPC_CMD_INDIRECT_RD);
+       err =3D busy_loop();
+       *value =3D ipc_readl(0);
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_register_read);
+
+/**
+ *     intel_scu_ipc_register_write    -       32bit indirect write
+ *     @addr: register address
+ *     @value: 32bit value to write
+ *
+ *     Performs IA 32 bit indirect write, returns 0 on success, or an
+ *     error code.
+ *
+ *     Can be used when SCCB(System Controller Configuration Block) regist=
er
+ *     HRIM(Honor Restricted IPC Messages) is set (bit 23)
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_register_write(u32 addr, u32 value)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_write_dptr(addr);
+       ipc_write(value, 0);
+       ipc_command(4 << 16 | IPC_CMD_INDIRECT_WR);
+       err =3D busy_loop();
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_register_write);
+
+/* Battery coulomb counter accumulator commands */
+#define IPC_CMD_CC_WR  0 /* Update coulomb counter value */
+#define IPC_CMD_CC_RD  1 /* Read coulomb counter value */
+#define IPC_CMD_BATTERY_PROPERTY 2 /* Read Battery property */
+
+/**
+ *     intel_scu_ipc_battery_cc_read   -       read battery cc
+ *     @value: battery coulomb counter read
+ *
+ *     Reads the battery couloumb counter value, returns 0 on success, or
+ *     an error code
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_battery_cc_read(u32 *value)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_command(IPC_CMD_CC_RD << 12 | IPCMSG_BATTERY);
+       err =3D busy_loop();
+       *value =3D ipc_readl(0);
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_cc_read);
+
+/**
+ *     intel_scu_ipc_battery_property_get      -       fetch properties
+ *     @prop: battery properties
+ *
+ *     Retrieve the battery properties from the power management
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_battery_cc_write(u32 data)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_write(data, 0);
+       ipc_command(IPC_CMD_CC_WR << 12 | IPCMSG_BATTERY);
+       err =3D busy_loop();
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_cc_write);
+
+/**
+ *     intel_scu_ipc_battery_property_get      -       fetch properties
+ *     @prop: battery properties
+ *
+ *     Retrieve the battery properties from the power management
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_battery_property_get(struct battery_property *prop)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_command(IPC_CMD_BATTERY_PROPERTY << 12 | IPCMSG_BATTERY);
+       err =3D busy_loop();
+       prop->capacity =3D ipc_readb(0);
+       prop->crnt =3D ipc_readb(4);
+       prop->volt =3D ipc_readb(5);
+       prop->prot =3D ipc_readb(6);
+       prop->prot2 =3D ipc_readb(7);
+       prop->timer =3D ipc_readb(8);
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_battery_property_get);
+
+/**
+ *     intel_scu_ipc_set_watchdog      -       watchdog configuration
+ *     @warn_threshold - warning timeout
+ *     @reset_threshold - reset timeout
+ *
+ *     Used to enable Timer Services for Kernel Watchdog Operation permitt=
ing
+ *     automatic reset or reboot of the system if tripped.
+ *     Set watchdog timer value, returns 0 on success, 1 on error
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_set_watchdog(u32 warn_threshold, u32 reset_threshold)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_write(warn_threshold, 0);
+       ipc_write(reset_threshold, 4);
+       ipc_command(2 << 16 | IPCMSG_WATCHDOG_TIMER);
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_set_watchdog);
+
+/**
+ *     intel_scu_ipc_fw_version        -       firmware information
+ *     @version: retrieved firmware version information
+ *
+ *     Read the firmware information from the SCU.
+ *
+ *     This function may sleep. Locking for SCU accesses is handled for
+ *     the caller.
+ */
+int intel_scu_ipc_fw_version(struct scu_fw_version *version)
+{
+       u32 err =3D 0;
+
+       mutex_lock(&ipclock);
+       if (ipcdev.pdev =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENODEV;
+       }
+       ipc_command(IPCMSG_FW_REVISION);
+       err =3D busy_loop();
+       version->rtMinorVer =3D ipc_readb(0);
+       version->rtMajorVer =3D ipc_readb(1);
+       version->romMinorVer =3D ipc_readb(2);
+       version->romMajorVer =3D ipc_readb(3);
+       version->punitMinorVer =3D ipc_readb(4);
+       version->punitMajorVer =3D ipc_readb(5);
+       version->iaMinorVer =3D ipc_readb(6);
+       version->iaMajorVer =3D ipc_readb(7);
+       version->ftlMinorVer =3D ipc_readb(8);
+       version->ftlMajorVer =3D ipc_readb(9);
+       version->valMinorVer =3D ipc_readb(10);
+       version->valMajorVer =3D ipc_readb(11);
+       /* Bytes 12 and 13 are unused */
+       version->ifwiMinorVer =3D ipc_readb(14);
+       version->ifwiMajorVer =3D ipc_readb(15);
+       mutex_unlock(&ipclock);
+       return err;
+}
+EXPORT_SYMBOL(intel_scu_ipc_fw_version);
+
+/*I2C commands */
+#define IPC_I2C_WRITE 1 /* I2C Write command */
+#define IPC_I2C_READ  2 /* I2C Read command */
+
+/**
+ *     intel_scu_ipc_i2c_cntrl         -       I2C read/write operations
+ *     @addr: I2C address + command bits
+ *     @data: data to read/write
+ *
+ *     Perform an an I2C read/write operation via the SCU. All locking is
+ *     handled for the caller. This function may sleep.
+ *
+ *     Returns an error code or 0 on success.
+ */
+int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data)
+{
+       u32 cmd =3D 0;
+
+       mutex_lock(&ipclock);
+       cmd =3D (addr >> 24) & 0xFF;
+       if (cmd =3D=3D IPC_I2C_READ) {
+               writel(addr, IPC_I2C_CNTRL_ADDR);
+               mdelay(1);/*Write Not getting updated without delay*/
+               *data =3D readl(I2C_DATA_ADDR);
+       } else if (cmd =3D=3D IPC_I2C_WRITE) {
+               writel(addr, I2C_DATA_ADDR);
+               mdelay(1);
+               writel(addr, IPC_I2C_CNTRL_ADDR);
+       } else {
+               dev_err(&ipcdev.pdev->dev,
+                       "intel_scu_ipc: I2C INVALID_CMD =3D 0x%x\n", cmd);
+
+               mutex_unlock(&ipclock);
+               return -1;
+       }
+       mutex_unlock(&ipclock);
+       return 0;
+}
+EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
+
+#define IPC_FW_LOAD_ADDR 0xFFFC0000 /* Storage location for FW image */
+#define IPC_FW_UPDATE_MBOX_ADDR 0xFFFFDFF4 /* Mailbox between ipc and scu =
*/
+#define IPC_MAX_FW_SIZE 262144 /* 256K storage size for loading the FW ima=
ge */
+#define IPC_FW_MIP_HEADER_SIZE 2048 /* Firmware MIP header size */
+/* IPC inform SCU to get ready for update process */
+#define IPC_CMD_FW_UPDATE_READY  0x10FE
+/* IPC inform SCU to go for update process */
+#define IPC_CMD_FW_UPDATE_GO     0x20FE
+/* Status code for fw update */
+#define IPC_FW_UPDATE_SUCCESS  0x444f4e45 /* Status code 'DONE' */
+#define IPC_FW_UPDATE_BADN     0x4241444E /* Status code 'BADN' */
+#define IPC_FW_TXHIGH          0x54784849 /* Status code 'IPC_FW_TXHIGH' *=
/
+#define IPC_FW_TXLOW           0x54784c4f /* Status code 'IPC_FW_TXLOW' */
+
+struct fw_update_mailbox {
+       u32    status;
+       u32    scu_flag;
+       u32    driver_flag;
+};
+
+
+/**
+ *     intel_scu_ipc_fw_update -        Firmware update utility
+ *     @buffer: firmware buffer
+ *     @length: size of firmware buffer
+ *
+ *     This function provides an interface to load the firmware into
+ *     the SCU. Returns 0 on success or -1 on failure
+ */
+int intel_scu_ipc_fw_update(u8 *buffer, u32 length)
+{
+       void __iomem *fw_update_base;
+       void __iomem *mailbox_base;
+       int retry_cnt =3D 0;
+
+       struct fw_update_mailbox *mailbox =3D NULL;
+
+       mutex_lock(&ipclock);
+       fw_update_base =3D ioremap_nocache(IPC_FW_LOAD_ADDR, (128*1024));
+       if (fw_update_base =3D=3D NULL) {
+               mutex_unlock(&ipclock);
+               return -ENOMEM;
+       }
+       mailbox_base =3D ioremap_nocache(IPC_FW_UPDATE_MBOX_ADDR,
+                                       sizeof(struct fw_update_mailbox));
+       if (mailbox_base =3D=3D NULL) {
+               iounmap(fw_update_base);
+               mutex_unlock(&ipclock);
+               return -ENOMEM;
+       }
+
+       mailbox =3D (struct fw_update_mailbox *)mailbox_base;
+
+       ipc_command(IPC_CMD_FW_UPDATE_READY);
+
+       /* Intitialize mailbox */
+       mailbox->status =3D 0;
+       mailbox->scu_flag =3D 0;
+       mailbox->driver_flag =3D 0;
+
+       /* Driver copies the 2KB MIP header to SRAM at 0xFFFC0000*/
+       memcpy_toio((u8 *)(fw_update_base), buffer, 0x800);
+
+       /* Driver sends "FW Update" IPC command (CMD_ID 0xFE; MSG_ID 0x02).
+       * Upon receiving this command, SCU will write the 2K MIP header
+       * from 0xFFFC0000 into NAND.
+       * SCU will write a status code into the Mailbox, and then set scu_f=
lag.
+       */
+
+       ipc_command(IPC_CMD_FW_UPDATE_GO);
+
+       /*Driver stalls until scu_flag is set */
+       while (mailbox->scu_flag !=3D 1) {
+               rmb();
+               mdelay(1);
+       }
+
+       /* Driver checks Mailbox status.
+        * If the status is 'BADN', then abort (bad NAND).
+        * If the status is 'IPC_FW_TXLOW', then continue.
+        */
+       while (mailbox->status !=3D IPC_FW_TXLOW) {
+               rmb();
+               mdelay(10);
+       }
+       mdelay(10);
+
+update_retry:
+       if (retry_cnt > 5)
+               goto update_end;
+
+       if (mailbox->status !=3D IPC_FW_TXLOW)
+               goto update_end;
+       buffer =3D buffer+0x800;
+       memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
+       mailbox->driver_flag =3D 0x1;
+       while (mailbox->scu_flag =3D=3D 1) {
+               rmb();
+               mdelay(1);
+       }
+
+       /* check for 'BADN' */
+       if (mailbox->status =3D=3D IPC_FW_UPDATE_BADN)
+               goto update_end;
+
+       while (mailbox->status !=3D IPC_FW_TXHIGH) {
+               rmb();
+               mdelay(10);
+       }
+       mdelay(10);
+
+       if (mailbox->status !=3D IPC_FW_TXHIGH)
+               goto update_end;
+       buffer =3D buffer+0x20000;
+       memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
+       mailbox->driver_flag =3D 0;
+       while (mailbox->scu_flag =3D=3D 0) {
+               rmb();
+               mdelay(1);
+       }
+
+       /* check for 'BADN' */
+       if (mailbox->status =3D=3D IPC_FW_UPDATE_BADN)
+               goto update_end;
+
+       if (mailbox->status =3D=3D IPC_FW_TXLOW) {
+               ++retry_cnt;
+               goto update_retry;
+       }
+
+update_end:
+       iounmap(fw_update_base);
+       iounmap(mailbox_base);
+       mutex_unlock(&ipclock);
+       if (mailbox->status =3D=3D IPC_FW_UPDATE_SUCCESS)
+               return 0;
+       return -1;
+}
+EXPORT_SYMBOL(intel_scu_ipc_fw_update);
+
+/*
+ * Interrupt handler gets called when ioc bit of IPC_COMMAND_REG set to 1
+ * When ioc bit is set to 1, caller api must wait for interrupt handler ca=
lled
+ * which in turn unlocks the caller api. Currently this is not used
+ *
+ * This is edge triggered so we need take no action to clear anything
+ */
+static irqreturn_t ioc(int irq, void *dev_id)
+{
+       return IRQ_HANDLED;
+}
+
+/**
+ *     ipc_probe       -       probe an Intel SCU IPC
+ *     @dev: the PCI device matching
+ *     @id: entry in the match table
+ *
+ *     Enable and install an intel SCU IPC. This appears in the PCI space
+ *     but uses some hard coded addresses as well.
+ */
+static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+       int err;
+       resource_size_t pci_resource;
+
+       ipcdev.pdev =3D pci_dev_get(dev); /* We support only one SCU */
+       if (!ipcdev.pdev)
+               return -EBUSY;
+
+       err =3D pci_enable_device(dev);
+       if (err)
+               return err;
+
+       err =3D pci_request_regions(dev, "ipc_mrst");
+       if (err)
+               return err;
+
+       pci_resource =3D pci_resource_start(dev, 0);
+       if (!pci_resource)
+               return -ENOMEM;
+
+       if (request_irq(dev->irq, ioc, 0, "ipc_mrst", &ipcdev))
+               return -EBUSY;
+
+       ipcdev.ipc_base =3D ioremap_nocache(IPC_BASE_ADDR, IPC_MAX_ADDR);
+       if (!ipcdev.ipc_base)
+               return -ENOMEM;
+
+       ipcdev.i2c_base =3D ioremap_nocache(IPC_I2C_BASE, IPC_I2C_MAX_ADDR)=
;
+       if (!ipcdev.i2c_base) {
+               iounmap(ipcdev.ipc_base);
+               return -ENOMEM;
+       }
+
+       ipcdev.pci_base =3D ioremap_nocache(pci_resource, 0x1000);
+       if (!ipcdev.pci_base) {
+               iounmap(ipcdev.ipc_base);
+               iounmap(ipcdev.i2c_base);
+               return -ENOMEM;
+       }
+
+       return 0;
+}
+
+/**
+ *     ipc_remove      -       remove a bound IPC device
+ *     @pdev: PCI device
+ *
+ *     In practice the SCU is not removable but this function is also
+ *     called for each device on a module unload or cleanup which is the
+ *     path that will get used.
+ *
+ *     Free up the mappings and release the PCI resources
+ */
+static void ipc_remove(struct pci_dev *pdev)
+{
+       free_irq(pdev->irq, &ipcdev);
+       pci_release_regions(pdev);
+       pci_dev_put(ipcdev.pdev);
+       iounmap(ipcdev.ipc_base);
+       iounmap(ipcdev.i2c_base);
+       iounmap(ipcdev.pci_base);
+       ipcdev.pdev =3D NULL;
+}
+
+static const struct pci_device_id pci_ids[] =3D {
+       {PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e)},
+       { 0,}
+};
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+static struct pci_driver ipc_driver =3D {
+       .name =3D "ipc_mrst",
+       .id_table =3D pci_ids,
+       .probe =3D ipc_probe,
+       .remove =3D ipc_remove,
+};
+
+
+static int __init intel_scu_ipc_init(void)
+{
+       return  pci_register_driver(&ipc_driver);
+}
+
+static void __exit intel_scu_ipc_exit(void)
+{
+       pci_unregister_driver(&ipc_driver);
+}
+
+MODULE_AUTHOR("Sreedhara DS <sreedhara.ds@intel.com>");
+MODULE_DESCRIPTION("PenWell ipc Driver");
+MODULE_LICENSE("GPL");
+
+module_init(intel_scu_ipc_init);
+module_exit(intel_scu_ipc_exit);
--
1.5.4.5


--_002_0AE3E14D83C76F4994657326177D1FF9042A1A849Ebgsmsx501garc_
Content-Type: application/octet-stream;
	name="0001-IPC-driver-for-Intel-Mobile-Internet-Device-MID-pl.patch"
Content-Description: 0001-IPC-driver-for-Intel-Mobile-Internet-Device-MID-pl.patch
Content-Disposition: attachment;
	filename="0001-IPC-driver-for-Intel-Mobile-Internet-Device-MID-pl.patch";
	size=30554; creation-date="Wed, 31 Mar 2010 00:32:50 GMT";
	modification-date="Wed, 31 Mar 2010 00:32:50 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0YTljZWRlNDJjMWU3MWQzNGQ5ZGQ5ZTYwNjM0NjY3NGIyNGE1ZTcxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTcmVlZGhhcmEgRFMgPHNyZWVkaGFyYS5kc0BpbnRlbC5jb20+
CkRhdGU6IFdlZCwgMzEgTWFyIDIwMTAgMDA6MzA6NDcgKzA1MzAKU3ViamVjdDogW1BBVENIXSBJ
UEMgZHJpdmVyIGZvciBJbnRlbCBNb2JpbGUgSW50ZXJuZXQgRGV2aWNlIChNSUQpIHBsYXRmb3Jt
cwogSVBDIGlzIHVzZWQgdG8gYnJpZGdlIHRoZSBjb21tdW5pY2F0aW9ucyBiZXR3ZWVuIGtlcm5l
bCBhbmQgU0NVIG9uCiBzb21lIGVtYmVkZGVkIEludGVsIHg4NiBwbGF0Zm9ybXMKCgltb2RpZmll
ZDogICBLY29uZmlnCgluZXcgZmlsZTogICBpbmNsdWRlL2FzbS9pbnRlbF9zY3VfaXBjLmgKCW1v
ZGlmaWVkOiAgIGtlcm5lbC9NYWtlZmlsZQoJbmV3IGZpbGU6ICAga2VybmVsL2ludGVsX3NjdV9p
cGMuYwoKU2lnbmVkLW9mZi1ieTogU3JlZWRoYXJhIERTIDxzcmVlZGhhcmEuZHNAaW50ZWwuY29t
PgotLS0KIGFyY2gveDg2L0tjb25maWcgICAgICAgICAgICAgICAgICAgICB8ICAgIDggKwogYXJj
aC94ODYvaW5jbHVkZS9hc20vaW50ZWxfc2N1X2lwYy5oIHwgIDEwMiArKysrCiBhcmNoL3g4Ni9r
ZXJuZWwvTWFrZWZpbGUgICAgICAgICAgICAgfCAgICAxICsKIGFyY2gveDg2L2tlcm5lbC9pbnRl
bF9zY3VfaXBjLmMgICAgICB8ICA4NzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KwogNCBmaWxlcyBjaGFuZ2VkLCA5ODggaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9pbnRlbF9zY3VfaXBjLmgKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9rZXJuZWwvaW50ZWxfc2N1X2lwYy5jCgpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvS2NvbmZpZyBiL2FyY2gveDg2L0tjb25maWcKaW5kZXggMGVhY2IxZi4u
YmM3ZWM1YyAxMDA2NDQKLS0tIGEvYXJjaC94ODYvS2NvbmZpZworKysgYi9hcmNoL3g4Ni9LY29u
ZmlnCkBAIC00MTAsNiArNDEwLDE0IEBAIGNvbmZpZyBYODZfTVJTVAogCSAgbm9yIHN0YW5kYXJk
IGxlZ2FjeSByZXBsYWNlbWVudCBkZXZpY2VzL2ZlYXR1cmVzLiBlLmcuIE1vb3Jlc3Rvd24gZG9l
cwogCSAgbm90IGNvbnRhaW4gaTgyNTksIGk4MjU0LCBIUEVULCBsZWdhY3kgQklPUywgbW9zdCBv
ZiB0aGUgaW8gcG9ydHMuCiAKK2NvbmZpZyBJTlRFTF9TQ1VfSVBDCisgICAgICAgYm9vbCAiSW50
ZWwgU0NVIElQQyBTdXBwb3J0IgorCWRlcGVuZHMgb24gWDg2X01SU1QKKwlkZWZhdWx0IHkKKwkt
LS1oZWxwLS0tCisJIElQQyBpcyB1c2VkIHRvIGJyaWRnZSB0aGUgY29tbXVuaWNhdGlvbnMgYmV0
d2VlbiBrZXJuZWwgYW5kIFNDVSBvbgorCSBzb21lIGVtYmVkZGVkIEludGVsIHg4NiBwbGF0Zm9y
bXMuCisKIGNvbmZpZyBYODZfUkRDMzIxWAogCWJvb2wgIlJEQyBSLTMyMXggU29DIgogCWRlcGVu
ZHMgb24gWDg2XzMyCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9pbnRlbF9zY3Vf
aXBjLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9pbnRlbF9zY3VfaXBjLmgKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uZmIyOWQ3OQotLS0gL2Rldi9udWxsCisrKyBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2ludGVsX3NjdV9pcGMuaApAQCAtMCwwICsxLDEwMiBAQAorI2lmbmRl
ZiBfX0lOVEVMX1NDVV9JUENfSF9fCisjZGVmaW5lICBfX0lOVEVMX1NDVV9JUENfSF9fCisKK2Vu
dW0gc2N1X2lwY19lcnJvcl90IHsKKwlJUENfTk9fRVJST1IsCQkJLyogTm8gRXJyb3IgKi8KKwlJ
UENfQ09NTUFORF9OT1RfU1VQUE9SVEVELAkvKiBDb21tYW5kIG5vdCBzdXBwb3J0ZWQgKi8KKwlJ
UENfQ09NTUFORF9OT1RfU0VSVklDRUQsCS8qIENvbW1hbmQgbm90IHNlcnZpY2VkICovCisJSVBD
X1VOQUJMRV9UT19TRVJWSUNFLAkJLyogVW5hYmxlIHRvIHNlcnZpY2UgKi8KKwlJUENfQ09NTUFO
RF9JTlZBTElELAkJLyogQ29tbWFuZCBpbnZhbGlkICovCisJSVBDX0NPTU1BTkRfRkFJTEVELAkJ
LyogQ29tbWFuZCBmYWlsZWQgKi8KK307CisKK3N0cnVjdCBzY3VfZndfdmVyc2lvbiB7CisJdTgg
cnRNaW5vclZlcjsJCS8qIFNDVSBSVCBGaXJtd2FyZSBNaW5vciBSZXZpc2lvbiAqLworCXU4IHJ0
TWFqb3JWZXI7CQkvKiBTQ1UgUlQgRmlybXdhcmUgTWFqb3IgUmV2aXNpb24gKi8KKwl1OCByb21N
aW5vclZlcjsJCS8qIFNDVSBST00gRmlybXdhcmUgTWlub3IgUmV2aXNpb24gKi8KKwl1OCByb21N
YWpvclZlcjsJCS8qIFNDVSBST00gRmlybXdhcmUgTWFqb3IgUmV2aXNpb24gKi8KKwl1OCBwdW5p
dE1pbm9yVmVyOwkvKiBQLXVuaXQgTWljcm9jb2RlIE1pbm9yIFJldmlzaW9uICovCisJdTggcHVu
aXRNYWpvclZlcjsJLyogUC11bml0IE1pY3JvY29kZSBNYWpvciBSZXZpc2lvbiAqLworCXU4IGlh
TWlub3JWZXI7CQkvKiBJQS0zMiBGaXJtd2FyZSBNaW5vciBSZXZpc2lvbiAqLworCXU4IGlhTWFq
b3JWZXI7CQkvKiBJQS0zMiBGaXJtd2FyZSBNYWpvciBSZXZpc2lvbiAqLworCXU4IGZ0bE1pbm9y
VmVyOwkJLyogRlRMIERyaXZlciBNaW5vciBSZXZpc2lvbiAqLworCXU4IGZ0bE1ham9yVmVyOwkJ
LyogRlRMIERyaXZlciBNYWpvciBSZXZpc2lvbiAqLworCXU4IHZhbE1pbm9yVmVyOwkJLyogVmFs
aWRhdGlvbiBIb29rcyBNaW5vciBSZXZpc2lvbiAqLworCXU4IHZhbE1ham9yVmVyOwkJLyogVmFs
aWRhdGlvbiBIb29rcyBNYWpvciBSZXZpc2lvbiAqLworCXU4IGlmd2lNaW5vclZlcjsJLyogSUZX
SSBNaW5vciBSZXZpc2lvbiAqLworCXU4IGlmd2lNYWpvclZlcjsJLyogSUZXSSBNYWpvciBSZXZp
c2lvbiAqLworfSA7CisKK3N0cnVjdCBiYXR0ZXJ5X3Byb3BlcnR5IHsKKwl1MzIgY2FwYWNpdHk7
CS8qIENoYXJnZXIgY2FwYWNpdHkgKi8KKwl1OCAgY3JudDsJLyogUXVpY2sgY2hhcmdlIGN1cnJl
bnQgdmFsdWUqLworCXU4ICB2b2x0OwkvKiBGaW5lIGFkanVzdG1lbnQgb2YgY29uc3RhbnQgY2hh
cmdlIHZvbHRhZ2UgKi8KKwl1OCAgcHJvdDsJLyogQ0hSR1BST1QgcmVnaXN0ZXIgdmFsdWUgKi8K
Kwl1OCAgcHJvdDI7CS8qIENIUkdQUk9UMSByZWdpc3RlciB2YWx1ZSAqLworCXU4IHRpbWVyOwkv
KiBDaGFyZ2luZyB0aW1lciAqLworfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKKworLyogUmVh
ZCBzaW5nbGUgcmVnaXN0ZXIgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lvcmVhZDgodTE2ICphZGRy
LCB1OCAqZGF0YSk7CisKKy8qIFJlYWQgdHdvIHJlZ2lzdGVycyAqLworaW50IGludGVsX3NjdV9p
cGNfaW9yZWFkMTYodTE2ICphZGRyLCB1OCAqZGF0YSk7CisKKy8qIFJlYWQgZm91ciByZWdpc3Rl
cnMgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lvcmVhZDMyKHUxNiAqYWRkciwgdTggKmRhdGEpOwor
CisvKiBXcml0ZSBzaW5nbGUgcmVnaXN0ZXIgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lvd3JpdGU4
KHUxNiAqYWRkciwgdTggKmRhdGEpOworCisvKiBXcml0ZSB0d28gcmVnaXN0ZXJzICovCitpbnQg
aW50ZWxfc2N1X2lwY19pb3dyaXRlMTYodTE2ICphZGRyLCB1OCAqZGF0YSk7CisKKy8qIFdyaXRl
IGZvdXIgcmVnaXN0ZXJzICovCitpbnQgaW50ZWxfc2N1X2lwY19pb3dyaXRlMzIodTE2ICphZGRy
LCB1OCAqZGF0YSk7CisKKy8qCisgKiBVcGRhdGUgc2luZ2xlIHJlZ2lzdGVyIGJhc2VkIG9uIHRo
ZSBtYXNrCisgKiBGaXJzdCBlbGVtZW50IG9mIGRhdGEgaXMgcmVnaXN0ZXIgdmFsdWUgYW5kIHNl
Y29uZCBlbGVtZW50IGlzIG1hc2sgdmFsdWUKKyAqLworaW50IGludGVsX3NjdV9pcGNfdXBkYXRl
X3JlZ2lzdGVyKHUxNiBhZGRyLCB1OCBkYXRhWzJdKTsKKworLyoKKyAqIEluZGlyZWN0IHJlZ2lz
dGVyIHJlYWQKKyAqIENhbiBiZSB1c2VkIHdoZW4gU0NDQihTeXN0ZW0gQ29udHJvbGxlciBDb25m
aWd1cmF0aW9uIEJsb2NrKSByZWdpc3RlcgorICogSFJJTShIb25vciBSZXN0cmljdGVkIElQQyBN
ZXNzYWdlcykgaXMgc2V0IChiaXQgMjMpCisgKi8KK2ludCBpbnRlbF9zY3VfaXBjX3JlZ2lzdGVy
X3JlYWQodTMyIGFkZHIsIHUzMiAqZGF0YSk7CisKKy8qCisgKiBJbmRpcmVjdCByZWdpc3RlciB3
cml0ZQorICogQ2FuIGJlIHVzZWQgd2hlbiBTQ0NCKFN5c3RlbSBDb250cm9sbGVyIENvbmZpZ3Vy
YXRpb24gQmxvY2spIHJlZ2lzdGVyCisgKiBIUklNKEhvbm9yIFJlc3RyaWN0ZWQgSVBDIE1lc3Nh
Z2VzKSBpcyBzZXQgKGJpdCAyMykKKyAqLworaW50IGludGVsX3NjdV9pcGNfcmVnaXN0ZXJfd3Jp
dGUodTMyIGFkZHIsIHUzMiBkYXRhKTsKKworLyogUmVhZCB0aGUgY291bG9tYiBjb3VudGVyIGFj
Y3VtdWxhdG9yIHRvIG1vbml0b3IgdGhlIGJhdHRlcnkgY2hhcmdlIGxldmVsICovCitpbnQgaW50
ZWxfc2N1X2lwY19iYXR0ZXJ5X2NjX3JlYWQodTMyICp2YWx1ZSk7CisKKy8qIFdyaXRlIHRoZSBj
b3Vsb21iIGNvdW50ZXIgYWNjdW11bGF0b3IgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2JhdHRlcnlf
Y2Nfd3JpdGUodTMyIHZhbHVlKTsKKworLyogUmVhZCBiYXR0ZXJ5IHByb3BlcnRpZXMgKi8KK2lu
dCBpbnRlbF9zY3VfaXBjX2JhdHRlcnlfcHJvcGVydHkoc3RydWN0IGJhdHRlcnlfcHJvcGVydHkg
KnByb3ApOworCisvKgorICogVXNlZCB0byBlbmFibGUgVGltZXIgU2VydmljZXMgZm9yIEtlcm5l
bCBXYXRjaGRvZyBPcGVyYXRpb24gcGVybWl0dGluZworICogYXV0b21hdGljIHJlc2V0IG9yIHJl
Ym9vdCBvZiB0aGUgc3lzdGVtIGlmIHRyaXBwZWQuCisgKiBTZXQgd2F0Y2hkb2cgdGltZXIgdmFs
dWUsIHJldHVybnMgMCBvbiBzdWNjZXNzLCAxIG9uIGVycm9yCisgKi8KK2ludCBpbnRlbF9zY3Vf
aXBjX3NldF93YXRjaGRvZyh1MzIgd2Fybl90aHJlc2hvbGQsIHUzMiByZXNldF90aHJlc2hvbGQp
OworCisvKiBJMkMgY29udHJvbCBhcGkgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2kyY19jbnRybCh1
MzIgYWRkciwgdTMyICpkYXRhKTsKKworLyogUmVhZCBGVyB2ZXJzaW9uICovCitpbnQgaW50ZWxf
c2N1X2lwY19md192ZXJzaW9uKHN0cnVjdCBzY3VfZndfdmVyc2lvbiAqdmVyc2lvbik7CisKKy8q
IFVwZGF0ZSBGVyB2ZXJzaW9uICovCitpbnQgaW50ZWxfc2N1X2lwY19md191cGRhdGUodTggKmJ1
ZmZlciwgdTMyIGxlbmd0aCk7CisKKyNlbmRpZgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVs
L01ha2VmaWxlIGIvYXJjaC94ODYva2VybmVsL01ha2VmaWxlCmluZGV4IDRjNTgzNTIuLjdhZWNk
NDQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9NYWtlZmlsZQorKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvTWFrZWZpbGUKQEAgLTEwNyw2ICsxMDcsNyBAQCBzY3gyMDAteQkJCSs9IHNjeDIwMF8z
Mi5vCiAKIG9iai0kKENPTkZJR19PTFBDKQkJKz0gb2xwYy5vCiBvYmotJChDT05GSUdfWDg2X01S
U1QpCQkrPSBtcnN0Lm8KK29iai0kKENPTkZJR19JTlRFTF9TQ1VfSVBDKQkrPSBpbnRlbF9zY3Vf
aXBjLm8KIAogbWljcm9jb2RlLXkJCQkJOj0gbWljcm9jb2RlX2NvcmUubwogbWljcm9jb2RlLSQo
Q09ORklHX01JQ1JPQ09ERV9JTlRFTCkJKz0gbWljcm9jb2RlX2ludGVsLm8KZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9pbnRlbF9zY3VfaXBjLmMgYi9hcmNoL3g4Ni9rZXJuZWwvaW50ZWxf
c2N1X2lwYy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmQyMDkyNzIKLS0t
IC9kZXYvbnVsbAorKysgYi9hcmNoL3g4Ni9rZXJuZWwvaW50ZWxfc2N1X2lwYy5jCkBAIC0wLDAg
KzEsODc3IEBACisvKgorICogaW50ZWxfc2N1X2lwYy5jOiBEcml2ZXIgZm9yIHRoZSBJbnRlbCBT
Q1UgSVBDIG1lY2hhbmlzbQorICoKKyAqIChDKSBDb3B5cmlnaHQgMjAwOC0yMDEwIEludGVsIENv
cnBvcmF0aW9uCisgKiBBdXRob3I6IFNyZWVkaGFyYSBEUyAoc3JlZWRoYXJhLmRzQGludGVsLmNv
bSkKKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3Ry
aWJ1dGUgaXQgYW5kL29yCisgKiBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3
YXJlIEZvdW5kYXRpb247IHZlcnNpb24gMgorICogb2YgdGhlIExpY2Vuc2UuCisgKgorICogU0NV
IHJ1bmluZyBpbiBBUkMgcHJvY2Vzc29yIGNvbW11bmljYXRlcyB3aXRoIG90aGVyIGVudGl0eSBy
dW5uaW5nIGluIElBCisgKiBjb3JlIHRocm91Z2ggSVBDIG1lY2hhbmlzbSB3aGljaCBpbiB0dXJu
IG1lc3NhZ2luZyBiZXR3ZWVuIElBIGNvcmUgYWQgU0NVLgorICogU0NVIGhhcyB0d28gSVBDIG1l
Y2hhbmlzbSBJUEMtMSBhbmQgSVBDLTIuIElQQy0xIGlzIHVzZWQgYmV0d2VlbiBJQTMyIGFuZAor
ICogU0NVIHdoZXJlIElQQy0yIGlzIHVzZWQgYmV0d2VlbiBQLVVuaXQgYW5kIFNDVS4gVGhpcyBk
cml2ZXIgZGVsYXMgd2l0aAorICogSVBDLTEgRHJpdmVyIHByb3ZpZGVzIGFuIEFQSSBmb3IgcG93
ZXIgY29udHJvbCB1bml0IHJlZ2lzdGVycyAoZS5nLiBNU0lDKQorICogYWxvbmcgd2l0aCBvdGhl
ciBBUElzLgorICovCisjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KKyNpbmNsdWRlIDxsaW51eC9l
cnJuby5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9zeXNkZXYu
aD4KKyNpbmNsdWRlIDxsaW51eC9wbS5oPgorI2luY2x1ZGUgPGxpbnV4L3BjaS5oPgorI2luY2x1
ZGUgPGxpbnV4L2ludGVycnVwdC5oPgorI2luY2x1ZGUgPGFzbS9zZXR1cC5oPgorI2luY2x1ZGUg
PGFzbS9pbnRlbF9zY3VfaXBjLmg+CisKKy8qIElQQyBkZWZpbmVzIHRoZSBmb2xsb3dpbmcgbWVz
c2FnZSB0eXBlcyAqLworI2RlZmluZSBJUENNU0dfV0FUQ0hET0dfVElNRVIgMHhGOCAvKiBTZXQg
S2VybmVsIFdhdGNoZG9nIFRocmVzaG9sZCAqLworI2RlZmluZSBJUENNU0dfQkFUVEVSWSAgICAg
ICAgMHhFRiAvKiBDb3Vsb21iIENvdW50ZXIgQWNjdW11bGF0b3IgKi8KKyNkZWZpbmUgSVBDTVNH
X0ZXX1VQREFURSAgICAgIDB4RkUgLyogRmlybXdhcmUgdXBkYXRlICovCisjZGVmaW5lIElQQ01T
R19QQ05UUkwgICAgICAgICAweEZGIC8qIFBvd2VyIGNvbnRyb2xsZXIgdW5pdCByZWFkL3dyaXRl
ICovCisjZGVmaW5lIElQQ01TR19GV19SRVZJU0lPTiAgICAweEY0IC8qIEdldCBmaXJtd2FyZSBy
ZXZpc2lvbiAqLworCisvKiBDb21tYW5kIGlkIGFzc29jaWF0ZWQgd2l0aCBtZXNzYWdlIElQQ01T
R19QQ05UUkwgKi8KKyNkZWZpbmUgSVBDX0NNRF9QQ05UUkxfVyAgICAgIDAgLyogUmVnaXN0ZXIg
d3JpdGUgKi8KKyNkZWZpbmUgSVBDX0NNRF9QQ05UUkxfUiAgICAgIDEgLyogUmVnaXN0ZXIgcmVh
ZCAqLworI2RlZmluZSBJUENfQ01EX1BDTlRSTF9NICAgICAgMiAvKiBSZWdpc3RlciByZWFkLW1v
ZGlmeS13cml0ZSAqLworCisvKiBNaXNjZWxhbmVvdXMgQ29tbWFuZCBpZHMgKi8KKyNkZWZpbmUg
SVBDX0NNRF9JTkRJUkVDVF9SRCAgIDIgLyogMzJiaXQgaW5kaXJlY3QgcmVhZCAqLworI2RlZmlu
ZSBJUENfQ01EX0lORElSRUNUX1dSICAgNSAvKiAzMmJpdCBpbmRpcmVjdCB3cml0ZSAqLworCisv
KgorICogSVBDIHJlZ2lzdGVyIHN1bW1hcnkKKyAqCisgKiBJUEMgcmVnaXN0ZXIgYmxvY2tzIGFy
ZSBtZW1vcnkgbWFwcGVkIGF0IGZpeGVkIGFkZHJlc3Mgb2YgMHhGRjExQzAwMAorICogVG8gcmVh
ZCBvciB3cml0ZSBpbmZvcm1hdGlvbiB0byB0aGUgU0NVLCBkcml2ZXIgd3JpdGVzIHRvIElQQy0x
IG1lbW9yeQorICogbWFwcGVkIHJlZ2lzdGVycyAoYmFzZSBhZGRyZXNzIDB4RkYxMUMwMDApLiBU
aGUgZm9sbG93aW5nIGlzIHRoZSBJUEMKKyAqIG1lY2hhbmlzbQorICoKKyAqIDEuIElBIGNvcmUg
Y0RNSSBpbnRlcmZhY2UgY2xhaW1zIHRoaXMgdHJhbnNhY3Rpb24gYW5kIGNvbnZlcnRzIGl0IHRv
IGEKKyAqICAgIFRyYW5zYWN0aW9uIExheWVyIFBhY2tldCAoVExQKSBtZXNzYWdlIHdoaWNoIGlz
IHNlbnQgYWNyb3NzIHRoZSBjRE1JLgorICoKKyAqIDIuIFNvdXRoIENvbXBsZXggY0RNSSBibG9j
ayByZWNlaXZlcyB0aGlzIG1lc3NhZ2UgYW5kIHdyaXRlcyBpdCB0bworICogICAgdGhlIElQQy0x
IHJlZ2lzdGVyIGJsb2NrLCBjYXVzaW5nIGFuIGludGVycnVwdCB0byB0aGUgU0NVCisgKgorICog
My4gU0NVIGZpcm13YXJlIGRlY29kZXMgdGhpcyBpbnRlcnJ1cHQgYW5kIElQQyBtZXNzYWdlIGFu
ZCB0aGUgYXBwcm9wcmlhdGUKKyAqICAgIG1lc3NhZ2UgaGFuZGxlciBpcyBjYWxsZWQgd2l0aGlu
IGZpcm13YXJlLgorICovCisKKyNkZWZpbmUgSVBDX0JBU0VfQUREUiAgICAgMHhGRjExQzAwMAkv
KiBJUEMxIGJhc2UgcmVnaXN0ZXIgYWRkcmVzcyAqLworI2RlZmluZSBJUENfTUFYX0FERFIgICAg
ICAweDEwMAkJLyogTWF4aW11bSBJUEMgcmVnaXNlcnMgKi8KKyNkZWZpbmUgSVBDX1dXQlVGX1NJ
WkUgICAgMTYJCS8qIElQQyBXcml0ZSBidWZmZXIgU2l6ZSAqLworI2RlZmluZSBJUENfUldCVUZf
U0laRSAgICAxNgkJLyogSVBDIFJlYWQgYnVmZmVyIFNpemUgKi8KKyNkZWZpbmUgSVBDX0kyQ19C
QVNFICAgICAgMHhGRjEyQjAwMAkvKiBJMkMgY29udHJvbCByZWdpc3RlciBiYXNlIGFkZHJlc3Mg
Ki8KKyNkZWZpbmUgSVBDX0kyQ19NQVhfQUREUiAgMHgxMAkJLyogTWF4aW11bSBJMkMgcmVnaXNl
cnMgKi8KKworc3RhdGljIGludCBpcGNfcHJvYmUoc3RydWN0IHBjaV9kZXYgKmRldiwgY29uc3Qg
c3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKTsKK3N0YXRpYyB2b2lkIGlwY19yZW1vdmUoc3RydWN0
IHBjaV9kZXYgKnBkZXYpOworCitzdHJ1Y3QgaW50ZWxfc2N1X2lwY19kZXYgeworCXN0cnVjdCBw
Y2lfZGV2ICpwZGV2OworCXZvaWQgX19pb21lbSAqaXBjX2Jhc2U7CisJdm9pZCBfX2lvbWVtICpp
MmNfYmFzZTsKKwl2b2lkIF9faW9tZW0gKnBjaV9iYXNlOworfTsKKworc3RhdGljIHN0cnVjdCBp
bnRlbF9zY3VfaXBjX2RldiAgaXBjZGV2OyAvKiBPbmx5IG9uZSBmb3Igbm93ICovCisKK3N0YXRp
YyBpbnQgcGxhdGZvcm0gPSAxOworbW9kdWxlX3BhcmFtKHBsYXRmb3JtLCBpbnQsIDApOworTU9E
VUxFX1BBUk1fREVTQyhwbGF0Zm9ybSwgIjEgZm9yIG1vb3Jlc3Rvd24gcGxhdGZvcm0iKTsKKwor
LyoKKyAqIENvbW1hbmQgUmVnaXN0ZXIgKFdyaXRlIE9ubHkpOgorICogQSB3cml0ZSB0byB0aGlz
IHJlZ2lzdGVyIHJlc3VsdHMgaW4gYW4gaW50ZXJydXB0IHRvIHRoZSBTQ1UgY29yZSBwcm9jZXNz
b3IKKyAqIEZvcm1hdDoKKyAqIHxyZnUyKDgpIHwgc2l6ZSg4KSB8IGNvbW1hbmQgaWQoNCkgfCBy
ZnUxKDMpIHwgaW9jKDEpIHwgY29tbWFuZCg4KXwKKyAqLworI2RlZmluZSBJUENfQ09NTUFORF9S
RUcJCWlwY2Rldi5pcGNfYmFzZQorCisvKgorICogU3RhdHVzIFJlZ2lzdGVyIChSZWFkIE9ubHkp
OgorICogRHJpdmVyIHdpbGwgcmVhZCB0aGlzIHJlZ2lzdGVyIHRvIGdldCB0aGUgcmVhZHkvYnVz
eSBzdGF0dXMgb2YgdGhlIElQQworICogYmxvY2sgYW5kIGVycm9yIHN0YXR1cyBvZiB0aGUgSVBD
IGNvbW1hbmQgdGhhdCB3YXMganVzdCBwcm9jZXNzZWQgYnkgU0NVCisgKiBGb3JtYXQ6CisgKiB8
cmZ1Myg4KXxlcnJvciBjb2RlKDgpfGluaXRpYXRvciBpZCg4KXxjbWQgaWQoNCl8cmZ1MSgyKXxl
cnJvcigxKXxidXN5KDEpfAorICovCisjZGVmaW5lIElQQ19TVEFUVVNfUkVHCQkoaXBjZGV2Lmlw
Y19iYXNlICsgMHgwNCkKKworLyoKKyAqIElQQyBTb3VyY2UgUG9pbnRlciAoV3JpdGUgT25seSk6
CisgKiBVc2UgY29udGVudCBhcyBwb2ludGVyIGZvciByZWFkIGxvY2F0aW9uCisqLworI2RlZmlu
ZSBJUENfU1BUUl9SRUcJCShpcGNkZXYuaXBjX2Jhc2UgKyAweDA4KQorCisvKgorICogSVBDIGRl
c3RpbmF0aW9uIFBvaW50ZXIgKFdyaXRlIE9ubHkpOgorICogVXNlIGNvbnRlbnQgYXMgcG9pbnRl
ciBmb3IgZGVzdGluYXRpb24gd3JpdGUKKyovCisjZGVmaW5lIElQQ19EUFRSX1JFRwkJKGlwY2Rl
di5pcGNfYmFzZSArIDB4MEMpCisKKy8qCisgKiBJUEMgV3JpdGUgQnVmZmVyIChXcml0ZSBPbmx5
KToKKyAqIDE2LWJ5dGUgYnVmZmVyIGZvciBzZW5kaW5nIGRhdGEgYXNzb2NpYXRlZCB3aXRoIElQ
QyBjb21tYW5kIHRvCisgKiBTQ1UuIFNpemUgb2YgdGhlIGRhdGEgaXMgc3BlY2lmaWVkIGluIHRo
ZSBJUENfQ09NTUFORF9SRUcgcmVnaXN0ZXIKKyovCisjZGVmaW5lIElQQ19XUklURV9CVUZGRVIJ
KGlwY2Rldi5pcGNfYmFzZSArIDB4ODApCisKKy8qCisgKiBJUEMgUmVhZCBCdWZmZXIgKFJlYWQg
T25seSk6CisgKiAxNiBieXRlIGJ1ZmZlciBmb3IgcmVjZWl2aW5nIGRhdGEgZnJvbSBTQ1UsIGlm
IElQQyBjb21tYW5kCisgKiBwcm9jZXNzaW5nIHJlc3VsdHMgaW4gcmVzcG9uc2UgZGF0YQorKi8K
KyNkZWZpbmUgSVBDX1JFQURfQlVGRkVSCQkoaXBjZGV2LmlwY19iYXNlICsgMHg5MCkKKworI2Rl
ZmluZSBJUENfSTJDX0NOVFJMX0FERFIJaXBjZGV2LmkyY19iYXNlCisjZGVmaW5lIEkyQ19EQVRB
X0FERFIJCShpcGNkZXYuaTJjX2Jhc2UgKyAweDA0KQorCitzdGF0aWMgREVGSU5FX01VVEVYKGlw
Y2xvY2spOyAvKiBsb2NrIHVzZWQgdG8gcHJldmVudCBtdWx0aXBsZSBjYWxsIHRvIFNDVSAqLwor
CitzdGF0aWMgaW5saW5lIHZvaWQgaXBjX2NvbW1hbmQodTMyIGNtZCkgLyogU2VuZCBpcGMgY29t
bWFuZCAqLworeworCXdyaXRlbChjbWQsIElQQ19DT01NQU5EX1JFRyk7Cit9CisKK3N0YXRpYyBp
bmxpbmUgdm9pZCBpcGNfd3JpdGUodTMyIGRhdGEsIHUzMiBvZmZzZXQpIC8qIFdyaXRlIGlwYyBk
YXRhICovCit7CisJd3JpdGVsKGRhdGEsIElQQ19XUklURV9CVUZGRVIgKyBvZmZzZXQpOworfQor
CitzdGF0aWMgaW5saW5lIHZvaWQgaXBjX3dyaXRlX2RwdHIodTMyIGRhdGEpIC8qIFdyaXRlIGRw
dHIgZGF0YSAqLworeworCXdyaXRlbChkYXRhLCBJUENfRFBUUl9SRUcpOworfQorCitzdGF0aWMg
aW5saW5lIHZvaWQgaXBjX3dyaXRlX3NwdHIodTMyIGRhdGEpIC8qIFdyaXRlIGRwdHIgZGF0YSAq
LworeworCXdyaXRlbChkYXRhLCBJUENfU1BUUl9SRUcpOworfQorCitzdGF0aWMgaW5saW5lIHU4
IGlwY19yZWFkYih1MzIgb2Zmc2V0KSAvKiBSZWFkIGlwYyBieXRlIGRhdGEgKi8KK3sKKwlyZXR1
cm4gcmVhZGIoSVBDX1JFQURfQlVGRkVSICsgb2Zmc2V0KTsKK30KKworc3RhdGljIGlubGluZSB1
OCBpcGNfcmVhZGwodTMyIG9mZnNldCkgLyogUmVhZCBpcGMgdTMyIGRhdGEgKi8KK3sKKwlyZXR1
cm4gcmVhZGwoSVBDX1JFQURfQlVGRkVSICsgb2Zmc2V0KTsKK30KKworc3RhdGljIGlubGluZSBp
bnQgYnVzeV9sb29wKHZvaWQpIC8qIFdhaXQgdGlsbCBzY3Ugc3RhdHVzIGlzIGJ1c3kgKi8KK3sK
Kwl1MzIgc3RhdHVzID0gMDsKKwl1MzIgbG9vcF9jb3VudCA9IDA7CisKKwlzdGF0dXMgPSBfX3Jh
d19yZWFkbChJUENfU1RBVFVTX1JFRyk7CisJd2hpbGUgKHN0YXR1cyAmIDEpIHsKKwkJdWRlbGF5
KDEpOyAvKiBzY3UgcHJvY2Vzc2luZyB0aW1lIGlzIGluIGZldyB1IHNlY29kcyAqLworCQlzdGF0
dXMgPSBfX3Jhd19yZWFkbChJUENfU1RBVFVTX1JFRyk7CisJCWxvb3BfY291bnQrKzsKKwkJLyog
YnJlYWsgaWYgc2N1IGRvZXNuJ3QgcmVzZXQgYnVzeSBiaXQgYWZ0ZXIgaHVnZSByZXRyeSAqLwor
CQlpZiAobG9vcF9jb3VudCA+IDEwMDAwMCkKKwkJCXJldHVybiBJUENfVU5BQkxFX1RPX1NFUlZJ
Q0U7CisJfQorCXJldHVybiAoc3RhdHVzID4+IDEpICYgMTsKK30KKworLyogUmVhZC9Xcml0ZSBw
b3dlciBjb250cm9sKFBNSUMgaW4gTGFuZ3dlbGwsIE1TSUMgaW4gUGVuV2VsbCkgcmVnaXN0ZXJz
ICovCitzdGF0aWMgaW50IHB3cl9yZWdfcmR3cih1MTYgKmFkZHIsIHU4ICpkYXRhLCB1MzIgY291
bnQsIHUzMiBvcCwgdTMyIGlkKQoreworCWludCBuYzsKKwl1MzIgb2Zmc2V0ID0gMDsKKwl1MzIg
ZXJyID0gMDsKKwl1OCBjYnVmW0lQQ19XV0JVRl9TSVpFXSA9IHsgJ1wwJyB9OworCXUzMiAqd2J1
ZiA9ICh1MzIgKikmY2J1ZjsKKworCW11dGV4X2xvY2soJmlwY2xvY2spOworCWlmIChpcGNkZXYu
cGRldiA9PSBOVUxMKSB7CisJCW11dGV4X3VubG9jaygmaXBjbG9jayk7CisJCXJldHVybiAtRU5P
REVWOworCX0KKworCWlmIChwbGF0Zm9ybSA9PSAxKSB7CisJCS8qIEVudHJ5IGlzIDQgYnl0ZXMg
Zm9yIHJlYWQvd3JpdGUsIDUgYnl0ZXMgZm9yIHJlYWQgbW9kaWZ5ICovCisJCWZvciAobmMgPSAw
OyBuYyA8IGNvdW50OyBuYysrKSB7CisJCQljYnVmW29mZnNldF0gPSBhZGRyW25jXTsKKwkJCWNi
dWZbb2Zmc2V0ICsgMV0gPSBhZGRyW25jXSA+PiA4OworCQkJaWYgKGlkICE9IElQQ19DTURfUENO
VFJMX1IpCisJCQkJY2J1ZltvZmZzZXQgKyAyXSA9IGRhdGFbbmNdOworCQkJaWYgKGlkID09IElQ
Q19DTURfUENOVFJMX00pIHsKKwkJCQljYnVmW29mZnNldCArIDNdID0gZGF0YVtuYyArIDFdOwor
CQkJCW9mZnNldCArPSAxOworCQkJfQorCQkJb2Zmc2V0ICs9IDM7CisJCX0KKwkJZm9yIChuYyA9
IDAsIG9mZnNldCA9IDA7IG5jIDwgY291bnQ7IG5jKyssIG9mZnNldCArPSA0KQorCQkJaXBjX3dy
aXRlKHdidWZbbmNdLCBvZmZzZXQpOyAvKiBXcml0ZSB3YnVmZiAqLworCisJfSBlbHNlIHsKKwkJ
Zm9yIChuYyA9IDAsIG9mZnNldCA9IDA7IG5jIDwgY291bnQ7IG5jKyssIG9mZnNldCArPSAyKQor
CQkJaXBjX3dyaXRlKGFkZHJbbmNdLCBvZmZzZXQpOyAvKiBXcml0ZSBhZGRyZXNzZXMgKi8KKwkJ
aWYgKGlkICE9IElQQ19DTURfUENOVFJMX1IpIHsKKwkJCWZvciAobmMgPSAwOyBuYyA8IGNvdW50
OyBuYysrLCBvZmZzZXQrKykKKwkJCQlpcGNfd3JpdGUoZGF0YVtuY10sIG9mZnNldCk7IC8qIFdy
aXRlIGRhdGEgKi8KKwkJCWlmIChpZCA9PSBJUENfQ01EX1BDTlRSTF9NKQorCQkJCWlwY193cml0
ZShkYXRhW25jICsgMV0sIG9mZnNldCk7IC8qIE1hc2sgdmFsdWUqLworCQl9CisJfQorCisJaWYg
KGlkICE9IElQQ19DTURfUENOVFJMX00pCisJCWlwY19jb21tYW5kKChjb3VudCozKSA8PCAxNiB8
ICBpZCA8PCAxMiB8IDAgPDwgOCB8IG9wKTsKKwllbHNlCisJCWlwY19jb21tYW5kKChjb3VudCo0
KSA8PCAxNiB8ICBpZCA8PCAxMiB8IDAgPDwgOCB8IG9wKTsKKworCWVyciA9IGJ1c3lfbG9vcCgp
OworCisJaWYgKGlkID09IElQQ19DTURfUENOVFJMX1IpIHsgLyogUmVhZCByYnVmICovCisJCS8q
IFdvcmthcm91bmQ6IHZhbHVlcyBhcmUgcmVhZCBhcyAwIHdpdGhvdXQgbWVtY3B5X2Zyb21pbyAq
LworCQltZW1jcHlfZnJvbWlvKGNidWYsIElQQ19SRUFEX0JVRkZFUiwgMTYpOworCQlpZiAocGxh
dGZvcm0gPT0gMSkgeworCQkJZm9yIChuYyA9IDAsIG9mZnNldCA9IDI7IG5jIDwgY291bnQ7IG5j
KyssIG9mZnNldCArPSAzKQorCQkJCWRhdGFbbmNdID0gaXBjX3JlYWRiKG9mZnNldCk7CisJCX0g
ZWxzZSB7CisJCQlmb3IgKG5jID0gMDsgbmMgPCBjb3VudDsgbmMrKykKKwkJCQlkYXRhW25jXSA9
IGlwY19yZWFkYihuYyk7CisJCX0KKwl9CisJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwlyZXR1
cm4gZXJyOworfQorCisvKioKKyAqCWludGVsX3NjdV9pcGNfaW9yZWFkOAkJLQlyZWFkIGEgd29y
ZCB2aWEgdGhlIFNDVQorICoJQGFkZHI6IHJlZ2lzdGVyIG9uIFNDVQorICoJQGRhdGE6IHJldHVy
biBwb2ludGVyIGZvciByZWFkIGJ5dGUKKyAqCisgKglSZWFkIGEgc2luZ2xlIHJlZ2lzdGVyLiBS
ZXR1cm5zIDAgb24gc3VjY2VzcyBvciBhbiBlcnJvciBjb2RlLiBBbGwKKyAqCWxvY2tpbmcgYmV0
d2VlbiBTQ1UgYWNjZXNzZXMgaXMgaGFuZGxlZCBmb3IgdGhlIGNhbGxlci4KKyAqCisgKglUaGlz
IGZ1bmN0aW9uIG1heSBzbGVlcC4KKyAqLworaW50IGludGVsX3NjdV9pcGNfaW9yZWFkOCh1MTYg
KmFkZHIsIHU4ICpkYXRhKQoreworCXJldHVybiBwd3JfcmVnX3Jkd3IoYWRkciwgZGF0YSwgMSwg
SVBDTVNHX1BDTlRSTCwgSVBDX0NNRF9QQ05UUkxfUik7Cit9CitFWFBPUlRfU1lNQk9MKGludGVs
X3NjdV9pcGNfaW9yZWFkOCk7CisKKy8qKgorICoJaW50ZWxfc2N1X2lwY19pb3JlYWQxNgkJLQly
ZWFkIGEgd29yZCB2aWEgdGhlIFNDVQorICoJQGFkZHI6IHJlZ2lzdGVyIG9uIFNDVQorICoJQGRh
dGE6IHJldHVybiBwb2ludGVyIGZvciByZWFkIHdvcmQKKyAqCisgKglSZWFkIGEgcmVnaXN0ZXIg
cGFpci4gUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgYW4gZXJyb3IgY29kZS4gQWxsCisgKglsb2Nr
aW5nIGJldHdlZW4gU0NVIGFjY2Vzc2VzIGlzIGhhbmRsZWQgZm9yIHRoZSBjYWxsZXIuCisgKgor
ICoJVGhpcyBmdW5jdGlvbiBtYXkgc2xlZXAuCisgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lvcmVh
ZDE2KHUxNiAqYWRkciwgdTggKmRhdGEpCit7CisJcmV0dXJuIHB3cl9yZWdfcmR3cihhZGRyLCBk
YXRhLCAyLCBJUENNU0dfUENOVFJMLCBJUENfQ01EX1BDTlRSTF9SKTsKK30KK0VYUE9SVF9TWU1C
T0woaW50ZWxfc2N1X2lwY19pb3JlYWQxNik7CisKKy8qKgorICoJaW50ZWxfc2N1X2lwY19pb3Jl
YWQzMgkJLQlyZWFkIGEgZHdvcmQgdmlhIHRoZSBTQ1UKKyAqCUBhZGRyOiByZWdpc3RlciBvbiBT
Q1UKKyAqCUBkYXRhOiByZXR1cm4gcG9pbnRlciBmb3IgcmVhZCBkd29yZAorICoKKyAqCVJlYWQg
Zm91ciByZWdpc3RlcnMuIFJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGFuIGVycm9yIGNvZGUuIEFs
bAorICoJbG9ja2luZyBiZXR3ZWVuIFNDVSBhY2Nlc3NlcyBpcyBoYW5kbGVkIGZvciB0aGUgY2Fs
bGVyLgorICoKKyAqCVRoaXMgZnVuY3Rpb24gbWF5IHNsZWVwLgorICovCitpbnQgaW50ZWxfc2N1
X2lwY19pb3JlYWQzMih1MTYgKmFkZHIsIHU4ICpkYXRhKQoreworCXJldHVybiBwd3JfcmVnX3Jk
d3IoYWRkciwgZGF0YSwgNCwgSVBDTVNHX1BDTlRSTCwgSVBDX0NNRF9QQ05UUkxfUik7Cit9CitF
WFBPUlRfU1lNQk9MKGludGVsX3NjdV9pcGNfaW9yZWFkMzIpOworCisvKioKKyAqCWludGVsX3Nj
dV9pcGNfaW93cml0ZTgJCS0Jd3JpdGUgYSBieXRlIHZpYSB0aGUgU0NVCisgKglAYWRkcjogcmVn
aXN0ZXIgb24gU0NVCisgKglAZGF0YTogYnl0ZSB0byB3cml0ZQorICoKKyAqCVdyaXRlIGEgc2lu
Z2xlIHJlZ2lzdGVyLiBSZXR1cm5zIDAgb24gc3VjY2VzcyBvciBhbiBlcnJvciBjb2RlLiBBbGwK
KyAqCWxvY2tpbmcgYmV0d2VlbiBTQ1UgYWNjZXNzZXMgaXMgaGFuZGxlZCBmb3IgdGhlIGNhbGxl
ci4KKyAqCisgKglUaGlzIGZ1bmN0aW9uIG1heSBzbGVlcC4KKyAqLworaW50IGludGVsX3NjdV9p
cGNfaW93cml0ZTgodTE2ICphZGRyLCB1OCAqZGF0YSkKK3sKKwlyZXR1cm4gcHdyX3JlZ19yZHdy
KGFkZHIsIGRhdGEsIDEsIElQQ01TR19QQ05UUkwsIElQQ19DTURfUENOVFJMX1cpOworfQorRVhQ
T1JUX1NZTUJPTChpbnRlbF9zY3VfaXBjX2lvd3JpdGU4KTsKKworLyoqCisgKglpbnRlbF9zY3Vf
aXBjX2lvd3JpdGUxNgkJLQl3cml0ZSBhIHdvcmQgdmlhIHRoZSBTQ1UKKyAqCUBhZGRyOiByZWdp
c3RlciBvbiBTQ1UKKyAqCUBkYXRhOiB3b3JkIHRvIHdyaXRlCisgKgorICoJV3JpdGUgdHdvIHJl
Z2lzdGVycy4gUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgYW4gZXJyb3IgY29kZS4gQWxsCisgKgls
b2NraW5nIGJldHdlZW4gU0NVIGFjY2Vzc2VzIGlzIGhhbmRsZWQgZm9yIHRoZSBjYWxsZXIuCisg
KgorICoJVGhpcyBmdW5jdGlvbiBtYXkgc2xlZXAuCisgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lv
d3JpdGUxNih1MTYgKmFkZHIsIHU4ICpkYXRhKQoreworCXJldHVybiBwd3JfcmVnX3Jkd3IoYWRk
ciwgZGF0YSwgMiwgSVBDTVNHX1BDTlRSTCwgSVBDX0NNRF9QQ05UUkxfVyk7Cit9CitFWFBPUlRf
U1lNQk9MKGludGVsX3NjdV9pcGNfaW93cml0ZTE2KTsKKworLyoqCisgKglpbnRlbF9zY3VfaXBj
X2lvd3JpdGUzMgkJLQl3cml0ZSBhIGR3b3JkIHZpYSB0aGUgU0NVCisgKglAYWRkcjogcmVnaXN0
ZXIgb24gU0NVCisgKglAZGF0YTogZHdvcmQgdG8gd3JpdGUKKyAqCisgKglXcml0ZSBmb3VyIHJl
Z2lzdGVycy4gUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgYW4gZXJyb3IgY29kZS4gQWxsCisgKgls
b2NraW5nIGJldHdlZW4gU0NVIGFjY2Vzc2VzIGlzIGhhbmRsZWQgZm9yIHRoZSBjYWxsZXIuCisg
KgorICoJVGhpcyBmdW5jdGlvbiBtYXkgc2xlZXAuCisgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2lv
d3JpdGUzMih1MTYgKmFkZHIsIHU4ICpkYXRhKQoreworCXJldHVybiBwd3JfcmVnX3Jkd3IoYWRk
ciwgZGF0YSwgNCwgSVBDTVNHX1BDTlRSTCwgSVBDX0NNRF9QQ05UUkxfVyk7Cit9CitFWFBPUlRf
U1lNQk9MKGludGVsX3NjdV9pcGNfaW93cml0ZTMyKTsKKworLyoqCisgKglpbnRlbF9zY3VfaXBj
X3VwZGF0ZV9yZWdpc3RlcgktCXIvbS93IGEgcmVnaXN0ZXIKKyAqCUBhZGRyOiByZWdpc3RlciBh
ZGRyZXNzCisgKglAZGF0YTogYml0cyB0byB1cGRhdGUgYW5kIG1hc2sKKyAqCisgKglSZWFkLW1v
ZGlmeS13cml0ZSBwb3dlciBjb250cm9sIHVuaXQgcmVnaXN0ZXIuIFRoZSBmaXJzdCBieXRlIG9m
IHRoZQorICoJZGF0YSBhcmd1bWVudCBtdXN0IGJlIHJlZ2lzdGVyIHZhbHVlIGFuZCBzZWNvbmQg
aXMgbWFzayB2YWx1ZQorICoJbWFzayBpcyBhIGJpdG1hcCB0aGF0IGluZGljYXRlcyB3aGljaCBi
aXRzIHRvIHVwZGF0ZS4KKyAqCTAgPSBtYXNrZWQuIERvbid0IG1vZGlmeSB0aGlzIGJpdCwgMSA9
IG1vZGlmeSB0aGlzIGJpdC4KKyAqCXJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGFuIGVycm9yIGNv
ZGUuCisgKgorICoJVGhpcyBmdW5jdGlvbiBtYXkgc2xlZXAuIExvY2tpbmcgYmV0d2VlbiBTQ1Ug
YWNjZXNzZXMgaXMgaGFuZGxlZAorICoJZm9yIHRoZSBjYWxsZXIuCisgKi8KK2ludCBpbnRlbF9z
Y3VfaXBjX3VwZGF0ZV9yZWdpc3Rlcih1MTYgYWRkciwgdTggZGF0YVsyXSkKK3sKKwlyZXR1cm4g
cHdyX3JlZ19yZHdyKCZhZGRyLCBkYXRhLCAxLCBJUENNU0dfUENOVFJMLCBJUENfQ01EX1BDTlRS
TF9NKTsKK30KK0VYUE9SVF9TWU1CT0woaW50ZWxfc2N1X2lwY191cGRhdGVfcmVnaXN0ZXIpOwor
CisvKioKKyAqCWludGVsX3NjdV9pcGNfcmVnaXN0ZXJfcmVhZAktCTMyYml0IGluZGlyZWN0IHJl
YWQKKyAqCUBhZGRyOiByZWdpc3RlciBhZGRyZXNzCisgKglAdmFsdWU6IDMyYml0IHZhbHVlIHJl
dHVybgorICoKKyAqCVBlcmZvcm1zIElBIDMyIGJpdCBpbmRpcmVjdCByZWFkLCByZXR1cm5zIDAg
b24gc3VjY2Vzcywgb3IgYW4KKyAqCWVycm9yIGNvZGUuCisgKgorICoJQ2FuIGJlIHVzZWQgd2hl
biBTQ0NCKFN5c3RlbSBDb250cm9sbGVyIENvbmZpZ3VyYXRpb24gQmxvY2spIHJlZ2lzdGVyCisg
KglIUklNKEhvbm9yIFJlc3RyaWN0ZWQgSVBDIE1lc3NhZ2VzKSBpcyBzZXQgKGJpdCAyMykKKyAq
CisgKglUaGlzIGZ1bmN0aW9uIG1heSBzbGVlcC4gTG9ja2luZyBmb3IgU0NVIGFjY2Vzc2VzIGlz
IGhhbmRsZWQgZm9yCisgKgl0aGUgY2FsbGVyLgorICovCitpbnQgaW50ZWxfc2N1X2lwY19yZWdp
c3Rlcl9yZWFkKHUzMiBhZGRyLCB1MzIgKnZhbHVlKQoreworCXUzMiBlcnIgPSAwOworCisJbXV0
ZXhfbG9jaygmaXBjbG9jayk7CisJaWYgKGlwY2Rldi5wZGV2ID09IE5VTEwpIHsKKwkJbXV0ZXhf
dW5sb2NrKCZpcGNsb2NrKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCWlwY193cml0ZV9zcHRy
KGFkZHIpOworCWlwY19jb21tYW5kKDQgPDwgMTYgfCBJUENfQ01EX0lORElSRUNUX1JEKTsKKwll
cnIgPSBidXN5X2xvb3AoKTsKKwkqdmFsdWUgPSBpcGNfcmVhZGwoMCk7CisJbXV0ZXhfdW5sb2Nr
KCZpcGNsb2NrKTsKKwlyZXR1cm4gZXJyOworfQorRVhQT1JUX1NZTUJPTChpbnRlbF9zY3VfaXBj
X3JlZ2lzdGVyX3JlYWQpOworCisvKioKKyAqCWludGVsX3NjdV9pcGNfcmVnaXN0ZXJfd3JpdGUJ
LQkzMmJpdCBpbmRpcmVjdCB3cml0ZQorICoJQGFkZHI6IHJlZ2lzdGVyIGFkZHJlc3MKKyAqCUB2
YWx1ZTogMzJiaXQgdmFsdWUgdG8gd3JpdGUKKyAqCisgKglQZXJmb3JtcyBJQSAzMiBiaXQgaW5k
aXJlY3Qgd3JpdGUsIHJldHVybnMgMCBvbiBzdWNjZXNzLCBvciBhbgorICoJZXJyb3IgY29kZS4K
KyAqCisgKglDYW4gYmUgdXNlZCB3aGVuIFNDQ0IoU3lzdGVtIENvbnRyb2xsZXIgQ29uZmlndXJh
dGlvbiBCbG9jaykgcmVnaXN0ZXIKKyAqCUhSSU0oSG9ub3IgUmVzdHJpY3RlZCBJUEMgTWVzc2Fn
ZXMpIGlzIHNldCAoYml0IDIzKQorICoKKyAqCVRoaXMgZnVuY3Rpb24gbWF5IHNsZWVwLiBMb2Nr
aW5nIGZvciBTQ1UgYWNjZXNzZXMgaXMgaGFuZGxlZCBmb3IKKyAqCXRoZSBjYWxsZXIuCisgKi8K
K2ludCBpbnRlbF9zY3VfaXBjX3JlZ2lzdGVyX3dyaXRlKHUzMiBhZGRyLCB1MzIgdmFsdWUpCit7
CisJdTMyIGVyciA9IDA7CisKKwltdXRleF9sb2NrKCZpcGNsb2NrKTsKKwlpZiAoaXBjZGV2LnBk
ZXYgPT0gTlVMTCkgeworCQltdXRleF91bmxvY2soJmlwY2xvY2spOworCQlyZXR1cm4gLUVOT0RF
VjsKKwl9CisJaXBjX3dyaXRlX2RwdHIoYWRkcik7CisJaXBjX3dyaXRlKHZhbHVlLCAwKTsKKwlp
cGNfY29tbWFuZCg0IDw8IDE2IHwgSVBDX0NNRF9JTkRJUkVDVF9XUik7CisJZXJyID0gYnVzeV9s
b29wKCk7CisJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwlyZXR1cm4gZXJyOworfQorRVhQT1JU
X1NZTUJPTChpbnRlbF9zY3VfaXBjX3JlZ2lzdGVyX3dyaXRlKTsKKworLyogQmF0dGVyeSBjb3Vs
b21iIGNvdW50ZXIgYWNjdW11bGF0b3IgY29tbWFuZHMgKi8KKyNkZWZpbmUgSVBDX0NNRF9DQ19X
UiAgMCAvKiBVcGRhdGUgY291bG9tYiBjb3VudGVyIHZhbHVlICovCisjZGVmaW5lIElQQ19DTURf
Q0NfUkQgIDEgLyogUmVhZCBjb3Vsb21iIGNvdW50ZXIgdmFsdWUgKi8KKyNkZWZpbmUgSVBDX0NN
RF9CQVRURVJZX1BST1BFUlRZIDIgLyogUmVhZCBCYXR0ZXJ5IHByb3BlcnR5ICovCisKKy8qKgor
ICoJaW50ZWxfc2N1X2lwY19iYXR0ZXJ5X2NjX3JlYWQJLQlyZWFkIGJhdHRlcnkgY2MKKyAqCUB2
YWx1ZTogYmF0dGVyeSBjb3Vsb21iIGNvdW50ZXIgcmVhZAorICoKKyAqCVJlYWRzIHRoZSBiYXR0
ZXJ5IGNvdWxvdW1iIGNvdW50ZXIgdmFsdWUsIHJldHVybnMgMCBvbiBzdWNjZXNzLCBvcgorICoJ
YW4gZXJyb3IgY29kZQorICoKKyAqCVRoaXMgZnVuY3Rpb24gbWF5IHNsZWVwLiBMb2NraW5nIGZv
ciBTQ1UgYWNjZXNzZXMgaXMgaGFuZGxlZCBmb3IKKyAqCXRoZSBjYWxsZXIuCisgKi8KK2ludCBp
bnRlbF9zY3VfaXBjX2JhdHRlcnlfY2NfcmVhZCh1MzIgKnZhbHVlKQoreworCXUzMiBlcnIgPSAw
OworCisJbXV0ZXhfbG9jaygmaXBjbG9jayk7CisJaWYgKGlwY2Rldi5wZGV2ID09IE5VTEwpIHsK
KwkJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCWlwY19j
b21tYW5kKElQQ19DTURfQ0NfUkQgPDwgMTIgfCBJUENNU0dfQkFUVEVSWSk7CisJZXJyID0gYnVz
eV9sb29wKCk7CisJKnZhbHVlID0gaXBjX3JlYWRsKDApOworCW11dGV4X3VubG9jaygmaXBjbG9j
ayk7CisJcmV0dXJuIGVycjsKK30KK0VYUE9SVF9TWU1CT0woaW50ZWxfc2N1X2lwY19iYXR0ZXJ5
X2NjX3JlYWQpOworCisvKioKKyAqCWludGVsX3NjdV9pcGNfYmF0dGVyeV9wcm9wZXJ0eV9nZXQJ
LQlmZXRjaCBwcm9wZXJ0aWVzCisgKglAcHJvcDogYmF0dGVyeSBwcm9wZXJ0aWVzCisgKgorICoJ
UmV0cmlldmUgdGhlIGJhdHRlcnkgcHJvcGVydGllcyBmcm9tIHRoZSBwb3dlciBtYW5hZ2VtZW50
CisgKgorICoJVGhpcyBmdW5jdGlvbiBtYXkgc2xlZXAuIExvY2tpbmcgZm9yIFNDVSBhY2Nlc3Nl
cyBpcyBoYW5kbGVkIGZvcgorICoJdGhlIGNhbGxlci4KKyAqLworaW50IGludGVsX3NjdV9pcGNf
YmF0dGVyeV9jY193cml0ZSh1MzIgZGF0YSkKK3sKKwl1MzIgZXJyID0gMDsKKworCW11dGV4X2xv
Y2soJmlwY2xvY2spOworCWlmIChpcGNkZXYucGRldiA9PSBOVUxMKSB7CisJCW11dGV4X3VubG9j
aygmaXBjbG9jayk7CisJCXJldHVybiAtRU5PREVWOworCX0KKwlpcGNfd3JpdGUoZGF0YSwgMCk7
CisJaXBjX2NvbW1hbmQoSVBDX0NNRF9DQ19XUiA8PCAxMiB8IElQQ01TR19CQVRURVJZKTsKKwll
cnIgPSBidXN5X2xvb3AoKTsKKwltdXRleF91bmxvY2soJmlwY2xvY2spOworCXJldHVybiBlcnI7
Cit9CitFWFBPUlRfU1lNQk9MKGludGVsX3NjdV9pcGNfYmF0dGVyeV9jY193cml0ZSk7CisKKy8q
KgorICoJaW50ZWxfc2N1X2lwY19iYXR0ZXJ5X3Byb3BlcnR5X2dldAktCWZldGNoIHByb3BlcnRp
ZXMKKyAqCUBwcm9wOiBiYXR0ZXJ5IHByb3BlcnRpZXMKKyAqCisgKglSZXRyaWV2ZSB0aGUgYmF0
dGVyeSBwcm9wZXJ0aWVzIGZyb20gdGhlIHBvd2VyIG1hbmFnZW1lbnQKKyAqCisgKglUaGlzIGZ1
bmN0aW9uIG1heSBzbGVlcC4gTG9ja2luZyBmb3IgU0NVIGFjY2Vzc2VzIGlzIGhhbmRsZWQgZm9y
CisgKgl0aGUgY2FsbGVyLgorICovCitpbnQgaW50ZWxfc2N1X2lwY19iYXR0ZXJ5X3Byb3BlcnR5
X2dldChzdHJ1Y3QgYmF0dGVyeV9wcm9wZXJ0eSAqcHJvcCkKK3sKKwl1MzIgZXJyID0gMDsKKwor
CW11dGV4X2xvY2soJmlwY2xvY2spOworCWlmIChpcGNkZXYucGRldiA9PSBOVUxMKSB7CisJCW11
dGV4X3VubG9jaygmaXBjbG9jayk7CisJCXJldHVybiAtRU5PREVWOworCX0KKwlpcGNfY29tbWFu
ZChJUENfQ01EX0JBVFRFUllfUFJPUEVSVFkgPDwgMTIgfCBJUENNU0dfQkFUVEVSWSk7CisJZXJy
ID0gYnVzeV9sb29wKCk7CisJcHJvcC0+Y2FwYWNpdHkgPSBpcGNfcmVhZGIoMCk7CisJcHJvcC0+
Y3JudCA9IGlwY19yZWFkYig0KTsKKwlwcm9wLT52b2x0ID0gaXBjX3JlYWRiKDUpOworCXByb3At
PnByb3QgPSBpcGNfcmVhZGIoNik7CisJcHJvcC0+cHJvdDIgPSBpcGNfcmVhZGIoNyk7CisJcHJv
cC0+dGltZXIgPSBpcGNfcmVhZGIoOCk7CisJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwlyZXR1
cm4gZXJyOworfQorRVhQT1JUX1NZTUJPTChpbnRlbF9zY3VfaXBjX2JhdHRlcnlfcHJvcGVydHlf
Z2V0KTsKKworLyoqCisgKglpbnRlbF9zY3VfaXBjX3NldF93YXRjaGRvZwktCXdhdGNoZG9nIGNv
bmZpZ3VyYXRpb24KKyAqCUB3YXJuX3RocmVzaG9sZCAtIHdhcm5pbmcgdGltZW91dAorICoJQHJl
c2V0X3RocmVzaG9sZCAtIHJlc2V0IHRpbWVvdXQKKyAqCisgKglVc2VkIHRvIGVuYWJsZSBUaW1l
ciBTZXJ2aWNlcyBmb3IgS2VybmVsIFdhdGNoZG9nIE9wZXJhdGlvbiBwZXJtaXR0aW5nCisgKglh
dXRvbWF0aWMgcmVzZXQgb3IgcmVib290IG9mIHRoZSBzeXN0ZW0gaWYgdHJpcHBlZC4KKyAqCVNl
dCB3YXRjaGRvZyB0aW1lciB2YWx1ZSwgcmV0dXJucyAwIG9uIHN1Y2Nlc3MsIDEgb24gZXJyb3IK
KyAqCisgKglUaGlzIGZ1bmN0aW9uIG1heSBzbGVlcC4gTG9ja2luZyBmb3IgU0NVIGFjY2Vzc2Vz
IGlzIGhhbmRsZWQgZm9yCisgKgl0aGUgY2FsbGVyLgorICovCitpbnQgaW50ZWxfc2N1X2lwY19z
ZXRfd2F0Y2hkb2codTMyIHdhcm5fdGhyZXNob2xkLCB1MzIgcmVzZXRfdGhyZXNob2xkKQorewor
CXUzMiBlcnIgPSAwOworCisJbXV0ZXhfbG9jaygmaXBjbG9jayk7CisJaWYgKGlwY2Rldi5wZGV2
ID09IE5VTEwpIHsKKwkJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwkJcmV0dXJuIC1FTk9ERVY7
CisJfQorCWlwY193cml0ZSh3YXJuX3RocmVzaG9sZCwgMCk7CisJaXBjX3dyaXRlKHJlc2V0X3Ro
cmVzaG9sZCwgNCk7CisJaXBjX2NvbW1hbmQoMiA8PCAxNiB8IElQQ01TR19XQVRDSERPR19USU1F
Uik7CisJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwlyZXR1cm4gZXJyOworfQorRVhQT1JUX1NZ
TUJPTChpbnRlbF9zY3VfaXBjX3NldF93YXRjaGRvZyk7CisKKy8qKgorICoJaW50ZWxfc2N1X2lw
Y19md192ZXJzaW9uCS0JZmlybXdhcmUgaW5mb3JtYXRpb24KKyAqCUB2ZXJzaW9uOiByZXRyaWV2
ZWQgZmlybXdhcmUgdmVyc2lvbiBpbmZvcm1hdGlvbgorICoKKyAqCVJlYWQgdGhlIGZpcm13YXJl
IGluZm9ybWF0aW9uIGZyb20gdGhlIFNDVS4KKyAqCisgKglUaGlzIGZ1bmN0aW9uIG1heSBzbGVl
cC4gTG9ja2luZyBmb3IgU0NVIGFjY2Vzc2VzIGlzIGhhbmRsZWQgZm9yCisgKgl0aGUgY2FsbGVy
LgorICovCitpbnQgaW50ZWxfc2N1X2lwY19md192ZXJzaW9uKHN0cnVjdCBzY3VfZndfdmVyc2lv
biAqdmVyc2lvbikKK3sKKwl1MzIgZXJyID0gMDsKKworCW11dGV4X2xvY2soJmlwY2xvY2spOwor
CWlmIChpcGNkZXYucGRldiA9PSBOVUxMKSB7CisJCW11dGV4X3VubG9jaygmaXBjbG9jayk7CisJ
CXJldHVybiAtRU5PREVWOworCX0KKwlpcGNfY29tbWFuZChJUENNU0dfRldfUkVWSVNJT04pOwor
CWVyciA9IGJ1c3lfbG9vcCgpOworCXZlcnNpb24tPnJ0TWlub3JWZXIgPSBpcGNfcmVhZGIoMCk7
CisJdmVyc2lvbi0+cnRNYWpvclZlciA9IGlwY19yZWFkYigxKTsKKwl2ZXJzaW9uLT5yb21NaW5v
clZlciA9IGlwY19yZWFkYigyKTsKKwl2ZXJzaW9uLT5yb21NYWpvclZlciA9IGlwY19yZWFkYigz
KTsKKwl2ZXJzaW9uLT5wdW5pdE1pbm9yVmVyID0gaXBjX3JlYWRiKDQpOworCXZlcnNpb24tPnB1
bml0TWFqb3JWZXIgPSBpcGNfcmVhZGIoNSk7CisJdmVyc2lvbi0+aWFNaW5vclZlciA9IGlwY19y
ZWFkYig2KTsKKwl2ZXJzaW9uLT5pYU1ham9yVmVyID0gaXBjX3JlYWRiKDcpOworCXZlcnNpb24t
PmZ0bE1pbm9yVmVyID0gaXBjX3JlYWRiKDgpOworCXZlcnNpb24tPmZ0bE1ham9yVmVyID0gaXBj
X3JlYWRiKDkpOworCXZlcnNpb24tPnZhbE1pbm9yVmVyID0gaXBjX3JlYWRiKDEwKTsKKwl2ZXJz
aW9uLT52YWxNYWpvclZlciA9IGlwY19yZWFkYigxMSk7CisJLyogQnl0ZXMgMTIgYW5kIDEzIGFy
ZSB1bnVzZWQgKi8KKwl2ZXJzaW9uLT5pZndpTWlub3JWZXIgPSBpcGNfcmVhZGIoMTQpOworCXZl
cnNpb24tPmlmd2lNYWpvclZlciA9IGlwY19yZWFkYigxNSk7CisJbXV0ZXhfdW5sb2NrKCZpcGNs
b2NrKTsKKwlyZXR1cm4gZXJyOworfQorRVhQT1JUX1NZTUJPTChpbnRlbF9zY3VfaXBjX2Z3X3Zl
cnNpb24pOworCisvKkkyQyBjb21tYW5kcyAqLworI2RlZmluZSBJUENfSTJDX1dSSVRFIDEgLyog
STJDIFdyaXRlIGNvbW1hbmQgKi8KKyNkZWZpbmUgSVBDX0kyQ19SRUFEICAyIC8qIEkyQyBSZWFk
IGNvbW1hbmQgKi8KKworLyoqCisgKglpbnRlbF9zY3VfaXBjX2kyY19jbnRybAkJLQlJMkMgcmVh
ZC93cml0ZSBvcGVyYXRpb25zCisgKglAYWRkcjogSTJDIGFkZHJlc3MgKyBjb21tYW5kIGJpdHMK
KyAqCUBkYXRhOiBkYXRhIHRvIHJlYWQvd3JpdGUKKyAqCisgKglQZXJmb3JtIGFuIGFuIEkyQyBy
ZWFkL3dyaXRlIG9wZXJhdGlvbiB2aWEgdGhlIFNDVS4gQWxsIGxvY2tpbmcgaXMKKyAqCWhhbmRs
ZWQgZm9yIHRoZSBjYWxsZXIuIFRoaXMgZnVuY3Rpb24gbWF5IHNsZWVwLgorICoKKyAqCVJldHVy
bnMgYW4gZXJyb3IgY29kZSBvciAwIG9uIHN1Y2Nlc3MuCisgKi8KK2ludCBpbnRlbF9zY3VfaXBj
X2kyY19jbnRybCh1MzIgYWRkciwgdTMyICpkYXRhKQoreworCXUzMiBjbWQgPSAwOworCisJbXV0
ZXhfbG9jaygmaXBjbG9jayk7CisJY21kID0gKGFkZHIgPj4gMjQpICYgMHhGRjsKKwlpZiAoY21k
ID09IElQQ19JMkNfUkVBRCkgeworCQl3cml0ZWwoYWRkciwgSVBDX0kyQ19DTlRSTF9BRERSKTsK
KwkJbWRlbGF5KDEpOy8qV3JpdGUgTm90IGdldHRpbmcgdXBkYXRlZCB3aXRob3V0IGRlbGF5Ki8K
KwkJKmRhdGEgPSByZWFkbChJMkNfREFUQV9BRERSKTsKKwl9IGVsc2UgaWYgKGNtZCA9PSBJUENf
STJDX1dSSVRFKSB7CisJCXdyaXRlbChhZGRyLCBJMkNfREFUQV9BRERSKTsKKwkJbWRlbGF5KDEp
OworCQl3cml0ZWwoYWRkciwgSVBDX0kyQ19DTlRSTF9BRERSKTsKKwl9IGVsc2UgeworCQlkZXZf
ZXJyKCZpcGNkZXYucGRldi0+ZGV2LAorCQkJImludGVsX3NjdV9pcGM6IEkyQyBJTlZBTElEX0NN
RCA9IDB4JXhcbiIsIGNtZCk7CisKKwkJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwkJcmV0dXJu
IC0xOworCX0KKwltdXRleF91bmxvY2soJmlwY2xvY2spOworCXJldHVybiAwOworfQorRVhQT1JU
X1NZTUJPTChpbnRlbF9zY3VfaXBjX2kyY19jbnRybCk7CisKKyNkZWZpbmUgSVBDX0ZXX0xPQURf
QUREUiAweEZGRkMwMDAwIC8qIFN0b3JhZ2UgbG9jYXRpb24gZm9yIEZXIGltYWdlICovCisjZGVm
aW5lIElQQ19GV19VUERBVEVfTUJPWF9BRERSIDB4RkZGRkRGRjQgLyogTWFpbGJveCBiZXR3ZWVu
IGlwYyBhbmQgc2N1ICovCisjZGVmaW5lIElQQ19NQVhfRldfU0laRSAyNjIxNDQgLyogMjU2SyBz
dG9yYWdlIHNpemUgZm9yIGxvYWRpbmcgdGhlIEZXIGltYWdlICovCisjZGVmaW5lIElQQ19GV19N
SVBfSEVBREVSX1NJWkUgMjA0OCAvKiBGaXJtd2FyZSBNSVAgaGVhZGVyIHNpemUgKi8KKy8qIElQ
QyBpbmZvcm0gU0NVIHRvIGdldCByZWFkeSBmb3IgdXBkYXRlIHByb2Nlc3MgKi8KKyNkZWZpbmUg
SVBDX0NNRF9GV19VUERBVEVfUkVBRFkgIDB4MTBGRQorLyogSVBDIGluZm9ybSBTQ1UgdG8gZ28g
Zm9yIHVwZGF0ZSBwcm9jZXNzICovCisjZGVmaW5lIElQQ19DTURfRldfVVBEQVRFX0dPICAgICAw
eDIwRkUKKy8qIFN0YXR1cyBjb2RlIGZvciBmdyB1cGRhdGUgKi8KKyNkZWZpbmUgSVBDX0ZXX1VQ
REFURV9TVUNDRVNTCTB4NDQ0ZjRlNDUgLyogU3RhdHVzIGNvZGUgJ0RPTkUnICovCisjZGVmaW5l
IElQQ19GV19VUERBVEVfQkFETgkweDQyNDE0NDRFIC8qIFN0YXR1cyBjb2RlICdCQUROJyAqLwor
I2RlZmluZSBJUENfRldfVFhISUdICQkweDU0Nzg0ODQ5IC8qIFN0YXR1cyBjb2RlICdJUENfRldf
VFhISUdIJyAqLworI2RlZmluZSBJUENfRldfVFhMT1cJCTB4NTQ3ODRjNGYgLyogU3RhdHVzIGNv
ZGUgJ0lQQ19GV19UWExPVycgKi8KKworc3RydWN0IGZ3X3VwZGF0ZV9tYWlsYm94IHsKKwl1MzIg
ICAgc3RhdHVzOworCXUzMiAgICBzY3VfZmxhZzsKKwl1MzIgICAgZHJpdmVyX2ZsYWc7Cit9Owor
CisKKy8qKgorICoJaW50ZWxfc2N1X2lwY19md191cGRhdGUJLQkgRmlybXdhcmUgdXBkYXRlIHV0
aWxpdHkKKyAqCUBidWZmZXI6IGZpcm13YXJlIGJ1ZmZlcgorICoJQGxlbmd0aDogc2l6ZSBvZiBm
aXJtd2FyZSBidWZmZXIKKyAqCisgKglUaGlzIGZ1bmN0aW9uIHByb3ZpZGVzIGFuIGludGVyZmFj
ZSB0byBsb2FkIHRoZSBmaXJtd2FyZSBpbnRvCisgKgl0aGUgU0NVLiBSZXR1cm5zIDAgb24gc3Vj
Y2VzcyBvciAtMSBvbiBmYWlsdXJlCisgKi8KK2ludCBpbnRlbF9zY3VfaXBjX2Z3X3VwZGF0ZSh1
OCAqYnVmZmVyLCB1MzIgbGVuZ3RoKQoreworCXZvaWQgX19pb21lbSAqZndfdXBkYXRlX2Jhc2U7
CisJdm9pZCBfX2lvbWVtICptYWlsYm94X2Jhc2U7CisJaW50IHJldHJ5X2NudCA9IDA7CisKKwlz
dHJ1Y3QgZndfdXBkYXRlX21haWxib3ggKm1haWxib3ggPSBOVUxMOworCisJbXV0ZXhfbG9jaygm
aXBjbG9jayk7CisJZndfdXBkYXRlX2Jhc2UgPSBpb3JlbWFwX25vY2FjaGUoSVBDX0ZXX0xPQURf
QUREUiwgKDEyOCoxMDI0KSk7CisJaWYgKGZ3X3VwZGF0ZV9iYXNlID09IE5VTEwpIHsKKwkJbXV0
ZXhfdW5sb2NrKCZpcGNsb2NrKTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCW1haWxib3hfYmFz
ZSA9IGlvcmVtYXBfbm9jYWNoZShJUENfRldfVVBEQVRFX01CT1hfQUREUiwKKwkJCQkJc2l6ZW9m
KHN0cnVjdCBmd191cGRhdGVfbWFpbGJveCkpOworCWlmIChtYWlsYm94X2Jhc2UgPT0gTlVMTCkg
eworCQlpb3VubWFwKGZ3X3VwZGF0ZV9iYXNlKTsKKwkJbXV0ZXhfdW5sb2NrKCZpcGNsb2NrKTsK
KwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJbWFpbGJveCA9IChzdHJ1Y3QgZndfdXBkYXRlX21h
aWxib3ggKiltYWlsYm94X2Jhc2U7CisKKwlpcGNfY29tbWFuZChJUENfQ01EX0ZXX1VQREFURV9S
RUFEWSk7CisKKwkvKiBJbnRpdGlhbGl6ZSBtYWlsYm94ICovCisJbWFpbGJveC0+c3RhdHVzID0g
MDsKKwltYWlsYm94LT5zY3VfZmxhZyA9IDA7CisJbWFpbGJveC0+ZHJpdmVyX2ZsYWcgPSAwOwor
CisJLyogRHJpdmVyIGNvcGllcyB0aGUgMktCIE1JUCBoZWFkZXIgdG8gU1JBTSBhdCAweEZGRkMw
MDAwKi8KKwltZW1jcHlfdG9pbygodTggKikoZndfdXBkYXRlX2Jhc2UpLCBidWZmZXIsIDB4ODAw
KTsKKworCS8qIERyaXZlciBzZW5kcyAiRlcgVXBkYXRlIiBJUEMgY29tbWFuZCAoQ01EX0lEIDB4
RkU7IE1TR19JRCAweDAyKS4KKwkqIFVwb24gcmVjZWl2aW5nIHRoaXMgY29tbWFuZCwgU0NVIHdp
bGwgd3JpdGUgdGhlIDJLIE1JUCBoZWFkZXIKKwkqIGZyb20gMHhGRkZDMDAwMCBpbnRvIE5BTkQu
CisJKiBTQ1Ugd2lsbCB3cml0ZSBhIHN0YXR1cyBjb2RlIGludG8gdGhlIE1haWxib3gsIGFuZCB0
aGVuIHNldCBzY3VfZmxhZy4KKwkqLworCisJaXBjX2NvbW1hbmQoSVBDX0NNRF9GV19VUERBVEVf
R08pOworCisJLypEcml2ZXIgc3RhbGxzIHVudGlsIHNjdV9mbGFnIGlzIHNldCAqLworCXdoaWxl
IChtYWlsYm94LT5zY3VfZmxhZyAhPSAxKSB7CisJCXJtYigpOworCQltZGVsYXkoMSk7CisJfQor
CisJLyogRHJpdmVyIGNoZWNrcyBNYWlsYm94IHN0YXR1cy4KKwkgKiBJZiB0aGUgc3RhdHVzIGlz
ICdCQUROJywgdGhlbiBhYm9ydCAoYmFkIE5BTkQpLgorCSAqIElmIHRoZSBzdGF0dXMgaXMgJ0lQ
Q19GV19UWExPVycsIHRoZW4gY29udGludWUuCisJICovCisJd2hpbGUgKG1haWxib3gtPnN0YXR1
cyAhPSBJUENfRldfVFhMT1cpIHsKKwkJcm1iKCk7CisJCW1kZWxheSgxMCk7CisJfQorCW1kZWxh
eSgxMCk7CisKK3VwZGF0ZV9yZXRyeToKKwlpZiAocmV0cnlfY250ID4gNSkKKwkJZ290byB1cGRh
dGVfZW5kOworCisJaWYgKG1haWxib3gtPnN0YXR1cyAhPSBJUENfRldfVFhMT1cpCisJCWdvdG8g
dXBkYXRlX2VuZDsKKwlidWZmZXIgPSBidWZmZXIrMHg4MDA7CisJbWVtY3B5X3RvaW8oKHU4ICop
KGZ3X3VwZGF0ZV9iYXNlKSwgYnVmZmVyLCAweDIwMDAwKTsKKwltYWlsYm94LT5kcml2ZXJfZmxh
ZyA9IDB4MTsKKwl3aGlsZSAobWFpbGJveC0+c2N1X2ZsYWcgPT0gMSkgeworCQlybWIoKTsKKwkJ
bWRlbGF5KDEpOworCX0KKworCS8qIGNoZWNrIGZvciAnQkFETicgKi8KKwlpZiAobWFpbGJveC0+
c3RhdHVzID09IElQQ19GV19VUERBVEVfQkFETikKKwkJZ290byB1cGRhdGVfZW5kOworCisJd2hp
bGUgKG1haWxib3gtPnN0YXR1cyAhPSBJUENfRldfVFhISUdIKSB7CisJCXJtYigpOworCQltZGVs
YXkoMTApOworCX0KKwltZGVsYXkoMTApOworCisJaWYgKG1haWxib3gtPnN0YXR1cyAhPSBJUENf
RldfVFhISUdIKQorCQlnb3RvIHVwZGF0ZV9lbmQ7CisJYnVmZmVyID0gYnVmZmVyKzB4MjAwMDA7
CisJbWVtY3B5X3RvaW8oKHU4ICopKGZ3X3VwZGF0ZV9iYXNlKSwgYnVmZmVyLCAweDIwMDAwKTsK
KwltYWlsYm94LT5kcml2ZXJfZmxhZyA9IDA7CisJd2hpbGUgKG1haWxib3gtPnNjdV9mbGFnID09
IDApIHsKKwkJcm1iKCk7CisJCW1kZWxheSgxKTsKKwl9CisKKwkvKiBjaGVjayBmb3IgJ0JBRE4n
ICovCisJaWYgKG1haWxib3gtPnN0YXR1cyA9PSBJUENfRldfVVBEQVRFX0JBRE4pCisJCWdvdG8g
dXBkYXRlX2VuZDsKKworCWlmIChtYWlsYm94LT5zdGF0dXMgPT0gSVBDX0ZXX1RYTE9XKSB7CisJ
CSsrcmV0cnlfY250OworCQlnb3RvIHVwZGF0ZV9yZXRyeTsKKwl9CisKK3VwZGF0ZV9lbmQ6CisJ
aW91bm1hcChmd191cGRhdGVfYmFzZSk7CisJaW91bm1hcChtYWlsYm94X2Jhc2UpOworCW11dGV4
X3VubG9jaygmaXBjbG9jayk7CisJaWYgKG1haWxib3gtPnN0YXR1cyA9PSBJUENfRldfVVBEQVRF
X1NVQ0NFU1MpCisJCXJldHVybiAwOworCXJldHVybiAtMTsKK30KK0VYUE9SVF9TWU1CT0woaW50
ZWxfc2N1X2lwY19md191cGRhdGUpOworCisvKgorICogSW50ZXJydXB0IGhhbmRsZXIgZ2V0cyBj
YWxsZWQgd2hlbiBpb2MgYml0IG9mIElQQ19DT01NQU5EX1JFRyBzZXQgdG8gMQorICogV2hlbiBp
b2MgYml0IGlzIHNldCB0byAxLCBjYWxsZXIgYXBpIG11c3Qgd2FpdCBmb3IgaW50ZXJydXB0IGhh
bmRsZXIgY2FsbGVkCisgKiB3aGljaCBpbiB0dXJuIHVubG9ja3MgdGhlIGNhbGxlciBhcGkuIEN1
cnJlbnRseSB0aGlzIGlzIG5vdCB1c2VkCisgKgorICogVGhpcyBpcyBlZGdlIHRyaWdnZXJlZCBz
byB3ZSBuZWVkIHRha2Ugbm8gYWN0aW9uIHRvIGNsZWFyIGFueXRoaW5nCisgKi8KK3N0YXRpYyBp
cnFyZXR1cm5fdCBpb2MoaW50IGlycSwgdm9pZCAqZGV2X2lkKQoreworCXJldHVybiBJUlFfSEFO
RExFRDsKK30KKworLyoqCisgKglpcGNfcHJvYmUJLQlwcm9iZSBhbiBJbnRlbCBTQ1UgSVBDCisg
KglAZGV2OiB0aGUgUENJIGRldmljZSBtYXRjaGluZworICoJQGlkOiBlbnRyeSBpbiB0aGUgbWF0
Y2ggdGFibGUKKyAqCisgKglFbmFibGUgYW5kIGluc3RhbGwgYW4gaW50ZWwgU0NVIElQQy4gVGhp
cyBhcHBlYXJzIGluIHRoZSBQQ0kgc3BhY2UKKyAqCWJ1dCB1c2VzIHNvbWUgaGFyZCBjb2RlZCBh
ZGRyZXNzZXMgYXMgd2VsbC4KKyAqLworc3RhdGljIGludCBpcGNfcHJvYmUoc3RydWN0IHBjaV9k
ZXYgKmRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQoreworCWludCBlcnI7CisJ
cmVzb3VyY2Vfc2l6ZV90IHBjaV9yZXNvdXJjZTsKKworCWlwY2Rldi5wZGV2ID0gcGNpX2Rldl9n
ZXQoZGV2KTsgLyogV2Ugc3VwcG9ydCBvbmx5IG9uZSBTQ1UgKi8KKwlpZiAoIWlwY2Rldi5wZGV2
KQorCQlyZXR1cm4gLUVCVVNZOworCisJZXJyID0gcGNpX2VuYWJsZV9kZXZpY2UoZGV2KTsKKwlp
ZiAoZXJyKQorCQlyZXR1cm4gZXJyOworCisJZXJyID0gcGNpX3JlcXVlc3RfcmVnaW9ucyhkZXYs
ICJpcGNfbXJzdCIpOworCWlmIChlcnIpCisJCXJldHVybiBlcnI7CisKKwlwY2lfcmVzb3VyY2Ug
PSBwY2lfcmVzb3VyY2Vfc3RhcnQoZGV2LCAwKTsKKwlpZiAoIXBjaV9yZXNvdXJjZSkKKwkJcmV0
dXJuIC1FTk9NRU07CisKKwlpZiAocmVxdWVzdF9pcnEoZGV2LT5pcnEsIGlvYywgMCwgImlwY19t
cnN0IiwgJmlwY2RldikpCisJCXJldHVybiAtRUJVU1k7CisKKwlpcGNkZXYuaXBjX2Jhc2UgPSBp
b3JlbWFwX25vY2FjaGUoSVBDX0JBU0VfQUREUiwgSVBDX01BWF9BRERSKTsKKwlpZiAoIWlwY2Rl
di5pcGNfYmFzZSkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwlpcGNkZXYuaTJjX2Jhc2UgPSBpb3Jl
bWFwX25vY2FjaGUoSVBDX0kyQ19CQVNFLCBJUENfSTJDX01BWF9BRERSKTsKKwlpZiAoIWlwY2Rl
di5pMmNfYmFzZSkgeworCQlpb3VubWFwKGlwY2Rldi5pcGNfYmFzZSk7CisJCXJldHVybiAtRU5P
TUVNOworCX0KKworCWlwY2Rldi5wY2lfYmFzZSA9IGlvcmVtYXBfbm9jYWNoZShwY2lfcmVzb3Vy
Y2UsIDB4MTAwMCk7CisJaWYgKCFpcGNkZXYucGNpX2Jhc2UpIHsKKwkJaW91bm1hcChpcGNkZXYu
aXBjX2Jhc2UpOworCQlpb3VubWFwKGlwY2Rldi5pMmNfYmFzZSk7CisJCXJldHVybiAtRU5PTUVN
OworCX0KKworCXJldHVybiAwOworfQorCisvKioKKyAqCWlwY19yZW1vdmUJLQlyZW1vdmUgYSBi
b3VuZCBJUEMgZGV2aWNlCisgKglAcGRldjogUENJIGRldmljZQorICoKKyAqCUluIHByYWN0aWNl
IHRoZSBTQ1UgaXMgbm90IHJlbW92YWJsZSBidXQgdGhpcyBmdW5jdGlvbiBpcyBhbHNvCisgKglj
YWxsZWQgZm9yIGVhY2ggZGV2aWNlIG9uIGEgbW9kdWxlIHVubG9hZCBvciBjbGVhbnVwIHdoaWNo
IGlzIHRoZQorICoJcGF0aCB0aGF0IHdpbGwgZ2V0IHVzZWQuCisgKgorICoJRnJlZSB1cCB0aGUg
bWFwcGluZ3MgYW5kIHJlbGVhc2UgdGhlIFBDSSByZXNvdXJjZXMKKyAqLworc3RhdGljIHZvaWQg
aXBjX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKK3sKKwlmcmVlX2lycShwZGV2LT5pcnEs
ICZpcGNkZXYpOworCXBjaV9yZWxlYXNlX3JlZ2lvbnMocGRldik7CisJcGNpX2Rldl9wdXQoaXBj
ZGV2LnBkZXYpOworCWlvdW5tYXAoaXBjZGV2LmlwY19iYXNlKTsKKwlpb3VubWFwKGlwY2Rldi5p
MmNfYmFzZSk7CisJaW91bm1hcChpcGNkZXYucGNpX2Jhc2UpOworCWlwY2Rldi5wZGV2ID0gTlVM
TDsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkIHBjaV9pZHNbXSA9IHsK
Kwl7UENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0lOVEVMLCAweDA4MGUpfSwKKwl7IDAsfQorfTsK
K01PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBwY2lfaWRzKTsKKworc3RhdGljIHN0cnVjdCBwY2lf
ZHJpdmVyIGlwY19kcml2ZXIgPSB7CisJLm5hbWUgPSAiaXBjX21yc3QiLAorCS5pZF90YWJsZSA9
IHBjaV9pZHMsCisJLnByb2JlID0gaXBjX3Byb2JlLAorCS5yZW1vdmUgPSBpcGNfcmVtb3ZlLAor
fTsKKworCitzdGF0aWMgaW50IF9faW5pdCBpbnRlbF9zY3VfaXBjX2luaXQodm9pZCkKK3sKKwly
ZXR1cm4gIHBjaV9yZWdpc3Rlcl9kcml2ZXIoJmlwY19kcml2ZXIpOworfQorCitzdGF0aWMgdm9p
ZCBfX2V4aXQgaW50ZWxfc2N1X2lwY19leGl0KHZvaWQpCit7CisJcGNpX3VucmVnaXN0ZXJfZHJp
dmVyKCZpcGNfZHJpdmVyKTsKK30KKworTU9EVUxFX0FVVEhPUigiU3JlZWRoYXJhIERTIDxzcmVl
ZGhhcmEuZHNAaW50ZWwuY29tPiIpOworTU9EVUxFX0RFU0NSSVBUSU9OKCJQZW5XZWxsIGlwYyBE
cml2ZXIiKTsKK01PRFVMRV9MSUNFTlNFKCJHUEwiKTsKKworbW9kdWxlX2luaXQoaW50ZWxfc2N1
X2lwY19pbml0KTsKK21vZHVsZV9leGl0KGludGVsX3NjdV9pcGNfZXhpdCk7Ci0tIAoxLjUuNC41
Cgo=

--_002_0AE3E14D83C76F4994657326177D1FF9042A1A849Ebgsmsx501garc_--
