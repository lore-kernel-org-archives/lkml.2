Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2AXL7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:59:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52812 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab2AXL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:58:58 -0500
Date: Tue, 24 Jan 2012 11:58:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, jedu@slimlogic.co.uk, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120124115855.GC14888@opensource.wolfsonmicro.com>
References: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 02:35:19PM +0530, Laxman Dewangan wrote:

> +	/*
> +	 * Rail can not be control from all external input EN1, EN2 and EN3
> +	 * together.
> +	 */
> +	if ((ext_sleep_config & EXT_SLEEP_CONTROL) == EXT_SLEEP_CONTROL) {
> +		dev_err(mfd->dev, "External sleep control flag is not "
> +					" not proper\n");
> +		return -EINVAL;
> +	}

Don't split log messages over multiple lines, it makes grepping the logs
harder.  Also, are combinations of two external enables valid?

> +static void tps65910_shutdown(struct platform_device *pdev)
> +{
> +	struct tps65910_reg *pmic = platform_get_drvdata(pdev);
> +	int i;
> +	int err;
> +	dev_err(&pdev->dev, "%s() is called\n", __func__);
> +
> +	/* Remove all external control before shutting down the device */
> +	for (i = 0; i < pmic->num_regulators; i++) {
> +		if (!pmic->rdev[i])
> +			continue;
> +
> +		err = tps65910_set_ext_sleep_config(pmic, i, 0);
> +		if (err < 0)
> +			dev_err(&pdev->dev, "Error in clearing external "
> +				"control\n");
> +	}

Why?

> +/*
> + * Regulator mode when rail is in sleep state which controlled by external
> + * input. The regultor will be OFF if it is in sleep state by default but
> + * can be set in LOW power mode by ORing following macro with any of
> + * above exterenl input option.
> + */
> +#define TPS65910_SLEEP_CONTROL_REG_LOW_POWER		0x10

There's the suspend mode API for configuring suspend modes.

> +
>  /**
>   * struct tps65910_board
>   * Board platform data may be used to initialize regulators.
> @@ -779,6 +792,7 @@ struct tps65910_board {
>  	int irq_base;
>  	int vmbch_threshold;
>  	int vmbch2_threshold;
> +	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];

I can't see anything in this code which will manage the enable signals?
