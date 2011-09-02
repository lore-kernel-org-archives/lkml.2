Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1IBW6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 18:58:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376Ab1IBW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 18:58:04 -0400
Date: Fri, 2 Sep 2011 15:57:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: tglx@linutronix.de, eric.dumazet@gmail.com, vapier@gentoo.org,
        asharma@fb.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V3 1/1] lib/atomic64 using
 raw_spin_lock_irq[save|resotre] for atomicity
Message-Id: <20110902155748.55b0dd1a.akpm@linux-foundation.org>
In-Reply-To: <1314925851-28163-2-git-send-email-haishan.bai@gmail.com>
References: <1314925851-28163-1-git-send-email-haishan.bai@gmail.com>
	<1314925851-28163-2-git-send-email-haishan.bai@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Sep 2011 09:10:51 +0800
Shan Hai <haishan.bai@gmail.com> wrote:

> Use non sleeping raw_spin_lock_irq in atomic64 implementation, because its IRQ
> safe, the sleeping spin_lock_irq is IRQ unsafe and causes deadlock shown below.
> 
> spin_lock_irq[save|restore] would cause the following OOPS on 2.6.34.9+rt

This changelog makes no sense.  I used this instead:

: The command 'perf top -e L1-dcache-loads' causes OOPS and hang up in the
: following configuration.
: 
: Powerpc e500 core
: OOPS on: 		2.6.34.9 PREEMPT-RT
: Whole system hangs up:	3.0.3 PREEMPT-RT
: 
: Listed the panic info. below. 
: 
: The cause of the problem is that the atomic64_add_return is interrupted by
: the performence counter interrupt, the interrupt handler calls
: atomic64_read, failed at /build/linux/kernel/rtmutex.c:832!  for the
: reason trying to hold the same lock twice in the same context.  
: 
: Replace the spin_lock_irq[save|restore] with
: raw_spin_lock_irq[save|restore] could guarantee the atomicity of
: atomic64_* because the raw variant of the spin lock disables interrupts
: during atomic64_* operations.
: 
: OOPS on 2.6.34.9+PREEMPT-RT:
: 
: kernel BUG at /build/linux/kernel/rtmutex.c:832!
: Oops: Exception in kernel mode, sig: 5 [#2]
: PREEMPT SMP NR_CPUS=8 LTT NESTING LEVEL : 0
: P4080 DS
: last sysfs file: /sys/devices/system/cpu/online
: Modules linked in: ipv6(+) [last unloaded: scsi_wait_scan]
: NIP: c068b218 LR: c068b1e0 CTR: 00000000
: REGS: eb459ae0 TRAP: 0700   Tainted: G      D     (2.6.34.9-rt)
: MSR: 00021002 <ME,CE>  CR: 28000488  XER: 00000000
: TASK = ea43d3b0[968] 'perf' THREAD: eb458000 CPU: 0
: GPR00: 00000001 eb459b90 ea43d3b0 00021002 00000000 00000000 00000000 00000001
: GPR08: 00000001 ea43d3b0 c068b1e0 00000000 28000482 10092c4c 7fffffff 80000000
: GPR16: eb459d40 eb459c68 00000001 c2fa2098 eb459ec0 eac5a8e8 eac5a900 c0906308
: GPR24: c0906334 00000000 eb459b9c c090d0ec 00021002 c09062e0 c09062e0 eb459b90
: NIP [c068b218] rt_spin_lock_slowlock+0x78/0x3a8
: LR [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8
: Call Trace:
: [eb459b90] [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8 (unreliable)
: [eb459c20] [c068bdb0] rt_spin_lock+0x40/0x98
: [eb459c40] [c03d2a14] atomic64_read+0x48/0x84
: [eb459c60] [c001aaf4] perf_event_interrupt+0xec/0x28c
: [eb459d10] [c0010138] performance_monitor_exception+0x7c/0x150
: [eb459d30] [c0014170] ret_from_except_full+0x0/0x4c

But I don't think the patch is applicable to mainline anyway, is it?


What's actually going on here?  A spin_lock_irq() which doesn't disable
interrupts sounds fairly moronic.  Is it the case that preempt-rt
converts interrupt code to thread context, so spin_lock_irq() only
needs to lock against other thread-context code?

If so, what's special about the ppc performance counter interrupt? 
Shouldn't that be covnerted to thread context as well?

If that isn't possible, does this mean that all locking/atomic code
which runs in the perf counter interrupt needs to be converted to use
raw_irq_foo()?

> @@ -29,7 +29,7 @@
>  * Ensure each lock is in a separate cacheline.
>  */
> static union {
> -	spinlock_t lock;
> +	raw_spinlock_t lock;
>  	char pad[L1_CACHE_BYTES];
>  } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;

There is no way on this little green earth that a reader of this code
will be able to work out that a raw_spinlock_t was used because of
something to do with ppc performance counter interrupts!

Therefore a code comment is needed.
