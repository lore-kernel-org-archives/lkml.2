Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab2CTQJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:09:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50757 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab2CTQJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <1332249981-3178-1-git-send-email-consul.kautuk@gmail.com>
References: <1332249981-3178-1-git-send-email-consul.kautuk@gmail.com>
Date: Tue, 20 Mar 2012 12:09:30 -0400
Message-ID: <CAFPAmTSB_Xd9=aZFu4Y3zS0PA2yThC84Rk3J4qAaebqr6uxfqw@mail.gmail.com>
Subject: Re: [PATCH 16/20] tile/mm/fault.c: Port OOM changes to handle_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>, paul.mckenney@linaro.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

There is a defect in this patch.

So, Ill post a v2 to this right away.

On Tue, Mar 20, 2012 at 9:26 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
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
> Port these changes to tile.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/tile/mm/fault.c |   31 ++++++++++++++++++++++++++-----
>  1 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> index c1eaaa1..a097631 100644
> --- a/arch/tile/mm/fault.c
> +++ b/arch/tile/mm/fault.c
> @@ -267,6 +267,8 @@ static int handle_page_fault(struct pt_regs *regs,
>        int si_code;
>        int is_kernel_mode;
>        pgd_t *pgd;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +                                                (write ? FAULT_FLAG_WRITE : 0);
>
>        /* on TILE, protection faults are always writes */
>        if (!is_page_fault)
> @@ -373,6 +375,8 @@ static int handle_page_fault(struct pt_regs *regs,
>                        vma = NULL;  /* happy compiler */
>                        goto bad_area_nosemaphore;
>                }
> +
> +retry:
>                down_read(&mm->mmap_sem);
>        }
>
> @@ -420,7 +424,11 @@ good_area:
>         * make sure we exit gracefully rather than endlessly redo
>         * the fault.
>         */
> -       fault = handle_mm_fault(mm, vma, address, write);
> +       fault = handle_mm_fault(mm, vma, address, flags);
> +
> +       if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +               return;

Incorrect!
This function returns an int.

> +
>        if (unlikely(fault & VM_FAULT_ERROR)) {
>                if (fault & VM_FAULT_OOM)
>                        goto out_of_memory;
> @@ -428,10 +436,23 @@ good_area:
>                        goto do_sigbus;
>                BUG();
>        }
> -       if (fault & VM_FAULT_MAJOR)
> -               tsk->maj_flt++;
> -       else
> -               tsk->min_flt++;
> +       if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +               if (fault & VM_FAULT_MAJOR)
> +                       tsk->maj_flt++;
> +               else
> +                       tsk->min_flt++;
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
>  #if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
>        /*
> --
> 1.7.5.4
>
