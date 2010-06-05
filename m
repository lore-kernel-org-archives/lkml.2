Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab0FEOvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:51:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59330 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0FEOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Fmm+jfve5SaQvo2fqZLTOWTivbjYqv832VmnLcyUy3pM+IMxwYhzx6UCPh6bsq7CNU
         caGFna2uJSp8cNwgH1FvPjpBGOVJZJX4lNjFEllI+XFtcAn2HgCw1xRTBfcRm+u2My+f
         34PDv5/2X6En/LzJbxCVVdE7lfR9j8y3uIlp4=
Subject: Re: [RFC PATCH v7 03/19] Export 2 func for device to
 assign/deassign new strucure
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 16:51:36 +0200
Message-ID: <1275749496.5238.233.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 05 juin 2010 à 18:14 +0800, xiaohui.xin@intel.com a écrit :
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  include/linux/netdevice.h |    3 +++
>  net/core/dev.c            |   28 ++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index bae725c..efb575a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1592,6 +1592,9 @@ extern gro_result_t	napi_frags_finish(struct napi_struct *napi,
>  					  gro_result_t ret);
>  extern struct sk_buff *	napi_frags_skb(struct napi_struct *napi);
>  extern gro_result_t	napi_gro_frags(struct napi_struct *napi);
> +extern int netdev_mp_port_attach(struct net_device *dev,
> +				 struct mpassthru_port *port);
> +extern void netdev_mp_port_detach(struct net_device *dev);
>  
>  static inline void napi_free_frags(struct napi_struct *napi)
>  {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index f769098..ecbb6b1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2469,6 +2469,34 @@ void netif_nit_deliver(struct sk_buff *skb)
>  	rcu_read_unlock();
>  }
>  
> +/* Export two functions to assign/de-assign mp_port pointer
> + * to a net device.
> + */
> +
> +int netdev_mp_port_attach(struct net_device *dev,
> +			struct mpassthru_port *port)
> +{
> +	/* locked by mp_mutex */
> +	if (rcu_dereference(dev->mp_port))
> +		return -EBUSY;
> +

Please... this is bogus...

Try with following config settings :

CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y




> +	rcu_assign_pointer(dev->mp_port, port);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(netdev_mp_port_attach);
> +
> +void netdev_mp_port_detach(struct net_device *dev)
> +{
> +	/* locked by mp_mutex */
> +	if (!rcu_dereference(dev->mp_port))
> +		return;

same problem here

> +
> +	rcu_assign_pointer(dev->mp_port, NULL);
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL(netdev_mp_port_detach);
> +
>  /**
>   *	netif_receive_skb - process receive buffer from network
>   *	@skb: buffer to process


