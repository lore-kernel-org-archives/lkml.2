Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0JELfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:35:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46007 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751589Ab0JELff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:35:35 -0400
Date: Tue, 5 Oct 2010 13:01:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: samu.p.onkalo@nokia.com
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
Message-ID: <20101005130102.7690c484@lxorguk.ukuu.org.uk>
In-Reply-To: <1286278190.21781.10.camel@4fid08082>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	<1286271779-19819-2-git-send-email-samu.p.onkalo@nokia.com>
	<20101005122157.149f14d0@lxorguk.ukuu.org.uk>
	<1286278190.21781.10.camel@4fid08082>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Oct 2010 14:29:50 +0300
Onkalo Samu <samu.p.onkalo@nokia.com> wrote:

> 
> Alan, thanks for comments
> 
> -Samu
> 
> On Tue, 2010-10-05 at 13:21 +0200, ext Alan Cox wrote:
> > On Tue,  5 Oct 2010 12:42:55 +0300
> > Samu Onkalo <samu.p.onkalo@nokia.com> wrote:
> > 
> > > This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
> > > ALS and proximity sensor.
> > 
> > Same comment about regulators.
> 
> ?

As the other review for the light sensor


> > > +	for (i = 0; i < ARRAY_SIZE(prox_rates); i++)
> > > +		if (prox_rates[i] == rate_threshold) {
> > > +			chip->prox_rate_threshold = i;
> > > +			return 0;
> > > +		}
> > > +
> > > +	return -EINVAL;
> > 
> > This makes it hard for generic code. Wouldn't picking the best (first at
> > least as good as required) be a bit more polite to user space ?
> 
> Well, perhaps it is better to have hardcoded (or platform specific)
> rates instead of control interface. I'll change that.

I don't see a problem with a rate setting where you ask for 'at least X'
and get the nearest ? Ie swap the == for a >= ?

> > This makes no sense because you can't poll() a sysfs file
> 
> ok, what should be returned when there is no valid results available?

I have the same problem with the isl29020 - I think you have to block,
there isn't any other sane response. A user given -EAGAIN simply doesn't
know what to do


> > > +static ssize_t bhsfh_lux_calib_show(struct device *dev,
> > > +				 struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct bhsfh_chip *chip = dev_get_drvdata(dev);
> > > +	return snprintf(buf, PAGE_SIZE, "%u\n", chip->lux_calib);
> > > +}
> > 
> > This is short chip->mutex locks as you sometimes temporarily change the
> > value (error path below)
> > 
> 
> ?

If I am doing a calib store and a calib show in parallel then the show
can give a bogus answer because of this bit of code

> > > +	mutex_lock(&chip->mutex);
> > > +	old_calib = chip->lux_calib;
> > > +	chip->lux_calib = value;
> > > +	new_corr = bhsfh_get_corr_value(chip);
> > > +	if (new_corr == 0) {

[Show can occur here]

> > > +		chip->lux_calib = old_calib;
> > > +		mutex_unlock(&chip->mutex);
> > > +		return -EINVAL;
> > > +	}
> > > +	chip->lux_corr = new_corr;
> > > +	mutex_unlock(&chip->mutex);
> > > +
> > > +	return len;


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
