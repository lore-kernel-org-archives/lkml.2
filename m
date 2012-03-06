Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2CFQL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:11:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2CFQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:11:27 -0500
Date: Tue, 6 Mar 2012 08:10:46 -0800
From: tip-bot for Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <tip-6so0ep0lj0zann68ad5983xh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, durgadoss.r@intel.com,
        alan@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        durgadoss.r@intel.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mid/thermal: Convert to use Intel MSIC API
Git-Commit-ID: 0f48d34ec6a34e24b96708719fd6f3ba8fa828af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:11:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f48d34ec6a34e24b96708719fd6f3ba8fa828af
Gitweb:     http://git.kernel.org/tip/0f48d34ec6a34e24b96708719fd6f3ba8fa828af
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Mon, 5 Mar 2012 15:01:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:01:25 +0100

x86/mid/thermal: Convert to use Intel MSIC API

Intel MSIC MFD driver provides common register access interface
to the devices in the MSIC die so we use that instead of SCU
IPC.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-6so0ep0lj0zann68ad5983xh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig             |    2 +-
 drivers/platform/x86/intel_mid_thermal.c |   39 +++++++++++++----------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5715e4d..86720bc 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -672,7 +672,7 @@ config INTEL_MID_POWER_BUTTON
 
 config INTEL_MFLD_THERMAL
        tristate "Thermal driver for Intel Medfield platform"
-       depends on INTEL_SCU_IPC && THERMAL
+       depends on MFD_INTEL_MSIC && THERMAL
        help
          Say Y here to enable thermal driver support for the  Intel Medfield
          platform.
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index ccd7b1f..d824a71 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -33,18 +33,15 @@
 #include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/thermal.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 /* Number of thermal sensors */
 #define MSIC_THERMAL_SENSORS	4
 
 /* ADC1 - thermal registers */
-#define MSIC_THERM_ADC1CNTL1	0x1C0
 #define MSIC_ADC_ENBL		0x10
 #define MSIC_ADC_START		0x08
 
-#define MSIC_THERM_ADC1CNTL3	0x1C2
 #define MSIC_ADCTHERM_ENBL	0x04
 #define MSIC_ADCRRDATA_ENBL	0x05
 #define MSIC_CHANL_MASK_VAL	0x0F
@@ -75,8 +72,8 @@
 #define ADC_VAL60C		315
 
 /* ADC base addresses */
-#define ADC_CHNL_START_ADDR	0x1C5	/* increments by 1 */
-#define ADC_DATA_START_ADDR	0x1D4	/* increments by 2 */
+#define ADC_CHNL_START_ADDR	INTEL_MSIC_ADC1ADDR0	/* increments by 1 */
+#define ADC_DATA_START_ADDR	INTEL_MSIC_ADC1SNS0H	/* increments by 2 */
 
 /* MSIC die attributes */
 #define MSIC_DIE_ADC_MIN	488
@@ -189,17 +186,17 @@ static int mid_read_temp(struct thermal_zone_device *tzd, unsigned long *temp)
 	addr = td_info->chnl_addr;
 
 	/* Enable the msic for conversion before reading */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
 	if (ret)
 		return ret;
 
 	/* Re-toggle the RRDATARD bit (temporary workaround) */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
 	if (ret)
 		return ret;
 
 	/* Read the higher bits of data */
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 
@@ -207,7 +204,7 @@ static int mid_read_temp(struct thermal_zone_device *tzd, unsigned long *temp)
 	adc_val = (data << 2);
 	addr++;
 
-	ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
+	ret = intel_msic_reg_read(addr, &data);/* Read lower bits */
 	if (ret)
 		return ret;
 
@@ -235,7 +232,7 @@ static int configure_adc(int val)
 	int ret;
 	uint8_t data;
 
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -246,7 +243,7 @@ static int configure_adc(int val)
 		/* Just stop the ADC */
 		data &= (~MSIC_ADC_START);
 	}
-	return intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL1, data);
+	return intel_msic_reg_write(INTEL_MSIC_ADC1CNTL1, data);
 }
 
 /**
@@ -262,21 +259,21 @@ static int set_up_therm_channel(u16 base_addr)
 	int ret;
 
 	/* Enable all the sensor channels */
-	ret = intel_scu_ipc_iowrite8(base_addr, SKIN_SENSOR0_CODE);
+	ret = intel_msic_reg_write(base_addr, SKIN_SENSOR0_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 1, SKIN_SENSOR1_CODE);
+	ret = intel_msic_reg_write(base_addr + 1, SKIN_SENSOR1_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 2, SYS_SENSOR_CODE);
+	ret = intel_msic_reg_write(base_addr + 2, SYS_SENSOR_CODE);
 	if (ret)
 		return ret;
 
 	/* Since this is the last channel, set the stop bit
 	 * to 1 by ORing the DIE_SENSOR_CODE with 0x10 */
-	ret = intel_scu_ipc_iowrite8(base_addr + 3,
+	ret = intel_msic_reg_write(base_addr + 3,
 			(MSIC_DIE_SENSOR_CODE | 0x10));
 	if (ret)
 		return ret;
@@ -295,11 +292,11 @@ static int reset_stopbit(uint16_t addr)
 {
 	int ret;
 	uint8_t data;
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 	/* Set the stop bit to zero */
-	return intel_scu_ipc_iowrite8(addr, (data & 0xEF));
+	return intel_msic_reg_write(addr, (data & 0xEF));
 }
 
 /**
@@ -322,7 +319,7 @@ static int find_free_channel(void)
 	uint8_t data;
 
 	/* check whether ADC is enabled */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -331,7 +328,7 @@ static int find_free_channel(void)
 
 	/* ADC is already enabled; Looking for an empty channel */
 	for (i = 0; i < ADC_CHANLS_MAX; i++) {
-		ret = intel_scu_ipc_ioread8(ADC_CHNL_START_ADDR + i, &data);
+		ret = intel_msic_reg_read(ADC_CHNL_START_ADDR + i, &data);
 		if (ret)
 			return ret;
 
@@ -359,7 +356,7 @@ static int mid_initialize_adc(struct device *dev)
 	 * Ensure that adctherm is disabled before we
 	 * initialize the ADC
 	 */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL3, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL3, &data);
 	if (ret)
 		return ret;
 
