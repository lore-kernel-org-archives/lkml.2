Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2CTP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:59:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39302 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2CTP7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <1332252722-3794-1-git-send-email-consul.kautuk@gmail.com>
References: <1332252722-3794-1-git-send-email-consul.kautuk@gmail.com>
Date: Tue, 20 Mar 2012 11:59:39 -0400
Message-ID: <CAFPAmTSYNE4gVu_qJVngBjqcvb=CH04jrvdKnAR-oaiPk-rdDA@mail.gmail.com>
Subject: Re: [PATCH 04/20 v2] powerpc/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jimi Xenidis <jimix@pobox.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry I found one more defect in this patch below.

Im gonna send a v3 for this patch.

On Tue, Mar 20, 2012 at 10:12 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to powerpc.
>
> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/powerpc/mm/fault.c |   51 +++++++++++++++++++++++++++++++++-------------
>  1 files changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 2f0d1b0..a3b1176 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -129,6 +129,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
>        int is_write = 0, ret;
>        int trap = TRAP(regs);
>        int is_exec = trap == 0x400;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>
>  #if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE))
>        /*
> @@ -212,6 +213,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
>                if (!user_mode(regs) && !search_exception_tables(regs->nip))
>                        goto bad_area_nosemaphore;
>
> +retry:
>                down_read(&mm->mmap_sem);
>        }
>
> @@ -313,6 +315,7 @@ good_area:
>        } else if (is_write) {
>                if (!(vma->vm_flags & VM_WRITE))
>                        goto bad_area;
> +               flags |= FAULT_FLAG_WRITE;
>        /* a read */
>        } else {
>                /* protection fault */
> @@ -327,7 +330,11 @@ good_area:
>         * make sure we exit gracefully rather than endlessly redo
>         * the fault.
>         */
> -       ret = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
> +       ret = handle_mm_fault(mm, vma, address, flags);
> +
> +       if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +               return;

Incorrect!
This should return 0 or 1.

> +
>        if (unlikely(ret & VM_FAULT_ERROR)) {
>                if (ret & VM_FAULT_OOM)
>                        goto out_of_memory;
> @@ -335,22 +342,36 @@ good_area:
>                        goto do_sigbus;
>                BUG();
>        }
> -       if (ret & VM_FAULT_MAJOR) {
> -               current->maj_flt++;
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
> -                                    regs, address);
> -#ifdef CONFIG_PPC_SMLPAR
> -               if (firmware_has_feature(FW_FEATURE_CMO)) {
> -                       preempt_disable();
> -                       get_lppaca()->page_ins += (1 << PAGE_FACTOR);
> -                       preempt_enable();
> +       if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +               if (ret & VM_FAULT_MAJOR) {
> +                       current->maj_flt++;
> +                       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
> +                                            regs, address);
> +#ifdef CONFIG_PPC_SMLPAR
> +                       if (firmware_has_feature(FW_FEATURE_CMO)) {
> +                               preempt_disable();
> +                               get_lppaca()->page_ins += (1 << PAGE_FACTOR);
> +                               preempt_enable();
> +                       }
> +#endif
> +               } else {
> +                       current->min_flt++;
> +                       perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
> +                                            regs, address);
> +               }
> +               if (fault & VM_FAULT_RETRY) {
> +                       flags &= ~FAULT_FLAG_ALLOW_RETRY;
> +
> +                       /*
> +                        * No need to up_read(&mm->mmap_sem) as we would
> +                        * have already released it in __lock_page_or_retry
> +                        * in mm/filemap.c.
> +                        */
> +
> +                       goto retry;
>                }
> -#endif
> -       } else {
> -               current->min_flt++;
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
> -                                    regs, address);
>        }
> +
>        up_read(&mm->mmap_sem);
>        return 0;
>
> --
> 1.7.5.4
>
