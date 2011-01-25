Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AYB6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:58:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64782 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1AYB6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IVH+wJyl7OwZ3d8H4oPZ5FRS1I6BGx4+9TQgbVWNPYhXJ3OzQGYKIp7hC8xHOjllMg
         EZ1JkONZPy7nrsQ7+4Ycfr56jGfIGKbjiWakJ9iYzaGun41BopzU/rTKH+V63NUGZjQF
         HYyq9Ob2A4zrl8FOPF+wYxAzlb+3WLHhEay0I=
MIME-Version: 1.0
In-Reply-To: <4D3E2A80.1000203@goop.org>
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
	<4086953399116e4d9a14f9fa1aa8cf33aaef753d.1295909909.git.jeremy.fitzhardinge@citrix.com>
	<AANLkTimnpm8YdxgnqekMZUbYN=ZAdVy=C1HkY3uHNS2h@mail.gmail.com>
	<4D3E2A80.1000203@goop.org>
Date: Tue, 25 Jan 2011 12:58:33 +1100
Message-ID: <AANLkTikcUnSYuRkSJivhavsBa+9TdaaHTNNWX7hRdE-J@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/ticketlock: make __ticket_spin_trylock common
From: Nick Piggin <npiggin@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:42 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 01/24/2011 05:16 PM, Nick Piggin wrote:
>> On Tue, Jan 25, 2011 at 10:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> Make trylock code common regardless of ticket size.
>> What's the asm for this look like?
>
> Asm:
>
>        movzwl (%rdi), %eax     # lock_1(D)->slock, tmp
>        cmpb %ah,%al    # tmp
>        leal 0x100(%rax), %edx  # tmp, new
>        jne 1f
>        lock; cmpxchgw %dx,(%rdi)       # new, lock_1(D)->slock
> 1:      sete %dl      # new
>        movzbl %dl,%eax # new, tmp
>
>
>
> C:
>
>        movw    (%rdi), %dx     # lock_2(D)->D.5949.tickets, old
>        xorl    %eax, %eax      # D.13954
>        movzbl  %dh, %ecx       # old, tmp70
>        cmpb    %dl, %cl        # old, tmp70
>        jne     .L5     #,
>        leal    256(%rdx), %ecx #, D.13956
>        movl    %edx, %eax      # old, __ret
>        lock; cmpxchgw %cx,(%rdi)       # D.13956,* lock
>        cmpw    %dx, %ax        # old, __ret
>        sete    %al     #, D.13954
>        movzbl  %al, %eax       # D.13954, D.13954
> .L5:
>
>
> The C version can't take advantage of the fact that the cmpxchg directly
> sets the flags, so it ends up re-comparing the old and swapped-out
> values to set the return.  And it doesn't re-use the same sete to set
> the return value in the quick failed-to-acquire path.

Hm.


> It might be worth having a generic cmpxchg() variant which returns a
> succeed/fail flag rather than the fetched value, to avoid comparison in
> this case - since many (most?) cmpxchg() callers end up doing that
> comparison.
>
> How performance critical is trylock?  I guess the ones in fs/dcache.c
> are the ones looming large in your mind.

Well they are on on the reclaim/free path rather than the _hottest_
paths, but yes they are performance critical.
