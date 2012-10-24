Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161315Ab2JXWIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:08:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab2JXWIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:08:09 -0400
Date: Wed, 24 Oct 2012 15:08:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: dan.carpenter@oracle.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: avoid using skb member after dev_queue_xmit
Message-Id: <20121024150807.82ce2677.akpm@linux-foundation.org>
In-Reply-To: <d1523cdc8a606d65418dc242e958ff1c@coraid.com>
References: <d1523cdc8a606d65418dc242e958ff1c@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 14:26:13 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> After calling dev_queue_xmit it is no longer safe to access the
> members of the skb.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

hm, that was clever.  How did Dan detect this bug?

> --- a/drivers/block/aoe/aoenet.c
> +++ b/drivers/block/aoe/aoenet.c
> @@ -55,12 +55,14 @@ static int
>  tx(void) __must_hold(&txlock)
>  {
>  	struct sk_buff *skb;
> +	struct net_device *ifp;
>  
>  	while ((skb = skb_dequeue(&skbtxq))) {
>  		spin_unlock_irq(&txlock);
> +		ifp = skb->dev;
>  		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
>  			pr_warn("aoe: packet could not be sent on %s.  %s\n",
> -				skb->dev ? skb->dev->name : "netif",
> +				ifp ? ifp->name : "netif",
>  				"consider increasing tx_queue_len");
>  		spin_lock_irq(&txlock);
>  	}

Queued as a fix against the not-yet-upstream
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch,
thanks.

