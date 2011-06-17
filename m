Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1FQE6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:58:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57897 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1FQE6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:58:04 -0400
Date: Fri, 17 Jun 2011 10:20:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
Message-ID: <20110617045000.GM4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
 <1308161486.2171.61.camel@laptop>
 <20110616032645.GF4952@linux.vnet.ibm.com>
 <1308225626.13240.34.camel@twins>
 <20110616130012.GL4952@linux.vnet.ibm.com>
 <1308248588.13240.267.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308248588.13240.267.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> }
> 

This would have a bigger race.
A breakpoint might be hit by which time the node is removed and we
have no way to find out the uprobe. So we deliver an extra TRAP to the
app.



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
> 


register_uprobe will race with mmap_uprobe's first pass.
So we might end up with a vma that doesnot have a breakpoint inserted
but inserted in all other vma that map to the same inode.

-- 
Thanks and Regards
Srikar
