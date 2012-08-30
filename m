Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2H3BMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 21:12:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38241 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2H3BMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 21:12:20 -0400
Date: Thu, 30 Aug 2012 10:12:15 +0900
From: Simon Horman <horms@verge.net.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Wensong Zhang <wensong@linux-vs.org>, kernel-janitors@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ipvs: fix error return code
Message-ID: <20120830011215.GL4127@verge.net.au>
References: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
 <1346258957-7649-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346258957-7649-2-git-send-email-Julia.Lawall@lip6.fr>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:49:11PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize return variable before exiting on an error path.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 3c60137..767cc12 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1171,8 +1171,10 @@ ip_vs_add_service(struct net *net, struct ip_vs_service_user_kern *u,
>  		goto out_err;
>  	}
>  	svc->stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
> -	if (!svc->stats.cpustats)
> +	if (!svc->stats.cpustats) {
> +		ret = -ENOMEM;
>  		goto out_err;
> +	}
>  
>  	/* I'm the first user of the service */
>  	atomic_set(&svc->usecnt, 0);

Acked-by: Simon Horman <horms@verge.net.au>
