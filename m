Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1AARDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 12:03:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64700 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1AARDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 12:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rjt7RaAtKIVy6g5ecBbTMWgCxceswlYBziFIiAhyNQQ5cA/dfbUVSKqKV/m3O0rAW/
         sUc/DKu4J2eaQNpDX6G+Q6eJFsWEA5BzUfrsZC2kX6WvuybykXm8FCWjwi3vjxGXYH17
         QiGu3iRvljAggT7cAPoCZ4NJ2ulxXGQ9UoZxw=
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not
 used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Jesse Gross <jesse@nicira.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20101214191500.GD19951@mcarlson.broadcom.com>
References: <1291536233.2806.102.camel@edumazet-laptop>
	 <20101205105528.49fa9a9f@xenia.leun.net>
	 <20101205114404.7c0cddc2@xenia.leun.net>
	 <AANLkTikrDTCDxsyOG4m0XcrOY=3pTRwWqnPGsio9cBFj@mail.gmail.com>
	 <20101206203437.54b550e0@xenia.leun.net>
	 <AANLkTikKkAesHc4Fi4SwAkV0e65D0TQRztrRYoDNu3MP@mail.gmail.com>
	 <20101206222703.32fbe852@xenia.leun.net>
	 <AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
	 <20101213224510.GB17400@mcarlson.broadcom.com>
	 <AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
	 <20101214191500.GD19951@mcarlson.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Jan 2011 18:03:13 +0100
Message-ID: <1293901393.2535.49.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 14 décembre 2010 à 11:15 -0800, Matt Carlson a écrit :

> Thanks for the comments Jesse.  Below is an updated patch.
> 
> Michael, I'm wondering if the difference in behavior can be explained by
> the presence or absence of management firmware.  Can you look at the
> driver sign-on messages in your syslogs for ASF[]?  I'm half expecting
> the 5752 to show "ASF[0]" and the 5714 to show "ASF[1]".  If you see
> this, and the below patch doesn't fix the problem, let me know.  I have
> another test I'd like you to run.
> 
> ----
> 
> [PATCH] tg3: Use new VLAN code
> 
> This patch pivots the tg3 driver to the new VLAN infrastructure.
> All references to vlgrp have been removed and all VLAN code is
> unconditionally active.
> 
> Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
> ---
>  drivers/net/tg3.c |   95 +++++------------------------------------------------
>  drivers/net/tg3.h |    3 --
>  2 files changed, 9 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index 5faa87d..3682205 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -60,12 +60,6 @@
>  #define BAR_0	0
>  #define BAR_2	2
>  
> -#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> -#define TG3_VLAN_TAG_USED 1
> -#else
> -#define TG3_VLAN_TAG_USED 0
> -#endif
> -
>  #include "tg3.h"
>  
>  #define DRV_MODULE_NAME		"tg3"
> @@ -134,9 +128,6 @@
>  				 TG3_TX_RING_SIZE)
>  #define NEXT_TX(N)		(((N) + 1) & (TG3_TX_RING_SIZE - 1))
>  
> -#define TG3_RX_DMA_ALIGN		16
> -#define TG3_RX_HEADROOM			ALIGN(VLAN_HLEN, TG3_RX_DMA_ALIGN)
> -
>  #define TG3_DMA_BYTE_ENAB		64
>  
>  #define TG3_RX_STD_DMA_SZ		1536
> @@ -4725,8 +4716,6 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
>  		struct sk_buff *skb;
>  		dma_addr_t dma_addr;
>  		u32 opaque_key, desc_idx, *post_ptr;
> -		bool hw_vlan __maybe_unused = false;
> -		u16 vtag __maybe_unused = 0;
>  
>  		desc_idx = desc->opaque & RXD_OPAQUE_INDEX_MASK;
>  		opaque_key = desc->opaque & RXD_OPAQUE_RING_MASK;
> @@ -4785,12 +4774,12 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
>  			tg3_recycle_rx(tnapi, tpr, opaque_key,
>  				       desc_idx, *post_ptr);
>  
> -			copy_skb = netdev_alloc_skb(tp->dev, len + VLAN_HLEN +
> +			copy_skb = netdev_alloc_skb(tp->dev, len +
>  						    TG3_RAW_IP_ALIGN);
>  			if (copy_skb == NULL)
>  				goto drop_it_no_recycle;
>  
> -			skb_reserve(copy_skb, TG3_RAW_IP_ALIGN + VLAN_HLEN);
> +			skb_reserve(copy_skb, TG3_RAW_IP_ALIGN);
>  			skb_put(copy_skb, len);
>  			pci_dma_sync_single_for_cpu(tp->pdev, dma_addr, len, PCI_DMA_FROMDEVICE);
>  			skb_copy_from_linear_data(skb, copy_skb->data, len);
> @@ -4817,30 +4806,11 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
>  		}
>  
>  		if (desc->type_flags & RXD_FLAG_VLAN &&
> -		    !(tp->rx_mode & RX_MODE_KEEP_VLAN_TAG)) {
> -			vtag = desc->err_vlan & RXD_VLAN_MASK;
> -#if TG3_VLAN_TAG_USED
> -			if (tp->vlgrp)
> -				hw_vlan = true;
> -			else
> -#endif
> -			{
> -				struct vlan_ethhdr *ve = (struct vlan_ethhdr *)
> -						    __skb_push(skb, VLAN_HLEN);
> -
> -				memmove(ve, skb->data + VLAN_HLEN,
> -					ETH_ALEN * 2);
> -				ve->h_vlan_proto = htons(ETH_P_8021Q);
> -				ve->h_vlan_TCI = htons(vtag);
> -			}
> -		}
> +		    !(tp->rx_mode & RX_MODE_KEEP_VLAN_TAG))
> +			__vlan_hwaccel_put_tag(skb,
> +					       desc->err_vlan & RXD_VLAN_MASK);
>  
> -#if TG3_VLAN_TAG_USED
> -		if (hw_vlan)
> -			vlan_gro_receive(&tnapi->napi, tp->vlgrp, vtag, skb);
> -		else
> -#endif
> -			napi_gro_receive(&tnapi->napi, skb);
> +		napi_gro_receive(&tnapi->napi, skb);
>  
>  		received++;
>  		budget--;
> @@ -5743,11 +5713,9 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb,
>  		base_flags |= TXD_FLAG_TCPUDP_CSUM;
>  	}
>  
> -#if TG3_VLAN_TAG_USED
>  	if (vlan_tx_tag_present(skb))
>  		base_flags |= (TXD_FLAG_VLAN |
>  			       (vlan_tx_tag_get(skb) << 16));
> -#endif
>  
>  	len = skb_headlen(skb);
>  
> @@ -5989,11 +5957,10 @@ static netdev_tx_t tg3_start_xmit_dma_bug(struct sk_buff *skb,
>  			}
>  		}
>  	}
> -#if TG3_VLAN_TAG_USED
> +
>  	if (vlan_tx_tag_present(skb))
>  		base_flags |= (TXD_FLAG_VLAN |
>  			       (vlan_tx_tag_get(skb) << 16));
> -#endif
>  
>  	if ((tp->tg3_flags3 & TG3_FLG3_USE_JUMBO_BDFLAG) &&
>  	    !mss && skb->len > VLAN_ETH_FRAME_LEN)
> @@ -9538,17 +9505,8 @@ static void __tg3_set_rx_mode(struct net_device *dev)
>  	/* When ASF is in use, we always keep the RX_MODE_KEEP_VLAN_TAG
>  	 * flag clear.
>  	 */
> -#if TG3_VLAN_TAG_USED
> -	if (!tp->vlgrp &&
> -	    !(tp->tg3_flags & TG3_FLAG_ENABLE_ASF))
> -		rx_mode |= RX_MODE_KEEP_VLAN_TAG;
> -#else
> -	/* By definition, VLAN is disabled always in this
> -	 * case.
> -	 */
>  	if (!(tp->tg3_flags & TG3_FLAG_ENABLE_ASF))
>  		rx_mode |= RX_MODE_KEEP_VLAN_TAG;
> -#endif
>  
>  	if (dev->flags & IFF_PROMISC) {
>  		/* Promiscuous mode. */
> @@ -11233,31 +11191,6 @@ static int tg3_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	return -EOPNOTSUPP;
>  }
>  
> -#if TG3_VLAN_TAG_USED
> -static void tg3_vlan_rx_register(struct net_device *dev, struct vlan_group *grp)
> -{
> -	struct tg3 *tp = netdev_priv(dev);
> -
> -	if (!netif_running(dev)) {
> -		tp->vlgrp = grp;
> -		return;
> -	}
> -
> -	tg3_netif_stop(tp);
> -
> -	tg3_full_lock(tp, 0);
> -
> -	tp->vlgrp = grp;
> -
> -	/* Update RX_MODE_KEEP_VLAN_TAG bit in RX_MODE register. */
> -	__tg3_set_rx_mode(dev);
> -
> -	tg3_netif_start(tp);
> -
> -	tg3_full_unlock(tp);
> -}
> -#endif
> -
>  static int tg3_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
>  {
>  	struct tg3 *tp = netdev_priv(dev);
> @@ -13069,9 +13002,7 @@ static struct pci_dev * __devinit tg3_find_peer(struct tg3 *);
>  
>  static void inline vlan_features_add(struct net_device *dev, unsigned long flags)
>  {
> -#if TG3_VLAN_TAG_USED
>  	dev->vlan_features |= flags;
> -#endif
>  }
>  
>  static inline u32 tg3_rx_ret_ring_size(struct tg3 *tp)
> @@ -13866,11 +13797,11 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
>  	else
>  		tp->tg3_flags &= ~TG3_FLAG_POLL_SERDES;
>  
> -	tp->rx_offset = NET_IP_ALIGN + TG3_RX_HEADROOM;
> +	tp->rx_offset = NET_IP_ALIGN;
>  	tp->rx_copy_thresh = TG3_RX_COPY_THRESHOLD;
>  	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701 &&
>  	    (tp->tg3_flags & TG3_FLAG_PCIX_MODE) != 0) {
> -		tp->rx_offset -= NET_IP_ALIGN;
> +		tp->rx_offset = 0;
>  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  		tp->rx_copy_thresh = ~(u16)0;
>  #endif
> @@ -14634,9 +14565,6 @@ static const struct net_device_ops tg3_netdev_ops = {
>  	.ndo_do_ioctl		= tg3_ioctl,
>  	.ndo_tx_timeout		= tg3_tx_timeout,
>  	.ndo_change_mtu		= tg3_change_mtu,
> -#if TG3_VLAN_TAG_USED
> -	.ndo_vlan_rx_register	= tg3_vlan_rx_register,
> -#endif
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	= tg3_poll_controller,
>  #endif
> @@ -14653,9 +14581,6 @@ static const struct net_device_ops tg3_netdev_ops_dma_bug = {
>  	.ndo_do_ioctl		= tg3_ioctl,
>  	.ndo_tx_timeout		= tg3_tx_timeout,
>  	.ndo_change_mtu		= tg3_change_mtu,
> -#if TG3_VLAN_TAG_USED
> -	.ndo_vlan_rx_register	= tg3_vlan_rx_register,
> -#endif
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	= tg3_poll_controller,
>  #endif
> @@ -14705,9 +14630,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  
> -#if TG3_VLAN_TAG_USED
>  	dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
> -#endif
>  
>  	tp = netdev_priv(dev);
>  	tp->pdev = pdev;
> diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
> index d62c8d9..f528243 100644
> --- a/drivers/net/tg3.h
> +++ b/drivers/net/tg3.h
> @@ -2808,9 +2808,6 @@ struct tg3 {
>  	u32				rx_std_max_post;
>  	u32				rx_offset;
>  	u32				rx_pkt_map_sz;
> -#if TG3_VLAN_TAG_USED
> -	struct vlan_group		*vlgrp;
> -#endif
>  
> 
>  	/* begin "everything else" cacheline(s) section */


Hi Matt.

Any news on this patch ?

Without it, net-next-2.6 doesnt work for me on a vlan setup on top of
bonding.

(bond0 : eth1 & eth2, eth1 being bnx2, eth2 beging tg3)

ip link add link bond0 vlan.103 type vlan id 103
ip addr add 192.168.20.110/24 dev vlan.103
ip link set vlan.103 up


If active slave is eth1 (bnx2), everything works, but if active slave is
eth2 (tg3), incoming tagged frames (on vlan 103) are lost.



