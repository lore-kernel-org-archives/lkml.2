Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979Ab2DMAmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:42:12 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47867 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab2DMAmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:42:09 -0400
X-Greylist: delayed 786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 20:42:09 EDT
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH v6 2/3] x86/platform: TS-5500 basic platform support
Date: Thu, 12 Apr 2012 20:28:54 -0400
Message-Id: <1334276935-11258-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
 MAINTAINERS                                     |    5 +
 arch/x86/Kconfig                                |    8 +
 arch/x86/platform/Makefile                      |    1 +
 arch/x86/platform/ts5500/Makefile               |    1 +
 arch/x86/platform/ts5500/ts5500.c               |  400 +++++++++++++++++++++++
 6 files changed, 461 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c

diff --git a/Documentation/ABI/testing/sysfs-platform-ts5500 b/Documentation/ABI/testing/sysfs-platform-ts5500
new file mode 100644
index 0000000..bc29bb8
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-ts5500
@@ -0,0 +1,46 @@
+What:		/sys/devices/platform/ts5500/id
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Product ID of the TS board. TS-5500 ID is 0x60.
+
+What:		/sys/devices/platform/ts5500/sram
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Say if the SRAM feature is present. If it is enabled, it will
+		display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/ereset
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Say if an external reset is present. If it is present, it will
+		display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/jp{1,2,3,4,5,6}
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Show the state of a plugged jumper. If it is present, it will
+		display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/adc
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Say if the A/D Converter is present. If it is enabled,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/rs485
+Date:		April 2012
+KernelVersion:	3.3
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Say if the RS485 feature is present. If it is enabled, it
+		will display "1", otherwise "0".
diff --git a/MAINTAINERS b/MAINTAINERS
index 2dcfca8..b126129 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6620,6 +6620,11 @@ S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
 
+TECHNOLOGIC SYSTEMS TS-5500 MACHINE SUPPORT
+M:	Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
+S:	Maintained
+F:	arch/x86/platform/ts5500/
+
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
 M:	Olof Johansson <olof@lixom.net>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..55f32b5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2131,6 +2131,14 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
+config TS5500
+	bool "Technologic Systems TS-5500 Single Board Computer support"
+	depends on MELAN
+	select CHECK_SIGNATURE
+	---help---
+	  Add support for the Technologic Systems TS-5500 SBC.
+	  If you have a TS-5500 platform, say Y here.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 8d87439..f50911b 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -7,5 +7,6 @@ obj-y	+= mrst/
 obj-y	+= olpc/
 obj-y	+= scx200/
 obj-y	+= sfi/
+obj-y	+= ts5500/
 obj-y	+= visws/
 obj-y	+= uv/
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
new file mode 100644
index 0000000..c54e348
--- /dev/null
+++ b/arch/x86/platform/ts5500/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_TS5500)	+= ts5500.o
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
new file mode 100644
index 0000000..96f76c0
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -0,0 +1,400 @@
+/*
+ * Technologic Systems TS-5500 board - SBC info layer
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *	Alexandre Savard <alexandre.savard@savoirfairelinux.com>
+ *	Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+ *
+ * Portions originate from ts_sbcinfo.c (c) Technologic Systems
+ *	Liberty Young <liberty@embeddedx86.com>
+ *
+ * These functions add sysfs platform entries to display information about
+ * the Technologic Systems TS-5500 Single Board Computer (SBC).
+ *
+ * For further information about sysfs entries, see
+ * Documentation/ABI/testing/sysfs-platform-ts5500
+ */
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <asm/processor.h>
+#include <linux/leds.h>
+#include <linux/delay.h>
+#include <linux/max197.h>
+
+/* Hardware info for pre-detection */
+#define AMD_ELAN_FAMILY			4
+#define AMD_ELAN_SC520			9
+
+/* Product code register */
+#define TS5500_PRODUCT_CODE_ADDR	0x74
+#define TS5500_PRODUCT_CODE		0x60	/* TS-5500 product code */
+
+/* SRAM/RS-485/ADC options, and RS-485 RTS/Automatic RS-485 flags register */
+#define TS5500_SRAM_RS485_ADC_ADDR	0x75
+#define TS5500_SRAM			0x01	/* SRAM option */
+#define TS5500_RS485			0x02	/* RS-485 option */
+#define TS5500_ADC			0x04	/* A/D converter option */
+#define TS5500_RS485_RTS		0x40	/* RTS for RS-485 */
+#define TS5500_RS485_AUTO		0x80	/* Automatic RS-485 */
+
+/* External Reset/Industrial Temperature Range options register */
+#define TS5500_ERESET_ITR_ADDR		0x76
+#define TS5500_ERESET			0x01	/* External Reset option */
+#define TS5500_ITR			0x02	/* Indust. Temp. Range option */
+
+/* LED/Jumpers register */
+#define TS5500_LED_JP_ADDR		0x77
+#define TS5500_LED			0x01	/* LED flag */
+#define TS5500_JP1			0x02	/* Automatic CMOS */
+#define TS5500_JP2			0x04	/* Enable Serial Console */
+#define TS5500_JP3			0x08	/* Write Enable Drive A */
+#define TS5500_JP4			0x10	/* Fast Console (115K baud) */
+#define TS5500_JP5			0x20	/* User Jumper */
+#define TS5500_JP6			0x40	/* Console on COM1 (req. JP2) */
+#define TS5500_JP7			0x80	/* Undocumented (Unused) */
+
+/* A/D Converter registers */
+#define TS5500_ADC_CONV_BUSY_ADDR	0x195	/* Conversion state register */
+#define TS5500_ADC_CONV_BUSY		0x01
+#define TS5500_ADC_CONV_INIT_LSB_ADDR	0x196	/* Start conv. / LSB register */
+#define TS5500_ADC_CONV_MSB_ADDR	0x197	/* MSB register */
+#define TS5500_ADC_CONV_DELAY		12	/* usec */
+
+/**
+ * struct ts5500_sbc - TS-5500 SBC main structure
+ * @lock:		Read/Write mutex.
+ * @board_id:		Board name.
+ * @sram:		Check SRAM option.
+ * @rs485:		Check RS-485 option.
+ * @adc:		Check Analog/Digital converter option.
+ * @ereset:		Check External Reset option.
+ * @itr:		Check Industrial Temperature Range option.
+ * @jumpers:		States of jumpers 1-7.
+ */
+struct ts5500_sbc {
+	struct mutex	lock;
+	int		board_id;
+	bool		sram;
+	bool		rs485;
+	bool		adc;
+	bool		ereset;
+	bool		itr;
+	u8		jumpers;
+};
+
+/* Current platform */
+struct ts5500_sbc *ts5500;
+
+/**
+ * ts5500_pre_detect_hw() - check for TS-5500 specific hardware
+ */
+static int __init ts5500_pre_detect_hw(void)
+{
+	/* Check for AMD ElanSC520 Microcontroller */
+	if (cpu_info.x86_vendor != X86_VENDOR_AMD ||
+	    cpu_info.x86 != AMD_ELAN_FAMILY	  ||
+	    cpu_info.x86_model != AMD_ELAN_SC520)
+		return -ENODEV;
+
+	return 0;
+}
+
+/* BIOS signatures */
+static struct {
+	const unsigned char *string;
+	const ssize_t offset;
+} signatures[] __initdata = {
+	{"TS-5x00 AMD Elan", 0xb14}
+};
+
+/**
+ * ts5500_bios_signature() - find board signature in BIOS shadow RAM.
+ */
+static int __init ts5500_bios_signature(void)
+{
+	void __iomem *bios = ioremap(0xF0000, 0x10000);
+	int i, ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(signatures); i++)
+		if (check_signature(bios + signatures[i].offset,
+				    signatures[i].string,
+				    strlen(signatures[i].string)))
+			goto found;
+		else
+			pr_notice("Technologic Systems BIOS signature "
+				  "'%s' not found at offset %zd\n",
+				  signatures[i].string, signatures[i].offset);
+	ret = -ENODEV;
+found:
+	iounmap(bios);
+	return ret;
+}
+
+/**
+ * ts5500_detect_config() - detect the TS board
+ * @sbc:	Structure in which the detected board's details will be stored.
+ */
+static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
+{
+	u8 tmp;
+	int ret = 0;
+
+	if (!request_region(TS5500_PRODUCT_CODE_ADDR, 4, "ts5500"))
+		return -EBUSY;
+
+	mutex_lock(&ts5500->lock);
+	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
+	if (tmp != TS5500_PRODUCT_CODE) {
+		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
+		ret = -ENODEV;
+		goto cleanup;
+	}
+	sbc->board_id = tmp;
+
+	tmp = inb(TS5500_SRAM_RS485_ADC_ADDR);
+	ts5500->sram = tmp & TS5500_SRAM;
+	ts5500->rs485 = tmp & TS5500_RS485;
+	ts5500->adc = tmp & TS5500_ADC;
+
+	tmp = inb(TS5500_ERESET_ITR_ADDR);
+	ts5500->ereset = tmp & TS5500_ERESET;
+	ts5500->itr = tmp & TS5500_ITR;
+
+	tmp = inb(TS5500_LED_JP_ADDR);
+	sbc->jumpers = tmp & ~TS5500_LED;
+
+cleanup:
+	mutex_unlock(&ts5500->lock);
+	release_region(TS5500_PRODUCT_CODE_ADDR, 4);
+	return ret;
+}
+
+#define TS5500_IS_JP_SET(sbc, jmp) (!!(sbc->jumpers & TS5500_JP##jmp))
+
+static ssize_t ts5500_show_id(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%x\n", sbc->board_id);
+}
+
+static ssize_t ts5500_show_sram(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", sbc->sram);
+}
+
+static ssize_t ts5500_show_rs485(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", sbc->rs485);
+}
+
+static ssize_t ts5500_show_adc(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", sbc->adc);
+}
+
+static ssize_t ts5500_show_ereset(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", sbc->ereset);
+}
+
+static ssize_t ts5500_show_itr(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", sbc->itr);
+}
+
+#define TS5500_SHOW_JP(jp)						\
+	static ssize_t ts5500_show_jp##jp(struct device *dev,		\
+					  struct device_attribute *attr,\
+					  char *buf)			\
+	{								\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);		\
+		return sprintf(buf, "%d\n", TS5500_IS_JP_SET(sbc, jp)); \
+	}
+
+TS5500_SHOW_JP(1)
+TS5500_SHOW_JP(2)
+TS5500_SHOW_JP(3)
+TS5500_SHOW_JP(4)
+TS5500_SHOW_JP(5)
+TS5500_SHOW_JP(6)
+
+static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
+static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
+static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
+static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
+static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
+static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+static DEVICE_ATTR(jp1, S_IRUGO, ts5500_show_jp1, NULL);
+static DEVICE_ATTR(jp2, S_IRUGO, ts5500_show_jp2, NULL);
+static DEVICE_ATTR(jp3, S_IRUGO, ts5500_show_jp3, NULL);
+static DEVICE_ATTR(jp4, S_IRUGO, ts5500_show_jp4, NULL);
+static DEVICE_ATTR(jp5, S_IRUGO, ts5500_show_jp5, NULL);
+static DEVICE_ATTR(jp6, S_IRUGO, ts5500_show_jp6, NULL);
+
+static struct attribute *ts5500_attributes[] = {
+	&dev_attr_id.attr,
+	&dev_attr_sram.attr,
+	&dev_attr_rs485.attr,
+	&dev_attr_adc.attr,
+	&dev_attr_ereset.attr,
+	&dev_attr_itr.attr,
+	&dev_attr_jp1.attr,
+	&dev_attr_jp2.attr,
+	&dev_attr_jp3.attr,
+	&dev_attr_jp4.attr,
+	&dev_attr_jp5.attr,
+	&dev_attr_jp6.attr,
+	NULL
+};
+
+static const struct attribute_group ts5500_attr_group = {
+	.attrs = ts5500_attributes,
+};
+
+/* LED platform device */
+
+static void ts5500_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness brightness)
+{
+	outb(!!brightness, TS5500_LED_JP_ADDR);
+}
+
+static enum led_brightness ts5500_led_get(struct led_classdev *led_cdev)
+{
+	return (inb(TS5500_LED_JP_ADDR) & TS5500_LED) ? LED_FULL : LED_OFF;
+}
+
+static struct led_classdev ts5500_led_cdev = {
+	.name = "ts5500:green:activity",
+	.brightness_set = ts5500_led_set,
+	.brightness_get = ts5500_led_get,
+};
+
+/* A/D Converter platform device */
+
+static int ts5500_adc_convert(u8 ctrl, u16 *raw)
+{
+	u8 lsb, msb;
+
+	/* Start convertion (ensure the 3 MSB are set to 0) */
+	outb(ctrl & 0x1F, TS5500_ADC_CONV_INIT_LSB_ADDR);
+
+	udelay(TS5500_ADC_CONV_DELAY);
+	if (inb(TS5500_ADC_CONV_BUSY_ADDR) & TS5500_ADC_CONV_BUSY)
+		return -EBUSY;
+
+	/* Read the raw data */
+	lsb = inb(TS5500_ADC_CONV_INIT_LSB_ADDR);
+	msb = inb(TS5500_ADC_CONV_MSB_ADDR);
+	*raw = (msb << 8) | lsb;
+
+	return 0;
+}
+
+static struct max197_platform_data ts5500_adc_pdata = {
+	.convert = ts5500_adc_convert,
+};
+
+static void ts5500_adc_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_adc_pdev = {
+	.name = "max197",
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_adc_pdata,
+		.release = ts5500_adc_release,
+	},
+};
+
+static int __init ts5500_init(void)
+{
+	int ret;
+	struct platform_device *pdev;
+
+	/*
+	 * There is no DMI available, or PCI bridge subvendor info,
+	 * only the BIOS provides a 16-bit identification call.
+	 * It is safer to check for a TS-5500 specific hardware
+	 * such as the processor, then find a signature in the BIOS.
+	 */
+	ret = ts5500_pre_detect_hw();
+	if (ret)
+		return ret;
+
+	ret = ts5500_bios_signature();
+	if (ret)
+		return ret;
+
+	ts5500 = kzalloc(sizeof(struct ts5500_sbc), GFP_KERNEL);
+	if (!ts5500)
+		return -ENOMEM;
+	mutex_init(&ts5500->lock);
+
+	ret = ts5500_detect_config(ts5500);
+	if (ret)
+		goto release_mem;
+
+	pdev = platform_device_register_simple("ts5500", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		goto release_mem;
+	}
+	platform_set_drvdata(pdev, ts5500);
+
+	ret = sysfs_create_group(&pdev->dev.kobj,
+				 &ts5500_attr_group);
+	if (ret)
+		goto release_pdev;
+
+	if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
+		dev_warn(ts5500_led_cdev.dev, "failed to register the LED\n");
+	if (ts5500->adc) {
+		ts5500_adc_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_adc_pdev))
+			dev_warn(&ts5500_adc_pdev.dev,
+				 "failed to register the A/D converter\n");
+	}
+
+	return 0;
+
+release_pdev:
+	platform_device_unregister(pdev);
+release_mem:
+	kfree(ts5500);
+
+	return ret;
+}
+device_initcall(ts5500_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500 Board's platform driver");
-- 
1.7.9.2

