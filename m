Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3ABTzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:55:32 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:54351 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3ABTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:55:30 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv2 2/2] pwm: vt8500: Add polarity support
Date: Thu,  3 Jan 2013 08:44:16 +1300
Message-Id: <1357155856-9552-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357155856-9552-1-git-send-email-linux@prisktech.co.nz>
References: <1357155856-9552-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to set polarity on PWM devices, allowing for inverted
duty cycles.

Also update the binding document to #pwm-cells = <3> to allow
passing the flags from devicetree.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
v2:
Change binding document to detail flags usage.
Add missing .of_xlate function
Add missing .of_pwm_n_cells

 .../devicetree/bindings/pwm/vt8500-pwm.txt         |    9 +++++---
 drivers/pwm/pwm-vt8500.c                           |   23 ++++++++++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
index bcc6367..d21d82d 100644
--- a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
@@ -3,14 +3,17 @@ VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
 Required properties:
 - compatible: should be "via,vt8500-pwm"
 - reg: physical base address and length of the controller's registers
-- #pwm-cells: should be 2.  The first cell specifies the per-chip index
-  of the PWM to use and the second cell is the period in nanoseconds.
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period in nanoseconds and bit 0 in the third cell is used to
+  encode the polarity of PWM output. Set bit 0 of the third in PWM specifier
+  to 1 for inverse polarity & set to 0 for normal polarity.
 - clocks: phandle to the PWM source clock
 
 Example:
 
 pwm1: pwm@d8220000 {
-	#pwm-cells = <2>;
+	#pwm-cells = <3>;
 	compatible = "via,vt8500-pwm";
 	reg = <0xd8220000 0x1000>;
 	clocks = <&clkpwm>;
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index bbc3750..98d79e9 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -164,10 +164,31 @@ static void vt8500_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	clk_disable(vt8500->clk);
 }
 
+static int vt8500_pwm_set_polarity(struct pwm_chip *chip,
+				   struct pwm_device *pwm,
+				   enum pwm_polarity polarity)
+{
+	struct vt8500_chip *vt8500 = to_vt8500_chip(chip);
+	u32 val;
+
+	val = readl(vt8500->base + REG_CTRL(pwm->hwpwm));
+
+	if (polarity == PWM_POLARITY_INVERSED)
+		val |= CTRL_INVERT;
+	else
+		val &= ~CTRL_INVERT;
+
+	writel(val, vt8500->base + REG_CTRL(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_CTRL_UPDATE);
+
+	return 0;
+}
+
 static struct pwm_ops vt8500_pwm_ops = {
 	.enable = vt8500_pwm_enable,
 	.disable = vt8500_pwm_disable,
 	.config = vt8500_pwm_config,
+	.set_polarity = vt8500_pwm_set_polarity,
 	.owner = THIS_MODULE,
 };
 
@@ -197,6 +218,8 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 
 	chip->chip.dev = &pdev->dev;
 	chip->chip.ops = &vt8500_pwm_ops;
+	chip->chip.of_xlate = of_pwm_xlate_with_flags;
+	chip->chip.of_pwm_n_cells = 3;
 	chip->chip.base = -1;
 	chip->chip.npwm = VT8500_NR_PWMS;
 
-- 
1.7.9.5

