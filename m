Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2BHWwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:52:45 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58335 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab2BHWwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:52:43 -0500
Date: Wed, 8 Feb 2012 14:52:40 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 47/50] bridge: use dev_hw_addr_random() instead of
 random_ether_addr()
Message-ID: <20120208145240.6fa6fb0e@nehalam.linuxnetplumber.net>
In-Reply-To: <1328735457-29986-48-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
	<1328735457-29986-48-git-send-email-danny.kukawka@bisect.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 22:10:54 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  net/bridge/br_device.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 71773b0..a25ed22 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -172,6 +172,10 @@ static int br_set_mac_address(struct net_device *dev, void *p)
>  	spin_lock_bh(&br->lock);
>  	if (compare_ether_addr(dev->dev_addr, addr->sa_data)) {
>  		memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> +		if (dev->addr_assign_type & NET_ADDR_RANDOM) {
> +			/* set back to NET_ADDR_PERM */
> +			dev->addr_assign_type ^= NET_ADDR_RANDOM;
> +		}
>  		br_fdb_change_mac_address(br, addr->sa_data);
>  		br_stp_change_bridge_id(br, addr->sa_data);
>  	}
> @@ -334,7 +338,7 @@ void br_dev_setup(struct net_device *dev)
>  {
>  	struct net_bridge *br = netdev_priv(dev);
>  
> -	random_ether_addr(dev->dev_addr);
> +	dev_hw_addr_random(dev, dev->dev_addr);
>  	ether_setup(dev);
>  
>  	dev->netdev_ops = &br_netdev_ops;


You should do more than just mechanical change here.
Go ahead and eliminate the private (BR_SET_MAC_ADDR) flag as well,
since it would be redundant.



