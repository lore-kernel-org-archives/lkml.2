Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0ICIIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:08:05 -0400
Received: from [83.228.35.12] ([83.228.35.12]:35747 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755576Ab0ICIGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:06:25 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 04:06:25 EDT
Message-ID: <4C80AB34.20501@fs.uni-ruse.bg>
Date: Fri, 03 Sep 2010 11:00:52 +0300
From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; bg; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>	 <4AUWBNzTkbD.A.ey.cGueMB@chimera> <courier.4C7C99F2.00001F74@fs.ru.acad.bg>	 <20100831192659.GA3093@del.dom.local> <1283338251.2556.124.camel@edumazet-laptop>
In-Reply-To: <1283338251.2556.124.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

На 01.9.2010 г. 13:50, Eric Dumazet написа:
> Plamen, could you test following patch ?
>
> I reproduced problem on a dev machine and following patch cured it.
>
> Thanks
>
> [PATCH] gro: fix different skb headrooms
>
> packets entering GRO might have different headrooms, even for a given
> flow (because of implementation details in drivers, like copybreak).
> We cant force drivers to deliver packets with a fixed headroom.
>
> 1) fix skb_segment()
>
> skb_segment() makes the false assumption headrooms of fragments are same
> than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
> errors, and crash later in skb_copy_and_csum_dev()
>
> 2) allocate a minimal skb for head of frag_list
>
> skb_gro_receive() uses netdev_alloc_skb(headroom + skb_gro_offset(p)) to
> allocate a fresh skb. This adds NET_SKB_PAD to a padding already
> provided by netdevice, depending on various things, like copybreak.
>
> Use alloc_skb() to allocate an exact padding, to reduce cache line
> needs:
> NET_SKB_PAD + NET_IP_ALIGN
>
> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
>
> Many thanks to Plamen Petrov, testing many debugging patches !
> With help of Jarek Poplawski.
>
> Reported-by: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> CC: Jarek Poplawski<jarkao2@gmail.com>
> ---
> patch against linux-2.6 current tree
>
>   net/core/skbuff.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3a2513f..26396ff 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2573,6 +2573,10 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
>   		__copy_skb_header(nskb, skb);
>   		nskb->mac_len = skb->mac_len;
>
> +		/* nskb and skb might have different headroom */
> +		if (nskb->ip_summed == CHECKSUM_PARTIAL)
> +			nskb->csum_start += skb_headroom(nskb) - headroom;
> +
>   		skb_reset_mac_header(nskb);
>   		skb_set_network_header(nskb, skb->mac_len);
>   		nskb->transport_header = (nskb->network_header +
> @@ -2702,8 +2706,8 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
>   	} else if (skb_gro_len(p) != pinfo->gso_size)
>   		return -E2BIG;
>
> -	headroom = skb_headroom(p);
> -	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
> +	headroom = NET_SKB_PAD + NET_IP_ALIGN;
> +	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
>   	if (unlikely(!nskb))
>   		return -ENOMEM;
>
>
>

I confirm that the above patch applied on top of v2.6.36-rc3 does not
show the problems that all the kernels since v2.6.35 (both stable
and Linus' tree) had.

My problematic machine has been running the patched 36-rc3 for 36 hours, 
and couning, with "generic receive offload" enabled only my tg3 nic.

Thank you very much for the wonderful job, Eric!
Thanks to you, too, Jarek!

Plamen Petrov
