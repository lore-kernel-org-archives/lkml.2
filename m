Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1FIXBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:01:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:45575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab1FIW7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:59:54 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 01:03:26 +0200
Message-ID: <1307660606.2497.1770.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> +/*
> + * There could be threads that have hit the breakpoint and are entering the
> + * notifier code and trying to acquire the uprobes_treelock. The thread
> + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> + * race with these threads and might acquire the uprobes_treelock compared
> + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> + * threads will not find the uprobe. Finding if a "trap" instruction was
> + * present at the interrupting address is racy. Hence provide some extra
> + * time (by way of synchronize_sched() for breakpoint hit threads to acquire
> + * the uprobes_treelock before the uprobe is removed from the rbtree.
> + */

'some' extra time doesn't really sound convincing to me. Either it is
sufficient to avoid the race or it is not. It reads to me like: we add a
delay so that the race mostly doesn't occur. Not good ;-)

> +static void delete_uprobe(struct uprobe *uprobe)
> +{
> +       unsigned long flags;
> +
> +       synchronize_sched();
> +       spin_lock_irqsave(&uprobes_treelock, flags);
> +       rb_erase(&uprobe->rb_node, &uprobes_tree);
> +       spin_unlock_irqrestore(&uprobes_treelock, flags);
> +       iput(uprobe->inode);
> +} 

Also what are the uprobe lifetime rules here? Does it still exist after
this returns?

The comment in del_consumer() that says: 'drop creation ref' worries me
and makes me thing that is the last reference around and the uprobe will
be freed right there, which clearly cannot happen since its not yet
removed from the RB-tree.


