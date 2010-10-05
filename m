Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0JELsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:48:43 -0400
Received: from smtp.nokia.com ([147.243.1.47]:56484 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0JELsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:48:42 -0400
Subject: Re: [PATCH 3/5] misc: Driver for APDS990X ALS and proximity sensors
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	 <1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com>
	 <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 05 Oct 2010 14:48:33 +0300
Message-Id: <1286279313.21781.29.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks

-Samu

On Tue, 2010-10-05 at 13:23 +0200, ext Alan Cox wrote:
> > +static int apds990x_refresh_athres(struct apds990x_chip *chip)
> > +{
> > +	int ret;
> > +	/* If the chip is not in use, don't try to access it */
> > +	if (pm_runtime_suspended(&chip->client->dev))
> > +		return 0;
> > +
> > +	ret = apds990x_write_word(chip, APDS990X_AILTL,
> > +			apds990x_lux_to_threshold(chip, chip->lux_thres_lo));
> > +	ret |= apds990x_write_word(chip, APDS990X_AIHTL,
> > +			apds990x_lux_to_threshold(chip, chip->lux_thres_hi));
> > +
> 
> What is the locking theory in the driver for things like these multi word
> writes. It's not clear from a first read how you guaranteed the refreshes
> don't get tangled up or how you know there won't be an interrupt half way
> through one of these pairs of accesses
> 
I'll double check that and add comments or mutexes if needed.

> > +static void apds990x_force_a_refresh(struct apds990x_chip *chip)
> > +{
> > +	/* This will force ALS interrupt after the next measurement. */
> > +	apds990x_write_word(chip, APDS990X_AILTL, APDS_LUX_DEF_THRES_LO);
> > +	apds990x_write_word(chip, APDS990X_AIHTL, APDS_LUX_DEF_THRES_HI);
> > +}
> > +
> > +static void apds990x_force_p_refresh(struct apds990x_chip *chip)
> > +{
> > +	/* This will force proximity interrupt after the next measurement. */
> > +	apds990x_write_word(chip, APDS990X_PILTL, APDS_PROX_DEF_THRES - 1);
> > +	apds990x_write_word(chip, APDS990X_PIHTL, APDS_PROX_DEF_THRES);
> > +}
> > +
> 
> > +
> > +	if (ret < 0)
> > +		apds990x_force_a_refresh(chip); /* Bad result -> re-measure */
> 
> What stops this getting stuck forever - I admit it would probably need a
> drastic case of strobe lighting but people do take phones to raves ..

Sensor averages light over 50ms period. Strobe light can cause anything.
But problem is that if the measurement overflows bright light causes 0
lux as a result. Re-measurement takes also one measurement period so it
not causing i.e. interrupt flow, but it may cause situation that resuls
is never available.

> 
> 
> > +static DEVICE_ATTR(lux0_input, S_IRUGO, apds990x_lux_show, NULL);
> 
> Are well all agreed on lux0_input ? I'm just putting some of the other
> bits together to submit and using the same spec
> 
> > +static DEVICE_ATTR(lux0_input10x, S_IRUGO, apds990x_lux10x_show, NULL);
> 
> This seems daft. No doubt we'll want lux0_input100x next year
> 
> What's wrong with outputting %d.%d format to lux0_input - existing apps
> will read the integer bit fine and we've not defined the interface yet
> anyway.
> 

Makes sense.

> 
> > +	if ((value > APDS_RANGE) || (value == 0) ||
> > +		(value < APDS_PROX_HYSTERESIS))
> > +		return -EINVAL;
> 
> Excess brackets
> 
> 
> > +	chip->regs[0].supply = reg_vcc;
> > +	chip->regs[1].supply = reg_vled;
> 
> Shouldn't these come from the provided platform data ? and again if there
> isn't a platform one supplied just skip the regulators. There are going
> to be cases of boxes with regulator API stuff in use but who don't have
> regulators for that device.

I'll change that.

> 
> 
> 
> On the sysfs side
> 
> - not clear how power_state and runtime pm interact - do we in fact need
>   power state ?

power_state turns chip on or off. In off state runtime pm is used to
handle bookkeeping and also handling chip state transitions including
regulators. Other ideas than separate power_state for this kind of
control? 


> - lux0_input range being fixed seems inconvenient, the sensors I've got
>   queued here use lux0_input as you do but also provide a read (and
>   optionally writable) range limit in lux
> 
> static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
> 	als_sensing_range_show, als_sensing_range_store);
> 
> and in your case you could just return 65535
> 

I'll add that

> 
> The sampling rate stuff is a bit different to what I have - in my case
> writing to the sensing range alters the sampling rate requirements. I can
> easily make either one adjust the other however so that fits nicely
> 
> 

