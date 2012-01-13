Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2AMPU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:26 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:45921 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758327Ab2AMPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/8] mfd/db8500-prcmu: function for obtaining the prcmu firmware version
Date: Fri, 13 Jan 2012 16:20:10 +0100
Message-ID: <1326468010-11719-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This patch exports a function that can be used to tell which
version of the DB8500 PRCMU firmware is available, and revamps the
firmware detection code a bit.

Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   51 ++++++++++++++++++++++++-------------
 include/linux/mfd/db8500-prcmu.h |   18 +++++++++++++
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index b911963..1251993 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -39,11 +39,6 @@
 /* Offset for the firmware version within the TCPM */
 #define PRCMU_FW_VERSION_OFFSET 0xA4
 
-/* PRCMU project numbers, defined by PRCMU FW */
-#define PRCMU_PROJECT_ID_8500V1_0 1
-#define PRCMU_PROJECT_ID_8500V2_0 2
-#define PRCMU_PROJECT_ID_8400V2_0 3
-
 /* Index of different voltages to be used when accessing AVSData */
 #define PRCM_AVS_BASE		0x2FC
 #define PRCM_AVS_VBB_RET	(PRCM_AVS_BASE + 0x0)
@@ -266,6 +261,11 @@
 #define WAKEUP_BIT_GPIO7 BIT(30)
 #define WAKEUP_BIT_GPIO8 BIT(31)
 
+static struct {
+	bool valid;
+	struct prcmu_fw_version version;
+} fw_info;
+
 /*
  * This vector maps irq numbers to the bits in the bit field used in
  * communication with the PRCMU firmware.
@@ -522,14 +522,6 @@ static const char *hwacc_ret_regulator_name[NUM_HW_ACC] = {
 
 #define PRCMU_PLLDSI_LOCKP_LOCKED	0x3
 
-static struct {
-	u8 project_number;
-	u8 api_version;
-	u8 func_version;
-	u8 errata;
-} prcmu_version;
-
-
 int db8500_prcmu_enable_dsipll(void)
 {
 	int i;
@@ -619,6 +611,11 @@ void prcmu_disable_spi2(void)
 	spin_unlock_irqrestore(&gpiocr_lock, flags);
 }
 
+struct prcmu_fw_version *prcmu_get_fw_version(void)
+{
+	return fw_info.valid ? &fw_info.version : NULL;
+}
+
 bool prcmu_has_arm_maxopp(void)
 {
 	return (readb(tcdm_base + PRCM_AVS_VARM_MAX_OPP) &
@@ -2077,6 +2074,22 @@ static struct irq_chip prcmu_irq_chip = {
 	.irq_unmask	= prcmu_irq_unmask,
 };
 
+static char *fw_project_name(u8 project)
+{
+	switch (project) {
+	case PRCMU_FW_PROJECT_U8500:
+		return "U8500";
+	case PRCMU_FW_PROJECT_U8500_C2:
+		return "U8500 C2";
+	case PRCMU_FW_PROJECT_U9500:
+		return "U9500";
+	case PRCMU_FW_PROJECT_U9500_C2:
+		return "U9500 C2";
+	default:
+		return "Unknown";
+	}
+}
+
 void __init db8500_prcmu_early_init(void)
 {
 	unsigned int i;
@@ -2086,11 +2099,13 @@ void __init db8500_prcmu_early_init(void)
 		if (tcpm_base != NULL) {
 			u32 version;
 			version = readl(tcpm_base + PRCMU_FW_VERSION_OFFSET);
-			prcmu_version.project_number = version & 0xFF;
-			prcmu_version.api_version = (version >> 8) & 0xFF;
-			prcmu_version.func_version = (version >> 16) & 0xFF;
-			prcmu_version.errata = (version >> 24) & 0xFF;
-			pr_info("PRCMU firmware version %d.%d.%d\n",
+			fw_info.version.project = version & 0xFF;
+			fw_info.version.api_version = (version >> 8) & 0xFF;
+			fw_info.version.func_version = (version >> 16) & 0xFF;
+			fw_info.version.errata = (version >> 24) & 0xFF;
+			fw_info.valid = true;
+			pr_info("PRCMU firmware: %s, version %d.%d.%d\n",
+				fw_project_name(fw_info.version.project),
 				(version >> 8) & 0xFF, (version >> 16) & 0xFF,
 				(version >> 24) & 0xFF);
 			iounmap(tcpm_base);
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 0dc9017..1895917 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -493,6 +493,18 @@ struct prcmu_auto_pm_config {
 	u8 sva_policy;
 };
 
+#define PRCMU_FW_PROJECT_U8500		2
+#define PRCMU_FW_PROJECT_U9500		4
+#define PRCMU_FW_PROJECT_U8500_C2	7
+#define PRCMU_FW_PROJECT_U9500_C2	11
+
+struct prcmu_fw_version {
+	u8 project;
+	u8 api_version;
+	u8 func_version;
+	u8 errata;
+};
+
 #ifdef CONFIG_MFD_DB8500_PRCMU
 
 void db8500_prcmu_early_init(void);
@@ -502,6 +514,7 @@ enum ap_pwrst prcmu_get_xp70_current_state(void);
 bool prcmu_has_arm_maxopp(void);
 int prcmu_set_ape_opp(u8 opp);
 int prcmu_get_ape_opp(void);
+struct prcmu_fw_version *prcmu_get_fw_version(void);
 int prcmu_request_ape_opp_100_voltage(bool enable);
 int prcmu_release_usb_wakeup_state(void);
 int prcmu_set_ddr_opp(u8 opp);
@@ -573,6 +586,11 @@ static inline bool prcmu_has_arm_maxopp(void)
 	return false;
 }
 
+static inline struct prcmu_fw_version *prcmu_get_fw_version(void)
+{
+	return NULL;
+}
+
 static inline int prcmu_set_ape_opp(u8 opp)
 {
 	return 0;
-- 
1.7.8

