Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1DLLlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:41:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1DLLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:41:39 -0400
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:41:28 +0200
Message-ID: <1302608488.3639.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 12:59 +0200, Antonio Ospite wrote:
> Add a regulator consumer driver for rfkill to enable controlling radio
> transmitters connected to voltage regulators using the regulator
> framework.
> 
> A new "vrfkill" virtual supply is provided to use in platform code.
> 
> Signed-off-by: Guiming Zhuo <gmzhuo@gmail.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
> 
> Changes since v1:
> 
>   - changed "voltage regulator" to "voltage regulators" in the commit
>     message
> 
>   - drop rfkill_init_sw_state() as requested by Johannes Berg
> 
>   - moved assignment fields of rfkill_data _before_ rfkill_register(),
>     as the latter will call .set_block (via schedule_work()) which would
>     find NULL pointers for the .vcc and .rf_kill fields otherwise.
> 
>     This issue was masked when I was using rfkill_init_sw_state() which
>     was setting the persistent flag: rfkill_register() does not call
>     schedule_work() immediately when the persistent flag is set.
> 
>     So please take another look at this part of rfkill_regulator_probe().
> 
> Mark, I left in the RFKILL || !RFKILL part.
> 
> If there are no more comments, who is going to merge the driver, Johannes?

I don't have a tree, John can merge it, but I found a few more bugs:

> + * static struct regulator_consumer_supply pcap_regulator_V6_consumers [] = {
> + * 	{ .dev_name = "rfkill-regulator.0", supply = "vrfkill" },
> + * };

It's a comment, but it should be .supply = (missing the .)

> +	if (pdata->name == NULL || pdata->type == 0) {
> +		dev_err(&pdev->dev, "invalid name or type in platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	vcc = regulator_get_exclusive(&pdev->dev, "vrfkill");

Wasn't that supposed to use pdata->supply? Actually, there's no member
"supply" in the struct?

> +	dev_info(&pdev->dev, "initialized\n");

Is that message really useful?

Other than that, looks good to me.

johannes

