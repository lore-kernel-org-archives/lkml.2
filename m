Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2GZKc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:32:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62262 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2GZK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/21] ARM: ux500: Fork MSP platform registration for step-by-step DT enablement
Date: Thu, 26 Jul 2012 11:28:45 +0100
Message-Id: <1343298534-13611-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've done this before and it worked well last time. Here we're
duplicating a complex registration function to ease the process
of enabling it for Device Tree. As there are quite a few steps
taken during the registration process, it makes sense to break
them up into more manageable chunks. This patch will aid us.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   42 ++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 217df1d..d0bd030 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -223,6 +223,48 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_exit = msp13_i2s_exit,
 };
 
+/* Due for removal once the MSP driver has been fully DT:ed. */
+void mop500_of_msp_init(struct device *parent)
+{
+	struct platform_device *msp1;
+
+	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
+	platform_device_register(&snd_soc_mop500);
+
+	pr_info("Initialize MSP I2S-devices.\n");
+	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
+			   &msp0_platform_data);
+	msp1 = db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+			   &msp1_platform_data);
+	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
+			   &msp2_platform_data);
+	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
+			   &msp3_platform_data);
+
+	/* Get the pinctrl handle for MSP1 */
+	if (msp1) {
+		msp1_p = pinctrl_get(&msp1->dev);
+		if (IS_ERR(msp1_p))
+			dev_err(&msp1->dev, "could not get MSP1 pinctrl\n");
+		else {
+			msp1_def = pinctrl_lookup_state(msp1_p,
+							PINCTRL_STATE_DEFAULT);
+			if (IS_ERR(msp1_def)) {
+				dev_err(&msp1->dev,
+					"could not get MSP1 defstate\n");
+			}
+			msp1_sleep = pinctrl_lookup_state(msp1_p,
+							  PINCTRL_STATE_SLEEP);
+			if (IS_ERR(msp1_sleep))
+				dev_err(&msp1->dev,
+					"could not get MSP1 idlestate\n");
+		}
+	}
+
+	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
+	platform_device_register(&ux500_pcm);
+}
+
 void mop500_msp_init(struct device *parent)
 {
 	struct platform_device *msp1;
-- 
1.7.9.5

