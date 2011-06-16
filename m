Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab1FPSYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:24:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1FPSYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:24:13 -0400
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
In-Reply-To: <20110616130012.GL4952@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
	 <1308161486.2171.61.camel@laptop>
	 <20110616032645.GF4952@linux.vnet.ibm.com>
	 <1308225626.13240.34.camel@twins>
	 <20110616130012.GL4952@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 20:23:08 +0200
Message-ID: <1308248588.13240.267.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 18:30 +0530, Srikar Dronamraju wrote:

> Now since a register and mmap operations can run in parallel, we could
> have subtle race conditions like this:
> 
> 1. register_uprobe inserts the uprobe in RB tree.
> 2. register_uprobe loops thro vmas and inserts breakpoints.
> 
> 3. mmap is called for same inode, mmap_uprobe() takes reference; 
> 4. mmap completes insertion and releases reference.
> 
> 5. register uprobe tries to install breakpoint on one vma fails and not
> due to -ESRCH or -EEXIST.
> 6. register_uprobe rolls back all install breakpoints except the one
> inserted by mmap.
> 
> We end up with breakpoints that we have inserted by havent cleared.
> 
> Similarly unregister_uprobe might be looping to remove the breakpoints
> when mmap comes in installs the breakpoint and returns.
> unregister_uprobe might erase the uprobe from rbtree after mmap is done.

Well yes, but that's mostly because of how you use those lists.

int __register_uprobe(...)
{
  uprobe = alloc_uprobe(...); // find or insert in tree

  vma_prio_tree_foreach(..) {
    // get mm ref, add to list blah blah
  }

  list_for_each_entry_safe() {
    // del from list etc..
    down_read(mm->mmap_sem);
    ret = install_breakpoint();
    if (ret && (ret != -ESRCH || ret != -EEXIST)) {
      up_read(..);
      goto fail;
  }

  return 0;

fail:
  list_for_each_entry_safe() {
    // del from list, put mm
  }

  return ret;
}

void __unregister_uprobe(...)
{
  uprobe = find_uprobe(); // ref++
  if (delete_consumer(...)); // includes tree removal on last consumer
                             // implies we own the last ref
     return; // consumers

  vma_prio_tree_foreach() {
     // create list
  }

  list_for_each_entry_safe() {
    // remove from list
    remove_breakpoint(); // unconditional, if it wasn't there
                         // its a nop anyway, can't get any new
                         // new probes on account of holding
                         // uprobes_mutex and mmap() doesn't see
                         // it due to tree removal.
  }
}

int register_uprobe(...)
{
  int ret;

  mutex_lock(&uprobes_mutex);
  ret = __register_uprobe(...);
  if (!ret)
    __unregister_uprobe(...);
  mutex_unlock(&uprobes_mutex);

  ret;
}

int mmap_uprobe(...)
{
  spin_lock(&uprobes_treelock);
  for_each_probe_in_inode() {
    // create list;
  }
  spin_unlock(..);

  list_for_each_entry_safe() {
    // remove from list
    ret = install_breakpoint();
    if (ret)
      goto fail;
    if (!uprobe_still_there()) // takes treelock
      remove_breakpoint();
  }

  return 0;

fail:
  list_for_each_entry_safe() {
    // destroy list
  }
  return ret;
}

Should work I think, no?
