Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1DSGkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:40:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60916 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1DSGki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:40:38 -0400
Date: Tue, 19 Apr 2011 11:56:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 12/26] 12: uprobes: slot allocation
 for uprobes
Message-ID: <20110419062654.GB10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143457.15455.64839.sendpatchset@localhost6.localdomain6>
 <1303145171.32491.886.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303145171.32491.886.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-04-18 18:46:11]:

> On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> > Every task is allocated a fixed slot. When a probe is hit, the original
> > instruction corresponding to the probe hit is copied to per-task fixed
> > slot. Currently we allocate one page of slots for each mm. Bitmaps are
> > used to know which slots are free. Each slot is made of 128 bytes so
> > that its cache aligned.
> > 
> > TODO: On massively threaded processes (or if a huge number of processes
> > share the same mm), there is a possiblilty of running out of slots.
> > One alternative could be to extend the slots as when slots are required.
> 
> As long as you're single stepping things and not using boosted probes
> you can fully serialize the slot usage. Claim a slot on trap and release
> the slot on finish. Claiming can wait on a free slot since you already
> have the whole SLEEPY thing.
> 

Yes, thats certainly one approach but that approach makes every
breakpoint hit contend for spinlock. (Infact we will have to change it
to mutex lock (as you rightly pointed out) so that we allow threads to
wait when slots are not free). Assuming a 4K page, we would be taxing
applications that have less than 32 threads (which is probably the
default case). If we continue with the current approach, then we
could only add additional page(s) for apps which has more than 32
threads and only when more than 32 __live__ threads have actually hit a
breakpoint.

> 
> > +static int xol_add_vma(struct uprobes_xol_area *area)
> > +{
> > +	struct vm_area_struct *vma;
> > +	struct mm_struct *mm;
> > +	struct file *file;
> > +	unsigned long addr;
> > +	int ret = -ENOMEM;
> > +
> > +	mm = get_task_mm(current);
> > +	if (!mm)
> > +		return -ESRCH;
> > +
> > +	down_write(&mm->mmap_sem);
> > +	if (mm->uprobes_xol_area) {
> > +		ret = -EALREADY;
> > +		goto fail;
> > +	}
> > +
> > +	/*
> > +	 * Find the end of the top mapping and skip a page.
> > +	 * If there is no space for PAGE_SIZE above
> > +	 * that, mmap will ignore our address hint.
> > +	 *
> > +	 * We allocate a "fake" unlinked shmem file because
> > +	 * anonymous memory might not be granted execute
> > +	 * permission when the selinux security hooks have
> > +	 * their way.
> > +	 */
> 
> That just annoys me, so we're working around some stupid sekurity crap,
> executable anonymous maps are perfectly fine, also what do JITs do?

Yes, we are working around selinux security hooks, but do we have a
choice. 

James can you please comment on this.

> 
> > +	vma = rb_entry(rb_last(&mm->mm_rb), struct vm_area_struct, vm_rb);
> > +	addr = vma->vm_end + PAGE_SIZE;
> > +	file = shmem_file_setup("uprobes/xol", PAGE_SIZE, VM_NORESERVE);
> > +	if (!file) {
> > +		printk(KERN_ERR "uprobes_xol failed to setup shmem_file "
> > +			"while allocating vma for pid/tgid %d/%d for "
> > +			"single-stepping out of line.\n",
> > +			current->pid, current->tgid);
> > +		goto fail;
> > +	}
> > +	addr = do_mmap_pgoff(file, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
> > +	fput(file);
> > +
