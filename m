Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2DSUMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:12:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49106 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2DSUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:12:35 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 01:42:12 +0530
Message-Id: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 0/12] Paravirtualized ticketlocks
x-cbid: 12041920-2674-0000-0000-00000419571C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This series replaces the existing paravirtualized spinlock mechanism
with a paravirtualized ticketlock mechanism. (targeted for 3.5 window)

Changes in V7:
 - Reabsed patches to 3.4-rc3
 - Added jumplabel split patch (originally from Andrew Jones rebased to
    3.4-rc3
 - jumplabel changes from Ingo and Jason taken and now using static_key_*
    instead of static_branch.
 - using UNINLINE_SPIN_UNLOCK (which was splitted as per suggestion from Linus)
 - This patch series is rebased on debugfs patch (that sould be already in
    Xen/linux-next https://lkml.org/lkml/2012/3/23/51)

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

This series provides a Xen implementation, KVM implementation will be
posted in next 2-3 days.

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
patch uses a locked add to do this, followed by a test to see if the
slowflag is set.  The lock prefix acts as a full memory barrier, so we
can be sure that other CPUs will have seen the unlock before we read
the flag (without the barrier the read could be fetched from the
store queue before it hits memory, which could result in a deadlock).

This is is all unnecessary complication if you're not using PV ticket
locks, it also uses the jump-label machinery to use the standard
"add"-based unlock in the non-PV case.

	if (TICKET_SLOWPATH_FLAG &&
	     static_key_false(&paravirt_ticketlocks_enabled))) {
		arch_spinlock_t prev;
		prev = *lock;
		add_smp(&lock->tickets.head, TICKET_LOCK_INC);

		/* add_smp() is a full mb() */
		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
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
2:	movzwl (%rdi),%esi	# Fetch prev

	lock addb $0x2,(%rdi)	# Do unlock

	testb  $0x1,0x1(%rdi)	# Test flag
	je     1b		# Finished if not set

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
aside from requiring a "lock add".

TODO: 1) remove CONFIG_PARAVIRT_SPINLOCK ?
      2) experiments on further optimization possibilities. (discussed in V6)

Results:
=======
various form of results based on V6 of the patch series are posted in following links
 https://lkml.org/lkml/2012/3/21/161
 https://lkml.org/lkml/2012/3/21/198

 kvm results:
 https://lkml.org/lkml/2012/3/23/50
 https://lkml.org/lkml/2012/4/5/73

Thoughts? Comments? Suggestions?

Jeremy Fitzhardinge (9):
  x86/spinlock: replace pv spinlocks with pv ticketlocks
  x86/ticketlock: collapse a layer of functions
  xen: defer spinlock setup until boot CPU setup
  xen/pvticketlock: Xen implementation for PV ticket locks
  xen/pvticketlocks: add xen_nopvspin parameter to disable xen pv
    ticketlocks
  x86/pvticketlock: use callee-save for lock_spinning
  x86/pvticketlock: when paravirtualizing ticket locks, increment by 2
  x86/ticketlock: add slowpath logic
  xen/pvticketlock: allow interrupts to be enabled while blocking

Raghavendra K T (1):
  x86/ticketlock: don't inline _spin_unlock when using paravirt
    spinlocks

Andrew Jones (1):
  split out rate limiting from jump_label.h

Stefano Stabellini (1):
 xen: enable PV ticketlocks on HVM Xen
---

V6 : https://lkml.org/lkml/2012/3/21/161

Changes in V6 posting: (Raghavendra K T)
 - Rebased to linux-3.3-rc6.
 - used function+enum in place of macro (better type checking) 
 - use cmpxchg while resetting zero status for possible race
	[suggested by Dave Hansen for KVM patches ]
 
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/paravirt.h       |   32 +---
 arch/x86/include/asm/paravirt_types.h |   10 +-
 arch/x86/include/asm/spinlock.h       |  128 ++++++++----
 arch/x86/include/asm/spinlock_types.h |   16 +-
 arch/x86/kernel/paravirt-spinlocks.c  |   18 +--
 arch/x86/xen/smp.c                    |    3 +-
 arch/x86/xen/spinlock.c               |  383 +++++++++++----------------------
 include/linux/jump_label.h            |   26 +---
 include/linux/jump_label_ratelimit.h  |   34 +++
 include/linux/perf_event.h            |    1 +
 kernel/jump_label.c                   |    1 +
 12 files changed, 279 insertions(+), 374 deletions(-)

