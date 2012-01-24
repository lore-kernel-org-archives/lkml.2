Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2AXLeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:34:25 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:34957 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab2AXLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:34:23 -0500
Message-ID: <4F1E9734.1040807@st.com>
Date: Tue, 24 Jan 2012 17:04:12 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Christopher BLAIR <chris.blair@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [PATCH] mfd/stmpe: Add support for no-interrupt config
References: <1327400314-18030-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1327400314-18030-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/2012 3:48 PM, Linus WALLEIJ wrote:
> From: Chris Blair <chris.blair@stericsson.com>
> 
> Adds support for boards which have an STMPE device without the
> interrupt pin connected.
> 
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Signed-off-by: Chris Blair <chris.blair@stericsson.com>
> Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c       |   72 +++++++++++++++++++++++++--------------------
>  include/linux/mfd/stmpe.h |    2 +
>  2 files changed, 42 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c

> @@ -988,7 +990,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
>  	if (ci->init)
>  		ci->init(stmpe);
>  
> -	if (pdata->irq_over_gpio) {
> +	if (!pdata->no_irq && pdata->irq_over_gpio) {
>  		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
>  		if (ret) {
>  			dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",

[I will add the actual code present here after this change to describe the concern]

	if (!pdata->no_irq && pdata->irq_over_gpio) {
		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
		if (ret) {
			dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",
					ret);
			goto out_free;
		}

		stmpe->irq = gpio_to_irq(pdata->irq_gpio);
	} else {
		stmpe->irq = ci->irq;
	}

Actually you want neither of them to work for no_irq case, if and else.
But with this code, if you pass no_irq = true, then else part will get called.

> @@ -1005,15 +1007,21 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
>  	if (ret)
>  		goto free_gpio;
>  
> -	ret = stmpe_irq_init(stmpe);
> -	if (ret)
> -		goto free_gpio;
> +	if (pdata->no_irq) {
> +		dev_info(stmpe->dev,
> +			"board config says IRQs are not supported\n");
> +	} else {
> +		ret = stmpe_irq_init(stmpe);
> +		if (ret)
> +			goto free_gpio;
>  

There are few more cases to handle in error part of probe and remove, where
following routines are called.

	free_irq(stmpe->irq, stmpe);
	stmpe_irq_remove(stmpe);
	if (pdata->irq_over_gpio)
		gpio_free(pdata->irq_gpio);

-- 
viresh
