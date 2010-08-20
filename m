Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0HTNju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:39:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0HTNjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:39:47 -0400
Date: Fri, 20 Aug 2010 15:39:03 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        npiggin@kernel.dk
Subject: Re: [PATCH 2/2] radix-tree: radix_tree_range_tag_if_tagged() can
 set incorrect tags
Message-ID: <20100820133903.GB5716@quack.suse.cz>
References: <1282281727-15088-1-git-send-email-david@fromorbit.com>
 <1282281727-15088-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282281727-15088-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Fri 20-08-10 15:22:07, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit ebf8aa44beed48cd17893a83d92a4403e5f9d9e2 ("radix-tree:
> omplement function radix_tree_range_tag_if_tagged") does not safely
> set tags on on intermediate tree nodes. The code walks down the tree
> setting tags before it has fully resolved the path to the leaf under
> the assumption there will be a leaf slot with the tag set in the
> range it is searching.
> 
> Unfortunately, this is not a valid assumption - we can abort after
> setting a tag on an intermediate node if we overrun the number of
> tags we are allowed to set in a batch, or stop scanning because we
> we have passed the last scan index before we reach a leaf slot with
> the tag we are searching for set.
> 
> As a result, we can leave the function with tags set on intemediate
> nodes which can be tripped over later by tag-based lookups. The
> result of these stale tags is that lookup may end prematurely or
> livelock because the lookup cannot make progress.
> 
> The fix for the problem involves reocrding the traversal path we
> take to the leaf nodes, and only propagating the tags back up the
> tree once the tag is set in the leaf node slot. We are already
> recording the path for efficient traversal, so there is no
> additional overhead to do the intermediately node tag setting in
> this manner.
> 
> This fixes a radix tree lookup livelock triggered by the new
> writeback sync livelock avoidance code introduced in commit
> f446daaea9d4a420d16c606f755f3689dcb2d0ce ("mm: implement writeback
> livelock avoidance using page tagging").
  I've reviewed the patch and it looks good. I'll put the patches to
testing on my machine and also uptade Andrew's radix-tree test suite to
catch these types of bugs and run it just to be sure.
  Anyway, for now:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  lib/radix-tree.c |   57 +++++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 1014171..e0ee8cb 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -625,6 +625,13 @@ EXPORT_SYMBOL(radix_tree_tag_get);
>   * also settag. The function stops either after tagging nr_to_tag items or
>   * after reaching last_index.
>   *
> + * The tags must be set from the leaf level only and propagated back up the
> + * path to the root. We must do this so that we resolve the full path before
> + * setting any tags on intermediate nodes. If we set tags as we descend, then
> + * we can get to the leaf node and find that the index that has the iftag
> + * set is outside the range we are scanning. This reults in dangling tags and
> + * can lead to problems with later tag operations (e.g. livelocks on lookups).
> + *
>   * The function returns number of leaves where the tag was set and sets
>   * *first_indexp to the first unscanned index.
>   */
> @@ -633,9 +640,13 @@ unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
>  		unsigned long nr_to_tag,
>  		unsigned int iftag, unsigned int settag)
>  {
> -	unsigned int height = root->height, shift;
> -	unsigned long tagged = 0, index = *first_indexp;
> -	struct radix_tree_node *open_slots[height], *slot;
> +	unsigned int height = root->height;
> +	struct radix_tree_path path[height];
> +	struct radix_tree_path *pathp = path;
> +	struct radix_tree_node *slot;
> +	unsigned int shift;
> +	unsigned long tagged = 0;
> +	unsigned long index = *first_indexp;
>  
>  	last_index = min(last_index, radix_tree_maxindex(height));
>  	if (index > last_index)
> @@ -655,6 +666,13 @@ unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
>  	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
>  	slot = radix_tree_indirect_to_ptr(root->rnode);
>  
> +	/*
> +	 * we fill the path from (root->height - 2) to 0, leaving the index at
> +	 * (root->height - 1) as a terminator. Zero the node in the terminator
> +	 * so that we can use this to end walk loops back up the path.
> +	 */
> +	path[height - 1].node = NULL;
> +
>  	for (;;) {
>  		int offset;
>  
> @@ -663,17 +681,30 @@ unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
>  			goto next;
>  		if (!tag_get(slot, iftag, offset))
>  			goto next;
> +		if (height > 1) {
> +			/* Go down one level */
> +			height--;
> +			shift -= RADIX_TREE_MAP_SHIFT;
> +			path[height - 1].node = slot;
> +			path[height - 1].offset = offset;
> +			slot = slot->slots[offset];
> +			continue;
> +		}
> +
> +		/* tag the leaf */
> +		tagged++;
>  		tag_set(slot, settag, offset);
> -		if (height == 1) {
> -			tagged++;
> -			goto next;
> +
> +		/* walk back up the path tagging interior nodes */
> +		pathp = &path[0];
> +		while (pathp->node) {
> +			/* stop if we find a node with the tag already set */
> +			if (tag_get(pathp->node, settag, pathp->offset))
> +				break;
> +			tag_set(pathp->node, settag, pathp->offset);
> +			pathp++;
>  		}
> -		/* Go down one level */
> -		height--;
> -		shift -= RADIX_TREE_MAP_SHIFT;
> -		open_slots[height] = slot;
> -		slot = slot->slots[offset];
> -		continue;
> +
>  next:
>  		/* Go to next item at level determined by 'shift' */
>  		index = ((index >> shift) + 1) << shift;
> @@ -687,7 +718,7 @@ next:
>  			 * last_index is guaranteed to be in the tree, what
>  			 * we do below cannot wander astray.
>  			 */
> -			slot = open_slots[height];
> +			slot = path[height - 1].node;
>  			height++;
>  			shift += RADIX_TREE_MAP_SHIFT;
>  		}
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
