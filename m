Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab1HINm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:42:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57716 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HINm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:42:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Tue, 09 Aug 2011 15:42:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC][PATCH 1/2] S5PV210: SPI: Add clkdev support
In-reply-to: <1312898222-7165-1-git-send-email-padma.v@samsung.com>
To: Padmavathi Venna <padma.v@samsung.com>
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, jassi Brar <jassisinghbrar@gmail.com>
Message-id: <4E413941.10307@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18)
 Gecko/20110617 Thunderbird/3.1.11
References: <1312898222-7165-1-git-send-email-padma.v@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[corrected Jassi's email address]

On 08/09/2011 03:57 PM, Padmavathi Venna wrote:
> Create a clkdev alias for spi bus clock and modify the spi
> driver to lookup the clock using the alias name instead of
> passing clock name and clock number from SPI platform data.
> 
> Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
> ---
> This patch is tested for S5PV210 platform and similar
> changes can be adopted for rest of the Samsung's s3c
> and s5p platforms, if this approach is accepted.

It is a bit surprising to me how you do intend to use the clock aliases.
Are we seriously going to be creating clock con_id aliases for most
of the available devices ? It doesn't sound sane to me..

Wouldn't it be possible to avoid the aliases by correcting the clock
registration process ?

>  arch/arm/mach-s5pv210/dev-spi.c                  |   31 ++++++++++++++++++---
>  arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |    7 +----
>  2 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pv210/dev-spi.c b/arch/arm/mach-s5pv210/dev-spi.c
...
> -void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
> +void __init s5pv210_spi_set_info(int cntrlr, int num_cs)
>  {
>  	struct s3c64xx_spi_info *pd;
> +	struct device *dev;
> +	char devname[16], clk_alias_name[16];
> +	int ret, i;
>  
>  	/* Reject invalid configuration */
> -	if (!num_cs || src_clk_nr < 0
> -			|| src_clk_nr > S5PV210_SPI_SRCCLK_SCLK) {
> +	if (!num_cs) {
>  		printk(KERN_ERR "%s: Invalid SPI configuration\n", __func__);
>  		return;
>  	}
> @@ -159,9 +162,11 @@ void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
>  	switch (cntrlr) {
>  	case 0:
>  		pd = &s5pv210_spi0_pdata;
> +		dev = &s5pv210_device_spi0.dev;
>  		break;
>  	case 1:
>  		pd = &s5pv210_spi1_pdata;
> +		dev = &s5pv210_device_spi1.dev;
>  		break;
>  	default:
>  		printk(KERN_ERR "%s: Invalid SPI controller(%d)\n",
> @@ -169,7 +174,23 @@ void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
>  		return;
>  	}
>  
> +	sprintf(devname, "s3c64xx-spi.%d", cntrlr);
> +
> +	for (i = 0; i < ARRAY_SIZE(spi_src_clks); i++) {
> +		sprintf(clk_alias_name, "clk_spi_bus%d", i);
> +
> +		if (!strcmp(spi_src_clks[i], "pclk"))
> +			ret = clk_add_alias(clk_alias_name, devname,
> +						spi_src_clks[i], NULL);
> +		else
> +			ret = clk_add_alias(clk_alias_name, devname,
> +						spi_src_clks[i], dev);
> +		if (ret) {
> +			printk(KERN_ERR "failed to create alias for"
> +				" SPI%d source clock%d\n", cntrlr, i);
> +			continue;
> +		}
> +	}
> +
>  	pd->num_cs = num_cs;
> -	pd->src_clk_nr = src_clk_nr;
> -	pd->src_clk_name = spi_src_clks[src_clk_nr];
>  }
...

--
Thanks,
Sylwester
