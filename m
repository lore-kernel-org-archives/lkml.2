Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2K3KsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:48:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35050 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab2K3KsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:48:19 -0500
Message-ID: <50B88EDF.9000109@ti.com>
Date: Fri, 30 Nov 2012 11:47:59 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost> <50B5D161.6010200@ti.com> <20121129161024.EEA803E0912@localhost> <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de> <20121130102039.0267E3E129E@localhost>
In-Reply-To: <20121130102039.0267E3E129E@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 11:20 AM, Grant Likely wrote:
> Umm, I agree with you on duty cycle, but that's got nothing to do with
> period. 100% duty cycle looks exactly the same whether the period is
> 10ns or 100s.

Yes this is true. But some PWM hw can select it's clock based on the period_ns
provided.
In most cases we could hardwire 10000 as period_ns but there might be HW which
checks this and only allow the use of supported frequencies.

>> Unless you're proposing to not include that in the PWM core but rather
>> in individual drivers. Then I suppose the driver could choose some
>> sensible default.
> 
> Mostly I'm asking questions because I'm not familiar with the subsystem.
> If the property is needed then I have no objections, but at the moment
> it doesn't make any sense to me.
> 
>> One other problem is that some PWM devices cannot be setup to achieve a
>> 0% or 100% duty-cycle but instead will toggle for at least one period.
>> This would be another argument in favour of moving the functionality to
>> the individual drivers, perhaps with some functionality provided by the
>> core to do the gpio_chip registration (a period could be passed to that
>> function at registration time), which will likely be the same for all
>> hardware that can and wants to support this feature.
> 
> It is a bit of an oddball case where if the hardware engineer wires up a
> PWM to use as a GPIO, then he better be sure that it is actually fit for
> the purpose.

If we inspect the situation from a different angle: a standard GPIO is a PWM
with either turned off state or with full duty cycle (where the duty cycle
means nothing since the signal on the line is constantly high).

> That doesn't prevent the PWM core having some
> gpio-emulation helper functionality, but do need to be careful about it.

If you give designers a way to take short cuts, they will take it whenever
they can. Even if it makes no sense. IMHO. But the BeagleBoard has been
designed before we had any indication from the SW that we could handle this
case. I guess the thinking was that in the bootloader the SW will configure
the PWM to always on and forget about it in the running code.

As a note: I noticed this during my cleanup work around the twl-core. If you
take a look at the kernel code there are other drivers configuring the PWMs of
twl in various places to handle them.
I wrote the pwm-twl and pwm-twl-led drivers so we can get rid of this whole mess:
- the gpio-twl4030 extends itself to handle the PWMA/B (LEDA/B) as GPIO. So
drivers are doing OMAP_MAX_GPIO + TWL_NUM_GPIO + 1/2 to control the PWMA/B.
- mach-omap2/board-zoom-display.c have custom code to control the same thing
and the list goes.

-- 
Péter
