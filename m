Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1BPVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:36:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52542 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1BPVgP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 16:36:15 -0500
Date: Wed, 16 Feb 2011 16:34:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Johannes Weiner <jweiner@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110216213439.GA26109@dumpdata.com>
References: <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216183304.GD5935@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4D5C4308.016A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 07:33:04PM +0100, Andrea Arcangeli wrote:
> On Tue, Feb 15, 2011 at 09:05:20PM +0100, Thomas Gleixner wrote:
> > Did you try with DEBUG_PAGEALLOC, which is calling into cpa quite a
> > lot?
> 
> I tried DEBUG_PAGEALLOC and it seems to work fine (in addition to
> lockdep), it doesn't spwan any debug check.
> 
> In addition to testing it (both prev patch and below one) I looked
I checked this under Xen running as PV and Dom0 and had no trouble.

You can stick:
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> into the code and the free_pages calling into
> pageattr->split_large_page apparently happens all at boot time.
> 
> Now one doubt remains if we need change_page_attr to run from irqs
> (not from DEBUG_PAGEALLOC though). Now is change_page_attr really sane
> to run from irqs? I thought __flush_tlb_all was delivering IPI (in
> that case it also wouldn't have been safe in the first place to run
> with irq disabled) but of course the "__" version is local, so after
> all maybe it's safe to run with interrupts too (I'd be amazed if
> somebody is calling it from irq, if not even DEBUG_PAGEALLOC does) but
> with the below patch it will remain safe from irq as far as the
> pgd_lock is concerned.
> 
> I think the previous patch was safe too though, avoiding VM
> manipulations from interrupts makes everything simpler. Normally only
> gart drivers should call it at init time to avoid prefetching of
> cachelines in the next 2m page with different (writeback) cache
> attributes of the pages physically aliased in the gart and mapped with
> different cache attribute, that init stuff happening from interrupt
> sounds weird. Anyway I post the below patch too as an alternative to
> still allow pageattr from irq.
> 
> With both patches the big dependency remains on __mmdrop not to run
> from irq. The alternative approach is to remove the page_table_lock
> from vmalloc_sync_all (which is only needed by Xen paravirt guest
> AFIK) and solve that problem in a different way, but I don't even know
> why they need it exactly, I tried not to impact that.
> 
> ===
> Subject: fix pgd_lock deadlock
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's forbidden to take the page_table_lock with the irq disabled or if there's
> contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> never run leading to a deadlock.
> 
> pageattr also seems to take advantage the pgd_lock to serialize
> split_large_page which isn't necessary so split it off to a separate spinlock
> (as a read_lock wouldn't enough to serialize split_large_page). Then we can use
> a read-write lock to allow pageattr to keep taking it from interrupts, but
> without having to always clear interrupts for readers. Writers are only safe
> from regular kernel context and they must clear irqs before taking it.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/include/asm/pgtable.h |    2 +-
>  arch/x86/mm/fault.c            |   23 ++++++++++++++++++-----
>  arch/x86/mm/init_64.c          |    6 +++---
>  arch/x86/mm/pageattr.c         |   17 ++++++++++-------
>  arch/x86/mm/pgtable.c          |   10 +++++-----
>  arch/x86/xen/mmu.c             |   10 ++++------
>  6 files changed, 41 insertions(+), 27 deletions(-)
> 
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -179,7 +179,21 @@ force_sig_info_fault(int si_signo, int s
>  	force_sig_info(si_signo, &info, tsk);
>  }
>  
> -DEFINE_SPINLOCK(pgd_lock);
> +/*
> + * The pgd_lock only protects the pgd_list. It can be taken from
> + * interrupt context but only in read mode (there's no need to clear
> + * interrupts before taking it in read mode). Write mode can only be
> + * taken from regular kernel context (not from irqs) and it must
> + * disable irqs before taking it. This way it can still be taken in
> + * read mode from interrupt context (in case
> + * pageattr->split_large_page is ever called from interrupt context),
> + * but without forcing the pgd_list readers to clear interrupts before
> + * taking it (like vmalloc_sync_all() that then wants to take the
> + * page_table_lock while holding the pgd_lock, which can only be taken
> + * while irqs are left enabled to avoid deadlocking against the IPI
> + * delivery of an SMP TLB flush run with the page_table_lock hold).
> + */
> +DEFINE_RWLOCK(pgd_lock);
>  LIST_HEAD(pgd_list);
>  
>  #ifdef CONFIG_X86_32
> @@ -229,15 +243,14 @@ void vmalloc_sync_all(void)
>  	for (address = VMALLOC_START & PMD_MASK;
>  	     address >= TASK_SIZE && address < FIXADDR_TOP;
>  	     address += PMD_SIZE) {
> -
> -		unsigned long flags;
>  		struct page *page;
>  
> -		spin_lock_irqsave(&pgd_lock, flags);
> +		read_lock(&pgd_lock);
>  		list_for_each_entry(page, &pgd_list, lru) {
>  			spinlock_t *pgt_lock;
>  			pmd_t *ret;
>  
> +			/* the pgt_lock only for Xen */
>  			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
>  
>  			spin_lock(pgt_lock);
> @@ -247,7 +260,7 @@ void vmalloc_sync_all(void)
>  			if (!ret)
>  				break;
>  		}
> -		spin_unlock_irqrestore(&pgd_lock, flags);
> +		read_unlock(&pgd_lock);
>  	}
>  }
>  
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -105,18 +105,18 @@ void sync_global_pgds(unsigned long star
>  
>  	for (address = start; address <= end; address += PGDIR_SIZE) {
>  		const pgd_t *pgd_ref = pgd_offset_k(address);
> -		unsigned long flags;
>  		struct page *page;
>  
>  		if (pgd_none(*pgd_ref))
>  			continue;
>  
> -		spin_lock_irqsave(&pgd_lock, flags);
> +		read_lock(&pgd_lock);
>  		list_for_each_entry(page, &pgd_list, lru) {
>  			pgd_t *pgd;
>  			spinlock_t *pgt_lock;
>  
>  			pgd = (pgd_t *)page_address(page) + pgd_index(address);
> +			/* the pgt_lock only for Xen */
>  			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
>  			spin_lock(pgt_lock);
>  
> @@ -128,7 +128,7 @@ void sync_global_pgds(unsigned long star
>  
>  			spin_unlock(pgt_lock);
>  		}
> -		spin_unlock_irqrestore(&pgd_lock, flags);
> +		read_unlock(&pgd_lock);
>  	}
>  }
>  
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -47,6 +47,7 @@ struct cpa_data {
>   * splitting a large page entry along with changing the attribute.
>   */
>  static DEFINE_SPINLOCK(cpa_lock);
> +static DEFINE_SPINLOCK(pgattr_lock);
>  
>  #define CPA_FLUSHTLB 1
>  #define CPA_ARRAY 2
> @@ -60,9 +61,9 @@ void update_page_count(int level, unsign
>  	unsigned long flags;
>  
>  	/* Protect against CPA */
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	spin_lock_irqsave(&pgattr_lock, flags);
>  	direct_pages_count[level] += pages;
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	spin_unlock_irqrestore(&pgattr_lock, flags);
>  }
>  
>  static void split_page_count(int level)
> @@ -376,6 +377,7 @@ static void __set_pmd_pte(pte_t *kpte, u
>  	if (!SHARED_KERNEL_PMD) {
>  		struct page *page;
>  
> +		read_lock(&pgd_lock);
>  		list_for_each_entry(page, &pgd_list, lru) {
>  			pgd_t *pgd;
>  			pud_t *pud;
> @@ -386,6 +388,7 @@ static void __set_pmd_pte(pte_t *kpte, u
>  			pmd = pmd_offset(pud, address);
>  			set_pte_atomic((pte_t *)pmd, pte);
>  		}
> +		read_unlock(&pgd_lock);
>  	}
>  #endif
>  }
> @@ -403,7 +406,7 @@ try_preserve_large_page(pte_t *kpte, uns
>  	if (cpa->force_split)
>  		return 1;
>  
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	spin_lock_irqsave(&pgattr_lock, flags);
>  	/*
>  	 * Check for races, another CPU might have split this page
>  	 * up already:
> @@ -498,7 +501,7 @@ try_preserve_large_page(pte_t *kpte, uns
>  	}
>  
>  out_unlock:
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	spin_unlock_irqrestore(&pgattr_lock, flags);
>  
>  	return do_split;
>  }
> @@ -519,7 +522,7 @@ static int split_large_page(pte_t *kpte,
>  	if (!base)
>  		return -ENOMEM;
>  
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	spin_lock_irqsave(&pgattr_lock, flags);
>  	/*
>  	 * Check for races, another CPU might have split this page
>  	 * up for us already:
> @@ -587,11 +590,11 @@ static int split_large_page(pte_t *kpte,
>  out_unlock:
>  	/*
>  	 * If we dropped out via the lookup_address check under
> -	 * pgd_lock then stick the page back into the pool:
> +	 * pgattr_lock then stick the page back into the pool:
>  	 */
>  	if (base)
>  		__free_page(base);
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	spin_unlock_irqrestore(&pgattr_lock, flags);
>  
>  	return 0;
>  }
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -121,14 +121,14 @@ static void pgd_ctor(struct mm_struct *m
>  
>  static void pgd_dtor(pgd_t *pgd)
>  {
> -	unsigned long flags; /* can be called from interrupt context */
> +	unsigned long flags;
>  
>  	if (SHARED_KERNEL_PMD)
>  		return;
>  
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	write_lock_irqsave(&pgd_lock, flags);
>  	pgd_list_del(pgd);
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	write_unlock_irqrestore(&pgd_lock, flags);
>  }
>  
>  /*
> @@ -280,12 +280,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>  	 * respect to anything walking the pgd_list, so that they
>  	 * never see a partially populated pgd.
>  	 */
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	write_lock_irqsave(&pgd_lock, flags);
>  
>  	pgd_ctor(mm, pgd);
>  	pgd_prepopulate_pmd(mm, pgd, pmds);
>  
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	write_unlock_irqrestore(&pgd_lock, flags);
>  
>  	return pgd;
>  
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -986,10 +986,9 @@ static void xen_pgd_pin(struct mm_struct
>   */
>  void xen_mm_pin_all(void)
>  {
> -	unsigned long flags;
>  	struct page *page;
>  
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	read_lock(&pgd_lock);
>  
>  	list_for_each_entry(page, &pgd_list, lru) {
>  		if (!PagePinned(page)) {
> @@ -998,7 +997,7 @@ void xen_mm_pin_all(void)
>  		}
>  	}
>  
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	read_unlock(&pgd_lock);
>  }
>  
>  /*
> @@ -1099,10 +1098,9 @@ static void xen_pgd_unpin(struct mm_stru
>   */
>  void xen_mm_unpin_all(void)
>  {
> -	unsigned long flags;
>  	struct page *page;
>  
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	read_lock(&pgd_lock);
>  
>  	list_for_each_entry(page, &pgd_list, lru) {
>  		if (PageSavePinned(page)) {
> @@ -1112,7 +1110,7 @@ void xen_mm_unpin_all(void)
>  		}
>  	}
>  
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	read_unlock(&pgd_lock);
>  }
>  
>  void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -25,7 +25,7 @@
>  extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>  #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
>  
> -extern spinlock_t pgd_lock;
> +extern rwlock_t pgd_lock;
>  extern struct list_head pgd_list;
>  
>  extern struct mm_struct *pgd_page_get_mm(struct page *page);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
