Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2IVDzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 23:55:01 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:39525 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2IVDzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 23:55:00 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <50852.162.105.203.8.1348282609.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1347956633-15667-4-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
    <1347956633-15667-4-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 22 Sep 2012 10:56:49 +0800 (CST)
Subject: Re: [PATCH v2 3/5] unicore32: pwm: Remove unnecessary indirection
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

> Calling the actual probing function through a proxy isn't required and
> makes the code needlessly complex.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks & Regards,
Guan Xuetao


> ---
>  arch/unicore32/kernel/pwm.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> index 012c54a..7e23470 100644
> --- a/arch/unicore32/kernel/pwm.c
> +++ b/arch/unicore32/kernel/pwm.c
> @@ -156,8 +156,7 @@ static inline void __add_pwm(struct pwm_device *pwm)
>  	mutex_unlock(&pwm_lock);
>  }
>
> -static struct pwm_device *pwm_probe(struct platform_device *pdev,
> -		unsigned int pwm_id, struct pwm_device *parent_pwm)
> +static int __devinit pwm_probe(struct platform_device *pdev)
>  {
>  	struct pwm_device *pwm;
>  	struct resource *r;
> @@ -166,7 +165,7 @@ static struct pwm_device *pwm_probe(struct
> platform_device *pdev,
>  	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
>  	if (pwm == NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		return ERR_PTR(-ENOMEM);
> +		return -ENOMEM;
>  	}
>
>  	pwm->clk = clk_get(NULL, "OST_CLK");
> @@ -177,7 +176,7 @@ static struct pwm_device *pwm_probe(struct
> platform_device *pdev,
>  	pwm->clk_enabled = 0;
>
>  	pwm->use_count = 0;
> -	pwm->pwm_id = pwm_id;
> +	pwm->pwm_id = pdev->id;
>  	pwm->pdev = pdev;
>
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -203,7 +202,7 @@ static struct pwm_device *pwm_probe(struct
> platform_device *pdev,
>
>  	__add_pwm(pwm);
>  	platform_set_drvdata(pdev, pwm);
> -	return pwm;
> +	return 0;
>
>  err_release_mem:
>  	release_mem_region(r->start, resource_size(r));
> @@ -211,17 +210,7 @@ err_free_clk:
>  	clk_put(pwm->clk);
>  err_free:
>  	kfree(pwm);
> -	return ERR_PTR(ret);
> -}
> -
> -static int __devinit puv3_pwm_probe(struct platform_device *pdev)
> -{
> -	struct pwm_device *pwm = pwm_probe(pdev, pdev->id, NULL);
> -
> -	if (IS_ERR(pwm))
> -		return PTR_ERR(pwm);
> -
> -	return 0;
> +	return ret;
>  }
>
>  static int __devexit pwm_remove(struct platform_device *pdev)
> @@ -251,7 +240,7 @@ static struct platform_driver puv3_pwm_driver = {
>  	.driver		= {
>  		.name	= "PKUnity-v3-PWM",
>  	},
> -	.probe		= puv3_pwm_probe,
> +	.probe		= pwm_probe,
>  	.remove		= __devexit_p(pwm_remove),
>  };
>  module_platform_driver(puv3_pwm_driver);
> --
> 1.7.12
>

