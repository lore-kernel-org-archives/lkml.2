Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1HOFzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:55:25 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49105 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1HOFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:55:23 -0400
Message-ID: <4E48B4B6.8000603@gmail.com>
Date: Sun, 14 Aug 2011 22:55:02 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: ip_rt_bug: 10.0.0.52 -> 255.255.255.255, ?
References: <4E4898F5.8050605@gmail.com> <20110814.224536.1330937123770047026.davem@davemloft.net>
In-Reply-To: <20110814.224536.1330937123770047026.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh.. guess I will wait for those to be put into the Mainline then. 
Thanks for the info!

>
> First, please contact netdev@vger.kernel.org for networking issues.
>
> Second, this is fixed already:
>
> commit d547f727df86059104af2234804fdd538e112015
> Author: Julian Anastasov<ja@ssi.bg>
> Date:   Sun Aug 7 22:20:20 2011 -0700
>
>      ipv4: fix the reusing of routing cache entries
>
>      	compare_keys and ip_route_input_common rely on
>      rt_oif for distinguishing of input and output routes
>      with same keys values. But sometimes the input route has
>      also same hash chain (keyed by iif != 0) with the output
>      routes (keyed by orig_oif=0). Problem visible if running
>      with small number of rhash_entries.
>
>      	Fix them to use rt_route_iif instead. By this way
>      input route can not be returned to users that request
>      output route.
>
>      	The patch fixes the ip_rt_bug errors that were
>      reported in ip_local_out context, mostly for 255.255.255.255
>      destinations.
>
>      Signed-off-by: Julian Anastasov<ja@ssi.bg>
>      Signed-off-by: David S. Miller<davem@davemloft.net>
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index e3dec1c..cb7efe0 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -731,6 +731,7 @@ static inline int compare_keys(struct rtable *rt1, struct rtable *rt2)
>   		((__force u32)rt1->rt_key_src ^ (__force u32)rt2->rt_key_src) |
>   		(rt1->rt_mark ^ rt2->rt_mark) |
>   		(rt1->rt_key_tos ^ rt2->rt_key_tos) |
> +		(rt1->rt_route_iif ^ rt2->rt_route_iif) |
>   		(rt1->rt_oif ^ rt2->rt_oif) |
>   		(rt1->rt_iif ^ rt2->rt_iif)) == 0;
>   }
> @@ -2321,8 +2322,8 @@ int ip_route_input_common(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>   		if ((((__force u32)rth->rt_key_dst ^ (__force u32)daddr) |
>   		     ((__force u32)rth->rt_key_src ^ (__force u32)saddr) |
>   		     (rth->rt_iif ^ iif) |
> -		     rth->rt_oif |
>   		     (rth->rt_key_tos ^ tos)) == 0&&
> +		    rt_is_input_route(rth)&&
>   		rth->rt_mark == skb->mark&&
>   		net_eq(dev_net(rth->dst.dev), net)&&
>   		!rt_is_expired(rth)) {
>
>
>

