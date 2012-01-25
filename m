Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2AYDks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 22:40:48 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:34983 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab2AYDkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 22:40:47 -0500
Message-ID: <4F1F79B5.30700@st.com>
Date: Wed, 25 Jan 2012 09:10:37 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Christopher BLAIR <chris.blair@stericsson.com>
Subject: Re: [PATCH] gpio/stmpe: Correct cleanup for no-irq mode
References: <1327446403-11775-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1327446403-11775-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 4:36 AM, Linus WALLEIJ wrote:
> From: Chris Blair <chris.blair@stericsson.com>
> 
> Corrects error condition and driver removal cleanup for the no-irq
> configuration.
> 
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Chris Blair <chris.blair@stericsson.com>
> ---
> This depends on the previous patch to the MFD code so should
> better be merged into the MFD tree with the previous patch.
> ---
>  drivers/gpio/gpio-stmpe.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index 87a68a8..1008c7c 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -361,9 +361,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>  	return 0;
>  
>  out_freeirq:
> -	free_irq(irq, stmpe_gpio);
> +	if (!stmpe->pdata->no_irq)
> +		free_irq(irq, stmpe_gpio);
>  out_removeirq:
> -	stmpe_gpio_irq_remove(stmpe_gpio);
> +	if (!stmpe->pdata->no_irq)
> +		stmpe_gpio_irq_remove(stmpe_gpio);
>  out_disable:
>  	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  out_free:
> @@ -391,8 +393,10 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
>  
>  	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  
> -	free_irq(irq, stmpe_gpio);
> -	stmpe_gpio_irq_remove(stmpe_gpio);
> +	if (!stmpe->pdata->no_irq) {
> +		free_irq(irq, stmpe_gpio);
> +		stmpe_gpio_irq_remove(stmpe_gpio);
> +	}
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(stmpe_gpio);
>  

Please check others stmpe drivers too, stmpe-ts & stmpe-keypad. :)

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
