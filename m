Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2F1AU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:20:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59024 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab2F1AUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:20:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fcc6d000003a7a-ea-4feba360ce9c
Message-id: <4FEBA35F.1050505@samsung.com>
Date: Thu, 28 Jun 2012 09:20:47 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number generator
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
 <4FEB486C.7000408@codeaurora.org>
In-reply-to: <4FEB486C.7000408@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd2Exa/9Da4esrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZD1tOMhbskqj4fug4ewPjDuEuRk4OCQETiY87m9ggbDGJC/fW
	A9lcHEIC0xklrv9/zQKS4BUQlPgx+R6QzcHBLCAvceRSNkiYWUBdYtK8RcwQ9V1MEpf7ZzNC
	1GtJbJywhRnEZhFQlTg48RvYHDYBOYm3Td8YQeaICkRI/OrnAAmLAM35vuMk2F5mgW4mid2/
	t4DNERbwl1i59QxYvZBAjkTTlVyQMKeAnsSj5T2sExgFZiG5bhbCdbOQXLeAkXkVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnDwPZPewbiqweIQowAHoxIP74WZr/2FWBPLiitzDzFKcDAr
	ifB+jwMK8aYkVlalFuXHF5XmpBYfYpTmYFES522yvuAvJJCeWJKanZpakFoEk2Xi4JRqYFQT
	kL7dEnhl2YWJ7Kzd4gnrJJW1Lm3k27Rx9pbSDb39C0M/h13aFHphdnS429U5GQ5HX5lFyVu4
	aN16pbAn/HRtqpWe2NTFldJRRnObeOMXPi5T1JdTE/nlU2vE2K4bfyRz18ajZ2bcje71aROY
	W5a69/z3PbvXyjqWry5cePOVpHcOT75yuRJLcUaioRZzUXEiAC2iHGQ6AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 06월 28일 02:52, Stephen Boyd wrote:

> Some minor comments, otherwise this looks much better than the previous
> patch.
> 
> On 06/27/12 03:31, Jonghwa Lee wrote:
>> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
>> 5 random number outputs. Module is excuted under runtime power management control,
>> so it activates only while it's in use. Otherwise it will be suspended generally.
>> It was tested on PQ board by rngtest program.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This is an incorrect signoff chain. Kyungmin is not sending this so why
> are you not the last one to sign off? Who is the author, Kyungmin or
> yourself?
> 


I'm author. Okay, I'll leave my name only.

>> +
>> +config HW_RANDOM_EXYNOS
>> +	tristate "EXYNOS HW random number generator support"
>> +	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME
> 
> There is no need to depend on PM_RUNTIME or ARCH_EXYNOS.
> 
>> +
>> +static int exynos_read(struct hwrng *rng, void *buf,
>> +					size_t max, bool wait)
>> +{
>> +	struct exynos_rng *exynos_rng = container_of(rng,
>> +						struct exynos_rng, rng);
>> +	u32 *data = buf;
>> +
>> +	pm_runtime_get_sync(exynos_rng->dev);
>> +
>> +	exynos_rng_writel(exynos_rng, PRNG_START, 0);
>> +
>> +	do {
>> +		cpu_relax();
>> +	} while (!(exynos_rng_readl(exynos_rng,
>> +			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE));
>> +
>> +	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
> 
> Curious, is this actually required? You poll for the status to say done
> and the hardware requires you to write back the done bit after it
> signals done?
> 


Yes, It's hardware's own characteristic. It needs to be written 1 on
status register to clear it.

>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		clk_put(exynos_rng->clk);
>> +		return -ENODEV;
>> +	}
> 
> Pass this through directly to devm_request_and_ioremap() without
> checking the return value to save some lines.
> 

>> +

>> +	exynos_rng->mem = devm_request_and_ioremap(&pdev->dev, res);
>> +	if (!exynos_rng->mem) {
>> +		dev_err(&pdev->dev, "Ioremap failed.\n");
> 
> devm_request_and_ioremap() already prints a message on failure to remap
> so this is unnecessary printk.
> 

>> +		return -EBUSY;

>> +	}
>> +
>> +	platform_set_drvdata(pdev, exynos_rng);
>> +
>> +	pm_runtime_enable(&pdev->dev);
>> +
>> +	ret = hwrng_register(&exynos_rng->rng);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
> 
> Why not just 'return hwrng_register()'?
> 

>> +

>> +static int exynos_rng_runtime_resume(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
>> +
>> +	clk_prepare_enable(exynos_rng->clk);
>> +	return 0;
> 
> Perhaps return the value of clk_prepare_enable() in case it fails for
> some reason?
> 


Okay, I agree with your opinion all.

Thanks.
