Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0IWWxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:53:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53569 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0IWWxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:53:49 -0400
Date: Thu, 23 Sep 2010 15:53:46 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Message-ID: <20100923225346.GB4960@lucy>
References: <20100921224610.GO13162@lucy>
 <20100923143849.ad29d0ad.rdunlap@xenotime.net>
 <20100923221253.GA4960@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100923221253.GA4960@lucy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IBM Real-Time "SMI Free" mode driver

This driver supports the Real-Time Linux (RTL) BIOS feature.
The RTL feature allows non-fatal System Management Interrupts
(SMIs) to be disabled on supported IBM platforms and is
intended to be coupled with a user-space daemon to monitor
the hardware in a way that can be prioritized and scheduled
to better suit the requirements for the system.

The Device is presented as a special "_RTL_" table to the OS
in the Extended BIOS Data Area.  There is a simple protocol
for entering and exiting the mode at runtime.  This driver
creates a simple sysfs interface to allow a simple entry and
exit from RTL mode in the UFI/BIOS.

This patch has taken the feedback in response to previous posts
by Keith Mannthey <kmannth@us.ibm.com> in addition to a couple
of more improvements, including using a DMI probe to reduce the
probability of getting into trouble on non-IBM systems.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>

--

diff --git a/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl b/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
new file mode 100644
index 0000000..b82deea
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
@@ -0,0 +1,22 @@
+What:           state
+Date:           Sep 2010
+KernelVersion:  2.6.37
+Contact:        Vernon Mauery <vernux@us.ibm.com>
+Description:    The state file allows a means by which to change in and
+                out of Premium Real-Time Mode (PRTM), as well as the
+                ability to query the current state.
+                    0 => PRTM off
+                    1 => PRTM enabled
+Users:          The ibm-prtm userspace daemon uses this interface.
+
+
+What:           version
+Date:           Sep 2010
+KernelVersion:  2.6.37
+Contact:        Vernon Mauery <vernux@us.ibm.com>
+Description:    The version file provides a means by which to query
+                the RTL table version that lives in the Extended
+                BIOS Data Area (EBDA).
+Users:          The ibm-prtm userspace daemon uses this interface.
+
+
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index cff7cc2..5fba368 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -590,4 +590,20 @@ config INTEL_IPS
  	  functionality.  If in doubt, say Y here; it will only load on
  	  supported platforms.
  
+config IBM_RTL
+	tristate "Device driver to enable PRTL support"
+	depends on X86 && PCI
+	---help---
+	  Enable support for IBM Premium Real Time Mode (PRTM).
+	  This module will allow you the enter and exit PRTM in the BIOS via
+	  sysfs on platforms that support this feature.  System in PRTM will
+	  not recive CPU-generated SMIs for recoverable errors.  Use of this
+	  feature without proper support may void your hardware warranty.
+
+	  If the proper BIOS support is found the driver will load and create
+	  /sys/devices/system/ibm_rtl/.  The "state" variable will indicate
+	  whether or not the BIOS is in PRTM.
+	  state = 0 (BIOS SMIs on)
+	  state = 1 (BIOS SMIs off)
+
  endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 85fb2b8..50fae7a 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -30,4 +30,5 @@ obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
  obj-$(CONFIG_RAR_REGISTER)	+= intel_rar_register.o
  obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
  obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
+obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
  
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
new file mode 100644
index 0000000..c7a991f
--- /dev/null
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -0,0 +1,352 @@
+/*
+ * IBM Real-Time Linux driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ *
+ * Author: Keith Mannthey <kmannth@us.ibm.com>
+ *         Vernon Mauery <vernux@us.ibm.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/sysdev.h>
+#include <linux/dmi.h>
+#include <linux/mutex.h>
+#include <asm/bios_ebda.h>
+
+static int force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+
+static int debug;
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Show debug output");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Keith Mannthey <kmmanth@us.ibm.com>");
+MODULE_AUTHOR("Vernon Mauery <vernux@us.ibm.com>");
+
+enum rtl_addr_type {
+	RTL_ADDR_TYPE_IO = 1,
+	RTL_ADDR_TYPE_MMIO,
+} __attribute__((packed));
+
+enum rtl_cmd_type {
+	RTL_CMD_NOP = 0,
+	RTL_CMD_ENTER_PRTM,
+	RTL_CMD_EXIT_PRTM,
+} __attribute__((packed));
+
+/* The RTL table as presented by the EBDA: */
+struct ibm_rtl_table {
+	char signature[5];
+	u8 version;
+	u8 rt_status;
+	enum rtl_cmd_type command;
+	u8 command_status;
+	enum rtl_addr_type cmd_address_type;
+	u8 cmd_granularity;
+	u8 cmd_offset;
+	u16 reserve1;
+	u8 cmd_port_address[4]; /* platform dependent address */
+	u8 cmd_port_value[4];   /* platform dependent value */
+};
+
+#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
+
+#define ERROR(A, B...) printk(KERN_ERR "ibm-rtl: " A, ##B )
+#define WARNING(A, B...) printk(KERN_WARNING "ibm-rtl: " A, ##B )
+#define DEBUG(A, B...) do { \
+	if (debug) \
+		printk(KERN_INFO "ibm-rtl: " A, ##B ); \
+} while (0)
+
+static DEFINE_MUTEX(rtl_lock);
+static struct ibm_rtl_table __iomem *rtl_table = NULL;
+static void __iomem *ebda_map;
+static void __iomem *rtl_cmd_iomem_addr = NULL;
+static u32 rtl_cmd_port_addr;
+static enum rtl_addr_type rtl_cmd_type;
+static u8 rtl_cmd_width;
+
+static int ibm_rtl_write(u8 value)
+{
+	int ret = 0, count = 0;
+	static u32 cmd_port_val;
+
+	DEBUG("%s(%d)\n", __FUNCTION__, value);
+
+	mutex_lock(&rtl_lock);
+
+	if (ioread8(&rtl_table->rt_status) != value) {
+		if (value == 1)
+			iowrite8(RTL_CMD_ENTER_PRTM, &rtl_table->command);
+		else
+			iowrite8(RTL_CMD_EXIT_PRTM, &rtl_table->command);
+
+		DEBUG("rtl_cmd_port_addr = %#x\n", rtl_cmd_port_addr);
+		DEBUG("rtl_cmd_type = %d\n", rtl_cmd_type);
+
+		switch (rtl_cmd_width) {
+		case 8:
+			cmd_port_val = ioread8(&rtl_table->cmd_port_value);
+			DEBUG("cmd_port_val = %u\n", cmd_port_val);
+			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
+				iowrite8((u8)cmd_port_val, rtl_cmd_iomem_addr);
+			else
+				outb((u8)cmd_port_val, rtl_cmd_port_addr);
+			break;
+		case 16:
+			cmd_port_val = ioread16(&rtl_table->cmd_port_value);
+			DEBUG("cmd_port_val = %u\n", cmd_port_val);
+			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
+				iowrite16((u16)cmd_port_val, rtl_cmd_iomem_addr);
+			else
+				outw((u16)cmd_port_val, rtl_cmd_port_addr);
+			break;
+		case 32:
+			cmd_port_val = ioread32(&rtl_table->cmd_port_value);
+			DEBUG("cmd_port_val = %u\n", cmd_port_val);
+			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
+				iowrite32(cmd_port_val, rtl_cmd_iomem_addr);
+			else
+				outl(cmd_port_val, rtl_cmd_port_addr);
+			break;
+		}
+
+		while (ioread8(&rtl_table->command)) {
+			msleep(10);
+			if (count++ > 500) {
+				ERROR("Hardware not responding to "
+					"mode switch request\n");
+				ret = -EIO;
+				break;
+			}
+
+		}
+
+		if (ioread8(&rtl_table->command_status)) {
+			DEBUG("command_status reports failed command\n");
+			ret = -EIO;
+		}
+	}
+
+	mutex_unlock(&rtl_lock);
+	return ret;
+}
+
+static ssize_t rtl_show_version(struct sysdev_class * dev,
+                                struct sysdev_class_attribute *attr,
+                                char *buf)
+{
+	return sprintf(buf, "%d\n", (int)ioread8(&rtl_table->version));
+}
+
+static ssize_t rtl_show_state(struct sysdev_class *dev,
+                              struct sysdev_class_attribute *attr,
+                              char *buf)
+{
+	return sprintf(buf, "%d\n", ioread8(&rtl_table->rt_status));
+}
+
+static ssize_t rtl_set_state(struct sysdev_class *dev,
+                             struct sysdev_class_attribute *attr,
+                             const char *buf,
+                             size_t count)
+{
+	ssize_t ret;
+
+	if (count < 1 || count > 2)
+		return -EINVAL;
+
+	switch (buf[0]) {
+	case '0':
+		ret = ibm_rtl_write(0);
+		break;
+	case '1':
+		ret = ibm_rtl_write(1);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (ret >= 0)
+		ret = count;
+
+	return ret;
+}
+
+static struct sysdev_class class_rtl = {
+	.name = "ibm_rtl",
+};
+
+static SYSDEV_CLASS_ATTR(version, S_IRUGO, rtl_show_version, NULL);
+static SYSDEV_CLASS_ATTR(state, 0600, rtl_show_state, rtl_set_state);
+
+static struct sysdev_class_attribute *rtl_attributes[] = {
+	&attr_version,
+	&attr_state,
+	NULL
+};
+
+
+static int rtl_setup_sysfs(void) {
+	int ret, i;
+	ret = sysdev_class_register(&class_rtl);
+
+	if (!ret) {
+		for (i = 0; rtl_attributes[i]; i ++)
+			sysdev_class_create_file(&class_rtl, rtl_attributes[i]);
+	}
+	return ret;
+}
+
+static void rtl_teardown_sysfs(void) {
+	int i;
+	for (i = 0; rtl_attributes[i]; i ++)
+		sysdev_class_remove_file(&class_rtl, rtl_attributes[i]);
+	sysdev_class_unregister(&class_rtl);
+}
+
+static int dmi_check_cb(const struct dmi_system_id *id)
+{
+	DEBUG("found IBM server '%s'\n", id->ident);
+	return 0;
+}
+
+#define ibm_dmi_entry(NAME, TYPE)                  \
+{                                                  \
+	.ident = NAME,                             \
+	.matches = {                               \
+		DMI_MATCH(DMI_SYS_VENDOR, "IBM"),  \
+		DMI_MATCH(DMI_PRODUCT_NAME, TYPE), \
+	},                                         \
+	.callback = dmi_check_cb                   \
+}
+
+static struct dmi_system_id __initdata ibm_rtl_dmi_table[] = {
+	ibm_dmi_entry("BladeCenter LS21", "7971"),
+	ibm_dmi_entry("BladeCenter LS22", "7901"),
+	ibm_dmi_entry("BladeCenter HS21 XM", "7995"),
+	ibm_dmi_entry("BladeCenter HS22", "7870"),
+	ibm_dmi_entry("BladeCenter HS22V", "7871"),
+	ibm_dmi_entry("System x3550 M2", "7946"),
+	ibm_dmi_entry("System x3650 M2", "7947"),
+	ibm_dmi_entry("System x3550 M3", "7944"),
+	ibm_dmi_entry("System x3650 M3", "7945"),
+	{ }
+};
+
+static int __init ibm_rtl_init(void) {
+	unsigned long ebda_addr, ebda_size;
+	unsigned int ebda_kb;
+	int ret = -ENODEV, i;
+
+	if (force)
+		WARNING("module loaded by force!\n");
+	/* first ensure that we are running on IBM HW */
+	else if (!dmi_check_system(ibm_rtl_dmi_table))
+		return -ENODEV;
+
+	/* Get the address for the Extended BIOS Data Area */
+	ebda_addr = get_bios_ebda();
+	if (!ebda_addr) {
+		DEBUG("no BIOS EBDA found\n");
+		return -ENODEV;
+	}
+
+	ebda_map = ioremap(ebda_addr, 4);
+	if (!ebda_map)
+		return -ENOMEM;
+
+	/* First word in the EDBA is the Size in KB */
+	ebda_kb = ioread16(ebda_map);
+	DEBUG("EBDA is %d kB\n", ebda_kb);
+
+	if (ebda_kb == 0)
+		goto out;
+
+	iounmap(ebda_map);
+	ebda_size = ebda_kb*1024;
+
+	/* Remap the whole table */
+	ebda_map = ioremap(ebda_addr, ebda_size);
+	if (!ebda_map)
+		return -ENOMEM;
+
+	/* search for the _RTL_ signature at the start of the table */
+	for (i = 0 ; i < ebda_size/sizeof(unsigned int); i++) {
+		struct ibm_rtl_table __iomem * tmp;
+		tmp = (struct ibm_rtl_table __iomem *) (ebda_map+i);
+		if (ioread32(&tmp->signature) == RTL_SIGNATURE) {
+			DEBUG("found RTL_SIGNATURE at %#llx\n", (u64)tmp);
+			rtl_table = tmp;
+			/* The address, value, width and offset are platform
+			 * dependent and found in the ibm_rtl_table */
+			rtl_cmd_width = ioread8(&rtl_table->cmd_granularity);
+			rtl_cmd_type = ioread8(&rtl_table->cmd_address_type);
+			DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
+			      rtl_cmd_width, rtl_cmd_type);
+			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO) {
+				u32 addr;
+				addr = ioread32(&rtl_table->cmd_port_address);
+				rtl_cmd_iomem_addr = ioremap(addr, 4);
+				DEBUG("rtl_cmd_iomem_addr = %#llx\n",
+				      (u64)rtl_cmd_iomem_addr);
+				if (!rtl_cmd_iomem_addr) {
+					ret = -ENOMEM;
+					break;
+				}
+			} else {
+				rtl_cmd_port_addr =
+					ioread32(&rtl_table->cmd_port_address);
+				DEBUG("rtl_cmd_port_addr = %#x\n",
+				      rtl_cmd_port_addr);
+			}
+			ret = rtl_setup_sysfs();
+			break;
+		}
+	}
+
+out:
+	if (ret) {
+		iounmap(ebda_map);
+		if (rtl_cmd_iomem_addr)
+			iounmap(rtl_cmd_iomem_addr);
+	}
+
+	return ret;
+}
+
+static void __exit ibm_rtl_exit(void)
+{
+	if (rtl_table) {
+		DEBUG("cleaning up");
+		/* do not leave the machine in SMI-free mode */
+		ibm_rtl_write(0);
+		/* unmap, unlink and remove all traces */
+		rtl_teardown_sysfs();
+		iounmap(ebda_map);
+		if (rtl_cmd_iomem_addr)
+			iounmap(rtl_cmd_iomem_addr);
+	}
+}
+
+module_init(ibm_rtl_init);
+module_exit(ibm_rtl_exit);
