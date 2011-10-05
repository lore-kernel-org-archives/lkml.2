Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984Ab1JEQ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:26:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40826 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476Ab1JEQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:26:58 -0400
Date: Wed, 5 Oct 2011 21:39:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 5/26]   Uprobes: copy of the original
 instruction.
Message-ID: <20111005160934.GC806@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120057.25326.63780.sendpatchset@srdronam.in.ibm.com>
 <20111003162905.GA3752@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111003162905.GA3752@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-03 18:29:05]:

> On 09/20, Srikar Dronamraju wrote:
> >
> > +static int __copy_insn(struct address_space *mapping,
> > +			struct vm_area_struct *vma, char *insn,
> > +			unsigned long nbytes, unsigned long offset)
> > +{
> > +	struct file *filp = vma->vm_file;
> > +	struct page *page;
> > +	void *vaddr;
> > +	unsigned long off1;
> > +	unsigned long idx;
> > +
> > +	if (!filp)
> > +		return -EINVAL;
> > +
> > +	idx = (unsigned long) (offset >> PAGE_CACHE_SHIFT);
> > +	off1 = offset &= ~PAGE_MASK;
> > +
> > +	/*
> > +	 * Ensure that the page that has the original instruction is
> > +	 * populated and in page-cache.
> > +	 */
> 
> Hmm. But how we can ensure?
> 
> > +	page_cache_sync_readahead(mapping, &filp->f_ra, filp, idx, 1);
> 
> This schedules the i/o,
> 
> > +	page = grab_cache_page(mapping, idx);
> 
> This finds/locks the page in the page-cache,
> 
> > +	if (!page)
> > +		return -ENOMEM;
> > +
> > +	vaddr = kmap_atomic(page);
> > +	memcpy(insn, vaddr + off1, nbytes);
> 
> What if this page is not PageUptodate() ?
> 
> Somehow this assumes that the i/o was already completed, I don't
> understand this.
> 
> But I am starting to think I simply do not understand this change.
> To the point, I do not underestand why do we need copy_insn() at all.
> We are going to replace this page, can't we save/analyze ->insn later
> when we copy the content of the old page? Most probably I missed
> something simple...
> 

Copying the instruction at the time we replace the original instruction
would have been ideal. However there are a few irritants to handle.

 - While inserting the breakpoint, we might find that the original
   instruction to be the breakpoint instruction itself. (This could
   happen if mmap_uprobe were to race with register_uprobe() or somebody
   else like gdb inserted a breakpoint). How do we distinguish if the
   breakpoint instruction was around in the text or somebody inserted a
   breakpoint in that address-space? Since we read from the page-cache,
   we can easily resolve this.

-  On archs like x86, with variable size instructions, the original
   instruction can be across 2 pages. This is because we copy the
   maximum instruction size from the given vaddr into a buffer for
   subsequent analysis. So the copy_insn takes care of getting two pages
   if and when required. 
   Currently the insert and remove breakpoint
   assumes that the instruction size of a breakpoint is the smallest
   size for that architecture. Hence reading/writing to one page in
   write_opcode is good enough.

-  Again on variable instruction size supporting archs, if two
   subsequent instructions are probed, the original instruction if
   copied using get_user_pages might already have a breakpoint included.
   (This shouldnt have any effect on the uprobes though.)

-- 
Thanks and Regards
Srikar
