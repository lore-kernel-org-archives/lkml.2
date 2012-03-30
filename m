Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966430Ab2C3Vpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:45:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35478 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966096Ab2C3VpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:45:25 -0400
Date: Fri, 30 Mar 2012 17:40:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 02/39] xen: document Xen is using an unused bit for the
 pagetables
Message-ID: <20120330214005.GC23599@phenom.dumpdata.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-3-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332783986-24195-3-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F76294C.0097,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 07:45:49PM +0200, Andrea Arcangeli wrote:
> Xen has taken over the last reserved bit available for the pagetables
> which is set through ioremap, this documents it and makes the code
> more readable.

About a year ago we redid the P2M code to ditch the major use case for this.
But there were two left over cases that I hadn't found a good solution
for that would allow us to completly eliminate the use of this bit:

1). When setting a PTE of a PFN which overlaps an E820 hole or any of the
    non-E820-RAM entries, we lookup in the P2M and find out that
    the PFN is a 1:1 and return a pte.pte | pfn << PAGE_SIZE.

    But we also stick the _PAGE_IOMAP on it so that when the call to
    xen_pte_val is done we don't end up doing the lookup in the P2M tree
    once more and just set the pte as is.

    So this is the dance between xen_pte_val and xen_make_pte.

2). When the userspace tries to mmap a guest memory for save/migrate
    or to setup something in the guest, it would use the xen_remap_domain_mfn_range
    to setup PTE's with the guest's PFN (gpfn). The _PAGE_IOMAP
    is used again to tell xen_pte_val to not bother looking it up in the
    P2M tree and use it as is.

So.. any thoughts on how to eliminate the usage of this?
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/include/asm/pgtable_types.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 013286a..b74cac9 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -17,7 +17,7 @@
>  #define _PAGE_BIT_PAT		7	/* on 4KB pages */
>  #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
>  #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
> -#define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
> +#define _PAGE_BIT_UNUSED2	10
>  #define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
>  #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
>  #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
> @@ -41,7 +41,7 @@
>  #define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
>  #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
>  #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
> -#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
> +#define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
>  #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
>  #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
>  #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
> @@ -49,6 +49,13 @@
>  #define _PAGE_SPLITTING	(_AT(pteval_t, 1) << _PAGE_BIT_SPLITTING)
>  #define __HAVE_ARCH_PTE_SPECIAL
>  
> +/* flag used to indicate IO mapping */
> +#ifdef CONFIG_XEN
> +#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
> +#else
> +#define _PAGE_IOMAP	(_AT(pteval_t, 0))
> +#endif
> +
>  #ifdef CONFIG_KMEMCHECK
>  #define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
>  #else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
