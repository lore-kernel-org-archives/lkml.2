Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1HPDbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 23:31:08 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:43948
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab1HPDbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 23:31:03 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 16 Aug 2011 11:39:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC PATCH v2 09/13] gpio/tegra: Add device tree support
Message-ID: <20110816033900.GF8044@S2100-06.ap.freescale.net>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-10-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1313440100-17131-10-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 02:28:16PM -0600, Stephen Warren wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/gpio/gpio-tegra.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index 4da4839..1d0a764 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -326,6 +326,30 @@ static struct irq_chip tegra_gpio_irq_chip = {
>  #endif
>  };
>  
> +#ifdef CONFIG_OF
> +static void __init tegra_gpio_probe_dt(struct platform_device *pdev)
> +{
> +	const __be32 *gpios;
> +	u32 gpioslen;
> +	int i;
> +
> +	gpios = of_get_property(pdev->dev.of_node, "nvidia,enabled-gpios",
> +				&gpioslen);
> +	if (gpios == NULL)
> +		return;
> +
> +	gpioslen /= sizeof(*gpios);
> +	for (i = 0; i < gpioslen; i++, gpios++) {
> +		u32 gpio = be32_to_cpup(gpios);
> +		dev_dbg(&pdev->dev, "Enabling GPIO %d\n", gpio);
> +		tegra_gpio_enable(gpio);
> +	}
> +}
> +#else
> +static inline void __init tegra_gpio_probe_dt(struct platform_device *pdev)
> +{
> +}
> +#endif
>  
With your patch below being merged, and the suggestion that
of_property_read_u32[_array] should be used to read integer from
device tree, the #ifdef thing can be removed?

  [PATCH] dt: add empty of_get_property for non-dt

Regards,
Shawn

>  /* This lock class tells lockdep that GPIO irqs are in a different
>   * category than their parents, so it won't report false recursion.
> @@ -371,13 +395,21 @@ static int __init tegra_gpio_probe(struct platform_device *pdev)
>  			spin_lock_init(&bank->lvl_lock[j]);
>  	}
>  
> +	tegra_gpio_probe_dt(pdev);
> +
>  	return 0;
>  }
>  
> +static struct of_device_id tegra_gpio_of_match[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra20-gpio", },
> +	{ },
> +};
> +
>  static struct platform_driver tegra_gpio_driver = {
>  	.driver		= {
>  		.name	= "tegra-gpio",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = tegra_gpio_of_match,
>  	},
>  	.probe		= tegra_gpio_probe,
>  };
> -- 
> 1.7.0.4
> 
> 

