Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0DASfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:35:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37605 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755327Ab0DASfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:35:13 -0400
Date: Thu, 1 Apr 2010 19:35:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 04/19] regulator: add support for Dallas DS1803 dual
	digital potentiometer
Message-ID: <20100401183511.GC26650@opensource.wolfsonmicro.com>
References: <1270121012-31916-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270121012-31916-1-git-send-email-giometti@linux.it>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:23:32PM +0200, Rodolfo Giometti wrote:

This looks good, a few nitpicky things below.

> +config REGULATOR_DS1803
> +	tristate "Dallas Maxim DS1803 addressable dual digital potentiometer"
> +	depends on I2C
> +	help
> +	  Say Y here to support the dual digital potentiometer on
> +	  Dallas Maxim DS1803
> +

Oh, wow.  A pot as a voltage regulator...  :)

> +struct ds1803_data {
> +	struct i2c_client *client;
> +	struct regulator_dev *rdev;
> +
> +	unsigned int min_uV;	/* voltage for selector value 0 */
> +	unsigned int max_uV;	/* voltage for selector value 255 */
> +	unsigned int init_uV;	/* initial voltage */

Given that you don't support get_voltage() or otherwise reference
init_uV it seems as well to just drop that for now.

> +static u8 ds1803_write_pot_lut[] = { 0xa9, 0xaa, /* both not supported */ };

Both what?  Since you don't seem to reference this I guess it could just
be dropped...

> +static int ds1803_list_voltage(struct regulator_dev *rdev, unsigned index)
> +{
> +	struct ds1803_data *ds1803 = rdev_get_drvdata(rdev);
> +
> +	return (ds1803->max_uV - ds1803->min_uV) * index / 255
> +							+ ds1803->min_uV;
> +}

I think I'd like more brackets in this calculation for clarity that the
operator precedence is OK.

> +		/* Set chip's name according to user supplied type */
> +		ds1803_reg[i].name = ds1803_names[pdata->type];

Perhaps just let the user write in something they feel like, or use a
constant string for the chip?  The type doesn't seem to be used
otherwise so I can see the data ending up wrong and misleading folks.

> +enum ds1803_type {
> +	DS1803_100K,
> +	DS1803_50K,
> +	DS1803_10K,
> +};

If you are going to keep these assign a value to the first item so you
don't end up with 0 as a valid type, or make the 0 type be "unspecified"
or something.  That way platform data that's left initialised to zero
can be distinguished from something that someone deliberately set.
