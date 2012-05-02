Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2EBKMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:12:54 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33301 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2EBKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:07:04 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 15:36:10 +0530
Message-Id: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
x-cbid: 12050123-1618-0000-0000-00000172F7C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series replaces the existing paravirtualized spinlock mechanism
with a paravirtualized ticketlock mechanism. The series provides
implementation for both Xen and KVM.(targeted for 3.5 window)

Note: This needs debugfs changes patch that should be in Xen / linux-next
   https://lkml.org/lkml/2012/3/30/687

Changes in V8:
 - Reabsed patches to 3.4-rc4
 - Combined the KVM changes with ticketlock + Xen changes (Ingo)
 - Removed CAP_PV_UNHALT since it is redundant (Avi). But note that we
    need newer qemu which uses KVM_GET_SUPPORTED_CPUID ioctl.
 - Rewrite GET_MP_STATE condition (Avi)
 - Make pv_unhalt = bool (Avi)
 - Move out reset pv_unhalt code to vcpu_run from vcpu_block (Gleb)
 - Documentation changes (Rob Landley)
 - Have a printk to recognize that paravirt spinlock is enabled (Nikunj)
 - Move out kick hypercall out of CONFIG_PARAVIRT_SPINLOCK now
   so that it can be used for other optimizations such as 
   flush_tlb_ipi_others etc. (Nikunj)

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

For KVM, one hypercall is introduced in hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.

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

TODO: 1) Remove CONFIG_PARAVIRT_SPINLOCK ?
      2) Experiments on further optimization possibilities. (discussed in V6)
      3) Use kvm_irq_delivery_to_apic() in kvm hypercall (suggested by Gleb)
      4) Any cleanups for e.g. Xen/KVM common code for debugfs.

PS: TODOs are no blockers for the current series merge.

Results:
=======
various form of results based on V6 of the patch series are posted in following links
 
 https://lkml.org/lkml/2012/3/21/161
 https://lkml.org/lkml/2012/3/21/198

 kvm results:
 https://lkml.org/lkml/2012/3/23/50
 https://lkml.org/lkml/2012/4/5/73

Benchmarking on the current set of patches will be posted soon.

Thoughts? Comments? Suggestions?. It  would be nice to see
Acked-by/Reviewed-by/Tested-by for the patch series.
 
Jeremy Fitzhardinge (9):
  x86/spinlock: Replace pv spinlocks with pv ticketlocks
  x86/ticketlock: Collapse a layer of functions
  xen: Defer spinlock setup until boot CPU setup
  xen/pvticketlock: Xen implementation for PV ticket locks
  xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv
    ticketlocks
  x86/pvticketlock: Use callee-save for lock_spinning
  x86/pvticketlock: When paravirtualizing ticket locks, increment by 2
  x86/ticketlock: Add slowpath logic
  xen/pvticketlock: Allow interrupts to be enabled while blocking

Srivatsa Vaddagiri (3): 
  Add a hypercall to KVM hypervisor to support pv-ticketlocks
  Added configuration support to enable debug information for KVM Guests
  Paravirtual ticketlock support for linux guests running on KVM hypervisor

Raghavendra K T (3):
  x86/ticketlock: Don't inline _spin_unlock when using paravirt
    spinlocks
  Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
  Add documentation on Hypercalls and features used for PV spinlock

Andrew Jones (1):
  Split out rate limiting from jump_label.h

Stefano Stabellini (1):
 xen: Enable PV ticketlocks on HVM Xen
---
PS: Had to trim down recipient list because, LKML archive does not support
list > 20. Though many more people should have been in To/CC list.

Ticketlock links:
V7 : https://lkml.org/lkml/2012/4/19/335 
V6 : https://lkml.org/lkml/2012/3/21/161

KVM patch links:
 V6: https://lkml.org/lkml/2012/4/23/123

 V5 kernel changes:
 https://lkml.org/lkml/2012/3/23/50
 Qemu changes for V5:
 http://lists.gnu.org/archive/html/qemu-devel/2012-03/msg04455.html 

 V4 kernel changes:
 https://lkml.org/lkml/2012/1/14/66
 Qemu changes for V4:
 http://www.mail-archive.com/kvm@vger.kernel.org/msg66450.html

 V3 kernel Changes:
 https://lkml.org/lkml/2011/11/30/62
 Qemu patch for V3:
 http://lists.gnu.org/archive/html/qemu-devel/2011-12/msg00397.html

 V2 kernel changes : 
 https://lkml.org/lkml/2011/10/23/207

 Previous discussions : (posted by Srivatsa V).
 https://lkml.org/lkml/2010/7/26/24
 https://lkml.org/lkml/2011/1/19/212

Ticketlock change history:
Changes in V7:
 - Reabsed patches to 3.4-rc3
 - Added jumplabel split patch (originally from Andrew Jones rebased to
    3.4-rc3
 - jumplabel changes from Ingo and Jason taken and now using static_key_*
    instead of static_branch.
 - using UNINLINE_SPIN_UNLOCK (which was splitted as per suggestion from Linus)
 - This patch series is rebased on debugfs patch (that sould be already in
    Xen/linux-next https://lkml.org/lkml/2012/3/23/51)

Changes in V6 posting: (Raghavendra K T)
 - Rebased to linux-3.3-rc6.
 - used function+enum in place of macro (better type checking) 
 - use cmpxchg while resetting zero status for possible race
	[suggested by Dave Hansen for KVM patches ]

KVM patch Change history:
Changes in V6:
- Rebased to 3.4-rc3
- Removed debugfs changes patch which should now be in Xen/linux-next.
  (https://lkml.org/lkml/2012/3/30/687)
- Removed PV_UNHALT_MSR since currently we don't need guest communication,
  and made pv_unhalt folded to GET_MP_STATE (Marcello, Avi[long back])
- Take jumplabel changes from Ingo/Jason into use (static_key_slow_inc usage)
- Added inline to spinlock_init in non PARAVIRT case
- Move arch specific code to arch/x86 and add stubs to other archs (Marcello)
- Added more comments on pv_unhalt usage etc (Marcello)

Changes in V5:
- rebased to 3.3-rc6
- added PV_UNHALT_MSR that would help in live migration (Avi)
- removed PV_LOCK_KICK vcpu request and pv_unhalt flag (re)added.
- Changed hypercall documentaion (Alex).
- mode_t changed to umode_t in debugfs.
- MSR related documentation added.
- rename PV_LOCK_KICK to PV_UNHALT. 
- host and guest patches not mixed. (Marcelo, Alex)
- kvm_kick_cpu now takes cpu so it can be used by flush_tlb_ipi_other 
   paravirtualization (Nikunj)
- coding style changes in variable declarion etc (Srikar)

Changes in V4:
- reabsed to 3.2.0 pre.
- use APIC ID for kicking the vcpu and use kvm_apic_match_dest for matching (Avi)
- fold vcpu->kicked flag into vcpu->requests (KVM_REQ_PVLOCK_KICK) and related 
  changes for UNHALT path to make pv ticket spinlock migration friendly(Avi, Marcello)
- Added Documentation for CPUID, Hypercall (KVM_HC_KICK_CPU)
  and capabilty (KVM_CAP_PVLOCK_KICK) (Avi)
- Remove unneeded kvm_arch_vcpu_ioctl_set_mpstate call. (Marcello)
- cumulative variable type changed (int ==> u32) in add_stat (Konrad)
- remove unneeded kvm_guest_init for !CONFIG_KVM_GUEST case

Changes in V3:
- rebased to 3.2-rc1
- use halt() instead of wait for kick hypercall.
- modify kick hyper call to do wakeup halted vcpu.
- hook kvm_spinlock_init to smp_prepare_cpus call (moved the call out of head##.c).
- fix the potential race when zero_stat is read.
- export debugfs_create_32 and add documentation to API.
- use static inline and enum instead of ADDSTAT macro. 
- add  barrier() in after setting kick_vcpu.
- empty static inline function for kvm_spinlock_init.
- combine the patches one and two readuce overhead.
- make KVM_DEBUGFS depends on DEBUGFS.
- include debugfs header unconditionally.

Changes in V2:
- rebased patchesto -rc9
- synchronization related changes based on Jeremy's changes 
 (Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>) pointed by 
 Stephan Diestelhorst <stephan.diestelhorst@amd.com>
- enabling 32 bit guests
- splitted patches into two more chunks

 Documentation/virtual/kvm/cpuid.txt      |    4 +
 Documentation/virtual/kvm/hypercalls.txt |   60 +++++
 arch/x86/Kconfig                         |   10 +
 arch/x86/include/asm/kvm_host.h          |    4 +
 arch/x86/include/asm/kvm_para.h          |   16 +-
 arch/x86/include/asm/paravirt.h          |   32 +--
 arch/x86/include/asm/paravirt_types.h    |   10 +-
 arch/x86/include/asm/spinlock.h          |  128 +++++++----
 arch/x86/include/asm/spinlock_types.h    |   16 +-
 arch/x86/kernel/kvm.c                    |  256 ++++++++++++++++++++
 arch/x86/kernel/paravirt-spinlocks.c     |   18 +-
 arch/x86/kvm/cpuid.c                     |    3 +-
 arch/x86/kvm/x86.c                       |   44 ++++-
 arch/x86/xen/smp.c                       |    3 +-
 arch/x86/xen/spinlock.c                  |  387 ++++++++++--------------------
 include/linux/jump_label.h               |   26 +--
 include/linux/jump_label_ratelimit.h     |   34 +++
 include/linux/kvm_para.h                 |    1 +
 include/linux/perf_event.h               |    1 +
 kernel/jump_label.c                      |    1 +
 20 files changed, 673 insertions(+), 381 deletions(-)

