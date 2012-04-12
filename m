Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057Ab2DLGtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:49:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44613 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762026Ab2DLGth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:49:37 -0400
Date: Thu, 12 Apr 2012 14:49:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Viresh Kumar <viresh.kumar@st.com>, Rajendra Nayak <rnayak@ti.com>,
        patches@linaro.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
Message-ID: <20120412064920.GH2445@S2101-09.ap.freescale.net>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-14-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-14-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:02:51PM -0700, Mike Turquette wrote:
...
> @@ -175,23 +188,32 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>  	div->flags = clk_divider_flags;
>  	div->lock = lock;
>  
> +	/* allocate the temporary parent_names */
>  	if (parent_name) {
> -		div->parent[0] = kstrdup(parent_name, GFP_KERNEL);
> -		if (!div->parent[0])
> -			goto out;
> +		parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
> +		if (!parent_names[0]) {
> +			pr_err("%s: could not allocate parent_names\n",
> +					__func__);
> +			goto fail_parent_names;
> +		}
>  	}

Why do we need to copy the parent_names here at all?  clk_register()
has done that for each basic clk.

Regards,
Shawn

>  
> +	/* register the clock */
>  	clk = clk_register(dev, name,
>  			&clk_divider_ops, &div->hw,
> -			div->parent,
> +			(parent_name ? parent_names: NULL),
>  			(parent_name ? 1 : 0),
>  			flags);
> -	if (clk)
> -		return clk;
>  
> -out:
> -	kfree(div->parent[0]);
> -	kfree(div);
> +	/* free the temporary parent_names */
> +	if (parent_name)
> +		kfree(parent_names[0]);
> +
> +	if (!IS_ERR(clk))
> +		goto out;
>  
> -	return NULL;
> +fail_parent_names:
> +	kfree(div);
> +out:
> +	return clk;
>  }
