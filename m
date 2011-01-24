Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1AXXmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:42:20 -0500
Received: from claw.goop.org ([74.207.240.146]:50296 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab1AXXlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:41:23 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/6] Clean up ticketlock implementation
Date: Mon, 24 Jan 2011 15:41:13 -0800
Message-Id: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

This series cleans up the x86 ticketlock implementation by converting
a large proportion of it to C.  This eliminates the need for having
separate implementations for "large" (NR_CPUS >= 256) and "small"
(NR_CPUS < 256) ticket locks.

This also lays the groundwork for future changes to the ticketlock
implementation.

Of course, the big question when converting from assembler to C is
what the compiler will do to the code.  In general, the results are
very similar.

For example, the original hand-coded small-ticket ticket_lock is:
      movl   $256, %eax
      lock xadd %ax,(%rdi)
   1: cmp    %ah,%al
      je     2f
      pause  
      mov    (%rdi),%al
      jmp    1b
   2:

The C version, compiled by gcc 4.5.1 is:
        movl   $256, %eax
        lock; xaddw %ax, (%rdi)
        movzbl  %ah, %edx
.L3:    cmpb    %dl, %al
        je      .L2
        rep; nop
        movb    (%rdi), %al     # lock_1(D)->D.5949.tickets.head, inc$head
        jmp     .L3     #
.L2:

So very similar, except the compiler misses directly comparing
%ah to %al.

With big tickets, which is what distros are typically compiled with,
the results are:

hand-coded:
        movl    $65536, %eax    #, inc
        lock; xaddl %eax, (%rdi)        # inc, lock_2(D)->slock
	movzwl %ax, %edx        # inc, tmp
        shrl $16, %eax  # inc
1:      cmpl %eax, %edx # inc, tmp
        je 2f
        rep ; nop
        movzwl (%rdi), %edx     # lock_2(D)->slock, tmp
        jmp 1b
2:

Compiled C:
        movl    $65536, %eax    #, tickets
        lock; xaddl %eax, (%rdi)        # tickets, lock_1(D)->D.5952.tickets
        movl    %eax, %edx      # tickets,
        shrl    $16, %edx       #,
.L3:    cmpw    %dx, %ax        # tickets$tail, inc$head
        je      .L2     #,
        rep; nop
        movw    (%rdi), %ax     # lock_1(D)->D.5952.tickets.head, inc$head
        jmp     .L3     #
.L2:

In this case the code is pretty much identical except for slight
variations in where the 32-bit values are truncated to 16.

So overall, I think this change will have negligable performance
impact.

Thanks,
	J


Jeremy Fitzhardinge (6):
  x86/ticketlock: clean up types and accessors
  x86/ticketlock: convert spin loop to C
  x86/ticketlock: Use C for __ticket_spin_unlock
  x86/ticketlock: make large and small ticket versions of spin_lock the
    same
  x86/ticketlock: make __ticket_spin_lock common
  x86/ticketlock: make __ticket_spin_trylock common

 arch/x86/include/asm/spinlock.h       |  146 ++++++++++++---------------------
 arch/x86/include/asm/spinlock_types.h |   22 +++++-
 2 files changed, 73 insertions(+), 95 deletions(-)

-- 
1.7.3.4

