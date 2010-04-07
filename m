Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0DGIRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:17:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab0DGIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:17:38 -0400
Date: Wed, 7 Apr 2010 18:17:33 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       corbet@lwn.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make
 out [ver #2]
Message-ID: <20100407081733.GC5433@laptop>
References: <20100406213620.28251.90764.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406213620.28251.90764.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:36:20PM +0100, David Howells wrote:
> radix_tree_tag_get() is not safe to use concurrently with radix_tree_tag_set()
> or radix_tree_tag_clear().  The problem is that the double tag_get() in
> radix_tree_tag_get():
> 
> 		if (!tag_get(node, tag, offset))
> 			saw_unset_tag = 1;
> 		if (height == 1) {
> 			int ret = tag_get(node, tag, offset);
> 
> may see the value change due to the action of set/clear.  RCU is no protection
> against this as no pointers are being changed, no nodes are being replaced
> according to a COW protocol - set/clear alter the node directly.
> 
> The documentation in linux/radix-tree.h, however, says that
> radix_tree_tag_get() is an exception to the rule that "any function modifying
> the tree or tags (...) must exclude other modifications, and exclude any
> functions reading the tree".
> 
> The problem is that the next statement in radix_tree_tag_get() checks that the
> tag doesn't vary over time:
> 
> 			BUG_ON(ret && saw_unset_tag);

Yep, it's just a simple bug because the pagecache hadn't been using
radix_tree_tag_get.

> 
> This has been seen happening in FS-Cache:
> 
> 	https://www.redhat.com/archives/linux-cachefs/2010-April/msg00013.html
> 
> To this end, remove the BUG_ON() from radix_tree_tag_get() and note in various
> comments that the value of the tag may change whilst the RCU read lock is held,

I was thinking more of adding it to the radix-tree.h comment, because
this is true of all radix-tree functions when called under RCU. I don't
know it is considered "unreliable", it is just that concurrent
modifications may run unless the caller has excluded them. So the
value returned is reliably a value that has been observed.

Thanks for spotting this bug.

> and thus that the return value of radix_tree_tag_get() may not be relied upon
> unless radix_tree_tag_set/clear() and radix_tree_delete() are excluded from
> running concurrently with it.
> 
> Reported-by: Romain DEGEZ <romain.degez@smartjog.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/radix-tree.h |    7 +++++++
>  lib/radix-tree.c           |   12 ++++++------
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index c5da749..55ca73c 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -121,6 +121,13 @@ do {									\
>   * (Note, rcu_assign_pointer and rcu_dereference are not needed to control
>   * access to data items when inserting into or looking up from the radix tree)
>   *
> + * Note that the value returned by radix_tree_tag_get() may not be relied upon
> + * if only the RCU read lock is held.  Functions to set/clear tags and to
> + * delete nodes running concurrently with it may affect its result such that
> + * two consecutive reads in the same locked section may return different
> + * values.  If reliability is required, modification functions must also be
> + * excluded from concurrency.
> + *
>   * radix_tree_tagged is able to be called without locking or RCU.
>   */
>  
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 6b9670d..6a75327 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -556,6 +556,10 @@ EXPORT_SYMBOL(radix_tree_tag_clear);
>   *
>   *  0: tag not present or not set
>   *  1: tag set
> + *
> + * Note that the return value of this function may not be relied on, even if
> + * the RCU lock is held, unless tag modification and node deletion are excluded
> + * from concurrency.
>   */
>  int radix_tree_tag_get(struct radix_tree_root *root,
>  			unsigned long index, unsigned int tag)
> @@ -596,12 +600,8 @@ int radix_tree_tag_get(struct radix_tree_root *root,
>  		 */
>  		if (!tag_get(node, tag, offset))
>  			saw_unset_tag = 1;
> -		if (height == 1) {
> -			int ret = tag_get(node, tag, offset);
> -
> -			BUG_ON(ret && saw_unset_tag);
> -			return !!ret;
> -		}
> +		if (height == 1)
> +			return !!tag_get(node, tag, offset);
>  		node = rcu_dereference_raw(node->slots[offset]);
>  		shift -= RADIX_TREE_MAP_SHIFT;
>  		height--;
