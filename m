Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3ADVR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:17:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3ADVRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:17:54 -0500
Message-ID: <1357334395.18825.0.camel@dcbw.foobar.com>
Subject: Re: [PATCH 20/25] wimax/i2400m: fix i2400m->wake_tx_skb handling
From: Dan Williams <dcbw@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, wimax@linuxwimax.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com
Date: Fri, 04 Jan 2013 15:19:55 -0600
In-Reply-To: <1356141435-17340-21-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	 <1356141435-17340-21-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 17:57 -0800, Tejun Heo wrote:
> i2400m_net_wake_tx() sets ->wake_tx_skb with the given skb if
> ->wake_tx_ws is not pending; however, i2400m_wake_tx_work() could have
> just started execution and haven't fetched -><wake_tx_skb yet.  The
> previous packet will be leaked.
> 
> Update ->wake_tx_skb handling.
> 
> * i2400m_net_wake_tx() now tests whether the previous ->wake_tx_skb
>   has been consumed by ->wake_tx_ws instead of testing work_pending().
> 
> * i2400m_net_wake_stop() is simplified similarly.  It always puts
>   ->wake_tx_skb if non-NULL.
> 
> * Spurious ->wake_tx_skb dereference outside critical section dropped
>   from i2400m_wake_tx_work().
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Dan Williams <dcbw@redhat.com>

No regressions in a quick connection check to Clear and browsing a bunch
of pages.

Dan

> Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> Cc: linux-wimax@intel.com
> Cc: wimax@linuxwimax.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  drivers/net/wimax/i2400m/netdev.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/netdev.c
> index 1d76ae8..530581c 100644
> --- a/drivers/net/wimax/i2400m/netdev.c
> +++ b/drivers/net/wimax/i2400m/netdev.c
> @@ -156,7 +156,7 @@ void i2400m_wake_tx_work(struct work_struct *ws)
>  	struct i2400m *i2400m = container_of(ws, struct i2400m, wake_tx_ws);
>  	struct net_device *net_dev = i2400m->wimax_dev.net_dev;
>  	struct device *dev = i2400m_dev(i2400m);
> -	struct sk_buff *skb = i2400m->wake_tx_skb;
> +	struct sk_buff *skb;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&i2400m->tx_lock, flags);
> @@ -236,23 +236,26 @@ void i2400m_tx_prep_header(struct sk_buff *skb)
>  void i2400m_net_wake_stop(struct i2400m *i2400m)
>  {
>  	struct device *dev = i2400m_dev(i2400m);
> +	struct sk_buff *wake_tx_skb;
> +	unsigned long flags;
>  
>  	d_fnstart(3, dev, "(i2400m %p)\n", i2400m);
> -	/* See i2400m_hard_start_xmit(), references are taken there
> -	 * and here we release them if the work was still
> -	 * pending. Note we can't differentiate work not pending vs
> -	 * never scheduled, so the NULL check does that. */
> -	if (cancel_work_sync(&i2400m->wake_tx_ws) == 0
> -	    && i2400m->wake_tx_skb != NULL) {
> -		unsigned long flags;
> -		struct sk_buff *wake_tx_skb;
> -		spin_lock_irqsave(&i2400m->tx_lock, flags);
> -		wake_tx_skb = i2400m->wake_tx_skb;	/* compat help */
> -		i2400m->wake_tx_skb = NULL;	/* compat help */
> -		spin_unlock_irqrestore(&i2400m->tx_lock, flags);
> +	/*
> +	 * See i2400m_hard_start_xmit(), references are taken there and
> +	 * here we release them if the packet was still pending.
> +	 */
> +	cancel_work_sync(&i2400m->wake_tx_ws);
> +
> +	spin_lock_irqsave(&i2400m->tx_lock, flags);
> +	wake_tx_skb = i2400m->wake_tx_skb;
> +	i2400m->wake_tx_skb = NULL;
> +	spin_unlock_irqrestore(&i2400m->tx_lock, flags);
> +
> +	if (wake_tx_skb) {
>  		i2400m_put(i2400m);
>  		kfree_skb(wake_tx_skb);
>  	}
> +
>  	d_fnend(3, dev, "(i2400m %p) = void\n", i2400m);
>  }
>  
> @@ -288,7 +291,7 @@ int i2400m_net_wake_tx(struct i2400m *i2400m, struct net_device *net_dev,
>  	 * and if pending, release those resources. */
>  	result = 0;
>  	spin_lock_irqsave(&i2400m->tx_lock, flags);
> -	if (!work_pending(&i2400m->wake_tx_ws)) {
> +	if (!i2400m->wake_tx_skb) {
>  		netif_stop_queue(net_dev);
>  		i2400m_get(i2400m);
>  		i2400m->wake_tx_skb = skb_get(skb);	/* transfer ref count */


