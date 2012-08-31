Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2HaT30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:29:26 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:54086 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab2HaT3Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:29:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ulf Hansson <ulf.hansson@stericsson.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
 <1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
Message-ID: <20120831192906.31162.97714@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 1/4] clk: Provide option for clk_get_rate to issue hw for new rate
Date: Fri, 31 Aug 2012 12:29:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ulf Hansson (2012-08-31 05:21:28)
> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> By using CLK_GET_RATE_NOCACHE flag, we tell the clk_get_rate API to
> issue the hw for an updated clock rate. This can be used for a clock
> which rate may be updated without a client necessary modifying it.
> 

I'm glad to see this.  We discussed whether the default behavior should
be cached or from the hardware at length some time back, so having a
flag to support the non-default is great.

> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/clk/clk.c            |   43 +++++++++++++++++++++++-------------------
>  include/linux/clk-provider.h |    1 +
>  2 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index efdfd00..d9cbae0 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -558,25 +558,6 @@ int clk_enable(struct clk *clk)
>  EXPORT_SYMBOL_GPL(clk_enable);
>  
>  /**
> - * clk_get_rate - return the rate of clk
> - * @clk: the clk whose rate is being returned
> - *
> - * Simply returns the cached rate of the clk.  Does not query the hardware.  If
> - * clk is NULL then returns 0.
> - */
> -unsigned long clk_get_rate(struct clk *clk)
> -{
> -       unsigned long rate;
> -
> -       mutex_lock(&prepare_lock);
> -       rate = __clk_get_rate(clk);
> -       mutex_unlock(&prepare_lock);
> -
> -       return rate;
> -}
> -EXPORT_SYMBOL_GPL(clk_get_rate);
> -
> -/**
>   * __clk_round_rate - round the given rate for a clk
>   * @clk: round the rate of this clock
>   *
> @@ -702,6 +683,30 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
>  }
>  
>  /**
> + * clk_get_rate - return the rate of clk
> + * @clk: the clk whose rate is being returned
> + *
> + * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
> + * is set, which means a recalc_rate will be issued.
> + * If clk is NULL then returns 0.
> + */
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +       unsigned long rate;
> +
> +       mutex_lock(&prepare_lock);
> +
> +       if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
> +               __clk_recalc_rates(clk, 0);

This is a bit subtle.  Calling __clk_recalc_rates will walk the subtree
of children recalculating rates as well as firing off notifiers.  Is
this what you want?  If your clock changes rates behind your back AND
has chilren then this is probably the right thing to do.  However you
might be better off with:

	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
		rate = clk->ops->recalc_rate(clk->hw, clk->parent->rate);

This doesn't update children or fire off notifiers.  What is best for
your platform?

Regards,
Mike

> +
> +       rate = __clk_get_rate(clk);
> +       mutex_unlock(&prepare_lock);
> +
> +       return rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_rate);
> +
> +/**
>   * __clk_speculate_rates
>   * @clk: first clk in the subtree
>   * @parent_rate: the "future" rate of clk's parent
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 77335fa..1b15307 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -26,6 +26,7 @@
>  #define CLK_IGNORE_UNUSED      BIT(3) /* do not gate even if unused */
>  #define CLK_IS_ROOT            BIT(4) /* root clk, has no parent */
>  #define CLK_IS_BASIC           BIT(5) /* Basic clk, can't do a to_clk_foo() */
> +#define CLK_GET_RATE_NOCACHE   BIT(6) /* do not use the cached clk rate */
>  
>  struct clk_hw;
>  
> -- 
> 1.7.10
