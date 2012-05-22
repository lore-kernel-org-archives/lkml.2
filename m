Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2EVIGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:06:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37096 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2EVIGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:06:24 -0400
Date: Tue, 22 May 2012 13:35:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, anton@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de, oleg@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
        andi@firstfloor.org, hch@infradead.org, ananth@in.ibm.com,
        vda.linux@googlemail.com, masami.hiramatsu.pt@hitachi.com,
        acme@infradead.org, sfr@canb.auug.org.au, roland@hack.frob.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes, mm, x86: Add the ability to
 install and remove uprobes breakpoints
Message-ID: <20120522080513.GC10829@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120209092642.GE16600@linux.vnet.ibm.com>
 <tip-2b144498350860b6ee9dc57ff27a93ad488de5dc@git.kernel.org>
 <20120521143701.74ab2d0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120521143701.74ab2d0b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052208-1780-0000-0000-000005C742FE
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000276; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00141327; UDB=6.00032653; UTC=2012-05-22
 08:06:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> static void unmap_single_vma(struct mmu_gather *tlb,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		unsigned long end_addr,
> 		struct zap_details *details)
> {
> 	unsigned long start = max(vma->vm_start, start_addr);
> 	unsigned long end;
> 
> 	if (start >= vma->vm_end)
> 		return;
> 	end = min(vma->vm_end, end_addr);
> 	if (end <= vma->vm_start)
> 		return;
> 
> <<<<<<< HEAD
> =======
> 	if (vma->vm_file)
> 		uprobe_munmap(vma, start, end);
> 
> 	if (vma->vm_flags & VM_ACCOUNT)
> 		*nr_accounted += (end - start) >> PAGE_SHIFT;
> 
> >>>>>>> linux-next/akpm-base
> 	if (unlikely(is_pfn_mapping(vma)))
> 		untrack_pfn_vma(vma, 0, 0);
> 
> 
> It made me look at uprobes.  Noticed a few things...
> 

I have responded to why I had to add a callback in unmap_single_vma in
response to Linus.

> > ...
> >
> > +static struct rb_root uprobes_tree = RB_ROOT;
> > +static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
> > +
> > +#define UPROBES_HASH_SZ	13
> > +/* serialize (un)register */
> > +static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
> > +#define uprobes_hash(v)	(&uprobes_mutex[((unsigned long)(v)) %\
> > +						UPROBES_HASH_SZ])
> > +
> > +/* serialize uprobe->pending_list */
> > +static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
> > +#define uprobes_mmap_hash(v)	(&uprobes_mmap_mutex[((unsigned long)(v)) %\
> > +						UPROBES_HASH_SZ])
> 
> Presumably these locks were hashed for scalability reasons?

Yes, 

uprobe_mmap_mutex is taken on every mmap/munmap operation. 
Since we do a per file operation per mm operation, (walk thro the rmap and 
insert/remove breakpoints), we looked at using i_mutex. However
Christoph wasnt happy to overload the usage of i_mutex. He suggested two
options,
1. adding another mutex in the inode structure 
2. adding global hash locks. (which he recommended)

Adding a mutex in the inode structure, is a overkill.
But having just one mutex to guard all uprobe_mmap is a contention on
different mmaps.  So we narrowed down to a hash mutex.

> 
> If so, this won't be terribly effective when we have multiple mutexes
> occupying a single cacheline - the array entries should be padded out.
> Of course, that's all a complete waste of space on uniprocessor
> machines, but nobody seems to think of that any more ;(
> 

Okay, I agree that having each mutex in a different cacheline helps.
If everyone agrees to this, I will have a addon patch that will move the
mutexes.

> There was no need to code the accessor functions as macros.  It is, as
> always, better to use a nice C function which takes an argument which
> is as strictly typed as possible.  ie, it *could* take a void*, but it
> would be better if it required an inode*.
> 

I will add this change as part of the add-on patch.

> >
> > ...
> >
> > +static int read_opcode(struct mm_struct *mm, unsigned long vaddr,
> > +						uprobe_opcode_t *opcode)
> > +{

[.....]

> > +	vaddr_new = kmap_atomic(page);
> > +	vaddr &= ~PAGE_MASK;
> > +	memcpy(opcode, vaddr_new + vaddr, uprobe_opcode_sz);
> > +	kunmap_atomic(vaddr_new);
> 
> This is modifying user memory?  flush_dcache_page() needed?  Or perhaps
> we will need different primitives to diddle the instruction memory on
> architectures which care.
> 

Here, we are just reading from the user memory, 
The part where we insert/remove the breakpoint (write_opcode) does the flush.

> > +int mmap_uprobe(struct vm_area_struct *vma)
> > +{
> > +	struct list_head tmp_list;
> > +	struct uprobe *uprobe, *u;
> > +	struct inode *inode;
> > +	int ret = 0;
> > +
> > +	if (!atomic_read(&uprobe_events) || !valid_vma(vma, true))
> > +		return ret;	/* Bail-out */
> > +
> > +	inode = vma->vm_file->f_mapping->host;
> > +	if (!inode)
> > +		return ret;
> > +
> > +	INIT_LIST_HEAD(&tmp_list);
> > +	mutex_lock(uprobes_mmap_hash(inode));
> > +	build_probe_list(inode, &tmp_list);
> > +	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> > +		loff_t vaddr;
> > +
> > +		list_del(&uprobe->pending_list);
> > +		if (!ret) {
> > +			vaddr = vma_address(vma, uprobe->offset);
> > +			if (vaddr < vma->vm_start || vaddr >= vma->vm_end) {
> > +				put_uprobe(uprobe);
> > +				continue;
> > +			}
> > +			ret = install_breakpoint(vma->vm_mm, uprobe, vma,
> > +								vaddr);
> > +			if (ret == -EEXIST)
> > +				ret = 0;
> 
> This now has the comment "Ignore double add:".  That is a poor
> comment, because it doesn't tell us *why* a double-add is ignored.
> 

We actually dont ignore the "Double-add". 

install_breakpoint() has comments on when we return EEXIST.

uprobe_mmap() has comments on why EEXIST should be considered successful
as part of commit  682968e0 (uprobes/core: Optimize probe hits with the
help of a counter) which is 

/*
 * Unable to insert a breakpoint, but
 * breakpoint lies underneath. Increment the
 * probe count
 */

i.e insert_breakpoint() needs to insert a breakpoint, but if a
breakpoint is already there, then it doesnt need to do anything.

I will go ahead and remove the "Ignore double-add" comment.
	
-- 
thanks and regards
Srikar

