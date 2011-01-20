Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1ATUd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:33:57 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32484 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab1ATUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:33:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71062577"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 6/7] msm: mahimahi: add gpio pin muxing code
Date: Thu, 20 Jan 2011 12:32:44 -0800
Message-Id: <1295555565-21563-7-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in old style pin muxing code. This code is from Google's
tree. However, the other way to do this is to use gpiomux, but
it's currently not mature enough to have on/off configurations.

This code was taken from Google's tree, with slight modifications
and clean up.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 arch/arm/mach-msm/board-mahimahi-mmc.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-mahimahi-mmc.c b/arch/arm/mach-msm/board-mahimahi-mmc.c
index 991818e..13e45d0 100644
--- a/arch/arm/mach-msm/board-mahimahi-mmc.c
+++ b/arch/arm/mach-msm/board-mahimahi-mmc.c
@@ -54,6 +54,34 @@ static struct msm_mmc_gpio sdc1_gpio_cfg[] = {
 	{67, "sdc1_dat_0"},
 };
 
+static void config_gpio_table(uint32_t *table, int len)
+{
+	int n;
+	unsigned id;
+	for (n = 0; n < len; n++) {
+		id = table[n];
+		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &id, 0);
+	}
+}
+
+static uint32_t sdcard_on_gpio_table[] = {
+	PCOM_GPIO_CFG(62, 1, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_8MA), /* CLK */
+	PCOM_GPIO_CFG(63, 1, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* CMD */
+	PCOM_GPIO_CFG(64, 1, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT3 */
+	PCOM_GPIO_CFG(65, 1, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT2 */
+	PCOM_GPIO_CFG(66, 1, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT1 */
+	PCOM_GPIO_CFG(67, 1, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT0 */
+};
+
+static uint32_t sdcard_off_gpio_table[] = {
+	PCOM_GPIO_CFG(62, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CLK */
+	PCOM_GPIO_CFG(63, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CMD */
+	PCOM_GPIO_CFG(64, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT3 */
+	PCOM_GPIO_CFG(65, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT2 */
+	PCOM_GPIO_CFG(66, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT1 */
+	PCOM_GPIO_CFG(67, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT0 */
+};
+
 static struct vreg	*sdslot_vreg;
 static uint32_t		sdslot_vdd = 0xffffffff;
 static uint32_t		sdslot_vreg_enabled;
@@ -86,6 +114,8 @@ static uint32_t mahimahi_sdslot_switchvdd(struct device *dev, unsigned int vdd)
 	sdslot_vdd = vdd;
 
 	if (vdd == 0) {
+		config_gpio_table(sdcard_off_gpio_table,
+				  ARRAY_SIZE(sdcard_off_gpio_table));
 		vreg_disable(sdslot_vreg);
 		sdslot_vreg_enabled = 0;
 		return 0;
@@ -95,6 +125,8 @@ static uint32_t mahimahi_sdslot_switchvdd(struct device *dev, unsigned int vdd)
 		ret = vreg_enable(sdslot_vreg);
 		if (ret)
 			pr_err("Error enabling vreg (%d)\n", ret);
+		config_gpio_table(sdcard_on_gpio_table,
+				  ARRAY_SIZE(sdcard_on_gpio_table));
 		sdslot_vreg_enabled = 1;
 	}
 
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
