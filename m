Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0DWS4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:56:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0DWS4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:56:16 -0400
Date: Fri, 23 Apr 2010 20:53:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20100423185341.GA16129@redhat.com>
References: <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com> <20100420153023.GA9351@redhat.com> <20100421065948.GA5440@linux.vnet.ibm.com> <20100421160515.GA11321@redhat.com> <20100422133154.GA10776@linux.vnet.ibm.com> <20100422154059.GA5916@redhat.com> <20100423145813.GA5503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423145813.GA5503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2010-04-22 17:40:59]:
>
> > On 04/22, Srikar Dronamraju wrote:
> > >
> > > I still need to verify this. I shall get back to you on this.
> > > However are there applications that mprotect(PROT_WRITE) text pages?
> >
> > Well, I think the kernel should assume that the user-space can do
> > anything.
> >
> > Hmm. And if this vma is VM_SHARED, then this bp could be actually
> > written to vm_file after mprotect().
>
> When I look through the load_.*_binary and load_.*_library functions,
> they seem to map the text regions MAP_PRIVATE|MAP_DENY_WRITE.

Sure, I didn't mean exec can use MAP_SHARED or mprotect().

> Also if vma are marked VM_SHARED and bp are inserted through ptrace,
> i.e(access_process_vm/get_user_pages), then we would still be writing to
> vm_file after mprotect?

Yes, that is why I mentioned register_uprobe() should check SHARED/MAYWRITE.

> Again, I am not sure if executable pages should be marked VM_SHARED.

Again, I didn't mean they should. But they can.

Not only VM_SHARED, the application can create the anonymous PROT_EXEC region,
in this case write_opcode() looks wrong, please see below.

> > 	@@ -2617,7 +2617,10 @@ int replace_page(struct vm_area_struct *vma, struct page *page,
> > 		}
> >
> > 		get_page(kpage);
> > 	-	page_add_anon_rmap(kpage, vma, addr);
> > 	+	if (PageAnon(kpage))
> > 	+		page_add_anon_rmap(kpage, vma, addr);
> > 	+	else
> > 	+		page_add_file_rmap(kpage);
> >
> > 		flush_cache_page(vma, addr, pte_pfn(*ptep));
> > 		ptep_clear_flush(vma, addr, ptep);
> >
> > I see no point in this patch, please see below.
> >
> > The next 4/11 patch introduces write_opcode() which roughly does:
> >
> > 	int write_opcode(unsigned long vaddr, user_bkpt_opcode_t opcode)
> > 	{
> > 		get_user_pages(write => false, &old_page);
> >
> > 		new_page = alloc_page_vma(...);
> >
> > 		... insert the bp into the new_page ...
> >
> > 		new_page->mapping = old_page->mapping;
> > 		new_page->index = old_page->index;
> >
> > 		replace_page(old_page, new_page);
> > 	}
> >
> > This doesn't look right at all to me.
> >
> > 	IF PageAnon(old_page):
> 		   ^^^ newpage

Yes,

> > 		in this case replace_page() calls page_add_anon_rmap() which
> > 		needs the locked page.
> >
> > 	ELSE:
> >
> > 		I don't think the new page should evere preserve the mapping,
> > 		this looks just wrong. It should be always anonymous.
>
> I did verify that page_add_file_rmap gets called from replace_page when
> we insert or remove a probe.

Of course! but see above, PageAnon() case is possible too. I think the
code should handle this case correctly anyway, but it seems it doesn't.
Not only page_add_anon_rmap() needs the locked page, I am not not sure
page_add_anon_rmap() is fine for write_opcode() which allocates the new
page. LRU? SetPageSwapBacked?

And you seem to miss my point. I think page_add_file_rmap() is always wrong.
I mean, no matter what is the page_mapping(old_page), the new page should be
mapped anonymously.

> I would leave it for vm experts to decide what the right thing to do.

Sure.

> > And in fact, I do not understand why write_opcode() needs replace_page().
> > It could just use get_user_pages(FOLL_WRITE | FOLL_FORCE), no? It should
> > create the anonymous page correctly.
>
> We were earlier doing access_process_vm that would inturn call
> get_user_pages to COW the page. However that needed that the threads of
> the target process be stopped.

OK, I missed this, thanks.

> Background page replacement was suggested by Linus and Peter.
> In this method.
> 1. we get a copy of the page.
> 2. modify the page
> 3. flush the tlbs.

OK.

I must admit, I don't understand the usage of the lockless get_pte() in
write_opcode(). replace_page() checks orig_pte, yes. But how this check
can help write_opcode and why it is needed? I do not think it can prevent
any race, pte can be changed even before write_opcode() calls get_pte().
I guess this is only done because replace_page() requires this argument?

Oleg.

