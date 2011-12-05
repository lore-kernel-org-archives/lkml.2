Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1LEJE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:04:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62627 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1LEJE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <1323075548.20963.7.camel@phoenix>
References: <1323075548.20963.7.camel@phoenix>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 5 Dec 2011 17:04:35 +0800
Message-ID: <CAMPhdO8F8QLjfeJReXSHgJNg+iaJ+CQ9i50ozsqAOiPWxhfwNA@mail.gmail.com>
Subject: Re: [PATCH] pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <spyro@f2s.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 4:59 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> I got buid errors due to implicit declaration of function 'IRQ_GPIO'.
>
> Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().
>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks fine to me.

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
> I got the build error on linux-next,
> this patch is against linux-next 20111205.
>
> Axel
>  drivers/pcmcia/pxa2xx_e740.c      |   11 +++++++----
>  drivers/pcmcia/pxa2xx_palmld.c    |    2 +-
>  drivers/pcmcia/pxa2xx_palmtc.c    |    2 +-
>  drivers/pcmcia/pxa2xx_stargate2.c |    6 ++++--
>  drivers/pcmcia/pxa2xx_vpac270.c   |    4 ++--
>  5 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/pcmcia/pxa2xx_e740.c b/drivers/pcmcia/pxa2xx_e740.c
> index 8bfbd4d..17cd2ce 100644
> --- a/drivers/pcmcia/pxa2xx_e740.c
> +++ b/drivers/pcmcia/pxa2xx_e740.c
> @@ -26,20 +26,23 @@
>  static struct pcmcia_irqs cd_irqs[] = {
>        {
>                .sock = 0,
> -               .irq  = IRQ_GPIO(GPIO_E740_PCMCIA_CD0),
>                .str  = "CF card detect"
>        },
>        {
>                .sock = 1,
> -               .irq  = IRQ_GPIO(GPIO_E740_PCMCIA_CD1),
>                .str  = "Wifi switch"
>        },
>  };
>
>  static int e740_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>  {
> -       skt->socket.pci_irq = skt->nr == 0 ? IRQ_GPIO(GPIO_E740_PCMCIA_RDY0) :
> -                               IRQ_GPIO(GPIO_E740_PCMCIA_RDY1);
> +       if (skt->nr == 0)
> +               skt->socket.pci_irq = gpio_to_irq(GPIO_E740_PCMCIA_RDY0);
> +       else
> +               skt->socket.pci_irq = gpio_to_irq(GPIO_E740_PCMCIA_RDY1);
> +
> +       cd_irqs[0].irq = gpio_to_irq(GPIO_E740_PCMCIA_CD0);
> +       cd_irqs[1].irq = gpio_to_irq(GPIO_E740_PCMCIA_CD1);
>
>        return soc_pcmcia_request_irqs(skt, &cd_irqs[skt->nr], 1);
>  }
> diff --git a/drivers/pcmcia/pxa2xx_palmld.c b/drivers/pcmcia/pxa2xx_palmld.c
> index d589ad1..6a8e011 100644
> --- a/drivers/pcmcia/pxa2xx_palmld.c
> +++ b/drivers/pcmcia/pxa2xx_palmld.c
> @@ -33,7 +33,7 @@ static int palmld_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>        ret = gpio_request_array(palmld_pcmcia_gpios,
>                                ARRAY_SIZE(palmld_pcmcia_gpios));
>
> -       skt->socket.pci_irq = IRQ_GPIO(GPIO_NR_PALMLD_PCMCIA_READY);
> +       skt->socket.pci_irq = gpio_to_irq(GPIO_NR_PALMLD_PCMCIA_READY);
>
>        return ret;
>  }
> diff --git a/drivers/pcmcia/pxa2xx_palmtc.c b/drivers/pcmcia/pxa2xx_palmtc.c
> index 9c6a04b..9e38de7 100644
> --- a/drivers/pcmcia/pxa2xx_palmtc.c
> +++ b/drivers/pcmcia/pxa2xx_palmtc.c
> @@ -37,7 +37,7 @@ static int palmtc_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>        ret = gpio_request_array(palmtc_pcmcia_gpios,
>                                ARRAY_SIZE(palmtc_pcmcia_gpios));
>
> -       skt->socket.pci_irq = IRQ_GPIO(GPIO_NR_PALMTC_PCMCIA_READY);
> +       skt->socket.pci_irq = gpio_to_irq(GPIO_NR_PALMTC_PCMCIA_READY);
>
>        return ret;
>  }
> diff --git a/drivers/pcmcia/pxa2xx_stargate2.c b/drivers/pcmcia/pxa2xx_stargate2.c
> index 9396222..6c2366b 100644
> --- a/drivers/pcmcia/pxa2xx_stargate2.c
> +++ b/drivers/pcmcia/pxa2xx_stargate2.c
> @@ -34,7 +34,7 @@
>  #define SG2_S0_GPIO_READY      81
>
>  static struct pcmcia_irqs irqs[] = {
> -       { 0, IRQ_GPIO(SG2_S0_GPIO_DETECT), "PCMCIA0 CD" },
> +       {.sock = 0, .str = "PCMCIA0 CD" },
>  };
>
>  static struct gpio sg2_pcmcia_gpios[] = {
> @@ -44,7 +44,9 @@ static struct gpio sg2_pcmcia_gpios[] = {
>
>  static int sg2_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>  {
> -       skt->socket.pci_irq = IRQ_GPIO(SG2_S0_GPIO_READY);
> +       skt->socket.pci_irq = gpio_to_irq(SG2_S0_GPIO_READY);
> +       irqs[0].irq = gpio_to_irq(SG2_S0_GPIO_DETECT);
> +
>        return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
>  }
>
> diff --git a/drivers/pcmcia/pxa2xx_vpac270.c b/drivers/pcmcia/pxa2xx_vpac270.c
> index 66ab92c..61b17d2 100644
> --- a/drivers/pcmcia/pxa2xx_vpac270.c
> +++ b/drivers/pcmcia/pxa2xx_vpac270.c
> @@ -38,12 +38,10 @@ static struct gpio vpac270_cf_gpios[] = {
>  static struct pcmcia_irqs cd_irqs[] = {
>        {
>                .sock = 0,
> -               .irq  = IRQ_GPIO(GPIO84_VPAC270_PCMCIA_CD),
>                .str  = "PCMCIA CD"
>        },
>        {
>                .sock = 1,
> -               .irq  = IRQ_GPIO(GPIO17_VPAC270_CF_CD),
>                .str  = "CF CD"
>        },
>  };
> @@ -57,6 +55,7 @@ static int vpac270_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>                                ARRAY_SIZE(vpac270_pcmcia_gpios));
>
>                skt->socket.pci_irq = gpio_to_irq(GPIO35_VPAC270_PCMCIA_RDY);
> +               cd_irqs[0].irq = gpio_to_irq(GPIO84_VPAC270_PCMCIA_CD);
>
>                if (!ret)
>                        ret = soc_pcmcia_request_irqs(skt, &cd_irqs[0], 1);
> @@ -65,6 +64,7 @@ static int vpac270_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>                                ARRAY_SIZE(vpac270_cf_gpios));
>
>                skt->socket.pci_irq = gpio_to_irq(GPIO12_VPAC270_CF_RDY);
> +               cd_irqs[1].irq = gpio_to_irq(GPIO17_VPAC270_CF_CD);
>
>                if (!ret)
>                        ret = soc_pcmcia_request_irqs(skt, &cd_irqs[1], 1);
> --
> 1.7.5.4
>
>
>
