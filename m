Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1JPSpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:45:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42850 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab1JPSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E985C60.9020308@cam.ac.uk>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
	<1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
	<20111013143224.GO1098@sirena.org.uk>
	<4E96F9AC.9000001@cam.ac.uk>
	<20111013204410.GA17160@sirena.org.uk>
	<4E985C60.9020308@cam.ac.uk>
Date: Sun, 16 Oct 2011 20:45:06 +0200
Message-ID: <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        zdevai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Jonathan Cameron <jic23@cam.ac.uk>:

> I'm trying to work out what our equivalent of the clk finding api is.

Judging from the ideal use of our in-tree driver
drivers/mfd/ab8500-gpadc.c a map like this would be
great

struct adc_map {
        struct device *adc_dev;
        const char *adc_dev_name;
        const char *channel;
        struct device *dev;
        const char *dev_name;
};

{ adc_dev, adc_dev_name } are alternative-compulsory identifiers for
the ADC

channel: string identifying the channel on the ADC, strings have
been shown to be good for identifying things.

{ dev, dev_name } are alternative-compulsory identifiers for the
ADC client.

struct device * pointers take precedence, fallback to names if device
pointers are unavailable.

adc_dev_name is the name of the ADC and then I mean what is returned
from it's struct device *dev when you do dev_name() on it. dev_name is
well dev_name(dev);

Then this API feels comfortable:

struct adc *adc_get(struct device *dev, const char *channel);
void adc_put(struct adc *adc);
int adc_read_raw(struct adc *adc, int *val);

We can then add adc_read_voltage(), adc_read_temperature(), adc_read_foo() ...

Usage in say a hwmon driver or whatever:

struct adc *mr_adc = adc_get(dev, NULL);
/*
 * Optional channel parameter used only when a single
 * device use more than one channel, as with clock names
 * or regulator names, so pass in NULL for the one channel
 * tied to this device.
 */
ret = adc_read_raw(mr_adc, &val);
(...)
adc_put(mr_adc);

But this is just what looks useful to us.

Yours,
Linus Walleij
