Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2HWWQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:16:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2HWWQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:16:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH 2/2] devfreq: exynos4: Support initialization of freq_table and max_state of devfreq's profile.
Date: Fri, 24 Aug 2012 00:22:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>,
        Xiaoguang Chen <chenxg@marvell.com>
References: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com> <1345099767-13467-3-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1345099767-13467-3-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208240022.04846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 16, 2012, Jonghwa Lee wrote:
> This patch initializes freq_table and max_state of devfreq's profile.
> They will be used for creating transition table.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Does that depend on [1/2]?

Rafael


> ---
>  drivers/devfreq/exynos4_bus.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 88ddc77..9c08855 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -985,7 +985,8 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>  	struct busfreq_data *data;
>  	struct opp *opp;
>  	struct device *dev = &pdev->dev;
> -	int err = 0;
> +	int err = 0, i;
> +	unsigned int *freq_table;
>  
>  	data = kzalloc(sizeof(struct busfreq_data), GFP_KERNEL);
>  	if (data == NULL) {
> @@ -1042,6 +1043,33 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, data);
>  
> +	switch (data->type) {
> +	case TYPE_BUSF_EXYNOS4210:
> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4210_LV_NUM,
> +					GFP_KERNEL);
> +
> +		for (i = 0; i < EX4210_LV_NUM; i++)
> +			freq_table[i] = exynos4210_busclk_table[i].clk;
> +
> +		exynos4_devfreq_profile.max_state = EX4210_LV_NUM;
> +		break;
> +	case TYPE_BUSF_EXYNOS4x12:
> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4x12_LV_NUM,
> +					GFP_KERNEL);
> +
> +		for (i = 0; i < EX4x12_LV_NUM; i++)
> +			freq_table[i] = exynos4x12_mifclk_table[i].clk;
> +
> +		exynos4_devfreq_profile.max_state = EX4x12_LV_NUM;
> +		break;
> +	default:
> +		dev_err(dev, "Cannot determine the device id %d\n", data->type);
> +		err = -EINVAL;
> +		goto err_opp_add;
> +	}
> +
> +	exynos4_devfreq_profile.freq_table = freq_table;
> +
>  	busfreq_mon_reset(data);
>  
>  	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
> 

