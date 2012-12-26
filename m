Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2LZTKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 14:10:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40952 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2LZTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 14:10:11 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <50D52E0C.6000103@redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org>  <50D52E0C.6000103@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Dec 2012 11:10:08 -0800
Message-ID: <1356549008.20133.20856.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 22:50 -0500, Rik van Riel wrote:

> I will try to run this test on a really large SMP system
> in the lab during the break.
> 
> Ideally, the auto-tuning will keep the delay value large
> enough that performance will stay flat even when there are
> 100 CPUs contending over the same lock.
> 
> Maybe it turns out that the maximum allowed delay value
> needs to be larger.  Only one way to find out...
> 

Hi Rik

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

 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..59f98f6 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/hash.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -113,6 +114,55 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
 /*
+ * Wait on a congested ticket spinlock.
+ */
+#define MIN_SPINLOCK_DELAY 1
+#define MAX_SPINLOCK_DELAY 1000
+#define DELAY_HASH_SHIFT 4
+DEFINE_PER_CPU(int [1 << DELAY_HASH_SHIFT], spinlock_delay) = { 
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
+};
+void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
+{
+	unsigned int slot = hash_32((u32)(unsigned long)lock, DELAY_HASH_SHIFT);
+	int delay = __this_cpu_read(spinlock_delay[slot]);
+
+	for (;;) {
+		int loops = delay * (__ticket_t)(inc.tail - inc.head);
+
+		while (loops--)
+			cpu_relax();
+
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+
+		if (inc.head == inc.tail) {
+			/* Decrease the delay, since we may have overslept. */
+			if (delay > MIN_SPINLOCK_DELAY)
+				delay--;
+			break;
+		}
+
+		/*
+		 * The lock is still busy, the delay was not long enough.
+		 * Going through here 2.7 times will, on average, cancel
+		 * out the decrement above. Using a non-integer number
+		 * gets rid of performance artifacts and reduces oversleeping.
+		 */
+		if (delay < MAX_SPINLOCK_DELAY &&
+		    (!(inc.head & 3) == 0 || (inc.head & 7) == 1))
+			delay++;
+	}
+	__this_cpu_write(spinlock_delay[slot], delay);
+}
+
+/*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...


