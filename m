Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1BJJia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:38:30 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:31941
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752745Ab1BJJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:38:28 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275bh8275dhz2dh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Date: Thu, 10 Feb 2011 17:37:57 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect
 enable/prepare semantics
Message-ID: <20110210093756.GA24710@b20223-02.ap.freescale.net>
References: <1297233693.241680.897691111624.0.gpush@pororo>
 <1297233693.243373.411051105619.3.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1297233693.243373.411051105619.3.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Wed, Feb 09, 2011 at 02:41:33PM +0800, Jeremy Kerr wrote:
> This change adds warnings to check for:
> 
>  1) enabling a clock that hasn't been prepared; and
> 
>  2) unpreparing a clock that is still enabled
> 
> While the correctness can't be guaranteed, the warnings should cover
> most situations, and won't indicate false positives.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  drivers/clk/clk.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index bbbdb0d..8c96623 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -29,6 +29,8 @@ EXPORT_SYMBOL_GPL(clk_prepare);
>  
>  void clk_unprepare(struct clk *clk)
>  {
> +	WARN_ON(clk->enable_count != 0);
> +
Other drivers may be using the clock and increased the enable_count.
This check may be moved to where we actually do unprepare.

Thanks
Richard
>  	mutex_lock(&clk->prepare_lock);
>  
>  	WARN_ON(clk->prepare_count == 0);
> @@ -45,6 +47,8 @@ int clk_enable(struct clk *clk)
>  	unsigned long flags;
>  	int ret = 0;
>  
> +	WARN_ON(clk->prepare_count == 0);
> +
>  	spin_lock_irqsave(&clk->enable_lock, flags);
>  	if (clk->enable_count == 0 && clk->ops->enable)
>  		ret = clk->ops->enable(clk);
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

