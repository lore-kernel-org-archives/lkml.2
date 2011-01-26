Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1AZPUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:20:47 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54776 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1AZPUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:20:45 -0500
Date: Wed, 26 Jan 2011 20:39:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
Message-ID: <20110126150946.GK19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957741.28776.719.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295957741.28776.719.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 13:15:41]:

> On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> > +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> > +               struct list_head *tmp_list);
> > +
> > +static void add_to_temp_list(struct vm_area_struct *vma, struct inode *inode,
> > +               struct list_head *tmp_list)
> > +{
> > +       struct uprobe *uprobe;
> > +       struct rb_node *n;
> > +       unsigned long flags;
> > +
> > +       n = uprobes_tree.rb_node;
> > +       spin_lock_irqsave(&treelock, flags);
> > +       while (n) {
> > +               uprobe = rb_entry(n, struct uprobe, rb_node);
> > +               if (match_inode(uprobe, inode, &n)) {
> > +                       list_add(&uprobe->pending_list, tmp_list);
> > +                       search_within_subtree(n, inode, tmp_list);
> > +                       break;
> > +               }
> > +       }
> > +       spin_unlock_irqrestore(&treelock, flags);
> > +}
> > +
> > +static void __search_within_subtree(struct rb_node *p, struct inode *inode,
> > +               struct list_head *tmp_list)
> > +{
> > +       struct uprobe *uprobe;
> > +
> > +       uprobe = rb_entry(p, struct uprobe, rb_node);
> > +       if (match_inode(uprobe, inode, &p)) {
> > +               list_add(&uprobe->pending_list, tmp_list);
> > +               search_within_subtree(p, inode, tmp_list);
> > +       }
> > +
> > +
> > +}
> > +
> > +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> > +               struct list_head *tmp_list)
> > +{
> > +       struct rb_node *p;
> > +
> > +       if (p)
> > +               __search_within_subtree(p, inode, tmp_list);
> > +
> > +       p = n->rb_right;
> > +       if (p)
> > +               __search_within_subtree(p, inode, tmp_list);
> > +} 
> 
> Whee recursion FTW!, you just blew your kernel stack :-)
> 
> Since you sort inode first, offset second, I think you can simply look
> for the first matching inode entry and simply rb_next() until you don't
> match.

Agree that we should get rid of recursion.

I dont think we can simply use rb_next() once we have the first
matching function. There could be a matching inode but a smaller
offset in left that will be missed by rb_next(). (Unless I have
misunderstood rb_next() !!!)

Here are the ways I think we can workaround.
A. change the match_inode() logic to use rb_first/rb_next.
This would make negate the benefit we get from rb_trees because we
have to match every node. Also match_offset might get a little tricky.

B. use the current match_inode but change the search_within_subtree
logic. search_within_subtree() would first find the leftmode node
within the subtree that still has the same inode. Thereafter it will use
rb_next().

Do you have any other ideas?

-- 
Thanks and Regards
Srikar
