Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1BQLAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:00:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1BQLAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:00:46 -0500
Date: Thu, 17 Feb 2011 12:00:43 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/4] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110217110043.GA30692@pengutronix.de>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
 <1297904216-15219-2-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1297904216-15219-2-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:56:54PM -0600, Peter Tyser wrote:
> Add a new get_direction() function to the gpio_chip structure.  This is
> useful so that the direction of a pin can be determined when its
> initially exported.  Previously, the direction defaulted to "unknown"
> regardless of the actual configuration of the GPIO pin.
> 
> If a GPIO driver implements get_direction(), it is called in
> gpio_request() to set the initial direction of the pin accurately.
> 
> Cc: Alek Du <alek.du@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> ---
> Changes since v1:
> - Add support for "unknown" direction
> 
>  drivers/gpio/gpiolib.c     |   20 ++++++++++++++++++++
>  include/asm-generic/gpio.h |    4 ++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 0113c10..7723beb 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1214,6 +1214,26 @@ int gpio_request(unsigned gpio, const char *label)
>  		}
>  	}
>  
> +	if (chip->get_direction) {
> +		/* chip->get_direction may sleep */
> +		spin_unlock_irqrestore(&gpio_lock, flags);
> +		switch (chip->get_direction(chip, gpio - chip->base)) {
> +		case -1:

Use some #defines instead of hardcoded values?

> +			clear_bit(FLAG_DIR_OUT, &desc->flags);
> +			clear_bit(FLAG_DIR_IN, &desc->flags);
> +			break;
> +		case 0:
> +			set_bit(FLAG_DIR_IN, &desc->flags);
> +			clear_bit(FLAG_DIR_OUT, &desc->flags);
> +			break;
> +		case 1:
> +			set_bit(FLAG_DIR_OUT, &desc->flags);
> +			clear_bit(FLAG_DIR_IN, &desc->flags);
> +			break;
> +		}
> +		spin_lock_irqsave(&gpio_lock, flags);

You are changing the flags without the lock. I think it would be good to copy
the locking-pattern of chip->request for now.

Regards,

   Wolfram

-- 
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
