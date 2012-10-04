Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2JDTRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:17:47 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:16023 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755821Ab2JDTRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:17:46 -0400
Message-ID: <1349378262.2817.25.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 02/11] net: axienet: Add ioctl support
From: Ben Hutchings <bhutchings@solarflare.com>
To: Michal Simek <monstr@monstr.eu>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 4 Oct 2012 20:17:42 +0100
In-Reply-To: <1349374497-9540-2-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
	 <1349374497-9540-2-git-send-email-monstr@monstr.eu>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
> Allow user to access the MDIO from userspace.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Anirudha Sarangi <anirudh@xilinx.com>
> CC: John Linn <John.Linn@xilinx.com>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 50167ab..a5b41cd 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1053,6 +1053,20 @@ static void axienet_poll_controller(struct net_device *ndev)
>  }
>  #endif
>  
> +/* Ioctl MII Interface */
> +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> +{
> +	struct axienet_local *priv = netdev_priv(dev);
> +
> +	if (!netif_running(dev))
> +		return -EINVAL;

Not sure this is the appropriate error code.

> +	if (!priv->phy_dev)
> +		return -ENODEV;

Error code should be EOPNOTSUPP - the device is present but just doesn't
support MDIO.

Ben.

> +	return phy_mii_ioctl(priv->phy_dev, rq, cmd);
> +}
> +
>  static const struct net_device_ops axienet_netdev_ops = {
>  	.ndo_open = axienet_open,
>  	.ndo_stop = axienet_stop,
> @@ -1061,6 +1075,7 @@ static const struct net_device_ops axienet_netdev_ops = {
>  	.ndo_set_mac_address = netdev_set_mac_address,
>  	.ndo_validate_addr = eth_validate_addr,
>  	.ndo_set_rx_mode = axienet_set_multicast_list,
> +	.ndo_do_ioctl = axienet_ioctl,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller = axienet_poll_controller,
>  #endif

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

