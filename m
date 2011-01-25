Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1AYMPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:15:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1AYMPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:40 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
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
In-Reply-To: <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 13:15:41 +0100
Message-ID: <1295957741.28776.719.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> +               struct list_head *tmp_list);
> +
> +static void add_to_temp_list(struct vm_area_struct *vma, struct inode *inode,
> +               struct list_head *tmp_list)
> +{
> +       struct uprobe *uprobe;
> +       struct rb_node *n;
> +       unsigned long flags;
> +
> +       n = uprobes_tree.rb_node;
> +       spin_lock_irqsave(&treelock, flags);
> +       while (n) {
> +               uprobe = rb_entry(n, struct uprobe, rb_node);
> +               if (match_inode(uprobe, inode, &n)) {
> +                       list_add(&uprobe->pending_list, tmp_list);
> +                       search_within_subtree(n, inode, tmp_list);
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&treelock, flags);
> +}
> +
> +static void __search_within_subtree(struct rb_node *p, struct inode *inode,
> +               struct list_head *tmp_list)
> +{
> +       struct uprobe *uprobe;
> +
> +       uprobe = rb_entry(p, struct uprobe, rb_node);
> +       if (match_inode(uprobe, inode, &p)) {
> +               list_add(&uprobe->pending_list, tmp_list);
> +               search_within_subtree(p, inode, tmp_list);
> +       }
> +
> +
> +}
> +
> +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> +               struct list_head *tmp_list)
> +{
> +       struct rb_node *p;
> +
> +       if (p)
> +               __search_within_subtree(p, inode, tmp_list);
> +
> +       p = n->rb_right;
> +       if (p)
> +               __search_within_subtree(p, inode, tmp_list);
> +} 

Whee recursion FTW!, you just blew your kernel stack :-)

Since you sort inode first, offset second, I think you can simply look
for the first matching inode entry and simply rb_next() until you don't
match.
