Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0IGBwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:52:01 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:27659 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755088Ab0IGBv4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:51:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 150984.89895.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=29WoWyxt0tYItqkasBb3TLd/4P+VF4JI8ifitvDbPWqAKFggjl/AFdtgcBWcmv/xnwUzU+Z8AtRVCFxyKssUnVH7v9HsTyT0UADfCnWOWpXm4lf1K194WHmnjiXNi9T+mv6aUj7IZLHgY8N8023cAM8KzlOlNZTt2rDB2PwLc/U=;
Message-ID: <51719.68478.qm@web180304.mail.gq1.yahoo.com>
X-YMail-OSG: 3OyEfgUVM1kjPfk9d25Qi.G3ZFQb.bAp.KbJDTX4nsgQK55
 P1GSpdvrJkvb09AazQ5xLut01YyJHW1niEMuTavqdUSwFs3deFDWcqqtFMLs
 swBweverUtAKn3JsN11ftahev8774miLD05qj.u8UbJTzlPJvTHh4w8pdAFn
 JtMMlZugHGWTcOvVMiVoJDCETlRpnqIUmOiPWIOKUOS9u5oYnJb.dgLBHlEo
 .vinI3qQFwPf2XdQRD5zs2JapRGbbQiKlp1aNj7VKFmX3EaRsKSCteQXywkE
 qvyKF8A8HU4eF6bHlY9MnXxMTXDSbbu6cWWzw9gf8y9m5zS.kuaI-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 6 Sep 2010 18:51:55 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] AT91: pio: add gpio_is_valid() function
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
In-Reply-To: <1283782864-10567-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Mon, 9/6/10, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Subject: [PATCH v2] AT91: pio: add gpio_is_valid() function


Of course there already *IS* a gpio_is_valid(),
with arch/platform hooks


> --- a/arch/arm/mach-at91/include/mach/gpio.h
> +++ b/arch/arm/mach-at91/include/mach/gpio.h

>  
> +/* keep room for a couple of GPIO expanders */
> +#define NR_EXTRA_GPIO       64
> +#define ARCH_NR_GPIOS       
> (NR_BUILTIN_GPIO + NR_EXTRA_GPIO)

ISTR contemplating something like NR_EXTRA_GPIO
once too, but deciding against it.  Doing it this
way (per-platform) seems OK.  ISTR, matches OMAP;
might be worth generalizing...)


>  #ifndef __ASSEMBLY__
> +static inline int gpio_is_valid(int number)
> +{
> +    if (number >= PIN_BASE &&

I suppose that clause is the entire reason to
not like the standard gpio_is_valid() ??  Since
on AT91 the IRQ and GPIO numbers share the same
space, but 0..(PIN_BASE-1) are IRQs not GPIOs.
  Yes?

Worth re-thinking your approach to handling that.
Most of the numbers in that range are valid GPIO
numbers -- on non-AT91 platforms.  Maybe AT91
scould grow to_gpio(N) and to_irq(N) macros.  It
was handy sharing the spaces when implementing
GPIO IRQ support, but in retrospect maybe that was
not the best idea.


> +        number <=
> ARCH_NR_GPIOS)


More conventional, FWIW -- just return the
boolean xpression's value ...
> +        return 1;
> +    return 0;

