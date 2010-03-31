Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab0CaI3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:29:06 -0400
Received: from stinky.trash.net ([213.144.137.162]:56897 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab0CaI3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:29:00 -0400
Message-ID: <4BB307CA.9080305@trash.net>
Date: Wed, 31 Mar 2010 10:28:58 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Anders Darander <anders.darander@gmail.com>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Erik Waling <erik.waling@konftel.com>,
       Anders Darander <ad@datarespons.se>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MACB: Set PHY address in kernel parameters
References: <1270021902-6556-1-git-send-email-anders.darander@gmail.com>
In-Reply-To: <1270021902-6556-1-git-send-email-anders.darander@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Darander wrote:
> From: Anders Darander <ad@datarespons.se>
> 
> Add the possibility to set the phy address. This is needed if an integrated
> switch is connected to the MAC, as it is often the case that the highest port
> is the one connected to the MAC of the MCU.
> 
> E.g. in the case of the Micrel KSZ8873, port 3 is the one to connect to the
> MCU, thus, the MAC needs to connect to phy address 0x03, instead of the first
> phy found.
> 
> Signed-off-by: Anders Darander <ad@datarespons.se>
> ---
>  drivers/net/macb.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macb.c b/drivers/net/macb.c
> index c8a18a6..9b4e301 100644
> --- a/drivers/net/macb.c
> +++ b/drivers/net/macb.c
> @@ -53,6 +53,14 @@
>  #define MACB_RX_INT_FLAGS	(MACB_BIT(RCOMP) | MACB_BIT(RXUBR)	\
>  				 | MACB_BIT(ISR_ROVR))
>  
> +/*
> + * Setup PHY probeing
> + */
> +
> +static int phy_addr = PHY_MAX_ADDR;
> +module_param(phy_addr, ushort, 0);
> +MODULE_PARAM_DESC(phy_addr, "PHY address connected to the MACB");
> +
>  static void __macb_set_hwaddr(struct macb *bp)
>  {
>  	u32 bottom;
> @@ -193,7 +201,11 @@ static int macb_mii_probe(struct net_device *dev)
>  	struct eth_platform_data *pdata;
>  	int ret;
>  
> -	phydev = phy_find_first(bp->mii_bus);
> +	if (phy_addr >= PHY_MAX_ADDRESS)
> +		phydev = phy_find_first(bp->mii_bus);
> +	else
> +		phydev = bp->mii_bus->phy_map[phy_addr];

This looks like you need to use an unsigned to avoid negative
indices.
