Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2LRJMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:12:33 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33848 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2LRJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:12:30 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 04:12:29 EST
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/2] pinctrl: nomadik: return if prcm_base is NULL
Date: Tue, 18 Dec 2012 10:12:11 +0100
Message-Id: <1355821932-15799-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for npct->prcm_base to make sure that the
address is not NULL before using it, as the driver was made capable of
loading even without a proper memory resource in:

f1671bf pinctrl/nomadik: make independent of prcmu driver

Also, refuses to probe without prcm_base on anything else than nomadik.

This solves the following crash, introduced during the merge window when
booting on U8500 with device tree:

pinctrl-nomadik pinctrl-db8500: No PRCM base, assume no ALT-Cx control is available
Unable to handle kernel NULL pointer dereference at virtual address 00000138
pgd = c0004000
[00000138] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0    Not tainted  (3.7.0-02892-g1ebaf4f #631)
PC is at nmk_pmx_enable+0x1bc/0x4d0
LR is at clk_disable+0x40/0x44
[snip]
[<c01d5e50>] (nmk_pmx_enable+0x1bc/0x4d0) from [<c01d3ba8>] (pinmux_enable_setting+0x12c/0x1ec)
[<c01d3ba8>] (pinmux_enable_setting+0x12c/0x1ec) from [<c01d1dc8>] (pinctrl_select_state_locked+0xfc/0x134)
[<c01d1dc8>] (pinctrl_select_state_locked+0xfc/0x134) from [<c01d2814>] (pinctrl_register+0x26c/0x43c)
[<c01d2814>] (pinctrl_register+0x26c/0x43c) from [<c01d668c>] (nmk_pinctrl_probe+0x114/0x238)
[<c01d668c>] (nmk_pinctrl_probe+0x114/0x238) from [<c0211cc4>] (platform_drv_probe+0x28/0x2c)
[<c0211cc4>] (platform_drv_probe+0x28/0x2c) from [<c0210738>] (driver_probe_device+0x84/0x21c)
[<c0210738>] (driver_probe_device+0x84/0x21c) from [<c02109c0>] (__device_attach+0x50/0x54)
[<c02109c0>] (__device_attach+0x50/0x54) from [<c020eb1c>] (bus_for_each_drv+0x54/0x9c)
[<c020eb1c>] (bus_for_each_drv+0x54/0x9c) from [<c0210668>] (device_attach+0x84/0x9c)
[<c0210668>] (device_attach+0x84/0x9c) from [<c020fbac>] (bus_probe_device+0x94/0xb8)
[<c020fbac>] (bus_probe_device+0x94/0xb8) from [<c020e084>] (device_add+0x4f0/0x5bc)
[<c020e084>] (device_add+0x4f0/0x5bc) from [<c0276400>] (of_device_add+0x40/0x48)
[<c0276400>] (of_device_add+0x40/0x48) from [<c0276a98>] (of_platform_device_create_pdata+0x68/0x98)
[<c0276a98>] (of_platform_device_create_pdata+0x68/0x98) from [<c0276bac>] (of_platform_bus_create+0xe4/0x260)
[<c0276bac>] (of_platform_bus_create+0xe4/0x260) from [<c0276bf8>] (of_platform_bus_create+0x130/0x260)
[<c0276bf8>] (of_platform_bus_create+0x130/0x260) from [<c0276d94>] (of_platform_populate+0x6c/0xac)
[<c0276d94>] (of_platform_populate+0x6c/0xac) from [<c04a8224>] (u8500_init_machine+0x78/0x140)
[<c04a8224>] (u8500_init_machine+0x78/0x140) from [<c04a3560>] (customize_machine+0x24/0x30)
[<c04a3560>] (customize_machine+0x24/0x30) from [<c00087b0>] (do_one_initcall+0x130/0x1b0)
[<c00087b0>] (do_one_initcall+0x130/0x1b0) from [<c033ff9c>] (kernel_init+0x138/0x2e8)
[<c033ff9c>] (kernel_init+0x138/0x2e8) from [<c000eb18>] (ret_from_fork+0x14/0x20)
Code: 0a00001b e19400b2 e59a200c e0822000 (e592c000)
---[ end trace 1b75b31a2719ed1c ]---
note: swapper/0[1] exited with preempt_count 1
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index ef66f98..015b093 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -259,6 +259,9 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 	const struct prcm_gpiocr_altcx_pin_desc *pin_desc;
 	const u16 *gpiocr_regs;
 
+	if (!npct->prcm_base)
+		return;
+
 	if (alt_num > PRCM_IDX_GPIOCR_ALTC_MAX) {
 		dev_err(npct->dev, "PRCM GPIOCR: alternate-C%i is invalid\n",
 			alt_num);
@@ -682,6 +685,9 @@ static int nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
 	const struct prcm_gpiocr_altcx_pin_desc *pin_desc;
 	const u16 *gpiocr_regs;
 
+	if (!npct->prcm_base)
+		return NMK_GPIO_ALT_C;
+
 	for (i = 0; i < npct->soc->npins_altcx; i++) {
 		if (npct->soc->altcx_pins[i].pin == gpio)
 			break;
@@ -1887,9 +1893,12 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 				"failed to ioremap PRCM registers\n");
 			return -ENOMEM;
 		}
-	} else {
+	} else if (version == PINCTRL_NMK_STN8815) {
 		dev_info(&pdev->dev,
 			 "No PRCM base, assume no ALT-Cx control is available\n");
+	} else {
+		dev_err(&pdev->dev, "missing PRCM base address\n");
+		return -EINVAL;
 	}
 
 	/*
-- 
1.7.12.1

