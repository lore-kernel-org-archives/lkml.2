Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0EYHWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:22:47 -0400
Received: from canardo.mork.no ([148.122.252.1]:53580 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0EYHWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:22:44 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 03:22:44 EDT
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [01/34] ipv4: udp: fix short packet and bad checksum logging
Organization: m
References: <20100524230349.439835687@clark.site>
Date: Tue, 25 May 2010 09:08:59 +0200
In-Reply-To: <20100524230349.439835687@clark.site> (Greg KH's message of "Mon,
	24 May 2010 15:59:33 -0700")
Message-ID: <87zkzoqwz8.fsf@nemi.mork.no>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> 2.6.34-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Bjørn Mork <bjorn@mork.no>
>
> commit ccc2d97cb7c798e785c9f198de243e2b59f7073b upstream.

This is already in 2.6.34 AFAIK.



Bjørn

> commit 2783ef23 moved the initialisation of saddr and daddr after
> pskb_may_pull() to avoid a potential data corruption.  Unfortunately
> also placing it after the short packet and bad checksum error paths,
> where these variables are used for logging.  The result is bogus
> output like
>
> [92238.389505] UDP: short packet: From 2.0.0.0:65535 23715/178 to 0.0.0.0:65535
>
> Moving the saddr and daddr initialisation above the error paths, while still
> keeping it after the pskb_may_pull() to keep the fix from commit 2783ef23.
>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  net/ipv4/udp.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1292,6 +1292,9 @@ int __udp4_lib_rcv(struct sk_buff *skb,
>  
>  	uh   = udp_hdr(skb);
>  	ulen = ntohs(uh->len);
> +	saddr = ip_hdr(skb)->saddr;
> +	daddr = ip_hdr(skb)->daddr;
> +
>  	if (ulen > skb->len)
>  		goto short_packet;
>  
> @@ -1305,9 +1308,6 @@ int __udp4_lib_rcv(struct sk_buff *skb,
>  	if (udp4_csum_init(skb, uh, proto))
>  		goto csum_error;
>  
> -	saddr = ip_hdr(skb)->saddr;
> -	daddr = ip_hdr(skb)->daddr;
> -
>  	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
>  		return __udp4_lib_mcast_deliver(net, skb, uh,
>  				saddr, daddr, udptable);
