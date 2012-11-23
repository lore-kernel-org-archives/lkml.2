Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2KWFuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:50:00 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52232 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2KWFt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <50AE5D79.8040803@oracle.com>
References: <50AE5D79.8040803@oracle.com>
Date: Thu, 22 Nov 2012 21:49:58 -0800
Message-ID: <CANN689G-VRTvFoRNMXx080=0VwTGqOw5YGVGaE7u64QKvh0rHw@mail.gmail.com>
Subject: Re: Is augmented rbtree propagation broken?
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 9:14 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi Michel,
>
> I've noticed a bug regarding search of ioports in the KVM tool. Since the KVM tool is
> using kernel's augmented rbtree implementation to represent an interval rbtree I dug a
> bit into the new implementation in the kernel, and noticed the following odd behaviour.
>
> Let's take a simple case where we have 2 intervals with the 3rd parameter being the
> 'max_high' field used by interval rbtrees: (1,2,0) , (3,4,0). Let's add them one by one:
>
> 1.               (1,2,2)
>                 /       \
>              NULL       NULL
>
> 2.               (1,2,4)
>                 /       \
>              NULL       (3,4,4)
>
> On the 2nd stage we'd expect that the new (3,4) interval will be added to the right
> subtree (which happens correctly), and that the insertion will be propagated to the
> root of the tree to update max_high (which doesn't happen).
>
> Basically, at stage 2, the tree we're left with is:
>
>                  (1,2,2)
>                 /       \
>              NULL       (3,4,4)
>
> Which is wrong.

You are absolutely correct that one needs to update the ancestors
augmented information on insertion, and that rb_insert_augmented
doesn't do that.

> I suspect that this happens because we never propagate upon insertion, which sounds
> quite odd to me, but I might be missing something.

What we are supposed to do (and what other call sites are doing), is
that before insertion we do a search down the rbtree to find the
correct insertion point. During that search, we already look at nodes
on the desired path, so it is the ideal time to update their augmented
information as well (max_high in the case you are talking about).

> The following patch fixed the problem for me:
>
> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
> index 214caa3..5cfdca6 100644
> --- a/include/linux/rbtree_augmented.h
> +++ b/include/linux/rbtree_augmented.h
> @@ -47,6 +47,7 @@ rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>                     const struct rb_augment_callbacks *augment)
>  {
>         __rb_insert_augmented(node, root, augment->rotate);
> +       augment->propagate(node, NULL);
>  }

This would work, but would slow down all sites which already take care
of updating the augmented information before calling
rb_insert_augmented, so please don't do that.

The simplest fix would be to add the propagate call where your
rb_insert_augmented() call site is; the better fix would be to do the
update incrementally as you search down the tree for the insertion
point; and the best fix may be to just avoid duplicating that code and
use interval_tree.h (if your keys are longs) or
interval_tree_generic.h to generate the proper insert / remove
functions.

I would send you patches if the code was in linus's tree, but as it's
not I want to ask - what trees do these new augmented rbtree call
sites live in ? Are we talking perf and kvm git trees on kernel.org,
or are there others I should be aware of ?

Also in the case of ioports, are your intervals ever overlapping ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
