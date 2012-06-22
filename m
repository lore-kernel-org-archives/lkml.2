Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab2FVBjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:39:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29065 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760850Ab2FVBjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:39:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fcc6d000003a7a-50-4fe3cce2ce7f
Message-id: <4FE3CCE1.6010400@samsung.com>
Date: Fri, 22 Jun 2012 10:39:45 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
References: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com>
 <4FE26F27.4010106@codeaurora.org> <4FE2897C.6050002@samsung.com>
 <4FE2913B.1040102@codeaurora.org>
In-reply-to: <4FE2913B.1040102@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAd1HZx77G6w7KmZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy/j9tYymYJlTxbNZjxgbG03xdjJwcEgImEveONbBB2GISF+6t
	B7K5OIQEFjFKXDu2jwkkwSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i1ihqjvY5Jo7toE
	Va8l8fT7OlYQm0VAVaLjy2UWEJtNQE7ibdM3RpA5ogIREr/6OUDCIkBzvu84CbaXWaCbSWL3
	7y2MIAlhAR+JKev+s0AsWM8osXjKN7BBnAJ6EnOuvGaawCgwC8l9sxDum4XkvgWMzKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxggPwmfQOxlUNFocYBTgYlXh4cw899hdiTSwrrsw9xCjB
	wawkwtt7EijEm5JYWZValB9fVJqTWnyIUZqDRUmct8n6gr+QQHpiSWp2ampBahFMlomDU6qB
	Ub9Wg4HhDOMug+NBb9SfmCdoWfneqxNo9LQ1FPx+xns3y8K7vS/Tpp8Q4Pl19WOyE7P3ostL
	xcw53P7m9eR2KV7+dDxYn8Fbw2pSdfHudbJHOZKu5LyKO1L0ZbNep//u6TOOHE+5OPOQx2rh
	e5qsJu3vAt3Slju1B0owLfZjXeCk80A+5TCzEktxRqKhFnNRcSIAaIFp8TwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 06월 21일 12:12, Stephen Boyd wrote:

> On 06/20/12 19:39, jonghwa3.lee@samsung.com wrote:
>>
>>>> +static int exynos_init(struct hwrng *rng)
>>>> +{
>>>> +	struct exynos_rng *exynos_rng = container_of(rng,
>>>> +						struct exynos_rng, rng);
>>>> +	int i;
>>>> +	int ret = 0;
>>>> +	u32 PRND_SEED[5];
>>>> +
>>>> +	pm_runtime_put_noidle(exynos_rng->dev);
>>>> +	pm_runtime_get_sync(exynos_rng->dev);
>>> This looks very odd. Why are you calling pm_runtime_put_noidle()?
>>>
>>
>> When this callback function is called, the status of power state is
>> 'suspended' and use_count is 1. To perform pm_runtime_get_sync()
>> correctly, it requires to have 'suspended' status and use_count is 0.
>> Thus i force to decrease use_count only with using
>> pm_runtime_put_noidle. I know it looks odd, but i couldn't find better
>> way. Otherwise it can use clk_enable() directly, but i think that it
>> isn't good neither.
> 
> Is the device suspended initially at probe? If so can you set the state
> of the device to suspended?
> 


Yes, it suspended already at the initial of probing. But i can't get
your point, you want to me to make device suspended?

>>
>>>> +{
>>>> +	int ret;
>>>> +	struct exynos_rng *exynos_rng;
>>>> +	struct resource *res;
>>>> +
>>>> +	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
>>>> +					GFP_KERNEL);
>>>> +	if (!exynos_rng)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	exynos_rng->dev = &pdev->dev;
>>>> +	exynos_rng->rng.name = "exynos";
>>>> +	exynos_rng->rng.init =	exynos_init;
>>>> +	exynos_rng->rng.read = exynos_read;
>>>> +	exynos_rng->clk = clk_get(NULL, "secss");
>>> Can you please pass &pdev->dev to clk_get()?
>>>
>>
>> But, this clock is not only used in PRNG. Should i put it in?
> 
> Why would that matter? I'm not familiar with the samsung clock
> implementation but I would assume that something like clkdev is being
> used. Ideally you would have one lookup entry per struct device that
> uses this clock and then tie each lookup entry to the same clock. This
> allows you to support multiple instances of the same device in a generic
> way (e.g. two rng devices that use different clocks but from the driver
> perspective they have the same name 'secss').
> 


Okay, I see. I'll apply it.
