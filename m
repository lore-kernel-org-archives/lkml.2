Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0HTNAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:00:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0HTNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:00:52 -0400
Date: Fri, 20 Aug 2010 15:00:05 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        npiggin@kernel.dk
Subject: Re: [PATCH 1/2] radix-tree: clear all tags in
 radix_tree_node_rcu_free
Message-ID: <20100820130005.GA5716@quack.suse.cz>
References: <1282281727-15088-1-git-send-email-david@fromorbit.com>
 <1282281727-15088-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282281727-15088-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-08-10 15:22:06, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit f446daaea9d4a420d16c606f755f3689dcb2d0ce ("mm: implement
> writeback livelock avoidance using page tagging") introduced a new
> radix tree tag, increasing the number of tags in each node from 2 to
> 3. It did not, however, fix up the code in
> radix_tree_node_rcu_free() that cleans up after radix_tree_shrink()
> and hence could leave stray tags set in the new tag array.
> 
> The result is that the livelock avoidance code added in the the
> above commit would hit stale tags when doing tag based lookups,
> resulting in livelocks when trying to traverse the tree.
> 
> Fix this problem in radix_tree_node_rcu_free() so it doesn't happen
> again in the future by using a loop to walk all the tags up to
> RADIX_TREE_MAX_TAGS to clear the stray tags radix_tree_shrink()
> leaves behind.
  The patch looks good. Thanks!
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  lib/radix-tree.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index e907858..1014171 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -174,14 +174,16 @@ static void radix_tree_node_rcu_free(struct rcu_head *head)
>  {
>  	struct radix_tree_node *node =
>  			container_of(head, struct radix_tree_node, rcu_head);
> +	int i;
>  
>  	/*
>  	 * must only free zeroed nodes into the slab. radix_tree_shrink
>  	 * can leave us with a non-NULL entry in the first slot, so clear
>  	 * that here to make sure.
>  	 */
> -	tag_clear(node, 0, 0);
> -	tag_clear(node, 1, 0);
> +	for (i = 0; i < RADIX_TREE_MAX_TAGS; i++)
> +		tag_clear(node, i, 0);
> +
>  	node->slots[0] = NULL;
>  	node->count = 0;
>  
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
