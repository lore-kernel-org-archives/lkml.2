Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1K0IHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 03:07:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42178 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1K0IHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 03:07:35 -0500
Message-ID: <1322381248.2826.1.camel@edumazet-laptop>
Subject: Re: [PATCH 21/62] net: remove the second argument of
 k[un]map_atomic()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dean Nelson <dnelson@redhat.com>,
        Ian Campbell <ian.campbell@citrix.com>, Jiri Pirko <jpirko@redhat.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Date: Sun, 27 Nov 2011 09:07:28 +0100
In-Reply-To: <1322371662-26166-22-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	 <1322371662-26166-22-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 27 novembre 2011 à 13:27 +0800, Cong Wang a écrit :
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---

> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
> index cf480b5..b194beb 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -3878,11 +3878,9 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
>  				if (length <= copybreak &&
>  				    skb_tailroom(skb) >= length) {
>  					u8 *vaddr;
> -					vaddr = kmap_atomic(buffer_info->page,
> -					                    KM_SKB_DATA_SOFTIRQ);
> +					vaddr = kmap_atomic(buffer_info->page);
>  					memcpy(skb_tail_pointer(skb), vaddr, length);
> -					kunmap_atomic(vaddr,
> -					              KM_SKB_DATA_SOFTIRQ);
> +					kunmap_atomic(vaddr);
>  					/* re-use the page, so don't erase
>  					 * buffer_info->page */
>  					skb_put(skb, length);
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index a855db1..8603c87 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -1272,9 +1272,9 @@ static bool e1000_clean_rx_irq_ps(struct e1000_adapter *adapter,
>  			 */
>  			dma_sync_single_for_cpu(&pdev->dev, ps_page->dma,
>  						PAGE_SIZE, DMA_FROM_DEVICE);
> -			vaddr = kmap_atomic(ps_page->page, KM_SKB_DATA_SOFTIRQ);
> +			vaddr = kmap_atomic(ps_page->page);
>  			memcpy(skb_tail_pointer(skb), vaddr, l1);
> -			kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
> +			kunmap_atomic(vaddr);
>  			dma_sync_single_for_device(&pdev->dev, ps_page->dma,
>  						   PAGE_SIZE, DMA_FROM_DEVICE);
>  
> @@ -1465,12 +1465,10 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
>  				if (length <= copybreak &&
>  				    skb_tailroom(skb) >= length) {
>  					u8 *vaddr;
> -					vaddr = kmap_atomic(buffer_info->page,
> -					                   KM_SKB_DATA_SOFTIRQ);
> +					vaddr = kmap_atomic(buffer_info->page);
>  					memcpy(skb_tail_pointer(skb), vaddr,
>  					       length);
> -					kunmap_atomic(vaddr,
> -					              KM_SKB_DATA_SOFTIRQ);
> +					kunmap_atomic(vaddr);
>  					/* re-use the page, so don't erase
>  					 * buffer_info->page */
>  					skb_put(skb, length);

But why are these drivers using kmap_atomic() in first place, since
their fragments are allocated in regular zone (GFP_ATOMIC or
GFP_KERNEL) ?




