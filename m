Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0DFTtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:49:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab0DFTtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:49:05 -0400
Date: Wed, 7 Apr 2010 05:48:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       corbet@lwn.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make
 out
Message-ID: <20100406194843.GJ5288@laptop>
References: <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 08:31:34PM +0100, David Howells wrote:
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
> The documentation in linux/radix-tree.h, however, proclaims that
> radix_tree_tag_get() is an exception to the rule that "any function modifying
> the tree or tags (...) must exclude other modifications, and exclude any
> functions reading the tree".
> 
> To this end, remove radix_tree_tag_get() from that list, and comment on its
> definition that the caller is responsible for preventing concurrent access with
> set/clear.
> 
> Furthermore, radix_tree_tag_get() is not safe with respect to
> radix_tree_delete() either as that also modifies the tags directly.
> 
> An alternative would be to drop the BUG_ON() from radix_tree_tag_get() and note
> that it may produce an untrustworthy answer if not so protected.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Nack, just drop the BUG_ON.

I don't know what you mean by "untrustworthy answer".

radix_tree_tag_get, when called under RCU, will always return 1 if the
tag is guaranteed to have been set. And always 0 if it was clear. If it
can have been flipped at some point, then radix_tree_tag_get might
return either.

This would be the same whether you are using "COW protocol" or whatever
to do the RCU protection. And it is the same for all other RCU radix
tree operations.

No, rcu_read_lock does not give atomicity over multiple operations
because it can't prevent writers from modifying the data structure. This
shouldn't be surprising, but feel free to add a comment that a lock or
seqlock is required to give such atomicity.

> ---
> 
>  include/linux/radix-tree.h |    3 +--
>  lib/radix-tree.c           |    4 ++++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index c5da749..33daa70 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -100,14 +100,13 @@ do {									\
>   * The notable exceptions to this rule are the following functions:
>   * radix_tree_lookup
>   * radix_tree_lookup_slot
> - * radix_tree_tag_get
>   * radix_tree_gang_lookup
>   * radix_tree_gang_lookup_slot
>   * radix_tree_gang_lookup_tag
>   * radix_tree_gang_lookup_tag_slot
>   * radix_tree_tagged
>   *
> - * The first 7 functions are able to be called locklessly, using RCU. The
> + * The first 6 functions are able to be called locklessly, using RCU. The
>   * caller must ensure calls to these functions are made within rcu_read_lock()
>   * regions. Other readers (lock-free or otherwise) and modifications may be
>   * running concurrently.
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 6b9670d..795a3bb 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -556,6 +556,10 @@ EXPORT_SYMBOL(radix_tree_tag_clear);
>   *
>   *  0: tag not present or not set
>   *  1: tag set
> + *
> + * The caller must make sure this function does not run concurrently with
> + * radix_tree_tag_set/clear() or radix_tree_delete() as these modify the nodes
> + * directly to alter the tags.
>   */
>  int radix_tree_tag_get(struct radix_tree_root *root,
>  			unsigned long index, unsigned int tag)
