Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab1FPS0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:26:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:56312 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab1FPS0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:26:23 -0400
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
In-Reply-To: <1308248588.13240.267.camel@twins>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
	 <1308161486.2171.61.camel@laptop>
	 <20110616032645.GF4952@linux.vnet.ibm.com>
	 <1308225626.13240.34.camel@twins>
	 <20110616130012.GL4952@linux.vnet.ibm.com>
	 <1308248588.13240.267.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 20:25:33 +0200
Message-ID: <1308248733.13240.269.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 20:23 +0200, Peter Zijlstra wrote:
> int __register_uprobe(...)
> {
>   uprobe = alloc_uprobe(...); // find or insert in tree
> 
>   vma_prio_tree_foreach(..) {
>     // get mm ref, add to list blah blah
>   }
> 
>   list_for_each_entry_safe() {
>     // del from list etc..
>     down_read(mm->mmap_sem);
>     ret = install_breakpoint();
>     if (ret && (ret != -ESRCH || ret != -EEXIST)) {
>       up_read(..);
>       goto fail;
>   }
> 
>   return 0;
> 
> fail:
>   list_for_each_entry_safe() {
>     // del from list, put mm
>   }
> 
>   return ret;
> }
> 
> void __unregister_uprobe(...)
> {
>   uprobe = find_uprobe(); // ref++
>   if (delete_consumer(...)); // includes tree removal on last consumer
>                              // implies we own the last ref
>      return; // consumers
> 
>   vma_prio_tree_foreach() {
>      // create list
>   }
> 
>   list_for_each_entry_safe() {
>     // remove from list
>     remove_breakpoint(); // unconditional, if it wasn't there
>                          // its a nop anyway, can't get any new
>                          // new probes on account of holding
>                          // uprobes_mutex and mmap() doesn't see
>                          // it due to tree removal.
>   }

   put_uprobe(); // last ref, *poof*
> }
> 
> int register_uprobe(...)
> {
>   int ret;
> 
>   mutex_lock(&uprobes_mutex);
>   ret = __register_uprobe(...);
>   if (!ret)
>     __unregister_uprobe(...);
>   mutex_unlock(&uprobes_mutex);
> 
>   ret;
> }
> 
> int mmap_uprobe(...)
> {
>   spin_lock(&uprobes_treelock);
>   for_each_probe_in_inode() {
>     // create list;
>   }
>   spin_unlock(..);
> 
>   list_for_each_entry_safe() {
>     // remove from list
>     ret = install_breakpoint();
>     if (ret)
>       goto fail;
>     if (!uprobe_still_there()) // takes treelock
>       remove_breakpoint();
>   }
> 
>   return 0;
> 
> fail:
>   list_for_each_entry_safe() {
>     // destroy list
>   }
>   return ret;
> } 
