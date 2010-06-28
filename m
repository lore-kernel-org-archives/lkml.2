Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0F1H0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 03:26:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50801 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0F1H0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 03:26:05 -0400
Message-ID: <4C284E5B.503@nokia.com>
Date: Mon, 28 Jun 2010 10:25:15 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tony Lindgren <tony@atomide.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Sundar Iyer <sundar.iyer@stericsson.com>,
       Bengt Jonsson <bengt.jonsson@stericsson.com>
Subject: Re: [PATCH] MMC: remove regulator refcount fiddling in mmc core
References: <1277392337-27627-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1277392337-27627-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2010 07:25:14.0790 (UTC) FILETIME=[0D36F460:01CB1693]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> Currently the mmc_regulator_set_ocr() fiddles with the regulator
> refcount by selectively calling regulator_[enable|disable]
> depending on the state of the regulator. This will confuse the
> reference count if case the regulator is for example shared with
> other MMC slots or user for other stuff than the MMC card.
> 
> Push regulator_[enable|disable] out into the MMC host drivers
> and remove this from the MMC core so the reference count can be
> trusted.

That is not a technical reason.  It would be better to provide
more regulator support in core so there is less duplication in
the drivers.

At least it should be a separate patch.

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Adrian Hunter <adrian.hunter@nokia.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Sundar Iyer <sundar.iyer@stericsson.com>
> Cc: Bengt Jonsson <bengt.jonsson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> This has been regression compiled for U300, OMAP3, PXA3XX
> defconfigs, tested on U300.
> 
> We're facing problems with our regulator reference counters if
> this is not fixed.
> ---
>  drivers/mmc/core/core.c       |   66 ++++++++++++++++++-----------------------
>  drivers/mmc/host/mmci.c       |   10 ++++--
>  drivers/mmc/host/omap_hsmmc.c |   40 ++++++++++++++++++------
>  drivers/mmc/host/pxamci.c     |   17 ++++++++--
>  4 files changed, 78 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 569e94d..904f245 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -784,47 +784,39 @@ int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
>  {
>  	int			result = 0;
>  	int			min_uV, max_uV;
> -	int			enabled;
> +	int			tmp;
> +	int			voltage;
>  
> -	enabled = regulator_is_enabled(supply);
> -	if (enabled < 0)
> -		return enabled;
> -
> -	if (vdd_bit) {
> -		int		tmp;
> -		int		voltage;
> -
> -		/* REVISIT mmc_vddrange_to_ocrmask() may have set some
> -		 * bits this regulator doesn't quite support ... don't
> -		 * be too picky, most cards and regulators are OK with
> -		 * a 0.1V range goof (it's a small error percentage).
> -		 */
> -		tmp = vdd_bit - ilog2(MMC_VDD_165_195);
> -		if (tmp == 0) {
> -			min_uV = 1650 * 1000;
> -			max_uV = 1950 * 1000;
> -		} else {
> -			min_uV = 1900 * 1000 + tmp * 100 * 1000;
> -			max_uV = min_uV + 100 * 1000;
> -		}
> -
> -		/* avoid needless changes to this voltage; the regulator
> -		 * might not allow this operation
> -		 */
> -		voltage = regulator_get_voltage(supply);
> -		if (voltage < 0)
> -			result = voltage;
> -		else if (voltage < min_uV || voltage > max_uV)
> -			result = regulator_set_voltage(supply, min_uV, max_uV);
> -		else
> -			result = 0;
> +	if (!vdd_bit)
> +		return 0;
>  
> -		if (result == 0 && !enabled)
> -			result = regulator_enable(supply);
> -	} else if (enabled) {
> -		result = regulator_disable(supply);
> +	/*
> +	 * REVISIT mmc_vddrange_to_ocrmask() may have set some
> +	 * bits this regulator doesn't quite support ... don't
> +	 * be too picky, most cards and regulators are OK with
> +	 * a 0.1V range goof (it's a small error percentage).
> +	 */
> +	tmp = vdd_bit - ilog2(MMC_VDD_165_195);
> +	if (tmp == 0) {
> +		min_uV = 1650 * 1000;
> +		max_uV = 1950 * 1000;
> +	} else {
> +		min_uV = 1900 * 1000 + tmp * 100 * 1000;
> +		max_uV = min_uV + 100 * 1000;
>  	}
>  
> +	/*
> +	 * Avoid needless changes to this voltage; the regulator
> +	 * might not allow this operation
> +	 */
> +	voltage = regulator_get_voltage(supply);
> +	if (voltage < 0)
> +		result = voltage;
> +	else if (voltage < min_uV || voltage > max_uV)
> +		result = regulator_set_voltage(supply, min_uV, max_uV);
> +	else
> +		result = 0;
> +
>  	return result;
>  }
>  EXPORT_SYMBOL(mmc_regulator_set_ocr);
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 4917af9..5f530b1 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -467,15 +467,17 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  
>  	switch (ios->power_mode) {
>  	case MMC_POWER_OFF:
> -		if(host->vcc &&
> -		   regulator_is_enabled(host->vcc))
> +		if (host->vcc)
>  			regulator_disable(host->vcc);
>  		break;
>  	case MMC_POWER_UP:
>  #ifdef CONFIG_REGULATOR
> -		if (host->vcc)
> -			/* This implicitly enables the regulator */
> +		if (host->vcc) {
> +			if (regulator_enable(host->vcc))
> +				dev_err(mmc_dev(mmc),
> +					"could not enable regulator\n");
>  			mmc_regulator_set_ocr(host->vcc, ios->vdd);
> +		}
>  #endif
>  		/*
>  		 * The translate_vdd function is not used if you have
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index b032828..d8d07e1 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -247,10 +247,17 @@ static int omap_hsmmc_1_set_power(struct device *dev, int slot, int power_on,
>  	if (mmc_slot(host).before_set_reg)
>  		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
>  
> -	if (power_on)
> -		ret = mmc_regulator_set_ocr(host->vcc, vdd);
> -	else
> -		ret = mmc_regulator_set_ocr(host->vcc, 0);
> +	if (power_on) {
> +		ret = regulator_enable(host->vcc);
> +		if (ret)
> +			dev_err(dev, "could not enable regulator\n");
> +		else
> +			ret = mmc_regulator_set_ocr(host->vcc, vdd);
> +	} else {
> +		ret = regulator_disable(host->vcc);
> +		if (ret)
> +			dev_err(dev, "could not disable regulator\n");
> +	}

Enabling the regulator before setting the voltage seems like it could
create problems, for example, enabling at an invalid voltage before
ramping to the correct voltage.  Also, while regulator_enable typically
waits for the regulator to stablize, regulator_set_voltage typically
does not.

The original code was the other way around.

>  
>  	if (mmc_slot(host).after_set_reg)
>  		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
> @@ -289,7 +296,11 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
>  	 * chips/cards need an interface voltage rail too.
>  	 */
>  	if (power_on) {
> -		ret = mmc_regulator_set_ocr(host->vcc, vdd);
> +		ret = regulator_enable(host->vcc);
> +		if (ret < 0)
> +			dev_err(dev, "could not enable regulator\n");
> +		else
> +			ret = mmc_regulator_set_ocr(host->vcc, vdd);
>  		/* Enable interface voltage rail, if needed */
>  		if (ret == 0 && host->vcc_aux) {
>  			ret = regulator_enable(host->vcc_aux);
> @@ -297,10 +308,15 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
>  				ret = mmc_regulator_set_ocr(host->vcc, 0);
>  		}
>  	} else {
> +		/* Shut down the rail */
>  		if (host->vcc_aux)
>  			ret = regulator_disable(host->vcc_aux);
> -		if (ret == 0)
> -			ret = mmc_regulator_set_ocr(host->vcc, 0);
> +		if (ret == 0) {
> +			/* Then proeeed to shut down the local regulator */
> +			ret = regulator_disable(host->vcc);
> +			if (ret == 0)
> +				ret = mmc_regulator_set_ocr(host->vcc, 0);
> +		}
>  	}
>  
>  	if (mmc_slot(host).after_set_reg)
> @@ -340,10 +356,14 @@ static int omap_hsmmc_23_set_sleep(struct device *dev, int slot, int sleep,
>  
>  	if (cardsleep) {
>  		/* VCC can be turned off if card is asleep */
> -		if (sleep)
> -			err = mmc_regulator_set_ocr(host->vcc, 0);
> -		else
> +		if (sleep) {
> +			err = regulator_disable(host->vcc);
> +		} else {
> +			err = regulator_enable(host->vcc);
> +			if (err)
> +				return err;
>  			err = mmc_regulator_set_ocr(host->vcc, vdd);
> +		}
>  	} else
>  		err = regulator_set_mode(host->vcc, mode);
>  	if (err)
> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
> index 0a4e43f..b7e0216 100644
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -99,13 +99,22 @@ static inline void pxamci_init_ocr(struct pxamci_host *host)
>  	}
>  }
>  
> -static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
> +static inline void pxamci_set_power(struct pxamci_host *host,
> +				    unsigned char power_mode,
> +				    unsigned int vdd)
>  {
>  	int on;
>  
>  #ifdef CONFIG_REGULATOR
> -	if (host->vcc)
> -		mmc_regulator_set_ocr(host->vcc, vdd);
> +	if (host->vcc) {
> +		if (power_mode == MMC_POWER_UP) {
> +			if (regulator_enable(host->vcc))
> +				dev_err(mmc_dev(host->mmc),
> +					"could not enable regulator\n");
> +			mmc_regulator_set_ocr(host->vcc, vdd);
> +		} else if (power_mode == MMC_POWER_OFF)
> +			regulator_disable(host->vcc);
> +	}
>  #endif
>  	if (!host->vcc && host->pdata &&
>  	    gpio_is_valid(host->pdata->gpio_power)) {
> @@ -492,7 +501,7 @@ static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	if (host->power_mode != ios->power_mode) {
>  		host->power_mode = ios->power_mode;
>  
> -		pxamci_set_power(host, ios->vdd);
> +		pxamci_set_power(host, ios->power_mode, ios->vdd);
>  
>  		if (ios->power_mode == MMC_POWER_ON)
>  			host->cmdat |= CMDAT_INIT;

