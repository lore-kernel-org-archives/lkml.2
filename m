Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1C1C26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:28:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:33352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1C1C24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:28:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="725810173"
From: Lu Guanqun <guanqun.lu@intel.com>
To: meego-kernel@lists.meego.com
Cc: alan@linux.intel.com, arjan@linux.intel.com, fengguang.wu@intel.com,
        feng.tang@intel.com, michael.fu@intel.com, xingchao.wang@intel.com,
        vinod.koul@intel.com, jeeja.kp@intel.com,
        Lu Guanqun <guanqun.lu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Feng Tang <feng.tang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jekyll Lai <jekyll_lai@wistron.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v9 1/2] mrst: export get_gpio_by_name() function
Date: Mon, 28 Mar 2011 10:29:19 +0800
Message-Id: <1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export get_gpio_by_name() function and make its name more focused.  We are
doing this because currently get_gpio_by_name() is only used by the devices
exported from SFI DEVS table, but it is also useful for other PCI devices which
also use the GPIO lines, and have their gpio infos in the SFI GPIO table.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Reviewed-by: Tang Feng <feng.tang@intel.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/x86/include/asm/mrst.h   |    1 +
 arch/x86/platform/mrst/mrst.c |   35 ++++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index dd8a072..d6cf6d4 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -18,6 +18,7 @@ extern int pci_mrst_init(void);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
 extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
+extern int mid_lookup_gpio(const char *name);
 
 /*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index bc5993f..909b2cc 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -389,7 +389,7 @@ static int __init sfi_parse_gpio(struct sfi_table_header *table)
 	return 0;
 }
 
-static int get_gpio_by_name(const char *name)
+int mid_lookup_gpio(const char *name)
 {
 	struct sfi_gpio_table_entry *pentry = gpio_table;
 	int i;
@@ -402,6 +402,7 @@ static int get_gpio_by_name(const char *name)
 	}
 	return -1;
 }
+EXPORT_SYMBOL_GPL(mid_lookup_gpio);
 
 /*
  * Here defines the array of devices platform data that IAFW would export
@@ -433,7 +434,7 @@ static void __init install_irq_resource(struct platform_device *pdev,
 static void __init *pmic_gpio_platform_data(void *info)
 {
 	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
-	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+	int gpio_base = mid_lookup_gpio("pmic_gpio_base");
 
 	if (gpio_base == -1)
 		gpio_base = 64;
@@ -453,7 +454,7 @@ static struct dw_spi_chip max3111_uart = {
 static void __init *max3111_platform_data(void *info)
 {
 	struct spi_board_info *spi_info = info;
-	int intr = get_gpio_by_name("max3111_int");
+	int intr = mid_lookup_gpio("max3111_int");
 
 	spi_info->mode = SPI_MODE_0;
 	spi_info->controller_data = &max3111_uart;
@@ -492,8 +493,8 @@ static void __init *max7315_platform_data(void *info)
 		strcpy(intr_pin_name, "max7315_int");
 	}
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = mid_lookup_gpio(base_pin_name);
+	intr = mid_lookup_gpio(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
@@ -520,8 +521,8 @@ static void *tca6416_platform_data(void *info)
 	strcpy(base_pin_name, "tca6416_base");
 	strcpy(intr_pin_name, "tca6416_int");
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = mid_lookup_gpio(base_pin_name);
+	intr = mid_lookup_gpio(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
@@ -539,7 +540,7 @@ static void *tca6416_platform_data(void *info)
 static void *mpu3050_platform_data(void *info)
 {
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("mpu3050_int");
+	int intr = mid_lookup_gpio("mpu3050_int");
 
 	if (intr == -1)
 		return NULL;
@@ -558,7 +559,7 @@ static void *ektf2136_spi_platform_data(void *info)
 {
 	struct spi_board_info *spi_info = info;
 	static struct ektf2136_platform_data ektf2136_spi_pdata;
-	int gpio = get_gpio_by_name("ts_int");
+	int gpio = mid_lookup_gpio("ts_int");
 
 	if (gpio == -1)
 		return NULL;
@@ -574,8 +575,8 @@ static void __init *emc1403_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("thermal_int");
-	int intr2nd = get_gpio_by_name("thermal_alert");
+	int intr = mid_lookup_gpio("thermal_int");
+	int intr2nd = mid_lookup_gpio("thermal_alert");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
@@ -592,7 +593,7 @@ static void __init *msic_ocd_platform_data(void *info)
 	int gpio_base;
 	struct platform_device *pdev = (struct platform_device *)info;
 
-	gpio_base = get_gpio_by_name("msic_ocd");
+	gpio_base = mid_lookup_gpio("msic_ocd");
 	if (gpio_base == -1)
 		return NULL;
 
@@ -604,8 +605,8 @@ static void __init *lis331dl_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("accel_int");
-	int intr2nd = get_gpio_by_name("accel_2");
+	int intr = mid_lookup_gpio("accel_int");
+	int intr2nd = mid_lookup_gpio("accel_2");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
@@ -763,8 +764,8 @@ static void *tc35894xbg_platform_data(struct i2c_board_info *i2c_info,
 			      struct tc35894xbg_platform_data* tc_data)
 
 {
-	tc_data->gpio_irq = get_gpio_by_name("keypad-intr");
-	tc_data->gpio_reset = get_gpio_by_name("keypad-reset");
+	tc_data->gpio_irq = mid_lookup_gpio("keypad-intr");
+	tc_data->gpio_reset = mid_lookup_gpio("keypad-reset");
 
 	printk(KERN_INFO "Nokia: keypad-intr on %d, keypad-reset on %d\n",
 	       tc_data->gpio_irq, tc_data->gpio_reset);
@@ -1117,7 +1118,7 @@ static int __init pb_keys_init(void)
 
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
-		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		gb[i].gpio = mid_lookup_gpio(gb[i].desc);
 		if (gb[i].gpio == -1)
 			continue;
 
-- 
1.7.2.3

