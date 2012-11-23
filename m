Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2KWBSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:18:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab2KWBSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:18:44 -0500
Date: Thu, 22 Nov 2012 23:16:26 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: improve reexecute_instruction
Message-ID: <20121123011625.GC9269@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AAC77C.8040505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:57:48AM +0800, Xiao Guangrong wrote:
> The current reexecute_instruction can not well detect the failed instruction
> emulation. It allows guest to retry all the instructions except it accesses
> on error pfn.
> 
> For example, these cases can not be detected:
> - for tdp used
>   currently, it refused to retry all instructions. If nested npt is used, the
>   emulation may be caused by shadow page, it can be fixed by unshadow the
>   shadow page.
> 
> - for shadow mmu
>   some cases are nested-write-protect, for example, if the page we want to
>   write is used as PDE but it chains to itself. Under this case, we should
>   stop the emulation and report the case to userspace.
> 
> This test case based on kvm-unit-test can trigger a infinite loop on current
> code (ept = 0), after this patchset, it can report the error to Qemu.
> 
> Marcelo, I am afraid this test case can not be putted on kvm-unit-test,
> autotest is confused about this case since it can abort Qemu.

That is OK, kvm-unit-test only executes tests listed at
x86/unittests.cfg.

> 
> Subject: [PATCH] access test: test unhandleable instruction
> 
> Test the instruction which can not be handled by kvm
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  x86/access.c |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 23a5995..e88db6b 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -2,6 +2,7 @@
>  #include "libcflat.h"
>  #include "desc.h"
>  #include "processor.h"
> +#include "vm.h"
> 
>  #define smp_id() 0
> 
> @@ -739,6 +740,28 @@ err:
>  	return 0;
>  }
> 
> +static int check_retry_unhandleable_ins(ac_pool_t *pool)
> +{
> +	unsigned long mem = 30 * 1024 * 1024;
> +	unsigned long esp;
> +	ac_test_t at;
> +
> +	ac_test_init(&at, (void *)(0x123406003000));
> +	at.flags[AC_PDE_PRESENT] = at.flags[AC_PDE_WRITABLE] = 1;
> +	at.flags[AC_PTE_PRESENT] = at.flags[AC_PTE_WRITABLE] = 1;
> +	at.flags[AC_CPU_CR0_WP] = 1;
> +
> +	at.phys = mem;
> +	ac_setup_specific_pages(&at, pool, mem, 0);
> +
> +	asm volatile("mov %%rsp, %%rax  \n\t" : "=a"(esp));
> +	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(0x123406003000 + 0xf0));
> +	asm volatile ("int $0x3 \n\t");
> +	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(esp));
> +
> +	return 1;
> +}
> +
>  int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
>  {
>      int r;
> @@ -756,7 +779,8 @@ const ac_test_fn ac_test_cases[] =
>  {
>  	corrupt_hugepage_triger,
>  	check_pfec_on_prefetch_pte,
> -	check_smep_andnot_wp
> +	check_smep_andnot_wp,
> +	check_retry_unhandleable_ins
>  };
> 
>  int ac_test_run(void)
> @@ -770,6 +794,7 @@ int ac_test_run(void)
>      tests = successes = 0;
>      ac_env_int(&pool);
>      ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
> +
>      do {
>  	if (at.flags[AC_CPU_CR4_SMEP] && (ptl2[2] & 0x4))
>  		ptl2[2] -= 0x4;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
