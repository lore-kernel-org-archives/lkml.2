Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab1JDXdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:33:38 -0400
Received: from claw.goop.org ([74.207.240.146]:57351 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933868Ab1JDXbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:31:31 -0400
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
Subject: [PATCH RFC V4 00/11] Paravirtualized ticketlocks
Date: Tue,  4 Oct 2011 16:31:06 -0700
Message-Id: <cover.1317762058.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

[ Changes since last posting:

  - Stephan Diestelhorst <stephan.diestelhorst@amd.com> pointed out
    that my old unlock code was unsound, and could lead to deadlocks
    (at least in principle).  The new unlock code is definitely sound,
    but likely slower as it introduces a locked xadd; this seems
    unavoidable.  However, when PV ticketlocks are not enabled, the
    unlock code is as it normally would be (a single unlocked add),
    and it uses the jump-label machinery to make the selection at
    runtime.
]

NOTE: this series is available in:
      git://github.com/jsgf/linux-xen.git upstream/pvticketlock-slowflag
and is based on the previously posted ticketlock cleanup series in
      git://github.com/jsgf/linux-xen.git upstream/ticketlock-cleanup

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

The "slowpath state" is stored in the LSB of the within the lock tail
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
	jne    1f	# Slowpath if lock in contention

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

The unlock code is complicated by the need to both add to the lock's
"head" and fetch the slowpath flag from "tail".  This version of the
patch uses a locked xadd to do this, along with a correction to
prevent an overflow in "head" from leaking into "tail".

This is is all unnecessary complication if you're not using PV ticket
locks, it also uses the jump-label machinery to use the standard
"add"-based unlock in the non-PV case.

	if (TICKET_SLOWPATH_FLAG &&
	    unlikely(static_branch(&paravirt_ticketlocks_enabled))) {
		arch_spinlock_t prev;
		__ticketpair_t inc = TICKET_LOCK_INC;

		if (lock->tickets.head >= (1 << TICKET_SHIFT) - TICKET_LOCK_INC)
			inc += -1 << TICKET_SHIFT;

		prev.head_tail = xadd(&lock->head_tail, inc);

		if (unlikely(prev.tickets.tail & TICKET_SLOWPATH_FLAG))
			__ticket_unlock_slowpath(lock, prev);
	} else
		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);

which generates:
	push   %rbp
	mov    %rsp,%rbp

	nop5	# replaced by 5-byte jmp 2f when PV enabled

	# non-PV unlock
	addb   $0x2,(%rdi)

1:	pop    %rbp
	retq   

### PV unlock ###
2:	cmpb   $254,(%rdi)	# cmp head >= 254
	sbb    %esi,%esi	# esi = carry ? 0xffff : 0x0000
	and    $0x100,%si	# si = 0x0100 or 0x0000
	sub    $254,%si		# si = 0x0002 or 0xff02
	lock xadd %si,(%rdi)
	test   $0x100,%si	# Test slowpath flag
	je     1b		# Done if clear

### Slow path ###
	add    $2,%sil		# Add "head" in old lock state
	mov    %esi,%edx
	and    $0xfe,%dh	# clear slowflag for comparison
	movzbl %dh,%eax
	cmp    %dl,%al		# If head == tail (uncontended)
	je     4f		# clear slowpath flag

	# Kick next CPU waiting for lock
3:	movzbl %sil,%esi
	callq  *pv_lock_ops.kick

	pop    %rbp
	retq   

	# Lock no longer contended - clear slowflag
4:	mov    %esi,%eax
	lock cmpxchg %dx,(%rdi)	# cmpxchg to clear flag
	cmp    %si,%ax
	jne    3b		# If clear failed, then kick

	pop    %rbp
	retq   

So when not using PV ticketlocks, the unlock sequence just has a
5-byte nop added to it, and the PV case is reasonable straightforward
aside from requiring a "lock xadd".

Thoughts? Comments? Suggestions?

Jeremy Fitzhardinge (10):
  x86/spinlock: replace pv spinlocks with pv ticketlocks
  x86/ticketlock: don't inline _spin_unlock when using paravirt
    spinlocks
  x86/ticketlock: collapse a layer of functions
  xen: defer spinlock setup until boot CPU setup
  xen/pvticketlock: Xen implementation for PV ticket locks
  xen/pvticketlocks: add xen_nopvspin parameter to disable xen pv
    ticketlocks
  x86/pvticketlock: use callee-save for lock_spinning
  x86/pvticketlock: when paravirtualizing ticket locks, increment by 2
  x86/ticketlock: add slowpath logic
  xen/pvticketlock: allow interrupts to be enabled while blocking

Stefano Stabellini (1):
  xen: enable PV ticketlocks on HVM Xen

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/paravirt.h       |   30 +---
 arch/x86/include/asm/paravirt_types.h |   10 +-
 arch/x86/include/asm/spinlock.h       |  139 ++++++++++-----
 arch/x86/include/asm/spinlock_types.h |   16 +-
 arch/x86/kernel/paravirt-spinlocks.c  |   18 +--
 arch/x86/xen/smp.c                    |    3 +-
 arch/x86/xen/spinlock.c               |  331 ++++++++++-----------------------
 kernel/Kconfig.locks                  |    2 +-
 9 files changed, 221 insertions(+), 331 deletions(-)

-- 
1.7.6.4

