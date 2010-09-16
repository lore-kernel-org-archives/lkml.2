Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0IPGSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:18:41 -0400
Received: from stinky.trash.net ([213.144.137.162]:36036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0IPGSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:18:40 -0400
Message-ID: <4C91B6BE.8020300@trash.net>
Date: Thu, 16 Sep 2010 08:18:38 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] netfilter: save the hash of the tuple in the original
 direction for latter use
References: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.2010 00:49, Changli Gao wrote:
> Since we don't change the tuple in the original direction, we can save it
> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
> use.

I like this idea. We could actually do the same for the reply tuple
and invalidate the saved hash in case the reply tuple is changed
(nf_conntrack_alter_reply()), which only happens when NAT is used.

> __hash_conntrack() is split into two steps: ____hash_conntrack() is used
> to get the raw hash, and __hash_bucket() is used to get the bucket id.

This patch uses underscores a bit excessively, how about renaming:

- ____hash_conntrack() => hash_conntrack_raw()
- __hash variables => hash
- hash variables => bucket

> @@ -408,7 +438,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  		return NF_ACCEPT;
>  
>  	zone = nf_ct_zone(ct);
> -	hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> +	/* reuse the __hash saved before */
> +	hash = hash_bucket(*(unsigned long *)&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev, net);

Please try to stay at least close to the 80 characters limit.
