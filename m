Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1JYQ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:26:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44415 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375Ab1JYQ0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:26:10 -0400
Message-ID: <1319559968.14932.5.camel@Joe-Laptop>
Subject: Re: [PATCH] arm/tegra: clk_get should not be fatal
From: Joe Perches <joe@perches.com>
To: pdeschrijver@nvidia.com
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Oct 2011 09:26:08 -0700
In-Reply-To: <1319559329-324-1-git-send-email-pdeschrijver@nvidia.com>
References: <1319559329-324-1-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 19:15 +0300, pdeschrijver@nvidia.com wrote:
> The timer and rtc-timer clocks aren't gated by default, so there is no reason
> to crash the system if the dummy enable call failed.
[]
> diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
[]
> @@ -186,16 +186,20 @@ static void __init tegra_init_timer(void)
>  	int ret;
>  
>  	clk = clk_get_sys("timer", NULL);
> -	BUG_ON(IS_ERR(clk));
> -	clk_enable(clk);
> +	if (IS_ERR(clk))
> +		pr_warning("Unable to get timer clock");
> +	else
> +		clk_enable(clk);
>  
>  	/*
>  	 * rtc registers are used by read_persistent_clock, keep the rtc clock
>  	 * enabled
>  	 */
>  	clk = clk_get_sys("rtc-tegra", NULL);
> -	BUG_ON(IS_ERR(clk));
> -	clk_enable(clk);
> +	if (IS_ERR(clk))
> +		pr_warning("Unable to get rtc-tegra clock");
> +	else
> +		clk_enable(clk);

Are these messages are really necessary?
Maybe just:
	if (!IS_ERR(clk))
		clk_enable(clk)

If these are really necessary, please use
	pr_warn("Unable to get <foo>\n");
pr_warn and with a terminating newline.

