Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1KLXBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 18:01:13 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47325 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1KLXBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 18:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <1321122781-2096-1-git-send-email-consul.kautuk@gmail.com>
References: <1321122781-2096-1-git-send-email-consul.kautuk@gmail.com>
Date: Sat, 12 Nov 2011 18:01:10 -0500
Message-ID: <CAFPAmTRB9vvoNtGbnfLt9PX3jchxhs63F4WbPdi4bjYBrHgQXg@mail.gmail.com>
Subject: Re: [PATCH 1/1] arch/arm/mm/fault.c: Porting OOM changes into __do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore this patch.

There is one error in it which I discovered through code review:
lockdep will detect a lock imbalance in the up_read() inside do_page_fault
if __do_page_fault returns with VM_FAULT_RETRY set in the fault variable.
This will happen in the fatal signal handling case of __do_page_fault.

I'll post another patch which takes care of this.

On Sat, Nov 12, 2011 at 1:33 PM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
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
>  arch/arm/mm/fault.c |   57 ++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 43 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index aa33949..f251ec1 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -231,11 +231,15 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
>
>  static int __kprobes
>  __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
> -               struct task_struct *tsk)
> +               struct pt_regs *regs, struct task_struct *tsk)
>  {
>        struct vm_area_struct *vma;
>        int fault;
> +       int write = fsr & FSR_WRITE;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +                                       (write ? FAULT_FLAG_WRITE : 0);
>
> +retry:
>        vma = find_vma(mm, addr);
>        fault = VM_FAULT_BADMAP;
>        if (unlikely(!vma))
> @@ -257,13 +261,44 @@ good_area:
>         * If for any reason at all we couldn't handle the fault, make
>         * sure we exit gracefully rather than endlessly redo the fault.
>         */
> -       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, (fsr & FSR_WRITE) ? FAULT_FLAG_WRITE : 0);
> -       if (unlikely(fault & VM_FAULT_ERROR))
> +       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
> +
> +       if (unlikely((fault & VM_FAULT_ERROR)))
>                return fault;
> -       if (fault & VM_FAULT_MAJOR)
> -               tsk->maj_flt++;
> -       else
> -               tsk->min_flt++;
> +
> +       if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +               return fault;
> +
> +       /*
> +        * Major/minor page fault accounting is only done on the
> +        * initial attempt. If we go through a retry, it is extremely
> +        * likely that the page will be found in page cache at that point.
> +        */
> +       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
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
> +
> +                       /* Acquire the mmap_sem again before retrying this
> +                        * pagefault. This would have been released by
> +                        * __lock_page_or_retry() in mm/filemap.c. */
> +                       down_read(&mm->mmap_sem);
> +
> +                       goto retry;
> +               }
> +       }
> +
>        return fault;
>
>  check_stack:
> @@ -320,15 +355,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  #endif
>        }
>
> -       fault = __do_page_fault(mm, addr, fsr, tsk);
> +       fault = __do_page_fault(mm, addr, fsr, regs, tsk);
>        up_read(&mm->mmap_sem);
>
> -       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
> -       if (fault & VM_FAULT_MAJOR)
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, addr);
> -       else if (fault & VM_FAULT_MINOR)
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, addr);
> -
>        /*
>         * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
>         */
> --
> 1.7.5.4
>
>
