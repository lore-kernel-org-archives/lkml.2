Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3ACFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3ACFZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:25:52 -0500
Date: Thu, 3 Jan 2013 00:24:44 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Subject: [RFC PATCH 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
Message-ID: <20130103002444.113f4950@annuminas.surriel.com>
In-Reply-To: <20130103001536.7fd1e952@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Eric Dumazet found a regression with the spinlock backoff code,
in workloads where multiple spinlocks were contended, each having
a different wait time.

This patch has multiple delay values per cpu, indexed on a hash
of the lock address, to avoid that problem.

Eric Dumazet wrote:

I did some tests with your patches with following configuration :

tc qdisc add dev eth0 root htb r2q 1000 default 3
(to force a contention on qdisc lock, even with a multi queue net
device)

and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"

Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
(24 threads), and a fast NIC (10Gbps)

Resulting in a 13 % regression (676 Mbits -> 595 Mbits)

In this workload we have at least two contended spinlocks, with
different delays. (spinlocks are not held for the same duration)

It clearly defeats your assumption of a single per cpu delay being OK :
Some cpus are spinning too long while the lock was released.

We might try to use a hash on lock address, and an array of 16 different
delays so that different spinlocks have a chance of not sharing the same
delay.

With following patch, I get 982 Mbits/s with same bench, so an increase
of 45 % instead of a 13 % regression.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/kernel/smp.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 6065291..29360c4 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/hash.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -135,12 +136,26 @@ static bool smp_no_nmi_ipi = false;
  */
 #define MIN_SPINLOCK_DELAY 1
 #define MAX_SPINLOCK_DELAY 16000
-DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
+#define DELAY_HASH_SHIFT 6
+struct delay_entry {
+	u32 hash;
+	u32 delay;
+};
+static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay) = {
+	[0 ... (1 << DELAY_HASH_SHIFT) - 1] = {
+		.hash = 0,
+		.delay = MIN_SPINLOCK_DELAY,
+	},
+};
+
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
 	__ticket_t waiters_ahead;
-	int delay = __this_cpu_read(spinlock_delay);
+	u32 hash = hash32_ptr(lock);
+	u32 slot = hash_32(hash, DELAY_HASH_SHIFT);
+	struct delay_entry *ent = &__get_cpu_var(spinlock_delay[slot]);
+	u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;
 	unsigned loops;
 
 	for (;;) {
@@ -178,7 +193,8 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 			break;
 		}
 	}
-	__this_cpu_write(spinlock_delay, delay);
+	ent->hash = hash;
+	ent->delay = delay;
 }
 
 /*
