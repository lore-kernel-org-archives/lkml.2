Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1DUKmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:42:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39255 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752268Ab1DUKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:42:07 -0400
Date: Thu, 21 Apr 2011 11:42:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 13/14] regulator: max8925: fix not add device if
 missing init data
Message-ID: <20110421104204.GB11788@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 07:55:39PM +0800, Haojian Zhuang wrote:
> If regulator[0] is missed in init data, all regulators of max8925 won't
> be initialized.

With a changelog like this I'd expect a small change to an error check
in the startup code or something but this is a very big change to the
driver initialisation.

> +static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];

That looks really suspicious, what happens if there's two of these
devices in the system?

> +		memcpy(&regulator_pdata[i], &pdata->regulator[i],
> +			sizeof(struct regulator_init_data));
> +		regulator_devs[i].platform_data = &regulator_pdata[i];
> +		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
> +		regulator_devs[i].num_resources = 1;
> +		regulator_devs[i].resources = &regulator_resources[seq];
> +
> +		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
> +				      &regulator_resources[seq], 0);
> +		if (ret < 0) {
> +			dev_err(chip->dev, "Failed to add regulator subdev\n");
> +			goto out;

It's really unclear why the array is needed at all if you're registering
the devices one at a time.

> -	if (pdata && pdata->regulator[0]) {
> -		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
> -				      ARRAY_SIZE(regulator_devs),
> -				      &regulator_resources[0], 0);
> -		if (ret < 0) {
> -			dev_err(chip->dev, "Failed to add regulator subdev\n");
> -			goto out_dev;
> -		}

Surely the only change that's needed here is to remove the check to see
if pdata->regulator[0] is non-null?
