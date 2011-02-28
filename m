Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1CATmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:42:46 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab1CAThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:18 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYbNA010298@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 13:21:52 -0500
Subject: [PATCH] arch/tile: fix __ndelay etc to work better
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:37.0654 (UTC) FILETIME=[B3888F60:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementations of __ndelay and __udelay call a hypervisor
service to delay, but the hypervisor service isn't actually implemented
very well, and the consensus is that Linux should handle figuring this
out natively and not use a hypervisor service.

By converting nanoseconds to cycles, and then spinning until the
cycle counter reaches the desired cycle, we get several benefits:
first, we are sensitive to the actual clock speed; second, we use
less power by issuing a slow SPR read once every six cycles while
we delay; and third, we properly handle the case of an interrupt by
exiting at the target time rather than after some number of cycles.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/timex.h     |    3 +++
 arch/tile/include/hv/hypervisor.h |    5 +++++
 arch/tile/kernel/entry.S          |    6 ------
 arch/tile/kernel/time.c           |   10 ++++++++++
 arch/tile/lib/delay.c             |   21 ++++++++++++++++-----
 5 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
index 3baf5fc..29921f0 100644
--- a/arch/tile/include/asm/timex.h
+++ b/arch/tile/include/asm/timex.h
@@ -38,6 +38,9 @@ static inline cycles_t get_cycles(void)
 
 cycles_t get_clock_rate(void);
 
+/* Convert nanoseconds to core clock cycles. */
+cycles_t ns2cycles(unsigned long nsecs);
+
 /* Called at cpu initialization to set some low-level constants. */
 void setup_clock(void);
 
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index f672544..103986b 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -964,6 +964,11 @@ HV_ASIDRange hv_inquire_asid(int idx);
 
 /** Waits for at least the specified number of nanoseconds then returns.
  *
+ * NOTE: this deprecated function currently assumes a 750 MHz clock,
+ * and is thus not generally suitable for use.  New code should call
+ * hv_sysconf(HV_SYSCONF_CPU_SPEED), compute a cycle count to wait for,
+ * and delay by looping while checking the cycle counter SPR.
+ *
  * @param nanosecs The number of nanoseconds to sleep.
  */
 void hv_nanosleep(int nanosecs);
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index fd8dc42..c3aa067 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -38,12 +38,6 @@ STD_ENTRY(kernel_execve)
 	jrp lr
 	STD_ENDPROC(kernel_execve)
 
-/* Delay a fixed number of cycles. */
-STD_ENTRY(__delay)
-	{ addi r0, r0, -1; bnzt r0, . }
-	jrp lr
-	STD_ENDPROC(__delay)
-
 /*
  * We don't run this function directly, but instead copy it to a page
  * we map into every user process.  See vdso_setup().
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index f2e156e..49a605b 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -224,3 +224,13 @@ int setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
 }
+
+/*
+ * Use the tile timer to convert nsecs to core clock cycles, relying
+ * on it having the same frequency as SPR_CYCLE.
+ */
+cycles_t ns2cycles(unsigned long nsecs)
+{
+	struct clock_event_device *dev = &__get_cpu_var(tile_timer);
+	return ((u64)nsecs * dev->mult) >> dev->shift;
+}
diff --git a/arch/tile/lib/delay.c b/arch/tile/lib/delay.c
index 5801b03..cdacdd1 100644
--- a/arch/tile/lib/delay.c
+++ b/arch/tile/lib/delay.c
@@ -15,20 +15,31 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/thread_info.h>
-#include <asm/fixmap.h>
-#include <hv/hypervisor.h>
+#include <asm/timex.h>
 
 void __udelay(unsigned long usecs)
 {
-	hv_nanosleep(usecs * 1000);
+	if (usecs > ULONG_MAX / 1000) {
+		WARN_ON_ONCE(usecs > ULONG_MAX / 1000);
+		usecs = ULONG_MAX / 1000;
+	}
+	__ndelay(usecs * 1000);
 }
 EXPORT_SYMBOL(__udelay);
 
 void __ndelay(unsigned long nsecs)
 {
-	hv_nanosleep(nsecs);
+	cycles_t target = get_cycles();
+	target += ns2cycles(nsecs);
+	while (get_cycles() < target)
+		cpu_relax();
 }
 EXPORT_SYMBOL(__ndelay);
 
-/* FIXME: should be declared in a header somewhere. */
+void __delay(unsigned long cycles)
+{
+	cycles_t target = get_cycles() + cycles;
+	while (get_cycles() < target)
+		cpu_relax();
+}
 EXPORT_SYMBOL(__delay);
-- 
1.6.5.2

