Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1LNV7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:59:53 -0500
Received: from smtp.riverbed.com ([208.70.196.45]:62427 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab1LNV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:59:48 -0500
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasanna Panchamukhi <Prasanna.Panchamukhi@riverbed.com>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>,
        "miles.ito@intel.com" <miles.ito@intel.com>
Subject: RE: [PATCH 1/2] e100: power down PHY if WOL is not enabled
Thread-Topic: [PATCH 1/2] e100: power down PHY if WOL is not enabled
Thread-Index: AQHMupWw3KBVkwNve0CC+hQ7t8HMcZXcT2kA//+RlTA=
Date: Wed, 14 Dec 2011 21:59:47 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA82AA78720@365EXCH-MBX-P5.nbttech.com>
References: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
 <1323894636.2753.2.camel@bwh-desktop>
In-Reply-To: <1323894636.2753.2.camel@bwh-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.249]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBEM07oX004988

Hi Ben,

Do you mean the WOL is enabled but PHY is powered off somehow? That scenario should never happen. If WOL is enabled, there is no code to power off PHY.

Regards,

Jiang

-------------------------------------
Jiang Wang
Member of Technical Staff
Riverbed Technology
Tel: (408) 522-5109
Email: Jiang.Wang@riverbed.com
www.riverbed.com

-----Original Message-----
From: Ben Hutchings [mailto:bhutchings@solarflare.com] 
Sent: Wednesday, December 14, 2011 12:31 PM
To: Jiang Wang
Cc: Jeff Kirsher; Jesse Brandeburg; Bruce Allan; Carolyn Wyborny; Don Skidmore; Greg Rose; Peter P Waskiewicz Jr; Alex Duyck; John Ronciak; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Prasanna Panchamukhi; Chaitanya Lala; Francis St. Amant; miles.ito@intel.com
Subject: Re: [PATCH 1/2] e100: power down PHY if WOL is not enabled

On Tue, 2011-12-13 at 18:49 -0800, Jiang Wang wrote:
> Since the interface will not be used after being put down and WOL is 
> disabled, just power it off.
> When bring up the interface, power on the PHY.

Don't you need to cover the case where WOL is enabled while the interface is down?

Ben.

> Signed-off-by: Jiang Wang <Jiang.Wang@riverbed.com>
> ---
>  drivers/net/ethernet/intel/e100.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e100.c 
> b/drivers/net/ethernet/intel/e100.c
> index 5a2fdf7..9824e0a 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -1449,6 +1449,14 @@ static int e100_phy_init(struct nic *nic)
>  		netif_printk(nic, hw, KERN_DEBUG, nic->netdev,
>  			     "phy_addr = %d\n", nic->mii.phy_id);
>  
> +	/* Make sure power to the PHY is enabled */
> +	if (!(nic->flags & wol_magic)) {
> +		uint16_t phy_data;
> +		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
> +		phy_data &= ~BMCR_PDOWN;
> +		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
> +	}
> +
>  	/* Get phy ID */
>  	id_lo = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID1);
>  	id_hi = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID2); @@ -2261,6 
> +2269,15 @@ static void e100_down(struct nic *nic)
>  	napi_disable(&nic->napi);
>  	netif_stop_queue(nic->netdev);
>  	e100_hw_reset(nic);
> +
> +	/* If wake on LAN is not enabled, power down the PHY */
> +	if (!(nic->flags & wol_magic)) {
> +		uint16_t phy_data;
> +		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
> +		phy_data |= BMCR_PDOWN;
> +		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
> +	}
> +
>  	free_irq(nic->pdev->irq, nic->netdev);
>  	del_timer_sync(&nic->watchdog);
>  	netif_carrier_off(nic->netdev);

--
Ben Hutchings, Staff Engineer, Solarflare Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
