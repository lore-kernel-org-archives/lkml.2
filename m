Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab2DLGTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:19:41 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51835 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049Ab2DLGTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:19:40 -0400
Message-ID: <4F86738A.10802@st.com>
Date: Thu, 12 Apr 2012 11:47:46 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH 04/13] clk: core: enforce clk_ops consistency
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-5-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-5-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> Documentation/clk.txt has some handsome ASCII art outlining which
> clk_ops are mandatory for a given clock, given the capability of the
> hardware.  Enforce those mandates with sanity checks in __clk_init.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/clk/clk.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index d83a9e0..9924aec 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1202,6 +1202,20 @@ void __clk_init(struct device *dev, struct clk *clk)
>  	if (__clk_lookup(clk->name))
>  		goto out;
>  
> +	/* check that clk_ops are sane.  See Documentation/clk.txt */
> +	if (clk->ops->set_rate &&
> +			!(clk->ops->round_rate && clk->ops->recalc_rate)) {
> +		pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
> +				__func__, clk->name);
> +		goto out;
> +	}
> +
> +	if (clk->ops->set_parent && !clk->ops->get_parent) {
> +		pr_warning("%s: %s must implement .get_parent & .set_parent\n",
> +				__func__, clk->name);
> +		goto out;
> +	}
> +
>  	/* throw a WARN if any entries in parent_names are NULL */
>  	for (i = 0; i < clk->num_parents; i++)
>  		WARN(!clk->parent_names[i],

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
