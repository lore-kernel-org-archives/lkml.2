Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1BJXXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:23:36 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:18319 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757240Ab1BJXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:23:35 -0500
Message-ID: <4D54738C.80900@bluewatersys.com>
Date: Fri, 11 Feb 2011 12:23:56 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
References: <1297233693.242725.820672531799.2.gpush@pororo>
In-Reply-To: <1297233693.242725.820672531799.2.gpush@pororo>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 07:41 PM, Jeremy Kerr wrote:
> Since most platforms will need a fixed-rate clock, add one. This will
> also serve as a basic example of an implementation of struct clk.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  drivers/clk/clk.c   |   14 ++++++++++++++
>  include/linux/clk.h |   16 ++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index c35478a..bbbdb0d 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -124,3 +124,17 @@ void __clk_put(struct clk *clk)
>  	if (clk->ops->put)
>  		clk->ops->put(clk);
>  }
> +
> +/* clk_fixed support */
> +
> +#define to_clk_fixed(clk) (container_of(clk, struct clk_fixed, clk))
> +
> +static unsigned long clk_fixed_get_rate(struct clk *clk)
> +{
> +	return to_clk_fixed(clk)->rate;
> +}
> +
> +struct clk_ops clk_fixed_ops = {
> +	.get_rate = clk_fixed_get_rate,
> +};
> +EXPORT_SYMBOL_GPL(clk_fixed_ops);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index fe806b7..e67fdb0 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -185,6 +185,22 @@ static inline void clk_common_init(struct clk *clk)
>  	mutex_init(&clk->prepare_lock);
>  }
>  
> +/* Simple fixed-rate clock */
> +struct clk_fixed {
> +	struct clk	clk;
> +	unsigned long	rate;
> +};
> +
> +extern struct clk_ops clk_fixed_ops;
> +
> +#define INIT_CLK_FIXED(name, r) { \
> +	.clk = INIT_CLK(name.clk, clk_fixed_ops), \
> +	.rate = (r) \
> +}

A fixed clock may still have other operations such as enable/disable.
Maybe do something like this instead:

#define INIT_CLK_FIXED(name, ops, r) { 		\
	.clk = INIT_CLK(name.clk, ops, rate), 	\
	.clk.ops.get_rate = clk_fixed_get_rate, \
	.rate = (r),				\
}

That's untested though. I'm not sure if you can reliably assign
something twice in a struct initialiser?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
