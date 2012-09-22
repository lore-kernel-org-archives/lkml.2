Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2IVD4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 23:56:34 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:53176 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2IVD4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 23:56:33 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <50857.162.105.203.8.1348282622.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1347956633-15667-5-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
    <1347956633-15667-5-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 22 Sep 2012 10:57:02 +0800 (CST)
Subject: Re: [PATCH v2 4/5] unicore32: pwm: Use managed resource allocations
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, "Qin Rui" <qinrui@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This commit uses the managed resource allocation functions to simplify
> the cleanup paths on error and removal.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks & Regards,
Guan Xuetao

> ---
>  arch/unicore32/kernel/pwm.c | 47
> +++++++++------------------------------------
>  1 file changed, 9 insertions(+), 38 deletions(-)
>
> diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> index 7e23470..724e860 100644
> --- a/arch/unicore32/kernel/pwm.c
> +++ b/arch/unicore32/kernel/pwm.c
> @@ -160,19 +160,17 @@ static int __devinit pwm_probe(struct
> platform_device *pdev)
>  {
>  	struct pwm_device *pwm;
>  	struct resource *r;
> -	int ret = 0;
>
> -	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> +	pwm = devm_kzalloc(&pdev->dev, sizeof(struct pwm_device), GFP_KERNEL);
>  	if (pwm == NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
>  		return -ENOMEM;
>  	}
>
> -	pwm->clk = clk_get(NULL, "OST_CLK");
> -	if (IS_ERR(pwm->clk)) {
> -		ret = PTR_ERR(pwm->clk);
> -		goto err_free;
> -	}
> +	pwm->clk = devm_clk_get(&pdev->dev, "OST_CLK");
> +	if (IS_ERR(pwm->clk))
> +		return PTR_ERR(pwm->clk);
> +
>  	pwm->clk_enabled = 0;
>
>  	pwm->use_count = 0;
> @@ -182,41 +180,21 @@ static int __devinit pwm_probe(struct
> platform_device *pdev)
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r == NULL) {
>  		dev_err(&pdev->dev, "no memory resource defined\n");
> -		ret = -ENODEV;
> -		goto err_free_clk;
> -	}
> -
> -	r = request_mem_region(r->start, resource_size(r), pdev->name);
> -	if (r == NULL) {
> -		dev_err(&pdev->dev, "failed to request memory resource\n");
> -		ret = -EBUSY;
> -		goto err_free_clk;
> +		return -ENODEV;
>  	}
>
> -	pwm->base = ioremap_nocache(r->start, resource_size(r));
> -	if (pwm->base == NULL) {
> -		dev_err(&pdev->dev, "failed to remap memory resource\n");
> -		ret = -EADDRNOTAVAIL;
> -		goto err_release_mem;
> -	}
> +	pwm->base = devm_request_and_ioremap(&pdev->dev, r);
> +	if (pwm->base == NULL)
> +		return -EADDRNOTAVAIL;
>
>  	__add_pwm(pwm);
>  	platform_set_drvdata(pdev, pwm);
>  	return 0;
> -
> -err_release_mem:
> -	release_mem_region(r->start, resource_size(r));
> -err_free_clk:
> -	clk_put(pwm->clk);
> -err_free:
> -	kfree(pwm);
> -	return ret;
>  }
>
>  static int __devexit pwm_remove(struct platform_device *pdev)
>  {
>  	struct pwm_device *pwm;
> -	struct resource *r;
>
>  	pwm = platform_get_drvdata(pdev);
>  	if (pwm == NULL)
> @@ -226,13 +204,6 @@ static int __devexit pwm_remove(struct
> platform_device *pdev)
>  	list_del(&pwm->node);
>  	mutex_unlock(&pwm_lock);
>
> -	iounmap(pwm->base);
> -
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
> -
> -	clk_put(pwm->clk);
> -	kfree(pwm);
>  	return 0;
>  }
>
> --
> 1.7.12
>

