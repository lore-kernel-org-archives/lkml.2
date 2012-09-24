Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab2IXWhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:37:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53258 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2IXWh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:37:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="240612422"
Message-ID: <5060E0A7.7090409@codeaurora.org>
Date: Mon, 24 Sep 2012 15:37:27 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/10] ARM: msm: Remove custom clk_set_{max,min}_rate()
 API
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-7-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1348194419-11486-7-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 07:26 PM, Stephen Boyd wrote:
> There are no users of this API anymore so let's just remove it.
> If a need arises in the future we can extend the common clock API
> to handle it.
>
> Cc: Saravana Kannan<skannan@codeaurora.org>
> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
> ---
>   arch/arm/mach-msm/clock-debug.c      |  9 +--------
>   arch/arm/mach-msm/clock.c            | 12 ------------
>   arch/arm/mach-msm/include/mach/clk.h |  6 ------
>   3 files changed, 1 insertion(+), 26 deletions(-)
>
> diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
> index 4886404..c4b34d7 100644
> --- a/arch/arm/mach-msm/clock-debug.c
> +++ b/arch/arm/mach-msm/clock-debug.c
> @@ -25,14 +25,7 @@ static int clock_debug_rate_set(void *data, u64 val)
>   	struct clk *clock = data;
>   	int ret;
>
> -	/* Only increases to max rate will succeed, but that's actually good
> -	 * for debugging purposes so we don't check for error. */
> -	if (clock->flags&  CLK_MAX)
> -		clk_set_max_rate(clock, val);
> -	if (clock->flags&  CLK_MIN)
> -		ret = clk_set_min_rate(clock, val);
> -	else
> -		ret = clk_set_rate(clock, val);
> +	ret = clk_set_rate(clock, val);

This was done to handle the difference in behavior of the remote 
processor on a per clock basis, but I agree that it's best to remove it 
now and added it back later if needed. And even if it's needed, I don't 
anticipate the need for changes to the common clock framework to deal 
with this.

Acked-by: Saravana Kannan <skannan@codeaurora.org>

-Saravana

>   	if (ret != 0)
>   		printk(KERN_ERR "clk_set%s_rate failed (%d)\n",
>   			(clock->flags&  CLK_MIN) ? "_min" : "", ret);
> diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
> index 5fac2df..8d07b25 100644
> --- a/arch/arm/mach-msm/clock.c
> +++ b/arch/arm/mach-msm/clock.c
> @@ -97,18 +97,6 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
>   }
>   EXPORT_SYMBOL(clk_round_rate);
>
> -int clk_set_min_rate(struct clk *clk, unsigned long rate)
> -{
> -	return clk->ops->set_min_rate(clk->id, rate);
> -}
> -EXPORT_SYMBOL(clk_set_min_rate);
> -
> -int clk_set_max_rate(struct clk *clk, unsigned long rate)
> -{
> -	return clk->ops->set_max_rate(clk->id, rate);
> -}
> -EXPORT_SYMBOL(clk_set_max_rate);
> -
>   int clk_set_parent(struct clk *clk, struct clk *parent)
>   {
>   	return -ENOSYS;
> diff --git a/arch/arm/mach-msm/include/mach/clk.h b/arch/arm/mach-msm/include/mach/clk.h
> index 5f1c37d..fd4f4a7 100644
> --- a/arch/arm/mach-msm/include/mach/clk.h
> +++ b/arch/arm/mach-msm/include/mach/clk.h
> @@ -25,12 +25,6 @@ enum clk_reset_action {
>
>   struct clk;
>
> -/* Rate is minimum clock rate in Hz */
> -int clk_set_min_rate(struct clk *clk, unsigned long rate);
> -
> -/* Rate is maximum clock rate in Hz */
> -int clk_set_max_rate(struct clk *clk, unsigned long rate);
> -
>   /* Assert/Deassert reset to a hardware block associated with a clock */
>   int clk_reset(struct clk *clk, enum clk_reset_action action);
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
