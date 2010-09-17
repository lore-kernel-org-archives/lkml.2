Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0IQXEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:04:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45072
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab0IQXE3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:04:29 -0400
Date: Fri, 17 Sep 2010 16:04:47 -0700 (PDT)
Message-Id: <20100917.160447.146098756.davem@davemloft.net>
To: remi@remlab.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        remi.denis-courmont@nokia.com, ebiederm@xmission.com,
        stable@kernel.org
Subject: Re: [PATCH stable-2.6.32] Phonet: disable network namespace support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284763006-22075-1-git-send-email-remi@remlab.net>
References: <1284763006-22075-1-git-send-email-remi@remlab.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>
Date: Sat, 18 Sep 2010 01:36:46 +0300

> From: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
> 
> Network namespace in the Phonet socket stack causes an OOPS when a
> namespace is destroyed. This occurs as the loopback exit_net handler is
> called after the Phonet exit_net handler, and re-enters the Phonet
> stack. I cannot think of any nice way to fix this in kernel <= 2.6.32.
> 
> For lack of a better solution, disable namespace support completely.
> If you need that, upgrade to a newer kernel.
> 
> Signed-off-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>

"lkml" address fixed, and -stable CC: added this time, please don't
omit that if you want to submit stable networking patches that have no
upstream counterpart.

Acked-by: David S. Miller <davem@davemloft.net>

> ---
>  net/phonet/af_phonet.c  |    4 ++++
>  net/phonet/pn_dev.c     |   12 ++++++++++--
>  net/phonet/pn_netlink.c |    9 ++++++++-
>  3 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
> index f60c0c2..519ff9d 100644
> --- a/net/phonet/af_phonet.c
> +++ b/net/phonet/af_phonet.c
> @@ -67,6 +67,8 @@ static int pn_socket_create(struct net *net, struct socket *sock, int protocol)
>  	struct phonet_protocol *pnp;
>  	int err;
>  
> +	if (!net_eq(net, &init_net))
> +		return -EAFNOSUPPORT;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> @@ -353,6 +355,8 @@ static int phonet_rcv(struct sk_buff *skb, struct net_device *dev,
>  	struct sockaddr_pn sa;
>  	u16 len;
>  
> +	if (!net_eq(net, &init_net))
> +		goto out;
>  	/* check we have at least a full Phonet header */
>  	if (!pskb_pull(skb, sizeof(struct phonethdr)))
>  		goto out;
> diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
> index 5f42f30..5a2275c 100644
> --- a/net/phonet/pn_dev.c
> +++ b/net/phonet/pn_dev.c
> @@ -246,7 +246,11 @@ static struct notifier_block phonet_device_notifier = {
>  /* Per-namespace Phonet devices handling */
>  static int phonet_init_net(struct net *net)
>  {
> -	struct phonet_net *pnn = kmalloc(sizeof(*pnn), GFP_KERNEL);
> +	struct phonet_net *pnn;
> +
> +	if (!net_eq(net, &init_net))
> +		return 0;
> +	pnn = kmalloc(sizeof(*pnn), GFP_KERNEL);
>  	if (!pnn)
>  		return -ENOMEM;
>  
> @@ -263,9 +267,13 @@ static int phonet_init_net(struct net *net)
>  
>  static void phonet_exit_net(struct net *net)
>  {
> -	struct phonet_net *pnn = net_generic(net, phonet_net_id);
> +	struct phonet_net *pnn;
>  	struct net_device *dev;
>  
> +	if (!net_eq(net, &init_net))
> +		return;
> +	pnn = net_generic(net, phonet_net_id);
> +
>  	rtnl_lock();
>  	for_each_netdev(net, dev)
>  		phonet_device_destroy(dev);
> diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
> index d21fd35..7acab1e 100644
> --- a/net/phonet/pn_netlink.c
> +++ b/net/phonet/pn_netlink.c
> @@ -68,6 +68,8 @@ static int addr_doit(struct sk_buff *skb, struct nlmsghdr *nlh, void *attr)
>  	int err;
>  	u8 pnaddr;
>  
> +	if (!net_eq(net, &init_net))
> +		return -EOPNOTSUPP;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> @@ -124,12 +126,16 @@ nla_put_failure:
>  
>  static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
>  {
> +	struct net *net = sock_net(skb->sk);
>  	struct phonet_device_list *pndevs;
>  	struct phonet_device *pnd;
>  	int dev_idx = 0, dev_start_idx = cb->args[0];
>  	int addr_idx = 0, addr_start_idx = cb->args[1];
>  
> -	pndevs = phonet_device_list(sock_net(skb->sk));
> +	if (!net_eq(net, &init_net))
> +		goto skip;
> +
> +	pndevs = phonet_device_list(net);
>  	spin_lock_bh(&pndevs->lock);
>  	list_for_each_entry(pnd, &pndevs->list, list) {
>  		u8 addr;
> @@ -154,6 +160,7 @@ static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  out:
>  	spin_unlock_bh(&pndevs->lock);
> +skip:
>  	cb->args[0] = dev_idx;
>  	cb->args[1] = addr_idx;
>  
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
