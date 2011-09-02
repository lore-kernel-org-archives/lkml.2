Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1IBX4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:56:05 -0400
Received: from claw.goop.org ([74.207.240.146]:45547 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab1IBXy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:54:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/8] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Fri,  2 Sep 2011 16:54:07 -0700
Message-Id: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

[ Changes since last posting:
  - fold all the cleanup/bugfix patches into their base patches
  - change spin_lock to make sure fastpath has no cruft in it
  - make sure it doesn't attempt to inline unlock
]

NOTE: this series is based on tip.git tip/x86/spinlocks

This series replaces the existing paravirtualized spinlock mechanism
with a paravirtualized ticketlock mechanism.

Ticket locks have an inherent problem in a virtualized case, because
the vCPUs are scheduled rather than running concurrently (ignoring
gang scheduled vCPUs).  This can result in catastrophic performance
collapses when the vCPU scheduler doesn't schedule the correct "next"
vCPU, and ends up scheduling a vCPU which burns its entire timeslice
spinning.  (Note that this is not the same problem as lock-holder
preemption, which this series also addresses; that's also a problem,
but not catastrophic).

(See Thomas Friebel's talk "Prevent Guests from Spinning Around"
http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)

Currently we deal with this by having PV spinlocks, which adds a layer
of indirection in front of all the spinlock functions, and defining a
completely new implementation for Xen (and for other pvops users, but
there are none at present).

PV ticketlocks keeps the existing ticketlock implemenentation
(fastpath) as-is, but adds a couple of pvops for the slow paths:

- If a CPU has been waiting for a spinlock for SPIN_THRESHOLD
  iterations, then call out to the __ticket_lock_spinning() pvop,
  which allows a backend to block the vCPU rather than spinning.  This
  pvop can set the lock into "slowpath state".

- When releasing a lock, if it is in "slowpath state", the call
  __ticket_unlock_kick() to kick the next vCPU in line awake.  If the
  lock is no longer in contention, it also clears the slowpath flag.

The "slowpath state" is stored in the LSB of the within the lock
ticket.  This has the effect of reducing the max number of CPUs by
half (so, a "small ticket" can deal with 128 CPUs, and "large ticket"
32768).

This series provides a Xen implementation, but it should be
straightforward to add a KVM implementation as well.

Overall, it results in a large reduction in code, it makes the native
and virtualized cases closer, and it removes a layer of indirection
around all the spinlock functions.

The fast path (taking an uncontended lock which isn't in "slowpath"
state) is optimal, identical to the non-paravirtualized case.

The inner part of ticket lock code becomes:
	inc = xadd(&lock->tickets, inc);
	inc.tail &= ~TICKET_SLOWPATH_FLAG;

	if (likely(inc.head == inc.tail))
		goto out;

	for (;;) {
		unsigned count = SPIN_THRESHOLD;

		do {
			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
				goto out;
			cpu_relax();
		} while (--count);
		__ticket_lock_spinning(lock, inc.tail);
	}
out:	barrier();

which results in:
	push   %rbp
	mov    %rsp,%rbp

	mov    $0x200,%eax
	lock xadd %ax,(%rdi)
	movzbl %ah,%edx
	cmp    %al,%dl
	jne    1f

	pop    %rbp
	retq   

	### SLOWPATH START
1:	and    $-2,%edx
	movzbl %dl,%esi

2:	mov    $0x800,%eax
	jmp    4f

3:	pause  
	sub    $0x1,%eax
	je     5f

4:	movzbl (%rdi),%ecx
	cmp    %cl,%dl
	jne    3b

	pop    %rbp
	retq   

5:	callq  *__ticket_lock_spinning
	jmp    2b
	### SLOWPATH END

with CONFIG_PARAVIRT_SPINLOCKS=n, the code has changed slightly, where
the fastpath case is straight through (taking the lock without
contention), and the spin loop is out of line:

	push   %rbp
	mov    %rsp,%rbp

	mov    $0x100,%eax
	lock xadd %ax,(%rdi)
	movzbl %ah,%edx
	cmp    %al,%dl
	jne    1f

	pop    %rbp
	retq   

	### SLOWPATH START
1:	pause  
	movzbl (%rdi),%eax
	cmp    %dl,%al
	jne    1b

	pop    %rbp
	retq   
	### SLOWPATH END

The unlock code is very straightforward:
	__ticket_unlock_release(lock);
	if (unlikely(__ticket_in_slowpath(lock)))
		__ticket_unlock_slowpath(lock);

which generates:
	push   %rbp
	mov    %rsp,%rbp

	addb   $0x2,(%rdi)
	testb  $0x1,0x1(%rdi)
	jne    1f

	pop    %rbp
	retq   

	### SLOWPATH START
1:	movzwl (%rdi),%edx
	movzbl %dh,%ecx
	mov    %edx,%eax
	and    $-2,%ecx	# clear TICKET_SLOWPATH_FLAG
	mov    %cl,%dh
	cmp    %dl,%cl	# test to see if lock is uncontended
	je     3f

2:	movzbl %dl,%esi
	callq  *__ticket_unlock_kick	# kick anyone waiting
	pop    %rbp
	retq   

3:	lock cmpxchg %dx,(%rdi)	# use cmpxchg to safely write back flag
	jmp    2b
	### SLOWPATH END

The fastpath is pretty straightforward, but it is definitely more
complex than a simple "incb (%rdi)" - which is still generated (and
inlined) when PARAVIRT_SPINLOCKS is disabled.

Thoughts? Comments? Suggestions?

Thanks,
	J

Jeremy Fitzhardinge (8):
  x86/spinlocks: replace pv spinlocks with pv ticketlocks
  x86/ticketlock: don't inline _spin_unlock when using paravirt
    spinlocks
  x86/ticketlock: collapse a layer of functions
  xen/pvticketlock: Xen implementation for PV ticket locks
  x86/pvticketlock: use callee-save for lock_spinning
  x86/ticketlocks: when paravirtualizing ticket locks, increment by 2
  x86/ticketlock: add slowpath logic
  xen/pvticketlock: allow interrupts to be enabled while blocking

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/paravirt.h       |   30 +---
 arch/x86/include/asm/paravirt_types.h |   10 +-
 arch/x86/include/asm/spinlock.h       |  134 ++++++++++-----
 arch/x86/include/asm/spinlock_types.h |   16 ++-
 arch/x86/kernel/paravirt-spinlocks.c  |   16 +--
 arch/x86/xen/spinlock.c               |  311 ++++++++-------------------------
 kernel/Kconfig.locks                  |    2 +-
 8 files changed, 193 insertions(+), 329 deletions(-)

-- 
1.7.6

