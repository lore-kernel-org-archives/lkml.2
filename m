Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1EaHif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:38:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1EaHie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:38:34 -0400
Date: Tue, 31 May 2011 09:38:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
Message-ID: <20110531073824.GA17999@elte.hu>
References: <20110530124600.GB494@eferding.osrc.amd.com>
 <1306786278-12219-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306786278-12219-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  				    gva_t addr, u32 access)
>  {
>  	pt_element_t pte;
> -	pt_element_t __user *ptep_user;
> +	pt_element_t __user *uninitialized_var(ptep_user);

Note that doing this is actually actively dangerous for two reasons.

Firstly, it also shuts down the warning when it turns into a *real* 
warning. For example this function will not produce a warning:

 int test(int a)
 {
        int uninitialized_var(b);

        return b;
 }

Secondly, if the *compiler* cannot understand the flow then the code 
is obviously rather complex for humans to review. So if there's an 
initialization bug in the future, the risk of a human not seeing it 
and the risk of uninitialized_var() hiding it is larger.

So the recommended thing is to simplify the flow there to make it 
easier for the compiler to see through it.

A quick look suggests that walk_addr_generic() is *horrible*: it has 
amassed a large number of classic code structure mistakes, and while 
it's clearly a performance critical function, needless code ugliness 
often goes at the *expense* of good performance.

I found a handful of problems during a quick review of it:

 - There's ugly repeated patterns of:

               if (unlikely(condition)) {
                        present = false;
                        break;
               }

   which is then handled outside the main loop with:

        if (unlikely(!present || ...))
                goto error;

   It would be a lot cleaner, not to mention faster as well to do 
   this via:

		if (condition)
			goto error_not_present;

   That way the 'present' bool does not clog up the code flow (and 
   register allocations).

 - rsvd_fault shows similar mismanagement:

                if (unlikely(condition)) {
                        rsvd_fault = true;
                        break;
                }

                if (!eperm && !rsvd_fault && ...) {
			...
		}
	}

	if (unlikely(!present || eperm || rsvd_fault))
		goto error;

   This obfuscation complicated (and potentially slowed down) the 
   middle condition: it's rather clear that the code flow cannot get 
   there with rsvd == true ...

   It should be done via a more natural:

		if (condition)
			goto error_rsvd_fault;

 - eperm setting:

                if (unlikely(write_fault && !is_writable_pte(pte)
                             && (user_fault || is_write_protection(vcpu))))
                        eperm = true;

                if (unlikely(user_fault && !(pte & PT_USER_MASK)))
                        eperm = true;

#if PTTYPE == 64
                if (unlikely(fetch_fault && (pte & PT64_NX_MASK)))
                        eperm = true;
#endif

   is idempotent so is an obvious candidate to be factored out into a 
   helper inline. If you already know how eperm is calculated why 
   should a code reader be forced to go through those lines again and 
   again, every time this function is reviewed?

 - In fact, once the unnecessary rsvd_fault complication has been 
   factored out, the heart of the function, marking the pte 
   accessed/dirty connects very nicely to the eperm calculating 
   inline:

	eperm = gpte_eperm(vcpu, pte, access);

   [ NOTE: we should probably pass in 'access' explicitly because for 
     code generation it's better to keep such variables in a single 
     register and check it via the obvious bitmask and TESTL, not via 
     the separate write_fault, user_fault, fetch_fault variables. ]

 - The 'access' attribute seems somewhat mismanaged as well. There 
   are unnecessary seeming complexities like:

        write_fault = access & PFERR_WRITE_MASK;
        user_fault = access & PFERR_USER_MASK;
        fetch_fault = access & PFERR_FETCH_MASK;


                        ac = write_fault | fetch_fault | user_fault;

                        real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
                                                      ac);

   So ... we first split the 'access' attribute into 3 separate 
   bools, then we *combine* them again and pass the result to 
   translate_gpa()? Will the compiler figure out that this is equivalent
   to access & ~(PFERR_WRITE_MASK|PFERR_USER_MASK|PFERR_FETCH_MASK)?

   Even if it does, wouldnt it be safe to pass 'access' to ->translate_gpa()
   as-is? If it's not safe to pass it as-is then a comment would be handy
   about this non-obvious looking fact.

 - Variables are not marked 'const' where they should be - the above
   *_fault attributes for example but there are other examples as 
   well. Since GCC very obviously has trouble seeing through this 
   monster of a function, not helping it out with 'const' can hurt 
   code generation quality. Reviewers are also helped: i had to spend 
   a minute figuring out that none of these are ever modified within 
   the function.

 - What the heck is up with ASSERT() usage in the Linux kernel?
   arch/x86/kvm/ uses about 50% of BUG_ON()s and 50% of inverted
   logic ASSERT()s. If the goal was to confuse the reviewer then it's 
   a full success! :-)

 - Litte details like:

                if (unlikely(kvm_is_error_hva(host_addr))) {

   The name already suggests that kvm_is_error_hva() is a rare 
   exception mechanism. The unlikely() could be propagated *into* 
   kvm_is_error_hva() and thus call sites would be less cluttered.

 - Data type choicese are sometimes unnatural and lead to unnecessary casts.
   For example:

                unsigned long host_addr;

                host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
                if (unlikely(kvm_is_error_hva(host_addr))) {

                ptep_user = (pt_element_t __user *)((void *)host_addr + offset);

   It's a host virtual address, so eventual usage ends up being a 
   void * variant. Other usages of kvm_is_error_hva() show
   similar patterns:

                unsigned long addr;
                addr = gfn_to_hva(vcpu->kvm, data >>
                                  HV_X64_MSR_APIC_ASSIST_PAGE_ADDRESS_SHIFT);
                if (kvm_is_error_hva(addr))
                        return 1;
                if (clear_user((void __user *)addr, PAGE_SIZE))
                        return 1;

   So if this type was changed to void __user *host_addr, and 
   gfn_to_hva() and kvm_is_error_hva() was changed to operate on void *
   then the code would look much cleaner:

                void __user *host_addr;

                host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
                if (kvm_is_error_hva(host_addr)) {

                ptep_user = host_addr + offset;

   And note that we also lost a fragile type cast.

 - Please factor out horrible conditions like:

		if ((walker->level == PT_PAGE_TABLE_LEVEL) ||
		    ((walker->level == PT_DIRECTORY_LEVEL) &&
				is_large_pte(pte) &&
				(PTTYPE == 64 || is_pse(vcpu))) ||
		    ((walker->level == PT_PDPE_LEVEL) &&
				is_large_pte(pte) &&
				mmu->root_level == PT64_ROOT_LEVEL)) {

   into helper inlines as well, with descriptive names.

 - Code like this:

			if (PTTYPE == 32 &&
			    walker->level == PT_DIRECTORY_LEVEL &&
			    is_cpuid_PSE36())

   is clearly hurting from too deep indentation caused by over-inlining.

 - Label names like 'walk:' are actively misleading. Of course it 
   'walks', but that's not the main function of the label: the main 
   function is that it *retries* a page table walk.

   So 'retry_walk:' would be a lot more informative and would make 
   code like this:

			ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index,
						  pte, pte|PT_ACCESSED_MASK);
			if (unlikely(ret < 0)) {
				present = false;
				break;
			} else if (ret)
				goto retry_walk;

   a lot more clearer as well. Small details like this add up.

 - I'd suggest splitting the iterator of the loop out into a helper inline
   and only leave the loop / retry and error logic in walk_addr_generic().
   Maybe even factor out the initialization and error logic - only leaving
   the main retry logic in walk_addr_generic() itself.

All in one, having spent a few minutes with this code i am not 
surprised *at all* that it has grown its *second* dangerous 
uninitialized_var() annotation ...

Please fix it instead.

Thanks,

	Ingo
