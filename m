Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2IDOZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:25:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2IDOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:25:08 -0400
Date: Tue, 4 Sep 2012 22:25:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        rob.herring@calxeda.com, pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        viresh.kumar@linaro.org, rnayak@ti.com, paul@pwsan.com,
        broonie@opensource.wolfsonmicro.com, ccross@android.com,
        linux-arm-kernel@lists.infradead.org, myungjoo.ham@samsung.com,
        rajagopal.venkat@linaro.org
Subject: Re: [PATCH v2 1/4] [RFC] clk: new locking scheme for reentrancy
Message-ID: <20120904142502.GL2362@S2101-09.ap.freescale.net>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
 <1345074214-17531-2-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345074214-17531-2-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:43:31PM -0700, Mike Turquette wrote:
> +void __clk_unprepare(struct clk *clk, struct clk *top)
> +{
>  	if (clk->ops->unprepare)
>  		clk->ops->unprepare(clk->hw);
>  
> -	__clk_unprepare(clk->parent);
> +	if (clk != top)
> +		__clk_unprepare(clk->parent, top);
> +}

The __clk_unprepare does not match the __clk_prepare below in terms of
if we should call clk->ops->prepare/unprepare on top clock.

I have to change __clk_unprepare to something like the below to get
the series work on imx6q.

 void __clk_unprepare(struct clk *clk, struct clk *top)
 {
+       if (clk == top)
+               return;
+
        if (clk->ops->unprepare)
                clk->ops->unprepare(clk->hw);

-       if (clk != top)
-               __clk_unprepare(clk->parent, top);
+       __clk_unprepare(clk->parent, top);
 }

> +int __clk_prepare(struct clk *clk, struct clk *top)
> +{
> +	int ret = 0;
> +
> +	if (clk != top) {
> +		ret = __clk_prepare(clk->parent, top);
>  		if (ret)
>  			return ret;
>  
>  		if (clk->ops->prepare) {
>  			ret = clk->ops->prepare(clk->hw);
>  			if (ret) {
> -				__clk_unprepare(clk->parent);
> +				/* this is safe since clk != top */
> +				__clk_unprepare(clk->parent, top);
>  				return ret;
>  			}
>  		}
>  	}
>  
> -	clk->prepare_count++;
> -
>  	return 0;
>  }

-- 
Regards,
Shawn
