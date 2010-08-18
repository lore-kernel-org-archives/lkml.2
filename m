Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0HRKKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:10:20 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58760 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab0HRKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:10:18 -0400
Date: Wed, 18 Aug 2010 15:39:50 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC] gpio/stmpe: add bitmask to block requests to unavailable
 GPIOs
Message-ID: <20100818100950.GA19706@bnru01.bnr.st.com>
References: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 17:14:44 +0200, Wolfram Sang wrote:
> GPIOs on these controller are multi-functional. If you decided to use
> some of them e.g. as input channels for the ADC, you surely don't want
> those pins to be reassigned as simple GPIOs (which may be triggered even
> from userspace via 'export'). Same for the touchscreen controller pins.
> Since knowledge about the hardware is needed to decide which GPIOs to
> reserve, let this bitmask be inside platform_data and provide some
> defines to assist potential users.

Could this be done without the platform data, say something like the
below?  (Though this does assume that nobody tries to request GPIOs
before the STMPE subdrivers reserve their pins.)

diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 656148e..d1595f9 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -179,6 +179,12 @@ static int __devinit stmpe_init_hw(struct stmpe_touch *ts)
 		return ret;
 	}
 
+	ret = stmpe_set_altfunc(stmpe, 0xf0, STMPE_BLOCK_TOUCHSCREEN);
+	if (ret) {
+		dev_err(dev, "Could not enable alternate function for pins\n");
+		return ret;
+	}
+
 	adc_ctrl1 = SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
 		REF_SEL(ts->ref_sel);
 	adc_ctrl1_mask = SAMPLE_TIME(0xff) | MOD_12B(0xff) | REF_SEL(0xff);
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 0754c5e9..4f748fa 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -253,6 +253,12 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, enum stmpe_block block)
 
 	mutex_lock(&stmpe->lock);
 
+	if (block == STMPE_BLOCK_GPIO && (pins & stmpe->af_pins)) {
+		dev_dbg(stmpe->dev, "not allowing change of AF pins to GPIO\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = __stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
 	if (ret < 0)
 		goto out;
@@ -274,6 +280,11 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, enum stmpe_block block)
 		pins &= ~(1 << pin);
 	}
 
+	if (block == STMPE_BLOCK_GPIO)
+		stmpe->af_pins &= ~pins;
+	else
+		stmpe->af_pins |= pins;
+
 	ret = __stmpe_block_write(stmpe, regaddr, numregs, regs);
 
 out:
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 39ca758..ba5a847 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -64,6 +64,7 @@ struct stmpe_variant_info;
  * @num_gpios: number of gpios, differs for variants
  * @ier: cache of IER registers for bus_lock
  * @oldier: cache of IER registers for bus_lock
+ * @af_pins: mask of pins set in alternate function mode
  * @pdata: platform data
  */
 struct stmpe {
@@ -79,6 +80,7 @@ struct stmpe {
 	int num_gpios;
 	u8 ier[2];
 	u8 oldier[2];
+	u32 af_pins;
 	struct stmpe_platform_data *pdata;
 };
 
