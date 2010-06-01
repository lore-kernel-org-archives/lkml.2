Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0FAJfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0FAJfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:35:43 -0400
Date: Tue, 1 Jun 2010 12:35:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, hpa@zytor.com, mingo@elte.hu,
       npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100601093515.GH24302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ticket lock spinlock ensures fairness by introducing FIFO of cpus waiting
for spinlock to be released. This works great on real HW, but when running
on hypervisor it introduce very heavy performance hit if physical cpus
are overcommitted (up to 35% in my test). The reason for performance
hit is that vcpu that at the head of the FIFO can be unscheduled and no
other vcpu waiting on the lock can proceed.  This result in a big time
gaps where no vcpu is in critical section. Even worse they are constantly
spinning and not allowing vcpu at the head of the FIFO to be scheduled
to run.

The patch below allows to patch ticket spinlock code to behave similar to
old unfair spinlock when hypervisor is detected. After patching unlocked
condition remains the same (next == owner), but if vcpu detects that lock
is already taken it spins till (next == owner == 0) and when the condition
is met it tries to reacquire the lock. Unlock simply zeroes head and tail.
Trylock state the same since unlocked condition stays the same.

I ran two guest with 16 vcpus each one. One guest with this patch another
without. Inside those guests I ran kernel compilation "time make -j 16 all".
Here are results of two runs:

patched:                        unpatched:
real 13m34.674s                 real 19m35.827s
user 96m2.638s                  user 102m38.665s
sys 56m14.991s                  sys 158m22.470s

real 13m3.768s                  real 19m4.375s
user 95m34.509s                 user 111m9.903s
sys 53m40.550s                  sys 141m59.370s

Note that for 6 minutes unpatched guest ran without cpu oversubscription
since patched guest was already idle.

Running kernbench on the host with and without the patch:

Unpatched:                                            Patched:
Average Half load -j 8 Run (std deviation):
Elapsed Time 312.538 (0.779404)                       Elapsed Time 311.974 (0.258031)
User Time 2154.89 (6.62261)                           User Time 2151.94 (1.96702)
System Time 233.78 (1.96642)                          System Time 236.472 (0.695572)
Percent CPU 763.8 (1.64317)                           Percent CPU 765 (0.707107)
Context Switches 39348.2 (1542.87)                    Context Switches 41522.4 (1193.13)
Sleeps 871688 (5596.52)                               Sleeps 877317 (1135.83)

Average Optimal load -j 16 Run (std deviation):
Elapsed Time 259.878 (0.444826)                       Elapsed Time 258.842 (0.413122)
User Time 2549.22 (415.685)                           User Time 2538.42 (407.383)
System Time 261.084 (28.8145)                         System Time 263.847 (28.8638)
Percent CPU 1003.4 (252.566)                          Percent CPU 1003.5 (251.407)
Context Switches 228418 (199308)                      Context Switches 228894 (197533)
Sleeps 898721 (28757.2)                               Sleeps 902020 (26074.5)

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..b919b54 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -60,19 +60,27 @@
 
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	short inc = 0x0100;
+	short inc;
 
 	asm volatile (
+		"1:\t\n"
+		"mov $0x100, %0\n\t"
 		LOCK_PREFIX "xaddw %w0, %1\n"
-		"1:\t"
+		"2:\t"
 		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
+		"je 4f\n\t"
+		"3:\t\n"
 		"rep ; nop\n\t"
-		"movb %1, %b0\n\t"
 		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
+		ALTERNATIVE(
+		"movb %1, %b0\n\t"
+		"jmp 2b\n",
+		"nop", X86_FEATURE_HYPERVISOR)"\n\t"
+		"cmpw $0, %1\n\t"
+		"jne 3b\n\t"
+		"jmp 1b\n\t"
+		"4:"
+		: "=Q" (inc), "+m" (lock->slock)
 		:
 		: "memory", "cc");
 }
@@ -98,10 +106,13 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	asm volatile(
+		ALTERNATIVE(UNLOCK_LOCK_PREFIX "incb (%0);"ASM_NOP3,
+			    UNLOCK_LOCK_PREFIX "movw $0, (%0)",
+			    X86_FEATURE_HYPERVISOR)
+		:
+		: "Q" (&lock->slock)
+		: "memory", "cc");
 }
 #else
 #define TICKET_SHIFT 16
--
			Gleb.
