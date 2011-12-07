Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1LGJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:29:16 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:30388
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488Ab1LGJ3I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:29:08 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 17:41:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: preserve
 MII/RMII setting in fec_stop()
Message-ID: <20111207094146.GG5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <d6f4de9e4cfb393754b42815a2ef1a59c96eab83.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <d6f4de9e4cfb393754b42815a2ef1a59c96eab83.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:14AM +0100, Lothar Waﬂmann wrote:
> Additionally to setting the ETHER_EN bit in FEC_ECNTRL the MII/RMII
> setting in FEC_R_CNTRL needs to be preserved to keep the MII interface

s/MII/RMII?  From what I see from imx28 and imx6q RM, the reset state
for this setting is MII mode.

> functional.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  drivers/net/ethernet/freescale/fec.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

I assume this is fixing a problem you are seeing on imx28 only.
Do you see the problem on imx53/51?

> 
> diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> index 11534b9..ab0afb5 100644
> --- a/drivers/net/ethernet/freescale/fec.c
> +++ b/drivers/net/ethernet/freescale/fec.c
> @@ -515,6 +515,7 @@ fec_stop(struct net_device *ndev)
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	const struct platform_device_id *id_entry =
>  				platform_get_device_id(fep->pdev);
> +	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);

This bit is only available on ENET (imx28 and imx6q).  Do we want to
do the same thing for FEC (imx25/27/35/51/53)?

>  
>  	/* We cannot expect a graceful transmit stop without link !!! */
>  	if (fep->link) {
> @@ -531,8 +532,10 @@ fec_stop(struct net_device *ndev)
>  	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
>  
>  	/* We have to keep ENET enabled to have MII interrupt stay working */
> -	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC)
> +	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
>  		writel(2, fep->hwp + FEC_ECNTRL);
> +		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
> +	}
>  }

On imx6q, we have two bits, bit 6 and 8 of FEC_R_CNTRL, to select MII
interface among MII, RMII and RGMII modes.  I'm not sure if we will
run into the same problem for RGMII mode.  What's your test setup?
I would try to reproduce it here.

-- 
Regards,
Shawn

