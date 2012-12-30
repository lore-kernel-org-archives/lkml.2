Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2L3UXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 15:23:30 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57008 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2L3UX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 15:23:28 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/2] pwm: vt8500: Register write busy test performed incorrectly
Date: Mon, 31 Dec 2012 09:23:24 +1300
Message-Id: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct operation for register writes is to perform a busy-wait
after writing the register. Currently the busy wait it performed
before, meaning subsequent register writes to bitfields may occur
before the previous field has been updated.

Also, all registers are defined as 32-bit read/write. Change
pwm_busy_wait() to use readl rather than readb.

Improve readability of code with defines for registers and bitfields.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Thierry,

This patch is a fix but it can go to 3.9 rather than 3.8 (if you prefer)
as the incorrect behaviour doesn't seem to cause a problem on current
hardware.

 drivers/pwm/pwm-vt8500.c |   62 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index b0ba2d4..27ed0f4 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -36,6 +36,25 @@
  */
 #define VT8500_NR_PWMS	2
 
+#define REG_CTRL(pwm)		(pwm << 4) + 0x00
+#define REG_SCALAR(pwm)		(pwm << 4) + 0x04
+#define REG_PERIOD(pwm)		(pwm << 4) + 0x08
+#define REG_DUTY(pwm)		(pwm << 4) + 0x0C
+#define REG_STATUS		0x40
+
+#define CTRL_ENABLE		BIT(0)
+#define CTRL_INVERT		BIT(1)
+#define CTRL_AUTOLOAD		BIT(2)
+#define CTRL_STOP_IMM		BIT(3)
+#define CTRL_LOAD_PRESCALE	BIT(4)
+#define CTRL_LOAD_PERIOD	BIT(5)
+
+#define STATUS_CTRL_UPDATE	BIT(0)
+#define STATUS_SCALAR_UPDATE	BIT(1)
+#define STATUS_PERIOD_UPDATE	BIT(2)
+#define STATUS_DUTY_UPDATE	BIT(3)
+#define STATUS_ALL_UPDATE	0x0F
+
 struct vt8500_chip {
 	struct pwm_chip chip;
 	void __iomem *base;
@@ -45,15 +64,17 @@ struct vt8500_chip {
 #define to_vt8500_chip(chip)	container_of(chip, struct vt8500_chip, chip)
 
 #define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
-static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
+static inline void pwm_busy_wait(struct vt8500_chip *vt8500, int nr, u8 bitmask)
 {
 	int loops = msecs_to_loops(10);
-	while ((readb(reg) & bitmask) && --loops)
+	u32 mask = bitmask << (nr << 8);
+
+	while ((readl(vt8500->base + REG_STATUS) & mask) && --loops)
 		cpu_relax();
 
 	if (unlikely(!loops))
 		pr_warn("Waiting for status bits 0x%x to clear timed out\n",
-			   bitmask);
+			   mask);
 }
 
 static int vt8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -63,6 +84,7 @@ static int vt8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long c;
 	unsigned long period_cycles, prescale, pv, dc;
 	int err;
+	u32 val;
 
 	err = clk_enable(vt8500->clk);
 	if (err < 0) {
@@ -91,14 +113,19 @@ static int vt8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	do_div(c, period_ns);
 	dc = c;
 
-	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 1));
-	writel(prescale, vt8500->base + 0x4 + (pwm->hwpwm << 4));
+	writel(prescale, vt8500->base + REG_SCALAR(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_SCALAR_UPDATE);
+
+	writel(pv, vt8500->base + REG_PERIOD(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_PERIOD_UPDATE);
 
-	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 2));
-	writel(pv, vt8500->base + 0x8 + (pwm->hwpwm << 4));
+	writel(dc, vt8500->base + REG_DUTY(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_DUTY_UPDATE);
 
-	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 3));
-	writel(dc, vt8500->base + 0xc + (pwm->hwpwm << 4));
+	val = readl(vt8500->base + REG_CTRL(pwm->hwpwm));
+	val |= CTRL_AUTOLOAD;
+	writel(val, vt8500->base + REG_CTRL(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_CTRL_UPDATE);
 
 	clk_disable(vt8500->clk);
 	return 0;
@@ -106,8 +133,9 @@ static int vt8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 static int vt8500_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	int err;
 	struct vt8500_chip *vt8500 = to_vt8500_chip(chip);
+	int err;
+	u32 val;
 
 	err = clk_enable(vt8500->clk);
 	if (err < 0) {
@@ -115,17 +143,23 @@ static int vt8500_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 		return err;
 	}
 
-	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 0));
-	writel(5, vt8500->base + (pwm->hwpwm << 4));
+	val = readl(vt8500->base + REG_CTRL(pwm->hwpwm));
+	val |= CTRL_ENABLE;
+	writel(val, vt8500->base + REG_CTRL(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_CTRL_UPDATE);
+
 	return 0;
 }
 
 static void vt8500_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct vt8500_chip *vt8500 = to_vt8500_chip(chip);
+	u32 val;
 
-	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 0));
-	writel(0, vt8500->base + (pwm->hwpwm << 4));
+	val = readl(vt8500->base + REG_CTRL(pwm->hwpwm));
+	val &= ~CTRL_ENABLE;
+	writel(val, vt8500->base + REG_CTRL(pwm->hwpwm));
+	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_CTRL_UPDATE);
 
 	clk_disable(vt8500->clk);
 }
-- 
1.7.9.5

