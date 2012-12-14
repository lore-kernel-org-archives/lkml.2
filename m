Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2LNAxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:53:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:26354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2LNAxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:53:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,276,1355126400"; 
   d="scan'208";a="231336422"
Message-ID: <1355446409.24876.110.camel@yhuang-dev>
Subject: Re: [PATCH v4 2/3] llist: add a safe version of llist_for_each_entry
From: Huang Ying <ying.huang@intel.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, Konrad Rzeszutek Wilk <konrad@kernel.org>
Date: Fri, 14 Dec 2012 08:53:29 +0800
In-Reply-To: <1355395179-55724-2-git-send-email-roger.pau@citrix.com>
References: <1355395179-55724-1-git-send-email-roger.pau@citrix.com>
	 <1355395179-55724-2-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 11:39 +0100, Roger Pau Monne wrote:
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>

Reviewed-by: Huang Ying <ying.huang@intel.com>

> ---
> Changes since v3:
>  * Change n to use type *, to keep the same semantics as
>    list_for_each_entry_safe.
> Changes since v2:
>  * Allow to pass a NULL node as the first entry of deleted list
>    entries.
> ---
>  include/linux/llist.h |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index a5199f6..f551ac4 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -125,6 +125,35 @@ static inline void init_llist_head(struct llist_head *list)
>  	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
>  
>  /**
> + * llist_for_each_entry_safe - safely iterate over some deleted entries of
> + *                             lock-less list of given type
> + * @pos:	the type * to use as a loop cursor.
> + * @n:		another type * to use as temporary storage
> + * @node:	the fist entry of deleted list entries.
> + * @member:	the name of the llist_node with the struct.
> + *
> + * In general, some entries of the lock-less list can be traversed
> + * safely only after being removed from list, so start with an entry
> + * instead of list head.
> + *
> + * If being used on entries deleted from lock-less list directly, the
> + * traverse order is from the newest to the oldest added entry.  If
> + * you want to traverse from the oldest to the newest, you must
> + * reverse the order by yourself before traversing.
> + *
> + * n is used to store a reference to the next item llist_node, so
> + * pos can be freed while iterating.
> + */
> +#define llist_for_each_entry_safe(pos, n, node, member)		\
> +	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
> +	     (n) = llist_entry(((&(pos)->member != NULL) ?		\
> +	         (pos)->member.next : NULL), typeof(*(pos)), member);	\
> +	     &(pos)->member != NULL;					\
> +	     (pos) = n,							\
> +	     (n) = llist_entry(((&(pos)->member != NULL) ?		\
> +	         (pos)->member.next : NULL), typeof(*(pos)), member))
> +
> +/**
>   * llist_empty - tests whether a lock-less list is empty
>   * @head:	the list to test
>   *


