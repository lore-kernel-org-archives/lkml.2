Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3AFD6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 22:58:01 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:34921 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3AFD6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 22:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130105152208.GA3386@redhat.com>
References: <20130105152208.GA3386@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Jan 2013 19:57:39 -0800
X-Google-Sender-Auth: JNHCOjR-5X9T4aerqlTKai6p7P0
Message-ID: <CA+55aFwkP=nA32pBO0gNm51nPxqWiq1e1zWzGEJoVQ1gP=CgDQ@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding more people in case somebody else has any idea. Anybody?

On Sat, Jan 5, 2013 at 7:22 AM, Dave Jones <davej@redhat.com> wrote:
> I have no idea what happened here, but this is the first time I've seen this one.
> This was running a tree pulled yesterday afternoon.
>
> BUG: unable to handle kernel paging request at ffff880100201000

This is %rsi, which is the source for the page copy:

  copy_user_highpage()->
    copy_user_page()->
      copy_page()->
        copy_page_rep

I don't know exactly which copy_user_highpage() case this is from, the
call trace implies this *could* be a hugepage, and those functions do
copy pages individually in a loop too.

> IP: [<ffffffff81333235>] copy_page_rep+0x5/0x10
> PGD 1c0c063 PUD cfbff067 PMD cfc01067 PTE 8000000100201160

Hmm. That PTE looks really odd. If I read the PUD/PMD contents right,
the page tables are for individual pages, but then the PTE doesn't
have the present bit set: other than that it looks like it could be a
valid PTE (NX and global bit set, Accessed and dirty also set, but the
two low bits are clear: present and writable are clear).

 I think it's due to DEBUG_PAGEALLOC, so the (free) page has been
unmapped from the kernel mapping.

But how could a page that is the source of a page fault be free?

> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3505, comm: trinity-child0 Not tainted 3.8.0-rc2+ #45 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
> RIP: 0010:[<ffffffff81333235>]  [<ffffffff81333235>] copy_page_rep+0x5/0x10
> RAX: 0000000100201000 RBX: 000000011d215000 RCX: 0000000000000200

The RCX value is 0x200, so this is the first access to that page. As expected.

> RDX: cccccccccccccccd RSI: ffff880100201000 RDI: ffff88011d215000

RSI (source) and RDI (destination) both look like valid kernel mapping
pages. But RSI isn't mapped, presumably because debug-pagealloc thinks
it is free.

Anybody with any ideas? The call trace indicates a normal page fault
from user space, so..

                   Linus

> Call Trace:
>  [<ffffffff8119a9c7>] ? do_huge_pmd_wp_page+0x707/0xc00
>  [<ffffffff81165f1c>] handle_mm_fault+0x14c/0x590
>  [<ffffffff810b35ce>] ? __lock_is_held+0x5e/0x90
>  [<ffffffff816a280c>] __do_page_fault+0x15c/0x4e0
>  [<ffffffff8100a1b6>] ? native_sched_clock+0x26/0x90
>  [<ffffffff810b28e8>] ? trace_hardirqs_off_caller+0x28/0xc0
>  [<ffffffff81334cbd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff816a2b9e>] do_page_fault+0xe/0x10
>  [<ffffffff8169f822>] page_fault+0x22/0x30
> Code: 90 90 90 90 90 90 9c fa 65 48 3b 06 75 14 65 48 3b 56 08 75 0d 65 48 89 1e 65 48 89 4e 08 9d b0 01 c3 9d 30 c0 c3 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 66 66 66 90 66 66 66 90
> RIP  [<ffffffff81333235>] copy_page_rep+0x5/0x10
