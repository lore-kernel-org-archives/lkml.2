Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1A0XyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:54:04 -0500
Received: from claw.goop.org ([74.207.240.146]:54029 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1A0XyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:54:02 -0500
Message-ID: <4D420597.9000305@goop.org>
Date: Thu, 27 Jan 2011 15:53:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 6/6] x86/ticketlock: make __ticket_spin_trylock common
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>	<4086953399116e4d9a14f9fa1aa8cf33aaef753d.1295909909.git.jeremy.fitzhardinge@citrix.com>	<AANLkTimnpm8YdxgnqekMZUbYN=ZAdVy=C1HkY3uHNS2h@mail.gmail.com>	<4D3E2A80.1000203@goop.org> <AANLkTikcUnSYuRkSJivhavsBa+9TdaaHTNNWX7hRdE-J@mail.gmail.com>
In-Reply-To: <AANLkTikcUnSYuRkSJivhavsBa+9TdaaHTNNWX7hRdE-J@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 05:58 PM, Nick Piggin wrote:
>>
>> The C version can't take advantage of the fact that the cmpxchg directly
>> sets the flags, so it ends up re-comparing the old and swapped-out
>> values to set the return.  And it doesn't re-use the same sete to set
>> the return value in the quick failed-to-acquire path.
> Hm.

Adding a "cmpxchg_flag" which does its own sete and returns a boolean
"success" flag, the whole thing goes to:

__ticket_spin_trylock:
        movw    (%rdi), %ax     # lock_2(D)->D.5950.tickets, old
        xorl    %edx, %edx      # D.13949
        movzbl  %ah, %ecx       # old, tmp69
        cmpb    %al, %cl        # old, tmp69
        jne     .L5     #,
        leal    256(%rax), %edx #, D.13951
        lock; cmpxchgw %dx,(%rdi); sete %al     # D.13951,* lock, __ret
        movzbl  %al, %edx       # __ret, D.13949
.L5:
        movl    %edx, %eax      # D.13949,
        ret




The eax/edx shuffle is a bit unfortunate I can't see it hurting very much.


>> It might be worth having a generic cmpxchg() variant which returns a
>> succeed/fail flag rather than the fetched value, to avoid comparison in
>> this case - since many (most?) cmpxchg() callers end up doing that
>> comparison.
>>
>> How performance critical is trylock?  I guess the ones in fs/dcache.c
>> are the ones looming large in your mind.
> Well they are on on the reclaim/free path rather than the _hottest_
> paths, but yes they are performance critical.

I think that code looks pretty reasonable.

    J

