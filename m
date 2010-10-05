Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0JEK4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:56:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53314 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832Ab0JEK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:56:34 -0400
Date: Tue, 5 Oct 2010 12:21:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
Message-ID: <20101005122157.149f14d0@lxorguk.ukuu.org.uk>
In-Reply-To: <1286271779-19819-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	<1286271779-19819-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Oct 2010 12:42:55 +0300
Samu Onkalo <samu.p.onkalo@nokia.com> wrote:

> This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
> ALS and proximity sensor.

Same comment about regulators.


> +/* Supported stand alone rates in ms from chip data sheet */
> +static s16 prox_rates[] = {10, 20, 30, 40, 70, 100, 200, 500, 1000, 2000};
> +
> +/* Supported IR-led currents in mA */
> +static const u8 prox_curr_ma[] = {5, 10, 20, 50, 100, 150, 200};
> +
> +/* Supported stand alone rates in ms from chip data sheet */
> +static s16 lux_rates[] = {100, 200, 500, 1000, 2000};

Any reason only one of the three is const ?


> +static int bhsfh_prox_rates(struct bhsfh_chip *chip, int rate,
> +			int rate_threshold)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(prox_rates); i++)
> +		if (prox_rates[i] == rate) {
> +			chip->prox_rate = i;
> +			break;
> +		}
> +
> +	if (i == ARRAY_SIZE(prox_rates))
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(prox_rates); i++)
> +		if (prox_rates[i] == rate_threshold) {
> +			chip->prox_rate_threshold = i;
> +			return 0;
> +		}
> +
> +	return -EINVAL;

This makes it hard for generic code. Wouldn't picking the best (first at
least as good as required) be a bit more polite to user space ?


> +static ssize_t bhsfh_lux_result_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
> +	ssize_t ret;
> +
> +	mutex_lock(&chip->mutex);
> +	if (pm_runtime_suspended(dev))
> +		ret = -EIO; /* Chip is not enabled at all */
> +	else if (chip->lux_wait_result)
> +		ret = -EAGAIN; /* Waiting for result */

This makes no sense because you can't poll() a sysfs file



> +static ssize_t bhsfh_lux_calib_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct bhsfh_chip *chip = dev_get_drvdata(dev);
> +	return snprintf(buf, PAGE_SIZE, "%u\n", chip->lux_calib);
> +}

This is short chip->mutex locks as you sometimes temporarily change the
value (error path below)

> +
> +static ssize_t bhsfh_lux_calib_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	struct bhsfh_chip *chip = dev_get_drvdata(dev);
> +	unsigned long value;
> +	u32 old_calib;
> +	u32 new_corr;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	mutex_lock(&chip->mutex);
> +	old_calib = chip->lux_calib;
> +	chip->lux_calib = value;
> +	new_corr = bhsfh_get_corr_value(chip);
> +	if (new_corr == 0) {
> +		chip->lux_calib = old_calib;
> +		mutex_unlock(&chip->mutex);
> +		return -EINVAL;
> +	}
> +	chip->lux_corr = new_corr;
> +	mutex_unlock(&chip->mutex);
> +
> +	return len;
