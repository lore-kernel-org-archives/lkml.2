Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab1DNCTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:19:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44220 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DNCTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:19:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: cpusets: randomize node rotor used in cpuset_mem_spread_node()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110413143539.GB11051@tiehlicka.suse.cz>
References: <20110413143539.GB11051@tiehlicka.suse.cz>
Message-Id: <20110414111939.0812.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 14 Apr 2011 11:19:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 959a8b8..8e57a72 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -93,6 +93,7 @@
>  
>  #include <asm/tlbflush.h>
>  #include <asm/uaccess.h>
> +#include <linux/random.h>
>  
>  #include "internal.h"
>  
> @@ -1649,6 +1650,21 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
>  		return interleave_nodes(pol);
>  }
>  
> +/*
> + * Return the bit number of a random bit set in the nodemask.
> + * (returns -1 if nodemask is empty)
> + */
> +int node_random(const nodemask_t *maskp)
> +{
> +	int w, bit = -1;
> +
> +	w = nodes_weight(*maskp);
> +	if (w)
> +		bit = bitmap_ord_to_pos(maskp->bits,
> +			get_random_int() % w, MAX_NUMNODES);
> +	return bit;
> +}
> +
>  #ifdef CONFIG_HUGETLBFS
>  /*
>   * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)

mempolicy.c is no best place for putting generic nodemask utility function.
but unforunately we have no alternative. Gack.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



