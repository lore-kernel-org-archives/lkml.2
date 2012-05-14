Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2ENDcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:32:22 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:30250
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963Ab2ENDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:32:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
Date: Mon, 14 May 2012 11:51:38 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Richard Zhao <richard.zhao@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <paul.liu@linaro.org>, <broonie@opensource.wolfsonmicro.com>,
        Richard Zhao <richard.zhao@freescale.com>, <sameo@linux.intel.com>,
        <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120514035137.GB20367@S2100-06.ap.freescale.net>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 08:59:54AM +0800, Richard Zhao wrote:
> It makes anatop register access easier. Anatop has many misc registers,
> which may not be a specific driver.
> 
> There's only one anatop device for a running system, so we use a global
> variable to store struct anatop.
> 
>From what I see, it's reasonable.  Then the immediate question I have
is, should we remove "struct anatop *adata" from anatop_read_reg and
anatop_write_reg completely?

Regards,
Shawn

> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> ---
>  drivers/mfd/anatop-mfd.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
> index 3bb7c49..b0313210 100644
> --- a/drivers/mfd/anatop-mfd.c
> +++ b/drivers/mfd/anatop-mfd.c
> @@ -41,8 +41,15 @@
>  #include <linux/of_address.h>
>  #include <linux/mfd/anatop.h>
>  
> +/* For any running system, there's only one anatop device. */
> +static struct anatop *anatop_data;
> +
>  u32 anatop_read_reg(struct anatop *adata, u32 addr)
>  {
> +	BUG_ON(!anatop_data);
> +	if (!adata)
> +		adata = anatop_data;
> +
>  	return readl(adata->ioreg + addr);
>  }
>  EXPORT_SYMBOL_GPL(anatop_read_reg);
> @@ -51,6 +58,10 @@ void anatop_write_reg(struct anatop *adata, u32 addr, u32 data, u32 mask)
>  {
>  	u32 val;
>  
> +	BUG_ON(!anatop_data);
> +	if (!adata)
> +		adata = anatop_data;
> +
>  	data &= mask;
>  
>  	spin_lock(&adata->reglock);
> @@ -83,6 +94,7 @@ static int __devinit of_anatop_probe(struct platform_device *pdev)
>  	drvdata->ioreg = ioreg;
>  	spin_lock_init(&drvdata->reglock);
>  	platform_set_drvdata(pdev, drvdata);
> +	anatop_data = drvdata;
>  	of_platform_populate(np, of_anatop_match, NULL, dev);
>  
>  	return 0;
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

