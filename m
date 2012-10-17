Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2JQScP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:32:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36172 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab2JQScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:32:14 -0400
Message-ID: <507EF9AB.9070603@wwwdotorg.org>
Date: Wed, 17 Oct 2012 12:32:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 7/7] gpio/tegra: convert to use linear irqdomain
References: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org> <507DE0AE.7090701@wwwdotorg.org>
In-Reply-To: <507DE0AE.7090701@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 04:33 PM, Stephen Warren wrote:
> On 10/16/2012 01:23 PM, Linus Walleij wrote:
>> The MXS driver tries to do the work of irq_domain_add_linear()
>> by reserving a bunch of descriptors somewhere and keeping track
>> of the base offset, then calling irq_domain_add_legacy(). Let's
>> stop doing that and simply use the linear IRQ domain.
> 
> This /looks/ fine, but appears to break users of GPIOs from this module,
> and causes a backtrace when cat /sys/kernel/debug/gpio:
...

The following additional diff makes it work:

> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index 0234162..c7c175a 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -460,7 +460,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
>         gpiochip_add(&tegra_gpio_chip);
>  
>         for (gpio = 0; gpio < tegra_gpio_chip.ngpio; gpio++) {
> -               int irq = irq_find_mapping(irq_domain, gpio);
> +               int irq = irq_create_mapping(irq_domain, gpio);
>                 /* No validity check; all Tegra GPIOs are valid IRQs */
>  
>                 bank = &tegra_gpio_banks[GPIO_BANK(gpio)];

I wonder if perhaps the entirety of that loop and perhaps the one after
it should be in the IRQ domain's map op - is that how all this is
intended to work?
