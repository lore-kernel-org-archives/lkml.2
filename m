Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030931Ab2HIPHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:07:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36369 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2HIPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:07:21 -0400
From: Paul Moore <paul@paul-moore.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@parisplace.org>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipv4: tcp: security_sk_alloc() needed for unicast_sock
Date: Thu, 09 Aug 2012 11:07:15 -0400
Message-ID: <5799181.tjlnF0gIh2@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1344523833.28967.996.camel@edumazet-glaptop>
References: <50215A7E.8000701@linaro.org> <1695034.0lrQgQPOMT@sifl> <1344523833.28967.996.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012 04:50:33 PM Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit be9f4a44e7d41cee (ipv4: tcp: remove per net tcp_sock) added a
> selinux regression, reported and bisected by John Stultz
> 
> selinux_ip_postroute_compat() expect to find a valid sk->sk_security
> pointer, but this field is NULL for unicast_sock
> 
> Fix this by adding a new 'kernel' parameter to security_sk_alloc(),
> set to true if socket might already have a valid sk->sk_security
> pointer. ip_send_unicast_reply() uses a percpu fake socket, so the first
> call to security_sk_alloc() will populate sk->sk_security pointer,
> subsequent ones will reuse existing context.
> 
> Reported-by: John Stultz <johnstul@us.ibm.com>
> Bisected-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>

...

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 76dde25..b233d6e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1524,6 +1524,8 @@ void ip_send_unicast_reply(struct net *net, struct
> sk_buff *skb, __be32 daddr, sk->sk_priority = skb->priority;
>  	sk->sk_protocol = ip_hdr(skb)->protocol;
>  	sk->sk_bound_dev_if = arg->bound_dev_if;
> +	if (security_sk_alloc(sk, PF_INET, GFP_ATOMIC, true))
> +		goto out;
>  	sock_net_set(sk, net);
>  	__skb_queue_head_init(&sk->sk_write_queue);
>  	sk->sk_sndbuf = sysctl_wmem_default;

Is is possible to do the call to security_sk_alloc() in the ip_init() function 
or does the per-cpu nature of the socket make this a pain?

-- 
paul moore
www.paul-moore.com

