Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2DPSMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:12:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58110 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2DPSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:12:01 -0400
Message-ID: <4F8C60EE.30008@wwwdotorg.org>
Date: Mon, 16 Apr 2012 12:11:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/3] pinctrl: display pin name instead of raw pin id
References: <1334585244-10249-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1334585244-10249-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 08:07 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Pin name is more useful to users.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -964,10 +984,14 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
>  			seq_printf(s, "%s [ERROR GETTING PINS]\n",
>  				   gname);
>  		else {
> +			seq_printf(s, "group: %s\n", gname);
> +			for (i = 0; i < num_pins; i++) {
> +				pname = pin_get_name(pctldev, pins[i]);
> +				if (!pname)
> +					return -EINVAL;

I'd rather see this say pname = "(unknown)" instead of return, to get as
much of the information into debugfs possible even in the face of errors.

But perhaps that condition should even be a BUG(); it would imply that
pinctrl_register_on_pin() had failed pretty badly.

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index c494c37..fa0357b 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -88,8 +88,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
>  	const struct pinmux_ops *ops = pctldev->desc->pmxops;
>  	int status = -EINVAL;
>  
> -	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, owner);
> -
>  	desc = pin_desc_get(pctldev, pin);
>  	if (desc == NULL) {
>  		dev_err(pctldev->dev,
> @@ -97,6 +95,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
>  		goto out;
>  	}
>  
> +	dev_dbg(pctldev->dev, "request pin %d (%s) for %s\n",
> +		pin, desc->name, owner);
> +
>  	if (gpio_range) {
>  		/* There's no need to support multiple GPIO requests */
>  		if (desc->gpio_owner) {

That seems like it should be a separate patch?
