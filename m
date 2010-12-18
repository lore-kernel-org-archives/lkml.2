Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0LRQrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:47:20 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:47315 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0LRQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:47:19 -0500
Subject: Re: [PATCH 1/2] net: phy: balance disable/enable irq on change
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: davem@davemloft.net, richard.cochran@omicron.at, shemminger@vyatta.com,
        tj@kernel.org, randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292687723-31981-1-git-send-email-jhautbois@gmail.com>
References: <1292687723-31981-1-git-send-email-jhautbois@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sat, 18 Dec 2010 16:47:12 +0000
Message-ID: <1292690832.6533.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2010 16:47:18.0891 (UTC) FILETIME=[3BCF23B0:01CB9ED3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17836.005
X-TM-AS-Result: No--18.369700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 16:55 +0100, Jean-Michel Hautbois wrote:
> When phy interface changes its status, it calls phy_change() function.
> This function calls the interrupt disabling functions for the driver registered, but if this driver doesn't implement it, there is no IRQ disabling. After doing the work, we call enable_irq and not the respective driver function. This fixes it, as it could lead to an unbalanced IRQ.
> 
> Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
> ---
>  drivers/net/phy/phy.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 7670aac..b28f2ac 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -89,7 +89,8 @@ static int phy_config_interrupt(struct phy_device *phydev, u32 interrupts)
>  	phydev->interrupts = interrupts;
>  	if (phydev->drv->config_intr)
>  		err = phydev->drv->config_intr(phydev);
> -
> +	else
> +		err = -ENOSYS;
[...]

ENOSYS means missing system call.  Perhaps EOPNOTSUPP is the appropriate
error code.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

