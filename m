Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2L3UXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 15:23:38 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60781 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2L3UXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 15:23:31 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/2] pwm: vt8500: Add support for .set_polarity
Date: Mon, 31 Dec 2012 09:23:25 +1300
Message-Id: <1356899005-8876-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
References: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to set polarity on pwm devices, allowing for inverted
duty cycles.

Also update the binding document to #pwm-cells = <3> to allow
passing the flags from devicetree.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/pwm/vt8500-pwm.txt         |    7 ++++---
 drivers/pwm/pwm-vt8500.c                           |   21 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
index bcc6367..f71cc8d 100644
--- a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
@@ -3,14 +3,15 @@ VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
 Required properties:
 - compatible: should be "via,vt8500-pwm"
 - reg: physical base address and length of the controller's registers
-- #pwm-cells: should be 2.  The first cell specifies the per-chip index
-  of the PWM to use and the second cell is the period in nanoseconds.
+- #pwm-cells: should be 3.  The first cell specifies the per-chip index
+  of the PWM to use, the second cell is the period in nanoseconds, and the
+  third cell is for flags.
 - clocks: phandle to the PWM source clock
 
 Example:
 
 pwm1: pwm@d8220000 {
-	#pwm-cells = <2>;
+	#pwm-cells = <3>;
 	compatible = "via,vt8500-pwm";
 	reg = <0xd8220000 0x1000>;
 	clocks = <&clkpwm>;
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 27ed0f4..9abf561 100644
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
 
-- 
1.7.9.5

