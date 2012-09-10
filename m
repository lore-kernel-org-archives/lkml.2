Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2IJSWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:22:09 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:38496 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2IJSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:22:06 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzFuK6ZQo8=
X-RZG-CLASS-ID: mo00
Message-ID: <504E2FCB.3040304@hartkopp.net>
Date: Mon, 10 Sep 2012 20:22:03 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: Re: [PATCH] can: export a safe netdev_priv wrapper for candev
References: <20120907071934.GB37685@macbook.local> <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com> <20120910142507.GA11000@vandijck-laurijssen.be>
In-Reply-To: <20120910142507.GA11000@vandijck-laurijssen.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.2012 16:25, Kurt Van Dijck wrote:

> can: export a safe netdev_priv wrapper for candev
> 
> In net_device notifier calls, it was impossible to determine
> if a CAN device is based on candev in a safe way.
> This patch adds such test in order to access candev storage
> from within those notifiers.
> 
> Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
> 
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 963e2cc..6c1e704 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -795,6 +795,18 @@ void unregister_candev(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(unregister_candev);
>  
> +/*
> + * Test if a network device is a candev based device
> + * and return the can_priv* if so.
> + */
> +struct can_priv *safe_candev_priv(struct net_device *dev)
> +{
> +	if ((dev->type != ARPHRD_CAN) || (dev->rtnl_link_ops != &can_link_ops))
> +		return NULL;


Nice idea!

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

> +
> +	return netdev_priv(dev);
> +}
> +
>  static __init int can_dev_init(void)
>  {
>  	int err;
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 7747d9b..fb0ab65 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -106,6 +106,9 @@ u8 can_len2dlc(u8 len);
>  struct net_device *alloc_candev(int sizeof_priv, unsigned int echo_skb_max);
>  void free_candev(struct net_device *dev);
>  
> +/* a candev safe wrapper around netdev_priv */
> +struct can_priv *safe_candev_priv(struct net_device *dev);
> +
>  int open_candev(struct net_device *dev);
>  void close_candev(struct net_device *dev);
>  


