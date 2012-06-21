Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2FUDNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:13:02 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41276 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab2FUDNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:13:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6748"; a="203144053"
Message-ID: <4FE2913B.1040102@codeaurora.org>
Date: Wed, 20 Jun 2012 20:12:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: jonghwa3.lee@samsung.com
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
References: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com> <4FE26F27.4010106@codeaurora.org> <4FE2897C.6050002@samsung.com>
In-Reply-To: <4FE2897C.6050002@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/12 19:39, jonghwa3.lee@samsung.com wrote:
>
>>> +static int exynos_init(struct hwrng *rng)
>>> +{
>>> +	struct exynos_rng *exynos_rng = container_of(rng,
>>> +						struct exynos_rng, rng);
>>> +	int i;
>>> +	int ret = 0;
>>> +	u32 PRND_SEED[5];
>>> +
>>> +	pm_runtime_put_noidle(exynos_rng->dev);
>>> +	pm_runtime_get_sync(exynos_rng->dev);
>> This looks very odd. Why are you calling pm_runtime_put_noidle()?
>>
>
> When this callback function is called, the status of power state is
> 'suspended' and use_count is 1. To perform pm_runtime_get_sync()
> correctly, it requires to have 'suspended' status and use_count is 0.
> Thus i force to decrease use_count only with using
> pm_runtime_put_noidle. I know it looks odd, but i couldn't find better
> way. Otherwise it can use clk_enable() directly, but i think that it
> isn't good neither.

Is the device suspended initially at probe? If so can you set the state
of the device to suspended?

>
>>> +{
>>> +	int ret;
>>> +	struct exynos_rng *exynos_rng;
>>> +	struct resource *res;
>>> +
>>> +	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
>>> +					GFP_KERNEL);
>>> +	if (!exynos_rng)
>>> +		return -ENOMEM;
>>> +
>>> +	exynos_rng->dev = &pdev->dev;
>>> +	exynos_rng->rng.name = "exynos";
>>> +	exynos_rng->rng.init =	exynos_init;
>>> +	exynos_rng->rng.read = exynos_read;
>>> +	exynos_rng->clk = clk_get(NULL, "secss");
>> Can you please pass &pdev->dev to clk_get()?
>>
>
> But, this clock is not only used in PRNG. Should i put it in?

Why would that matter? I'm not familiar with the samsung clock
implementation but I would assume that something like clkdev is being
used. Ideally you would have one lookup entry per struct device that
uses this clock and then tie each lookup entry to the same clock. This
allows you to support multiple instances of the same device in a generic
way (e.g. two rng devices that use different clocks but from the driver
perspective they have the same name 'secss').

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

