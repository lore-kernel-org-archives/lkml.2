Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab2AKB64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:58:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:45937 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab2AKB6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:58:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="0'?scan'208";a="55301733"
Message-ID: <4F0CECC8.7010203@linux.intel.com>
Date: Tue, 10 Jan 2012 17:58:32 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Masayuki Ohtake <masa-korg@dsn.okisemi.com>, Wang Qi <qi.wang@intel.com>
Subject: Porting pch_pcieqos to 3.2 for Intel EG20T with no MAC
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
 boundary="------------020809070803060700050407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809070803060700050407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I find myself with a development board with no MAC address for the pch_gbe in
the Platform Controller Hub EG20T. I've dusted off an old patch and am trying
to get it working so it can be included upstream.

I found the phub_util_mac utility on sourceforge which appears to require the
following patch:

http://git.yoctoproject.org/cgit/cgit.cgi/meta-extras/plain/recipes-kernel/linux/linux-netbook-2.6.33.2/linux-2.6.34-pch-pcieqos.patch

I've made the obvious changes to the driver to use unlocked_ioctl as ioctl has
been removed upstream. With this driver built and installed, the
topcliff_mac_util command reports no errors and reads the MAC address as:

00:00:00:00:00:00

Trying to set it reports no errors either, and the instrumentation suggests it
is at least trying to write the correct data. Reading back still results in all
zeros.

During boot, the pch_gbe driver reports:
[    2.211233] pch_gbe 0000:02:00.1: enabling device (0000 -> 0003)
[    2.217271] pch_gbe 0000:02:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.224349] pch_gbe 0000:02:00.1: setting latency timer to 64
[    2.233388] pch_gbe 0000:02:00.1: Invalid MAC Address
[    2.238821] pch_gbe 0000:02:00.1: PCI INT A disabled
[    2.243809] pch_gbe: probe of 0000:02:00.1 failed with error -5

The patch itself follows, I have attached a rather lengthy log which includes a
read/write/read cycle demonstrating the write not taking effect.

Can you shed some light on why this might be the case?

Thanks,

Darren Hart


>From 53b8f7b9033e374be3edaa4ea620069bdfa4aebb Mon Sep 17 00:00:00 2001
Message-Id: <53b8f7b9033e374be3edaa4ea620069bdfa4aebb.1326246553.git.dvhart@linux.intel.com>
From: Darren Hart <dvhart@linux.intel.com>
Date: Mon, 9 Jan 2012 13:51:20 -0800
Subject: [PATCH] OKI Semiconductor PCH PCIEQOS driver

This driver implements PCH PCIEQOS controls for PCH.

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Acked-by: Wang Qi <qi.wang@intel.com>

Ported to 3.2 from 2.6.34 by Darren Hart.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 drivers/char/Kconfig                       |    7 +
 drivers/char/Makefile                      |    2 +
 drivers/char/pch_pcieqos/Makefile          |    9 +
 drivers/char/pch_pcieqos/pch_common.h      |  146 ++++++++
 drivers/char/pch_pcieqos/pch_debug.h       |   60 +++
 drivers/char/pch_pcieqos/pch_pcieqos.c     |  400 ++++++++++++++++++++
 drivers/char/pch_pcieqos/pch_pcieqos.h     |  193 ++++++++++
 drivers/char/pch_pcieqos/pch_pcieqos_hal.c |  550 ++++++++++++++++++++++++++++
 drivers/char/pch_pcieqos/pch_pcieqos_hal.h |  125 +++++++
 drivers/char/pch_pcieqos/pch_pcieqos_pci.c |  523 ++++++++++++++++++++++++++
 10 files changed, 2015 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/pch_pcieqos/Makefile
 create mode 100644 drivers/char/pch_pcieqos/pch_common.h
 create mode 100644 drivers/char/pch_pcieqos/pch_debug.h
 create mode 100644 drivers/char/pch_pcieqos/pch_pcieqos.c
 create mode 100644 drivers/char/pch_pcieqos/pch_pcieqos.h
 create mode 100644 drivers/char/pch_pcieqos/pch_pcieqos_hal.c
 create mode 100644 drivers/char/pch_pcieqos/pch_pcieqos_hal.h
 create mode 100644 drivers/char/pch_pcieqos/pch_pcieqos_pci.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4364303..1a44568 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -627,5 +627,12 @@ config TILE_SROM
 	  device appear much like a simple EEPROM, and knows
 	  how to partition a single ROM for multiple purposes.
 
+config PCH_PCIEQOS
+       tristate "PCH PCIEQOS"
+       depends on PCI
+       help
+         If you say yes to this option, support will be included for the
+         PCH PCIEQOS Host controller.
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 32762ba..1163576 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -65,3 +65,5 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
+
+obj-$(CONFIG_PCH_PCIEQOS)	+= pch_pcieqos/
diff --git a/drivers/char/pch_pcieqos/Makefile b/drivers/char/pch_pcieqos/Makefile
new file mode 100644
index 0000000..8024021
--- /dev/null
+++ b/drivers/char/pch_pcieqos/Makefile
@@ -0,0 +1,9 @@
+ifeq ($(CONFIG_PCIEQOS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+obj-$(CONFIG_PCH_PCIEQOS) += pch_pcieqos_drv.o
+#to set CAN clock to 50Mhz
+EXTRA_CFLAGS+=-DIOH_CAN_PCLK_50MHZ
+
+pch_pcieqos_drv-objs := pch_pcieqos.o pch_pcieqos_pci.o pch_pcieqos_hal.o
diff --git a/drivers/char/pch_pcieqos/pch_common.h b/drivers/char/pch_pcieqos/pch_common.h
new file mode 100644
index 0000000..10526b2
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_common.h
@@ -0,0 +1,146 @@
+/*!
+ * @file ioh_common.h
+ * @brief Provides the macro definitions used by all files.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2008 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	WIPRO 03/07/2009
+ * modified:
+ *	WIPRO 05/08/2009
+ *
+ */
+
+#ifndef __IOH_COMMON_H__
+#define __IOH_COMMON_H__
+
+/*! @ingroup	Global
+@def		    IOH_WRITE8
+@brief			Macro for writing 8 bit data to an io/mem address
+*/
+#define IOH_WRITE8(val, addr)   iowrite8((val), (void __iomem *)(addr))
+/*! @ingroup	Global
+@def		    IOH_LOG
+@brief			Macro for writing 16 bit data to an io/mem address
+*/
+#define IOH_WRITE16(val, addr)  iowrite16((val), (void __iomem *)(addr))
+/*! @ingroup	Global
+@def		    IOH_LOG
+@brief			Macro for writing 32 bit data to an io/mem address
+*/
+#define IOH_WRITE32(val, addr)  iowrite32((val), (void __iomem *)(addr))
+
+/*! @ingroup	Global
+@def		    IOH_READ8
+@brief			Macro for reading 8 bit data from an io/mem address
+*/
+#define IOH_READ8(addr)   ioread8((void __iomem *)(addr))
+/*! @ingroup	Global
+@def		    IOH_READ16
+@brief			Macro for reading 16 bit data from an io/mem address
+*/
+#define IOH_READ16(addr)  ioread16((void __iomem *)(addr))
+/*! @ingroup	Global
+@def		    IOH_READ32
+@brief			Macro for reading 32 bit data from an io/mem address
+*/
+#define IOH_READ32(addr)  ioread32((void __iomem *)(addr))
+/*! @ingroup	Global
+@def		    IOH_WRITE32_F
+@brief			Macro for writing 32 bit data to an io/mem address
+*/
+#define IOH_WRITE32_F(val, addr) do \
+	{ IOH_WRITE32((val), (addr)); (void)IOH_READ32((addr)); } while (0);
+
+/*! @ingroup	Global
+@def		    IOH_WRITE_BYTE
+@brief			Macro for writing 1 byte data to an io/mem address
+*/
+#define IOH_WRITE_BYTE IOH_WRITE8
+/*! @ingroup	Global
+@def		    IOH_WRITE_WORD
+@brief			Macro for writing 1 word data to an io/mem address
+*/
+#define IOH_WRITE_WORD IOH_WRITE16
+/*! @ingroup	Global
+@def		    IOH_WRITE_LONG
+@brief			Macro for writing long data to an io/mem address
+*/
+#define IOH_WRITE_LONG IOH_WRITE32
+
+/*! @ingroup	Global
+@def		    IOH_READ_BYTE
+@brief			Macro for reading 1 byte data from an io/mem address
+*/
+#define IOH_READ_BYTE  IOH_READ8
+/*! @ingroup	Global
+@def		    IOH_READ_WORD
+@brief			Macro for reading 1 word data from an io/mem address
+*/
+#define IOH_READ_WORD  IOH_READ16
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			Macro for reading long data from an io/mem address
+*/
+#define IOH_READ_LONG  IOH_READ32
+
+/* Bit Manipulation Macros */
+
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			macro to set a specified bit(mask) at the
+			specified address
+*/
+#define IOH_SET_ADDR_BIT(addr, bitmask) IOH_WRITE_LONG((IOH_READ_LONG(addr) |\
+							 (bitmask)), (addr))
+
+/*! @ingroup	Global
+@def	    IOH_READ_LONG
+@brief		macro to clear a specified bit(mask) at the specified address
+*/
+#define IOH_CLR_ADDR_BIT(addr, bitmask) IOH_WRITE_LONG((IOH_READ_LONG(addr) &\
+							 ~(bitmask)), (addr))
+
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			macro to set a specified bitmask for a variable
+*/
+#define IOH_SET_BITMSK(var, bitmask) ((var) |= (bitmask))
+
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			macro to clear a specified bitmask for a variable
+*/
+#define IOH_CLR_BITMSK(var, bitmask) ((var) &= (~(bitmask)))
+
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			macro to set a specified bit for a variable
+*/
+#define IOH_SET_BIT(var, bit) ((var) |= (1<<(bit)))
+
+/*! @ingroup	Global
+@def		    IOH_READ_LONG
+@brief			macro to clear a specified bit for a variable
+*/
+#define IOH_CLR_BIT(var, bit) ((var) &= ~(1<<(bit)))
+
+#endif
diff --git a/drivers/char/pch_pcieqos/pch_debug.h b/drivers/char/pch_pcieqos/pch_debug.h
new file mode 100644
index 0000000..e89f659
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_debug.h
@@ -0,0 +1,60 @@
+/*!
+ * @file ioh_debug.h
+ * @brief Provides the macro definitions used for debugging.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2008 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	WIPRO 03/07/2009
+ * modified:
+ *	WIPRO 05/08/2009
+ *
+ */
+
+#ifndef __IOH_DEBUG_H__
+#define __IOH_DEBUG_H__
+
+#ifdef MODULE
+#define IOH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n",\
+						 THIS_MODULE->name, ##args)
+#else
+#define IOH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n" ,\
+							 __FILE__, ##args)
+#endif
+
+#define DEBUG 1
+#ifdef DEBUG
+	#define IOH_DEBUG(fmt, args...) IOH_LOG(KERN_DEBUG, fmt, ##args)
+#else
+	#define IOH_DEBUG(fmt, args...)
+#endif
+
+#ifdef IOH_TRACE_ENABLED
+	#define IOH_TRACE IOH_DEBUG
+#else
+	#define IOH_TRACE(fmt, args...)
+#endif
+
+#define IOH_TRACE_ENTER IOH_TRACE("Enter %s", __func__)
+#define IOH_TRACE_EXIT 	IOH_TRACE("Exit %s", __func__)
+
+
+#endif
diff --git a/drivers/char/pch_pcieqos/pch_pcieqos.c b/drivers/char/pch_pcieqos/pch_pcieqos.c
new file mode 100644
index 0000000..e0699d4
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_pcieqos.c
@@ -0,0 +1,400 @@
+/*!
+ * @file ioh_pcieqos.c
+ * @brief Provides all the implementation of the interfaces pertaining to the PCIEQOS module.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2009 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 06/20/2009
+ * modified:
+ *
+ */
+
+/* includes */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/string.h>
+
+#include "pch_common.h"
+#include "pch_debug.h"
+#include "pch_pcieqos.h"
+#include "pch_pcieqos_hal.h"
+
+#define MODULE_NAME "pch_pcieqos"
+
+/* global variables */
+s32 ioh_pcieqos_opencount;	/* check whether opened or not */
+
+DEFINE_SPINLOCK(ioh_pcieqos_lock);	/* for spin lock */
+
+/**
+ * file_operations structure initialization
+ */
+const struct file_operations ioh_pcieqos_fops = {
+	.owner = THIS_MODULE,
+	.open = ioh_pcieqos_open,
+	.release = ioh_pcieqos_release,
+	.unlocked_ioctl = ioh_pcieqos_ioctl,
+};
+
+/*function implementations*/
+
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn  int ioh_pcieqos_open( struct inode *inode,struct file *file)
+  @remarks  Implements the Initializing and opening of the pcieqos module.
+  @param  inode 	[@ref INOUT] Contains the reference of the inode
+								 structure
+  @param  file 	[@ref INOUT] Contains the reference of the file structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  EBUSY
+  */
+int ioh_pcieqos_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	spin_lock(&ioh_pcieqos_lock);
+	IOH_DEBUG("ioh_pcieqos_open : open count value = %d",
+		  ioh_pcieqos_opencount);
+	if (ioh_pcieqos_opencount) {
+		IOH_LOG(KERN_ERR,
+			"ioh_pcieqos_open :  device already opened\n");
+		ret = -EBUSY;
+	} else {
+		ioh_pcieqos_opencount++;
+		ret = IOH_PCIEQOS_SUCCESS;
+	}
+	spin_unlock(&ioh_pcieqos_lock);
+
+	IOH_DEBUG("ioh_pcieqos_open returns=%d\n", ret);
+	return ret;
+}
+
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn  int ioh_pcieqos_release(struct inode *inode,struct file *file)
+  @remarks  Implements the release functionality of the pcieqos module.
+  @param  inode 	[@ref INOUT] Contains the reference of the inode
+								 structure
+  @param  file 	[@ref INOUT] Contains the reference of the file structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  SUCCESS
+  */
+int ioh_pcieqos_release(struct inode *inode, struct file *file)
+{
+	spin_lock(&ioh_pcieqos_lock);
+
+	if (ioh_pcieqos_opencount > 0)
+		ioh_pcieqos_opencount--;
+	spin_unlock(&ioh_pcieqos_lock);
+
+	IOH_DEBUG("ioh_pcieqos_release : ioh_pcieqos_opencount =%d\n",
+		  ioh_pcieqos_opencount);
+
+	IOH_DEBUG("ioh_pcieqos_release returning=%d\n", IOH_PCIEQOS_SUCCESS);
+	return IOH_PCIEQOS_SUCCESS;
+}
+
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn  int ioh_pcieqos_ioctl(struct inode * inode,struct file * file,
+					 unsigned int cmd,unsigned long arg)
+  @remarks  Implements the various ioctl functionalities of the pcieqos module.
+  @param  file 	[@ref INOUT] Contains the reference of the file structure
+  @param  cmd 	[@ref IN] Contains the command value
+  @param  arg 	[@ref IN] Contains the command argument value
+  @retval returnvalue	[@ref OUT] contains the result for the concerned attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  EINVAL
+  EFAULT
+  */
+long ioh_pcieqos_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+
+	long ret_value = IOH_PCIEQOS_SUCCESS;
+	struct ioh_pcieqos_reqt __user *p_ioh_pcieqos_reqt;
+	unsigned long addr_offset;
+	unsigned long data;
+	unsigned long mask;
+
+	printk("ioh_pcieqos arguments:\n");
+	printk("\tfile: %p\n", file);
+	printk("\t  cmd: %x\n", cmd);
+	printk("\t  arg: %lx\n", arg);
+
+	printk("command summary:\n");
+	printk("\t%x: IOCTL_PCIEQOS_READ_MAC_ADDR\n", IOCTL_PCIEQOS_READ_MAC_ADDR); 
+	printk("\t%x: IOCTL_PCIEQOS_WRITE_MAC_ADDR\n", IOCTL_PCIEQOS_WRITE_MAC_ADDR); 
+
+	do {
+		if (ioh_pcieqos_suspended == true) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_ioctl : suspend initiated\
+							 returning =%d\n",
+				IOH_PCIEQOS_FAIL);
+			ret_value = IOH_PCIEQOS_FAIL;
+			break;
+		}
+
+		p_ioh_pcieqos_reqt = (struct ioh_pcieqos_reqt __user *)arg;
+		printk("%d: copy_from_user\n", __LINE__);
+		printk("\t&addr_offset: %p\n", &addr_offset);
+		printk("\t&reqt->addr_offset: %p\n", &p_ioh_pcieqos_reqt->addr_offset);
+		ret_value =
+		    copy_from_user(&addr_offset,
+				   &p_ioh_pcieqos_reqt->addr_offset,
+				   sizeof(addr_offset));
+		if (ret_value) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_ioctl : copy_from_user fail\
+							 returning =%d\n",
+				-EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		IOH_DEBUG("ioh_pcieqos_ioctl  : copy_from_user returns =%d\n",
+			  ret_value);
+
+		switch (cmd) {
+		case IOCTL_PCIEQOS_READ_REG:
+			{
+
+				ioh_pcieqos_read_reg(addr_offset, &data);
+				IOH_DEBUG
+				    ("ioh_pcieqos_ioctl  : Invoked\
+					 ioh_pcieqos_read_reg successfully\n");
+
+				ret_value =
+				    copy_to_user((void *)&p_ioh_pcieqos_reqt->
+						 data, (void *)&data,
+						 sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_to_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				break;
+			}
+
+		case IOCTL_PCIEQOS_WRITE_REG:
+			{
+
+				ret_value =
+				    copy_from_user((void *)&data,
+						   (void *)&p_ioh_pcieqos_reqt->
+						   data, sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_from_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				ioh_pcieqos_write_reg(addr_offset, data);
+				IOH_DEBUG
+				    ("ioh_pcieqos_ioctl  : Invoked\
+					 ioh_pcieqos_write_reg successfully\n");
+				break;
+			}
+
+		case IOCTL_PCIEQOS_READ_MODIFY_WRITE_REG:
+			{
+
+				ret_value =
+				    copy_from_user((void *)&data,
+						   (void *)&p_ioh_pcieqos_reqt->
+						   data, sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_from_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				ret_value =
+				    copy_from_user((void *)&mask,
+						   (void *)&p_ioh_pcieqos_reqt->
+						   mask, sizeof(mask));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_from_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				ioh_pcieqos_read_modify_write_reg(addr_offset,
+								  data, mask);
+				IOH_DEBUG
+				    ("ioh_pcieqos_ioctl  : Invoked\
+			 ioh_pcieqos_read_modify_write_reg successfully\n");
+				break;
+			}
+
+		case IOCTL_PCIEQOS_READ_OROM:
+			{
+
+				ret_value =
+				    ioh_pcieqos_read_serial_rom(addr_offset,
+							(unsigned char *)&data);
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+				 Invoked ioh_pcieqos_read_serial_rom =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				} else {
+					IOH_DEBUG
+					    ("ioh_pcieqos_ioctl  :\
+			 Invoked ioh_pcieqos_read_serial_rom successfully\n");
+				}
+
+				ret_value =
+				    copy_to_user((void *)&p_ioh_pcieqos_reqt->
+						 data, (void *)&data,
+						 sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_to_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				break;
+			}
+
+		case IOCTL_PCIEQOS_WRITE_OROM:
+			{
+
+				ret_value =
+				    copy_from_user((void *)&data,
+						   (void *)&p_ioh_pcieqos_reqt->
+						   data, sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_from_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				ret_value =
+				    ioh_pcieqos_write_serial_rom(addr_offset,
+								 data);
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+				 Invoked ioh_pcieqos_write_serial_rom =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				} else {
+					IOH_DEBUG
+					    ("ioh_pcieqos_ioctl  :\
+			 Invoked ioh_pcieqos_write_serial_rom successfully\n");
+				}
+				break;
+			}
+
+		case IOCTL_PCIEQOS_READ_MAC_ADDR:
+			{
+
+				ioh_pcieqos_read_gbe_mac_addr(addr_offset,
+						 (unsigned char *)&data);
+				IOH_DEBUG
+				    ("ioh_pcieqos_ioctl  : Invoked\
+				 ioh_pcieqos_read_gbe_mac_addr successfully\n");
+
+				ret_value =
+				    copy_to_user((void *)&p_ioh_pcieqos_reqt->
+						 data, (void *)&data,
+						 sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_to_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				break;
+			}
+
+		case IOCTL_PCIEQOS_WRITE_MAC_ADDR:
+			{
+
+				ret_value =
+				    copy_from_user((void *)&data,
+						   (void *)&p_ioh_pcieqos_reqt->
+						   data, sizeof(data));
+				if (ret_value) {
+					IOH_LOG(KERN_ERR,
+						"ioh_pcieqos_ioctl :\
+					 copy_from_user fail returning =%d\n",
+						-EFAULT);
+					ret_value = -EFAULT;
+					break;
+				}
+				ioh_pcieqos_write_gbe_mac_addr(addr_offset,
+							       data);
+				IOH_DEBUG
+				    ("ioh_pcieqos_ioctl  : Invoked\
+			 ioh_pcieqos_write_gbe_mac_addr successfully\n");
+				break;
+			}
+
+		default:
+			{
+				IOH_LOG(KERN_ERR,
+					"ioh_write_ioctl invalid command\
+							 returning=%d\n",
+					-EINVAL);
+				ret_value = -EINVAL;
+				break;
+			}
+		}
+		break;
+
+	} while (0);
+	IOH_LOG(KERN_ERR, "ioh_write_ioctl returns=%ld\n", ret_value);
+	return ret_value;
+}
diff --git a/drivers/char/pch_pcieqos/pch_pcieqos.h b/drivers/char/pch_pcieqos/pch_pcieqos.h
new file mode 100644
index 0000000..1b0512b
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_pcieqos.h
@@ -0,0 +1,193 @@
+#ifndef __IOH_PCIEQOS_H__
+#define __IOH_PCIEQOS_H__
+/*!
+ * @file ioh_pcieqos.h
+ * @brief Provides all the interfaces pertaining to the PCIEQOS module.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2008 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 06/20/2009
+ * modified:
+ *
+ */
+
+/*! @defgroup PCIEQOS */
+/*! @defgroup PCIEQOS_Global  				Global
+  @ingroup PCIEQOS */
+/*! @defgroup PCIEQOS_GlobalGeneral			General
+  @ingroup PCIEQOS_Global */
+/*! @defgroup PCIEQOS_GlobalResultCodes			StatusCodes
+  @ingroup PCIEQOS_Global */
+/*! @defgroup PCIEQOS_InterfaceLayer			InterfaceLayer
+  @ingroup PCIEQOS */
+/*! @defgroup PCIEQOS_InterfaceLayerAPI  		Providers
+  @ingroup PCIEQOS_InterfaceLayer
+  */
+/*! @defgroup PCIEQOS_InterfaceLayerNotifyRoutines  	Notifiers
+  @ingroup PCIEQOS_InterfaceLayer
+  */
+/*! @defgroup PCIEQOS_PCILayer				PCILayer
+  @ingroup PCIEQOS */
+/*! @defgroup PCIEQOS_PCILayerAPI  			Providers
+  @ingroup PCIEQOS_PCILayer
+  */
+/*! @defgroup PCIEQOS_PCILayerFacilitators  		Facilitators
+  @ingroup PCIEQOS_PCILayer
+  */
+/*! @defgroup PCIEQOS_HALLayer				HALLayer
+  @ingroup PCIEQOS */
+/*! @defgroup PCIEQOS_HALLayerAPI  			Providers
+  @ingroup PCIEQOS_HALLayer
+  */
+/*! @defgroup PCIEQOS_HALLayerFacilitators  		Facilitators
+  @ingroup PCIEQOS_HALLayer
+  */
+/*! @defgroup PCIEQOS_Utilities				Utilities
+  @ingroup PCIEQOS */
+/*! @defgroup PCIEQOS_UtilitiesAPI  			Providers
+  @ingroup PCIEQOS_Utilities
+  */
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def PCIEQOS_IOCTL_MAGIC
+  @brief Outlines the ioctl magic.
+  */
+#define PCIEQOS_IOCTL_MAGIC 		(0xf7)
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_READ_REG
+  @brief Outlines the read register function signature.
+  */
+#define IOCTL_PCIEQOS_READ_REG (_IOW(PCIEQOS_IOCTL_MAGIC, 1, unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_WRITE_REG
+  @brief Outlines the write register function signature.
+  */
+#define IOCTL_PCIEQOS_WRITE_REG (_IOW(PCIEQOS_IOCTL_MAGIC, 2, unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_READ_MODIFY_WRITE_REG
+  @brief Outlines the read, modify and write register function signature.
+  */
+#define IOCTL_PCIEQOS_READ_MODIFY_WRITE_REG (_IOW(PCIEQOS_IOCTL_MAGIC, 3,\
+								 unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_READ_OROM
+  @brief Outlines the read option rom function signature.
+  */
+#define IOCTL_PCIEQOS_READ_OROM (_IOW(PCIEQOS_IOCTL_MAGIC, 4, unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_WRITE_OROM
+  @brief Outlines the write option rom function signature.
+  */
+#define IOCTL_PCIEQOS_WRITE_OROM (_IOW(PCIEQOS_IOCTL_MAGIC, 5, unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_READ_MAC_ADDR
+  @brief Outlines the read mac address function signature.
+  */
+#define IOCTL_PCIEQOS_READ_MAC_ADDR (_IOW(PCIEQOS_IOCTL_MAGIC, 6,\
+								 unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def IOCTL_PCIEQOS_WRITE_MAC_ADDR
+  @brief Outlines the write mac address function signature.
+  */
+#define IOCTL_PCIEQOS_WRITE_MAC_ADDR (_IOW(PCIEQOS_IOCTL_MAGIC, 7,\
+								 unsigned long))
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def PCIEQOS STATUS CODE
+  @brief Outlines PCIEQOS SUCCESS STATUS CODE
+  */
+#define IOH_PCIEQOS_SUCCESS 	(0)
+
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @def PCIEQOS STATUS CODE
+  @brief Outlines PCIEQOS ERROR STATUS CODE
+  */
+#define IOH_PCIEQOS_FAIL 		(-1)
+
+/* Registers address offset */
+#define IOH_PCIEQOS_PHUB_ID_REG			(0x0000)
+#define IOH_PCIEQOS_QUEUE_PRI_VAL_REG		(0x0004)
+#define IOH_PCIEQOS_RC_QUEUE_MAXSIZE_REG	(0x0008)
+#define IOH_PCIEQOS_BRI_QUEUE_MAXSIZE_REG	(0x000C)
+#define IOH_PCIEQOS_COMP_RESP_TIMEOUT_REG	(0x0010)
+#define IOH_PCIEQOS_BUS_SLAVE_CONTROL_REG	(0x0014)
+#define IOH_PCIEQOS_DEADLOCK_AVOID_TYPE_REG	(0x0018)
+#define IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG0	(0x0020)
+#define IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG1	(0x0024)
+#define IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG2	(0x0028)
+#define IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG3	(0x002C)
+#define IOH_PCIEQOS_INT_REDUCE_CONTROL_REG_BASE	(0x0040)
+#define CLKCFG_REG_OFFSET           		(0x500)
+
+/*structures*/
+/*! @ingroup PCIEQOS_InterfaceLayer
+  @struct ioh_pcieqos_reqt
+  @brief It is a structure used for perserving information related to the
+  pcieqos request.
+  @note
+  The concerned details should be provided during the read register,
+   write register and read / modify / write register.
+  @see
+  ioh_pcieqos_ioctl
+  */
+struct ioh_pcieqos_reqt {
+	unsigned long addr_offset;	/*specifies the register address
+								 offset */
+	unsigned long data;	/*specifies the data */
+	unsigned long mask;	/*specifies the mask */
+};
+
+/* exported function prototypes */
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn nt ioh_pcieqos_open( struct inode *inode,struct file *file )
+  @brief  Provides the functionality of initialization of the module
+  */
+int ioh_pcieqos_open(struct inode *inode, struct file *file);
+
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn int ioh_pcieqos_release(struct inode *inode,struct file *file)
+  @brief  Provides the functionality of releasing the module
+  */
+int ioh_pcieqos_release(struct inode *inode, struct file *file);
+
+/*! @ingroup PCIEQOS_InterfaceLayerAPI
+  @fn long ioh_pcieqos_ioctl(struct file * file, unsigned int cmd, unsigned long arg)
+  @brief  Provides the functionality of invoking various functionalities of
+								 the PCIEQOS.
+  */
+long ioh_pcieqos_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+/**global variables*/
+extern u32 ioh_pcieqos_base_address;	/* base address */
+extern s32 ioh_pcieqos_suspended;	/* suspend status */
+
+extern s32 ioh_pcieqos_opencount;
+extern spinlock_t ioh_pcieqos_lock;
+extern const struct file_operations ioh_pcieqos_fops;
+#endif
diff --git a/drivers/char/pch_pcieqos/pch_pcieqos_hal.c b/drivers/char/pch_pcieqos/pch_pcieqos_hal.c
new file mode 100644
index 0000000..a312a23
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_pcieqos_hal.c
@@ -0,0 +1,550 @@
+/*!
+ * @file ioh_pcieqos_hal.c
+ * @brief Provides all the implementation of the interfaces pertaining to the
+ * 									 HAL.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2009 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 06/20/2009
+ * modified:
+ *
+ */
+
+/*includes*/
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include "pch_common.h"
+#include "pch_debug.h"
+#include "pch_pcieqos.h"
+#include "pch_pcieqos_hal.h"
+
+/* Status Register offset */
+#define PCIEQOS_STATUS (0x00)
+
+/* Control Register offset */
+#define PCIEQOS_CONTROL (0x04)
+
+/* Time out value for Status Register */
+#define PCIEQOS_TIMEOUT (0x05)
+
+/* Enabling for writing ROM */
+#define IOH_PCIEQOS_ROM_WRITE_ENABLE (0x01)
+
+/* Disabling for writing ROM */
+#define IOH_PCIEQOS_ROM_WRITE_DISABLE (0x00)
+
+/* ROM data area start address offset */
+#define IOH_PCIEQOS_ROM_START_ADDR (0x14)
+
+/* MAX number of INT_REDUCE_CONTROL registers */
+#define MAX_NUM_INT_REDUCE_CONTROL_REG (128)
+
+/* global variables */
+struct ioh_pcieqos_reg {
+	u32 phub_id_reg;	/* PHUB_ID register val */
+	u32 q_pri_val_reg;	/* QUEUE_PRI_VAL register val */
+	u32 rc_q_maxsize_reg;	/* RC_QUEUE_MAXSIZE register val */
+	u32 bri_q_maxsize_reg;	/* BRI_QUEUE_MAXSIZE register val */
+	u32 comp_resp_timeout_reg;	/* COMP_RESP_TIMEOUT register val */
+	u32 bus_slave_control_reg;	/* BUS_SLAVE_CONTROL_REG register val */
+	u32 deadlock_avoid_type_reg;	/* DEADLOCK_AVOID_TYPE register val */
+	u32 intpin_reg_wpermit_reg0;	/* INTPIN_REG_WPERMIT register 0 val */
+	u32 intpin_reg_wpermit_reg1;	/* INTPIN_REG_WPERMIT register 1 val */
+	u32 intpin_reg_wpermit_reg2;	/* INTPIN_REG_WPERMIT register 2 val */
+	u32 intpin_reg_wpermit_reg3;	/* INTPIN_REG_WPERMIT register 3 val */
+	/* INT_REDUCE_CONTROL registers val */
+	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
+#ifdef IOH_CAN_PCLK_50MHZ
+	u32 clkcfg_reg;		/* CLK CFG register val */
+#endif
+} g_ioh_pcieqos_reg;
+
+/*functions implementations*/
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_read_reg(unsigned long reg_addr_offset,
+							 unsigned long *data)
+  @remarks  Implements the functionality of reading register.
+  @param  reg_addr_offset [@ref IN] Contains the register offset address value
+  @param  *data           [@ref INOUT] Contains the register value
+  @retval NONE
+  @see
+  */
+void ioh_pcieqos_read_reg(unsigned long reg_addr_offset, unsigned long *data)
+{
+	unsigned long reg_addr = ioh_pcieqos_base_address + reg_addr_offset;
+	*data = IOH_READ32(reg_addr);
+
+	return;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_write_reg(unsigned long reg_addr_offset,
+							 unsigned long data)
+  @remarks  Implements the functionality of writing register.
+  @param  reg_addr_offset [@ref IN] Contains the register offset address value
+  @param  data            [@ref IN] Contains the writing value
+  @retval NONE
+  @see
+  */
+void ioh_pcieqos_write_reg(unsigned long reg_addr_offset, unsigned long data)
+{
+	unsigned long reg_addr = ioh_pcieqos_base_address + reg_addr_offset;
+	IOH_WRITE32(data, reg_addr);
+
+	return;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_read_modify_write_reg(unsigned long reg_addr_offset,
+					 unsigned long data, unsigned long mask)
+  @remarks  Implements the functionality of reading, modifying and writing
+								 register.
+  @param  reg_addr_offset [@ref IN] Contains the register offset address value
+  @param  data            [@ref IN] Contains the writing value
+  @param  mask            [@ref IN] Contains the mask value
+  @retval NONE
+  @see
+  */
+void ioh_pcieqos_read_modify_write_reg(unsigned long reg_addr_offset,
+				       unsigned long data, unsigned long mask)
+{
+	unsigned long reg_addr = ioh_pcieqos_base_address + reg_addr_offset;
+	IOH_WRITE32(((IOH_READ32(reg_addr) & ~mask)) | data, reg_addr);
+
+	return;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_read_gbe_mac_addr(unsigned long offset_address,
+							 unsigned char *data)
+  @param  unsigned long offset_address [@ref IN] Contains the Gigabit
+					 Ethernet MAC address offset value
+  @param  *data                        [@ref INOUT] Contains the Gigabit
+						 Ethernet MAC address value
+  @retval return value	               [@ref OUT] contains the result
+			 for the reading Gigabit Ethernet MAC address attempt
+  @see
+  */
+int ioh_pcieqos_read_gbe_mac_addr(unsigned long offset_address,
+				  unsigned char *data)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+
+	retval = ioh_pcieqos_read_serial_rom_val(offset_address, data);
+
+	return retval;
+}
+EXPORT_SYMBOL(ioh_pcieqos_read_gbe_mac_addr);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_write_gbe_mac_addr(unsigned long offset_address,
+							 unsigned char data)
+  @param  unsigned long offset_address [@ref IN] Contains the Gigabit
+					 Ethernet MAC address offset value
+  @param  data                         [@ref IN] Contains the Gigabit Ethernet
+							 MAC address value
+  @retval return value	               [@ref OUT] contains the result for the
+				 writing Gigabit Ethernet MAC address attempt
+  @see
+  */
+int ioh_pcieqos_write_gbe_mac_addr(unsigned long offset_address,
+				   unsigned char data)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+
+	retval = ioh_pcieqos_gbe_serial_rom_conf();
+	retval |= ioh_pcieqos_write_serial_rom_val(offset_address, data);
+
+	return retval;
+}
+EXPORT_SYMBOL(ioh_pcieqos_write_gbe_mac_addr);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_save_reg_conf(void)
+  @remarks  saves register configuration
+  @param NONE
+  @retval  NONE
+  @see
+  ioh_pcieqos_suspend
+  */
+void ioh_pcieqos_save_reg_conf(void)
+{
+	u32 base_addr = ioh_pcieqos_base_address;
+	u32 i = 0;
+
+	IOH_DEBUG("ioh_pcieqos_save_reg_conf ENTRY\n");
+	/* to store contents of PHUB_ID register */
+	g_ioh_pcieqos_reg.phub_id_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_PHUB_ID_REG);
+	/* to store contents of QUEUE_PRI_VAL register */
+	g_ioh_pcieqos_reg.q_pri_val_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_QUEUE_PRI_VAL_REG);
+	/* to store contents of RC_QUEUE_MAXSIZE register */
+	g_ioh_pcieqos_reg.rc_q_maxsize_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_RC_QUEUE_MAXSIZE_REG);
+	/* to store contents of BRI_QUEUE_MAXSIZE register */
+	g_ioh_pcieqos_reg.bri_q_maxsize_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_BRI_QUEUE_MAXSIZE_REG);
+	/* to store contents of COMP_RESP_TIMEOUT register */
+	g_ioh_pcieqos_reg.comp_resp_timeout_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_COMP_RESP_TIMEOUT_REG);
+	/* to store contents of BUS_SLAVE_CONTROL_REG register */
+	g_ioh_pcieqos_reg.bus_slave_control_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_BUS_SLAVE_CONTROL_REG);
+	/* to store contents of DEADLOCK_AVOID_TYPE register */
+	g_ioh_pcieqos_reg.deadlock_avoid_type_reg =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_DEADLOCK_AVOID_TYPE_REG);
+	/* to store contents of INTPIN_REG_WPERMIT register 0 */
+	g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0 =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG0);
+	/* to store contents of INTPIN_REG_WPERMIT register 1 */
+	g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1 =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG1);
+	/* to store contents of INTPIN_REG_WPERMIT register 2 */
+	g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2 =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG2);
+	/* to store contents of INTPIN_REG_WPERMIT register 3 */
+	g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3 =
+	    IOH_READ32(base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG3);
+	IOH_DEBUG
+	    ("ioh_pcieqos_save_reg_conf : g_ioh_pcieqos_reg.phub_id_reg=%x, \
+		g_ioh_pcieqos_reg.q_pri_val_reg=%x, \
+		g_ioh_pcieqos_reg.rc_q_maxsize_reg=%x, \
+		g_ioh_pcieqos_reg.bri_q_maxsize_reg=%x, \
+		g_ioh_pcieqos_reg.comp_resp_timeout_reg=%x, \
+		g_ioh_pcieqos_reg.bus_slave_control_reg=%x, \
+		g_ioh_pcieqos_reg.deadlock_avoid_type_reg=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3=%x\n",
+		g_ioh_pcieqos_reg.phub_id_reg,
+		g_ioh_pcieqos_reg.q_pri_val_reg,
+		g_ioh_pcieqos_reg.rc_q_maxsize_reg,
+		g_ioh_pcieqos_reg.bri_q_maxsize_reg,
+		g_ioh_pcieqos_reg.comp_resp_timeout_reg,
+		g_ioh_pcieqos_reg.bus_slave_control_reg,
+		g_ioh_pcieqos_reg.deadlock_avoid_type_reg,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3);
+	/* to store contents of INT_REDUCE_CONTROL registers */
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		g_ioh_pcieqos_reg.int_reduce_control_reg[i] =
+		    IOH_READ32(base_addr +
+			       IOH_PCIEQOS_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		IOH_DEBUG
+		    ("ioh_pcieqos_save_reg_conf : \
+			g_ioh_pcieqos_reg.int_reduce_control_reg[%d]=%x\n",
+		     i, g_ioh_pcieqos_reg.int_reduce_control_reg[i]);
+	}
+#ifdef IOH_CAN_PCLK_50MHZ
+	/* save clk cfg register */
+	g_ioh_pcieqos_reg.clkcfg_reg =
+	    IOH_READ32(base_addr + CLKCFG_REG_OFFSET);
+#endif
+	return;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_restore_reg_conf(void)
+  @remarks  restore register configuration
+  @param NONE
+  @retval  NONE
+  @see
+  ioh_pcieqos_resume
+  */
+void ioh_pcieqos_restore_reg_conf(void)
+{
+	u32 base_addr = ioh_pcieqos_base_address;
+	u32 i = 0;
+
+	IOH_DEBUG("ioh_pcieqos_restore_reg_conf ENTRY\n");
+	/* to store contents of PHUB_ID register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.phub_id_reg,
+		    base_addr + IOH_PCIEQOS_PHUB_ID_REG);
+	/* to store contents of QUEUE_PRI_VAL register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.q_pri_val_reg,
+		    base_addr + IOH_PCIEQOS_QUEUE_PRI_VAL_REG);
+	/* to store contents of RC_QUEUE_MAXSIZE register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.rc_q_maxsize_reg,
+		    base_addr + IOH_PCIEQOS_RC_QUEUE_MAXSIZE_REG);
+	/* to store contents of BRI_QUEUE_MAXSIZE register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.bri_q_maxsize_reg,
+		    base_addr + IOH_PCIEQOS_BRI_QUEUE_MAXSIZE_REG);
+	/* to store contents of COMP_RESP_TIMEOUT register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.comp_resp_timeout_reg,
+		    base_addr + IOH_PCIEQOS_COMP_RESP_TIMEOUT_REG);
+	/* to store contents of BUS_SLAVE_CONTROL_REG register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.bus_slave_control_reg,
+		    base_addr + IOH_PCIEQOS_BUS_SLAVE_CONTROL_REG);
+	/* to store contents of DEADLOCK_AVOID_TYPE register */
+	IOH_WRITE32(g_ioh_pcieqos_reg.deadlock_avoid_type_reg,
+		    base_addr + IOH_PCIEQOS_DEADLOCK_AVOID_TYPE_REG);
+	/* to store contents of INTPIN_REG_WPERMIT register 0 */
+	IOH_WRITE32(g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0,
+		    base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG0);
+	/* to store contents of INTPIN_REG_WPERMIT register 1 */
+	IOH_WRITE32(g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1,
+		    base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG1);
+	/* to store contents of INTPIN_REG_WPERMIT register 2 */
+	IOH_WRITE32(g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2,
+		    base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG2);
+	/* to store contents of INTPIN_REG_WPERMIT register 3 */
+	IOH_WRITE32(g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3,
+		    base_addr + IOH_PCIEQOS_INTPIN_REG_WPERMIT_REG3);
+	IOH_DEBUG
+	    ("ioh_pcieqos_save_reg_conf : g_ioh_pcieqos_reg.phub_id_reg=%x, \
+		g_ioh_pcieqos_reg.q_pri_val_reg=%x, \
+		g_ioh_pcieqos_reg.rc_q_maxsize_reg=%x, \
+		g_ioh_pcieqos_reg.bri_q_maxsize_reg=%x, \
+		g_ioh_pcieqos_reg.comp_resp_timeout_reg=%x, \
+		g_ioh_pcieqos_reg.bus_slave_control_reg=%x, \
+		g_ioh_pcieqos_reg.deadlock_avoid_type_reg=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2=%x, \
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3=%x\n",
+		g_ioh_pcieqos_reg.phub_id_reg, g_ioh_pcieqos_reg.q_pri_val_reg,
+		g_ioh_pcieqos_reg.rc_q_maxsize_reg,
+		g_ioh_pcieqos_reg.bri_q_maxsize_reg,
+		g_ioh_pcieqos_reg.comp_resp_timeout_reg,
+		g_ioh_pcieqos_reg.bus_slave_control_reg,
+		g_ioh_pcieqos_reg.deadlock_avoid_type_reg,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg0,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg1,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg2,
+		g_ioh_pcieqos_reg.intpin_reg_wpermit_reg3);
+	/* to store contents of INT_REDUCE_CONTROL register */
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		IOH_WRITE32(g_ioh_pcieqos_reg.int_reduce_control_reg[i],
+			    base_addr +
+			    IOH_PCIEQOS_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		IOH_DEBUG
+		    ("ioh_pcieqos_save_reg_conf : \
+			g_ioh_pcieqos_reg.int_reduce_control_reg[%d]=%x\n",
+			i, g_ioh_pcieqos_reg.int_reduce_control_reg[i]);
+	}
+
+#ifdef IOH_CAN_PCLK_50MHZ
+	/*restore the clock config reg */
+	IOH_WRITE32(g_ioh_pcieqos_reg.clkcfg_reg,
+		    base_addr + CLKCFG_REG_OFFSET);
+#endif
+
+	return;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_read_serial_rom(unsigned long offset_address,
+							 unsigned char *data)
+  @remarks  Implements the functionality of reading Serial ROM.
+  @param  unsigned long offset_address [@ref IN] Contains the Serial ROM
+							 address offset value
+  @param  *data                        [@ref INOUT] Contains the Serial
+								 ROM value
+  @retval returnvalue	[@ref OUT] contains the result for the reading Serial
+								 ROM attempt
+  @see
+  */
+int ioh_pcieqos_read_serial_rom(unsigned long offset_address,
+				unsigned char *data)
+{
+	unsigned long mem_addr =
+	    ioh_pcieqos_extrom_base_address + offset_address;
+
+	IOH_DEBUG("ioh_pcieqos_read_serial_rom:mem_addr=0x%08x\n", mem_addr);
+	*data = IOH_READ8(mem_addr);
+
+	return IOH_PCIEQOS_SUCCESS;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_write_serial_rom(unsigned long offset_address,
+							 unsigned char data)
+  @remarks  Implements the functionality of writing Serial ROM.
+  @param  unsigned long offset_address [@ref IN] Contains the Serial ROM
+							 address offset value
+  @param  data                         [@ref IN] Contains the Serial ROM value
+  @retval returnvalue	[@ref OUT] contains the result for the writing Serial
+								 ROM attempt
+  @see
+  */
+int ioh_pcieqos_write_serial_rom(unsigned long offset_address,
+				 unsigned char data)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+	unsigned long mem_addr =
+	    ioh_pcieqos_extrom_base_address + offset_address;
+	int i = 0;
+	unsigned long word_data = 0;
+
+	IOH_DEBUG("ioh_pcieqos_write_serial_rom:mem_addr=0x%08x\n", mem_addr);
+	IOH_WRITE32(IOH_PCIEQOS_ROM_WRITE_ENABLE,
+		    ioh_pcieqos_extrom_base_address + PCIEQOS_CONTROL);
+
+	word_data = IOH_READ32((mem_addr & 0xFFFFFFFC));
+	IOH_DEBUG("word_data=0x%08x\n", word_data);
+	IOH_DEBUG("data=0x%02x\n", data);
+	switch (mem_addr % 4) {
+	case 0:
+		{
+			word_data &= 0xFFFFFF00;
+			IOH_WRITE32((word_data | (unsigned long)data),
+				    (mem_addr & 0xFFFFFFFC));
+		}
+	case 1:
+		{
+			word_data &= 0xFFFF00FF;
+			IOH_WRITE32((word_data | ((unsigned long)data << 8)),
+				    (mem_addr & 0xFFFFFFFC));
+		}
+	case 2:
+		{
+			word_data &= 0xFF00FFFF;
+			IOH_WRITE32((word_data | ((unsigned long)data << 16)),
+				    (mem_addr & 0xFFFFFFFC));
+		}
+	case 3:
+		{
+			word_data &= 0x00FFFFFF;
+			IOH_WRITE32((word_data | ((unsigned long)data << 24)),
+				    (mem_addr & 0xFFFFFFFC));
+		}
+	}
+	while (0x00 !=
+	       IOH_READ8(ioh_pcieqos_extrom_base_address + PCIEQOS_STATUS)) {
+		msleep(1);
+		if (PCIEQOS_TIMEOUT == i) {
+			retval = IOH_PCIEQOS_FAIL;
+			break;
+		}
+		i++;
+	}
+
+	IOH_WRITE32(IOH_PCIEQOS_ROM_WRITE_DISABLE,
+		    ioh_pcieqos_extrom_base_address + PCIEQOS_CONTROL);
+
+	return retval;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_read_serial_rom_val(unsigned long offset_address,
+							 unsigned char *data)
+  @remarks  Implements the functionality of reading Serial ROM value.
+  @param  unsigned long offset_address [@ref IN] Contains the Serial ROM
+							 address offset value
+  @param  *data                        [@ref INOUT] Contains the Serial
+								 ROM value
+  @retval returnvalue	[@ref OUT] contains the result for the reading Serial
+								 ROM attempt
+  @see
+  */
+int ioh_pcieqos_read_serial_rom_val(unsigned long offset_address,
+				    unsigned char *data)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+	unsigned long mem_addr;
+
+	mem_addr =
+	    (offset_address / 4 * 8) + 3 - (offset_address % 4) +
+	    IOH_PCIEQOS_ROM_START_ADDR;
+	retval = ioh_pcieqos_read_serial_rom(mem_addr, data);
+
+	return retval;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn  void ioh_pcieqos_write_serial_rom_val(unsigned long offset_address,
+							 unsigned char data)
+  @remarks  Implements the functionality of writing Serial ROM value.
+  @param  unsigned long offset_address [@ref IN] Contains the Serial ROM
+							 address offset value
+  @param  data                         [@ref IN] Contains the Serial ROM value
+  @retval returnvalue	[@ref OUT] contains the result for the writing Serial
+								 ROM attempt
+  @see
+  */
+int ioh_pcieqos_write_serial_rom_val(unsigned long offset_address,
+				     unsigned char data)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+	unsigned long mem_addr;
+
+	mem_addr =
+	    (offset_address / 4 * 8) + 3 - (offset_address % 4) +
+	    IOH_PCIEQOS_ROM_START_ADDR;
+	retval = ioh_pcieqos_write_serial_rom(mem_addr, data);
+
+	return retval;
+}
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_gbe_serial_rom_conf(void)
+  @remarks  makes Serial ROM header format configuration for Gigabit Ethernet
+								 MAC address
+  @param NONE
+  @retval returnvalue	[@ref OUT] contains the result for the writing Serial
+								 ROM attempt
+  @see
+  */
+int ioh_pcieqos_gbe_serial_rom_conf(void)
+{
+	int retval = IOH_PCIEQOS_SUCCESS;
+
+	retval |= ioh_pcieqos_write_serial_rom(0x0b, 0xbc);
+	retval |= ioh_pcieqos_write_serial_rom(0x0a, 0x10);
+	retval |= ioh_pcieqos_write_serial_rom(0x09, 0x01);
+	retval |= ioh_pcieqos_write_serial_rom(0x08, 0x02);
+
+	retval |= ioh_pcieqos_write_serial_rom(0x0f, 0x00);
+	retval |= ioh_pcieqos_write_serial_rom(0x0e, 0x00);
+	retval |= ioh_pcieqos_write_serial_rom(0x0d, 0x00);
+	retval |= ioh_pcieqos_write_serial_rom(0x0c, 0x80);
+
+	retval |= ioh_pcieqos_write_serial_rom(0x13, 0xbc);
+	retval |= ioh_pcieqos_write_serial_rom(0x12, 0x10);
+	retval |= ioh_pcieqos_write_serial_rom(0x11, 0x01);
+	retval |= ioh_pcieqos_write_serial_rom(0x10, 0x18);
+
+	retval |= ioh_pcieqos_write_serial_rom(0x1b, 0xbc);
+	retval |= ioh_pcieqos_write_serial_rom(0x1a, 0x10);
+	retval |= ioh_pcieqos_write_serial_rom(0x19, 0x01);
+	retval |= ioh_pcieqos_write_serial_rom(0x18, 0x19);
+
+	retval |= ioh_pcieqos_write_serial_rom(0x23, 0xbc);
+	retval |= ioh_pcieqos_write_serial_rom(0x22, 0x10);
+	retval |= ioh_pcieqos_write_serial_rom(0x21, 0x01);
+	retval |= ioh_pcieqos_write_serial_rom(0x20, 0x3a);
+
+	retval |= ioh_pcieqos_write_serial_rom(0x27, 0x01);
+	retval |= ioh_pcieqos_write_serial_rom(0x26, 0x00);
+	retval |= ioh_pcieqos_write_serial_rom(0x25, 0x00);
+	retval |= ioh_pcieqos_write_serial_rom(0x24, 0x00);
+
+	return retval;
+}
+
diff --git a/drivers/char/pch_pcieqos/pch_pcieqos_hal.h b/drivers/char/pch_pcieqos/pch_pcieqos_hal.h
new file mode 100644
index 0000000..bd84c96
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_pcieqos_hal.h
@@ -0,0 +1,125 @@
+#ifndef __IOH_PCIEQOS_HAL_H__
+#define __IOH_PCIEQOS_HAL_H__
+/*!
+ * @file ioh_pcieqos_hal.h
+ * @brief Provides all the interfaces pertaining to the HAL.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2009 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 06/20/2009
+ * modified:
+ *
+ */
+
+/* exported function prototypes */
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn void ioh_pcieqos_read_reg(unsigned long reg_addr_offset,
+							 unsigned long *data)
+  @brief  Provides the functionality of reading register
+  */
+void ioh_pcieqos_read_reg(unsigned long reg_addr_offset, unsigned long *data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn ioh_pcieqos_write_reg(unsigned long reg_addr_offset, unsigned long data)
+  @brief  Provides the functionality of writing register
+  */
+void ioh_pcieqos_write_reg(unsigned long reg_addr_offset, unsigned long data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn ioh_pcieqos_read_modify_write_reg(unsigned long reg_addr_offset,
+					 unsigned long data, unsigned long mask)
+  @brief  Provides the functionality of reading, modifying and writing register
+  */
+void ioh_pcieqos_read_modify_write_reg(unsigned long reg_addr_offset,
+				       unsigned long data, unsigned long mask);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_read_gbe_mac_addr(unsigned long offset_address,
+							 unsigned char *data)
+  @brief  Provides the functionality of reading Gigabit Ethernet MAC address
+  */
+int ioh_pcieqos_read_gbe_mac_addr(unsigned long offset_address,
+				  unsigned char *data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_write_gbe_mac_addr(unsigned long offset_address,
+							 unsigned char data)
+  @brief  Provides the functionality of writing Gigabit Ethernet MAC address
+  */
+int ioh_pcieqos_write_gbe_mac_addr(unsigned long offset_address,
+				   unsigned char data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn void ioh_pcieqos_save_reg_conf(void)
+  @brief  saves register configuration
+  */
+void ioh_pcieqos_save_reg_conf(void);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn void ioh_pcieqos_restore_reg_conf(void)
+  @brief  restores register configuration
+  */
+void ioh_pcieqos_restore_reg_conf(void);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_read_serial_rom(unsigned long offset_address,
+							 unsigned char *data)
+  @brief  Provides the functionality of reading Serial ROM
+  */
+int ioh_pcieqos_read_serial_rom(unsigned long offset_address,
+				unsigned char *data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_write_serial_rom(unsigned long offset_address,
+							 unsigned char data)
+  @brief  Provides the functionality of writing Serial ROM
+  */
+int ioh_pcieqos_write_serial_rom(unsigned long offset_address,
+				 unsigned char data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_read_serial_rom_val(unsigned long offset_address,
+							 unsigned char *data)
+  @brief  Provides the functionality of reading Serial ROM value
+  */
+int ioh_pcieqos_read_serial_rom_val(unsigned long offset_address,
+				    unsigned char *data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_write_serial_rom_val(unsigned long offset_address,
+							 unsigned char data)
+  @brief  Provides the functionality of writing Serial ROM value
+  */
+int ioh_pcieqos_write_serial_rom_val(unsigned long offset_address,
+				     unsigned char data);
+
+/*! @ingroup PCIEQOS_HALLayerAPI
+  @fn int ioh_pcieqos_gbe_serial_rom_conf(void)
+  @brief  makes Serial ROM data format configuration for Gigabit Ethernet
+								 MAC address
+  */
+int ioh_pcieqos_gbe_serial_rom_conf(void);
+
+/* global variables */
+extern u32 ioh_pcieqos_base_address;
+extern u32 ioh_pcieqos_extrom_base_address;
+#endif
diff --git a/drivers/char/pch_pcieqos/pch_pcieqos_pci.c b/drivers/char/pch_pcieqos/pch_pcieqos_pci.c
new file mode 100644
index 0000000..a288415
--- /dev/null
+++ b/drivers/char/pch_pcieqos/pch_pcieqos_pci.c
@@ -0,0 +1,523 @@
+/*!
+ * @file ioh_pcieqos_pci.c
+ * @brief Provides all the implementation of the interfaces pertaining to the
+ * 						 pci and gpic registrations.
+ * @version 1.0.0.0
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2009 OKI SEMICONDUCTOR Co., LTD.
+ * All rights reserved.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 06/20/2009
+ * modified:
+ *
+ */
+/*includes*/
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/string.h>
+
+#include "pch_common.h"
+#include "pch_debug.h"
+#include "pch_pcieqos.h"
+#include "pch_pcieqos_hal.h"
+
+/*macros*/
+
+/*! @ingroup PCIEQOS_PCILayer
+  @def PCI_DEVICE_ID_IOH1_PCIEQOS
+  @brief Outlines the PCI Device ID.
+  */
+#define PCI_DEVICE_ID_IOH1_PCIEQOS (0x8801)
+
+/*! @ingroup PCIEQOS_PCILayer
+  @def IOH_MINOR_NOS
+  @brief Outlines the PCIEQOS minor numbers limit.
+  */
+#define IOH_MINOR_NOS (1)
+
+/*values for configuring CLKCFG reg
+ * for CAN clock of 50Mhz*/
+
+/*! @ingroup PCIEQOS_PCILayer
+  @def CLKCFG_CAN_50MHZ
+  @brief CLKCFG register setting for CAN clock of 50Mhz.
+  */
+#define CLKCFG_CAN_50MHZ (0x12000000)
+
+/*! @ingroup PCIEQOS_PCILayer
+  @def CLKCFG_CANCLK_MASK
+  @brief Bit mask for bit fields in CLKCFG register
+	     to set CAN clock to 50Mhz.
+  */
+#define CLKCFG_CANCLK_MASK (0xFF000000)
+
+/**global variables*/
+u32 ioh_pcieqos_base_address;
+u32 ioh_pcieqos_extrom_base_address;
+s32 ioh_pcieqos_suspended;
+
+/* ToDo: major number allocation via module parameter */
+static dev_t ioh_pcieqos_dev_no;
+static int ioh_pcieqos_major_no;
+
+static struct cdev ioh_pcieqos_dev;
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static int __devinit ioh_pcieqos_probe(struct pci_dev* ioh_pci_dev,
+					 const struct pci_device_id* pci_id)
+  @brief  Provides the functionality of probing the module
+  */
+static int __devinit ioh_pcieqos_probe(struct pci_dev *pdev, const
+				       struct pci_device_id *id);
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static void __devexit ioh_pcieqos_remove(struct pci_dev * ioh_pci_dev)
+  @brief  Provides the functionality of removing the module
+  */
+static void __devexit ioh_pcieqos_remove(struct pci_dev *pdev);
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static int ioh_pcieqos_suspend(struct pci_dev* pDev,pm_message_t state)
+  @brief  Provides the functionality of suspending the module
+  */
+static int ioh_pcieqos_suspend(struct pci_dev *pdev, pm_message_t state);
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static int ioh_pcieqos_resume(struct pci_dev* pDev)
+  @brief  Provides the functionality of resuming the module
+  */
+static int ioh_pcieqos_resume(struct pci_dev *pdev);
+
+/*structures*/
+/*! @ingroup PCIEQOS_PCILayerFacilitators
+  @static struct pci_device_id
+  @brief It is a structure used for perserving information related to the
+  device id.
+  @note
+  The concerned details should be provided as a reference in the pci driver
+  structure.
+  */
+static struct pci_device_id ioh_pcieqos_pcidev_id[] = {
+
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_IOH1_PCIEQOS)},
+	{0,}
+};
+
+/*! @ingroup PCIEQOS_PCILayerFacilitators
+  @static struct ioh_pcieqos_driver
+  @brief It is a structure used for perserving information related to the
+  pcieqos device and preserves function signatures to manipulate the device.
+  @note
+  The structure contains the various interfaces aspects
+  provided to the pci layer.
+  @see
+  ioh_pcieqos_probe
+  ioh_pcieqos_suspend
+  ioh_pcieqos_resume
+  ioh_pcieqos_remove
+  */
+static struct pci_driver ioh_pcieqos_driver = {
+	.name = "ioh_pcieqos",
+	.id_table = ioh_pcieqos_pcidev_id,
+	.probe = ioh_pcieqos_probe,
+	.remove = __devexit_p(ioh_pcieqos_remove),
+#ifdef CONFIG_PM
+	.suspend = ioh_pcieqos_suspend,
+	.resume = ioh_pcieqos_resume
+#endif
+};
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+ * @fn static int __init ioh_pcieqos_pci_init(void)
+ * @brief  Provides the functionality of initializing the module
+ * */
+static int __init ioh_pcieqos_pci_init(void);
+/*! @ingroup PCIEQOS_PCILayerAPI
+ * @fn static void __exit ioh_pcieqos_pci_exit(void)
+ * @brief  Provides the functionality of exiting the module
+ * */
+static void __exit ioh_pcieqos_pci_exit(void);
+
+MODULE_DESCRIPTION("IOH PCIEQOS PCI Driver");
+MODULE_LICENSE("GPL");
+module_init(ioh_pcieqos_pci_init);
+module_exit(ioh_pcieqos_pci_exit);
+module_param(ioh_pcieqos_major_no, int, S_IRUSR | S_IWUSR);
+
+/*function implementations*/
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn  static int __init ioh_pcieqos_pci_init(void)
+  @remarks  Implements the initialization functionality of the module.
+  @param  NONE
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_exit
+  */
+static int __init ioh_pcieqos_pci_init(void)
+{
+	s32 ret;
+	ret = pci_register_driver(&ioh_pcieqos_driver);
+	IOH_DEBUG
+	    ("ioh_pcieqos_pci_init : Invoked pci_register_driver\
+							 successfully\n");
+	IOH_DEBUG("ioh_pcieqos_pci_init returns %d\n", ret);
+	return ret;
+}
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn  static void __exit ioh_pcieqos_pci_exit(void)
+  @remarks  Implements the exit functionality of the module.
+  @param  NONE
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_init
+  */
+static void __exit ioh_pcieqos_pci_exit(void)
+{
+	pci_unregister_driver(&ioh_pcieqos_driver);
+	IOH_DEBUG
+	    ("ioh_pcieqos_pci_exit : Invoked pci_unregister_driver\
+							 successfully\n");
+}
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn  static int __devinit ioh_pcieqos_probe(struct pci_dev* pdev,
+						 const struct pci_device_id* id)
+  @remarks  Implements the probe functionality of the module.
+  @param  pdev [@ref INOUT] Contains the reference of the pci_dev structure
+  @param  id [@ref INOUT] Contains the reference of the pci_device_id structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_init
+  */
+static int __devinit ioh_pcieqos_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *id)
+{
+
+	char *DRIVER_NAME = "ioh_pcieqos";
+	int ret;
+	unsigned int rom_size;
+
+	ioh_pcieqos_major_no = (ioh_pcieqos_major_no < 0
+				|| ioh_pcieqos_major_no >
+				254) ? 0 : ioh_pcieqos_major_no;
+
+	do {
+
+		ret = pci_enable_device(pdev);
+		if (ret) {
+			IOH_LOG(KERN_ERR,
+				"\nioh_pcieqos_probe : pci_enable_device\
+								 FAILED");
+			break;
+		}
+		IOH_DEBUG("ioh_pcieqos_probe : pci_enable_device returns %d\n",
+			  ret);
+
+		ret = pci_request_regions(pdev, DRIVER_NAME);
+		if (ret) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_probe : pci_request_regions\
+								 FAILED");
+			pci_disable_device(pdev);
+			break;
+		}
+		IOH_DEBUG
+		    ("ioh_pcieqos_probe : pci_request_regions returns %d\n",
+		     ret);
+
+		ioh_pcieqos_base_address = (unsigned long)pci_iomap(pdev, 1, 0);
+
+		if (ioh_pcieqos_base_address == 0) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_probe : pci_iomap FAILED");
+			pci_release_regions(pdev);
+			pci_disable_device(pdev);
+			ret = -ENOMEM;
+			break;
+		}
+		IOH_DEBUG
+		    ("ioh_pcieqos_probe : pci_iomap SUCCESS and value in\
+				 ioh_pcieqos_base_address variable is 0x%08x\n",
+		     ioh_pcieqos_base_address);
+
+		ioh_pcieqos_extrom_base_address =
+		    (unsigned long)pci_map_rom(pdev, &rom_size);
+		if (ioh_pcieqos_extrom_base_address == 0) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_probe : pci_map_rom FAILED");
+			pci_iounmap(pdev, (void *)ioh_pcieqos_base_address);
+			pci_release_regions(pdev);
+			pci_disable_device(pdev);
+			ret = -ENOMEM;
+			break;
+		}
+		IOH_DEBUG
+		    ("ioh_pcieqos_probe : pci_map_rom SUCCESS and value in\
+			 ioh_pcieqos_extrom_base_address variable is 0x%08x\n",
+		     ioh_pcieqos_extrom_base_address);
+
+		if (ioh_pcieqos_major_no) {
+			ioh_pcieqos_dev_no = MKDEV(ioh_pcieqos_major_no, 0);
+			ret =
+			    register_chrdev_region(ioh_pcieqos_dev_no,
+						   IOH_MINOR_NOS, DRIVER_NAME);
+			if (ret) {
+				IOH_LOG(KERN_ERR,
+					"ioh_pcieqos_probe :\
+					 register_chrdev_region FAILED");
+				pci_unmap_rom(pdev,
+					      (void *)
+					      ioh_pcieqos_extrom_base_address);
+				pci_iounmap(pdev,
+					    (void *)ioh_pcieqos_base_address);
+				pci_release_regions(pdev);
+				pci_disable_device(pdev);
+				break;
+			}
+			IOH_DEBUG
+			    ("ioh_pcieqos_probe :\
+					 register_chrdev_region returns %d\n",
+			     ret);
+		} else {
+			ret =
+			    alloc_chrdev_region(&ioh_pcieqos_dev_no, 0,
+						IOH_MINOR_NOS, DRIVER_NAME);
+			if (ret) {
+				IOH_LOG(KERN_ERR,
+					"ioh_pcieqos_probe :\
+						 alloc_chrdev_region FAILED");
+				pci_unmap_rom(pdev,
+					      (void *)
+					      ioh_pcieqos_extrom_base_address);
+				pci_iounmap(pdev,
+					    (void *)ioh_pcieqos_base_address);
+				pci_release_regions(pdev);
+				pci_disable_device(pdev);
+				break;
+			}
+			IOH_DEBUG
+			    ("ioh_pcieqos_probe :\
+					 alloc_chrdev_region returns %d\n",
+			     ret);
+		}
+
+		cdev_init(&ioh_pcieqos_dev, &ioh_pcieqos_fops);
+		IOH_DEBUG
+		    ("ioh_pcieqos_probe :  cdev_init invoked successfully\n");
+
+		ioh_pcieqos_dev.owner = THIS_MODULE;
+		ioh_pcieqos_dev.ops = &ioh_pcieqos_fops;
+
+		ret =
+		    cdev_add(&ioh_pcieqos_dev, ioh_pcieqos_dev_no,
+			     IOH_MINOR_NOS);
+		if (ret) {
+			IOH_LOG(KERN_ERR,
+				"ioh_pcieqos_probe :  cdev_add FAILED");
+			unregister_chrdev_region(ioh_pcieqos_dev_no,
+						 IOH_MINOR_NOS);
+			pci_unmap_rom(pdev,
+				      (void *)ioh_pcieqos_extrom_base_address);
+			pci_iounmap(pdev, (void *)ioh_pcieqos_base_address);
+			pci_release_regions(pdev);
+			pci_disable_device(pdev);
+			break;
+		}
+		IOH_DEBUG("ioh_pcieqos_probe :  cdev_add returns %d\n", ret);
+
+#ifdef IOH_CAN_PCLK_50MHZ
+		/*set the clock config reg if CAN clock is 50Mhz */
+		IOH_DEBUG
+		    ("ioh_pcieqos_probe : invoking\
+			 ioh_pcieqos_read_modify_write_reg to set CLKCFG reg\
+							 for CAN clk 50Mhz\n");
+		ioh_pcieqos_read_modify_write_reg(CLKCFG_REG_OFFSET,
+						  CLKCFG_CAN_50MHZ,
+						  CLKCFG_CANCLK_MASK);
+#endif
+		return IOH_PCIEQOS_SUCCESS;
+	} while (0);
+	IOH_DEBUG("ioh_pcieqos_probe returns %d\n", ret);
+	return ret;
+}
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn  static void __devexit ioh_pcieqos_remove(struct pci_dev * pdev)
+  @remarks  Implements the remove functionality of the module.
+  @param  pdev [@ref INOUT] Contains the reference of the pci_dev structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_init
+  */
+static void __devexit ioh_pcieqos_remove(struct pci_dev *pdev)
+{
+
+	cdev_del(&ioh_pcieqos_dev);
+	IOH_DEBUG("ioh_pcieqos_remove - cdev_del Invoked successfully\n");
+
+	unregister_chrdev_region(ioh_pcieqos_dev_no, IOH_MINOR_NOS);
+	IOH_DEBUG
+	    ("ioh_pcieqos_remove - unregister_chrdev_region Invoked\
+							 successfully\n");
+
+	pci_unmap_rom(pdev, (void *)ioh_pcieqos_extrom_base_address);
+
+	pci_iounmap(pdev, (void *)ioh_pcieqos_base_address);
+
+	IOH_DEBUG("ioh_pcieqos_remove - pci_iounmap Invoked successfully\n");
+
+	pci_release_regions(pdev);
+	IOH_DEBUG
+	    ("ioh_pcieqos_remove - pci_release_regions Invoked successfully\n");
+
+	pci_disable_device(pdev);
+	IOH_DEBUG
+	    ("ioh_pcieqos_remove - pci_disable_device Invoked successfully\n");
+
+}
+
+#ifdef CONFIG_PM
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static int ioh_pcieqos_suspend(struct pci_dev* pdev,pm_message_t state)
+  @remarks  Implements the suspend functionality of the module.
+  @param  pdev [@ref INOUT] Contains the reference of the pci_dev structure
+  @param  state [@ref INOUT] Contains the reference of the pm_message_t
+								 structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_init
+  ioh_pcieqos_resume
+  */
+static int ioh_pcieqos_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
+	ioh_pcieqos_suspended = true;	/* For blocking further IOCTLs */
+
+	ioh_pcieqos_save_reg_conf();
+	IOH_DEBUG
+	    ("ioh_pcieqos_suspend - ioh_pcieqos_save_reg_conf Invoked\
+							 successfully\n");
+
+	ret = pci_save_state(pdev);
+	if (ret) {
+		IOH_LOG(KERN_ERR,
+			" ioh_pcieqos_suspend -pci_save_state returns-%d\n",
+			ret);
+		return ret;
+	}
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	IOH_DEBUG
+	    ("ioh_pcieqos_suspend - pci_enable_wake Invoked successfully\n");
+
+	IOH_DEBUG("ioh_pcieqos_suspend - pci_save_state returns %d\n", ret);
+
+	pci_disable_device(pdev);
+	IOH_DEBUG
+	    ("ioh_pcieqos_suspend - pci_disable_device Invoked successfully\n");
+
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	IOH_DEBUG
+	    ("ioh_pcieqos_suspend - pci_set_power_state Invoked\
+							 successfully\n");
+
+	IOH_DEBUG("ioh_pcieqos_suspend - return %d\n", IOH_PCIEQOS_SUCCESS);
+
+	return IOH_PCIEQOS_SUCCESS;
+}
+
+/*! @ingroup PCIEQOS_PCILayerAPI
+  @fn static int ioh_pcieqos_resume(struct pci_dev* pdev)
+  @remarks  Implements the resume functionality of the module.
+  @param  pdev [@ref INOUT] Contains the reference of the pci_dev structure
+  @retval returnvalue	[@ref OUT] contains the result for the concerned\
+								 attempt.
+  The result would generally comprise of success code
+  or failure code. The failure code will indicate reason for
+  failure.
+  @see
+  ioh_pcieqos_pci_init
+  ioh_pcieqos_suspend
+  */
+static int ioh_pcieqos_resume(struct pci_dev *pdev)
+{
+
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	IOH_DEBUG
+	    ("ioh_pcieqos_resume - pci_set_power_state Invoked successfully\n");
+
+	pci_restore_state(pdev);
+	IOH_DEBUG
+	    ("ioh_pcieqos_resume - pci_restore_state Invoked successfully\n");
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		IOH_LOG(KERN_ERR,
+			"ioh_pcieqos_resume-pci_enable_device failed ");
+		return ret;
+	}
+
+	IOH_DEBUG("ioh_pcieqos_resume - pci_enable_device returns -%d\n", ret);
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	IOH_DEBUG
+	    ("ioh_pcieqos_resume - pci_enable_wake Invoked successfully\n");
+
+	ioh_pcieqos_restore_reg_conf();
+	IOH_DEBUG
+	    ("ioh_pcieqos_resume - ioh_pcieqos_restore_reg_conf Invoked\
+							 successfully\n");
+
+	ioh_pcieqos_suspended = false;
+
+	IOH_DEBUG("ioh_pcieqos_resume  returns- %d\n", IOH_PCIEQOS_SUCCESS);
+	return IOH_PCIEQOS_SUCCESS;
+}
+
+#endif
-- 
1.7.5.4



-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

--------------020809070803060700050407
Content-Type: text/plain;
 name="screenlog.0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="screenlog.0"

root@(none):/# topcliff_mac_util /get

Topcliff MAC a[ 1498.714703] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open : open count value = 0
ddress utility
[ 1498.724336] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open returns=0
[ 1498.724340] 

[ 1498.734384] ioh_pcieqos arguments:
[ 1498.737962] 	file: dd729b80
[ 1498.740785] 	  cmd: 4004f706
[ 1498.743672] 	  arg: bffc1734
[ 1498.746574] command summary:
[ 1498.749460] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1498.754263] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1498.759168] 172: copy_from_user
[ 1498.762340] 	&addr_offset: de409f24
[ 1498.765850] 	&reqt->addr_offset: bffc1734
[ 1498.769890] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1498.769895] 
[ 1498.780292] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40017
[ 1498.780297] 
[ 1498.791149] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1498.791155] 
[ 1498.804072] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1498.804077] 
[ 1498.812693] ioh_pcieqos arguments:
[ 1498.816117] 	file: dd729b80
[ 1498.818911] 	  cmd: 4004f706
[ 1498.821805] 	  arg: bffc1734
[ 1498.824699] command summary:
[ 1498.827585] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1498.832396] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1498.837301] 172: copy_from_user
[ 1498.840458] 	&addr_offset: de409f24
[ 1498.843958] 	&reqt->addr_offset: bffc1734
[ 1498.847997] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1498.848002] 
[ 1498.858383] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40016
[ 1498.858388] 
[ 1498.869237] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1498.869243] 
[ 1498.882155] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1498.882159] 
[ 1498.890720] ioh_pcieqos arguments:
[ 1498.894148] 	file: dd729b80
[ 1498.896975] 	  cmd: 4004f706
[ 1498.899877] 	  arg: bffc1734
[ 1498.902771] command summary:
[ 1498.905675] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1498.910484] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1498.915392] 172: copy_from_user
[ 1498.918553] 	&addr_offset: de409f24
[ 1498.922064] 	&reqt->addr_offset: bffc1734
[ 1498.926103] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1498.926108] 
[ 1498.936506] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40015
[ 1498.936511] 
[ 1498.947318] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1498.947324] 
[ 1498.960254] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1498.960258] 
[ 1498.968827] ioh_pcieqos arguments:
[ 1498.972246] 	file: dd729b80
[ 1498.975046] 	  cmd: 4004f706
[ 1498.977940] 	  arg: bffc1734
[ 1498.980834] command summary:
[ 1498.983721] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1498.988523] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1498.993428] 172: copy_from_user
[ 1498.996602] 	&addr_offset: de409f24
[ 1499.000110] 	&reqt->addr_offset: bffc1734
[ 1499.004143] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1499.004147] 
[ 1499.014516] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40014
[ 1499.014521] 
[ 1499.025338] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1499.025344] 
[ 1499.038248] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1499.038252] 
[ 1499.046811] ioh_pcieqos arguments:
[ 1499.050223] 	file: dd729b80
[ 1499.053030] 	  cmd: 4004f706
[ 1499.055909] 	  arg: bffc1734
[ 1499.058802] command summary:
[ 1499.061707] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1499.066519] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1499.071421] 172: copy_from_user
[ 1499.074576] 	&addr_offset: de409f24
[ 1499.078087] 	&reqt->addr_offset: bffc1734
[ 1499.082126] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1499.082131] 
[ 1499.092528] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff4001f
[ 1499.092533] 
[ 1499.103352] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1499.103357] 
[ 1499.116258] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1499.116262] 
[ 1499.124832] ioh_pcieqos arguments:
[ 1499.128260] 	file: dd729b80
[ 1499.131060] 	  cmd: 4004f706
[ 1499.133955] 	  arg: bffc1734
[ 1499.136867] command summary:
[ 1499.139753] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1499.144563] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1499.149461] 172: copy_from_user
[ 1499.152632] 	&addr_offset: de409f24
[ 1499.156143] 	&reqt->addr_offset: bffc1734
[ 1499.160172] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1499.160177] 
[ 1499.170582] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff4001e
[ 1499.170587] 
[ 1499.181413] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1499.181419] 
[ 1499.194329] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1499.194334] 
Read MAC address[ 1499.202917] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release : ioh_pcieqos_opencount =0
[ 1499.202921] 
 = 00:00:00:00:0[ 1499.214689] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release returning=0
[ 1499.214693] 
0:00

root@(none):/# topcliff_mac_util /set 00:00:00:00:00:BB

Topcliff MAC a[ 1503.258860] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open : open count value = 0
ddress utility
[ 1503.268477] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open returns=0
[ 1503.268481] 
[ 1503.278533] ioh_pcieqos arguments:
[ 1503.281952] 	file: dd729f00
[ 1503.284761] 	  cmd: 4004f707
[ 1503.287647] 	  arg: bff2b684
[ 1503.290541] command summary:
[ 1503.293437] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1503.298246] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1503.303136] 172: copy_from_user
[ 1503.306300] 	&addr_offset: de409f24
[ 1503.309809] 	&reqt->addr_offset: bff2b684
[ 1503.313842] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1503.313847] 
[ 1503.324242] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1503.324247] 
[ 1503.335169] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.335173] 
[ 1503.343653] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1503.343657] 
[ 1503.351210] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1503.351215] 
[ 1503.362150] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.362154] 
[ 1503.370643] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1503.370647] 
[ 1503.378238] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1503.378243] 
[ 1503.389174] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.389178] 
[ 1503.397658] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1503.397662] 
[ 1503.405241] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1503.405246] 
[ 1503.416180] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.416184] 
[ 1503.424683] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1503.424687] 
[ 1503.432262] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1503.432267] 
[ 1503.443184] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.443188] 
[ 1503.451662] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.451666] 
[ 1503.459206] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1503.459211] 
[ 1503.470131] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.470135] 
[ 1503.478627] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.478631] 
[ 1503.486184] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1503.486189] 
[ 1503.497138] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.497143] 
[ 1503.505613] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.505617] 
[ 1503.513203] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1503.513208] 
[ 1503.524147] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.524151] 
[ 1503.532639] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1503.532643] 
[ 1503.540224] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1503.540229] 
[ 1503.551166] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.551170] 
[ 1503.559644] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1503.559648] 
[ 1503.567214] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1503.567219] 
[ 1503.578157] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.578162] 
[ 1503.586631] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1503.586635] 
[ 1503.594192] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1503.594197] 
[ 1503.605152] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.605156] 
[ 1503.613632] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1503.613636] 
[ 1503.621203] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1503.621208] 
[ 1503.632141] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.632145] 
[ 1503.640639] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1503.640643] 
[ 1503.648224] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1503.648229] 
[ 1503.659159] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.659163] 
[ 1503.667645] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1503.667648] 
[ 1503.675190] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1503.675195] 
[ 1503.686129] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.686133] 
[ 1503.694632] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1503.694635] 
[ 1503.702207] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1503.702212] 
[ 1503.713126] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.713130] 
[ 1503.721623] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1503.721627] 
[ 1503.729194] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1503.729199] 
[ 1503.740117] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.740122] 
[ 1503.748593] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1503.748597] 
[ 1503.756196] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1503.756201] 
[ 1503.767138] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.767143] 
[ 1503.775635] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1503.775639] 
[ 1503.783179] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1503.783184] 
[ 1503.794129] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.794134] 
[ 1503.802639] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1503.802643] 
[ 1503.810200] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1503.810205] 
[ 1503.821142] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.821147] 
[ 1503.829621] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1503.829625] 
[ 1503.837211] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1503.837216] 
[ 1503.848141] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.848145] 
[ 1503.856626] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1503.856630] 
[ 1503.864223] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1503.864228] 
[ 1503.875164] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.875168] 
[ 1503.883642] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1503.883646] 
[ 1503.891212] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1503.891217] 
[ 1503.902137] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.902141] 
[ 1503.910622] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.910626] 
[ 1503.918197] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1503.918202] 
[ 1503.929135] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.929139] 
[ 1503.937619] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.937623] 
[ 1503.945203] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1503.945208] 
[ 1503.956115] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.956119] 
[ 1503.964599] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.964603] 
[ 1503.972179] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40017
[ 1503.972184] 
[ 1503.983122] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1503.983126] 
[ 1503.991617] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1503.991621] 
[ 1503.999159] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1503.999165] 
[ 1504.012089] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1504.012093] 
[ 1504.020668] ioh_pcieqos arguments:
[ 1504.024086] 	file: dd729f00
[ 1504.026883] 	  cmd: 4004f707
[ 1504.029786] 	  arg: bff2b684
[ 1504.032679] command summary:
[ 1504.035566] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1504.040385] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1504.045275] 172: copy_from_user
[ 1504.048429] 	&addr_offset: de409f24
[ 1504.051930] 	&reqt->addr_offset: bff2b684
[ 1504.055955] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1504.055960] 
[ 1504.066366] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1504.066371] 
[ 1504.077298] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.077303] 
[ 1504.085759] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1504.085763] 
[ 1504.093304] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1504.093308] 
[ 1504.104228] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.104232] 
[ 1504.112714] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1504.112718] 
[ 1504.120273] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1504.120278] 
[ 1504.131211] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.131215] 
[ 1504.139694] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.139698] 
[ 1504.147257] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1504.147262] 
[ 1504.158188] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.158192] 
[ 1504.166666] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1504.166671] 
[ 1504.174245] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1504.174250] 
[ 1504.185169] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.185174] 
[ 1504.193646] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.193650] 
[ 1504.201191] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1504.201196] 
[ 1504.212134] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.212138] 
[ 1504.220616] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.220621] 
[ 1504.228184] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1504.228189] 
[ 1504.239120] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.239124] 
[ 1504.247607] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.247611] 
[ 1504.255170] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1504.255175] 
[ 1504.266100] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.266105] 
[ 1504.274586] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1504.274591] 
[ 1504.282182] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1504.282187] 
[ 1504.293116] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.293120] 
[ 1504.301593] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1504.301597] 
[ 1504.309147] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1504.309152] 
[ 1504.320087] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.320091] 
[ 1504.328572] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1504.328576] 
[ 1504.336131] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1504.336136] 
[ 1504.347067] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.347072] 
[ 1504.355548] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.355552] 
[ 1504.363126] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1504.363131] 
[ 1504.374047] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.374052] 
[ 1504.382508] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1504.382512] 
[ 1504.390104] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1504.390109] 
[ 1504.401029] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.401033] 
[ 1504.409505] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1504.409510] 
[ 1504.417051] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1504.417056] 
[ 1504.427966] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.427970] 
[ 1504.436442] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1504.436446] 
[ 1504.444010] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1504.444015] 
[ 1504.454937] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.454941] 
[ 1504.463424] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.463428] 
[ 1504.470988] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1504.470993] 
[ 1504.481909] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.481914] 
[ 1504.490385] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1504.490389] 
[ 1504.497982] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1504.497987] 
[ 1504.508915] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.508919] 
[ 1504.517400] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1504.517404] 
[ 1504.524945] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1504.524950] 
[ 1504.535870] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.535874] 
[ 1504.544346] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1504.544350] 
[ 1504.551921] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1504.551926] 
[ 1504.562852] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.562856] 
[ 1504.571343] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.571347] 
[ 1504.578926] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1504.578931] 
[ 1504.589847] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.589851] 
[ 1504.598309] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1504.598313] 
[ 1504.605886] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1504.605891] 
[ 1504.616819] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.616823] 
[ 1504.625305] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.625309] 
[ 1504.632851] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1504.632856] 
[ 1504.643765] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.643770] 
[ 1504.652241] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.652245] 
[ 1504.659800] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1504.659806] 
[ 1504.670728] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.670732] 
[ 1504.679204] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.679208] 
[ 1504.686786] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1504.686791] 
[ 1504.697717] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.697721] 
[ 1504.706203] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.706207] 
[ 1504.713789] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40016
[ 1504.713794] 
[ 1504.724697] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.724701] 
[ 1504.733173] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.733177] 
[ 1504.740735] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1504.740741] 
[ 1504.753637] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1504.753641] 
[ 1504.762200] ioh_pcieqos arguments:
[ 1504.765630] 	file: dd729f00
[ 1504.768439] 	  cmd: 4004f707
[ 1504.771323] 	  arg: bff2b684
[ 1504.774218] command summary:
[ 1504.777131] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1504.781933] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1504.786823] 172: copy_from_user
[ 1504.789977] 	&addr_offset: de409f24
[ 1504.793478] 	&reqt->addr_offset: bff2b684
[ 1504.797502] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1504.797507] 
[ 1504.807894] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1504.807899] 
[ 1504.818839] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.818844] 
[ 1504.827307] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1504.827311] 
[ 1504.834851] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1504.834856] 
[ 1504.845795] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.845799] 
[ 1504.854286] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1504.854290] 
[ 1504.861845] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1504.861850] 
[ 1504.872781] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.872785] 
[ 1504.881268] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1504.881272] 
[ 1504.888831] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1504.888836] 
[ 1504.899755] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.899759] 
[ 1504.908240] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1504.908244] 
[ 1504.915818] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1504.915823] 
[ 1504.926758] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.926763] 
[ 1504.935238] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.935242] 
[ 1504.942792] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1504.942797] 
[ 1504.953714] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.953718] 
[ 1504.962190] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.962195] 
[ 1504.969749] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1504.969755] 
[ 1504.980676] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1504.980680] 
[ 1504.989156] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1504.989160] 
[ 1504.996734] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1504.996739] 
[ 1505.007665] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.007670] 
[ 1505.016141] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1505.016145] 
[ 1505.023732] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1505.023737] 
[ 1505.034656] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.034660] 
[ 1505.043123] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.043127] 
[ 1505.050676] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1505.050681] 
[ 1505.061601] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.061605] 
[ 1505.070076] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.070080] 
[ 1505.077644] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1505.077649] 
[ 1505.088571] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.088575] 
[ 1505.097051] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.097055] 
[ 1505.104639] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1505.104644] 
[ 1505.115569] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.115574] 
[ 1505.124046] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1505.124050] 
[ 1505.131634] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1505.131639] 
[ 1505.142558] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.142562] 
[ 1505.151035] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.151039] 
[ 1505.158582] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1505.158587] 
[ 1505.169513] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.169517] 
[ 1505.177998] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.178002] 
[ 1505.185557] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1505.185562] 
[ 1505.196484] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.196488] 
[ 1505.204964] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.204968] 
[ 1505.212543] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1505.212548] 
[ 1505.223464] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.223468] 
[ 1505.231926] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1505.231930] 
[ 1505.239529] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1505.239534] 
[ 1505.250452] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.250457] 
[ 1505.258923] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.258927] 
[ 1505.266459] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1505.266464] 
[ 1505.277393] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.277397] 
[ 1505.285878] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.285882] 
[ 1505.293446] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1505.293451] 
[ 1505.304372] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.304376] 
[ 1505.312840] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.312844] 
[ 1505.320404] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1505.320409] 
[ 1505.331344] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.331349] 
[ 1505.339836] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1505.339840] 
[ 1505.347433] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1505.347438] 
[ 1505.358357] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.358361] 
[ 1505.366836] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.366840] 
[ 1505.374371] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1505.374376] 
[ 1505.385287] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.385291] 
[ 1505.393762] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.393766] 
[ 1505.401331] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1505.401336] 
[ 1505.412283] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.412287] 
[ 1505.420763] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.420767] 
[ 1505.428341] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1505.428346] 
[ 1505.439247] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.439251] 
[ 1505.447723] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.447728] 
[ 1505.455311] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40015
[ 1505.455316] 
[ 1505.466254] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.466259] 
[ 1505.474740] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.474744] 
[ 1505.482327] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1505.482333] 
[ 1505.495237] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1505.495241] 
[ 1505.503807] ioh_pcieqos arguments:
[ 1505.507221] 	file: dd729f00
[ 1505.510031] 	  cmd: 4004f707
[ 1505.512925] 	  arg: bff2b684
[ 1505.515824] command summary:
[ 1505.518740] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1505.523560] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1505.528445] 172: copy_from_user
[ 1505.531607] 	&addr_offset: de409f24
[ 1505.535112] 	&reqt->addr_offset: bff2b684
[ 1505.539150] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1505.539155] 
[ 1505.549554] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1505.549559] 
[ 1505.560463] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.560468] 
[ 1505.568941] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.568945] 
[ 1505.576496] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1505.576501] 
[ 1505.587416] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.587420] 
[ 1505.595893] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.595897] 
[ 1505.603455] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1505.603460] 
[ 1505.614389] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.614393] 
[ 1505.622865] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.622869] 
[ 1505.630446] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1505.630451] 
[ 1505.641353] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.641357] 
[ 1505.649829] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1505.649833] 
[ 1505.657419] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1505.657424] 
[ 1505.668341] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.668345] 
[ 1505.676822] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.676826] 
[ 1505.684355] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1505.684360] 
[ 1505.695278] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.695283] 
[ 1505.703748] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.703752] 
[ 1505.711316] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1505.711321] 
[ 1505.722239] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.722244] 
[ 1505.730700] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1505.730704] 
[ 1505.738273] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1505.738278] 
[ 1505.749195] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.749199] 
[ 1505.757671] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1505.757675] 
[ 1505.765262] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1505.765267] 
[ 1505.776187] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.776191] 
[ 1505.784679] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.784683] 
[ 1505.792214] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1505.792220] 
[ 1505.803156] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.803161] 
[ 1505.811623] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.811627] 
[ 1505.819183] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1505.819188] 
[ 1505.830110] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.830115] 
[ 1505.838587] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.838591] 
[ 1505.846159] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1505.846164] 
[ 1505.857081] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.857085] 
[ 1505.865541] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1505.865545] 
[ 1505.873128] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1505.873132] 
[ 1505.884045] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.884049] 
[ 1505.892522] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1505.892526] 
[ 1505.900058] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1505.900063] 
[ 1505.910973] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.910977] 
[ 1505.919458] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1505.919462] 
[ 1505.927017] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1505.927022] 
[ 1505.937944] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.937949] 
[ 1505.946421] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1505.946425] 
[ 1505.953994] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1505.953999] 
[ 1505.964915] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.964919] 
[ 1505.973395] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1505.973399] 
[ 1505.980987] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1505.980992] 
[ 1505.991905] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1505.991909] 
[ 1506.000391] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1506.000395] 
[ 1506.007936] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1506.007941] 
[ 1506.018851] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.018855] 
[ 1506.027327] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1506.027331] 
[ 1506.034887] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1506.034892] 
[ 1506.045830] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.045834] 
[ 1506.054309] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.054313] 
[ 1506.061893] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1506.061898] 
[ 1506.072820] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.072824] 
[ 1506.081305] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1506.081309] 
[ 1506.088891] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1506.088896] 
[ 1506.099828] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.099832] 
[ 1506.108315] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.108319] 
[ 1506.115873] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1506.115878] 
[ 1506.126806] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.126810] 
[ 1506.135286] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.135290] 
[ 1506.142851] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1506.142856] 
[ 1506.153778] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.153782] 
[ 1506.162263] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.162268] 
[ 1506.169837] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1506.169842] 
[ 1506.180767] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.180771] 
[ 1506.189252] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.189256] 
[ 1506.196839] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40014
[ 1506.196844] 
[ 1506.207749] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.207753] 
[ 1506.216234] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.216238] 
[ 1506.223831] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1506.223837] 
[ 1506.236740] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1506.236744] 
[ 1506.245324] ioh_pcieqos arguments:
[ 1506.248748] 	file: dd729f00
[ 1506.251548] 	  cmd: 4004f707
[ 1506.254458] 	  arg: bff2b684
[ 1506.257353] command summary:
[ 1506.260257] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1506.265078] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1506.269982] 172: copy_from_user
[ 1506.273136] 	&addr_offset: de409f24
[ 1506.276638] 	&reqt->addr_offset: bff2b684
[ 1506.280661] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1506.280666] 
[ 1506.291053] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1506.291058] 
[ 1506.301997] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.302001] 
[ 1506.310483] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1506.310487] 
[ 1506.318036] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1506.318041] 
[ 1506.328979] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.328983] 
[ 1506.337457] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1506.337461] 
[ 1506.344997] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1506.345002] 
[ 1506.355915] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.355919] 
[ 1506.364400] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.364404] 
[ 1506.371968] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1506.371973] 
[ 1506.382894] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.382898] 
[ 1506.391364] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1506.391368] 
[ 1506.398951] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1506.398956] 
[ 1506.409901] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.409905] 
[ 1506.418378] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.418382] 
[ 1506.425914] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1506.425919] 
[ 1506.436848] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.436853] 
[ 1506.445323] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.445327] 
[ 1506.452883] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1506.452888] 
[ 1506.463801] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.463805] 
[ 1506.472280] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.472284] 
[ 1506.479834] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1506.479839] 
[ 1506.490755] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.490759] 
[ 1506.499233] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1506.499237] 
[ 1506.506822] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1506.506827] 
[ 1506.517752] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.517757] 
[ 1506.526231] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1506.526235] 
[ 1506.533774] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1506.533779] 
[ 1506.544698] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.544702] 
[ 1506.553185] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1506.553189] 
[ 1506.560735] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1506.560740] 
[ 1506.571672] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.571676] 
[ 1506.580140] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.580143] 
[ 1506.587712] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1506.587717] 
[ 1506.598634] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.598638] 
[ 1506.607110] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1506.607114] 
[ 1506.614698] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1506.614703] 
[ 1506.625622] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.625626] 
[ 1506.634103] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1506.634107] 
[ 1506.641661] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1506.641666] 
[ 1506.652578] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.652582] 
[ 1506.661054] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1506.661058] 
[ 1506.668631] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1506.668636] 
[ 1506.679565] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.679569] 
[ 1506.688051] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.688055] 
[ 1506.695623] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1506.695628] 
[ 1506.706563] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.706567] 
[ 1506.715042] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1506.715046] 
[ 1506.722611] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1506.722616] 
[ 1506.733552] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.733556] 
[ 1506.742038] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1506.742042] 
[ 1506.749583] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1506.749588] 
[ 1506.760508] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.760513] 
[ 1506.769001] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1506.769005] 
[ 1506.776560] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1506.776565] 
[ 1506.787478] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.787482] 
[ 1506.795982] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.795985] 
[ 1506.803554] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1506.803559] 
[ 1506.814493] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.814497] 
[ 1506.822987] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1506.822991] 
[ 1506.830574] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1506.830579] 
[ 1506.841501] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.841505] 
[ 1506.849977] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1506.849981] 
[ 1506.857521] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1506.857526] 
[ 1506.868455] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.868459] 
[ 1506.876950] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.876954] 
[ 1506.884490] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1506.884495] 
[ 1506.895410] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.895414] 
[ 1506.903903] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.903906] 
[ 1506.911475] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1506.911480] 
[ 1506.922388] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.922392] 
[ 1506.930867] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.930871] 
[ 1506.938452] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001f
[ 1506.938457] 
[ 1506.949385] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1506.949389] 
[ 1506.957872] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1506.957876] 
[ 1506.965425] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1506.965430] 
[ 1506.978346] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1506.978350] 
[ 1506.986922] ioh_pcieqos arguments:
[ 1506.990338] 	file: dd729f00
[ 1506.993145] 	  cmd: 4004f707
[ 1506.996048] 	  arg: bff2b684
[ 1506.998946] command summary:
[ 1507.001872] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1507.006675] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1507.011571] 172: copy_from_user
[ 1507.014737] 	&addr_offset: de409f24
[ 1507.018254] 	&reqt->addr_offset: bff2b684
[ 1507.022279] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1507.022283] 
[ 1507.032677] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000b
[ 1507.032682] 
[ 1507.043604] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.043608] 
[ 1507.052081] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1507.052085] 
[ 1507.059628] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000a
[ 1507.059633] 
[ 1507.070567] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.070571] 
[ 1507.079028] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1507.079032] 
[ 1507.086586] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40009
[ 1507.086591] 
[ 1507.097523] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.097527] 
[ 1507.106016] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1507.106019] 
[ 1507.113598] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40008
[ 1507.113603] 
[ 1507.124520] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.124524] 
[ 1507.133006] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x02
[ 1507.133010] 
[ 1507.140611] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000f
[ 1507.140616] 
[ 1507.151561] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.151565] 
[ 1507.160057] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.160061] 
[ 1507.167583] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000e
[ 1507.167588] 
[ 1507.178523] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.178527] 
[ 1507.187009] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.187013] 
[ 1507.194587] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000d
[ 1507.194592] 
[ 1507.205521] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.205525] 
[ 1507.213998] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.214002] 
[ 1507.221571] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4000c
[ 1507.221576] 
[ 1507.232494] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.232499] 
[ 1507.240989] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x80
[ 1507.240993] 
[ 1507.248574] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40013
[ 1507.248579] 
[ 1507.259499] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.259503] 
[ 1507.267976] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1507.267980] 
[ 1507.275520] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40012
[ 1507.275525] 
[ 1507.286446] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.286450] 
[ 1507.294939] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1507.294943] 
[ 1507.302498] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40011
[ 1507.302503] 
[ 1507.313416] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.313420] 
[ 1507.321894] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1507.321897] 
[ 1507.329466] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40010
[ 1507.329471] 
[ 1507.340388] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.340392] 
[ 1507.348876] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x18
[ 1507.348880] 
[ 1507.356460] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001b
[ 1507.356465] 
[ 1507.367394] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.367399] 
[ 1507.375872] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1507.375876] 
[ 1507.383416] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001a
[ 1507.383421] 
[ 1507.394340] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.394344] 
[ 1507.402826] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1507.402829] 
[ 1507.410393] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40019
[ 1507.410398] 
[ 1507.421313] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.421317] 
[ 1507.429815] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1507.429819] 
[ 1507.437406] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40018
[ 1507.437411] 
[ 1507.448343] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.448347] 
[ 1507.456820] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x19
[ 1507.456824] 
[ 1507.464410] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40023
[ 1507.464415] 
[ 1507.475333] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.475337] 
[ 1507.483818] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbc
[ 1507.483822] 
[ 1507.491363] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40022
[ 1507.491368] 
[ 1507.502287] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.502291] 
[ 1507.510764] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x10
[ 1507.510768] 
[ 1507.518323] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40021
[ 1507.518328] 
[ 1507.529257] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.529261] 
[ 1507.537753] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1507.537757] 
[ 1507.545326] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40020
[ 1507.545331] 
[ 1507.556268] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.556272] 
[ 1507.564734] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x3a
[ 1507.564738] 
[ 1507.572337] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40027
[ 1507.572342] 
[ 1507.583279] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.583283] 
[ 1507.591766] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x01
[ 1507.591770] 
[ 1507.599330] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40026
[ 1507.599334] 
[ 1507.610251] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.610255] 
[ 1507.618729] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.618733] 
[ 1507.626288] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40025
[ 1507.626293] 
[ 1507.637222] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.637226] 
[ 1507.645709] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.645713] 
[ 1507.653281] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff40024
[ 1507.653286] 
[ 1507.664231] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.664235] 
[ 1507.672726] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0x00
[ 1507.672730] 
[ 1507.680310] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_write_serial_rom:mem_addr=0xdff4001e
[ 1507.680315] 
[ 1507.691245] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:word_data=0x00000000
[ 1507.691249] 
[ 1507.699722] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:data=0xbb
[ 1507.699726] 
[ 1507.707280] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked			 ioh_pcieqos_write_gbe_mac_addr successfully
[ 1507.707286] 
[ 1507.720194] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1507.720198] 
[ 1507.728769] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release : ioh_pcieqos_opencount =0
[ 1507.728774] 
[ 1507.739148] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release returning=0
[ 1507.739153] 

root@(none):/# topcliff_mac_util /get

Topcliff MAC a[ 1510.011209] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open : open count value = 0
ddress utility
[ 1510.020858] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_open returns=0
[ 1510.020862] 

[ 1510.030915] ioh_pcieqos arguments:
[ 1510.034504] 	file: dd729980
[ 1510.037309] 	  cmd: 4004f706
[ 1510.040204] 	  arg: bf9d6b64
[ 1510.043090] command summary:
[ 1510.046011] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.050832] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.055720] 172: copy_from_user
[ 1510.058892] 	&addr_offset: de409f24
[ 1510.062400] 	&reqt->addr_offset: bf9d6b64
[ 1510.066423] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.066428] 
[ 1510.076808] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40017
[ 1510.076812] 
[ 1510.087655] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.087661] 
[ 1510.100582] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.100587] 
[ 1510.109183] ioh_pcieqos arguments:
[ 1510.112604] 	file: dd729980
[ 1510.115410] 	  cmd: 4004f706
[ 1510.118310] 	  arg: bf9d6b64
[ 1510.121233] command summary:
[ 1510.124146] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.128946] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.133841] 172: copy_from_user
[ 1510.137008] 	&addr_offset: de409f24
[ 1510.140516] 	&reqt->addr_offset: bf9d6b64
[ 1510.144556] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.144561] 
[ 1510.154958] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40016
[ 1510.154963] 
[ 1510.165788] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.165793] 
[ 1510.178730] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.178734] 
[ 1510.187304] ioh_pcieqos arguments:
[ 1510.190733] 	file: dd729980
[ 1510.193541] 	  cmd: 4004f706
[ 1510.196454] 	  arg: bf9d6b64
[ 1510.199355] command summary:
[ 1510.202268] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.207089] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.211975] 172: copy_from_user
[ 1510.215121] 	&addr_offset: de409f24
[ 1510.218639] 	&reqt->addr_offset: bf9d6b64
[ 1510.222662] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.222667] 
[ 1510.233055] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40015
[ 1510.233060] 
[ 1510.243893] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.243899] 
[ 1510.256801] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.256805] 
[ 1510.265360] ioh_pcieqos arguments:
[ 1510.268779] 	file: dd729980
[ 1510.271579] 	  cmd: 4004f706
[ 1510.274492] 	  arg: bf9d6b64
[ 1510.277401] command summary:
[ 1510.280297] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.285109] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.289994] 172: copy_from_user
[ 1510.293159] 	&addr_offset: de409f24
[ 1510.296660] 	&reqt->addr_offset: bf9d6b64
[ 1510.300690] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.300695] 
[ 1510.311100] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff40014
[ 1510.311105] 
[ 1510.321933] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.321939] 
[ 1510.334839] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.334843] 
[ 1510.343423] ioh_pcieqos arguments:
[ 1510.346850] 	file: dd729980
[ 1510.349667] 	  cmd: 4004f706
[ 1510.352562] 	  arg: bf9d6b64
[ 1510.355448] command summary:
[ 1510.358352] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.363170] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.368058] 172: copy_from_user
[ 1510.371205] 	&addr_offset: de409f24
[ 1510.374706] 	&reqt->addr_offset: bf9d6b64
[ 1510.378728] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.378733] 
[ 1510.389120] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff4001f
[ 1510.389125] 
[ 1510.399962] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.399968] 
[ 1510.412868] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.412872] 
[ 1510.421451] ioh_pcieqos arguments:
[ 1510.424879] 	file: dd729980
[ 1510.427679] 	  cmd: 4004f706
[ 1510.430574] 	  arg: bf9d6b64
[ 1510.433484] command summary:
[ 1510.436382] 	4004f706: IOCTL_PCIEQOS_READ_MAC_ADDR
[ 1510.441181] 	4004f707: IOCTL_PCIEQOS_WRITE_MAC_ADDR
[ 1510.446070] 172: copy_from_user
[ 1510.449225] 	&addr_offset: de409f24
[ 1510.452726] 	&reqt->addr_offset: bf9d6b64
[ 1510.456749] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : copy_from_user returns =0
[ 1510.456754] 
[ 1510.467132] drivers/char/pch_pcieqos/pch_pcieqos_hal.c:ioh_pcieqos_read_serial_rom:mem_addr=0xdff4001e
[ 1510.467137] 
[ 1510.477963] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_ioctl  : Invoked				 ioh_pcieqos_read_gbe_mac_addr successfully
[ 1510.477968] 
[ 1510.490888] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_write_ioctl returns=0
[ 1510.490892] 
Read MAC address[ 1510.499490] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release : ioh_pcieqos_opencount =0
[ 1510.499494] 
 = 00:00:00:00:0[ 1510.511263] drivers/char/pch_pcieqos/pch_pcieqos.c:ioh_pcieqos_release returning=0
[ 1510.511268] 
0:00

root@(none):/# 

--------------020809070803060700050407--
