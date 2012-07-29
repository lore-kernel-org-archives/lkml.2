Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2G2MgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 08:36:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37405 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2G2MgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 08:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120729040432.25753.qmail@science.horizon.com>
References: <20120729040432.25753.qmail@science.horizon.com>
Date: Sun, 29 Jul 2012 05:36:03 -0700
Message-ID: <CANN689EPE823oV_SFZXHG+18CiD3oknF34=X26sUiKUiMPTeVQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] rbtree: rb_erase updates and comments
From: Michel Lespinasse <walken@google.com>
To: George Spelvin <linux@horizon.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 9:04 PM, George Spelvin <linux@horizon.com> wrote:
> I was just looking at the beginning of the 2-children case and wondering:
>
> +               /*
> +                * Old is the node we want to erase. It's got left and right
> +                * children, which makes things difficult. Let's find the
> +                * next node in the tree to have it fill old's position.
> +                */
>                 node = node->rb_right;
>
> Er... isn't this already available in "child"?  Why fetch it again (or make the
> compiler figure out that it doesn't have to)?

Good catch, I just failed to notice it myself :)

> Another thing you can use for comments is that if a node has a single
> child, that child must be red.  That can simplify the rb_set_parent
> code, since it does not need to read the old value.

Nicely observed, I hadn't thought of that one either.

> Then the end of case 3 of rb_erase becomes:
>         if (child)
>                 rb_set_parent_color(child, parent, RB_RED);

Yes. it's actually even nicer, because we know since the child is red,
the node being erased is black, and we can thus handle recoloring 'for
free' by setting child to black here instead of going through
__rb_erase_color() later. And if we could do that for all 1-child
cases, it might even be possible to invoke __rb_erase_color() for the
no-childs case only, at which point we can drop one of that function's
arguments. Worth investigating, I think.

> A common idiom I see in the code:
>
> +               if (parent) {
> +                       if (parent->rb_left == node)
> +                               parent->rb_left = child;
> +                       else
> +                               parent->rb_right = child;
> +               } else
> +                       root->rb_node = child;
>
> might be written more attractively as:
>
>                 if (unlikely(!parent))
>                         root->rb_node = child;
>                 else if (parent->rb_left == node)
>                         parent->rb_left = child;
>                 else
>                         parent->rb_right = child;
>
> I'm almost tempted to wrap that up in a helper function, although the
> lack of an obviously correct order for the three "struct rb_node *" parameters
> suggests that it would maybe be too confusing.

Using a helper doesn't hurt, I think. I'm not sure about the unlikely
thing because near-empty trees could be common for some workloads,
which is why I've let it the way it currently is.

> Finally, it would be interesting to look at Sedgewick's left-leaning RB-tree to see
> if it could improve things.  I'm not sure if it would, since in a multiprocessor system,
> the most important thing is minimizing cache line bouncing, which means minimizing
> writes, and he gets his code simplicity by tightening invariants, which means more
> write traffic.

Yeah, I've had a quick look at left-leaning RBtrees, but they didn't
seem like an obvious win to me. Plus, I feel like I've been thinking
about rbtrees too much already, so I kinda want to take a vacation
from them at this point :)

Thanks for your remarks, especially the one about one-child coloring
in rb_erase().

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
