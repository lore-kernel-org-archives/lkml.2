Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1G0Rlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:41:44 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:40339 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab1G0Rlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:41:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=OGy6gif6xesx7OCzeG1/BjrdwUdPflxiFm72uPgpxibCUTe03FcHG454Aq7ZagW3;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4E304DCA.503@earthlink.net>
Date: Wed, 27 Jul 2011 13:41:30 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: tgraf@infradead.org, davem@davemloft.net, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] [10/98] ipv6: add special mode accept_ra=2 to accept
 RA while configured as router
References: <20110726534.972201586@firstfloor.org> <20110727003502.28C332403FF@tassilo.jf.intel.com>
In-Reply-To: <20110727003502.28C332403FF@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79899fc47060b31e40eb6b69a146cbd889350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 08:35 PM, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Thomas Graf<tgraf@infradead.org>
>
> [ upstream commit 65e9b62d4503849b10bedfc29bff0473760cc597 ]
>
> The current IPv6 behavior is to not accept router advertisements while
> forwarding, i.e. configured as router.
>
> This does make sense, a router is typically not supposed to be auto
> configured. However there are exceptions and we should allow the
> current behavior to be overwritten.
>
> Therefore this patch enables the user to overrule the "if forwarding
> enabled then don't listen to RAs" rule by setting accept_ra to the
> special value of 2.
>
> An alternative would be to ignore the forwarding switch alltogether
> and solely accept RAs based on the value of accept_ra. However, I
> found that if not intended, accepting RAs as a router can lead to
> strange unwanted behavior therefore we it seems wise to only do so
> if the user explicitely asks for this behavior.
>
> Signed-off-by: Thomas Graf<tgraf@infradead.org>
> Signed-off-by: David S. Miller<davem@davemloft.net>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>
> Index: linux-2.6.35.y/net/ipv6/ndisc.c
> ===================================================================
> --- linux-2.6.35.y.orig/net/ipv6/ndisc.c
> +++ linux-2.6.35.y/net/ipv6/ndisc.c
> @@ -1105,6 +1105,18 @@ errout:
>   	rtnl_set_sk_err(net, RTNLGRP_ND_USEROPT, err);
>   }
>
> +static inline int accept_ra(struct inet6_dev *in6_dev)
> +{
> +	/*
> +	 * If forwarding is enabled, RA are not accepted unless the special
> +	 * hybrid mode (accept_ra=2) is enabled.
> +	 */
> +	if (in6_dev->cnf.forwarding&&  in6_dev->cnf.accept_ra<  2)
> +		return 0;
> +
> +	return in6_dev->cnf.accept_ra;
> +}
> +
>   static void ndisc_router_discovery(struct sk_buff *skb)
>   {
>   	struct ra_msg *ra_msg = (struct ra_msg *)skb_transport_header(skb);
> @@ -1158,8 +1170,7 @@ static void ndisc_router_discovery(struc
>   		return;
>   	}
>
> -	/* skip route and link configuration on routers */
> -	if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
> +	if (!accept_ra(in6_dev))
>   		goto skip_linkparms;
>
>   #ifdef CONFIG_IPV6_NDISC_NODETYPE
> @@ -1309,8 +1320,7 @@ skip_linkparms:
>   			     NEIGH_UPDATE_F_ISROUTER);
>   	}
>
> -	/* skip route and link configuration on routers */
> -	if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
> +	if (!accept_ra(in6_dev))
>   		goto out;
>
>   #ifdef CONFIG_IPV6_ROUTE_INFO
>
>    
Hi Andi,

I only saw patches upto 38/98 so I don't know whether the following is 
also included but it should be.
It is a corresponding patch to the one above.

author    Thomas Graf <tgraf@infradead.org>
Fri, 3 Sep 2010 03:04:20 +0000 (03:04 +0000)
committer    David S. Miller <davem@davemloft.net>
Fri, 3 Sep 2010 16:43:14 +0000 (09:43 -0700)
commit    c3bccac2fa76f1619dfe4fb7b9bee69de7f066d8
tree    f2271f01bae9c3d5c0557a550d62757b0061bf63    tree | snapshot
parent    65e9b62d4503849b10bedfc29bff0473760cc597    commit | diff
ipv6: add special mode forwarding=2 to send RS while configured as router

Similar to accepting router advertisement, the IPv6 stack does not send 
router
solicitations if forwarding is enabled.

This patch enables this behavior to be overruled by setting forwarding 
to the
special value 2.

-

