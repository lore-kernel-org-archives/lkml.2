Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2GPMcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:32:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46332 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GPMca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:32:30 -0400
Subject: Re: [PATCH] net-next: make sock diag per-namespace
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1342440849-1757320-1-git-send-email-avagin@openvz.org>
References: <1342440849-1757320-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 14:32:25 +0200
Message-ID: <1342441945.23494.23.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 16:14 +0400, Andrew Vagin wrote:
> Before this patch sock_diag works for init_net only and dumps
> information about sockets from all namespaces.

...

> diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
> index a7f86a3..52f42f9 100644
> --- a/net/ipv4/udp_diag.c
> +++ b/net/ipv4/udp_diag.c
> @@ -34,6 +34,7 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
>  	int err = -EINVAL;
>  	struct sock *sk;
>  	struct sk_buff *rep;
> +	struct net *net = sock_net(in_skb->sk);
>  
>  	if (req->sdiag_family == AF_INET)
>  		sk = __udp4_lib_lookup(&init_net,

It seems you didnt fix udp_dump_one() correctly, since it
still mentions &init_net

> @@ -75,7 +76,7 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
>  		kfree_skb(rep);
>  		goto out;
>  	}
> -	err = netlink_unicast(sock_diag_nlsk, rep, NETLINK_CB(in_skb).pid,
> +	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).pid,
>  			      MSG_DONTWAIT);
>  	if (err > 0)
>  		err = 0;

udp_dump() also needs some care ?


