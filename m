Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2DXTA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:00:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40998 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2DXTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:00:26 -0400
Message-ID: <4F96F847.508@wwwdotorg.org>
Date: Tue, 24 Apr 2012 13:00:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v2 1/2] pinctrl: add pinctrl_provide_dummies interface
 for platforms to use
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1335260023-15859-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:33 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Add a interface pinctrl_provide_dummies for platform to indicate
> whether it needs use pinctrl dummy state and dummy gpio.

> @@ -382,7 +396,12 @@ int pinctrl_request_gpio(unsigned gpio)
>  	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
>  	if (ret) {
>  		mutex_unlock(&pinctrl_mutex);
> -		return -EINVAL;
> +		if (pinctrl_dummy_gpio) {
> +			pr_debug("pinctrl: using dummy gpio(%u)\n", gpio);
> +			return 0;
> +		} else {
> +			return -EINVAL;
> +		}
>  	}

The only thing that should be calling pinctrl_request_gpio() is a GPIO
driver. It should only be calling it for the GPIOs it manages. I'd
expect that if a platform's pinctrl driver was not yet written to
support the GPIO functionality, then the GPIO driver would not be
calling this function.

As such, I'm not sure that this part of the change is necessary.

If it is, then surely all the other pinctrl GPIO APIs need a similar change?

Finally, how does this interact with deferred probe: How does the code
know whether the pinctrl driver and/or GPIO range is simply not yet
registered, or whether it never will be? That'd be the difference
between returning -EPROBE_DEFER or 0 in the if block above.


I'm fine with the other parts of this patch.
