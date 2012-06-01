Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655Ab2FAWJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:09:00 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:43457
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965479Ab2FAWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:08:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FC93D74.3090200@freescale.com>
Date: Fri, 1 Jun 2012 17:08:52 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup event
 source
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> Add APIs for setting wakeup source and lossless Ethernet in low power modes.
> These APIs can be used by wake-on-packet feature.
> 
> Signed-off-by: Dave Liu <daveliu@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_pmc.c |   71 ++++++++++++++++++++++++++++++++++++++++-
>  arch/powerpc/sysdev/fsl_soc.h |    9 +++++
>  2 files changed, 79 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
> index 1dc6e9e..c1170f7 100644
> --- a/arch/powerpc/sysdev/fsl_pmc.c
> +++ b/arch/powerpc/sysdev/fsl_pmc.c
> @@ -34,6 +34,7 @@ struct pmc_regs {
>  	__be32 powmgtcsr;
>  #define POWMGTCSR_SLP		0x00020000
>  #define POWMGTCSR_DPSLP		0x00100000
> +#define POWMGTCSR_LOSSLESS	0x00400000
>  	__be32 res3[2];
>  	__be32 pmcdr;
>  };
> @@ -43,6 +44,74 @@ static unsigned int pmc_flag;
>  
>  #define PMC_SLEEP	0x1
>  #define PMC_DEEP_SLEEP	0x2
> +#define PMC_LOSSLESS	0x4
> +
> +/**
> + * mpc85xx_pmc_set_wake - enable devices as wakeup event source
> + * @pdev: platform device affected
> + * @enable: True to enable event generation; false to disable
> + *
> + * This enables the device as a wakeup event source, or disables it.
> + *
> + * RETURN VALUE:
> + * 0 is returned on success
> + * -EINVAL is returned if device is not supposed to wake up the system
> + * Error code depending on the platform is returned if both the platform and
> + * the native mechanism fail to enable the generation of wake-up events
> + */
> +int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool enable)

Why does it have to be a platform_device?  Would a bare device_node work
here?  If it's for stuff like device_may_wakeup() that could be in a
platform_device wrapper function.

Where does this get called from?  I don't see an example user in this
patchset.

> +{
> +	int ret = 0;
> +	struct device_node *clk_np;
> +	u32 *prop;
> +	u32 pmcdr_mask;
> +
> +	if (!pmc_regs) {
> +		pr_err("%s: PMC is unavailable\n", __func__);
> +		return -ENODEV;
> +	}
> +
> +	if (enable && !device_may_wakeup(&pdev->dev))
> +		return -EINVAL;

Who is setting can_wakeup for these devices?

> +	clk_np = of_parse_phandle(pdev->dev.of_node, "fsl,pmc-handle", 0);
> +	if (!clk_np)
> +		return -EINVAL;
> +
> +	prop = (u32 *)of_get_property(clk_np, "fsl,pmcdr-mask", NULL);

Don't cast the const away.

> +	if (!prop) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	pmcdr_mask = be32_to_cpup(prop);
> +
> +	if (enable)
> +		/* clear to enable clock in low power mode */
> +		clrbits32(&pmc_regs->pmcdr, pmcdr_mask);
> +	else
> +		setbits32(&pmc_regs->pmcdr, pmcdr_mask);

What is the default PMCDR if this function is never called?  Should init
to all bits set on PM driver probe (or maybe limit it to defined bits
only, though that's a little harder to do generically).

-Scot

