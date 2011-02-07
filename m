Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1BGIGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:06:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1BGIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:06:06 -0500
Date: Mon, 7 Feb 2011 09:05:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect
 enable/prepare semantics
Message-ID: <20110207080555.GC27982@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <1297058877.800990.238556019385.3.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297058877.800990.238556019385.3.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeremy,

On Mon, Feb 07, 2011 at 02:07:57PM +0800, Jeremy Kerr wrote:
> This change adds warnings to check for:
> 
>  1) enabling a clock that hasn't been prepared; and
> 
>  2) unpreparing a clock that is still enabled
> 
> While the correctness can't be guaranteed, these warnings should cover
> most situations.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  drivers/clk/clk.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 51dbd33..2369959 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -35,6 +35,8 @@ void clk_unprepare(struct clk *clk)
>  	if (!clk->ops->unprepare)
>  		return;
>  
> +	WARN_ON(clk->enable_count);
> +
>  	mutex_lock(&clk->prepare_lock);
>  	if (--clk->prepare_count == 0)
>  		clk->ops->unprepare(clk);
> @@ -50,6 +52,8 @@ int clk_enable(struct clk *clk)
>  	if (!clk->ops->enable)
>  		return 0;
>  
> +	WARN_ON(clk->ops->prepare && clk->prepare_count);
> +
This implies the warning is only issued on clocks that have a prepare
callback.  If we want to enforce the new API the warning here shouldn't
depend on clk->ops->prepare.  (clk_prepare and clk_unprepare need to
be changed then to adapt the prepare_count even in the absence of
clk->ops->prepare.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
