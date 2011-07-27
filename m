Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1G0KWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:22:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:39044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1G0KWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:22:19 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Mike Frysinger <vapier.adi@gmail.com>,
        Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1311761831.24752.413.camel@twins>
References: <1311757190.24752.406.camel@twins>
	 <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop> <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop> <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop> <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop> <4E24FA51.70602@gmail.com>
	 <1311049762.25044.392.camel@pasglop>
	 <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
	 <1311753513.25044.663.camel@pasglop>   <20368.1311761379@redhat.com>
	 <1311761831.24752.413.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 20:20:43 +1000
Message-ID: <1311762043.25044.679.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 12:17 +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-27 at 11:09 +0100, David Howells wrote:
> > Can you inline this for the NOMMU case please?
> 
> ---
> Subject: mm: Fix fixup_user_fault() for MMU=n 
> 
> In commit 2efaca927 ("mm/futex: fix futex writes on archs with SW
> tracking of dirty & young") we forgot about MMU=n. This patch fixes
> that.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Hoping the BUG() isn't trippable by userspace but then it's no mmu, it's
not like we care what userspace can do right :-)

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks !

Cheers,
Ben.

> ---
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -962,6 +962,8 @@ int invalidate_inode_page(struct page *p
>  #ifdef CONFIG_MMU
>  extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  			unsigned long address, unsigned int flags);
> +extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
> +			    unsigned long address, unsigned int fault_flags);
>  #else
>  static inline int handle_mm_fault(struct mm_struct *mm,
>  			struct vm_area_struct *vma, unsigned long address,
> @@ -971,6 +973,14 @@ static inline int handle_mm_fault(struct
>  	BUG();
>  	return VM_FAULT_SIGBUS;
>  }
> +static inline int fixup_user_fault(struct task_struct *tsk, 
> +		struct mm_struct *mm, unsigned long address,
> +		unsigned int fault_flags)
> +{
> +	/* should never happen if there's no MMU */
> +	BUG();
> +	return -EFAULT;
> +}
>  #endif
>  
>  extern int make_pages_present(unsigned long addr, unsigned long end);
> @@ -988,8 +998,6 @@ int get_user_pages(struct task_struct *t
>  int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			struct page **pages);
>  struct page *get_dump_page(unsigned long addr);
> -extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
> -			    unsigned long address, unsigned int fault_flags);
>  
>  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
>  extern void do_invalidatepage(struct page *page, unsigned long offset);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


