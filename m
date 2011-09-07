Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1IGQW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:22:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:4776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab1IGQVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,345,1312182000"; 
   d="scan'208";a="48892369"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: alan@linux.intel.com, sameo@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/3] x86, mrst: add platform support for MSIC MFD driver
Date: Wed,  7 Sep 2011 16:06:52 +0300
Message-Id: <dfe26ef675afbc2ce21b54f5c23b94cb00fc4032.1315399396.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1315399396.git.mika.westerberg@linux.intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
In-Reply-To: <cover.1315399396.git.mika.westerberg@linux.intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSIC MFD driver creates platform devices for MSIC device drivers so we
don't need to create them in platform code anymore.

This patch adds a new runtime check which determines whether we are running
on a Medfield platform and enables the MSIC MFD driver accordingly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/platform/mrst/mrst.c |  167 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 153 insertions(+), 14 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 97138a3..2a89f70 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/mfd/intel_msic.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -504,6 +505,128 @@ static void __init *no_platform_data(void *info)
 	return NULL;
 }
 
+static struct resource msic_resources[] = {
+	{
+		.start	= INTEL_MSIC_IRQ_PHYS_BASE,
+		.end	= INTEL_MSIC_IRQ_PHYS_BASE + 64 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct intel_msic_platform_data msic_pdata;
+
+static struct platform_device msic_device = {
+	.name		= "intel_msic",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &msic_pdata,
+	},
+	.num_resources	= ARRAY_SIZE(msic_resources),
+	.resource	= msic_resources,
+};
+
+static inline bool mrst_has_msic(void)
+{
+	return mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL;
+}
+
+static int msic_scu_status_change(struct notifier_block *nb,
+				  unsigned long code, void *data)
+{
+	if (code == SCU_DOWN) {
+		platform_device_unregister(&msic_device);
+		return 0;
+	}
+
+	return platform_device_register(&msic_device);
+}
+
+static int __init msic_init(void)
+{
+	static struct notifier_block msic_scu_notifier = {
+		.notifier_call	= msic_scu_status_change,
+	};
+
+	/*
+	 * We need to be sure that the SCU IPC is ready before MSIC device
+	 * can be registered.
+	 */
+	if (mrst_has_msic())
+		intel_scu_notifier_add(&msic_scu_notifier);
+
+	return 0;
+}
+arch_initcall(msic_init);
+
+/*
+ * msic_generic_platform_data - sets generic platform data for the block
+ * @info: pointer to the SFI device table entry for this block
+ * @block: MSIC block
+ *
+ * Function sets IRQ number from the SFI table entry for given device to
+ * the MSIC platform data.
+ */
+static void *msic_generic_platform_data(void *info, enum intel_msic_block block)
+{
+	struct sfi_device_table_entry *entry = info;
+
+	BUG_ON(block < 0 || block >= INTEL_MSIC_BLOCK_LAST);
+	msic_pdata.irq[block] = entry->irq;
+
+	return no_platform_data(info);
+}
+
+static void *msic_battery_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
+}
+
+static void *msic_gpio_platform_data(void *info)
+{
+	static struct intel_msic_gpio_pdata pdata;
+	int gpio = get_gpio_by_name("msic_gpio_base");
+
+	if (gpio < 0)
+		return NULL;
+
+	pdata.gpio_base = gpio;
+	msic_pdata.gpio = &pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_GPIO);
+}
+
+static void *msic_audio_platform_data(void *info)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("sst-platform", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		pr_err("failed to create audio platform device\n");
+		return NULL;
+	}
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_AUDIO);
+}
+
+static void *msic_power_btn_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_POWER_BTN);
+}
+
+static void *msic_ocd_platform_data(void *info)
+{
+	static struct intel_msic_ocd_pdata pdata;
+	int gpio = get_gpio_by_name("ocd_gpio");
+
+	if (gpio < 0)
+		return NULL;
+
+	pdata.gpio = gpio;
+	msic_pdata.ocd = &pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
+}
+
 static const struct devs_id __initconst device_ids[] = {
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
@@ -512,7 +635,14 @@ static const struct devs_id __initconst device_ids[] = {
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
 	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+
+	/* MSIC subdevices */
+	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
+	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
+
 	{},
 };
 
@@ -633,19 +763,37 @@ static void __init install_irq_resource(struct platform_device *pdev, int irq)
 	platform_device_add_resources(pdev, &res, 1);
 }
 
-static void __init sfi_handle_ipc_dev(struct platform_device *pdev)
+static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *entry)
 {
 	const struct devs_id *dev = device_ids;
+	struct platform_device *pdev;
 	void *pdata = NULL;
 
 	while (dev->name[0]) {
 		if (dev->type == SFI_DEV_TYPE_IPC &&
-			!strncmp(dev->name, pdev->name, SFI_NAME_LEN)) {
-			pdata = dev->get_platform_data(pdev);
+			!strncmp(dev->name, entry->name, SFI_NAME_LEN)) {
+			pdata = dev->get_platform_data(entry);
 			break;
 		}
 		dev++;
 	}
+
+	/*
+	 * On Medfield the platform device creation is handled by the MSIC
+	 * MFD driver so we don't need to do it here.
+	 */
+	if (mrst_has_msic())
+		return;
+
+	/* ID as IRQ is a hack that will go away */
+	pdev = platform_device_alloc(entry->name, entry->irq);
+	if (pdev == NULL) {
+		pr_err("out of memory for SFI platform device '%s'.\n",
+			entry->name);
+		return;
+	}
+	install_irq_resource(pdev, entry->irq);
+
 	pdev->dev.platform_data = pdata;
 	intel_scu_device_register(pdev);
 }
@@ -698,7 +846,6 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 	struct sfi_device_table_entry *pentry;
 	struct spi_board_info spi_info;
 	struct i2c_board_info i2c_info;
-	struct platform_device *pdev;
 	int num, i, bus;
 	int ioapic;
 	struct io_apic_irq_attr irq_attr;
@@ -724,17 +871,9 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 
 		switch (pentry->type) {
 		case SFI_DEV_TYPE_IPC:
-			/* ID as IRQ is a hack that will go away */
-			pdev = platform_device_alloc(pentry->name, pentry->irq);
-			if (pdev == NULL) {
-				pr_err("out of memory for SFI platform device '%s'.\n",
-							pentry->name);
-				continue;
-			}
-			install_irq_resource(pdev, pentry->irq);
 			pr_debug("info[%2d]: IPC bus, name = %16.16s, "
 				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
-			sfi_handle_ipc_dev(pdev);
+			sfi_handle_ipc_dev(pentry);
 			break;
 		case SFI_DEV_TYPE_SPI:
 			memset(&spi_info, 0, sizeof(spi_info));
-- 
1.7.5.4

