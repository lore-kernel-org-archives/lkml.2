Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2CZK1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:27:40 -0400
Received: from fw2.prolan.hu ([193.68.50.107]:41860 "EHLO fw2.prolan.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab2CZK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:27:30 -0400
Message-ID: <4F704490.7000308@prolan.hu>
Date: Mon, 26 Mar 2012 12:27:28 +0200
From: Peter Rusko <rusko.peter@prolan.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>
Subject: Re: PCA GPIO interrupt triggers, matrix-keypad
References: <4F6B4C11.4000608@prolan.hu> <20120325074012.GA25173@pengutronix.de>
In-Reply-To: <20120325074012.GA25173@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [193.91.83.115]
X-EsetResult: clean, is OK
X-EsetId: 525F3323825E3531001D68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ? I fail to see why having EDGE_FALLING together with EDGE_RISING is not
> supported. Are you sure you didn't use some other IRQ_TYPE here?
>
Yes, you're right, the problem is not there.

>> I think, this patch should work:
>
> Think? Can't you test it :)
I wish that could be that simple :)

I can test it with the matrix-keypad driver. But there's an inverter
(+delay) in the circuit (to prevent contact bounce) and I don't know how
it affects the signals. But in the end sometimes I don't get e.g. the
key-release event.

Another change in the code was with the IRQ request. I could only make
the matrix-keypad driver working with threaded interrupts:

diff --git a/drivers/input/keyboard/matrix_keypad.c 
b/drivers/input/keyboard/matrix_keypad.c
index e2ae657..f047502 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -48,7 +48,7 @@ struct matrix_keypad {
  static void __activate_col(const struct matrix_keypad_platform_data 
*pdata,
                            int col, bool on)
  {
-       bool level_on = !pdata->active_low;
+       bool level_on = (!pdata->active_low)^(!!pdata->invert_output);

         if (on) {
                 gpio_direction_output(pdata->col_gpios[col], level_on);
@@ -341,7 +341,8 @@ static int __devinit init_matrix_gpio(struct 
platform_device *pdev,
                 }
         } else {
                 for (i = 0; i < pdata->num_row_gpios; i++) {
-                       err = request_irq(gpio_to_irq(pdata->row_gpios[i]),
+                       err = 
request_threaded_irq(gpio_to_irq(pdata->row_gpios[i]),
+                                       NULL,
                                         matrix_keypad_interrupt,
                                         IRQF_TRIGGER_RISING |
                                         IRQF_TRIGGER_FALLING,

Is this okay, or is there another way?

Regards,
Peter
