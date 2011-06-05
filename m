Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1FECiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 22:38:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1FECh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 22:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=utdFS7ZGh6slt3WRQiFusNsH69gTxZK6BObDX+H4G0+BA92X4YtKrzXpSuArfvdB45
         zuKVDH8KUu2u3vVKL1jg==
MIME-Version: 1.0
In-Reply-To: <1307214239-16316-1-git-send-email-ccross@android.com>
References: <1307214239-16316-1-git-send-email-ccross@android.com>
Date: Sat, 4 Jun 2011 19:37:54 -0700
X-Google-Sender-Auth: ronXazzBXvTCX2w4XJu1pmyilFc
Message-ID: <BANLkTingmUNvZO_szivRkmn7LRO4L5A+5Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
From: Colin Cross <ccross@android.com>
To: l-o <linux-omap@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 4, 2011 at 12:03 PM, Colin Cross <ccross@android.com> wrote:
> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
> causing only the last bit set to take effect, resulting in lost
> wakeups when the GPIO controller is in idle.
>
> Replace direct writes to IRQWAKEN with writes to SETWKUENA and
> CLEARWKUEN.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/plat-omap/gpio.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
> index c985652..23ac7b6 100644
> --- a/arch/arm/plat-omap/gpio.c
> +++ b/arch/arm/plat-omap/gpio.c
> @@ -539,7 +539,6 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
>  {
>        void __iomem *base = bank->base;
>        u32 gpio_bit = 1 << gpio;
> -       u32 val;
>
>        if (cpu_is_omap44xx()) {
>                MOD_REG_BIT(OMAP4_GPIO_LEVELDETECT0, gpio_bit,
> @@ -563,14 +562,11 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
>        if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
>                if (cpu_is_omap44xx()) {
>                        if (trigger != 0)
> -                               __raw_writel(1 << gpio, bank->base+
> -                                               OMAP4_GPIO_IRQWAKEN0);
> -                       else {
> -                               val = __raw_readl(bank->base +
> -                                                       OMAP4_GPIO_IRQWAKEN0);
> -                               __raw_writel(val & (~(1 << gpio)), bank->base +
> -                                                        OMAP4_GPIO_IRQWAKEN0);
> -                       }
> +                               __raw_writel(gpio_bit,
> +                                       bank->base + OMAP4_GPIO_SETWKUENA);
> +                       else
> +                               __raw_writel(gpio_bit,
> +                                       bank->base + OMAP4_GPIO_CLEARWKUENA);

Todd pointed out that the OMAP4 TRM says not to use SETWKUENA and
CLEARWKUENA.  I'll send another patch that applies to v3.0-rc1 that
uses MOD_REG_BIT on IRQWAKEN_0, and another patch that adds the
necessary locking around the read-modify-writes in
_set_gpio_triggering.

>                } else {
>                        /*
>                         * GPIO wakeup request can only be generated on edge
> --
> 1.7.4.1
>
>
