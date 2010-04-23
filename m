Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0DWO6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:58:22 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52285 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0DWO6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:58:19 -0400
Date: Fri, 23 Apr 2010 20:28:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100423145813.GA5503@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
 <20100413183537.GA17538@redhat.com>
 <20100415093506.GA2064@linux.vnet.ibm.com>
 <20100419193139.GA24080@redhat.com>
 <20100420124358.GA20675@linux.vnet.ibm.com>
 <20100420153023.GA9351@redhat.com>
 <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com>
 <20100422133154.GA10776@linux.vnet.ibm.com>
 <20100422154059.GA5916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100422154059.GA5916@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2010-04-22 17:40:59]:

> On 04/22, Srikar Dronamraju wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> [2010-04-21 18:05:15]:
> >
> > > 3. mprotect(). write_opcode() checks !VM_WRITE. This is correct,
> > >    otherwise we can race with the user-space writing to the same
> > >    page.
> > >
> > >    But suppose that the application does mprotect(PROT_WRITE) after
> > >    register_uprobe() installs the bp, now unregister_uprobe/etc can't
> > >    restore the original insn?
> > >
> >
> > I still need to verify this. I shall get back to you on this.
> > However are there applications that mprotect(PROT_WRITE) text pages?
> 
> Well, I think the kernel should assume that the user-space can do
> anything.
> 
> Hmm. And if this vma is VM_SHARED, then this bp could be actually
> written to vm_file after mprotect().

When I look through the load_.*_binary and load_.*_library functions,
they seem to map the text regions MAP_PRIVATE|MAP_DENY_WRITE. (Few
exceptions like load_som_binary that seem to map text regions with
MAP_PRIVATE only).

Also if vma are marked VM_SHARED and bp are inserted through ptrace,
i.e(access_process_vm/get_user_pages), then we would still be writing to
vm_file after mprotect?

Again, I am not sure if executable pages should be marked VM_SHARED.

> 
> But I think this doesn't really matter. When I actually look at
> patches 3 and 4, I am starting to think this all is very wrong.
> 
> > I am copying Mel Gorman and Andrea Arcangeli so that they can provide
> > their inputs on VM and KSM related issues.
> 
> Yes. We need vm experts here, I am not. Still, I'd like to share my
> concerns. I also added Rik and Hugh.
> 
> 
> So, 3/11 does
> 
> 	@@ -2617,7 +2617,10 @@ int replace_page(struct vm_area_struct *vma, struct page *page,
> 		}
> 	 
> 		get_page(kpage);
> 	-	page_add_anon_rmap(kpage, vma, addr);
> 	+	if (PageAnon(kpage))
> 	+		page_add_anon_rmap(kpage, vma, addr);
> 	+	else
> 	+		page_add_file_rmap(kpage);
> 	 
> 		flush_cache_page(vma, addr, pte_pfn(*ptep));
> 		ptep_clear_flush(vma, addr, ptep);
> 
> I see no point in this patch, please see below.
> 
> The next 4/11 patch introduces write_opcode() which roughly does:
> 
> 	int write_opcode(unsigned long vaddr, user_bkpt_opcode_t opcode)
> 	{
> 		get_user_pages(write => false, &old_page);
> 
> 		new_page = alloc_page_vma(...);
> 
> 		... insert the bp into the new_page ...
> 
> 		new_page->mapping = old_page->mapping;
> 		new_page->index = old_page->index;
> 
> 		replace_page(old_page, new_page);
> 	}
> 
> This doesn't look right at all to me.
> 
> 	IF PageAnon(old_page):
		   ^^^ newpage

> 
> 		in this case replace_page() calls page_add_anon_rmap() which
> 		needs the locked page.
> 
> 	ELSE:
> 
> 		I don't think the new page should evere preserve the mapping,
> 		this looks just wrong. It should be always anonymous.

I did verify that page_add_file_rmap gets called from replace_page when 
we insert or remove a probe.
This should be because uprobes doesnt do a anon_vma_prepare() before the
alloc_page_vma(). 
I would leave it for vm experts to decide what the right thing to do.

> 
> 
> And in fact, I do not understand why write_opcode() needs replace_page().
> It could just use get_user_pages(FOLL_WRITE | FOLL_FORCE), no? It should
> create the anonymous page correctly.

We were earlier doing access_process_vm that would inturn call
get_user_pages to COW the page. However that needed that the threads of
the target process be stopped.

In the access_process_vm method,
1. we get a copy of page, 
2. flush the tlbs.
3. modify the page. 

The concern was if the threads were executing in the vicinity.
Hence we were stopping all threads while inserting/deleting breakpoints.


Background page replacement was suggested by Linus and Peter. 
In this method.
1. we get a copy of the page.
2. modify the page 
3. flush the tlbs.

This method is suppose to be atomic enuf that we dont need to stop the
threads.

> 
> Either way, I think register_uprobe() should disallow the probes in
> VM_SHARED/VM_MAYWRITE vmas.

Yes, we certainly could add that check. 

--
Thanks and Regards
Srikar
