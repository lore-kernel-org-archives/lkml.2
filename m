Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2IFIcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:32:54 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59263 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2IFIcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:32:50 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <63235.162.105.203.8.1346920695.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1346581273-7041-2-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
    <1346581273-7041-2-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 6 Sep 2012 16:38:15 +0800 (CST)
Subject: Re: [PATCH 1/6] unicore32: pwm: Properly remap memory-mapped 
     registers
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        "Mike Turquette" <mturquette@linaro.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of writing to the timer controller registers by dereferencing a
> pointer to the memory location, properly remap the memory region with a
> call to ioremap_nocache() and access the registers using writel().
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/unicore32/kernel/pwm.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> index 4615d51..410b786 100644
> --- a/arch/unicore32/kernel/pwm.c
> +++ b/arch/unicore32/kernel/pwm.c
> @@ -23,10 +23,16 @@
>  #include <asm/div64.h>
>  #include <mach/hardware.h>
>
> +#define PWCR 0x00
> +#define DCCR 0x04
> +#define PCR  0x08
I think old register names could be used here by some small modifications.
Please see arch/unicore32/include/mach/regs-ost.h
We can avoid ioremap and use writel/readl directly on these registers.

Guan

> +
>  struct pwm_device {
>  	struct list_head	node;
>  	struct platform_device *pdev;
>
> +	void __iomem	*base;
> +
>  	const char	*label;
>  	struct clk	*clk;
>  	int		clk_enabled;
> @@ -69,9 +75,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int
> period_ns)
>  	 * before writing to the registers
>  	 */
>  	clk_enable(pwm->clk);
> -	OST_PWMPWCR = prescale;
> -	OST_PWMDCCR = pv - dc;
> -	OST_PWMPCR  = pv;
> +
> +	writel(prescale, pwm->base + PWCR);
> +	writel(pv - dc, pwm->base + DCCR);
> +	writel(pv, pwm->base + PCR);
> +
>  	clk_disable(pwm->clk);
>
>  	return 0;
> @@ -190,10 +198,19 @@ static struct pwm_device *pwm_probe(struct
> platform_device *pdev,
>  		goto err_free_clk;
>  	}
>
> +	pwm->base = ioremap_nocache(r->start, resource_size(r));
> +	if (pwm->base == NULL) {
> +		dev_err(&pdev->dev, "failed to remap memory resource\n");
> +		ret = -EADDRNOTAVAIL;
> +		goto err_release_mem;
> +	}
> +
>  	__add_pwm(pwm);
>  	platform_set_drvdata(pdev, pwm);
>  	return pwm;
>
> +err_release_mem:
> +	release_mem_region(r->start, resource_size(r));
>  err_free_clk:
>  	clk_put(pwm->clk);
>  err_free:
> @@ -224,6 +241,8 @@ static int __devexit pwm_remove(struct platform_device
> *pdev)
>  	list_del(&pwm->node);
>  	mutex_unlock(&pwm_lock);
>
> +	iounmap(pwm->base);
> +
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	release_mem_region(r->start, resource_size(r));
>
> --
> 1.7.12
>

