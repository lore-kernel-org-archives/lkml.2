Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab2CTQPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:15:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36797 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2CTQP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <1332251159-3582-1-git-send-email-consul.kautuk@gmail.com>
References: <1332251159-3582-1-git-send-email-consul.kautuk@gmail.com>
Date: Tue, 20 Mar 2012 12:15:28 -0400
Message-ID: <CAFPAmTQBkO8X424-_oqHA7sZqi=H0+U4Bv2=Brxc59Dhi5FhBA@mail.gmail.com>
Subject: Re: [PATCH 1/1] um/kernel/trap.c: Port OOM changes to handle_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

There is a small defect in this patch.
I am sending a v2to this patch.

On Tue, Mar 20, 2012 at 9:45 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
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
> Port these changes to um.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/um/kernel/trap.c |   24 +++++++++++++++++++-----
>  1 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
> index dafc947..76adb61 100644
> --- a/arch/um/kernel/trap.c
> +++ b/arch/um/kernel/trap.c
> @@ -30,6 +30,8 @@ int handle_page_fault(unsigned long address, unsigned long ip,
>        pmd_t *pmd;
>        pte_t *pte;
>        int err = -EFAULT;
> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +                                (is_write ? FAULT_FLAG_WRITE : 0);
>
>        *code_out = SEGV_MAPERR;
>
> @@ -40,6 +42,7 @@ int handle_page_fault(unsigned long address, unsigned long ip,
>        if (in_atomic())
>                goto out_nosemaphore;
>
> +retry:
>        down_read(&mm->mmap_sem);
>        vma = find_vma(mm, address);
>        if (!vma)
> @@ -65,7 +68,11 @@ good_area:
>        do {
>                int fault;
>
> -               fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
> +               fault = handle_mm_fault(mm, vma, address, flags);
> +
> +               if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> +                       goto out;

The out: label will do an up_read which is not required here.
So, in v2 of this patch I am now doing a goto out_nosmaphore.

> +
>                if (unlikely(fault & VM_FAULT_ERROR)) {
>                        if (fault & VM_FAULT_OOM) {
>                                goto out_of_memory;
> @@ -75,10 +82,17 @@ good_area:
>                        }
>                        BUG();
>                }
> -               if (fault & VM_FAULT_MAJOR)
> -                       current->maj_flt++;
> -               else
> -                       current->min_flt++;
> +               if (flags & FAULT_FLAG_ALLOW_RETRY) {
> +                       if (fault & VM_FAULT_MAJOR)
> +                               current->maj_flt++;
> +                       else
> +                               current->min_flt++;
> +                       if (fault & VM_FAULT_RETRY) {
> +                               flags &= ~FAULT_FLAG_ALLOW_RETRY;
> +
> +                               goto retry;
> +                       }
> +               }
>
>                pgd = pgd_offset(mm, address);
>                pud = pud_offset(pgd, address);
> --
> 1.7.5.4
>
