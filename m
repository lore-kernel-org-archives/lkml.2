Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2B2Nnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:43:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49181 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab2B2Nns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:43:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.92.227 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329466058-15969-1-git-send-email-dhdang@apm.com>
References: <1329466058-15969-1-git-send-email-dhdang@apm.com>
Date: Wed, 29 Feb 2012 08:43:46 -0500
Message-ID: <CA+5PVA5hciQSvfkodX-oP_kUZueiTp=0+t8X_0iHQ+ehU0ecOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/44x: Add more changes for APM821XX EMAC driver
From: Josh Boyer <jwboyer@gmail.com>
To: Duc Dang <dhdang@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 3:07 AM, Duc Dang <dhdang@apm.com> wrote:
> This patch includes:
>
>  Configure EMAC PHY clock source (clock from PHY or internal clock).
>
>  Do not advertise PHY half duplex capability as APM821XX EMAC does not
> support half duplex mode.
>
>  Add changes to support configuring jumbo frame for APM821XX EMAC.
>
> Signed-off-by: Duc Dang <dhdang@apm.com>

This should have been sent to netdev.  CC'ing them now.

Ben and David, I can take this change through the 4xx tree if it looks OK to
both of you.  The pre-requisite DTS patch will go through my tree, so it might
make sense to keep them together.

josh

> ---
>  drivers/net/ethernet/ibm/emac/core.c |   26 +++++++++++++++++++++++++-
>  drivers/net/ethernet/ibm/emac/core.h |   13 +++++++++++--
>  drivers/net/ethernet/ibm/emac/emac.h |    5 ++++-
>  3 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
> index ed79b2d..de620f1 100644
> --- a/drivers/net/ethernet/ibm/emac/core.c
> +++ b/drivers/net/ethernet/ibm/emac/core.c
> @@ -434,6 +434,11 @@ static inline u32 emac_iff2rmr(struct net_device *ndev)
>  	else if (!netdev_mc_empty(ndev))
>  		r |= EMAC_RMR_MAE;
>
> +	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE)) {
> +		r &= ~EMAC4_RMR_MJS_MASK;
> +		r |= EMAC4_RMR_MJS(ndev->mtu);
> +	}
> +
>  	return r;
>  }
>
> @@ -965,6 +970,7 @@ static int emac_resize_rx_ring(struct emac_instance *dev, int new_mtu)
>  	int rx_sync_size = emac_rx_sync_size(new_mtu);
>  	int rx_skb_size = emac_rx_skb_size(new_mtu);
>  	int i, ret = 0;
> +	int mr1_jumbo_bit_change = 0;
>
>  	mutex_lock(&dev->link_lock);
>  	emac_netif_stop(dev);
> @@ -1013,7 +1019,14 @@ static int emac_resize_rx_ring(struct emac_instance *dev, int new_mtu)
>  	}
>   skip:
>  	/* Check if we need to change "Jumbo" bit in MR1 */
> -	if ((new_mtu > ETH_DATA_LEN) ^ (dev->ndev->mtu > ETH_DATA_LEN)) {
> +	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE))
> +		mr1_jumbo_bit_change = (new_mtu > ETH_DATA_LEN) ||
> +				(dev->ndev->mtu > ETH_DATA_LEN);
> +	else
> +		mr1_jumbo_bit_change = (new_mtu > ETH_DATA_LEN) ^
> +				(dev->ndev->mtu > ETH_DATA_LEN);
> +
> +	if (mr1_jumbo_bit_change) {
>  		/* This is to prevent starting RX channel in emac_rx_enable() */
>  		set_bit(MAL_COMMAC_RX_STOPPED, &dev->commac.flags);
>
> @@ -2471,6 +2484,7 @@ static int __devinit emac_init_phy(struct emac_instance *dev)
>
>  	/* Disable any PHY features not supported by the platform */
>  	dev->phy.def->features &= ~dev->phy_feat_exc;
> +	dev->phy.features &= ~dev->phy_feat_exc;
>
>  	/* Setup initial link parameters */
>  	if (dev->phy.features & SUPPORTED_Autoneg) {
> @@ -2568,6 +2582,10 @@ static int __devinit emac_init_config(struct emac_instance *dev)
>  		if (of_device_is_compatible(np, "ibm,emac-405ex") ||
>  		    of_device_is_compatible(np, "ibm,emac-405exr"))
>  			dev->features |= EMAC_FTR_440EP_PHY_CLK_FIX;
> +		if (of_device_is_compatible(np, "ibm,emac-apm821xx"))
> +			dev->features |= (EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE
> +					| EMAC_FTR_APM821XX_NO_HALF_DUPLEX
> +					| EMAC_FTR_460EX_PHY_CLK_FIX);
>  	} else if (of_device_is_compatible(np, "ibm,emac4")) {
>  		dev->features |= EMAC_FTR_EMAC4;
>  		if (of_device_is_compatible(np, "ibm,emac-440gx"))
> @@ -2818,6 +2836,12 @@ static int __devinit emac_probe(struct platform_device *ofdev)
>  	dev->stop_timeout = STOP_TIMEOUT_100;
>  	INIT_DELAYED_WORK(&dev->link_work, emac_link_timer);
>
> +	/* Some SoCs like APM821xx does not support Half Duplex mode. */
> +	if (emac_has_feature(dev, EMAC_FTR_APM821XX_NO_HALF_DUPLEX))
> +		dev->phy_feat_exc = (SUPPORTED_1000baseT_Half
> +					| SUPPORTED_100baseT_Half
> +					| SUPPORTED_10baseT_Half);
> +
>  	/* Find PHY if any */
>  	err = emac_init_phy(dev);
>  	if (err != 0)
> diff --git a/drivers/net/ethernet/ibm/emac/core.h b/drivers/net/ethernet/ibm/emac/core.h
> index fa3ec57..9dea85a 100644
> --- a/drivers/net/ethernet/ibm/emac/core.h
> +++ b/drivers/net/ethernet/ibm/emac/core.h
> @@ -325,7 +325,14 @@ struct emac_instance {
>   * Set if we need phy clock workaround for 460ex or 460gt
>   */
>  #define EMAC_FTR_460EX_PHY_CLK_FIX	0x00000400
> -
> +/*
> + * APM821xx requires Jumbo frame size set explicitly
> + */
> +#define EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE	0x00000800
> +/*
> + * APM821xx does not support Half Duplex mode
> + */
> +#define EMAC_FTR_APM821XX_NO_HALF_DUPLEX	0x00001000
>
>  /* Right now, we don't quite handle the always/possible masks on the
>   * most optimal way as we don't have a way to say something like
> @@ -353,7 +360,9 @@ enum {
>  	    EMAC_FTR_NO_FLOW_CONTROL_40x |
>  #endif
>  	EMAC_FTR_460EX_PHY_CLK_FIX |
> -	EMAC_FTR_440EP_PHY_CLK_FIX,
> +	EMAC_FTR_440EP_PHY_CLK_FIX |
> +	EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE |
> +	EMAC_FTR_APM821XX_NO_HALF_DUPLEX,
>  };
>
>  static inline int emac_has_feature(struct emac_instance *dev,
> diff --git a/drivers/net/ethernet/ibm/emac/emac.h b/drivers/net/ethernet/ibm/emac/emac.h
> index 1568278..36bcd69 100644
> --- a/drivers/net/ethernet/ibm/emac/emac.h
> +++ b/drivers/net/ethernet/ibm/emac/emac.h
> @@ -212,7 +212,10 @@ struct emac_regs {
>  #define EMAC4_RMR_RFAF_64_1024		0x00000006
>  #define EMAC4_RMR_RFAF_128_2048		0x00000007
>  #define EMAC4_RMR_BASE			EMAC4_RMR_RFAF_128_2048
> -
> +#if defined(CONFIG_APM821xx)
> +#define EMAC4_RMR_MJS_MASK              0x0001fff8
> +#define EMAC4_RMR_MJS(s)                (((s) << 3) & EMAC4_RMR_MJS_MASK)
> +#endif
>  /* EMACx_ISR & EMACx_ISER */
>  #define EMAC4_ISR_TXPE			0x20000000
>  #define EMAC4_ISR_RXPE			0x10000000
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
