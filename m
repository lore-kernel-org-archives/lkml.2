Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1LGNPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:15:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36046 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1LGNPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:15:44 -0500
X-SpamScore: -5
X-BigFish: VS-5(z37d4lzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 21:28:29 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: fix the
 .remove code
Message-ID: <20111207132828.GQ5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <04c11563fee748562d7b53d5e5b3c5cf37fef200.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <04c11563fee748562d7b53d5e5b3c5cf37fef200.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:15AM +0100, Lothar Waﬂmann wrote:
> The .remove code is broken in several ways.
>  - mdiobus_unregister() is called twice for the same object in case of dual FEC
>  - phy_disconnect() is being called when the PHY is already disconnected
>  - the requested IRQ(s) are not freed
>  - fec_stop() is being called with the inteface already stopped
> 
>  All of those lead to kernel crashes if the remove function is actually used.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  drivers/net/ethernet/freescale/fec.c |   30 +++++++++++++++++++++---------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> index ab0afb5..70ec7ec 100644
> --- a/drivers/net/ethernet/freescale/fec.c
> +++ b/drivers/net/ethernet/freescale/fec.c
> @@ -235,6 +235,7 @@ struct fec_enet_private {
>  
>  	/* Phylib and MDIO interface */
>  	struct	mii_bus *mii_bus;
> +	int	mii_cnt;
>  	struct	phy_device *phy_dev;
>  	int	mii_timeout;
>  	uint	phy_speed;
> @@ -1040,8 +1041,12 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	 */
>  	if ((id_entry->driver_data & FEC_QUIRK_ENET_MAC) && pdev->id > 0) {
>  		/* fec1 uses fec0 mii_bus */
> -		fep->mii_bus = fec0_mii_bus;
> -		return 0;
> +		if (fep->mii_cnt && fec0_mii_bus) {

This seems broken.  The second fec has its own fep and fep->mii_cnt is
always 0 here.

Regards,
Shawn

> +			fep->mii_bus = fec0_mii_bus;
> +			fep->mii_cnt++;
> +			return 0;
> +		}
> +		return -ENOENT;
>  	}
>  
>  	fep->mii_timeout = 0;
> @@ -1086,6 +1091,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	if (mdiobus_register(fep->mii_bus))
>  		goto err_out_free_mdio_irq;
>  
> +	fep->mii_cnt++;
> +
>  	/* save fec0 mii_bus */
>  	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC)
>  		fec0_mii_bus = fep->mii_bus;
> @@ -1102,11 +1109,11 @@ err_out:
>  
>  static void fec_enet_mii_remove(struct fec_enet_private *fep)
>  {
> -	if (fep->phy_dev)
> -		phy_disconnect(fep->phy_dev);
> -	mdiobus_unregister(fep->mii_bus);
> -	kfree(fep->mii_bus->irq);
> -	mdiobus_free(fep->mii_bus);
> +	if (--fep->mii_cnt == 0) {
> +		mdiobus_unregister(fep->mii_bus);
> +		kfree(fep->mii_bus->irq);
> +		mdiobus_free(fep->mii_bus);
> +	}
>  }
>  
>  static int fec_enet_get_settings(struct net_device *ndev,
> @@ -1646,13 +1653,18 @@ fec_drv_remove(struct platform_device *pdev)
>  	struct net_device *ndev = platform_get_drvdata(pdev);
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct resource *r;
> +	int i;
>  
> -	fec_stop(ndev);
> +	unregister_netdev(ndev);
>  	fec_enet_mii_remove(fep);
> +	for (i = 0; i < FEC_IRQ_NUM; i++) {
> +		int irq = platform_get_irq(pdev, i);
> +		if (irq > 0)
> +			free_irq(irq, ndev);
> +	}
>  	clk_disable(fep->clk);
>  	clk_put(fep->clk);
>  	iounmap(fep->hwp);
> -	unregister_netdev(ndev);
>  	free_netdev(ndev);
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -- 
> 1.5.6.5

