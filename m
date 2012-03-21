Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2CUO7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2CUO7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:59:37 -0400
Date: Wed, 21 Mar 2012 15:59:34 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: build failure in linux-next
Message-ID: <20120321145934.GA24602@redhat.com>
References: <1332340575.12353.55.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332340575.12353.55.camel@deneb.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 21, 2012 at 10:36:14AM -0400, Mark Salter wrote:
> I'm seeing a build failure in linux-next:
> 
>   CC      init/main.o
> In file included from /es/linux/linux-next/arch/c6x/include/asm/pgtable.h:76:0,
>                  from /es/linux/linux-next/include/linux/mm.h:44,
>                  from /es/linux/linux-next/include/linux/ring_buffer.h:5,
>                  from /es/linux/linux-next/include/linux/ftrace_event.h:4,
>                  from /es/linux/linux-next/include/trace/syscall.h:6,
>                  from /es/linux/linux-next/include/linux/syscalls.h:78,
>                  from /es/linux/linux-next/init/main.c:16:
> /es/linux/linux-next/include/asm-generic/pgtable.h: In function 'pmd_none_or_trans_huge_or_clear_bad':
> /es/linux/linux-next/include/asm-generic/pgtable.h:476:4: error: implicit declaration of function 'pmd_clear_bad' [-Werror=implicit-function-declaration]
> 
> 
> This patch added some functions to asm-generic/pgtable.h which should
> have been placed in the CONFIG_MMU conditional block:
> 
>   Author: Andrea Arcangeli <aarcange@redhat.com>
>   Date:   Wed Mar 21 10:48:00 2012 +1100
> 
>       mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem read mode
> 
> 
> The following patch fixes the build problem for me:

Thanks for noticing this problem.



> 
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 202c010..8ba3ba5 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -342,6 +342,64 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
>  	__ptep_modify_prot_commit(mm, addr, ptep, pte);
>  }
>  #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
> +
> +/*
> + * This function is meant to be used by sites walking pagetables with
> + * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
> + * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
> + * into a null pmd and the transhuge page fault can convert a null pmd
> + * into an hugepmd or into a regular pmd (if the hugepage allocation
> + * fails). While holding the mmap_sem in read mode the pmd becomes
> + * stable and stops changing under us only if it's not null and not a
> + * transhuge pmd. When those races occurs and this function makes a
> + * difference vs the standard pmd_none_or_clear_bad, the result is
> + * undefined so behaving like if the pmd was none is safe (because it
> + * can return none anyway). The compiler level barrier() is critically
> + * important to compute the two checks atomically on the same pmdval.
> + */
> +static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
> +{
> +	/* depend on compiler for an atomic pmd read */
> +	pmd_t pmdval = *pmd;
> +	/*
> +	 * The barrier will stabilize the pmdval in a register or on
> +	 * the stack so that it will stop changing under the code.
> +	 */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	barrier();
> +#endif
> +	if (pmd_none(pmdval))
> +		return 1;
> +	if (unlikely(pmd_bad(pmdval))) {
> +		if (!pmd_trans_huge(pmdval))
> +			pmd_clear_bad(pmd);

Problem is, this fixes MMU=n but it'll break x86 with MMU=y and THP=n.

These functions shall be placed after pmd_trans_huge you see at the
end of asm-generic/pgtable.h .

The simplest fix is that you add #ifdef CONFIG_MMU around it instead
of moving (I guess you can keep pmd_trans_huge and the rest at the end
of the file inside CONFIG_MMU too as it shall never be called as it
all takes pmds/ptes as parameter).

Thanks,
Andrea
