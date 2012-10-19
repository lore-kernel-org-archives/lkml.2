Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab2JSKRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:17:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59878 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2JSKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <507EF9AB.9070603@wwwdotorg.org>
References: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
	<507DE0AE.7090701@wwwdotorg.org>
	<507EF9AB.9070603@wwwdotorg.org>
Date: Fri, 19 Oct 2012 12:17:09 +0200
Message-ID: <CACRpkdbknYsVKTMRzeDRo5DPfnSUSUwCNd2GKVRO_YOwrNdBFA@mail.gmail.com>
Subject: Re: [PATCH 7/7] gpio/tegra: convert to use linear irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 8:32 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/16/2012 04:33 PM, Stephen Warren wrote:
>> On 10/16/2012 01:23 PM, Linus Walleij wrote:
>>> The MXS driver tries to do the work of irq_domain_add_linear()
>>> by reserving a bunch of descriptors somewhere and keeping track
>>> of the base offset, then calling irq_domain_add_legacy(). Let's
>>> stop doing that and simply use the linear IRQ domain.
>>
>> This /looks/ fine, but appears to break users of GPIOs from this module,
>> and causes a backtrace when cat /sys/kernel/debug/gpio:
> ...
>
> The following additional diff makes it work:
>
>> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
>> index 0234162..c7c175a 100644
>> --- a/drivers/gpio/gpio-tegra.c
>> +++ b/drivers/gpio/gpio-tegra.c
>> @@ -460,7 +460,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
>>         gpiochip_add(&tegra_gpio_chip);
>>
>>         for (gpio = 0; gpio < tegra_gpio_chip.ngpio; gpio++) {
>> -               int irq = irq_find_mapping(irq_domain, gpio);
>> +               int irq = irq_create_mapping(irq_domain, gpio);
>>                 /* No validity check; all Tegra GPIOs are valid IRQs */
>>
>>                 bank = &tegra_gpio_banks[GPIO_BANK(gpio)];
>
> I wonder if perhaps the entirety of that loop and perhaps the one after
> it should be in the IRQ domain's map op - is that how all this is
> intended to work?

I've been asking the same kind of question...

Basically as far as I understand:

- If you use a linear IRQ domain you need to call irq_create_mapping()
 atleast once, and at that point the IRQ descriptor will be dynamically
 allocated. On subsequent calls, irq_find_mapping() can be used.

- If using legacy IRQ domains, descriptors are supposed to be
 allocated elsewhere, and you can just use irq_find_mapping(),
 but irq_create_mapping() does not hurt, because that call will
 check if a descriptor is already available.

- With the simple domain (as augmented by myself) the mappins
  will be dynamically created if the passed IRQ base is <= 0
  else it falls through to creating a linear domain, so in this case
  to be certain irq_create_mapping() should also be called at
  least once.

I'm not overly happy with these semantics :-(

Basically irq_find_mapping() may be a fragile and dangerous
optimization path.

I've folded the above into my patch.

Yours,
Linus Walleij
