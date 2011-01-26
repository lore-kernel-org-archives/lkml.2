Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1AZIu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:50:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44325 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1AZIu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:50:57 -0500
Date: Wed, 26 Jan 2011 14:07:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@kvack.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
Message-ID: <20110126083743.GC19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
 <1295957740.28776.718.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295957740.28776.718.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       spin_lock_irqsave(&treelock, flags);
> > +       while (*p) {
> > +               parent = *p;
> > +               u = rb_entry(parent, struct uprobe, rb_node);
> > +               if (u->inode > uprobe->inode)
> > +                       p = &(*p)->rb_left;
> > +               else if (u->inode < uprobe->inode)
> > +                       p = &(*p)->rb_right;
> > +               else {
> > +                       if (u->offset > uprobe->offset)
> > +                               p = &(*p)->rb_left;
> > +                       else if (u->offset < uprobe->offset)
> > +                               p = &(*p)->rb_right;
> > +                       else {
> > +                               atomic_inc(&u->ref);
> 
> If the lookup can find a 'dead' entry, then why can't we here?
> 

If a new user of a uprobe comes up as when the last registered user was
removing the uprobe, we keep the uprobe entry till the new user
loses interest in that uprobe.

> > +                               goto unlock_return;
> > +                       }
> > +               }
> > +       }
> > +       u = NULL;
> > +       rb_link_node(&uprobe->rb_node, parent, p);
> > +       rb_insert_color(&uprobe->rb_node, &uprobes_tree);
> > +       atomic_set(&uprobe->ref, 2);
> > +
> > +unlock_return:
> > +       spin_unlock_irqrestore(&treelock, flags);
> > +       return u;
> > +} 
> 
> It would be nice if you could merge the find and 'acquire' thing, the
> lookup is basically the same in both cases.
> 
> Also, I'm not quite sure on the name of that last function, its not a
> strict insert and what's the trailing _rb_node about? That lookup isn't
> called find_uprobe_rb_node() either is it?

Since we already have a install_uprobe, register_uprobe, I thought
insert_uprobe_rb_node would give context to that function that it was
only inserting an rb_node but not installing the actual breakpoint.
I am okay to rename it to insert_uprobe(). 
