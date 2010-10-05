Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab0JEK6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:58:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53317 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712Ab0JEK6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:58:01 -0400
Date: Tue, 5 Oct 2010 12:23:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] misc: Driver for APDS990X ALS and proximity sensors
Message-ID: <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
In-Reply-To: <1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	<1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int apds990x_refresh_athres(struct apds990x_chip *chip)
> +{
> +	int ret;
> +	/* If the chip is not in use, don't try to access it */
> +	if (pm_runtime_suspended(&chip->client->dev))
> +		return 0;
> +
> +	ret = apds990x_write_word(chip, APDS990X_AILTL,
> +			apds990x_lux_to_threshold(chip, chip->lux_thres_lo));
> +	ret |= apds990x_write_word(chip, APDS990X_AIHTL,
> +			apds990x_lux_to_threshold(chip, chip->lux_thres_hi));
> +

What is the locking theory in the driver for things like these multi word
writes. It's not clear from a first read how you guaranteed the refreshes
don't get tangled up or how you know there won't be an interrupt half way
through one of these pairs of accesses

> +static void apds990x_force_a_refresh(struct apds990x_chip *chip)
> +{
> +	/* This will force ALS interrupt after the next measurement. */
> +	apds990x_write_word(chip, APDS990X_AILTL, APDS_LUX_DEF_THRES_LO);
> +	apds990x_write_word(chip, APDS990X_AIHTL, APDS_LUX_DEF_THRES_HI);
> +}
> +
> +static void apds990x_force_p_refresh(struct apds990x_chip *chip)
> +{
> +	/* This will force proximity interrupt after the next measurement. */
> +	apds990x_write_word(chip, APDS990X_PILTL, APDS_PROX_DEF_THRES - 1);
> +	apds990x_write_word(chip, APDS990X_PIHTL, APDS_PROX_DEF_THRES);
> +}
> +

> +
> +	if (ret < 0)
> +		apds990x_force_a_refresh(chip); /* Bad result -> re-measure */

What stops this getting stuck forever - I admit it would probably need a
drastic case of strobe lighting but people do take phones to raves ..


> +static DEVICE_ATTR(lux0_input, S_IRUGO, apds990x_lux_show, NULL);

Are well all agreed on lux0_input ? I'm just putting some of the other
bits together to submit and using the same spec

> +static DEVICE_ATTR(lux0_input10x, S_IRUGO, apds990x_lux10x_show, NULL);

This seems daft. No doubt we'll want lux0_input100x next year

What's wrong with outputting %d.%d format to lux0_input - existing apps
will read the integer bit fine and we've not defined the interface yet
anyway.


> +	if ((value > APDS_RANGE) || (value == 0) ||
> +		(value < APDS_PROX_HYSTERESIS))
> +		return -EINVAL;

Excess brackets


> +	chip->regs[0].supply = reg_vcc;
> +	chip->regs[1].supply = reg_vled;

Shouldn't these come from the provided platform data ? and again if there
isn't a platform one supplied just skip the regulators. There are going
to be cases of boxes with regulator API stuff in use but who don't have
regulators for that device.



On the sysfs side

- not clear how power_state and runtime pm interact - do we in fact need
  power state ?
- lux0_input range being fixed seems inconvenient, the sensors I've got
  queued here use lux0_input as you do but also provide a read (and
  optionally writable) range limit in lux

static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
	als_sensing_range_show, als_sensing_range_store);

and in your case you could just return 65535


The sampling rate stuff is a bit different to what I have - in my case
writing to the sensing range alters the sampling rate requirements. I can
easily make either one adjust the other however so that fits nicely


