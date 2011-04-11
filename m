Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1DKCFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 22:05:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47868 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1DKCFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:05:37 -0400
Message-ID: <4DA261DA.2050404@oracle.com>
Date: Sun, 10 Apr 2011 19:05:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Pinkava <jiri.pinkava@vscht.cz>
CC: ben-linux@fluff.org, kgene.kim@samsung.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nand: Fix S3C NAND clock stop
References: <1302485262-8401-1-git-send-email-jiri.pinkava@vscht.cz>
In-Reply-To: <1302485262-8401-1-git-send-email-jiri.pinkava@vscht.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DA261D7.0018:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2011 6:27 PM, Jiri Pinkava wrote:
> Current implementation of s3c2410_nand_select_chip call
> clk_disable every time when chip = -1 (de-select). This happend
> multiple times even if chip was already de-selected. This causes
> disabling clock even if they are already disabled and due to
> nature of clock subsytem implementation this causes nand clock
> to be disabled and newer enabled again.
>
> Signed-off-by: Jiri Pinkava<jiri.pinkava@vscht.cz>
> ---
>   drivers/mtd/nand/s3c2410.c |   57 +++++++++++++++++++++++++++++++------------
>   1 files changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
> index 33d832d..79e18a3 100644
> --- a/drivers/mtd/nand/s3c2410.c
> +++ b/drivers/mtd/nand/s3c2410.c

> @@ -159,11 +165,33 @@ static struct s3c2410_platform_nand *to_nand_plat(struct platform_device *dev)
>   	return dev->dev.platform_data;
>   }
>
> -static inline int allow_clk_stop(struct s3c2410_nand_info *info)
> +static inline int allow_clk_suspend(struct s3c2410_nand_info *info)
>   {
>   	return clock_stop;
>   }
>
> +/**
> + * s3c2410_nand_clk_set_state - Enable, disable or suspend NAND clock.
> + * @info: The controller instance.
> + * @state: State to which clock should be set.

       @new_state:

> + */
> +static void s3c2410_nand_clk_set_state(struct s3c2410_nand_info *info,
> +		int new_state)
> +{
> +	if (!allow_clk_suspend(info)&&  new_state == CLOCK_SUSPEND)
> +		return;
> +
> +	if (clock_state == CLOCK_ENABLE) {
> +		if (new_state != CLOCK_ENABLE)
> +			clk_disable(info->clk);
> +	} else {
> +		if (new_state == CLOCK_ENABLE)
> +			clk_enable(info->clk);
> +	}
> +
> +	clock_state = new_state;
> +}

