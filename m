Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2GMOJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:09:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab2GMOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:09:18 -0400
Date: Fri, 13 Jul 2012 11:09:10 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 08/68] dummy: fix rcu_sched self-detected stalls
Message-ID: <20120713140909.GA3185@herton-Z68MA-D2H-B3>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
 <20120712175036.147190749@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712175036.147190749@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 04:01:42PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/dummy.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/drivers/net/dummy.c
> +++ b/drivers/net/dummy.c
> @@ -186,8 +186,10 @@ static int __init dummy_init_module(void
>  	rtnl_lock();
>  	err = __rtnl_link_register(&dummy_link_ops);
>  
> -	for (i = 0; i < numdummies && !err; i++)
> +	for (i = 0; i < numdummies && !err; i++) {
>  		err = dummy_init_one();
> +		cond_resched();

This cherry-pick for 3.0 has the same problem as the one that was
proposed to 3.2, build fails on i386/arm:

linux-stable/drivers/net/dummy.c: In function 'dummy_init_module':
linux-stable/drivers/net/dummy.c:191:3: error: implicit declaration of function 'cond_resched' [-Werror=implicit-function-declaration]

This will need an include for linux/sched.h as in 3.2 (the same proposed
patch for 3.4 shouldn't be affected).

> +	}
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
