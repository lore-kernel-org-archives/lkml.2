Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2BRTaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 14:30:13 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:10603 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2BRTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 14:30:11 -0500
Date: Sat, 18 Feb 2012 20:29:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v4] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
Message-ID: <20120218202957.379c781f@endymion.delvare>
In-Reply-To: <a9271306-f4b9-4d59-9925-803d142f17ab@zimbra>
References: <7d63fbf3-04a4-4cf0-ada3-5807d11928d9@zimbra>
	<a9271306-f4b9-4d59-9925-803d142f17ab@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Fri, 17 Feb 2012 17:28:33 -0600 (CST), Aaron Sierra wrote:
> From: Peter Tyser <ptyser@xes-inc.com>
> 
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on QM67 (Cougar Point), QM57 (Ibex Peak), 3100 (Whitmore Lake),
> and NM10 (Tiger Point).
> 
> Includes work from Jean Delvare:
> 	- Resource leak removal during module load/unload
> 	- GPIO API bit value enforcement
> 
> Also includes code cleanup from Guenter Roeck.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---
> (...)
> +static int __devinit ichx_gpio_probe(struct platform_device *pdev)
> +{
> +	struct resource *res_base, *res_pm;
> +	int err;
> +	struct lpc_ich_info *ich_info = pdev->dev.platform_data;
> +
> +	if (!ich_info)
> +		return -ENODEV;
> +
> +	switch (ich_info-> gpio_version) {

Extra space after ->.

> +		case 0x401:
> +			ichx_priv.desc = &i3100_desc;
> +			break;
> +		case 0x501:
> +			ichx_priv.desc = &intel5_desc;
> +			break;
> +		case 0x601:
> +			ichx_priv.desc = &ich6_desc;
> +			break;
> +		case 0x701:
> +			ichx_priv.desc = &ich7_desc;
> +			break;
> +		case 0x801:
> +			ichx_priv.desc = &ich9_desc;
> +			break;
> +		case 0xa01:
> +			ichx_priv.desc = &ich10_corp_desc;
> +			break;
> +		case 0xa11:
> +			ichx_priv.desc = &ich10_cons_desc;
> +			break;
> +		default:
> +			return -ENODEV;

The indentation of this block is wrong, as reported by checkpatch.
"case" and "default" lines should have the same indentation level as
"switch".

> +	}
> +
> +	res_base = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPIO);
> +	if (!res_base || !res_base->start || !res_base->end)
> +		return -ENODEV;
> +
> +	/*
> +	 * The GPIO resource size reported by lpc_ich is the largest size
> +	 * for any of the supported chipsets. Older devices provide fewer
> +	 * GPIO and have a smaller resource size.
> +	 */
> +	if (ichx_priv.desc->ngpio <= 64)
> +		res_base->end = res_base->start + 64 - 1;

This still looks wrong. Declaring a resource larger than it actually
is, could cause a conflict when lpc_ich registers the GPIO device.
Plus, the above is not only causing the gpio_ich driver to request a
smaller I/O range. It also changes the lpc_ich resource retroactively,
so the resource lpc_ich will attempt to remove is different from the
one it registered. I don't think you're supposed to do that.

Why don't you get the resource size right in the first place? This
shouldn't be too difficult, as far as I can see the 128-byte region is
only for gpio_version 0x501 and 0xa01.

> +
> +	if (!request_region(res_base->start, resource_size(res_base),
> +				pdev->name))
> +		return -EBUSY;
> +
> +	ichx_priv.gpio_base = res_base;
> +
> +	/*
> +	 * If necessary, determine the I/O address of ACPI/power management
> +	 * registers which are needed to read the the GPE0 register for GPI pins
> +	 * 0 - 15 on some chipsets.
> +	 */
> +	if (!ichx_priv.desc->gpe0_sts_ofs)
> +		goto init;
> +
> +	res_pm = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPE0);
> +	if (!res_pm || !res_pm->start || !res_pm->end) {
> +		pr_warn("ACPI BAR is unavailable, GPI 0 - 15 unavailable\n");
> +		goto init;
> +	}
> +
> +	if (!request_region(res_pm->start, resource_size(res_pm),
> +			pdev->name)) {
> +		pr_warn("ACPI BAR is busy, GPI 0 - 15 unavailable\n");
> +		goto init;
> +	}
> +
> +	ichx_priv.pm_base = res_pm;
> +
> +init:
> +	ichx_gpiolib_setup(&ichx_priv.chip);
> +	err = gpiochip_add(&ichx_priv.chip);

The gpio device is currently not showing up at the right place in the
device tree. You should set ichx_priv.chip.dev to &pdev->dev to fix
that.

> +	if (err) {
> +		pr_err("Failed to register GPIOs\n");
> +		goto add_err;
> +	}
> +
> +	pr_info("GPIO from %d to %d on %s\n", ichx_priv.chip.base,
> +	       ichx_priv.chip.base + ichx_priv.chip.ngpio - 1, DRV_NAME);
> +
> +	return 0;
> +
> +add_err:
> +	release_region(ichx_priv.gpio_base->start,
> +			resource_size(ichx_priv.gpio_base));
> +	if (ichx_priv.pm_base)
> +		release_region(ichx_priv.pm_base->start,
> +				resource_size(ichx_priv.pm_base));
> +	return err;
> +}

-- 
Jean Delvare
