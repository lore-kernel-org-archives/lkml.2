Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0ELMNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:13:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0ELMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:13:11 -0400
Subject: Re: [PATCH v3 0/10] Uprobes v3
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20100512102518.GA30767@linux.vnet.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
	 <1273611585.1810.132.camel@laptop>
	 <20100512102518.GA30767@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 14:13:05 +0200
Message-ID: <1273666385.1626.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 15:55 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-05-11 22:59:45]:
> 
> > On Thu, 2010-05-06 at 23:31 +0530, Srikar Dronamraju wrote:
> > >   - Addressed comments from Oleg, including removal of interrupt context
> > >     handlers, reverting background page replacement in favour of
> > >     access_process_vm(). 
> > 
> > 
> > > +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> > > +                                               user_bkpt_opcode_t opcode)
> > > +{
> > > +       int ret;
> > > +
> > > +       if (!tsk)
> > > +               return -EINVAL;
> > > +
> > > +       ret = access_process_vm(tsk, vaddr, &opcode, user_bkpt_opcode_sz, 1);
> > > +       return (ret == user_bkpt_opcode_sz ? 0 : -EFAULT);
> > > +}
> > 
> > Why!
> > 
> > That's not not the atomic sequence outlined.
> > 
> 
> 
> Yes, we had moved away from access_process_vm to background page
> replacement in Version 1 and Version 2. 
> 
> One of the reasons being Mathieu suggesting to Jim in LFCS that 
> for almost all architectures insertion of a breakpoint instruction on a
> user page is an atomic operation, as far as the CPU is concerned.

That is true, however when restoring the old instruction you do need to
take care, so your usage from set_orig_insn() is dubious.

> Can you and other VM experts tell me if access_process_vm isnt going to
> be atomic with respect to inserting/deleting a breakpoint instruction? 

Well, clearly not, since it simply does a gup(.force=1), if whatever
page is there is writable it will simply poke at it.

Now writing the INT3 is special, but restoring the old insn is not and
might confuse another CPU that is currently trying to execute code near
there.

All in all, doing the page flip thing isn't hard at all and does avoid
any and all potential CPU decoder/i$ races.

> Oleg had few questions which I didnt have answers. (Most of
> which you have already answered yesterday). One thing that's still
> missing is 
> 
> [ snipping from Oleg's mail: ]
> -----
> But suppose that the application does mprotect(PROT_WRITE)
> after register_uprobe() installs the bp, now unregister_uprobe/etc
> can't restore the original insn?  

I wouldn't see why not. The mprotect() will only allow the application
to poke at its own private copy of the page (the one you COWed for it).

Of course the app, a ptrace-client and uprobes could go fighting over
who owns what INT3 (all 3 poking an INT3 at the same place, and one of
them removing it will confuse matters, but that's unavoidable).

But a nicely written flip will be atomic wrt concurrent writes (the
below is not).

> Also I tried a write_opcode that uses background page replacement which 
> addressed some of Oleg's comments.  The pseudo-code is here:

> write_opcode()
> {
> 	down_read(mmap_sem);
> 	get_user_pages(tsk, mm, vaddr, .. &old_page, &vma);
> 	anon_vma_prepare(vma);	
> 	new_page=alloc_page_vma(.., vma, vaddr);
> 	copy_user_page(new_page, old_page);
> 	kmap_atomic(new_page,...);
> 	memcpy(vaddr,..);
> 	kunmap_atomic(..);
> 	lock_page(new_page);
> 	old_pte = get_pte(mm,vaddr);
> 	replace_page(vma, new_page, old_page, old_pte);
> 	unlock_page(new_page);
> 	put_page(new_page);
> 	put_page(old_page);
> 	up_read(mmap);
> }	
> 
> 
> Will this work?

No, that's full of races. you need to copy and modify the original page
while holding the pte-lock and after you cleared the original pte.

You could possible skip the whole COW break logic by cheating and making
gup() do that, it would be a little extra overhead, but a lot less to
worry about.

Hrmm, you could do something like the above and use write_protect_page()
along with that lock_page() you do to sync against concurrent faults. It
won't be the fastest code around but it should work I guess.

Something like try_to_merge_one_page() in the KSM code:

write_opcode(struct mm_struct *mm, unsigned long address, void *insn,
int len)
{
	down_read(mm->mmap_sem);

	/* let gup() deal with COW and VM accounting */
	nr = get_user_pages(tsk, mm, address, 1, 1, 1, &old_page, &vma);
	if (!nr) goto fail;

	/* get ourselves a new page */
	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
	if (!new_page) goto fail;

	/* lock page will serialize against do_wp_page()'s PageAnon() handling */
	lock_page(old_page);

	/* mark the page RO so any concurrent access will end up in do_wp_page() */
	if (write_protect_page(vma, old_page, &orig_pte)) goto fail_locked;
	
	/* copy the page now that we've got it stable */
	vaddr_old = kmap_atomic(old_page);
	vaddr_new = kmap_atomic(new_page);

	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
	/* poke the new insn in, ASSUMES we don't cross page boundary */
	memcpy(vaddr_new + (address & PAGE_MASK), insn, len);

	kunmap_atomic(vaddr_new);
	kunmap_atomic(vaddr_old);

	/* XXX: frob mlock state */

	/* flip pages, do_wp_page() will fail pte_same() and bail */
	err = replace_page(vma, new_page, old_page, orig_pte)
	if (err) goto fail_more;

	/* we're done, let 'em rip */
	unlock_page(old_page);
	put_page(old_page);

	return;

fail:
	/* XXX: fixup stuff */
}

Note that this can fail for fun reasons like O_DIRECT IO, but that
should be very rare indeed on text pages.

> The Other VM quieries that I had were:
> 
> Is there any thing else needed for the parent process to pass on the anon_vma to
> the child process. (I inserted a breakpoint in the parent and tried
> removing the breakpoint in the child. 
> However page_address_in_vma() (called by replace_page() returned
> EFAULT because "vma->anon_vma != page_anon_vma(page)"

Yeah, anon_vma is a bit of a pain after Rik changed it, you need to
compare the oldest entries on the list or something.

> Do we need to take care of mem_cgroups?

Dunno, I've so far successfully avoided looking at them, but yeah, I
think you need to do like the regular COW path does when breaking COW.

> Do we need to update mm counters?

When breaking COW, yes, but the above code cheats and lets gup() worry
about that.

