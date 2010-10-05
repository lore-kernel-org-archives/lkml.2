Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0JEMhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:37:16 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:25757 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0JEMhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:37:14 -0400
Subject: Re: [PATCH 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101005130102.7690c484@lxorguk.ukuu.org.uk>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	 <1286271779-19819-2-git-send-email-samu.p.onkalo@nokia.com>
	 <20101005122157.149f14d0@lxorguk.ukuu.org.uk>
	 <1286278190.21781.10.camel@4fid08082>
	 <20101005130102.7690c484@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 05 Oct 2010 15:37:06 +0300
Message-Id: <1286282226.21781.60.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 14:01 +0200, ext Alan Cox wrote:
> On Tue, 05 Oct 2010 14:29:50 +0300

> > > > +	for (i = 0; i < ARRAY_SIZE(prox_rates); i++)
> > > > +		if (prox_rates[i] == rate_threshold) {
> > > > +			chip->prox_rate_threshold = i;
> > > > +			return 0;
> > > > +		}
> > > > +
> > > > +	return -EINVAL;
> > > 
> > > This makes it hard for generic code. Wouldn't picking the best (first at
> > > least as good as required) be a bit more polite to user space ?
> > 
> > Well, perhaps it is better to have hardcoded (or platform specific)
> > rates instead of control interface. I'll change that.
> 
> I don't see a problem with a rate setting where you ask for 'at least X'
> and get the nearest ? Ie swap the == for a >= ?

ok.

> 
> > > This makes no sense because you can't poll() a sysfs file
> > 
> > ok, what should be returned when there is no valid results available?
> 
> I have the same problem with the isl29020 - I think you have to block,
> there isn't any other sane response. A user given -EAGAIN simply doesn't
> know what to do
> 

-EIO then the chip is not running and otherwise block until data is
available.

> 
> > > > +static ssize_t bhsfh_lux_calib_show(struct device *dev,
> > > > +				 struct device_attribute *attr, char *buf)
> > > > +{
> > > > +	struct bhsfh_chip *chip = dev_get_drvdata(dev);
> > > > +	return snprintf(buf, PAGE_SIZE, "%u\n", chip->lux_calib);
> > > > +}
> > > 
> > > This is short chip->mutex locks as you sometimes temporarily change the
> > > value (error path below)
> > > 
> > 
> > ?

of course...

> If I am doing a calib store and a calib show in parallel then the show
> can give a bogus answer because of this bit of code
> 
> > > > +	mutex_lock(&chip->mutex);
> > > > +	old_calib = chip->lux_calib;
> > > > +	chip->lux_calib = value;
> > > > +	new_corr = bhsfh_get_corr_value(chip);
> > > > +	if (new_corr == 0) {
> 
> [Show can occur here]
> 
> > > > +		chip->lux_calib = old_calib;
> > > > +		mutex_unlock(&chip->mutex);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +	chip->lux_corr = new_corr;
> > > > +	mutex_unlock(&chip->mutex);
> > > > +
> > > > +	return len;
> 
> 

