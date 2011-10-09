Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017Ab1JIMGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 08:06:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33915 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab1JIMGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 08:06:03 -0400
Date: Sun, 9 Oct 2011 17:17:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 18/26]   uprobes: slot allocation.
Message-ID: <20111009114745.GA6810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
 <20111007183740.GC1655@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111007183740.GC1655@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-07 20:37:40]:

> On 09/20, Srikar Dronamraju wrote:
> >
> > - * valid_vma: Verify if the specified vma is an executable vma
> > + * valid_vma: Verify if the specified vma is an executable vma,
> > + * but not an XOL vma.
> >   *	- Return 1 if the specified virtual address is in an
> > - *	  executable vma.
> > + *	  executable vma, but not in an XOL vma.
> >   */
> >  static bool valid_vma(struct vm_area_struct *vma)
> >  {
> > +	struct uprobes_xol_area *area = vma->vm_mm->uprobes_xol_area;
> > +
> >  	if (!vma->vm_file)
> >  		return false;
> >
> > +	if (area && (area->vaddr == vma->vm_start))
> > +			return false;
> 
> Could you explain why do we need this "but not an XOL vma" check?
> xol_vma->vm_file is always NULL, no?
> 

Yes, xol_vma->vm_file is always NULL.
previously we used shmem_file_setup before we map the XOL area.
However we now use init_creds instead, so this should also change
accordingly. Will correct this.

> > +static struct uprobes_xol_area *xol_alloc_area(void)
> > +{
> > +	struct uprobes_xol_area *area = NULL;
> > +
> > +	area = kzalloc(sizeof(*area), GFP_KERNEL);
> > +	if (unlikely(!area))
> > +		return NULL;
> > +
> > +	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long),
> > +								GFP_KERNEL);
> > +
> > +	if (!area->bitmap)
> > +		goto fail;
> > +
> > +	init_waitqueue_head(&area->wq);
> > +	spin_lock_init(&area->slot_lock);
> > +	if (!xol_add_vma(area) && !current->mm->uprobes_xol_area) {
> > +		task_lock(current);
> > +		if (!current->mm->uprobes_xol_area) {
> > +			current->mm->uprobes_xol_area = area;
> > +			task_unlock(current);
> > +			return area;
> > +		}
> > +		task_unlock(current);
> 
> But you can't rely on task_lock(), you can race with another thread
> with the same ->mm. I guess you need mmap_sem or xchg().

Agree, 
I think its better to use cmpxchg instead of xchg(). Otherwise,
(using xchg), I would set area to new value, but the old area might be in
use already. So I cant unmap the old area.

If I use cmpxchg, I can free up the new area if previous area is non
NULL.

However setting uprobes_xol_area in xol_add_vma() where we already take
mmap_sem for write while maping the xol_area is the best option.

> 
> >  static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs,
> >  				unsigned long vaddr)
> >  {
> > -	/* TODO: Yet to be implemented */
> > +	if (xol_get_insn_slot(uprobe, vaddr) && !pre_xol(uprobe, regs)) {
> > +		set_instruction_pointer(regs, current->utask->xol_vaddr);
> 
> set_instruction_pointer() looks unneded, pre_xol() has already changed
> regs->ip.
> 

Agree.

-- 
Thanks and Regards
Srikar
