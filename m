Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510Ab2CTQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:04:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42909 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2CTQEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:04:54 -0400
MIME-Version: 1.0
In-Reply-To: <1332249746-2867-1-git-send-email-consul.kautuk@gmail.com>
References: <1332249746-2867-1-git-send-email-consul.kautuk@gmail.com>
Date: Tue, 20 Mar 2012 12:04:53 -0400
Message-ID: <CAFPAmTQFGiF56XLgGHb3Tm15+H2eV=cXU8qDfrHpGabXrsNVNg@mail.gmail.com>
Subject: Re: [PATCH 08/20] m68k/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Im sorry there is a defect in this patch.

I am now posting a v2 of this patch.

On Tue, Mar 20, 2012 at 9:22 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
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
> Port these changes to m68k.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/m68k/mm/fault.c |   31 ++++++++++++++++++++++++++-----
>  1 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
> index 2db6099..27879bd 100644
> --- a/arch/m68k/mm/fault.c
> +++ b/arch/m68k/mm/fault.c
> @@ -74,6 +74,7 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
>        struct mm_struct *mm = current->mm;
>        struct vm_area_struct * vma;
>        int write, fault;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>
>  #ifdef DEBUG
>        printk ("do page fault:\nregs->sr=%#x, regs->pc=%#lx, address=%#lx, %ld, %p\n",
> @@ -88,6 +89,7 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
>        if (in_atomic() || !mm)
>                goto no_context;
>
> +retry:
>        down_read(&mm->mmap_sem);
>
>        vma = find_vma(mm, address);
> @@ -126,6 +128,7 @@ good_area:
>                        if (!(vma->vm_flags & VM_WRITE))
>                                goto acc_err;
>                        write++;
> +                       flags |= FAULT_FLAG_WRITE;
>                        break;
>                case 1:         /* read, present */
>                        goto acc_err;
> @@ -140,10 +143,14 @@ good_area:
>         * the fault.
>         */
>
> -       fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
> +       fault = handle_mm_fault(mm, vma, address, flags);
>  #ifdef DEBUG
>        printk("handle_mm_fault returns %d\n",fault);
>  #endif
> +
> +       if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +               return;

Incorrect. This function returns an int.

> +
>        if (unlikely(fault & VM_FAULT_ERROR)) {
>                if (fault & VM_FAULT_OOM)
>                        goto out_of_memory;
> @@ -151,10 +158,24 @@ good_area:
>                        goto bus_err;
>                BUG();
>        }
> -       if (fault & VM_FAULT_MAJOR)
> -               current->maj_flt++;
> -       else
> -               current->min_flt++;
> +
> +       if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +               if (fault & VM_FAULT_MAJOR)
> +                       current->maj_flt++;
> +               else
> +                       current->min_flt++;
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
> +               }
> +       }
>
>        up_read(&mm->mmap_sem);
>        return 0;
> --
> 1.7.5.4
>
