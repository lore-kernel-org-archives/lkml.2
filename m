Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1JRX3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:29:50 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:57276 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1JRX3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:29:48 -0400
Message-ID: <1318980570.23980.28.camel@deadeye>
Subject: Re: [RESEND] [PATCH] ll_temac: Add support for ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: davem@davemloft.net, grant.likely@secretlab.ca, sfr@canb.auug.org.au,
        u.kleine-koenig@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Oct 2011 00:29:30 +0100
In-Reply-To: <1318960501-3544-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318960501-3544-1-git-send-email-ricardo.ribalda@gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 18 Oct 2011 23:29:48.0178 (UTC) FILETIME=[D37BE720:01CC8DED]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18456.005
X-TM-AS-Result: No--10.104600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 19:55 +0200, Ricardo Ribalda Delgado wrote:
> This patch enables the ethtool interface. The implementation is done
> using the libphy helper functions.

All Ethernet drivers have been moved in net-next.  This driver is now
under drivers/net/ethernet/xilinx.

> Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/net/ll_temac_main.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
> index 728fe41..91a9804 100644
> --- a/drivers/net/ll_temac_main.c
> +++ b/drivers/net/ll_temac_main.c
> @@ -957,6 +957,32 @@ static const struct attribute_group temac_attr_group = {
>  	.attrs = temac_device_attrs,
>  };
>  
> +/* ethtool support */
> +static int temac_get_settings(struct net_device *ndev, struct ethtool_cmd *cmd)
> +{
> +	struct temac_local *lp = netdev_priv(ndev);
> +	return phy_ethtool_gset(lp->phy_dev, cmd);
> +}
> +
> +static int temac_set_settings(struct net_device *ndev, struct ethtool_cmd *cmd)
> +{
> +	struct temac_local *lp = netdev_priv(ndev);
> +	return phy_ethtool_sset(lp->phy_dev, cmd);
> +}
> +
> +static int temac_nway_reset(struct net_device *ndev)
> +{
> +	struct temac_local *lp = netdev_priv(ndev);
> +	return phy_start_aneg(lp->phy_dev);
> +}
> +
> +static const struct ethtool_ops temac_ethtool_ops = {
> +	.get_settings = temac_get_settings,
> +	.set_settings = temac_set_settings,
> +	.nway_reset = temac_nway_reset,
> +	.get_link = ethtool_op_get_link,
> +};
> +
>  static int __devinit temac_of_probe(struct platform_device *op)
>  {
>  	struct device_node *np;
> @@ -978,6 +1004,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
>  	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
>  	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
>  	ndev->netdev_ops = &temac_netdev_ops;
> +	ndev->ethtool_ops= &temac_ethtool_ops;

Missing space before '='.

Ben.

>  #if 0
>  	ndev->features |= NETIF_F_IP_CSUM; /* Can checksum TCP/UDP over IPv4. */
>  	ndev->features |= NETIF_F_HW_CSUM; /* Can checksum all the packets. */

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

