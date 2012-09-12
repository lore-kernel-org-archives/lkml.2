Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2ILIIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:08:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43587 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2ILIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:07:34 -0400
Subject: Re: [PATCH] netfilter/iptables: Fix log-level processing
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: auto75914331@hushmail.com, Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1347435973.2456.23.camel@joe2Laptop>
References: <20120912045120.9E1A76F446@smtp.hushmail.com>
	 <1347435973.2456.23.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Sep 2012 10:07:25 +0200
Message-ID: <1347437245.13103.697.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 00:46 -0700, Joe Perches wrote:
> auto75914331@hushmail.com reports that iptables does not correctly
> output the KERN_<level>.
> 
> $IPTABLES -A RULE_0_in  -j LOG  --log-level notice --log-prefix "DENY  in: "
> 
> result with linux 3.6-rc5
> Sep 12 06:37:29 xxxxx kernel: <5>DENY  in: IN=eth0 OUT= MAC=.......
> 
> result with linux 3.5.3 and older:
> Sep  9 10:43:01 xxxxx kernel: DENY  in: IN=eth0 OUT= MAC......
> 
> commit 04d2c8c83d0
> ("printk: convert the format for KERN_<LEVEL> to a 2 byte pattern")
> updated the syslog header style but did not update netfilter uses.
> 
> Do so.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: auto75914331@hushmail.com
> ---
>  net/bridge/netfilter/ebt_log.c |    4 ++--
>  net/netfilter/xt_LOG.c         |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
> index f88ee53..cb46d2f 100644
> --- a/net/bridge/netfilter/ebt_log.c
> +++ b/net/bridge/netfilter/ebt_log.c
> @@ -80,8 +80,8 @@ ebt_log_packet(u_int8_t pf, unsigned int hooknum,
>  	unsigned int bitmask;
>  
>  	spin_lock_bh(&ebt_log_lock);
> -	printk("<%c>%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
> -	       '0' + loginfo->u.log.level, prefix,
> +	printk("%c%c%s IN=%s OUT=%s MAC source = %pM MAC dest = %pM proto = 0x%04x",
> +	       KERN_SOH_ASCII, '0' + loginfo->u.log.level, prefix,
>  	       in ? in->name : "", out ? out->name : "",
>  	       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
>  	       ntohs(eth_hdr(skb)->h_proto));
> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
> index ff5f75f..bdc5352 100644
> --- a/net/netfilter/xt_LOG.c
> +++ b/net/netfilter/xt_LOG.c
> @@ -436,8 +436,8 @@ log_packet_common(struct sbuff *m,
>  		  const struct nf_loginfo *loginfo,
>  		  const char *prefix)
>  {
> -	sb_add(m, "<%d>%sIN=%s OUT=%s ", loginfo->u.log.level,
> -	       prefix,
> +	sb_add(m, "%c%c%sIN=%s OUT=%s ",
> +	       KERN_SOH_ASCII, '0' + loginfo->u.log.level, prefix,
>  	       in ? in->name : "",
>  	       out ? out->name : "");
>  #ifdef CONFIG_BRIDGE_NETFILTER
> 

would be better to avoid the %c

->

 sb_add(m, KERN_SOH "%c%sIN=%s OUT=%s ",
	'0' + loginfo->u.log.level, prefix,


