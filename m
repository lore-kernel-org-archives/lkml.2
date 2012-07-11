Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2GKWLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:11:41 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36909 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280Ab2GKWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <d0bd829760aba6c8e686f3b864b3831aa6bdcaa1.1341925681.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<d0bd829760aba6c8e686f3b864b3831aa6bdcaa1.1341925681.git.cmahapatra@ti.com>
Date: Thu, 12 Jul 2012 00:11:39 +0200
Message-ID: <CACRpkdbKbQGKGsqnSKB5NgVG+yuBfHSLSS_bYWWJVXe1_tCByA@mail.gmail.com>
Subject: Re: [PATCH 4/4] gpio/pca953x: register the device irq using
 appropriate api's
From: Linus Walleij <linus.walleij@linaro.org>
To: Chandrabhanu Mahapatra <cmahapatra@ti.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 3:36 PM, Chandrabhanu Mahapatra
<cmahapatra@ti.com> wrote:

> From: Leed Aguilar <leed.aguilar@ti.com>
>
> Here, the implementation of registration of requested IRQs has been corrected
> with appropiate api's. The gpio number is requested through gpio_request_one()
> API and conversion of the gpio to irq is done using the gpio_to_irq() API.
>
> Change-Id: I964145e2a280d6553ea2c05ea8049810a1983930

Delete that.

> Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>
> ---
>  drivers/gpio/gpio-pca953x.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index c3ca7d8..27486da 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -509,7 +509,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>  #endif
>                 }
>
> -               ret = request_threaded_irq(client->irq,
> +               ret = gpio_request_one(client->irq, GPIOF_IN, "pca953x");

Not that it's really related to this one patch, but why is a GPIO number named
"irq" in client->irq??

> +               if (ret) {
> +                       dev_err(&client->dev, "gpio request failure\n");
> +                       goto out_failed;
> +               }
> +
> +               ret = request_threaded_irq(gpio_to_irq(client->irq),

It gets ever more confused as you're seemingly converting an IRQ to
an IRQ. Can we rename this variable in a separate patch?

Apart from this it looks good, but do I dare apply it without applying
3/4 (that needs ACK:ing)?

Yours,
Linus Walleij
