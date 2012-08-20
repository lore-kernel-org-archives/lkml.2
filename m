Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2HTUgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2HTUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:36:42 -0400
Date: Mon, 20 Aug 2012 13:36:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] backlight: Add Backlight driver for lm3630 chip
Message-Id: <20120820133639.aa6db587.akpm@linux-foundation.org>
In-Reply-To: <1344832471-13568-2-git-send-email-gshark.jeong@gmail.com>
References: <1344832471-13568-1-git-send-email-gshark.jeong@gmail.com>
	<1344832471-13568-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 13:34:31 +0900
"G.Shark Jeong" <gshark.jeong@gmail.com> wrote:

> This driver is a general version for LM3630 backlgiht driver chip of TI.
> 
> LM3630 :
> The LM3630 is a current mode boost converter which supplies the power
> and controls the current in two strings of up to 10 LEDs per string.
> Programming is done over an I2C compatible interface.
> www.ti.com

Looks OK to me.  Please review (and test!) my commentary-via-patch:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-backlight-driver-for-lm3630-chip-fix

- make bled_name[] static

- a few coding style tuneups

- create new set_intensity(), partly to avoid awkward layout gymnastics

Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: G.Shark Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630_bl.c |   41 ++++++++++++--------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-add-backlight-driver-for-lm3630-chip-fix drivers/video/backlight/Kconfig
diff -puN drivers/video/backlight/Makefile~backlight-add-backlight-driver-for-lm3630-chip-fix drivers/video/backlight/Makefile
diff -puN drivers/video/backlight/lm3630_bl.c~backlight-add-backlight-driver-for-lm3630-chip-fix drivers/video/backlight/lm3630_bl.c
--- a/drivers/video/backlight/lm3630_bl.c~backlight-add-backlight-driver-for-lm3630-chip-fix
+++ a/drivers/video/backlight/lm3630_bl.c
@@ -37,7 +37,7 @@ enum lm3630_leds {
 	BLED_2
 };
 
-const char *bled_name[] = {
+static const char *bled_name[] = {
 	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
 	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
 	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
@@ -62,15 +62,14 @@ static int __devinit lm3630_chip_init(st
 	struct lm3630_platform_data *pdata = pchip->pdata;
 
 	/*pwm control */
-	reg_val = ((pdata->pwm_active & 0x01) << 2)
-	    | (pdata->pwm_ctrl & 0x03);
+	reg_val = ((pdata->pwm_active & 0x01) << 2) | (pdata->pwm_ctrl & 0x03);
 	ret = regmap_update_bits(pchip->regmap, REG_CONFIG, 0x07, reg_val);
 	if (ret < 0)
 		goto out;
 
 	/* bank control */
-	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1)
-	    | (pdata->bank_a_ctrl & 0x07);
+	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1) |
+			(pdata->bank_a_ctrl & 0x07);
 	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x07, reg_val);
 	if (ret < 0)
 		goto out;
@@ -105,8 +104,9 @@ static void lm3630_delayed_func(struct w
 {
 	int ret;
 	unsigned int reg_val;
-	struct lm3630_chip_data *pchip =
-	    container_of(work, struct lm3630_chip_data, work.work);
+	struct lm3630_chip_data *pchip;
+
+	pchip = container_of(work, struct lm3630_chip_data, work.work);
 
 	ret = regmap_read(pchip->regmap, REG_INT_STATUS, &reg_val);
 	if (ret < 0) {
@@ -153,6 +153,16 @@ static int lm3630_intr_config(struct lm3
 	return 0;
 }
 
+static bool
+set_intensity(struct backlight_device *bl, struct lm3630_chip_data *pchip)
+{
+	if (!pchip->pdata->pwm_set_intensity)
+		return false;
+	pchip->pdata->pwm_set_intensity(bl->props.brightness - 1,
+					pchip->pdata->pwm_period);
+	return true;
+}
+
 /* update and get brightness */
 static int lm3630_bank_a_update_status(struct backlight_device *bl)
 {
@@ -170,14 +180,8 @@ static int lm3630_bank_a_update_status(s
 
 	/* pwm control */
 	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (pchip->pdata->pwm_set_intensity)
-			pchip->pdata->pwm_set_intensity(bl->props.brightness -
-							1,
-							pchip->pdata->
-							pwm_period);
-		else
-			dev_err(pchip->dev,
-				"No pwm control func. in plat-data\n");
+		if (!set_intensity(bl, pchip))
+			dev_err(pchip->dev, "No pwm control func. in plat-data\n");
 	} else {
 
 		/* i2c control */
@@ -242,12 +246,7 @@ static int lm3630_bank_b_update_status(s
 	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
 
 	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (pchip->pdata->pwm_set_intensity)
-			pchip->pdata->pwm_set_intensity(bl->props.brightness -
-							1,
-							pchip->pdata->
-							pwm_period);
-		else
+		if (!set_intensity(bl, pchip))
 			dev_err(pchip->dev,
 				"no pwm control func. in plat-data\n");
 	} else {
diff -puN include/linux/platform_data/lm3630_bl.h~backlight-add-backlight-driver-for-lm3630-chip-fix include/linux/platform_data/lm3630_bl.h
_

