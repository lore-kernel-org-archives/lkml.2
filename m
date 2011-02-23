Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1BWRCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:02:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab1BWRCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:02:50 -0500
Subject: Re: [RFC PATCH 1/3] Weight-balanced tree
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D6506FB.2090809@redhat.com>
References: <20110222183822.22026.62832.stgit@s20.home>
	 <20110222185456.22026.28200.stgit@s20.home>  <4D6506FB.2090809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 10:02:43 -0700
Message-ID: <1298480563.18387.6.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 15:09 +0200, Avi Kivity wrote:
> On 02/22/2011 08:55 PM, Alex Williamson wrote:
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >
> >   include/linux/wbtree.h |   55 ++++++++++++++++
> >   lib/Makefile           |    3 +
> >   lib/wbtree.c           |  170 ++++++++++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 227 insertions(+), 1 deletions(-)
> >   create mode 100644 include/linux/wbtree.h
> >   create mode 100644 lib/wbtree.c
> >
> 
> Andrew, can we add something like this to the tree?  Can it go through 
> the kvm tree?
> 
> > diff --git a/include/linux/wbtree.h b/include/linux/wbtree.h
> > new file mode 100644
> > index 0000000..ef70f6f
> > --- /dev/null
> > +++ b/include/linux/wbtree.h
> > @@ -0,0 +1,55 @@
> > +/*
> > + * Weight-balanced binary tree
> > + *
> > + * The balance of this tree is based on search probability.  The
> > + * heaviest weighted nodes (the ones we're most likely to hit), are
> > + * at the top of each subtree.
> > + *
> > + * Copywrite (C) 2011 Red Hat, Inc.
> > + *
> > + * Authors:
> > + *   Alex Williamson<alex.williamson@redhat.com>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2.  See
> > + * the COPYING file in the top-level directory.
> > + */
> > +#ifndef _LINUX_WBTREE_H
> > +#define _LINUX_WBTREE_H
> > +
> > +#include<linux/kernel.h>
> > +#include<linux/stddef.h>
> > +
> > +struct wb_node {
> > +	struct wb_node *wb_parent;
> > +	struct wb_node *wb_left;
> > +	struct wb_node *wb_right;
> > +	unsigned long wb_weight;
> > +};
> > +
> > +struct wb_root {
> > +	struct wb_node *wb_node;
> > +};
> > +
> > +#define WB_ROOT (struct wb_root) { NULL, }
> > +#define wb_entry(ptr, type, member) container_of(ptr, type, member)
> > +
> > +extern void wb_rebalance(struct wb_node *node, struct wb_root *root);
> > +extern void wb_erase(struct wb_node *node, struct wb_root *root);
> > +extern struct wb_node *wb_first(struct wb_root *root);
> > +extern struct wb_node *wb_last(struct wb_root *root);
> > +extern struct wb_node *wb_next(struct wb_node *node);
> > +extern struct wb_node *wb_prev(struct wb_node *node);
> > +
> > +static inline void wb_set_weight(struct wb_node *node, unsigned long weight)
> > +{
> > +	node->wb_weight = weight;
> > +}
> > +
> > +static inline void wb_link_node(struct wb_node *node, struct wb_node *parent,
> > +				struct wb_node **wb_link)
> > +{
> > +	node->wb_left = node->wb_right = NULL;
> > +	node->wb_parent = parent;
> > +	*wb_link = node;
> > +}
> > +#endif /* _LINUX_WBTREE_H */
> > diff --git a/lib/Makefile b/lib/Makefile
> > index cbb774f..5c42e63 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -21,7 +21,8 @@ lib-y	+= kobject.o kref.o klist.o
> >
> >   obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> >   	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> > -	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
> > +	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
> > +	 wbtree.o
> >
> 
> obj-$(CONFIG_WEIGHT_BALANCED_TREE) += wbtree.o
> 
> then kvm can select it, and the impact on non-kvm kernels is removed.

Then we'd have issues trying to build an external kvm module for a
pre-existing non-kvm kernel.  Do we care?  If we were to take such a
path, I think the default should be on, kvm would depend on it, but we
could add an option to disable it for EMBEDDED/EXPERT.  Thanks,

Alex

