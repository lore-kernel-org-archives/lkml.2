Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1DRMVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:21:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1DRMVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:21:40 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 5/26]  5: uprobes: Adding and remove
 a uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110401143328.15455.19094.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143328.15455.19094.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 14:20:28 +0200
Message-ID: <1303129228.32491.777.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:03 +0530, Srikar Dronamraju wrote:
> +static int match_inode(struct uprobe *uprobe, struct inode *inode,
> +                                               struct rb_node **p)
> +{
> +       struct rb_node *n = *p;
> +
> +       if (inode < uprobe->inode)
> +               *p = n->rb_left;
> +       else if (inode > uprobe->inode)
> +               *p = n->rb_right;
> +       else
> +               return 1;
> +       return 0;
> +}
> +
> +static int match_offset(struct uprobe *uprobe, loff_t offset,
> +                                               struct rb_node **p)
> +{
> +       struct rb_node *n = *p;
> +
> +       if (offset < uprobe->offset)
> +               *p = n->rb_left;
> +       else if (offset > uprobe->offset)
> +               *p = n->rb_right;
> +       else
> +               return 1;
> +       return 0;
> +}
>+
> +/* Called with treelock held */
> +static struct uprobe *__find_uprobe(struct inode * inode,
> +                        loff_t offset, struct rb_node **near_match)
> +{
> +       struct rb_node *n = uprobes_tree.rb_node;
> +       struct uprobe *uprobe, *u = NULL;
> +
> +       while (n) {
> +               uprobe = rb_entry(n, struct uprobe, rb_node);
> +               if (match_inode(uprobe, inode, &n)) {
> +                       if (near_match)
> +                               *near_match = n;
> +                       if (match_offset(uprobe, offset, &n)) {
> +                               /* get access ref */
> +                               atomic_inc(&uprobe->ref);
> +                               u = uprobe;
> +                               break;
> +                       }
> +               }
> +       }
> +       return u;
> +}

Here you break out the match functions for some reason.

> +/*
> + * Find a uprobe corresponding to a given inode:offset
> + * Acquires treelock
> + */
> +static struct uprobe *find_uprobe(struct inode * inode, loff_t offset)
> +{
> +       struct uprobe *uprobe;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&treelock, flags);
> +       uprobe = __find_uprobe(inode, offset, NULL);
> +       spin_unlock_irqrestore(&treelock, flags);
> +       return uprobe;
> +}
> +
> +/*
> + * Acquires treelock.
> + * Matching uprobe already exists in rbtree;
> + *     increment (access refcount) and return the matching uprobe.
> + *
> + * No matching uprobe; insert the uprobe in rb_tree;
> + *     get a double refcount (access + creation) and return NULL.
> + */
> +static struct uprobe *insert_uprobe(struct uprobe *uprobe)
> +{
> +       struct rb_node **p = &uprobes_tree.rb_node;
> +       struct rb_node *parent = NULL;
> +       struct uprobe *u;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&treelock, flags);
> +       while (*p) {
> +               parent = *p;
> +               u = rb_entry(parent, struct uprobe, rb_node);
> +               if (u->inode > uprobe->inode)
> +                       p = &(*p)->rb_left;
> +               else if (u->inode < uprobe->inode)
> +                       p = &(*p)->rb_right;
> +               else {
> +                       if (u->offset > uprobe->offset)
> +                               p = &(*p)->rb_left;
> +                       else if (u->offset < uprobe->offset)
> +                               p = &(*p)->rb_right;
> +                       else {
> +                               /* get access ref */
> +                               atomic_inc(&u->ref);
> +                               goto unlock_return;
> +                       }
> +               }
> +       }
> +       u = NULL;
> +       rb_link_node(&uprobe->rb_node, parent, p);
> +       rb_insert_color(&uprobe->rb_node, &uprobes_tree);
> +       /* get access + drop ref */
> +       atomic_set(&uprobe->ref, 2);
> +
> +unlock_return:
> +       spin_unlock_irqrestore(&treelock, flags);
> +       return u;
> +} 

And here you open-code the match functions..

Why not have something like:

static int match_probe(struct uprobe *l, struct uprobe *r)
{
	if (l->inode < r->inode)
		return -1;
	else if (l->inode > r->inode)
		return 1;
	else {
		if (l->offset < r->offset)
			return -1;
		else if (l->offset > r->offset)
			return 1;
	}

	return 0;
}

And use that as:

static struct uprobe *
__find_uprobe(struct inode *inode, loff_t offset)
{
	struct uprobe r = { .inode = inode, .offset = offset };
	struct rb_node *n = uprobes_tree.rb_node;
	struct uprobe *uprobe;
	int match;

	while (n) {
		uprobe = rb_node(n, struct uprobe, rb_node);
		match = match_probe(uprobe, &r);
		if (!match) {
			atomic_inc(&uprobe->ref);
			return uprobe;
		}
		if (match < 0)
			n = n->rb_left;
		else
			n = n->rb_right;
	}

	return NULL;
}

static struct uprobe *__insert_uprobe(struct uprobe *uprobe)
{
	struct rb_node **p = &uprobes_tree.rb_node;
	struct rn_node *parent = NULL;
	struct uprobe *u;
	int match;

	while (*p) {
		parent = *p;
		u = rb_entry(parent, struct uprobe, rb_node);
		match = match_uprobe(u, uprobe);
		if (!match) {
			atomic_inc(&u->ref);
			return u;
		}
		if (match < 0)
			p = &parent->rb_left;
		else
			p = &parent->rb_right;
	}

	atomic_set(&uprobe->ref, 2);
	rb_link_node(&uprobe->rb_node, parent, p);
	rb_insert_color(&uprobe->rb_node, &uprobes_tree);
	return uprobe;
}

Isn't that much nicer?
