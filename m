Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1KKKt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:49:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54378 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab1KKKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:49:25 -0500
Date: Fri, 11 Nov 2011 10:49:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 07/16] ARM: LPAE: Introduce the 3-level page table
 format definitions
Message-ID: <20111111104907.GA23243@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-8-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1111101638550.3307@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111101638550.3307@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 09:53:53PM +0000, Nicolas Pitre wrote:
> On Mon, 7 Nov 2011, Catalin Marinas wrote:
> 
> > This patch introduces the pgtable-3level*.h files with definitions
> > specific to the LPAE page table format (3 levels of page tables).
> [...]
> > diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
> > new file mode 100644
> > index 0000000..7c238a3
> > --- /dev/null
> > +++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
> [...]
> > +#ifdef __ASSEMBLY__
> > +/* avoid 'shift count out of range' warning */
> > +#define PMD_SECT_XN		(0)
> > +#else
> > +#define PMD_SECT_XN		((pmdval_t)1 << 54)
> > +#endif
> 
> Please don't do that.  Having a symbol that changes value depending on 
> the type of code is evil.  If PMD_SECT_XN is actually used in assembly 
> code then you have to deal with it, not blindly redefine it as zero.
> In my compilation test I didn't see any such warning anyway.

When compiling for LPAE, I get:

arch/arm/mm/proc-v7.S: Assembler messages:
arch/arm/mm/proc-v7.S|349| Warning: shift count out of range (54 is not between 0 and 31)
arch/arm/mm/proc-v7.S|359| Warning: shift count out of range (54 is not between 0 and 31)

because we have a .long definition that cannot accommodate bigger
values. I also wouldn't change the __cpu_io_mmu_flags type to long long.

But I can deal with this directly in the head.S file. The fix-up would
look like this:

diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
index 7c238a3..d795282 100644
--- a/arch/arm/include/asm/pgtable-3level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -41,12 +41,7 @@
 #define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)
 #define PMD_SECT_AF		(_AT(pmdval_t, 1) << 10)
 #define PMD_SECT_nG		(_AT(pmdval_t, 1) << 11)
-#ifdef __ASSEMBLY__
-/* avoid 'shift count out of range' warning */
-#define PMD_SECT_XN		(0)
-#else
-#define PMD_SECT_XN		((pmdval_t)1 << 54)
-#endif
+#define PMD_SECT_XN		(_AT(pmdval_t, 1) << 54)
 #define PMD_SECT_AP_WRITE	(_AT(pmdval_t, 0))
 #define PMD_SECT_AP_READ	(_AT(pmdval_t, 0))
 #define PMD_SECT_TEX(x)		(_AT(pmdval_t, 0))
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index a400a4d..a1df2ac 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -278,6 +278,8 @@ __create_page_tables:
 	orr	r3, r7, r3, lsl #SECTION_SHIFT
 #ifdef CONFIG_ARM_LPAE
 	mov	r7, #1 << (54 - 32)		@ XN
+#else
+	orr	r3, r3, #PMD_SECT_XN
 #endif
 1:	str	r3, [r0], #4
 #ifdef CONFIG_ARM_LPAE
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index fc224bc..0b68a93 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -303,7 +303,7 @@ __v7_setup_stack:
 			PMD_SECT_AF | PMD_FLAGS_SMP | \mm_mmuflags)
 	ALT_UP(.long	PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AP_READ | \
 			PMD_SECT_AF | PMD_FLAGS_UP | \mm_mmuflags)
-	.long	PMD_TYPE_SECT | PMD_SECT_XN | PMD_SECT_AP_WRITE | \
+	.long	PMD_TYPE_SECT | PMD_SECT_AP_WRITE | \
 		PMD_SECT_AP_READ | PMD_SECT_AF | \io_mmuflags
 	W(b)	\initfunc
 	.long	cpu_arch_name

> > diff --git a/arch/arm/include/asm/pgtable-3level-types.h b/arch/arm/include/asm/pgtable-3level-types.h
> > new file mode 100644
> > index 0000000..921aa30
> > --- /dev/null
> > +++ b/arch/arm/include/asm/pgtable-3level-types.h
> > @@ -0,0 +1,70 @@
> [...]
> > +typedef u64 pteval_t;
> > +typedef u64 pmdval_t;
> > +typedef u64 pgdval_t;
> > +
> > +#undef STRICT_MM_TYPECHECKS
> > +
> > +#ifdef STRICT_MM_TYPECHECKS
> > +
> > +/*
> > + * These are used to make use of C type-checking..
> > + */
> > +typedef struct { pteval_t pte; } pte_t;
> > +typedef struct { pmdval_t pmd; } pmd_t;
> > +typedef struct { pgdval_t pgd; } pgd_t;
> > +typedef struct { pteval_t pgprot; } pgprot_t;
> > +
> > +#define pte_val(x)      ((x).pte)
> > +#define pmd_val(x)      ((x).pmd)
> > +#define pgd_val(x)	((x).pgd)
> > +#define pgprot_val(x)   ((x).pgprot)
> > +
> > +#define __pte(x)        ((pte_t) { (x) } )
> > +#define __pmd(x)        ((pmd_t) { (x) } )
> > +#define __pgd(x)	((pgd_t) { (x) } )
> > +#define __pgprot(x)     ((pgprot_t) { (x) } )
> > +
> > +#else	/* !STRICT_MM_TYPECHECKS */
> > +
> > +typedef pteval_t pte_t;
> > +typedef pmdval_t pmd_t;
> > +typedef pgdval_t pgd_t;
> > +typedef pteval_t pgprot_t;
> > +
> > +#define pte_val(x)	(x)
> > +#define pmd_val(x)	(x)
> > +#define pgd_val(x)	(x)
> > +#define pgprot_val(x)	(x)
> > +
> > +#define __pte(x)	(x)
> > +#define __pmd(x)	(x)
> > +#define __pgd(x)	(x)
> > +#define __pgprot(x)	(x)
> > +
> > +#endif	/* STRICT_MM_TYPECHECKS */
> 
> Isn't the vast majority of this file actually common with the content of 
> pgtable-2level-types.h?  Except for the basic types and pgd handling, 
> this looks pretty similar.

The pgd_t and pgd_val definitions are different. But pgd_t depends on
the pmd_t definition so we would end up with #ifdef's in a common file
(or two includes for the type headers). IMHO, it's cleaner this way.

-- 
Catalin
