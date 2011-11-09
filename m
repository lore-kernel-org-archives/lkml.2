Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1KIRUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:20:07 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:52009 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754391Ab1KIRUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:20:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAAy2uk4Y9geI/2dsb2JhbAAMNoR9ow6FEAEBAQEDIwRRARALDgoCAgUWCwICCQMCAQIBRQYNAQcBAa1bkjyBMIc5gRYEiAyeKQ
X-IronPort-AV: E=Sophos;i="4.69,484,1315195200"; 
   d="scan'208";a="147180117"
Message-ID: <4EBAB643.8020603@teksavvy.com>
Date: Wed, 09 Nov 2011 12:20:03 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>   <20111026.194045.2019668159403582571.davem@davemloft.net>   <4EA8B283.3010105@teksavvy.com>   <20111026.221719.2216112919297458522.davem@davemloft.net>   <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>  <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye> <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>
In-Reply-To: <4EBAB0EA.1050102@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-09 11:57 AM, Mark Lord wrote:
> On 11-11-09 11:47 AM, Mark Lord wrote:
> ..
>> Note:  I'm looking at smsc95xx.c and smsc75xx.c for examples,
>> and they both have the same problem I'll have here:
>>
>> How to update the csum settings atomically.
>> A spinlock is no good, because config register access is over USB.
> 
> Nevermind.. a slight change in the logic and all is well again.
..

Or even simpler (below).  I don't think this method requires any
extra locking, but I'm still open to persuasion.  :)


static int ax88772b_set_features(struct net_device *netdev, u32 features)
{
        struct usbnet *dev = netdev_priv(netdev);
        struct ax88772b_data *priv = (struct ax88772b_data *)dev->driver_priv;
        u16 tx_csum = 0, rx_csum = 0;

        priv->features = features & (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
        if (features & NETIF_F_HW_CSUM)
                tx_csum = AX_TXCOE_DEF_CSUM;
        if (features & NETIF_F_RXCSUM)
                rx_csum = AX_RXCOE_DEF_CSUM;
        ax8817x_write_cmd(dev, AX_CMD_WRITE_RXCOE_CTL, rx_csum, 0, 0, NULL);
        ax8817x_write_cmd(dev, AX_CMD_WRITE_TXCOE_CTL, tx_csum, 0, 0, NULL);
        return 0;
}

