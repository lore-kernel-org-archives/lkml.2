Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1GYNzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:55:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36900 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1GYNzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:55:35 -0400
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 15:55:34 +0200
Message-ID: <CAC+thW0Cx4pQDeZ2ZJfvFMfv23ExDmS5LDM8_-1Nz23t1TpJcA@mail.gmail.com>
Subject: power: bq20z75: problem with optional battery detect gpio feature
From: Andrea Galbusera <gizero@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the in-object feature really optional?
If battery_detect field in my bq20z75_platform_data structure is not
explicitly set, I suspect the driver ends up requesting an irq for the
GPIO number 0. This look indesirable.

Here is the relevant code snip form bq20z75_probe():

if (pdata) {
	bq20z75_device->gpio_detect =
		gpio_is_valid(pdata->battery_detect);    // GPIO 0 _IS_ a valid gpio !!
	bq20z75_device->pdata = pdata;
}

[...]

if (!bq20z75_device->gpio_detect)
	goto skip_gpio;

[...]

irq = gpio_to_irq(pdata->battery_detect);

[...]

rc = request_irq(irq, bq20z75_irq,
	IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
	dev_name(&client->dev), &bq20z75_device->power_supply);


I cannot find in gpio related headers any sort of "GPIO_INVALID"
symbol to explicitly declare that I don't want this feature. I'm
temporarily setting it to ARCH_NR_GPIOS but I believe we need to
disambiguate GPIO number 0 from "disable feature".
Correct?

Regards,
Andrea
