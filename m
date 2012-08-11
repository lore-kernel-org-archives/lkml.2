Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2HKNTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 09:19:48 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:27786
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab2HKNTr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 09:19:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hf0ah107ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH 2/4] fsl_pmc: Add API to enable device as wakeup event
 source
Thread-Topic: [PATCH 2/4] fsl_pmc: Add API to enable device as wakeup event
 source
Thread-Index: AQHNd8P4LAXTlFz0D0K3tYD/bdzH1w==
Date: Sat, 11 Aug 2012 13:19:43 +0000
Message-ID: <CAOZdJXXdgS5x2ZkuXb4wHckdqLzSM2xy-eYU3+28d_=JH3euxg@mail.gmail.com>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
	<1344329006-10645-2-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1344329006-10645-2-git-send-email-chenhui.zhao@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <4FB0EB735C3E5C40ACE8D4C0127664EA@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 3:43 AM, Zhao Chenhui <chenhui.zhao@freescale.com> wrote:

> +int mpc85xx_pmc_set_wake(struct device *dev, bool enable)
> +{
> +       int ret = 0;
> +       struct device_node *clk_np;
> +       const u32 *prop;
> +       u32 pmcdr_mask;
> +
> +       if (!pmc_regs) {
> +               pr_err("%s: PMC is unavailable\n", __func__);

You have a 'struct device', so please use dev_err instead.

> +               return -ENODEV;
> +       }
> +
> +       if (enable && !device_may_wakeup(dev))
> +               return -EINVAL;
> +
> +       clk_np = of_parse_phandle(dev->of_node, "fsl,pmc-handle", 0);
> +       if (!clk_np)
> +               return -EINVAL;
> +
> +       prop = of_get_property(clk_np, "fsl,pmcdr-mask", NULL);
> +       if (!prop) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +       pmcdr_mask = be32_to_cpup(prop);
> +
> +       if (enable)
> +               /* clear to enable clock in low power mode */
> +               clrbits32(&pmc_regs->pmcdr, pmcdr_mask);
> +       else
> +               setbits32(&pmc_regs->pmcdr, pmcdr_mask);
> +
> +out:
> +       of_node_put(clk_np);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_wake);

Use EXPORT_SYMBOL, not EXPORT_SYMBOL_GPL.

> +
> +/**
> + * mpc85xx_pmc_set_lossless_ethernet - enable lossless ethernet
> + * in (deep) sleep mode
> + * @enable: True to enable event generation; false to disable
> + */
> +void mpc85xx_pmc_set_lossless_ethernet(int enable)

Should this be 'bool enable'?

> @@ -21,6 +22,17 @@ struct device_node;
>
>  extern void fsl_rstcr_restart(char *cmd);
>
> +#ifdef CONFIG_FSL_PMC
> +extern int mpc85xx_pmc_set_wake(struct device *dev, bool enable);
> +extern void mpc85xx_pmc_set_lossless_ethernet(int enable);

Don't use 'extern' for functions.

-- 
Timur Tabi
Linux kernel developer at Freescale
