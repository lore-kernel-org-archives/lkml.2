Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab2CULPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:15:33 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:40502 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030821Ab2CULPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:15:30 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Date: Wed, 21 Mar 2012 15:50:41 +0530
Message-Id: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
x-cbid: 12032110-5816-0000-0000-000001D7C2E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Changes since last posting: (Raghavendra K T)
[
 - Rebased to linux-3.3-rc6.
 - used function+enum in place of macro (better type checking) 
 - use cmpxchg while resetting zero status for possible race
	[suggested by Dave Hansen for KVM patches ]
]

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
patch uses a locked add to do this, followed by a test to see if the
slowflag is set.  The lock prefix acts as a full memory barrier, so we
can be sure that other CPUs will have seen the unlock before we read
the flag (without the barrier the read could be fetched from the
store queue before it hits memory, which could result in a deadlock).

This is is all unnecessary complication if you're not using PV ticket
locks, it also uses the jump-label machinery to use the standard
"add"-based unlock in the non-PV case.

	if (TICKET_SLOWPATH_FLAG &&
	    unlikely(static_branch(&paravirt_ticketlocks_enabled))) {
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

Note that the patch series needs jumplabel split posted in
 https://lkml.org/lkml/2012/2/21/167 to avoid cyclic dependency
of headers (to use jump label machinary)

TODO: remove CONFIG_PARAVIRT_SPINLOCK when everybody convinced.

Results:
=======
machine
IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM

OS: enterprise linux 
Gcc  Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-languages=c,c++,objc,obj-c++,java,fortran,ada --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile --enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.4.5 20110214

base kernel = 3.3-rc6 (cloned sunday 4th march)
unit=tps (higher is better)
benchmak=pgbench based on pgsql 9.2-dev: 
	http://www.postgresql.org/ftp/snapshot/dev/ (link given by Attilo)

tool used to collect benachmark: git://git.postgresql.org/git/pgbench-tools.git
config is same as tools default except MAX_WORKER=8

Average taken over 10 iterations, analysed with ministat tool.

BASE  (CONFIG_PARAVIRT_SPINLOCK = n)
==========================================
	------ scale=1 (32MB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3718.4108     4182.7842     3855.1089      3914.535     196.91943
  2  	x  10     7462.1997     7921.4638     7855.1965     7808.1603     135.37891
  4  	x  10     21682.402     23445.941     22151.922     22224.329     507.32299
  8  	x  10     43309.638     48103.494      45332.24     45593.135     1496.3735
 16  	x  10     108624.95     109227.45     108997.96     108987.84     210.15136
 32  	x  10      112582.1     113170.42     112776.92     112830.09     202.70556
 64  	x  10     100576.34     104011.92     103299.89     103034.24     928.24581
	----------------
	------ scale=500 (16GB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3451.9407     3948.3127     3512.2215     3610.6086     201.58491
  2  	x  10     7311.1769     7383.2552     7341.0847     7342.2349     21.231902
  4  	x  10     19582.548      26909.72     24778.282     23893.162     2587.6103
  8  	x  10     52292.765     54561.472     53171.286     53216.256     733.16626
 16  	x  10     89643.138     90353.598     89970.878     90018.505     213.73589
 32  	x  10     81010.402      81556.02     81256.217     81247.223     174.31678
 64  	x  10     83855.565     85048.602     84087.693      84201.86     352.25182
	----------------

BASE + jumplabel_split + jeremy patch (CONFIG_PARAVIRT_SPINLOCK = n)
=====================================================
	------ scale=1 (32MB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3669.2156     4102.5109     3732.9526     3784.4072     129.14134
  2  	x  10      7423.984     7797.5046     7446.8946     7500.2076     119.85178
  4  	x  10     21332.859     26327.619     24175.239     24084.731     1841.8335
  8  	x  10     43149.937     49515.406     45779.204     45838.782     2191.6348
 16  	x  10     109512.27     110407.82     109977.15     110019.72     283.41371
 32  	x  10      112653.3     113156.22     113023.24     112973.56     151.54906
 64  	x  10     102816.08     104514.48     103843.95     103658.17     515.10115
	----------------
	------ scale=500 (16GB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3501.3548     3985.3114     3609.0236     3705.6665      224.3719
  2  	x  10      7275.246     9026.7466     7447.4013     7581.6494     512.75417
  4  	x  10     19506.151     22661.801     20843.142     21154.886     1329.5591
  8  	x  10     53150.178     55594.073     54132.383     54227.117     728.42913
 16  	x  10      84281.93     91234.692     90917.411     90249.053      2108.903
 32  	x  10     80860.018     81500.369     81212.514     81201.361     205.66759
 64  	x  10     84090.033      85423.79     84505.041     84588.913     436.69012
	----------------

BASE + jumplabel_split+ jeremy patch (CONFIG_PARAVIRT_SPINLOCK = y)
=====================================================
	------ scale=1 (32MB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3749.8427     4149.0224     4120.6696     3982.6575     197.32902
  2  	x  10     7786.4802     8149.0902     7956.6706     7970.5441      94.42967
  4  	x  10     22053.383     27424.414     23514.166     23698.775      1492.792
  8  	x  10     44585.203     48082.115     46123.156     46135.687     1232.9399
 16  	x  10     108290.15     109655.13        108924     108968.59     476.48336
 32  	x  10     112359.02     112966.97     112570.06     112611.48     180.51304
 64  	x  10     103020.85     104042.71     103457.83     103496.84     291.19165
	----------------
	------ scale=500 (16GB shared buf) ----------
Client	    N           Min           Max        Median           Avg        Stddev
  1  	x  10     3462.6179     3898.5392     3871.6231     3738.0069     196.86077
  2  	x  10     7358.8148     7396.1029     7387.8169      7382.229     13.117357
  4  	x  10     19734.357     27799.895      21840.41     22964.202     3070.8067
  8  	x  10      52412.64     55214.305     53481.185     53552.261     878.21383
 16  	x  10     89862.081     90375.328     90161.886     90139.154     202.49282
 32  	x  10     80140.853     80898.452     80683.819     80671.361     227.13277
 64  	x  10     83402.864     84868.355     84311.472     84281.567      428.6501
	----------------
		
Summary of Avg
==============

Client  BASE         Base+patch               base+patch
	PARAVIRT=n   PARAVIRT=n (%improve)    PARAVIRT=y (%improve)
------ scale=1 (32MB shared buf) ----------
1	3914.535     3784.4072 (-3.32422)      3982.6575 (+1.74025)
2	7808.1603    7500.2076 (-3.94399)      7970.5441 (+2.07967)
4	22224.329    24084.731 (+8.37102)     23698.775  (+6.63438)
8	45593.135    45838.782 (+0.538781)    46135.687  (+1.18999)
16	108987.84    110019.72 (+0.946785)    108968.59  (-0.0176625)
32	112830.09    112973.56 (+0.127156)    112611.48  (-0.193752)
64	103034.24    103658.17 (+0.605556)    103496.84  (+0.448977)

------ scale=500 (~16GB shared buf) ----------
1	3610.6086    3705.6665 (+2.63274)     3738.0069  (+3.52844)
2	7342.2349    7581.6494 (+3.26079)     7382.229   (+0.544713)
4	23893.162    21154.886 (-11.4605)     22964.202  (-3.88797)
8	53216.256    54227.117 (+1.89953)     53552.261  (+0.631395)
16	90018.505    90249.053 (+0.256112)    90139.154  (+0.134027)
32	81247.223    81201.361 (-0.0564475)    80671.361 (-0.708777)
64	84201.86     84588.913 (+0.459673)    84281.567  (+0.0946618)

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
---
 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/paravirt.h       |   32 +---
 arch/x86/include/asm/paravirt_types.h |   10 +-
 arch/x86/include/asm/spinlock.h       |  128 ++++++++----
 arch/x86/include/asm/spinlock_types.h |   16 +-
 arch/x86/kernel/paravirt-spinlocks.c  |   18 +--
 arch/x86/xen/smp.c                    |    3 +-
 arch/x86/xen/spinlock.c               |  383 +++++++++++----------------------
 kernel/Kconfig.locks                  |    2 +-
 9 files changed, 245 insertions(+), 350 deletions(-)

