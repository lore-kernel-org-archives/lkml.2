Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab2HHT7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:59:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51787 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab2HHT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:59:32 -0400
MIME-Version: 1.0
In-Reply-To: <1344454701.28967.233.camel@edumazet-glaptop>
References: <50215A7E.8000701@linaro.org>
	<502198B4.8040503@linaro.org>
	<5022BAA2.90606@us.ibm.com>
	<17464273.DGOeQvDGIE@sifl>
	<1344454701.28967.233.camel@edumazet-glaptop>
Date: Wed, 8 Aug 2012 15:59:31 -0400
Message-ID: <CACLa4ptgoge0nnEuov5E9gc2bdR-wjCo+bpB6Auhwo8jSO99oA@mail.gmail.com>
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Paris <eparis@parisplace.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 3:38 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2012-08-08 at 15:26 -0400, Paul Moore wrote:

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index ba39a52..027a331 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1524,6 +1524,10 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>         sk->sk_priority = skb->priority;
>         sk->sk_protocol = ip_hdr(skb)->protocol;
>         sk->sk_bound_dev_if = arg->bound_dev_if;
> +#ifdef CONFIG_SECURITY
> +       if (!sk->sk_security && security_sk_alloc(sk, PF_INET, GFP_ATOMIC))
> +                       goto out;
> +#endif
>         sock_net_set(sk, net);
>         __skb_queue_head_init(&sk->sk_write_queue);
>         sk->sk_sndbuf = sysctl_wmem_default;
> @@ -1539,7 +1543,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>                 skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
>                 ip_push_pending_frames(sk, &fl4);
>         }
> -
> +out:
>         put_cpu_var(unicast_sock);
>
>         ip_rt_put(rt);

Seems wrong.  We shouldn't ever need ifdef CONFIG_SECURITY in core
code.  Ifndef CONF_SECURITY then security_sk_alloc() is a static
inline return 0;   I guess the question is "Where did the sk come
from"?  Why wasn't security_sk_alloc() called when it was allocated?
Should it have been updated at some time and that wasn't done either?
Seems wrong to be putting packets on the queue for a socket where the
security data was never allocated and was never set to its proper
state.

there must be a bigger bug here...

-Eric
