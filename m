Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1IBA5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:57:05 -0400
Received: from claw.goop.org ([74.207.240.146]:43199 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865Ab1IBAza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:30 -0400
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
Subject: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
Date: Thu,  1 Sep 2011 17:54:53 -0700
Message-Id: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
around all the spinlock functions.  The downside is that it does add a
few instructions into the fastpath in the native case.

Most of the heavy lifting code is in the slowpaths, but it does have
an effect on the fastpath code.  The inner part of ticket lock code
becomes:
	inc = xadd(&lock->tickets, inc);
	inc.tail &= ~TICKET_SLOWPATH_FLAG;

	for (;;) {
		unsigned count = SPIN_THRESHOLD;

		do {
			if (inc.head == inc.tail)
				goto out;
			cpu_relax();
			inc.head = ACCESS_ONCE(lock->tickets.head);
		} while (--count);
		__ticket_lock_spinning(lock, inc.tail);
	}

which results in:

      pushq   %rbp
      movq    %rsp,%rbp

      movl    $512, %ecx
      lock; xaddw %cx, (%rdi)	# claim ticket

      movzbl  %ch, %edx
      movl    $2048, %eax	# set spin count
      andl    $-2, %edx		# mask off TICKET_SLOWPATH_FLAG
      movzbl  %dl, %esi

1:    cmpb    %dl, %cl		# compare head and tail
      je      2f   		# got it!

      ### BEGIN SLOWPATH
      rep; nop			# pause
      decl    %eax		# dec count
      movb    (%rdi), %cl	# re-fetch head
      jne     1b      		# try again

      call    *pv_lock_ops	# call __ticket_lock_spinning
      movl    $2048, %eax	# reload spin count
      jmp     1b
      ### END SLOWPATH

2:    popq    %rbp
      ret

with CONFIG_PARAVIRT_SPINLOCKS=n, the same code identical asm to the
current ticketlock code:

	pushq   %rbp
        movq    %rsp, %rbp

        movl    $256, %eax
	lock; xaddw %ax, (%rdi)

	movzbl  %ah, %edx

1:	cmpb    %dl, %al	# compare head and tail
	je	2f   		# got it!

	### BEGIN SLOWPATH
	rep; nop		# pause
	movb    (%rdi), %al	# reload head
	jmp	1b		# loop
	### END SLOWPATH

2:	popq	%rbp
	ret

so the pv ticketlocks add 3 extra instructions to the fastpath, one of
which really doesn't need to be there (setting up the arg for the
slowpath function):
      movl    $2048, %eax	# set spin count
      andl    $-2, %edx		# mask off SLOW_PATH_FLAG
      movzbl  %dl, %esi		# set up __ticket_lock_spinning arg

The unlock code is very straightforward:
	__ticket_unlock_release(lock);
	if (unlikely(__ticket_in_slowpath(lock)))
		__ticket_unlock_slowpath(lock);
which generates:
      addb $2, (%rdi)
      testb    $1, 1(%rdi)
      je       1f
      call     __ticket_unlock_slowpath
1:

which, while simple, is more complex than the simple "incb (%rdi)".
(I'm not sure whether its worth inlining this or not.)

Thoughts? Comments? Suggestions?

Thanks,
	J

Jeremy Fitzhardinge (12):
  x86/spinlocks: replace pv spinlocks with pv ticketlocks
  x86/ticketlock: collapse a layer of functions
  xen/pvticketlock: Xen implementation for PV ticket locks
  x86/pvticketlock: use callee-save for lock_spinning
  x86/ticketlocks: when paravirtualizing ticket locks, increment by 2
  x86/ticketlock: add slowpath logic
  x86/ticketlocks: tidy up __ticket_unlock_kick()
  xen/pvticketlock: disable interrupts while blocking
  x86/pvticketlocks: we only need to kick if there's waiters
  xen/pvticket: allow interrupts to be enabled while blocking
  x86/pvticketlock: make sure unlock_kick pvop call is inlined
  x86/pvticketlock: use __ticket_t for pvop args

Srivatsa Vaddagiri (1):
  x86/ticketlock: only do kick after doing unlock

 arch/x86/include/asm/paravirt.h       |   30 +---
 arch/x86/include/asm/paravirt_types.h |    8 +-
 arch/x86/include/asm/spinlock.h       |  118 ++++++++-----
 arch/x86/include/asm/spinlock_types.h |   16 ++-
 arch/x86/kernel/paravirt-spinlocks.c  |   40 +++--
 arch/x86/xen/spinlock.c               |  305 ++++++++-------------------------
 6 files changed, 186 insertions(+), 331 deletions(-)

-- 
1.7.6

