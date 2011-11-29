Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1K2IfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:35:15 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60002 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1K2IfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:35:13 -0500
Date: Tue, 29 Nov 2011 14:03:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, tulasidhard@gmail.com
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
Message-ID: <20111129083322.GD13445@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
 <1322071812.14799.87.camel@twins>
 <20111124134742.GH28065@linux.vnet.ibm.com>
 <1322492384.2921.143.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322492384.2921.143.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112908-3270-0000-0000-00000232A547
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +                       ret = install_breakpoint(vma->vm_mm, uprobe);
> > > > +                       if (ret == -EEXIST) {
> > > > +                               atomic_inc(&vma->vm_mm->mm_uprobes_count);
> > > > +                               ret = 0;
> > > > +                       } 
> > > 
> > > Aren't you double counting that probe position here? The one that raced
> > > you to inserting it will also have incremented that counter, no?
> > > 
> > 
> > No we arent.
> > Because register_uprobe can never race with mmap_uprobe and register
> > before mmap_uprobe registers .(Once we start mmap_region,
> > register_uprobe waits for the read_lock of mmap_sem.)
> > 
> > And we badly need this for mmap_uprobe case.  Because when we do mremap,
> > or vma_adjust(), we do a munmap_uprobe() followed by mmap_uprobe() which
> > would have decremented the count but not removed it. So when we do a
> > mmap_uprobe, we need to increment the count. 
> 
> Ok, so I didn't parse that properly last time around.. but it still
> doesn't make sense, why would munmap_uprobe() decrement the count but
> not uninstall the probe?
> 
> install_breakpoint() returning -EEXIST on two different conditions
> doesn't help either.
> 
> So what I think you're doing is that you're optimizing the unmap case
> since the memory is going to be thrown out fixing up the instruction is
> a waste of time, but this leads to the asymmetry observed above. But you

Yes, we are optimizing the unmap case, because we expect the memory to
be thrown out.

> fail to mention this in both the changelog or a comment near that
> -EEXIST branch in mmap_uprobe.
> 
> Worse, you don't explain how the other -EEXIST (!consumers) thing
> interacts here, and I just gave up trying to figure that out since it
> made my head hurt.
> 

install_breakpoints cannot have !consumers to be true when called from
register_uprobe. (Since unregister_uprobe() which does the removal of
consumer cannot race with register_uprobe().)

Now lets consider mmap_uprobe() being called from vm_adjust(), the
preceding unmap_uprobe() has already decremented the count but left the
count intact.

if consumers is NULL, unregister_uprobes() has kicked already in, so
there is no point in inserting the probe, Hence we return EEXIST. The
following unregister_uprobe() (or the munmap_uprobe() which might race
before unregister_uprobe) is also going to decrement the count.  So we
have a case where the same breakpoint is accounted as removed twice. To
offset this, we pretend as if the breakpoint is around by incrementing
the count.

Would it help if I add an extra check in mmap_uprobe?

int mmap_uprobe(...) {
....
	       ret = install_breakpoint(vma->vm_mm, uprobe);
	       if (ret == -EEXIST) {
			if (!read_opcode(vma->vm_mm, vaddr, &opcode) &&
					(opcode == UPROBES_BKPT_INSN))
			       atomic_inc(&vma->vm_mm->mm_uprobes_count);
		       ret = 0;
	       } 
....
}


The extra read_opcode check will tell us if the breakpoint is still
around and then only increment the count. (As in it will distinguish if
the mmap_uprobe is from vm_adjust).

-- 
Thanks and Regards
Srikar

