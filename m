Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1EHVsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:48:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab1EHVr6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 May 2011 14:47:33 -0700
Message-ID: <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 8, 2011 at 11:55 AM, Mikulas Patocka
<mikulas@artax.karlin.mff.cuni.cz> wrote:
>
> This patch fixes lvm2 on PA-RISC (and possibly other architectures with
> up-growing stack). lvm2 calculates the number of used pages when locking
> and when unlocking and reports an internal error if the numbers mismatch.

This patch won't apply on current kernels (including stable) because
of commit a1fde08c74e9 that changed the test of "pages" to instead
just test "flags & FOLL_MLOCK".

That should be trivial to fix up.

However, I really don't much like this complex test:

>  static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
>  {
> -       return (vma->vm_flags & VM_GROWSDOWN) &&
> +       return ((vma->vm_flags & VM_GROWSDOWN) &&
>                (vma->vm_start == addr) &&
> -               !vma_stack_continue(vma->vm_prev, addr);
> +               !vma_stack_continue(vma->vm_prev, addr)) ||
> +              ((vma->vm_flags & VM_GROWSUP) &&
> +               (vma->vm_end == addr + PAGE_SIZE) &&
> +               !vma_stack_growsup_continue(vma->vm_next, addr + PAGE_SIZE));
>  }

in that format. It gets really hard to read, and I think you'd be
better off writing it as two helper functions (or macros) for the two
cases, and then have

  static inline int stack_guard_page(struct vm_area_struct *vma,
unsigned long addr)
  {
    return stack_guard_page_growsdown(vma, addr) ||
      stack_guard_page_growsup(vma, addr);
  }

I'd also like to verify that it doesn't actually generate any extra
code for the common case (iirc VM_GROWSUP is 0 for the architectures
that don't need it, and so the compiler shouldn't generate any extra
code, but I'd like that mentioned and verified explicitly).

Hmm?

Other than that it looks ok to me.

That said, could we please fix LVM to not do that crazy sh*t in the
first place? The STACK_GROWSUP case is never going to have a lot of
testing, this is just sad.

                   Linus
