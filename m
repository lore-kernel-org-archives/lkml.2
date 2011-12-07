Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1LGQ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:59:18 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:60100 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab1LGQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:59:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqABAEKa304Y9geI/2dsb2JhbAAMN4UGoxmFLAEBAQEDIwRRARALDgoCAgUWCwICCQMCAQIBRQYNAQcBAa07kVeBNIhqgRYEiC6efg
X-IronPort-AV: E=Sophos;i="4.71,314,1320642000"; 
   d="scan'208";a="151284538"
Message-ID: <4EDF9B5F.6050500@teksavvy.com>
Date: Wed, 07 Dec 2011 11:59:11 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>  <20111026.194045.2019668159403582571.davem@davemloft.net>  <4EA8B283.3010105@teksavvy.com>  <20111026.221719.2216112919297458522.davem@davemloft.net>  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>  <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>  <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>  <4EBAB643.8020603@teksavvy.com> <1320859911.2781.1.camel@bwh-desktop>  <4EBABAFD.6050604@teksavvy.com> <1320860895.2781.6.camel@bwh-desktop>  <4EDCD828.2090904@teksavvy.com> <1323098335.7454.214.camel@deadeye>  <4EDE0E29.9070809@teksavvy.com> <1323193537.2772.9.camel@bwh-desktop>  <4EDF9293.8070809@teksavvy.com> <1323275233.2728.3.camel@bwh-desktop>
In-Reply-To: <1323275233.2728.3.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 11:27 AM, Ben Hutchings wrote:
> On Wed, 2011-12-07 at 11:21 -0500, Mark Lord wrote:
..
>> Heh.. my thinking side says to use the exact same protocol-specific flags
>> in both "hw_features" and "features", and therefore check for those flags
>> inside the "set_features()" function.
> 
> Right.


Thanks.
Now now we have:

static int ax88772b_set_features(struct net_device *netdev, u32 features)
{
        struct usbnet *dev = netdev_priv(netdev);
        u16 tx_csum = 0, rx_csum = 0;

        if (features & NETIF_F_IP_CSUM)
                tx_csum |= AX_TXCOE_TCP | AX_TXCOE_UDP;
        if (features & NETIF_F_IPV6_CSUM)
                tx_csum |= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
        if (features & NETIF_F_RXCSUM)
                rx_csum = AX_RXCOE_DEF_CSUM;
        ax8817x_write_cmd(dev, AX_CMD_WRITE_TXCOE_CTL, tx_csum, 0, 0, NULL);
        ax8817x_write_cmd(dev, AX_CMD_WRITE_RXCOE_CTL, rx_csum, 0, 0, NULL);
        return 0;
}

static int ax88772b_bind(struct usbnet *dev, struct usb_interface *intf)
{
	...

        /* enable hardware checksums */
        dev->net->hw_features |=
                NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
        dev->net->features |=
                NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
        ax88772b_set_features(dev->net, dev->net->features);
	...
}
