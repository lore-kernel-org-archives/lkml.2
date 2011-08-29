Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1H2WMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:12:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57060 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1H2WL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:11:59 -0400
Date: Mon, 29 Aug 2011 23:11:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110829221132.GB26846@sirena.org.uk>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Cookie: Every morning is a Smirnoff morning.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:40:25PM -0400, Vivien Didelot wrote:

>  arch/x86/platform/ts5500/ts5500_gpio.c |  421 ++++++++++++++++++++++++++++++++
>  arch/x86/platform/ts5500/ts5500_gpio.h |   60 +++++

New GPIO drivers should really go under drivers/gpiolib and be called
gpio-foo.c.

> +static int ts5500_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct ts5500_drvdata *drvdata;
> +
> +	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
> +
> +	mutex_lock(&drvdata->gpio_lock);
> +	if (requested_gpios[offset]) {
> +		mutex_unlock(&drvdata->gpio_lock);
> +		return -EBUSY;
> +	}
> +	requested_gpios[offset] = 1;
> +	mutex_unlock(&drvdata->gpio_lock);

gpiolib should already be making sure there's only one user at once, no
need to bother open coding it in the driver.

> +	bitno = line_to_bit_map[offset];
> +
> +	mutex_lock(&drvdata->gpio_lock);
> +	byte = inb(ioaddr);
> +	mutex_unlock(&drvdata->gpio_lock);

Do you really need the lock to do a read?
