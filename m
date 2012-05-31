Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2EaUsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:48:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab2EaUsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:48:14 -0400
Date: Thu, 31 May 2012 22:48:06 +0200
From: Jan Kara <jack@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>
Subject: Re: [PATCH 2/4] [RFC] Range tree implementation
Message-ID: <20120531204806.GB16338@quack.suse.cz>
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
 <1337973456-19533-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337973456-19533-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-05-12 12:17:34, John Stultz wrote:
> I suspect range-tree isn't a totally accurate name, but I
> couldn't quite make out the difference between range trees
> and interval trees, so I just picked one to call it. Do
> let me know if you have a better name.
  Well, interval tree is a data structure for tracking a set of
possibly overlapping intervals. Range tree is a data structure tracking
points allowing for fast queries on a set of points contained in a given
range (gets useful and interesting when dimension > 1). Your data structure
is neither so it would be good to have a different name. OTOH there are so
many data structures that it's hard to find a reasonable unused name ;)

> +/**
> + * range_tree_next_in_range - Return the next range in a range_tree still
> + *                            contained within a specified range.
  'within' isn't really correct, right? It should rather be 'intersecting'.

> + * @root: range_tree root
> + * @start: range start
> + * @end: range end
> + *
> + */
> +struct range_tree_node *range_tree_next_in_range(struct range_tree_node *node,
> +							u64 start, u64 end)
> +{
> +	struct rb_node *next;
> +	struct range_tree_node *candidate;
> +	if (!node)
> +		return NULL;
> +	next = rb_next(&node->rb);
> +	if (!next)
> +		return NULL;
> +
> +	candidate = container_of(next, struct range_tree_node, rb);
> +
> +	if ((candidate->start > end) || (candidate->end < start))
> +		return NULL;
> +
> +	return candidate;
> +}
> +
> +/**
> + * range_tree_add - Add a node to a range tree
> + * @root: range tree to be added to
> + * @node: range_tree_node to be added
> + *
> + * Adds a node to the range tree.
  I think you should document here that the added range must not intersect
with any other range in the tree.

> + */
> +void range_tree_add(struct range_tree_root *root,
> +					struct range_tree_node *node)
> +{
> +	struct rb_node **p = &root->head.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct range_tree_node *ptr;
> +
> +	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->rb));
> +
> +	while (*p) {
> +		parent = *p;
> +		ptr = rb_entry(parent, struct range_tree_node, rb);
> +		if (node->start < ptr->start)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +	rb_link_node(&node->rb, parent, p);
> +	rb_insert_color(&node->rb, &root->head);
> +
  ^^ Spurious empty line.

> +}
> +

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
