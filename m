Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0I3OWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:22:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0I3OWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=roNh/6gbbnHW9JYDOmPWe6kkrfRrD0rtQHHH7+iZR7qw96eQRt0nz+UFTR4ondRrPu
         ZXqF8M1aQ1SWd7/jASmbiVA1Zqclhlf4KsVD0/saxk8l8ucivRxypua44PlP20ee+jGu
         CV8qrGfDCXmZWnRSErRg9oZTE0eE9bn6dDo3w=
Subject: Re: [PATCH v12 10/17] Add a hook to intercept external buffers
 from NIC driver.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <fda262fa746dfc1feb8543cf88d5ecf60001c186.1285853725.git.xiaohui.xin@intel.com>
References: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
	 <fda262fa746dfc1feb8543cf88d5ecf60001c186.1285853725.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:22:13 +0200
Message-ID: <1285856533.2615.573.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 22:04 +0800, xiaohui.xin@intel.com a
écrit :
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> The hook is called in netif_receive_skb().
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  net/core/dev.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c11e32c..83172b8 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2517,6 +2517,37 @@ err:
>  EXPORT_SYMBOL(netdev_mp_port_prep);
>  #endif
>  
> +#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
> +/* Add a hook to intercept mediate passthru(zero-copy) packets,
> + * and insert it to the socket queue owned by mp_port specially.
> + */
> +static inline struct sk_buff *handle_mpassthru(struct sk_buff *skb,
> +					       struct packet_type **pt_prev,
> +					       int *ret,
> +					       struct net_device *orig_dev)
> +{
> +	struct mp_port *mp_port = NULL;
> +	struct sock *sk = NULL;
> +
> +	if (!dev_is_mpassthru(skb->dev))
> +		return skb;
> +	mp_port = skb->dev->mp_port;
> +
> +	if (*pt_prev) {
> +		*ret = deliver_skb(skb, *pt_prev, orig_dev);
> +		*pt_prev = NULL;
> +	}
> +
> +	sk = mp_port->sock->sk;
> +	skb_queue_tail(&sk->sk_receive_queue, skb);
> +	sk->sk_state_change(sk);
> +
> +	return NULL;
> +}
> +#else
> +#define handle_mpassthru(skb, pt_prev, ret, orig_dev)     (skb)
> +#endif
> +
>  /**
>   *	netif_receive_skb - process receive buffer from network
>   *	@skb: buffer to process
> @@ -2598,6 +2629,10 @@ int netif_receive_skb(struct sk_buff *skb)
>  ncls:
>  #endif
>  
> +	/* To intercept mediate passthru(zero-copy) packets here */
> +	skb = handle_mpassthru(skb, &pt_prev, &ret, orig_dev);
> +	if (!skb)
> +		goto out;
>  	skb = handle_bridge(skb, &pt_prev, &ret, orig_dev);
>  	if (!skb)
>  		goto out;

This does not apply to current net-next-2.6

We now have dev->rx_handler (currently for bridge or macvlan)


commit ab95bfe01f9872459c8678572ccadbf646badad0
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Tue Jun 1 21:52:08 2010 +0000

    net: replace hooks in __netif_receive_skb V5
    
    What this patch does is it removes two receive frame hooks (for bridge and for
    macvlan) from __netif_receive_skb. These are replaced them with a single
    hook for both. It only supports one hook per device because it makes no
    sense to do bridging and macvlan on the same device.
    
    Then a network driver (of virtual netdev like macvlan or bridge) can register
    an rx_handler for needed net device.
    
    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>



