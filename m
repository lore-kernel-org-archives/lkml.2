Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2DILb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 07:31:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42086 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2DILb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 07:31:26 -0400
Message-ID: <4F82C830.1020100@mvista.com>
Date: Mon, 09 Apr 2012 15:29:52 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: netdev@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] davinci_emac: Add cpu_freq support
References: <1333968549-3282-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1333968549-3282-1-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-04-2012 14:49, Manjunathappa, Prakash wrote:

> Reconfigure interrupt coalesce parameter for changed emac bus_freq
> due to DVFS.

> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> ---
>   drivers/net/ethernet/ti/davinci_emac.c |   60 ++++++++++++++++++++++++++++++++
>   1 files changed, 60 insertions(+), 0 deletions(-)

> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
> index 174a334..11d3bd7 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
[...]
> @@ -1761,6 +1765,46 @@ static const struct net_device_ops emac_netdev_ops = {
>   #endif
>   };
>
> +#ifdef CONFIG_CPU_FREQ
> +static int davinci_emac_cpufreq_transition(struct notifier_block *nb,
> +				     unsigned long val, void *data)
> +{
> +	int ret = 0;
> +	struct emac_priv *priv;
> +
> +	priv = container_of(nb, struct emac_priv, freq_transition);
> +	if (priv->coal_intvl != 0) {
> +		if (val == CPUFREQ_POSTCHANGE) {
> +			if (emac_bus_frequency != clk_get_rate(emac_clk)) {

    These 3 *if*s could be collapsed into one, and so indentation level 
lowered significantly.

> +				struct ethtool_coalesce coal;
> +
> +				emac_bus_frequency = clk_get_rate(emac_clk);
> +
> +				priv->bus_freq_mhz = (u32)(emac_bus_frequency /
> +						1000000);
> +				coal.rx_coalesce_usecs = (priv->coal_intvl
> +						<<  4);
> +				ret = emac_set_coalesce(priv->ndev,&coal);
> +			}
> +		}
> +	}
> +	return ret;
> +}
> +
> +static inline int davinci_emac_cpufreq_register(struct emac_priv *priv)
> +{
> +	priv->freq_transition.notifier_call = davinci_emac_cpufreq_transition;
> +	return cpufreq_register_notifier(&priv->freq_transition,
> +					 CPUFREQ_TRANSITION_NOTIFIER);
> +}
> +
> +static inline void davinci_emac_cpufreq_deregister(struct emac_priv *priv)
> +{
> +	cpufreq_unregister_notifier(&priv->freq_transition,
> +				    CPUFREQ_TRANSITION_NOTIFIER);
> +}
> +#endif
> +
>   /**
>    * davinci_emac_probe: EMAC device probe
>    * @pdev: The DaVinci EMAC device that we are removing
> @@ -1925,8 +1969,21 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
>   			   "(regs: %p, irq: %d)\n",
>   			   (void *)priv->emac_base_phys, ndev->irq);
>   	}
> +
> +#ifdef CONFIG_CPU_FREQ
> +	rc = davinci_emac_cpufreq_register(priv);
> +	if (rc) {
> +		dev_err(&pdev->dev, "error in register_netdev\n");

    Really?

> +		rc = -ENODEV;
> +		goto cpufreq_reg_err;
> +	}
> +#endif
>   	return 0;
>
> +#ifdef CONFIG_CPU_FREQ
> +cpufreq_reg_err:
> +	unregister_netdev(ndev);
> +#endif
>   netdev_reg_err:
>   	clk_disable(emac_clk);
>   no_irq_res:
> @@ -1973,6 +2030,9 @@ static int __devexit davinci_emac_remove(struct platform_device *pdev)
>
>   	release_mem_region(res->start, resource_size(res));
>
> +#ifdef CONFIG_CPU_FREQ
> +	davinci_emac_cpufreq_deregister(priv);
> +#endif

    This is considered a bad practice to use #ifdef in the body of function.
Define the faunction you call here as empty inline in case CONFIG_CPU_FREQ is 
not defined instead. The same about davinci_emac_cpufreq_register().

WBR, Sergei
