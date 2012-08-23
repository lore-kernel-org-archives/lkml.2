Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HWFVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:21:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49285 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2HWFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:21:05 -0400
Message-ID: <5035BDBF.9020602@wwwdotorg.org>
Date: Wed, 22 Aug 2012 23:21:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org, paul.liu@linaro.org
Subject: Re: [PATCH 4/7] regulator: anatop-regulator: convert to use imx-syscon
 to access anatop register
References: <1345619928-15446-1-git-send-email-b29396@freescale.com> <1345619928-15446-5-git-send-email-b29396@freescale.com>
In-Reply-To: <1345619928-15446-5-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 01:18 AM, Dong Aisheng wrote:
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c

> @@ -109,7 +110,11 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
>  	rdesc->ops = &anatop_rops;
>  	rdesc->type = REGULATOR_VOLTAGE;
>  	rdesc->owner = THIS_MODULE;
> -	sreg->mfd = anatopmfd;
> +
> +	sreg->anatop = of_parse_phandle(np, "fsl,anatop", 0);
> +	if (!sreg->anatop)
> +		return -ENODEV;

In fact, that imx_syscon_lookup function I proposed could even do the
of_parse_phandle() internally, so perhaps:

foo->syscon_dev = imx_syscon_lookup(np, "fsl,anatop", 0);
if (IS_ERR(foo->syscon_dev))
    return PTR_ERR(foo->syscon_dev);

with imx_syscon_lookup() internally knowing when to return EPROBE_DEFER
rather than any other permanent error code (e.g. for missing property,
bad phandle, etc.)
