Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1G2Ojw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:39:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:56561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1G2Oju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:39:50 -0400
Message-ID: <4E32C633.5000205@trash.net>
Date: Fri, 29 Jul 2011 16:39:47 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH][RFC] netfilter: Fix small leak in ipq_build_packet_message()
References: <alpine.LNX.2.00.1107171942400.32359@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107171942400.32359@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2011 19:46, Jesper Juhl wrote:
> ipq_build_packet_message() in net/ipv4/netfilter/ip_queue.c and
> net/ipv6/netfilter/ip6_queue.c contain a small potential mem leak as
> far as I can tell.
> 
> We allocate memory for 'skb' with alloc_skb() annd then call
>  nlh = NLMSG_PUT(skb, 0, 0, IPQM_PACKET, size - sizeof(*nlh));
> 
> NLMSG_PUT is a macro
>  NLMSG_PUT(skb, pid, seq, type, len) \
>   		NLMSG_NEW(skb, pid, seq, type, len, 0)
> 
> that expands to NLMSG_NEW, which is also a macro which expands to:
>  NLMSG_NEW(skb, pid, seq, type, len, flags) \
>   	({	if (unlikely(skb_tailroom(skb) < (int)NLMSG_SPACE(len))) \
>   			goto nlmsg_failure; \
>   		__nlmsg_put(skb, pid, seq, type, len, flags); })
> 
> If we take the true branch of the 'if' statement and 'goto
> nlmsg_failure', then we'll, at that point, return from
> ipq_build_packet_message() without having assigned 'skb' to anything
> and we'll leak the memory we allocated for it when it goes out of
> scope.
> 
> Fix this by placing a 'kfree(skb)' at 'nlmsg_failure'.
> 
> I admit that I do not know how likely this to actually happen or even
> if there's something that guarantees that it will never happen - I'm
> not that familiar with this code, but if that is so, I've not been
> able to spot it.
> 
> Please review and commit if you believe this is correct. Thanks.
> 

Looks correct, applied, thanks.
