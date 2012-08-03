Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2HCJRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:17:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53034 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2HCJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:17:15 -0400
Subject: Re: [PATCH 1/7] netpoll: use GFP_ATOMIC in slave_enable_netpoll()
 and __netpoll_setup()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1343403484-29347-2-git-send-email-amwang@redhat.com>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
	 <1343403484-29347-2-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Aug 2012 11:17:08 +0200
Message-ID: <1343985428.9299.868.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 23:37 +0800, Cong Wang wrote:
> slave_enable_netpoll() and __netpoll_setup() may be called
> with read_lock() held, so should use GFP_ATOMIC to allocate
> memory.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c |    2 +-
>  net/core/netpoll.c              |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 6fae5f3..ab773d4 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1235,7 +1235,7 @@ static inline int slave_enable_netpoll(struct slave *slave)
>  	struct netpoll *np;
>  	int err = 0;
>  
> -	np = kzalloc(sizeof(*np), GFP_KERNEL);
> +	np = kzalloc(sizeof(*np), GFP_ATOMIC);
>  	err = -ENOMEM;
>  	if (!np)
>  		goto out;
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index b4c90e4..c78a966 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -734,7 +734,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
>  	}
>  
>  	if (!ndev->npinfo) {
> -		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
> +		npinfo = kmalloc(sizeof(*npinfo), GFP_ATOMIC);
>  		if (!npinfo) {
>  			err = -ENOMEM;
>  			goto out;

Yes this works, but maybe you instead could pass/add a gfp_t flags
argument to __netpoll_setup() ?

Management tasks should allow GFP_KERNEL allocations to have less
failure risks.

Its sad bonding uses the rwlock here instead of a mutex



