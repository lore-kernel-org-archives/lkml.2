Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab1KIRcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:32:05 -0500
Received: from mail.solarflare.com ([216.237.3.220]:37814 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab1KIRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:31:59 -0500
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mark Lord <kernel@teksavvy.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <4EBAB643.8020603@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	 <20111026.194045.2019668159403582571.davem@davemloft.net>
	 <4EA8B283.3010105@teksavvy.com>
	 <20111026.221719.2216112919297458522.davem@davemloft.net>
	 <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
	 <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>
	 <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>
	 <4EBAB643.8020603@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 9 Nov 2011 17:31:51 +0000
Message-ID: <1320859911.2781.1.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18502.005
X-TM-AS-Result: No--19.099000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 09 Nov 2011 17:31:58.0607 (UTC) FILETIME=[7BB5D9F0:01CC9F05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 12:20 -0500, Mark Lord wrote:
> On 11-11-09 11:57 AM, Mark Lord wrote:
> > On 11-11-09 11:47 AM, Mark Lord wrote:
> > ..
> >> Note:  I'm looking at smsc95xx.c and smsc75xx.c for examples,
> >> and they both have the same problem I'll have here:
> >>
> >> How to update the csum settings atomically.
> >> A spinlock is no good, because config register access is over USB.
> > 
> > Nevermind.. a slight change in the logic and all is well again.
> ..
> 
> Or even simpler (below).  I don't think this method requires any
> extra locking, but I'm still open to persuasion.  :)

Looks reasonable, but...

> static int ax88772b_set_features(struct net_device *netdev, u32 features)
> {
>         struct usbnet *dev = netdev_priv(netdev);
>         struct ax88772b_data *priv = (struct ax88772b_data *)dev->driver_priv;
>         u16 tx_csum = 0, rx_csum = 0;
> 
>         priv->features = features & (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);

...why do you need priv->features at all?

Ben.

>         if (features & NETIF_F_HW_CSUM)
>                 tx_csum = AX_TXCOE_DEF_CSUM;
>         if (features & NETIF_F_RXCSUM)
>                 rx_csum = AX_RXCOE_DEF_CSUM;
>         ax8817x_write_cmd(dev, AX_CMD_WRITE_RXCOE_CTL, rx_csum, 0, 0, NULL);
>         ax8817x_write_cmd(dev, AX_CMD_WRITE_TXCOE_CTL, tx_csum, 0, 0, NULL);
>         return 0;
> }
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

