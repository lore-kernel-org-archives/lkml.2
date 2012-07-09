Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2GIXjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:39:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2GIXjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:39:09 -0400
Date: Mon, 9 Jul 2012 20:39:02 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 35/48] dummy: fix rcu_sched self-detected stalls
Message-ID: <20120709233901.GB3237@herton-Z68MA-D2H-B3>
References: <20120709143116.348975190@decadent.org.uk>
 <20120709143121.743971024@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709143121.743971024@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:31:51PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 16b0dc29c1af9df341428f4c49ada4f626258082 ]
> 
> Trying to "modprobe dummy numdummies=30000" triggers :
> 
> INFO: rcu_sched self-detected stall on CPU { 8} (t=60000 jiffies)
> 
> After this splat, RTNL is locked and reboot is needed.
> 
> We must call cond_resched() to avoid this, even holding RTNL.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/dummy.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
> index eeac9ca..87e4632 100644
> --- a/drivers/net/dummy.c
> +++ b/drivers/net/dummy.c
> @@ -186,8 +186,10 @@ static int __init dummy_init_module(void)
>  	rtnl_lock();
>  	err = __rtnl_link_register(&dummy_link_ops);
>  
> -	for (i = 0; i < numdummies && !err; i++)
> +	for (i = 0; i < numdummies && !err; i++) {
>  		err = dummy_init_one();
> +		cond_resched();
> +	}

Hi, I got the following build error with this applied to 3.2, on i386
and arm builds:

linux-stable/drivers/net/dummy.c: In function 'dummy_init_module':
linux-stable/drivers/net/dummy.c:191:3: error: implicit declaration of function 'cond_resched' [-Werror=implicit-function-declaration]

This doesn't happen on mainline so far. Looking here on mainline, sched.h is
implicitly included through <linux/netdevice.h> ->
<net/netprio_cgroup.h> -> <linux/cgroup.h> -> <linux/sched.h>

But on 3.2 this doesn't happen, and build fails on i386 and arm. On
x86_64 it works though since sched.h is pulled from netdevice.h ->
ethtool.h -> compat.h if CONFIG_COMPAT is enabled.

May be the best solution is for the patch backported to 3.2, to include
<linux/sched.h> also.

>  	if (err < 0)
>  		__rtnl_link_unregister(&dummy_link_ops);
>  	rtnl_unlock();
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
