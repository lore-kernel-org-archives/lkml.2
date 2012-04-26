Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2DZG2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:28:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14488 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2DZG2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:28:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="182789901"
Message-ID: <4F98EB10.2000505@codeaurora.org>
Date: Wed, 25 Apr 2012 23:28:32 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
CC: Andrew Lunn <andrew@lunn.ch>, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:58 PM, Saravana Kannan wrote:
> Create a struct clk_init_data to hold all data that needs to be passed from
> the platfrom specific driver to the common clock framework during clock
> registration. Add a pointer to this struct inside clk_hw.
>
> This has several advantages:
> * Completely hides struct clk from many clock platform drivers and static
>    clock initialization code that don't care for static initialization of
>    the struct clks.
> * For platforms that want to do complete static initialization, it removed
>    the need to directly mess with the struct clk's fields while still
>    allowing to statically allocate struct clk. This keeps the code more
>    future proof even if they include clk-private.h.
> * Simplifies the generic clk_register() function and allows adding optional
>    fields in the future without modifying the function signature.
> * Simplifies the static initialization of clocks on all platforms by
>    removing the need for forward delcarations or convoluted macros.

<SNIP>

> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 90627e4..8ea11b4 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -167,6 +167,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>   {

<SNIP>

> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index b555a04..cbd2462 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -52,6 +52,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>   {

<SNIP>

> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> index 0021616..578465e 100644
> --- a/drivers/clk/clk-gate.c
> +++ b/drivers/clk/clk-gate.c
> @@ -119,6 +119,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
>   {

<SNIP>

> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 6e58f11..8e97491 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -95,6 +95,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>   {

I would really like to remove these functions. At least until we add 
device tree support where each clock is listed in device tree.

At present, these functions seem to be abused more than actually being 
used appropriately. IMHO, these should not be used to register clocks in 
your probe function by calling these functions one at a time. Just 
declare the clocks statically and call clk_register in a loop on them.

The only time I see these functions as being appropriate is when the 
list of clocks in your device is detected by actually probing (reading 
registers) HW or by parsing device tree (haven't followed it closely, 
but still seems to be work in progress).

Regards,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
