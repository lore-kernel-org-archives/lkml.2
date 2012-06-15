Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2FOML6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:11:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34486 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FOML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:11:56 -0400
Date: Fri, 15 Jun 2012 14:11:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: write_opcode()->__replace_page() can race
 with try_to_unmap()
Message-ID: <20120615121151.GB28541@gmail.com>
References: <20120607165942.GA31966@redhat.com>
 <20120607170041.GC31974@redhat.com>
 <20120608165551.GA30683@redhat.com>
 <20120615061217.GC12051@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615061217.GC12051@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> > ---
> > Subject: [PATCH] uprobes: write_opcode()->__replace_page() can race with try_to_unmap()
> > 
> > write_opcode() gets old_page via get_user_pages() and then calls
> > __replace_page() which assumes that this old_page is still mapped
> > after pte_offset_map_lock().
> > 
> > This is not true if this old_page was already try_to_unmap()'ed,
> > and in this case everything __replace_page() does with old_page
> > is wrong. Just for example, put_page() is not balanced.
> > 
> > I think it is possible to teach __replace_page() to handle this
> > unlikely case correctly, but this patch simply changes it to use
> > page_check_address() and return -EAGAIN if it fails. The caller
> > should notice this error code and retry.
> > 
> > Note: write_opcode() asks for the cleanups, I'll try to do this
> > in a separate patch.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  kernel/events/uprobes.c |   41 +++++++++++++----------------------------
> >  1 files changed, 13 insertions(+), 28 deletions(-)
> > 
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 9c53bc2..54c8780 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -135,33 +135,17 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
> >  static int __replace_page(struct vm_area_struct *vma, struct page *page, struct page *kpage)
> >  {
> >  	struct mm_struct *mm = vma->vm_mm;
> > -	pgd_t *pgd;
> > -	pud_t *pud;
> > -	pmd_t *pmd;
> > -	pte_t *ptep;
> > -	spinlock_t *ptl;
> >  	unsigned long addr;
> > -	int err = -EFAULT;
> > +	spinlock_t *ptl;
> > +	pte_t *ptep;
> > 
> >  	addr = page_address_in_vma(page, vma);
> >  	if (addr == -EFAULT)
> > -		goto out;
> > -
> > -	pgd = pgd_offset(mm, addr);
> > -	if (!pgd_present(*pgd))
> > -		goto out;
> > -
> > -	pud = pud_offset(pgd, addr);
> > -	if (!pud_present(*pud))
> > -		goto out;
> > +		return -EFAULT;
> > 
> > -	pmd = pmd_offset(pud, addr);
> > -	if (!pmd_present(*pmd))
> > -		goto out;
> > -
> > -	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
> > +	ptep = page_check_address(page, mm, addr, &ptl, 0);
> >  	if (!ptep)
> > -		goto out;
> > +		return -EAGAIN;
> > 
> >  	get_page(kpage);
> >  	page_add_new_anon_rmap(kpage, vma, addr);
> > @@ -180,10 +164,8 @@ static int __replace_page(struct vm_area_struct *vma, struct page *page, struct
> >  		try_to_free_swap(page);
> >  	put_page(page);
> >  	pte_unmap_unlock(ptep, ptl);
> > -	err = 0;
> > 
> > -out:
> > -	return err;
> > +	return 0;
> >  }
> > 
> >  /**
> > @@ -228,9 +210,10 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
> >  	void *vaddr_old, *vaddr_new;
> >  	struct vm_area_struct *vma;
> >  	struct uprobe *uprobe;
> > +	unsigned long pgoff;
> >  	loff_t addr;
> >  	int ret;
> > -
> > +retry:
> 
> Just a check on coding style: Shouldnt we have a preceeding blank
> line before the goto label.

Yeah, that's most likely helpful to readability.

Thanks,

	Ingo
