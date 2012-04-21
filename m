Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2DUGsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:48:06 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:38734 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644Ab2DUGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:48:03 -0400
X-Greylist: delayed 8699 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 02:48:03 EDT
Date: Sat, 21 Apr 2012 05:42:04 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v4] iio: Add device tree support to LPC32xx ADC
Message-ID: <20120421034204.GA9142@game.jcrosoft.org>
References: <1334951307-1269-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334951307-1269-1-git-send-email-stigge@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3531103583657044829
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegfedrgedtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:48 Fri 20 Apr     , Roland Stigge wrote:
> This patch adds device tree support to the LPC32xx's ADC.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> 
> Applies to v3.4-rc3
> 
> Changes since v3:
> * Changed "compatible" strings to non-wildcard versions
> 
> Thanks to Arnd Bergmann and Lars-Peter Clausen for reviewing!
> 
>  Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt |   17 ++++++++++
>  drivers/staging/iio/adc/lpc32xx_adc.c                             |   13 +++++++
>  2 files changed, 30 insertions(+)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
> @@ -0,0 +1,17 @@
> +* NXP LPC32xx SoC ADC controller
> +
> +Required properties:
> +- compatible: must be "nxp,lpc3220-adc", "nxp,lpc3230-adc", "nxp,lpc3240-adc"
> +  or "nxp,lpc3250-adc"
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: The ADC interrupt
> +
> +Example:
> +
> +	adc@40048000 {
> +		compatible = "nxp,lpc3250-adc";
> +		reg = <0x40048000 0x1000>;
> +		interrupt-parent = <&mic>;
> +		interrupts = <39 0>;
> +	};
> --- linux-2.6.orig/drivers/staging/iio/adc/lpc32xx_adc.c
> +++ linux-2.6/drivers/staging/iio/adc/lpc32xx_adc.c
> @@ -30,6 +30,7 @@
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  #include <linux/completion.h>
> +#include <linux/of.h>
>  
>  #include "../iio.h"
>  #include "../sysfs.h"
> @@ -221,12 +222,24 @@ static int __devexit lpc32xx_adc_remove(
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id lpc32xx_adc_match[] = {
> +	{ .compatible = "nxp,lpc3220-adc" },
> +	{ .compatible = "nxp,lpc3230-adc" },
> +	{ .compatible = "nxp,lpc3240-adc" },
> +	{ .compatible = "nxp,lpc3250-adc" },
do you really need to list them all?


if they are all cmpatible just list the first one

Best Regards,
J.
