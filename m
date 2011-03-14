Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1CNRai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:30:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51954 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab1CNRa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:30:29 -0400
Date: Mon, 14 Mar 2011 22:54:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 3/20]  3: uprobes: Breakground page
 replacement.
Message-ID: <20110314172439.GO24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
 <1300117137.9910.110.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300117137.9910.110.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-03-14 11:38:57]:

> On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> > +/*
> > + * Called with tsk->mm->mmap_sem held (either for read or write and
> > + * with a reference to tsk->mm.
> > + */
> > +static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
> > +                       unsigned long vaddr, uprobe_opcode_t opcode)
> > +{
> > +       struct page *old_page, *new_page;
> > +       void *vaddr_old, *vaddr_new;
> > +       struct vm_area_struct *vma;
> > +       spinlock_t *ptl;
> > +       pte_t *orig_pte;
> > +       unsigned long addr;
> > +       int ret = -EINVAL;
> > +
> > +       /* Read the page with vaddr into memory */
> > +       ret = get_user_pages(tsk, tsk->mm, vaddr, 1, 1, 1, &old_page, &vma);
> > +       if (ret <= 0)
> > +               return -EINVAL;
> > +       ret = -EINVAL;
> > +
> > +       /*
> > +        * check if the page we are interested is read-only mapped
> > +        * Since we are interested in text pages, Our pages of interest
> > +        * should be mapped read-only.
> > +        */
> > +       if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) ==
> > +                                               (VM_READ|VM_EXEC))
> > +               goto put_out;
> > + 
> 
> I'm confused by the above comment and code. You state we are only
> interested text pages mapped read-only, but then if the page is mapped
> read/exec we exit out? It is fine if it is anything but READ/EXEC.

You are right, it should have been
	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) !=
					(VM_READ|VM_EXEC))
		goto put_out;


Your comment applied for read_opcode function too.
Will correct in the next version of the patchset.

However in the next patch, where we replace the above with
valid_vma and that does the right thing.

> 
> I'm also curious to why we can't modify text code that is also mapped as
> read/write.
> 

If text code is mapped read/write then on memory pressure the page gets
written to the disk. Hence breakpoints inserted may end up being in the
disk copy modifying the actual copy.

-- 
Thanks and Regards
Srikar
