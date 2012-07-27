Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2G0T01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:26:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2G0T00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:26:26 -0400
Message-ID: <1343417168.32120.38.camel@twins>
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 21:26:08 +0200
In-Reply-To: <1342787467-5493-5-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	 <1342787467-5493-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -88,7 +88,8 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
>                 root->rb_node = new;
>  }
>  
> -void rb_insert_color(struct rb_node *node, struct rb_root *root)
> +inline void rb_insert_augmented(struct rb_node *node, struct rb_root *root,
> +                               rb_augment_rotate *augment)

Daniel probably knows best, but I would have expected something like:

__always_inline void 
__rb_insert(struct rb_node *node, struct rb_root *root,
	    const rb_augment_rotate *augment)

Where you force inline and use a const function pointer since GCC is
better with inlining them -- iirc, Daniel?

>  {
>         struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
>  
> @@ -152,6 +153,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
>                                         rb_set_parent_color(tmp, parent,
>                                                             RB_BLACK);
>                                 rb_set_parent_color(parent, node, RB_RED);
> +                               augment(parent, node);

And possibly:
		if (augment)
			augment(parent, node);

>                                 parent = node;
>                                 tmp = node->rb_right;
>                         }


> +static inline void dummy(struct rb_node *old, struct rb_node *new) {}

That would obviate the need for the dummy..

> +void rb_insert_color(struct rb_node *node, struct rb_root *root) {

placed your { wrong..

> +       rb_insert_augmented(node, root, dummy);
> +}
>  EXPORT_SYMBOL(rb_insert_color); 

And use Daniel's __flatten here, like:

void rb_insert_color(struct rb_node *node, struct rb_root *root)
__flatten
{
	__rb_insert(node, root, NULL);
}
EXPORT_SYMBOL(rb_insert_color);

void rb_insert_augmented(struct rb_node *node, struct rb_root *root,
			 const rb_augment_rotate *augment) __flatten
{
	__rb_insert(node, root, augment);
}
EXPORT_SYMBOL(rb_insert_augmented);
