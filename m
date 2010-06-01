Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0FARAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:00:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab0FARA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:00:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oQ6d8yYX8KjYnmGdQc6jOOh8hD40Jm8aZXGbM4S8qaTeQi7smIvJJvrJ0LDIqN7Wq
	foBWOheA9CRt39whHxKBg==
MIME-Version: 1.0
In-Reply-To: <1275139902.27810.13737.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	<tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	<1275136178.27810.13539.camel@twins>
	<1275139902.27810.13737.camel@twins>
Date: Tue, 1 Jun 2010 10:00:21 -0700
Message-ID: <AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 6:31 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> A better changelog, and I guess we can keep the explanation of
> the augmented rb-tree since it doesn't actually mentions the
> interface, merely the idea of adding a heap to the binary tree.
>
> The patch simply reverts the rbtree.c hunk, and keeps the non-conforming
> style it has..
>
> ---
> Subject: rbtree: Undo augmented damage
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat May 29 15:14:02 CEST 2010
>
> Reimplement augmented RB-trees without sprinkling extra branches
> all over the RB-tree code (which lives in the scheduler hot path).
>
> This approach is 'borrowed' from Fabio's BFQ implementation and
> relies on traversing the rebalance path after the RB-tree-op to
> correct the heap property for insertion/removal and make up for
> the damage done by the tree rotations.
>
> For insertion the rebalance path is trivially that from the new
> node upwards to the root, for removal it is that from the deepest
> node in the path from the to be removed node that will still
> be around after the removal.

Yes. I like avoiding the sprinkled if's. But, I don't think
rb_augment_erase_begin() and rb_augment_insert() is covering all the
callbacks needed to maintain the augmented tree correctly. More
comments below.

>
> Cc: Fabio Checconi <fabio@gandalf.sssup.it>
> Cc: suresh.b.siddha@intel.com
> Cc: venki@google.com
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/mm/pat_rbtree.c |    9 ++--
>  include/linux/rbtree.h   |   13 ++++--
>  lib/rbtree.c             |   97 +++++++++++++++++++++++++----------------------
>  3 files changed, 68 insertions(+), 51 deletions(-)
>
> Index: linux-2.6/arch/x86/mm/pat_rbtree.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/pat_rbtree.c
> +++ linux-2.6/arch/x86/mm/pat_rbtree.c
> @@ -34,8 +34,7 @@
>  * memtype_lock protects the rbtree.
>  */
>
> -static void memtype_rb_augment_cb(struct rb_node *node);
> -static struct rb_root memtype_rbroot = RB_AUGMENT_ROOT(&memtype_rb_augment_cb);
> +static struct rb_root memtype_rbroot = RB_ROOT;
>
>  static int is_node_overlap(struct memtype *node, u64 start, u64 end)
>  {
> @@ -190,7 +189,7 @@ failure:
>        return -EBUSY;
>  }
>
> -static void memtype_rb_augment_cb(struct rb_node *node)
> +static void memtype_rb_augment_cb(struct rb_node *node, void *data)
>  {
>        if (node)
>                update_path_max_end(node);

There is a optimization in memtype_rb_augment_cb, where in it does not
do the fixup all the way to the root, when a nodes max_end does not
change. That has to be removed for this change to work.


> @@ -213,6 +212,7 @@ static void memtype_rb_insert(struct rb_
>
>        rb_link_node(&newdata->rb, parent, node);
>        rb_insert_color(&newdata->rb, root);
> +       rb_augment_insert(&newdata->rb, memtype_rb_augment_cb, NULL);
>  }
>

<snip>

> @@ -324,6 +284,55 @@ void rb_erase(struct rb_node *node, stru
>  EXPORT_SYMBOL(rb_erase);
>
>  /*
> + * after inserting @node into the tree, update the tree to account for
> + * both the new entry and any damage done by rebalance
> + */
> +void rb_augment_insert(struct rb_node *node, rb_augment_f func, void *data)
> +{
> +       if (node->rb_left)
> +               node = node->rb_left;
> +       else if (node->rb_right)
> +               node = node->rb_right;
> +
> +       func(node, data);
> +}

I am not seeing how this can cover all the callbacks we will need to
maintain the augmented tree property. May be I am missing something.

For example, during insertion there can be a rotate at the grand
parent. So, (bad ascii art alert)

    G
   / \
  P   U
 /
N

    P
   / \
  N   G
       \
        U

Where N is the new node. Here G has new children and has to
recalculate the nodes augmented data. I don't see that happening with
rb_augment_insert()


> +
> +/*
> + * before removing the node, find the deepest node on the rebalance path
> + * that will still be there after @node gets removed
> + */
> +struct rb_node *rb_augment_erase_begin(struct rb_node *node)
> +{
> +       struct rb_node *deepest;
> +
> +       if (!node->rb_right && !node->rb_left)
> +               deepest = rb_parent(node);
> +       else if (!node->rb_right)
> +               deepest = node->rb_left;
> +       else if (!node->rb_left)
> +               deepest = node->rb_right;
> +       else {
> +               deepest = rb_next(node);
> +               if (deepest->rb_right)
> +                       deepest = deepest->rb_right;
> +               else if (rb_parent(deepest) != node)
> +                       deepest = rb_parent(deepest);
> +       }
> +
> +       return deepest;
> +}
> +

I have similar concern with rb_augment_erase_begin() returning the
deepest node. There is a case in __rb_erase_color where we do a
rotate_left of 'other' (sibling) node. That changes the children of
some nodes that are not in deepest to root path. No?

Thanks,
Venki
