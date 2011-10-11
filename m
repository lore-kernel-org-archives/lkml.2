Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1JKXhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:37:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36275 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JKXhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:37:52 -0400
Date: Tue, 11 Oct 2011 16:37:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ulist: generic data structure to build unique lists
Message-Id: <20111011163749.b0c27813.akpm@linux-foundation.org>
In-Reply-To: <1318238525-28879-1-git-send-email-sensille@gmx.net>
References: <1318238525-28879-1-git-send-email-sensille@gmx.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 11:22:05 +0200
Arne Jansen <sensille@gmx.net> wrote:

> ulist is a generic data structures to hold a collection of unique u64
> values. The only operations it supports is adding to the list and
> enumerating it.
> 
> It is possible to store an auxiliary value along with the key.
> The implementation is preliminary and can probably be sped up
> significantly.
> The main purpose of this submission is to get some idea whether this
> data structure is worth having generally available.
> 
> It is used by btrfs subvolume quota to translate recursions into iterative
> loops and to gather a unique list of roots. Once I had built this data
> structure, several uses for it popped up.
> 
>
> ...
>
> +#define ULIST_SIZE 16
> +
> +struct ulist_node {
> +	u64 val;
> +	unsigned long aux;
> +	unsigned long next;
> +};
> +
> +struct ulist {
> +	unsigned long nnodes;
> +	unsigned long gfp_mask;
> +	struct ulist_node *nodes;
> +	unsigned long nodes_alloced;
> +	struct ulist_node int_nodes[ULIST_SIZE];
> +};

Please document your data structures.  In particular, the relationship
between the various fields.  And ulist_node.aux and .next are rather
mysterious.  Would prefer not to have to reverse engineer these things
from an implementation.

> +void ulist_init(struct ulist *ulist, unsigned long gfp_mask);
> +void ulist_fini(struct ulist *ulist);
> +void ulist_reinit(struct ulist *ulist);
> +struct ulist *ulist_alloc(unsigned long gfp_mask);
> +void ulist_free(struct ulist *ulist);

These are all missing EXPORT_SYMBOL.

And they're all missing interface documentation ;)

The locking requirements should be documented.  It appears to be
"caller provides it".  That's a good design, but let's spell it out. 

Bear in mind that some callers might wish to use rwlocks or rwsems, so
really good documentation would tell them which interface functions
need a read lock and which need a write lock.  Bear in mind that such
decisions might constrain future additions to the library code.

> +/* returns < 0 on error, 0 on duplicate, 1 on insert */
> +int ulist_add(struct ulist *ulist, u64 val, unsigned long aux);
> +
> +struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
> +
> +#endif
> diff --git a/lib/ulist.c b/lib/ulist.c
> new file mode 100644
> index 0000000..641a90f
> --- /dev/null
> +++ b/lib/ulist.c
> @@ -0,0 +1,103 @@
> +/*
> + * Copyright (C) 2011 STRATO AG
> + * written by Arne Jansen <sensille@gmx.net>
> + * Distributed under the GNU GPL license version 2.
> + *
> + * ulist is a generic data structures to hold a collection of unique u64
> + * values. The only operations it supports is adding to the list and
> + * enumerating it.
> + * It is possible to store an auxiliary value along with the key.
> + *
> + * The implementation is preliminary and can probably be sped up
> + * significantly. A first step would be to store the values in an rbtree
> + * as soon as ULIST_SIZE is exceeded.
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/ulist.h>
> +
> +void ulist_init(struct ulist *ulist, unsigned long gfp_mask)
> +{
> +	ulist->nnodes = 0;
> +	ulist->gfp_mask = gfp_mask;
> +	ulist->nodes = ulist->int_nodes;
> +	ulist->nodes_alloced = ULIST_SIZE;
> +}

Putting the gfp_mask into the ulist is a mistake, trust me.  Been there
before.  It should be passed in as an argument by the caller.

> +void ulist_fini(struct ulist *ulist)
> +{
> +	if (ulist->nodes_alloced > ULIST_SIZE)
> +		kfree(ulist->nodes);
> +}

What a strange function.  I look forward to seeing the documentation.

> +void ulist_reinit(struct ulist *ulist)
> +{
> +	ulist_fini(ulist);
> +	ulist_init(ulist, ulist->gfp_mask);
> +}
> +
> +struct ulist *ulist_alloc(unsigned long gfp_mask)
> +{
> +	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
> +
> +	if (!ulist)
> +		return NULL;
> +
> +	ulist_init(ulist, gfp_mask);
> +
> +	return ulist;
> +}
> +
> +void ulist_free(struct ulist *ulist)
> +{
> +	if (!ulist)
> +		return;
> +	ulist_fini(ulist);
> +	kfree(ulist);
> +}
> +
> +int ulist_add(struct ulist *ulist, u64 val, unsigned long aux)
> +{
> +	int i;
> +
> +	for (i = 0; i < ulist->nnodes; ++i) {
> +		if (ulist->nodes[i].val == val)
> +			return 0;
> +	}
> +
> +	if (ulist->nnodes > ulist->nodes_alloced) {
> +		u64 new_alloced = ulist->nodes_alloced + 128;
> +		struct ulist_node *new_nodes = kmalloc(sizeof(*new_nodes) *
> +					       new_alloced, ulist->gfp_mask);
> +
> +		if (!new_nodes)
> +			return -ENOMEM;
> +		memcpy(new_nodes, ulist->nodes,
> +		       sizeof(*new_nodes) * ulist->nnodes);

We have krealloc().

> +		if (ulist->nodes_alloced > ULIST_SIZE)
> +			kfree(ulist->nodes);
> +		ulist->nodes = new_nodes;
> +		ulist->nodes_alloced = new_alloced;
> +	}
> +	ulist->nodes[ulist->nnodes].val = val;
> +	ulist->nodes[ulist->nnodes].aux = aux;
> +	ulist->nodes[ulist->nnodes].next = ulist->nnodes + 1;
> +	++ulist->nnodes;
> +
> +	return 1;
> +}
> +
> +struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
> +{
> +	if (ulist->nnodes == 0)
> +		return NULL;
> +
> +	if (!prev)
> +		return &ulist->nodes[0];
> +
> +	if (prev->next < 0 || prev->next >= ulist->nnodes)
> +		return NULL;
> +
> +	return &ulist->nodes[prev->next];
> +}

Generally, I really do ask that you provide us a complete description
of what this utility is supposed to do.  Once that is understood we can
then start to determine why none of the existing container helpers were
suitable, and were not capable of being modified to be suitable.

For example, from a quick squint at the code I'm wondering why
flex_array was unsuitable.

