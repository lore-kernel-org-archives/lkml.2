Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1L3BSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:18:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63896 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1L3BSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:18:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111229.184842.664528940770120593.davem@davemloft.net>
References: <20111229.170514.1766899380937848638.davem@davemloft.net>
	<CACPM=kV8NwYLAdODQHxYmJ21X0RmZ8KJT9szKdY2xa-DsesvQg@mail.gmail.com>
	<CACPM=kVfsXgFhKheevTS1pm7kCoezKO3M+102O=PRbXzxebxxg@mail.gmail.com>
	<20111229.184842.664528940770120593.davem@davemloft.net>
Date: Fri, 30 Dec 2011 02:18:46 +0100
X-Google-Sender-Auth: uKqYpuUw_V8EjqJ3PAB3Fgx1uSM
Message-ID: <CACPM=kUy6RfHe48LRp-mcLHRia31g+DoJHXQFuk3tTBQnE1m7A@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: David Miller <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, shemminger@vyatta.com, bhutchings@solarflare.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/30 David Miller <davem@davemloft.net>:
> From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
> Date: Fri, 30 Dec 2011 00:37:17 +0100
>
>> Hmm, it seems like this problem isn't related to the driver, but
>> related to the current HEAD of net-next :)
>
> Please try this patch.
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 30de9e7..4a62c47 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -129,11 +129,14 @@ static struct neighbour *ip6_neigh_lookup(const struct dst_entry *dst, const voi
>        return neigh_create(&nd_tbl, daddr, dst->dev);
>  }
>
> -static int rt6_bind_neighbour(struct rt6_info *rt)
> +static int rt6_bind_neighbour(struct rt6_info *rt, struct net_device *dev)
>  {
> -       struct neighbour *n = ip6_neigh_lookup(&rt->dst, &rt->rt6i_gateway);
> -       if (IS_ERR(n))
> -               return PTR_ERR(n);
> +       struct neighbour *n = __ipv6_neigh_lookup(&nd_tbl, dev, &rt->rt6i_gateway);
> +       if (!n) {
> +               n = neigh_create(&nd_tbl, &rt->rt6i_gateway, dev);
> +               if (IS_ERR(n))
> +                       return PTR_ERR(n);
> +       }
>        dst_set_neighbour(&rt->dst, n);
>
>        return 0;
> @@ -746,7 +749,7 @@ static struct rt6_info *rt6_alloc_cow(const struct rt6_info *ort,
>  #endif
>
>        retry:
> -               if (rt6_bind_neighbour(rt)) {
> +               if (rt6_bind_neighbour(rt, rt->dst.dev)) {
>                        struct net *net = dev_net(rt->dst.dev);
>                        int saved_rt_min_interval =
>                                net->ipv6.sysctl.ip6_rt_gc_min_interval;
> @@ -1397,7 +1400,7 @@ int ip6_route_add(struct fib6_config *cfg)
>                rt->rt6i_prefsrc.plen = 0;
>
>        if (cfg->fc_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) {
> -               err = rt6_bind_neighbour(rt);
> +               err = rt6_bind_neighbour(rt, dev);
>                if (err)
>                        goto out;
>        }
> @@ -2084,7 +2087,7 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
>                rt->rt6i_flags |= RTF_ANYCAST;
>        else
>                rt->rt6i_flags |= RTF_LOCAL;
> -       err = rt6_bind_neighbour(rt);
> +       err = rt6_bind_neighbour(rt, rt->dst.dev);
>        if (err) {
>                dst_free(&rt->dst);
>                return ERR_PTR(err);

Hey David,

That patch works, now it boots fine :)
I tried the driver on the 3.1.6 kernel to make sure nothing not tested
is causing problems.

/Bjarke

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
