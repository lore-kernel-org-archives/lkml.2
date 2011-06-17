Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1FQIFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:05:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:47858 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1FQIEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:04:52 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110617045000.GM4952@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
	 <1308161486.2171.61.camel@laptop>
	 <20110616032645.GF4952@linux.vnet.ibm.com>
	 <1308225626.13240.34.camel@twins>
	 <20110616130012.GL4952@linux.vnet.ibm.com>
	 <1308248588.13240.267.camel@twins>
	 <20110617045000.GM4952@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Jun 2011 10:03:56 +0200
Message-ID: <1308297836.13240.380.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 10:20 +0530, Srikar Dronamraju wrote:
> > 
> > void __unregister_uprobe(...)
> > {
> >   uprobe = find_uprobe(); // ref++
> >   if (delete_consumer(...)); // includes tree removal on last consumer
> >                              // implies we own the last ref
> >      return; // consumers
> > 
> >   vma_prio_tree_foreach() {
> >      // create list
> >   }
> > 
> >   list_for_each_entry_safe() {
> >     // remove from list
> >     remove_breakpoint(); // unconditional, if it wasn't there
> >                          // its a nop anyway, can't get any new
> >                          // new probes on account of holding
> >                          // uprobes_mutex and mmap() doesn't see
> >                          // it due to tree removal.
> >   }
> > }
> > 
> 
> This would have a bigger race.
> A breakpoint might be hit by which time the node is removed and we
> have no way to find out the uprobe. So we deliver an extra TRAP to the
> app.

Gah indeed. Back to the drawing board for me.

> > int mmap_uprobe(...)
> > {
> >   spin_lock(&uprobes_treelock);
> >   for_each_probe_in_inode() {
> >     // create list;
> >   }
> >   spin_unlock(..);
> > 
> >   list_for_each_entry_safe() {
> >     // remove from list
> >     ret = install_breakpoint();
> >     if (ret)
> >       goto fail;
> >     if (!uprobe_still_there()) // takes treelock
> >       remove_breakpoint();
> >   }
> > 
> >   return 0;
> > 
> > fail:
> >   list_for_each_entry_safe() {
> >     // destroy list
> >   }
> >   return ret;
> > }
> > 
> 
> 
> register_uprobe will race with mmap_uprobe's first pass.
> So we might end up with a vma that doesnot have a breakpoint inserted
> but inserted in all other vma that map to the same inode.

I'm not seeing this though, if mmap_uprobe() is before register_uprobe()
inserts the probe in the tree, the vma is already in the rmap and
register_uprobe() will find it in its vma walk. If its after,
mmap_uprobe() will find it and install, if a concurrent
register_uprobe()'s vma walk also finds it, it will -EEXISTS and ignore
the error.

