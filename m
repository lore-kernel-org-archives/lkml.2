Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab2CBBWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:22:15 -0500
Received: from mail.us.es ([193.147.175.20]:36722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070Ab2CBBWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:22:13 -0500
Date: Fri, 2 Mar 2012 02:22:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] netfilter: potential null derefence.
Message-ID: <20120302012208.GA10185@1984>
References: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:47:14PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> I am getting following error.
> " net/bridge/netfilter/ebtables.c:269 ebt_do_table()
>   error: potential null derefence 'cs'"
> 
>     i = cs[sp].n;  // If cs == Null then this will cause problem.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bridge/netfilter/ebtables.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index f3fcbd9..9c0f177 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -209,8 +209,10 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
>  	   smp_processor_id());
>  	if (private->chainstack)
>  		cs = private->chainstack[smp_processor_id()];
> -	else
> +	else {
>  		cs = NULL;

I just noticed we can remove this cs = NULL. No need to resend, I'll
mangle it myself.

> +		goto out;
> +	}
>  	chaininfo = private->hook_entry[hook];
>  	nentries = private->hook_entry[hook]->nentries;
>  	point = (struct ebt_entry *)(private->hook_entry[hook]->data);
> @@ -313,6 +315,7 @@ letscontinue:
>  		read_unlock_bh(&table->lock);
>  		return NF_ACCEPT;
>  	}
> +out:
>  	read_unlock_bh(&table->lock);
>  	return NF_DROP;
>  }
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
