Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1KMB1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 20:27:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45523 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1KMB1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 20:27:47 -0500
MIME-Version: 1.0
In-Reply-To: <1321145481-3329-1-git-send-email-consul.kautuk@gmail.com>
References: <1321145481-3329-1-git-send-email-consul.kautuk@gmail.com>
Date: Sat, 12 Nov 2011 20:27:45 -0500
Message-ID: <CAFPAmTSzb0Hvf=7dVJ044BM3kTCiXuFfAf27nbT+Bt-4oBQ2hg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] arch/arm/mm/fault.c: Porting OOM changes into __do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I made one more mistake about the locking:
We cannot do a up_read as VM_FAULT_RETRY might be set.

I will modify the patch and send it again for review.

On Sat, Nov 12, 2011 at 7:51 PM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> Commits d065bd810b6deb67d4897a14bfe21f8eb526ba99 and
> 37b23e0525d393d48a7d59f870b3bc061a30ccdb introduced changes into
> the x86 pagefault handler for makeing the page fault handler
> retryable as well as killable.
>
> These changes reduce the mmap_sem hold time(for x86), which is crucial
> during OOM killer invocation.
>
> Porting these changes to ARM.
>
> Without these changes, my ARM board encounters many hang and livelock
> scenarios.
> After applying this patch, OOM feature performance improves according to
> my testing.
>
> Motivation for porting these changes:
> ------------------------------------
> Embedded devices such as SMART TVs and SMART phones in the near future
> will have the capability to download and run apps from the internet.
> Due to this, the device user might run some malignant app that
> allocates too much memory.
> In that case, OOM killer performance is very important so that the
> device can free up memory for other apps as well as the kernel.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/arm/mm/fault.c |   48 +++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 37 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index aa33949..7286786 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -231,7 +231,7 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
>
>  static int __kprobes
>  __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
> -               struct task_struct *tsk)
> +               unsigned int flags, struct task_struct *tsk)
>  {
>        struct vm_area_struct *vma;
>        int fault;
> @@ -257,13 +257,9 @@ good_area:
>         * If for any reason at all we couldn't handle the fault, make
>         * sure we exit gracefully rather than endlessly redo the fault.
>         */
> -       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, (fsr & FSR_WRITE) ? FAULT_FLAG_WRITE : 0);
> +       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
>        if (unlikely(fault & VM_FAULT_ERROR))
>                return fault;
> -       if (fault & VM_FAULT_MAJOR)
> -               tsk->maj_flt++;
> -       else
> -               tsk->min_flt++;
>        return fault;
>
>  check_stack:
> @@ -279,6 +275,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>        struct task_struct *tsk;
>        struct mm_struct *mm;
>        int fault, sig, code;
> +       int write = fsr & FSR_WRITE;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +                                       (write ? FAULT_FLAG_WRITE : 0);
>
>        if (notify_page_fault(regs, fsr))
>                return 0;
> @@ -305,6 +304,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>        if (!down_read_trylock(&mm->mmap_sem)) {
>                if (!user_mode(regs) && !search_exception_tables(regs->ARM_pc))
>                        goto no_context;
> +retry:
>                down_read(&mm->mmap_sem);
>        } else {
>                /*
> @@ -320,14 +320,40 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  #endif
>        }
>
> -       fault = __do_page_fault(mm, addr, fsr, tsk);
> +       fault = __do_page_fault(mm, addr, fsr, flags, tsk);
> +
> +       /* If we need to retry but a fatal signal is pending, handle the
> +        * signal first. We do not need to release the mmap_sem because
> +        * it would already be released in __lock_page_or_retry in
> +        * mm/filemap.c. */
> +       if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +               return 0;
> +
>        up_read(&mm->mmap_sem);
>
> +       /*
> +        * Major/minor page fault accounting is only done on the
> +        * initial attempt. If we go through a retry, it is extremely
> +        * likely that the page will be found in page cache at that point.
> +        */
>        perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
> -       if (fault & VM_FAULT_MAJOR)
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, addr);
> -       else if (fault & VM_FAULT_MINOR)
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, addr);
> +       if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +               if (fault & VM_FAULT_MAJOR) {
> +                       tsk->maj_flt++;
> +                       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
> +                                     regs, addr);
> +               } else {
> +                       tsk->min_flt++;
> +                       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
> +                                     regs, addr);
> +               }
> +               if (fault & VM_FAULT_RETRY) {
> +                       /* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
> +                        * of starvation. */
> +                       flags &= ~FAULT_FLAG_ALLOW_RETRY;
> +                       goto retry;
> +               }
> +       }
>
>        /*
>         * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
> --
> 1.7.5.4
>
>
