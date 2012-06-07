Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2FGVaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:30:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56028 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab2FGVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:30:10 -0400
Subject: Re: Deadlock, L2TP over IP are not working, 3.4.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120607205356.GA2491@electric-eye.fr.zoreil.com>
References: <7ed49f446365ac625437702d92946add@visp.net.lb>
	 <20120607205356.GA2491@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 23:30:06 +0200
Message-ID: <1339104606.6001.4.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 22:53 +0200, Francois Romieu wrote:

> Any reason why it could not be made LLTX ?
> 

>  /* via l2tp_session_priv() */
> @@ -87,25 +95,56 @@ static int l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct l2tp_eth *priv = netdev_priv(dev);
>  	struct l2tp_session *session = priv->session;
> +	struct l2tp_eth_stats *tstats = &priv->tstats;
>  
>  	l2tp_xmit_skb(session, skb, session->hdr_len);
>  
> -	dev->stats.tx_bytes += skb->len;
> -	dev->stats.tx_packets++;
> +	u64_stats_update_begin(&tstats->syncp);
> +	tstats->packets++;
> +	tstats->bytes += skb->len;
> +	u64_stats_update_end(&tstats->syncp);
>  
>  	return 0;
>  }
>  

Its racy.

If LLTX is used, this means several cpus can execute this code at the
same time.

You need percpu stats, or use atomic primitives.



