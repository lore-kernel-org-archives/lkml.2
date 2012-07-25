Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2GYQPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab2GYQPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:15:42 -0400
Message-ID: <50101A77.3070407@redhat.com>
Date: Wed, 25 Jul 2012 12:10:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-5-git-send-email-walken@google.com>
In-Reply-To: <1342787467-5493-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:31 AM, Michel Lespinasse wrote:

> +++ b/lib/rbtree.c
> @@ -88,7 +88,8 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
>   		root->rb_node = new;
>   }
>
> -void rb_insert_color(struct rb_node *node, struct rb_root *root)
> +inline void rb_insert_augmented(struct rb_node *node, struct rb_root *root,
> +				rb_augment_rotate *augment)
>   {
>   	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
>
> @@ -152,6 +153,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
>   					rb_set_parent_color(tmp, parent,
>   							    RB_BLACK);
>   				rb_set_parent_color(parent, node, RB_RED);
> +				augment(parent, node);

> +static inline void dummy(struct rb_node *old, struct rb_node *new) {}
> +
> +void rb_insert_color(struct rb_node *node, struct rb_root *root) {
> +	rb_insert_augmented(node, root, dummy);
> +}
>   EXPORT_SYMBOL(rb_insert_color);

While the above is what I would have done, the
question remains "what if the compiler decides
to not inline the function after all, and does
not remove the call to the dummy function in
rb_insert_color as a result?

Do we have some way to force inlining, so the
compiler is more likely to optimize out the
dummy call?

>   static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
> diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
> index 2dfafe4..5ace332 100644
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -67,22 +67,37 @@ static void augment_callback(struct rb_node *rb, void *unused)
>   	node->augmented = augment_recompute(node);
>   }
>
> +static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
> +{
> +	struct test_node *old = rb_entry(rb_old, struct test_node, rb);
> +	struct test_node *new = rb_entry(rb_new, struct test_node, rb);
> +
> +	/* Rotation doesn't change subtree's augmented value */
> +	new->augmented = old->augmented;
> +	old->augmented = augment_recompute(old);
> +}

Is it worth documenting that rb_old is always the
parent of rb_new (at least, it seems to be in this
patch) ?

