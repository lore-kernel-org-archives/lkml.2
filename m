Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0JHISr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:18:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0JHISq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:18:46 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] kernel: add bl_list
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	<1286515292-15882-2-git-send-email-david@fromorbit.com>
Date: Fri, 08 Oct 2010 10:18:40 +0200
In-Reply-To: <1286515292-15882-2-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Fri, 8 Oct 2010 16:21:15 +1100")
Message-ID: <87hbgx5c7z.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> +static inline void __hlist_bl_del(struct hlist_bl_node *n)
> +{
> +	struct hlist_bl_node *next = n->next;
> +	struct hlist_bl_node **pprev = n->pprev;
> +
> +	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
> +
> +	/* pprev may be `first`, so be careful not to lose the lock bit */
> +	*pprev = (struct hlist_bl_node *)
> +			((unsigned long)next |
> +			 ((unsigned long)*pprev & LIST_BL_LOCKMASK));
> +	if (next)
> +		next->pprev = pprev;
> +}

Should this set n->pprev to NULL so that unhashed returns true
afterwards?


> +
> +static inline void hlist_bl_del(struct hlist_bl_node *n)
> +{
> +	__hlist_bl_del(n);
> +	n->next = BL_LIST_POISON1;
> +	n->pprev = BL_LIST_POISON2;
> +}

Ok so unhashed only works once. Seems unsymmetric.

Other than that looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
