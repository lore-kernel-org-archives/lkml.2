Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2KMI3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KMI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:35 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 04/13] MFD/rtc/gpio: twl: No need to allocate bigger buffer for write
Date: Tue, 13 Nov 2012 09:28:45 +0100
Message-ID: <1352795334-7406-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the twl-core has been converted to use regmap it is no longer needed
to allocate bigger buffer for data when writing to twl.

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 12 ++++++------
 drivers/mfd/twl-core.c      |  9 ++-------
 drivers/mfd/twl4030-irq.c   |  6 +++---
 drivers/mfd/twl6030-irq.c   |  4 ++--
 drivers/rtc/rtc-twl.c       | 32 ++++++++++++++++----------------
 5 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index c5f8ca2..88829c3 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -354,13 +354,13 @@ static struct gpio_chip twl_gpiochip = {
 
 static int __devinit gpio_twl4030_pulls(u32 ups, u32 downs)
 {
-	u8		message[6];
+	u8		message[5];
 	unsigned	i, gpio_bit;
 
 	/* For most pins, a pulldown was enabled by default.
 	 * We should have data that's specific to this board.
 	 */
-	for (gpio_bit = 1, i = 1; i < 6; i++) {
+	for (gpio_bit = 1, i = 0; i < 5; i++) {
 		u8		bit_mask;
 		unsigned	j;
 
@@ -379,16 +379,16 @@ static int __devinit gpio_twl4030_pulls(u32 ups, u32 downs)
 
 static int __devinit gpio_twl4030_debounce(u32 debounce, u8 mmc_cd)
 {
-	u8		message[4];
+	u8		message[3];
 
 	/* 30 msec of debouncing is always used for MMC card detect,
 	 * and is optional for everything else.
 	 */
-	message[1] = (debounce & 0xff) | (mmc_cd & 0x03);
+	message[0] = (debounce & 0xff) | (mmc_cd & 0x03);
 	debounce >>= 8;
-	message[2] = (debounce & 0xff);
+	message[1] = (debounce & 0xff);
 	debounce >>= 8;
-	message[3] = (debounce & 0x03);
+	message[2] = (debounce & 0x03);
 
 	return twl_i2c_write(TWL4030_MODULE_GPIO, message,
 				REG_GPIO_DEBEN1, 3);
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 5043f505a..a55ab15 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -344,7 +344,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	twl = &twl_modules[sid];
 
 	ret = regmap_bulk_write(twl->regmap, twl_map[mod_no].base + reg,
-				&value[1], num_bytes);
+				value, num_bytes);
 
 	if (ret)
 		pr_err("%s: Write failed (mod %d, reg 0x%02x count %d)\n",
@@ -406,12 +406,7 @@ EXPORT_SYMBOL(twl_i2c_read);
  */
 int twl_i2c_write_u8(u8 mod_no, u8 value, u8 reg)
 {
-
-	/* 2 bytes offset 1 contains the data offset 0 is used by i2c_write */
-	u8 temp_buffer[2] = { 0 };
-	/* offset 1 contains the data */
-	temp_buffer[1] = value;
-	return twl_i2c_write(mod_no, temp_buffer, reg, 1);
+	return twl_i2c_write(mod_no, &value, reg, 1);
 }
 EXPORT_SYMBOL(twl_i2c_write_u8);
 
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index ad733d7..e900402 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -501,7 +501,7 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		} imr;
 
 		/* byte[0] gets overwritten as we write ... */
-		imr.word = cpu_to_le32(agent->imr << 8);
+		imr.word = cpu_to_le32(agent->imr);
 		agent->imr_change_pending = false;
 
 		/* write the whole mask ... simpler than subsetting it */
@@ -526,7 +526,7 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		 * any processor on the other IRQ line, EDR registers are
 		 * shared.
 		 */
-		status = twl_i2c_read(sih->module, bytes + 1,
+		status = twl_i2c_read(sih->module, bytes,
 				sih->edr_offset, sih->bytes_edr);
 		if (status) {
 			pr_err("twl4030: %s, %s --> %d\n", __func__,
@@ -538,7 +538,7 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		while (edge_change) {
 			int		i = fls(edge_change) - 1;
 			struct irq_data	*idata;
-			int		byte = 1 + (i >> 2);
+			int		byte = i >> 2;
 			int		off = (i & 0x3) * 2;
 			unsigned int	type;
 
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index b76902f..277a8db 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -355,7 +355,7 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	static struct irq_chip  twl6030_irq_chip;
 	int			status = 0;
 	int			i;
-	u8			mask[4];
+	u8			mask[3];
 
 	nr_irqs = TWL6030_NR_IRQS;
 
@@ -370,9 +370,9 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 
 	irq_end = irq_base + nr_irqs;
 
+	mask[0] = 0xFF;
 	mask[1] = 0xFF;
 	mask[2] = 0xFF;
-	mask[3] = 0xFF;
 
 	/* mask all int lines */
 	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9277d94..8b7464c 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -233,7 +233,7 @@ static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
  */
 static int twl_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	unsigned char rtc_data[ALL_TIME_REGS];
 	int ret;
 	u8 save_control;
 	u8 rtc_control;
@@ -300,15 +300,15 @@ static int twl_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char save_control;
-	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	unsigned char rtc_data[ALL_TIME_REGS];
 	int ret;
 
-	rtc_data[1] = bin2bcd(tm->tm_sec);
-	rtc_data[2] = bin2bcd(tm->tm_min);
-	rtc_data[3] = bin2bcd(tm->tm_hour);
-	rtc_data[4] = bin2bcd(tm->tm_mday);
-	rtc_data[5] = bin2bcd(tm->tm_mon + 1);
-	rtc_data[6] = bin2bcd(tm->tm_year - 100);
+	rtc_data[0] = bin2bcd(tm->tm_sec);
+	rtc_data[1] = bin2bcd(tm->tm_min);
+	rtc_data[2] = bin2bcd(tm->tm_hour);
+	rtc_data[3] = bin2bcd(tm->tm_mday);
+	rtc_data[4] = bin2bcd(tm->tm_mon + 1);
+	rtc_data[5] = bin2bcd(tm->tm_year - 100);
 
 	/* Stop RTC while updating the TC registers */
 	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
@@ -341,7 +341,7 @@ out:
  */
 static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	unsigned char rtc_data[ALL_TIME_REGS];
 	int ret;
 
 	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
@@ -368,19 +368,19 @@ static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 
 static int twl_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	unsigned char alarm_data[ALL_TIME_REGS + 1];
+	unsigned char alarm_data[ALL_TIME_REGS];
 	int ret;
 
 	ret = twl_rtc_alarm_irq_enable(dev, 0);
 	if (ret)
 		goto out;
 
-	alarm_data[1] = bin2bcd(alm->time.tm_sec);
-	alarm_data[2] = bin2bcd(alm->time.tm_min);
-	alarm_data[3] = bin2bcd(alm->time.tm_hour);
-	alarm_data[4] = bin2bcd(alm->time.tm_mday);
-	alarm_data[5] = bin2bcd(alm->time.tm_mon + 1);
-	alarm_data[6] = bin2bcd(alm->time.tm_year - 100);
+	alarm_data[0] = bin2bcd(alm->time.tm_sec);
+	alarm_data[1] = bin2bcd(alm->time.tm_min);
+	alarm_data[2] = bin2bcd(alm->time.tm_hour);
+	alarm_data[3] = bin2bcd(alm->time.tm_mday);
+	alarm_data[4] = bin2bcd(alm->time.tm_mon + 1);
+	alarm_data[5] = bin2bcd(alm->time.tm_year - 100);
 
 	/* update all the alarm registers in one shot */
 	ret = twl_i2c_write(TWL_MODULE_RTC, alarm_data,
-- 
1.8.0

