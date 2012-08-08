Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834Ab2HHTu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:50:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46686 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab2HHTuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:50:22 -0400
Message-ID: <5022C2D5.3050208@us.ibm.com>
Date: Wed, 08 Aug 2012 12:49:41 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Paul Moore <paul@paul-moore.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
References: <50215A7E.8000701@linaro.org> <502198B4.8040503@linaro.org> <5022BAA2.90606@us.ibm.com>  <17464273.DGOeQvDGIE@sifl> <1344454701.28967.233.camel@edumazet-glaptop>
In-Reply-To: <1344454701.28967.233.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080819-1976-0000-0000-00000FFD3F87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 12:38 PM, Eric Dumazet wrote:
> On Wed, 2012-08-08 at 15:26 -0400, Paul Moore wrote:
>> It looks the like there is a bug in ip_send_unicast_reply() which uses a
>> inet_sock/sock struct which does not have the LSM data properly initialized.
>>
>> I'll put together a patch shortly.
> Something like this ?
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index ba39a52..027a331 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1524,6 +1524,10 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>   	sk->sk_priority = skb->priority;
>   	sk->sk_protocol = ip_hdr(skb)->protocol;
>   	sk->sk_bound_dev_if = arg->bound_dev_if;
> +#ifdef CONFIG_SECURITY
> +	if (!sk->sk_security && security_sk_alloc(sk, PF_INET, GFP_ATOMIC))
> +			goto out;
> +#endif
>   	sock_net_set(sk, net);
>   	__skb_queue_head_init(&sk->sk_write_queue);
>   	sk->sk_sndbuf = sysctl_wmem_default;
> @@ -1539,7 +1543,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>   		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
>   		ip_push_pending_frames(sk, &fl4);
>   	}
> -
> +out:
>   	put_cpu_var(unicast_sock);
>
>   	ip_rt_put(rt);

I can't comment on the patch itself, but I tested it against Linus' HEAD 
and it seems to resolve the oops on shutdown for me.

thanks
-john

