Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1IBBLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:11:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65455 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1IBBK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:10:56 -0400
From: Shan Hai <haishan.bai@gmail.com>
To: akpm@linux-foundation.org, tglx@linutronix.de
Cc: eric.dumazet@gmail.com, vapier@gentoo.org, asharma@fb.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Shan Hai <haishan.bai@gmail.com>
Subject: [PATCH V3 1/1] lib/atomic64 using raw_spin_lock_irq[save|resotre] for atomicity
Date: Fri,  2 Sep 2011 09:10:51 +0800
Message-Id: <1314925851-28163-2-git-send-email-haishan.bai@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314925851-28163-1-git-send-email-haishan.bai@gmail.com>
References: <1314925851-28163-1-git-send-email-haishan.bai@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use non sleeping raw_spin_lock_irq in atomic64 implementation, because its IRQ
safe, the sleeping spin_lock_irq is IRQ unsafe and causes deadlock shown below.

spin_lock_irq[save|restore] would cause the following OOPS on 2.6.34.9+rt

OOPS on 2.6.34.9+PREEMPT-RT:
------------[ cut here ]------------
kernel BUG at /build/linux/kernel/rtmutex.c:832!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT SMP NR_CPUS=8 LTT NESTING LEVEL : 0
P4080 DS
last sysfs file: /sys/devices/system/cpu/online
Modules linked in: ipv6(+) [last unloaded: scsi_wait_scan]
NIP: c068b218 LR: c068b1e0 CTR: 00000000
REGS: eb459ae0 TRAP: 0700   Tainted: G      D     (2.6.34.9-rt)
MSR: 00021002 <ME,CE>  CR: 28000488  XER: 00000000
TASK = ea43d3b0[968] 'perf' THREAD: eb458000 CPU: 0
GPR00: 00000001 eb459b90 ea43d3b0 00021002 00000000 00000000 00000000 00000001
GPR08: 00000001 ea43d3b0 c068b1e0 00000000 28000482 10092c4c 7fffffff 80000000
GPR16: eb459d40 eb459c68 00000001 c2fa2098 eb459ec0 eac5a8e8 eac5a900 c0906308
GPR24: c0906334 00000000 eb459b9c c090d0ec 00021002 c09062e0 c09062e0 eb459b90
NIP [c068b218] rt_spin_lock_slowlock+0x78/0x3a8
LR [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8
Call Trace:
[eb459b90] [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8 (unreliable)
[eb459c20] [c068bdb0] rt_spin_lock+0x40/0x98
[eb459c40] [c03d2a14] atomic64_read+0x48/0x84
[eb459c60] [c001aaf4] perf_event_interrupt+0xec/0x28c
[eb459d10] [c0010138] performance_monitor_exception+0x7c/0x150
[eb459d30] [c0014170] ret_from_except_full+0x0/0x4c
--- Exception: 2060 at lock_acquire+0x94/0x130
    LR = lock_acquire+0x8c/0x130
[eb459e30] [c068bdf0] rt_spin_lock+0x80/0x98
[eb459e50] [c03d2884] atomic64_add_return+0x50/0x98
[eb459e70] [c00ff888] T.902+0x150/0x4f8
[eb459eb0] [c00ffedc] sys_perf_event_open+0x2ac/0x508
[eb459f40] [c0013b6c] ret_from_syscall+0x0/0x4
--- Exception: c00 at 0xfa8abe4
    LR = 0x10016034

Signed-off-by: Shan Hai <haishan.bai@gmail.com>
---
 lib/atomic64.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/lib/atomic64.c b/lib/atomic64.c
index e12ae0d..82b3313 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -29,7 +29,7 @@
  * Ensure each lock is in a separate cacheline.
  */
 static union {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	char pad[L1_CACHE_BYTES];
 } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
 
@@ -48,9 +48,9 @@ long long atomic64_read(const atomic64_t *v)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_read);
@@ -60,9 +60,9 @@ void atomic64_set(atomic64_t *v, long long i)
 	unsigned long flags;
 	spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter = i;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_set);
 
@@ -71,9 +71,9 @@ void atomic64_add(long long a, atomic64_t *v)
 	unsigned long flags;
 	spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_add);
 
@@ -83,9 +83,9 @@ long long atomic64_add_return(long long a, atomic64_t *v)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_add_return);
@@ -95,9 +95,9 @@ void atomic64_sub(long long a, atomic64_t *v)
 	unsigned long flags;
 	spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_sub);
 
@@ -107,9 +107,9 @@ long long atomic64_sub_return(long long a, atomic64_t *v)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_sub_return);
@@ -120,11 +120,11 @@ long long atomic64_dec_if_positive(atomic64_t *v)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter - 1;
 	if (val >= 0)
 		v->counter = val;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_dec_if_positive);
@@ -135,11 +135,11 @@ long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
 	if (val == o)
 		v->counter = n;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_cmpxchg);
@@ -150,10 +150,10 @@ long long atomic64_xchg(atomic64_t *v, long long new)
 	spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
 	v->counter = new;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_xchg);
@@ -164,12 +164,12 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	spinlock_t *lock = lock_addr(v);
 	int ret = 0;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	if (v->counter != u) {
 		v->counter += a;
 		ret = 1;
 	}
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(atomic64_add_unless);
@@ -179,7 +179,7 @@ static int init_atomic64_lock(void)
 	int i;
 
 	for (i = 0; i < NR_LOCKS; ++i)
-		spin_lock_init(&atomic64_lock[i].lock);
+		raw_spin_lock_init(&atomic64_lock[i].lock);
 	return 0;
 }
 
-- 
1.7.4.1

