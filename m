Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2LKAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:51:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:28827 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2LKAv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:51:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,254,1355126400"; 
   d="scan'208";a="229645149"
Message-ID: <1355187084.7216.102.camel@yhuang-dev>
Subject: Re: [PATCH v2 2/3] llist: add a safe version of llist_for_each_entry
From: Huang Ying <ying.huang@intel.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, Konrad Rzeszutek Wilk <konrad@kernel.org>
Date: Tue, 11 Dec 2012 08:51:24 +0800
In-Reply-To: <1355160290-22180-2-git-send-email-roger.pau@citrix.com>
References: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
	 <1355160290-22180-2-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 18:24 +0100, Roger Pau Monne wrote:
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> ---
>  include/linux/llist.h |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index a5199f6..f611cd8 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -125,6 +125,33 @@ static inline void init_llist_head(struct llist_head *list)
>  	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
>  
>  /**
> + * llist_for_each_entry_safe - safely iterate over some deleted entries of
> + *                             lock-less list of given type
> + * @pos:	the type * to use as a loop cursor.
> + * @n:		the &struct llist_node to use as a temporary loop cursor
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
> +	     (n) = (pos)->member.next;					\

If node == NULL, (pos)->member.next will trigger NULL reference.

Best Regards,
Huang Ying

> +	     &(pos)->member != NULL;					\
> +	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
> +	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
> +
> +/**
>   * llist_empty - tests whether a lock-less list is empty
>   * @head:	the list to test
>   *


