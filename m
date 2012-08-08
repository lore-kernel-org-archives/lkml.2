Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030845Ab2HHTux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:50:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030484Ab2HHTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:50:52 -0400
From: Paul Moore <paul@paul-moore.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
Date: Wed, 08 Aug 2012 15:50:47 -0400
Message-ID: <1469977.Edv3iizobX@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1344454701.28967.233.camel@edumazet-glaptop>
References: <50215A7E.8000701@linaro.org> <17464273.DGOeQvDGIE@sifl> <1344454701.28967.233.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 09:38:21 PM Eric Dumazet wrote:
> On Wed, 2012-08-08 at 15:26 -0400, Paul Moore wrote:
> > On Wednesday, August 08, 2012 12:14:42 PM John Stultz wrote:
> > > So I bisected this down and it seems to be the following commit:
> > > 
> > > commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
> > > Author: Eric Dumazet <edumazet@google.com>
> > > Date:   Thu Jul 19 07:34:03 2012 +0000
> > > 
> > >      ipv4: tcp: remove per net tcp_sock
> > > 
> > > It doesn't revert totally cleanly, but after fixing up the rejections
> > > and booting with this patch removed on top of Linus' head the oops on
> > > shutdown goes away.
> > 
> > Thanks!
> > 
> > It looks the like there is a bug in ip_send_unicast_reply() which uses a
> > inet_sock/sock struct which does not have the LSM data properly
> > initialized.
> > 
> > I'll put together a patch shortly.
> 
> Something like this ?

Yep.  I was just trying to see if there was a way we could avoid having to 
make it conditional on CONFIG_SECURITY, but I think this is a better approach 
than the alternatives.

I'm also looking into making sure we get a sane LSM label on the per-cpu sock 
as security_sk_alloc() just allocates and initializes the LSM blob to a basic 
starting value (unlabeled_t in the case of SELinux) ... that is likely to be 
the tricky bit.

Regardless, I'm okay with us merging the patch below now to fix the panic and 
I'll supply a follow-up patch to fix the labeling once I figure out a solution 
that seems reasonable.  Does that work for you?  David?

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index ba39a52..027a331 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1524,6 +1524,10 @@ void ip_send_unicast_reply(struct net *net, struct
> sk_buff *skb, __be32 daddr, sk->sk_priority = skb->priority;
>  	sk->sk_protocol = ip_hdr(skb)->protocol;
>  	sk->sk_bound_dev_if = arg->bound_dev_if;
> +#ifdef CONFIG_SECURITY
> +	if (!sk->sk_security && security_sk_alloc(sk, PF_INET, GFP_ATOMIC))
> +			goto out;
> +#endif
>  	sock_net_set(sk, net);
>  	__skb_queue_head_init(&sk->sk_write_queue);
>  	sk->sk_sndbuf = sysctl_wmem_default;
> @@ -1539,7 +1543,7 @@ void ip_send_unicast_reply(struct net *net, struct
> sk_buff *skb, __be32 daddr, skb_set_queue_mapping(nskb,
> skb_get_queue_mapping(skb));
>  		ip_push_pending_frames(sk, &fl4);
>  	}
> -
> +out:
>  	put_cpu_var(unicast_sock);
> 
>  	ip_rt_put(rt);

-- 
paul moore
www.paul-moore.com

