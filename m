Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1AYMQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:16:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1AYMP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:29 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 13:15:40 +0100
Message-ID: <1295957740.28776.718.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
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
> +static int match_offset(struct uprobe *uprobe, unsigned long offset,
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
> +
> +/*
> + * Find a uprobe corresponding to a given inode:offset
> + * Acquires treelock
> + */
> +static struct uprobe *find_uprobe(struct inode * inode,
> +                                        unsigned long offset)
> +{
> +       struct rb_node *n = uprobes_tree.rb_node;
> +       struct uprobe *uprobe, *u = NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&treelock, flags);
> +       while (n) {
> +               uprobe = rb_entry(n, struct uprobe, rb_node);
> +
> +               if (match_inode(uprobe, inode, &n)) {
> +                       if (match_offset(uprobe, offset, &n)) {
> +                               if (atomic_inc_not_zero(&uprobe->ref))
> +                                       u = uprobe;
> +                               break;
> +                       }
> +               }
> +       }
> +       spin_unlock_irqrestore(&treelock, flags);
> +       return u;
> +}
> +
> +/*
> + * Check if a uprobe is already inserted;
> + *     If it does; return refcount incremented uprobe
> + *     else add the current uprobe and return NULL
> + * Acquires treelock.
> + */
> +static struct uprobe *insert_uprobe_rb_node(struct uprobe *uprobe)
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
> +                               atomic_inc(&u->ref);

If the lookup can find a 'dead' entry, then why can't we here?

> +                               goto unlock_return;
> +                       }
> +               }
> +       }
> +       u = NULL;
> +       rb_link_node(&uprobe->rb_node, parent, p);
> +       rb_insert_color(&uprobe->rb_node, &uprobes_tree);
> +       atomic_set(&uprobe->ref, 2);
> +
> +unlock_return:
> +       spin_unlock_irqrestore(&treelock, flags);
> +       return u;
> +} 

It would be nice if you could merge the find and 'acquire' thing, the
lookup is basically the same in both cases.

Also, I'm not quite sure on the name of that last function, its not a
strict insert and what's the trailing _rb_node about? That lookup isn't
called find_uprobe_rb_node() either is it?
