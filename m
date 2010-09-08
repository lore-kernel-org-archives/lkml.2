Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0IHWw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:52:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab0IHWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:52:53 -0400
Date: Wed, 8 Sep 2010 15:51:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
Message-Id: <20100908155114.880463fc.akpm@linux-foundation.org>
In-Reply-To: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Sep 2010 11:05:38 +0200
Linus Walleij <linus.walleij@stericsson.com> wrote:

> After discovering a problem in regulator reference counting I
> took Mark Brown's advice to move the reference count into the
> MMC core by making the regulator status a member of
> struct mmc_host.
> 
>
> ...
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
> +		if (power_mode == MMC_POWER_UP)
> +			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
> +		else if (power_mode == MMC_POWER_OFF)
> +			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
> +	}

There's no point in copying the return value into a local then ignoring
it.  mmc_regulator_set_ocr() can return a negative errno so we should
test for that, clean up and propagate the error.

If we really do deliberately ignore the error then there should be a
code comment which excuses this behaviour and perhaps a warning printk.

The same comments apply to mmci_set_ios().

omap_hsmmc_1_set_power() gets it right.

Why doesn't omap_hsmmc_23_set_sleep() run .before_set_reg() and
.after_set_reg()?

>
> ...
>
