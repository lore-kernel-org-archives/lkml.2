Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2LMI4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:56:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18630 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2LMI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:56:35 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-2b-50c99841e08b
Message-id: <50C99839.1040803@samsung.com>
Date: Thu, 13 Dec 2012 09:56:25 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Moll <pawel.moll@arm.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH RFC/RFT] regulator: core: Fix continuous_voltage_range case
 in regulator_can_change_voltage
References: <1355275366.11924.2.camel@phoenix>
In-reply-to: <1355275366.11924.2.camel@phoenix>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4FV3HGScDDLrPClpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MQ6s/shc08FZs2bmSrYHxDFcXIyeHhICJxI4l65ggbDGJC/fW
	s3UxcnEICSxllHj5cC2Us4RJYuuSdnaQKl4BLYmnh28yg9gsAqoSv1qngNlsAoYSXW+72EBs
	UQFfiWm/rjFB1AtK/Jh8jwXEFhFQklh1/zILyFBmgSuMEifXnAQaysEhLFAoMe+HJUiNkICe
	RNv3SWD1nAL6ElMvb2MFsZkFzCQetaxjhrDlJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGpp
	ckFxUnquoV5xYm5xaV66XnJ+7iZGSAh+2cG4+JjVIUYBDkYlHt6C8JMBQqyJZcWVuYcYJTiY
	lUR4WyYBhXhTEiurUovy44tKc1KLDzEycXBKNTCun2p53OqdoNVF0bAL02MsJeflWeyRi99Q
	+Lz9l2tx/iXn2m9tPdqPZrMfsbtz9639gtS63L2f2T5uOKGTH/0nduPeWQK7055WvJKMUODf
	+Yp32vFXhdESK8xvFuczfb13Xbli5xaVCak2AsV9Veu9FpbsvLB7yfw52b/Fcl8uOe1hNSv6
	9erjSizFGYmGWsxFxYkAS4F8Ph8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/12/2012 2:22 AM, Axel Lin wrote:
> Regulator drivers with continuous_voltage_range flag set allows not setting
> n_voltages. Thus if continuous_voltage_range is set, check the constraint range
> instead.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/core.c |   12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 0f65b24..d7448ad 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1885,9 +1885,15 @@ int regulator_can_change_voltage(struct regulator *regulator)
>   	struct regulator_dev	*rdev = regulator->rdev;
>
>   	if (rdev->constraints &&
> -	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
> -	    (rdev->desc->n_voltages - rdev->desc->linear_min_sel) > 1)
> -		return 1;
> +	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
> +		if (rdev->desc->n_voltages - rdev->desc->linear_min_sel > 1)
> +			return 1;
> +
> +		if (rdev->desc->continuous_voltage_range &&
> +		    rdev->constraints->min_uV && rdev->constraints->max_uV &&
> +		    rdev->constraints->min_uV != rdev->constraints->max_uV)
> +			return 1;
> +	}
>
>   	return 0;
>   }
>

This change looks reasonable, I've missed the fact that there is a
support for regulators with continuous voltage range. This change also
shows that the n_voltages based workaround used earlier by mmc core was
indeed only a hack and regulator_can_change_voltage() approach is much
cleaner solution.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

