Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0H3VEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:04:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:45468 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0H3VEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:04:32 -0400
Message-ID: <4C7C1A2B.1010400@nokia.com>
Date: Mon, 30 Aug 2010 23:52:59 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Bengt Jonsson <bengt.jonsson@stericsson.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MMC: move regulator handling closer to core
References: <1283102159-25804-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1283102159-25804-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2010 20:53:00.0542 (UTC) FILETIME=[551411E0:01CB4885]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> After discovering a problem in regulator reference counting I
> took Mark Brown's advice to move the reference count into the
> MMC core by making the regulator status a member of
> struct mmc_host.
> 
> I took this opportunity to also implement NULL versions of
> the regulator functions so as to rid the driver code from
> some ugly #ifdef CONFIG_REGULATOR clauses.
> 
> Cc: Daniel Mack <daniel@caiaq.de>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Cliff Brake <cbrake@bec-systems.com>
> Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Adrian Hunter <adrian.hunter@nokia.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Sundar Iyer <sundar.iyer@stericsson.com>
> Cc: Bengt Jonsson <bengt.jonsson@stericsson.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> This is not the final movement of regulator code into the
> MMC framework by a long shot, but it's atleast a starter.
> If you like it, ACK it.
> 
> It's not easy for me to test this code since both the OMAP2 and
> PXA3XX defconfigs have (unrelated) build failures on the current
> -next tree, however the U300 builds fine and seems to work nicely,
> I'll stress-test it a bit more though.
> ---
>  drivers/mmc/core/core.c       |   38 +++++++++++++++++++++++++++++---------
>  drivers/mmc/host/mmci.c       |   21 +++++++++++++--------
>  drivers/mmc/host/omap_hsmmc.c |   32 ++++++++++++++++++++++----------
>  drivers/mmc/host/pxamci.c     |   24 ++++++++++++++++++------
>  include/linux/mmc/host.h      |    8 +++++++-
>  5 files changed, 89 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 5db49b1..1e8a70e 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -771,8 +771,9 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
>  
>  /**
>   * mmc_regulator_set_ocr - set regulator to match host->ios voltage
> - * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
> + * @mmc: the host to regulate
>   * @supply: regulator to use
> + * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
>   *
>   * Returns zero on success, else negative errno.
>   *
> @@ -780,15 +781,12 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
>   * a particular supply voltage.  This would normally be called from the
>   * set_ios() method.
>   */
> -int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
> +int mmc_regulator_set_ocr(struct mmc_host *mmc,
> +			struct regulator *supply,
> +			unsigned short vdd_bit)
>  {
>  	int			result = 0;
>  	int			min_uV, max_uV;
> -	int			enabled;
> -
> -	enabled = regulator_is_enabled(supply);
> -	if (enabled < 0)
> -		return enabled;
>  
>  	if (vdd_bit) {
>  		int		tmp;
> @@ -819,16 +817,38 @@ int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
>  		else
>  			result = 0;
>  
> -		if (result == 0 && !enabled)
> +		if (result == 0 && !mmc->regulator_enabled) {
>  			result = regulator_enable(supply);
> -	} else if (enabled) {
> +			if (!result)
> +				mmc->regulator_enabled = true;
> +		}
> +	} else if (mmc->regulator_enabled) {
>  		result = regulator_disable(supply);
> +		if (result == 0)
> +			mmc->regulator_enabled = false;
>  	}
>  
>  	return result;
>  }
>  EXPORT_SYMBOL(mmc_regulator_set_ocr);
> +#else
> +/*
> + * For drivers with optional regulator support we offer to
> + * just compile this thing out with functions that always
> + * succeed, just like the default stuff from the regulator
> + * core.
> + */

Shouldn't these be in the header?  The comment is not needed.

> +int inline mmc_regulator_get_ocrmask(struct regulator *supply)
> +{
> +	return 0;
> +}
>  
> +int inline mmc_regulator_set_ocr(struct mmc_host *mmc,
> +				 struct regulator *supply,
> +				 unsigned short vdd_bit)
> +{
> +	return 0;
> +}
>  #endif
>  
>  /*
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 840b301..0734ccb 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -507,19 +507,24 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	struct mmci_host *host = mmc_priv(mmc);
>  	u32 pwr = 0;
>  	unsigned long flags;
> +	int ret;
>  
>  	switch (ios->power_mode) {
>  	case MMC_POWER_OFF:
> -		if(host->vcc &&
> -		   regulator_is_enabled(host->vcc))
> -			regulator_disable(host->vcc);
> +		if (host->vcc) {
> +			ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);
> +			if (ret)
> +				dev_err(mmc_dev(mmc),
> +					"could not disable regulator\n");

What about putting the dev_err inside mmc_regulator_set_ocr()?

> +		}
>  		break;
>  	case MMC_POWER_UP:
> -#ifdef CONFIG_REGULATOR
> -		if (host->vcc)
> -			/* This implicitly enables the regulator */
> -			mmc_regulator_set_ocr(host->vcc, ios->vdd);
> -#endif
> +		if (host->vcc) {
> +			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
> +			if (ret)
> +				dev_err(mmc_dev(mmc),
> +					"could not set regulator OCR\n");
> +		}
>  		if (host->plat->vdd_handler)
>  			pwr |= host->plat->vdd_handler(mmc_dev(mmc), ios->vdd,
>  						       ios->power_mode);
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 4a8776f..9debfe2 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -249,10 +249,15 @@ static int omap_hsmmc_1_set_power(struct device *dev, int slot, int power_on,
>  	if (mmc_slot(host).before_set_reg)
>  		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
>  
> -	if (power_on)
> -		ret = mmc_regulator_set_ocr(host->vcc, vdd);
> -	else
> -		ret = mmc_regulator_set_ocr(host->vcc, 0);
> +	if (power_on) {
> +		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
> +		if (ret)
> +			dev_err(dev, "could not set regulator OCR\n");
> +	} else {
> +		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
> +		if (ret)
> +			dev_err(dev, "could not disable regulator\n");
> +	}
>  
>  	if (mmc_slot(host).after_set_reg)
>  		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
> @@ -291,18 +296,25 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
>  	 * chips/cards need an interface voltage rail too.
>  	 */
>  	if (power_on) {
> -		ret = mmc_regulator_set_ocr(host->vcc, vdd);
> +		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
> +		if (ret)
> +			dev_err(dev, "could not set regulator OCR\n");
>  		/* Enable interface voltage rail, if needed */
>  		if (ret == 0 && host->vcc_aux) {
>  			ret = regulator_enable(host->vcc_aux);
>  			if (ret < 0)
> -				ret = mmc_regulator_set_ocr(host->vcc, 0);
> +				ret = mmc_regulator_set_ocr(host->mmc,
> +							host->vcc, 0);
>  		}
>  	} else {
> +		/* Shut down the rail */
>  		if (host->vcc_aux)
>  			ret = regulator_disable(host->vcc_aux);
> -		if (ret == 0)
> -			ret = mmc_regulator_set_ocr(host->vcc, 0);
> +		if (!ret) {
> +			/* Then proceed to shut down the local regulator */
> +			ret = mmc_regulator_set_ocr(host->mmc,
> +						host->vcc, 0);
> +		}
>  	}
>  
>  	if (mmc_slot(host).after_set_reg)
> @@ -343,9 +355,9 @@ static int omap_hsmmc_23_set_sleep(struct device *dev, int slot, int sleep,
>  	if (cardsleep) {
>  		/* VCC can be turned off if card is asleep */
>  		if (sleep)
> -			err = mmc_regulator_set_ocr(host->vcc, 0);
> +			err = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
>  		else
> -			err = mmc_regulator_set_ocr(host->vcc, vdd);
> +			err = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
>  	} else
>  		err = regulator_set_mode(host->vcc, mode);
>  	if (err)
> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
> index 0a4e43f..47dae9b 100644
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -99,14 +99,26 @@ static inline void pxamci_init_ocr(struct pxamci_host *host)
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
> -#ifdef CONFIG_REGULATOR
> -	if (host->vcc)
> -		mmc_regulator_set_ocr(host->vcc, vdd);
> -#endif
> +	if (host->vcc) {
> +		int ret;
> +
> +		if (power_mode == MMC_POWER_UP) {
> +			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
> +			if (ret)
> +				dev_err(mmc_dev(host->mmc),
> +					"could not set regulator OCR\n");
> +		} else if (power_mode == MMC_POWER_OFF)
> +			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
> +			if (ret)
> +				dev_err(mmc_dev(host->mmc),
> +					"could not disable regulator\n");
> +	}

mmc_power_off() does set ios->vdd to 0 so the original code was fine
wrt to ignoring power_mode.

>  	if (!host->vcc && host->pdata &&
>  	    gpio_is_valid(host->pdata->gpio_power)) {
>  		on = ((1 << vdd) & host->pdata->ocr_mask);
> @@ -492,7 +504,7 @@ static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	if (host->power_mode != ios->power_mode) {
>  		host->power_mode = ios->power_mode;
>  
> -		pxamci_set_power(host, ios->vdd);
> +		pxamci_set_power(host, ios->power_mode, ios->vdd);
>  
>  		if (ios->power_mode == MMC_POWER_ON)
>  			host->cmdat |= CMDAT_INIT;
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 1575b52..8f5d765 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -212,6 +212,10 @@ struct mmc_host {
>  	struct led_trigger	*led;		/* activity led */
>  #endif
>  
> +#ifdef CONFIG_REGULATOR
> +	bool			regulator_enabled; /* regulator state */
> +#endif
> +
>  	struct dentry		*debugfs_root;
>  
>  	unsigned long		private[0] ____cacheline_aligned;
> @@ -251,7 +255,9 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
>  struct regulator;
>  
>  int mmc_regulator_get_ocrmask(struct regulator *supply);
> -int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
> +int mmc_regulator_set_ocr(struct mmc_host *mmc,
> +			struct regulator *supply,
> +			unsigned short vdd_bit);
>  
>  int mmc_card_awake(struct mmc_host *host);
>  int mmc_card_sleep(struct mmc_host *host);

