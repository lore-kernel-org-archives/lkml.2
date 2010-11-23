Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0KWOdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:33:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56064 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0KWOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E7K3qA0TQvt1wvZkpDeJnLKrS9DZ/2WTQC8W3H9p2xho8ZbnyNezw5AN94bvmkwg8L
         vwk5gA9Bw0kuIB0h90c0hx/NleW1GVLgccvCGYSNRoYNhFr+piotFpe18mlbyJhF7Tp5
         QsEXxI/ZTGjHW1Ox2+YQ0L+jKKh6I387CcXCU=
Subject: Re: addrconf: refcnt with  IPV6_PRIVACY enabled
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
In-Reply-To: <20101123134003.GB4142@swordfish.minsk.epam.com>
References: <20101123134003.GB4142@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 15:33:23 +0100
Message-ID: <1290522803.3046.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 15:40 +0200, Sergey Senozhatsky a écrit :
> Hello,
> 
> I've sent a patch http://lkml.org/lkml/2010/11/21/124 
> "[PATCH] ipv6: fix inet6_dev refcnt with IPV6_PRIVACY enabled" related
> to wrong in6_dev refcnt value when IPV6_PRIVACY enabled.
> 
> I've took a second look, and question arised - 
> Is it actually necessary to in6_dev_hold/in6_dev_put in ipv6_regen_rndid?
> In ipv6_regen_rndid we call in6_dev_hold only when mod_timer == 0,
> and always in6_dev_put. 
> 
> 
> I've removed check for < 0 and goto from __ipv6_regen_rndid call, since it 
> always return 0.
> 
> 
> Please, kindly review V2.
> 
> ---
> 
>  net/ipv6/addrconf.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 2fc35b3..8187d14 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -425,7 +425,6 @@ static struct inet6_dev * ipv6_add_dev(struct net_device *dev)
>  		       dev->name);
>  		ndev->cnf.use_tempaddr = -1;
>  	} else {
> -		in6_dev_hold(ndev);
>  		ipv6_regen_rndid((unsigned long) ndev);
>  	}
>  #endif
> @@ -1653,8 +1652,7 @@ static void ipv6_regen_rndid(unsigned long data)
>  	if (idev->dead)
>  		goto out;
>  
> -	if (__ipv6_regen_rndid(idev) < 0)
> -		goto out;
> +	__ipv6_regen_rndid(idev);
>  
>  	expires = jiffies +
>  		idev->cnf.temp_prefered_lft * HZ -
> @@ -1667,13 +1665,11 @@ static void ipv6_regen_rndid(unsigned long data)
>  		goto out;
>  	}
>  
> -	if (!mod_timer(&idev->regen_timer, expires))
> -		in6_dev_hold(idev);
> -
> +	mod_timer(&idev->regen_timer, expires);
> +	
>  out:
>  	write_unlock_bh(&idev->lock);
>  	rcu_read_unlock_bh();
> -	in6_dev_put(idev);
>  }
>  
>  static int __ipv6_try_regen_rndid(struct inet6_dev *idev, struct in6_addr *tmpaddr) {
> 


Sergey, I dont think your patches (V1 or V2) are correct.

You leak a refcount if (idev->dead) is true

ipv6_regen_rndid() is the timer handler function, it must call
in6_dev_put() at the end, unless we rearm the timer.

So this code is correct.


if (!mod_timer(&idev->regen_timer, expires))
	in6_dev_hold(idev);
...
in6_dev_put(idev);


And we must call in6_dev_hold() before calling the handler, either
directly from ipv6_add_dev() [Where your first patch tried to remove the
dev_hold() call], or when arming the timer.

Are you sure the problem you try to solve is not already solved in
commit 88b2a9a3d98a19496d64aadda7158c0ad51cbe7d in net-2.6 tree ?

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=88b2a9a3d98a19496d64aadda7158c0ad51cbe7d




