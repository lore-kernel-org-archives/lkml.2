Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2EKE5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:57:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57162 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2EKE5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:57:54 -0400
Date: Fri, 11 May 2012 00:57:40 -0400 (EDT)
Message-Id: <20120511.005740.210437168371869566.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-11-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-11-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 21:57:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:45:03 +0100

> +/* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
> +bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);

I know this gets added in an earlier patch, but it seems slightly
overkill to have a function call just for a simply bit test.

> +extern atomic_t memalloc_socks;
> +static inline int sk_memalloc_socks(void)
> +{
> +	return atomic_read(&memalloc_socks);
> +}

Please change this to be a static branch.

> +	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask,
> +						SKB_ALLOC_RX, NUMA_NO_NODE);

Please fix the argument indentation.

> +	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
> +		       gfp_mask, NUMA_NO_NODE, NULL);

Likewise.

> -	struct sk_buff *n = alloc_skb(newheadroom + skb->len + newtailroom,
> -				      gfp_mask);
> +	struct sk_buff *n = __alloc_skb(newheadroom + skb->len + newtailroom,
> +				      gfp_mask, skb_alloc_rx_flag(skb),
> +				      NUMA_NO_NODE);

Likewise.

> -			nskb = alloc_skb(hsize + doffset + headroom,
> -					 GFP_ATOMIC);
> +			nskb = __alloc_skb(hsize + doffset + headroom,
> +					 GFP_ATOMIC, skb_alloc_rx_flag(skb),
> +					 NUMA_NO_NODE);

Likewise.
