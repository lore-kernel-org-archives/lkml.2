Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1DFNya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:54:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab1DFNy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EcvSM97KKAqoXAvKH1SJQYvxEqPIfeKPH6fSdidyuATd7kWBxy8ccZ/xn4qwbJX+Er
         ehUNZlQz9Pl2TLCarsaL5lL03FBJlx8Bq9xzFNzlyH7pjmF1dqp+H0nPFHKb+a5tBj20
         VDxtm38+vgPSo8dAw+8gTSxZXu0FppfEJsa/w=
Date: Wed, 6 Apr 2011 15:54:24 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH v3] hwmon: Add driver for AMD family 15h processor power
 information
Message-ID: <20110406135424.GC2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405144536.GA5054@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

This CPU family provides NB register values to gather following
TDP information

* ProcessorPwrWatts: Specifies in Watts the maximum amount of power
  the processor can support.
* CurrPwrWatts: Specifies in Watts the current amount of power being
  consumed by the processor.

This driver provides

* power1_max (ProcessorPwrWatts)
* power1_input (CurrPwrWatts)

Changes from v2::
 - fix format strings
 - removed paranoid checks for existense of functions 3 and 5
 - changed return type of function f15h_power_is_internal_node0
 - provide power1_max instead of power1_cap
 - use dev_warn instead of WARN_ON
 - rebased against 2.6.39-rc2
 - added Documentation/hwmon/f15h_power

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/hwmon/f15h_power |   37 ++++++++
 drivers/hwmon/Kconfig          |   10 ++
 drivers/hwmon/Makefile         |    1 +
 drivers/hwmon/f15h_power.c     |  197 ++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/k10temp.c        |    2 +-
 5 files changed, 246 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/hwmon/f15h_power
 create mode 100644 drivers/hwmon/f15h_power.c

diff --git a/Documentation/hwmon/f15h_power b/Documentation/hwmon/f15h_power
new file mode 100644
index 0000000..5e990d3
--- /dev/null
+++ b/Documentation/hwmon/f15h_power
@@ -0,0 +1,37 @@
+Kernel driver f15h_power
+========================
+
+Supported chips:
+* AMD Family 15h Processors
+
+  Prefix: 'f15h_power'
+  Addresses scanned: PCI space
+  Datasheets:
+  BIOS and Kernel Developer's Guide (BKDG) For AMD Family 15h Processors
+    (not yet published)
+
+Author: Andreas Herrmann <andreas.herrmann3@amd.com>
+
+Description
+-----------
+
+This driver permits reading of registers providing power information
+of AMD Family 15h processors.
+
+For AMD Family 15h processors the following power values can be
+calculated using different processor northbridge function registers
+
+* BasePwrWatts: Specifies in watts the maximum amount of power
+  consumed by the processor for NB and logic external to the core.
+* ProcessorPwrWatts: Specifies in watts the maximum amount of power
+  the processor can support.
+* CurrPwrWatts: Specifies in watts the current amount of power being
+  consumed by the processor.
+
+This driver provides ProcessorPwrWatts and CurrPwrWatts:
+* power1_max (ProcessorPwrWatts)
+* power1_input (CurrPwrWatts)
+
+On multi-node processors the calculated value is for the entire
+package and not for a single node. Thus the driver creates sysfs
+attributes only for internal node0 of a multi-node processor.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 060ef63..36ae085 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -249,6 +249,16 @@ config SENSORS_K10TEMP
 	  This driver can also be built as a module.  If so, the module
 	  will be called k10temp.
 
+config SENSORS_F15H_POWER
+	tristate "AMD Family 15h processor power"
+	depends on X86 && PCI
+	help
+	  If you say yes here you get support for processor power
+	  information of your AMD family 15h CPU.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called f15h_power.
+
 config SENSORS_ASB100
 	tristate "Asus ASB100 Bach"
 	depends on X86 && I2C && EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 967d0ea..a8d03d5 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_SENSORS_JC42)	+= jc42.o
 obj-$(CONFIG_SENSORS_JZ4740)	+= jz4740-hwmon.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
+obj-$(CONFIG_SENSORS_F15H_POWER) += f15h_power.o
 obj-$(CONFIG_SENSORS_LINEAGE)	+= lineage-pem.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
diff --git a/drivers/hwmon/f15h_power.c b/drivers/hwmon/f15h_power.c
new file mode 100644
index 0000000..648c21d
--- /dev/null
+++ b/drivers/hwmon/f15h_power.c
@@ -0,0 +1,197 @@
+/*
+ * f15h_power.c - AMD Family 15h processor power monitoring
+ *
+ * Copyright (c) 2011 Advanced Micro Devices, Inc.
+ * Author: Andreas Herrmann <andreas.herrmann3@amd.com>
+ *
+ *
+ * This driver is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+#include <asm/processor.h>
+
+MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
+MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
+MODULE_LICENSE("GPL");
+
+/* D18F3 */
+#define REG_NORTHBRIDGE_CAP		0xe8
+
+/* D18F4 */
+#define REG_PROCESSOR_TDP		0x1b8
+
+/* D18F5 */
+#define REG_TDP_RUNNING_AVERAGE		0xe0
+#define REG_TDP_LIMIT3			0xe8
+
+static ssize_t show_power(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	u32 val, btdp, tdpl, tdp2w, arange;
+	s32 acap;
+	u64 ctdp;
+	struct pci_dev *f4 = to_pci_dev(dev);
+
+	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
+	btdp = (val >> 16) & 0xffff;
+
+	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
+				  REG_TDP_RUNNING_AVERAGE, &val);
+	acap = (val >> 4) & 0x3fffff;
+	acap = sign_extend32(acap, 22);
+	arange = val & 0xf;
+
+	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
+				  REG_TDP_LIMIT3, &val);
+
+	tdpl = (val >> 16) & 0x1fff;
+	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
+	ctdp = tdpl - (s32)(acap >> (arange + 1)) + btdp;
+	ctdp *= tdp2w;
+
+	/*
+	 * Convert to microWatt
+	 *
+	 * power is in Watt provided as fixed point integer with
+	 * scaling factor 1/(2^16).  For conversion we use
+	 * (10^6)/(2^16) = 15625/(2^10)
+	 */
+	ctdp = (ctdp * 15625) >> 10;
+	return sprintf(buf, "%u\n", (u32) ctdp);
+}
+static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);
+
+static ssize_t show_power_max(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	u32 val, tdp2w;
+	u64 ptdp;
+	struct pci_dev *f4 = to_pci_dev(dev);
+
+	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
+	ptdp = val & 0xffff;
+
+	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
+				  REG_TDP_LIMIT3, &val);
+
+	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
+	ptdp *= tdp2w;
+
+	/* result not allowed to be >= 256W */
+	if ((ptdp>>16) >= 256)
+		dev_warn(dev, "Bogus value for ProcessorPwrWatts (ptdp>=%u)\n",
+			 (u32) (ptdp >> 16));
+
+	/* convert to microWatt */
+	ptdp = (ptdp * 15625) >> 10;
+	return sprintf(buf, "%u\n", (u32) ptdp);
+}
+static DEVICE_ATTR(power1_max, S_IRUGO, show_power_max, NULL);
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "f15h_power\n");
+}
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static bool __devinit f15h_power_is_internal_node0(struct pci_dev *f4)
+{
+	u32 val;
+
+	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3),
+				  REG_NORTHBRIDGE_CAP, &val);
+	if ((val & BIT(29)) && ((val >> 30) & 3))
+		return false;
+
+	return true;
+}
+
+static int __devinit f15h_power_probe(struct pci_dev *pdev,
+				      const struct pci_device_id *id)
+{
+	struct device *hwmon_dev;
+	int err = -ENODEV;
+
+	if (!f15h_power_is_internal_node0(pdev))
+		goto exit;
+
+	err = device_create_file(&pdev->dev, &dev_attr_power1_input);
+	if (err)
+		goto exit;
+	err = device_create_file(&pdev->dev, &dev_attr_power1_max);
+	if (err)
+		goto exit_remove;
+
+	err = device_create_file(&pdev->dev, &dev_attr_name);
+	if (err)
+		goto exit_remove;
+
+	hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto exit_remove;
+	}
+	dev_set_drvdata(&pdev->dev, hwmon_dev);
+
+	return 0;
+
+exit_remove:
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &dev_attr_power1_input);
+	device_remove_file(&pdev->dev, &dev_attr_power1_max);
+exit:
+	return err;
+}
+
+static void __devexit f15h_power_remove(struct pci_dev *pdev)
+{
+	hwmon_device_unregister(dev_get_drvdata(&pdev->dev));
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &dev_attr_power1_input);
+	device_remove_file(&pdev->dev, &dev_attr_power1_max);
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(f15h_power_id_table) = {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, f15h_power_id_table);
+
+static struct pci_driver f15h_power_driver = {
+	.name = "f15h_power",
+	.id_table = f15h_power_id_table,
+	.probe = f15h_power_probe,
+	.remove = __devexit_p(f15h_power_remove),
+};
+
+static int __init f15h_power_init(void)
+{
+	return pci_register_driver(&f15h_power_driver);
+}
+
+static void __exit f15h_power_exit(void)
+{
+	pci_unregister_driver(&f15h_power_driver);
+}
+
+module_init(f15h_power_init)
+module_exit(f15h_power_exit)
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 82bf65a..2cbc1ab 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -205,7 +205,7 @@ static void __devexit k10temp_remove(struct pci_dev *pdev)
 	dev_set_drvdata(&pdev->dev, NULL);
 }
 
-static const struct pci_device_id k10temp_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
-- 
1.7.4.1

