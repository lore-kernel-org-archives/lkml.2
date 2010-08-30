Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0H3Vf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:35:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36229 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0H3VfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SJiNDR1WWp5ls7AyPWTK42hWIN3zZ+CwEmC/nzgbin9BOb8Qy1JIL7lLZHyKshvEeP
         gJVa719cl28iARFo58dHRBRQ7s0rjR7n+pimh5dCnLhBTkWf0Z/+5R6M8rJsFw+aIA2f
         mjvsMy6vVAyy2CMKKrGdAeWavLJz7unvAB0XA=
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bandan Das <bandan.das@stratus.com>
Cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100830200917.GA10754@stratus.com>
References: <20100830200917.GA10754@stratus.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 23:35:18 +0200
Message-ID: <1283204118.2405.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 30 août 2010 à 16:09 -0400, Bandan Das a écrit :
> The bridge layer can overwrite the IPCB using the
> BR_INPUT_SKB_CB macro. In br_nf_dev_queue_xmit, 
> if we recieve a packet greater in size than the bridge 
> device MTU, we call ip_fragment which in turn will lead to 
> icmp_send calling ip_options_echo if the DF flag is set. 
> ip_options_echo will then incorrectly try to parse the IPCB as 
> IP options resulting in a buffer overflow. 
> This change refills the CB area back with IP 
> options before ip_fragment calls icmp_send. If we fail parsing, 
> we zero out the IPCB area to guarantee that the stack does 
> not get corrupted.
> 
> Test setup that can exhibit this behavior:
> <Remote Machine>--<Host Machine>--<Bridge>--<Tun/Tap>--<KVM Guest>
>   1500 mtu          576 mtu        576 mtu   576 mtu    1500 mtu
> 
> Example of crash :
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff8146dff3
> Pid: 3173, comm: qemu-kvm Not tainted 2.6.32-63.el6.x86_64 #1
> Call Trace:
> Message from <IRQ>  syslogd@kvm at  [<ffffffff814c8285>] panic+0x78/0x137
> Aug 30 14:09:50  [<ffffffff8146dff3>] ? icmp_send+0x743/0x780
> 
> Signed-off-by: Bandan Das <bandan.das@stratus.com>
> ---
>  net/ipv4/ip_output.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index e427620..5fef4a9 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -445,6 +445,7 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  	struct iphdr *iph;
>  	int ptr;
>  	struct net_device *dev;
> +	struct ip_options *opt;
>  	struct sk_buff *skb2;
>  	unsigned int mtu, hlen, left, len, ll_rs;
>  	int offset;
> @@ -462,6 +463,16 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  
>  	if (unlikely((iph->frag_off & htons(IP_DF)) && !skb->local_df)) {
>  		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
> +
> +		/* Refill CB with IP options */
> +		opt = &(IPCB(skb)->opt);
> +		opt->optlen = iph->ihl*4 - sizeof(struct iphdr);
> +		if (ip_options_compile(dev_net(dev), opt, skb)) {
> +			IP_INC_STATS(dev_net(dev), IPSTATS_MIB_INHDRERRORS);
> +			/* If we fail, zero out IPCB and continue */
> +			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
> +		}
> +
>  		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
>  			  htonl(ip_skb_dst_mtu(skb)));
>  		kfree_skb(skb);


I wonder if we want this.

Maybe setting skb->local_df = 1 in bridge should be enough ?



