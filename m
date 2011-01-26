Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1AZJK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:10:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58083 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:10:24 -0500
Date: Wed, 26 Jan 2011 14:33:46 +0530
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
Message-ID: <20110126090346.GH19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957739.28776.717.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295957739.28776.717.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> > +void uprobe_mmap(struct vm_area_struct *vma)
> > +{
> > +       struct list_head tmp_list;
> > +       struct uprobe *uprobe, *u;
> > +       struct mm_struct *mm;
> > +       struct inode *inode;
> > +
> > +       if (!valid_vma(vma))
> > +               return;
> > +
> > +       INIT_LIST_HEAD(&tmp_list);
> > +
> > +       /*
> > +        * The vma was just allocated and this routine gets called
> > +        * while holding write lock for mmap_sem.  Function called
> > +        * in context of a thread that has a reference to mm.
> > +        * Hence no need to take a reference to mm
> > +        */
> > +       mm = vma->vm_mm;
> > +       up_write(&mm->mmap_sem);
> 
> Are you very very sure its a good thing to simply drop the mmap_sem
> here? Also, why?
> 

I actually dont like to release the write_lock and then reacquire it.
write_opcode, which is called thro install_uprobe, i.e to insert the
actual breakpoint instruction takes a read lock on the mmap_sem.
Hence uprobe_mmap gets called in context with write lock on mmap_sem
held, I had to release it before calling install_uprobe.

Another solution, I thought of was to pass a context to write_opcode to
say that map-sem is already acquired by us. But I am not sure that
idea is good enuf. 

> > +       mutex_lock(&uprobes_mutex);
> > +
> > +       inode = vma->vm_file->f_mapping->host;
> 
> Since you just dropped the mmap_sem, what's keeping that vma from going
> away?
> 

How about dropping the mmap_sem after add_to_temp_list and cachng the
vma->vm_start value before calling add_to_temp_list?

Or if you have better ideas, then that would be great.

> > +       add_to_temp_list(vma, inode, &tmp_list);
> > +
> > +       list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> > +               mm->uprobes_vaddr = vma->vm_start + uprobe->offset;
> > +               install_uprobe(mm, uprobe);
> > +               list_del(&uprobe->pending_list);
> > +       }
> > +       mutex_unlock(&uprobes_mutex);
> > +       down_write(&mm->mmap_sem);
> > +} 
> 
> 
