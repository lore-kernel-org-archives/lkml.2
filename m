Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1DLTSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:18:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33590 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1DLTSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110412190804.GB13752@redhat.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
	<BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
	<20110412182809.GA1218@redhat.com>
	<20110412190731.GA13752@redhat.com>
	<20110412190804.GB13752@redhat.com>
Date: Tue, 12 Apr 2011 21:18:47 +0200
Message-ID: <BANLkTinenKYRUtfif_LEXhZByYkKD95UNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] __mlock_vma_pages_range: stack_guard_page() case
 returns the wrong value
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 9:08 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> __mlock_vma_pages_range() simply changes addr/nr_pages when
> stack_guard_page(vma, start). But this means that __get_user_pages()
> returns a number which doesn't match the [start, end) interval and
> the caller can be confused.
>
> If we skip the first page, we should return 1 if gup fails, or add
> 1 to the number it returns.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>
>  mm/mlock.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> --- sigprocmask/mm/mlock.c~do_mlock_pages_stack_guard_page      2011-04-06 21:33:50.000000000 +0200
> +++ sigprocmask/mm/mlock.c      2011-04-12 20:50:30.000000000 +0200
> @@ -159,9 +159,8 @@ static long __mlock_vma_pages_range(stru
>                                    int *nonblocking)
>  {
>        struct mm_struct *mm = vma->vm_mm;
> -       unsigned long addr = start;
>        int nr_pages = (end - start) / PAGE_SIZE;
> -       int gup_flags;
> +       int gup_flags, skip_page, ret;
>
>        VM_BUG_ON(start & ~PAGE_MASK);
>        VM_BUG_ON(end   & ~PAGE_MASK);
> @@ -189,13 +188,22 @@ static long __mlock_vma_pages_range(stru
>                gup_flags |= FOLL_MLOCK;
>
>        /* We don't try to access the guard page of a stack vma */
> +       skip_page = 0;
>        if (stack_guard_page(vma, start)) {
> -               addr += PAGE_SIZE;
> +               skip_page = 1;
> +               start += PAGE_SIZE;
>                nr_pages--;
>        }
>
> -       return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
> +       ret = __get_user_pages(current, mm, start, nr_pages, gup_flags,
>                                NULL, NULL, nonblocking);
> +
> +       if (ret >= 0)
> +               ret += skip_page;
> +       else if (skip_page)
> +               ret = 1;
> +
> +       return ret;
>  }
>
>  /*

Compiling with Linus' new patch now, lemme know if you agree on which
one might be the more correct one :). Otherwise I'll stick to the
first choice, and let you know tomorrow if it worked some more
extensive testing.

-- 
Robert Święcki
