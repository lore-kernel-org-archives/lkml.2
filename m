Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0ELKZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:25:25 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37286 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0ELKZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:25:23 -0400
Date: Wed, 12 May 2010 15:55:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100512102518.GA30767@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
 <1273611585.1810.132.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273611585.1810.132.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-11 22:59:45]:

> On Thu, 2010-05-06 at 23:31 +0530, Srikar Dronamraju wrote:
> >   - Addressed comments from Oleg, including removal of interrupt context
> >     handlers, reverting background page replacement in favour of
> >     access_process_vm(). 
> 
> 
> > +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> > +                                               user_bkpt_opcode_t opcode)
> > +{
> > +       int ret;
> > +
> > +       if (!tsk)
> > +               return -EINVAL;
> > +
> > +       ret = access_process_vm(tsk, vaddr, &opcode, user_bkpt_opcode_sz, 1);
> > +       return (ret == user_bkpt_opcode_sz ? 0 : -EFAULT);
> > +}
> 
> Why!
> 
> That's not not the atomic sequence outlined.
> 


Yes, we had moved away from access_process_vm to background page
replacement in Version 1 and Version 2. 

One of the reasons being Mathieu suggesting to Jim in LFCS that 
for almost all architectures insertion of a breakpoint instruction on a
user page is an atomic operation, as far as the CPU is concerned.

Can you and other VM experts tell me if access_process_vm isnt going to
be atomic with respect to inserting/deleting a breakpoint instruction? 

Oleg had few questions which I didnt have answers. (Most of
which you have already answered yesterday). One thing that's still
missing is 

[ snipping from Oleg's mail: ]
-----
But suppose that the application does mprotect(PROT_WRITE)
after register_uprobe() installs the bp, now unregister_uprobe/etc
can't restore the original insn?  
---

Also I tried a write_opcode that uses background page replacement which 
addressed some of Oleg's comments.  The pseudo-code is here:
write_opcode()
{
	down_read(mmap_sem);

	get_user_pages(tsk, mm, vaddr, .. &old_page, &vma);

	anon_vma_prepare(vma);	

	new_page=alloc_page_vma(.., vma, vaddr);

	copy_user_page(new_page, old_page);

	kmap_atomic(new_page,...);

	memcpy(vaddr,..);

	kunmap_atomic(..);

	lock_page(new_page);

	old_pte = get_pte(mm,vaddr);

	replace_page(vma, new_page, old_page, old_pte);

	unlock_page(new_page);

	put_page(new_page);

	put_page(old_page);

	up_read(mmap);
}	


Will this work?

The Other VM quieries that I had were:

Is there any thing else needed for the parent process to pass on the anon_vma to
the child process. (I inserted a breakpoint in the parent and tried
removing the breakpoint in the child. 
However page_address_in_vma() (called by replace_page() returned
EFAULT because "vma->anon_vma != page_anon_vma(page)"

Do we need to take care of mem_cgroups?
Do we need to update mm counters?


--
Thanks and Regards
Srikar
