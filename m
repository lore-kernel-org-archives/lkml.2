Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1FPFem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:34:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40232 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1FPFel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:34:41 -0400
Date: Thu, 16 Jun 2011 10:56:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
Message-ID: <20110616052639.GI4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
 <1307660606.2497.1770.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1307660606.2497.1770.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-10 01:03:26]:

> On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> > +/*
> > + * There could be threads that have hit the breakpoint and are entering the
> > + * notifier code and trying to acquire the uprobes_treelock. The thread
> > + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> > + * race with these threads and might acquire the uprobes_treelock compared
> > + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> > + * threads will not find the uprobe. Finding if a "trap" instruction was
> > + * present at the interrupting address is racy. Hence provide some extra
> > + * time (by way of synchronize_sched() for breakpoint hit threads to acquire
> > + * the uprobes_treelock before the uprobe is removed from the rbtree.
> > + */
> 
> 'some' extra time doesn't really sound convincing to me. Either it is
> sufficient to avoid the race or it is not. It reads to me like: we add a
> delay so that the race mostly doesn't occur. Not good ;-)

The extra time provided is sufficient to avoid the race. So will modify
it to mean "sufficient" instead of "some".

> 
> > +static void delete_uprobe(struct uprobe *uprobe)
> > +{
> > +       unsigned long flags;
> > +
> > +       synchronize_sched();
> > +       spin_lock_irqsave(&uprobes_treelock, flags);
> > +       rb_erase(&uprobe->rb_node, &uprobes_tree);
> > +       spin_unlock_irqrestore(&uprobes_treelock, flags);
> > +       iput(uprobe->inode);
> > +} 
> 
> Also what are the uprobe lifetime rules here? Does it still exist after
> this returns?
> 
> The comment in del_consumer() that says: 'drop creation ref' worries me
> and makes me thing that is the last reference around and the uprobe will
> be freed right there, which clearly cannot happen since its not yet
> removed from the RB-tree.
> 

When del_consumer() is called in unregister_uprobe() it has atleast two
(or more if the uprobe is hit) references. One at the creation time and
the other thro find_uprobe() called in unregister_uprobe before
del_consumer. So the reference lost in del_consumer is never the last
reference.  I added a commented this as creation reference so that the
find_uprobe and the put_uprobe() before return would match.

If the comment is confusing I can delete it or reword it as suggested by
Steven Rostedt which is  /* Have caller drop the creation ref */

I would prefer to delete the comment.

-- 
Thanks and Regards
Srikar
