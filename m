Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2HFOSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:18:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:57765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2HFOSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:18:04 -0400
Message-ID: <1344262669.27828.55.camel@twins>
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 16:17:49 +0200
In-Reply-To: <1343946858-8170-9-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-9-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> +static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
> +{
> +       while (rb != stop) {
> +               struct interval_tree_node *node =
> +                       rb_entry(rb, struct interval_tree_node, rb);
> +               unsigned long subtree_last = compute_subtree_last(node);
> +               if (node->__subtree_last == subtree_last)
> +                       break;
> +               node->__subtree_last = subtree_last;
> +               rb = rb_parent(&node->rb);
> +       }
> +}
> +
> +static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
> +{
> +       struct interval_tree_node *old =
> +               rb_entry(rb_old, struct interval_tree_node, rb);
> +       struct interval_tree_node *new =
> +               rb_entry(rb_new, struct interval_tree_node, rb);
> +
> +       new->__subtree_last = old->__subtree_last;
> +}
> +
> +static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
> +{
> +       struct interval_tree_node *old =
> +               rb_entry(rb_old, struct interval_tree_node, rb);
> +       struct interval_tree_node *new =
> +               rb_entry(rb_new, struct interval_tree_node, rb);
> +
> +       new->__subtree_last = old->__subtree_last;
> +       old->__subtree_last = compute_subtree_last(old);
> +} 

I still don't get why we need the 3 callbacks when both propagate and
rotate are simple variants of the original callback
(compute_subtree_last, in this instance).

Why would every user need to replicate the propagate and rotate
boilerplate?
