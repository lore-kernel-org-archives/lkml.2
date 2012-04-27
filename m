Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349Ab2D0U3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:29:19 -0400
Received: from ns.amnesiak.org ([95.130.11.136]:45437 "EHLO amnesiak.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760531Ab2D0U3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:29:17 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 16:29:17 EDT
To: Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [Linux-zigbee-devel] [PATCH 2/2] net/ieee802154/6lowpan.c:  reuse =?UTF-8?Q?eth=5Fmac=5Faddr=28=29?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 27 Apr 2012 22:21:05 +0200
From: Tony Cheneau <tony.cheneau+zigbeedev@amnesiak.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, <netdev@vger.kernel.org>,
        Danny Kukawka <dkukawka@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-zigbee-devel@lists.sourceforge.net>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
 <1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
Message-ID: <92f4dc09fca1e6ec54f12ca61b8b8e55@amnesiak.org>
User-Agent: Roundcube Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I believe the following patch should not have been applied and should 
now be reverted.
The reason is because eth_mac_addr() is not functionally equivalent to 
lowpan_set_address() that it replaces:
- lowpan_set_address() copies dev->addr_len bytes, where dev->addr_len 
is set to 8 bytes for IEEE802154 devices (this is an IEEE EUI-64 
address). Hence, the function copies the full 8 bytes of the address.
- eth_mac_addr() copies ETH_ALEN bytes, where ETH_ALEN is set to 6. 
Hence, the function copies only 6 bytes of the 8 bytes address. So, 2 
bytes of the address are never copied.

Does this sound reasonable?

Regards,
Tony


Le 22.02.2012 14:36, Danny Kukawka a écrit :
> Use eth_mac_addr() for .ndo_set_mac_address, remove
> lowpan_set_address since it do currently the same as
> eth_mac_addr(). Additional advantage: eth_mac_addr() already
> checks if the given address is valid
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  net/ieee802154/6lowpan.c |   16 ++--------------
>  1 files changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
> index e4ecc1e..3685158 100644
> --- a/net/ieee802154/6lowpan.c
> +++ b/net/ieee802154/6lowpan.c
> @@ -55,6 +55,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
>  #include <net/af_ieee802154.h>
>  #include <net/ieee802154.h>
>  #include <net/ieee802154_netdev.h>
> @@ -924,19 +925,6 @@ drop:
>  	return -EINVAL;
>  }
>
> -static int lowpan_set_address(struct net_device *dev, void *p)
> -{
> -	struct sockaddr *sa = p;
> -
> -	if (netif_running(dev))
> -		return -EBUSY;
> -
> -	/* TODO: validate addr */
> -	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
> -
> -	return 0;
> -}
> -
>  static int lowpan_get_mac_header_length(struct sk_buff *skb)
>  {
>  	/*
> @@ -1062,7 +1050,7 @@ static struct header_ops lowpan_header_ops = {
>
>  static const struct net_device_ops lowpan_netdev_ops = {
>  	.ndo_start_xmit		= lowpan_xmit,
> -	.ndo_set_mac_address	= lowpan_set_address,
> +	.ndo_set_mac_address	= eth_mac_addr,
>  };
>
>  static void lowpan_setup(struct net_device *dev)

