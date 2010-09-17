Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0IQSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:16:59 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47796 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619Ab0IQSQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:16:58 -0400
Date: Fri, 17 Sep 2010 13:16:56 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2] x86, UV: Improve access time to RTC clock in node
	controller
Message-ID: <20100917181655.GA15767@sgi.com>
References: <20100909193613.GA6062@sgi.com> <20100910065930.GE31090@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910065930.GE31090@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV has a globally synchronized clock (UV RTC) that is located in the node
controller chip of each blade. Although any cpu can access it's own RTC
without making offnode references, access to a register in the node
controller still requires a few hundred nsec.  This is problematic for
some workloads.

This patch changes the clock code so that the RTC value is calculated
based on the in-core TSC clock. Access to the TSC is much faster than
access to the RTC. The UV RTC access function is improved:
    OLD: 292 nsec
    NEW:  18 nsec

Periodically, a pair of TSC/RTC values is read. New requests to read the
RTC will read the current TSC, then calculate an RTC value
based on the TSC delta from the last sync point and the ratio of TSC to
RTC frequencies.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>

---

V2 - Minor cleanup + updates/fixes suggested by Ingo:
	- add __read_mostly to seldom used static vars
	- moved cmpxchg128 & read128() to asm/cmpxchg_64.h
	- use of rdtsc_barrier()
	- deleted some debug code
	- refactored large functions into more readible sized functions






 arch/x86/include/asm/cmpxchg_64.h |   37 +++
 arch/x86/include/asm/timer.h      |    7 
 arch/x86/kernel/uv_time.c         |  468 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 490 insertions(+), 22 deletions(-)

Index: linux/arch/x86/include/asm/cmpxchg_64.h
===================================================================
--- linux.orig/arch/x86/include/asm/cmpxchg_64.h	2010-09-17 12:06:22.000000000 -0500
+++ linux/arch/x86/include/asm/cmpxchg_64.h	2010-09-17 13:00:39.585020327 -0500
@@ -151,4 +151,41 @@ extern void __cmpxchg_wrong_size(void);
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
+/*
+ * Atomic cmpxchg of a 128-bit value (pair of DW)
+ */
+static inline int cmpxchg128(void *p, unsigned long oldhi, unsigned long oldlo,
+			unsigned long newhi, unsigned long newlo)
+{
+	unsigned char ret;
+
+	asm volatile(   "lock; cmpxchg16b (%1)\n\t"
+			"sete %0\n\t"
+			: "=qm" (ret)
+			: "r"(p), "d"(oldhi), "a"(oldlo), "c"(newhi), "b"(newlo)
+			: "memory", "cc");
+	return ret;
+}
+
+
+/*
+ * Atomic read of 128 bit value (pair of DW)
+ */
+static inline void read128(unsigned long *wd,
+				unsigned long *hi, unsigned long *lo)
+{
+	unsigned long t0, t1, t0x;
+
+	do {
+		barrier();
+		t0 = wd[0];
+		barrier();
+		t1 = wd[1];
+		barrier();
+		t0x = wd[0];
+	} while (t0 != t0x);
+	*hi = t1;
+	*lo = t0;
+}
+
 #endif /* _ASM_X86_CMPXCHG_64_H */
Index: linux/arch/x86/include/asm/timer.h
===================================================================
--- linux.orig/arch/x86/include/asm/timer.h	2010-09-17 12:06:22.000000000 -0500
+++ linux/arch/x86/include/asm/timer.h	2010-09-17 13:00:39.596735346 -0500
@@ -65,4 +65,11 @@ static inline unsigned long long cycles_
 	return ns;
 }
 
+static inline unsigned long long ns_2_cycles(unsigned long ns, int cpu)
+{
+	unsigned long long cyc;
+	cyc = (ns << CYC2NS_SCALE_FACTOR) / (per_cpu(cyc2ns, cpu));
+	return cyc;
+}
+
 #endif /* _ASM_X86_TIMER_H */
Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2010-09-17 13:00:19.000000000 -0500
+++ linux/arch/x86/kernel/uv_time.c	2010-09-17 13:01:21.571867066 -0500
@@ -15,12 +15,13 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2009-2010 Silicon Graphics, Inc.  All Rights Reserved.
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
 #include <linux/slab.h>
-
+#include <linux/sysfs.h>
+#include <asm/timer.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
@@ -29,8 +30,135 @@
 #include <asm/cpu.h>
 
 #define RTC_NAME		"sgi_rtc"
+#define RTC_NAME_CALC		"sgi_rtc_calc"
+
+/*
+ * On UV, the latency to read the hardware RTC clock is ~300 nsec.
+ * Numerous workloads show this to be a performance issue.
+ *
+ * The following code changes the RTC access code to read the TSC
+ * instead of the RTC. Based on the current TSC and the ratio
+ * of TSC to RTC frequency, the code calculates the RTC value.
+ *
+ * The following are the requirements for the algorithms that
+ * calculate the RTC value:
+ *	- a cpu will never see it's own RTC value go backward
+ *	- the error in the calculation of the RTC value must be
+ *	  less than the time required to bounce a cacheline between
+ *	  cpus. For example cpu A must not be allowed to
+ *		- read a RTC value
+ *		- write it to memory
+ *		- have cpu B read A's RTC value
+ *		- cpu B read it's own RTC value
+ *		- B's RTC is less than A's
+ *	  Or saying this another way, no pair of cpus can
+ *	  perceive time to go backward.
+ *
+ * Assumptions:
+ *	- RTCs are synchronized across all blades. Any cpu reading
+ *	  it's own RTC will see the same value.
+ *	- TSCs on a blade are synchronized
+ *	- TSCs on different blades are NOT synchronized
+ *	- TSCs on different blades may run at different frequencies
+ *	  (UV supports SSIs with mixed processor types & running
+ *	  at different core frequencies)
+ *	- clock frequencies of TSC vs RTC may drift but at a
+ *	  slow rate. No significant change over a period of a
+ *	  few 10's of seconds.
+ *	- don't do divide instructions in the critical path
+ *
+ * Tables:
+ *
+ *      RTC Blade Control (RBC) - Per blade tables allocated blade local
+ *                      (2 processor sockets on each blade)
+ *
+ *               +-----------+                  +-----------+
+ *               '    RBC    '                  '   RBC     '
+ *               '           '                  '           '
+ *               +-----------+                  +-----------+
+ *                ^    ^   ^                     ^    ^    ^
+ *               /     |    \                   /     |     \
+ *              /      |     \                 /      |      \
+ *             /       |      \               /       |       \
+ *        +-----+   +------  -------      +-----+   +-----+   +-----+
+ *        ' RCC '   ' RCC '  ' RCC '      ' RCC '   ' RCC '   ' RCC '
+ *        +-----+   +-----+  +-----+      +-----+   +-----+   +-----+
+ *
+ *      RTC Cpu Control (RCC) - Per-cpu tables allocated socket-local
+ *
+ *
+ *   RBC contain per-blade state:
+ *	- recent RTC/TSC pair. Current RTC value is
+ *	  calculated by reading the live TSC, then calculating
+ *	  the current RTC value based on the TSC delta.
+ *	- fixed-point (32.32) multiplier:
+ *		rtc_delta = (tsc delta) * fixmult
+ *	- RTC/TSC pair for time when fixmult was last calculated
+ *	- TSC intervals for resyncing the recent RTC/TSC pair
+ *	  or for recalculating the fixmult multiplier
+ *
+ *   RCC contain per-cpu state for estimating the RTC value
+ *	- pointer to the RBC structure for all cpus on the blade
+ *	- last_rtc_value returned on this cpu. This is used to
+ *	  make sure time never goes backward.
+ *
+ *  Implementation Notes:
+ *	- I tried making the RBC table a per-socket table instead of a
+ *	  per-blade table. That did not work & a pair of cpus could see
+ *	  time go backward. Cachelines bounce between sockets faster
+ *	  than the the accuracy of the RTC calculation.
+ *	- the most critical inter-cpu timing is for passing RTC
+ *	  values between HT threads in the same core. Other inter-cpu
+ *	  times are much larger.
+ */
+
+/*
+ * The following structures are used to manage the per-node UV RTC
+ * structures used to calculate RTC values from the local RTC. Access
+ * to the local TSC is much faster than a RTC access.
+ *
+ */
+
+/* Maximum attempts to read a TSC/RTC pair before giving up */
+#define MAXREADS	 			10
+
+/* Maximum TSC nsec to read a TSC/RTC pair. Try again if exceeded. */
+#define DEFAULT_MAX_READCLOCKS_TSC_NSEC		10000
+
+/* Reread a TSC/RTC pair if it is older than the following. */
+#define DEFAULT_RESYNC_CLOCKS_MSEC		2000
+
+/* Recalculate fixmult if it is older than the following. */
+#define DEFAULT_RECALC_DRIFT_MSEC		20000
+
+ /* The following are almost never referenced */
+static long resync_clocks_msec __read_mostly = DEFAULT_RESYNC_CLOCKS_MSEC;
+static long recalc_drift_msec __read_mostly = DEFAULT_RECALC_DRIFT_MSEC;
+static long max_readclocks_tsc_nsec __read_mostly = DEFAULT_MAX_READCLOCKS_TSC_NSEC;
+
+static atomic_t resync_clocks_failures;
+
+struct uv_rtc_blade_control {
+	unsigned long			rtc0;
+	unsigned long			tsc0;
+	unsigned long			rtc0m;
+	unsigned long			tsc0m;
+	unsigned long			fixmult;
+};
+
+struct uv_rtc_cpu_control {
+	struct uv_rtc_blade_control	*rbc;
+	unsigned long			*myrtcp;
+	unsigned long			last_rtc_value;
+	unsigned long			max_readclocks_tsc_delta;
+	unsigned long			max_tsc_delta;
+	unsigned long			recalc_drift_tsc_delta;
+};
+
+static DEFINE_PER_CPU(struct uv_rtc_cpu_control *, uv_rtc_cpu_control);
 
 static cycle_t uv_read_rtc(struct clocksource *cs);
+static cycle_t uv_read_rtc_calc(struct clocksource *cs);
 static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
 static void uv_rtc_timer_setup(enum clock_event_mode,
 				struct clock_event_device *);
@@ -44,6 +172,20 @@ static struct clocksource clocksource_uv
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+static struct clocksource clocksource_uv_calc = {
+	.name		= RTC_NAME_CALC,
+	.rating		= 401,
+	.read		= uv_read_rtc_calc,
+	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
+	.shift		= 10,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct clocksource *clocksources[] = {
+	&clocksource_uv,
+	&clocksource_uv_calc,
+};
+
 static struct clock_event_device clock_event_device_uv = {
 	.name		= RTC_NAME,
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
@@ -282,22 +424,22 @@ static int uv_rtc_unset_timer(int cpu, i
  */
 
 /*
- * Read the RTC.
+ * Calculate the address of the RTC.
  *
  * Starting with HUB rev 2.0, the UV RTC register is replicated across all
  * cachelines of it's own page.  This allows faster simultaneous reads
  * from a given socket.
  */
-static cycle_t uv_read_rtc(struct clocksource *cs)
+static unsigned long *uv_raw_rtc_address(int cpu)
 {
 	unsigned long offset;
 
 	if (uv_get_min_hub_revision_id() == 1)
 		offset = 0;
 	else
-		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
-
-	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
+		offset = (uv_cpu_hub_info(cpu)->blade_processor_id * L1_CACHE_BYTES) %
+				PAGE_SIZE;
+	return uv_local_mmr_address(UVH_RTC  | offset);
 }
 
 /*
@@ -312,6 +454,136 @@ static int uv_rtc_next_event(unsigned lo
 }
 
 /*
+ * Atomically read the RTC & TSC. For accuracy, if it
+ * takes too long to access the RTC, try again. It is imporatnt that
+ * the TSC/RTC values be read as close as possible at the same time.
+ * Under certain pathological workloads, it can take a long time to
+ * read the RTC. Be paranoid - after a few attempts at reading a
+ * RTC/TSC pair, return a failure. Caller can try again later.
+ */
+static noinline int uv_readclocks(struct uv_rtc_cpu_control *rcc,
+				unsigned long *tsc, unsigned long *rtc)
+{
+	unsigned long flags, delta, rtc0, tsc0, tsc1;
+	unsigned volatile long *myrtcp = rcc->myrtcp;
+
+	int cnt = MAXREADS;
+
+	do {
+		local_irq_save(flags);
+		rdtsc_barrier();
+		rdtscll(tsc0);
+		rdtsc_barrier();
+		rtc0 = *myrtcp;
+		rdtsc_barrier();
+		rdtscll(tsc1);
+		local_irq_restore(flags);
+		delta = tsc1 - tsc0;
+		cnt--;
+		if (cnt == 0)
+			return -1;
+	} while (delta > rcc->max_readclocks_tsc_delta);
+	*rtc = rtc0;
+	*tsc = tsc1;
+	return 0;
+}
+
+/*
+ * Read the current RTC value. RTC access is several hundred nsec &
+ * can be a performance issue. In most cases, the current RTC value
+ * is calculated based on the current TSC value (fast access) and the
+ * TSC delta since a TSC/RTC pair was last read..
+ */
+static unsigned long uv_rtc_resync(void)
+{
+	struct uv_rtc_cpu_control *rcc = __get_cpu_var(uv_rtc_cpu_control);
+	struct uv_rtc_blade_control *rbc = rcc->rbc;
+	unsigned long rtcx, tscx, rtc0m, tsc0m, rtc0, tsc0;
+
+	/*
+	 * Periodically, reread a TSC/RTC pair. This prevents cumulative
+	 * clock drift from causing incorect values to be calculated.
+	 * If unable to read a TSC/RTC pair, disable RTC calculation
+	 * and read it directly.
+	 */
+	if (unlikely(uv_readclocks(rcc, &tsc0, &rtc0) < 0))
+		goto syncfail;
+	cmpxchg128(&rbc->rtc0, rbc->tsc0, rbc->rtc0, tsc0, rtc0);
+	read128(&rbc->rtc0m, &tsc0m, &rtc0m);
+	if (unlikely(tsc0m + rcc->recalc_drift_tsc_delta < tsc0 ||
+					tsc0m == 0)) {
+		cmpxchg128(&rbc->rtc0m, tsc0m, rtc0m, tsc0, rtc0);
+		if (tsc0m) {
+			rtcx = rtc0 - rtc0m;
+			tscx = tsc0 - tsc0m;
+			while (tscx > 0x7fffffff || rtcx > 0x7fffffff) {
+				tscx >>= 1;
+				rtcx >>= 1;
+			}
+			rbc->fixmult = (rtcx << 32) / tscx;
+		}
+	}
+	return rtc0;
+
+syncfail:
+	/*
+	 * Almost never happens but be prepared.
+	 * Unable to read a TSC/RTC pair. Disable dynamic calculation
+	 * of the RTC value until a pair can be read.
+	 */
+	rbc->tsc0m = 0;
+	rbc->fixmult = 0;
+	atomic_inc(&resync_clocks_failures);
+	return *rcc->myrtcp;
+}
+
+/*
+ * Read the current RTC value. RTC access is several hundred nsec &
+ * can be a performance issue. In most cases, the current RTC value
+ * is calculated based on the current TSC value (fast access) and the
+ * TSC delta since a TSC/RTC pair was last read..
+ */
+static cycle_t uv_read_rtc_calc(struct clocksource *cs)
+{
+	struct uv_rtc_cpu_control *rcc = __get_cpu_var(uv_rtc_cpu_control);
+	struct uv_rtc_blade_control *rbc = rcc->rbc;
+	unsigned long rtc, tsc, rtc0, tsc0;
+	unsigned long fixmult;
+	unsigned long adj;
+
+	read128(&rbc->rtc0, &tsc0, &rtc0);
+	rdtscll(tsc);
+	fixmult = rbc->fixmult;
+
+	if (likely((tsc0 + rcc->max_tsc_delta >= tsc) && fixmult)) {
+		/*
+		 * Cast to long to get sign extension on the shift  - delta might
+		 * be negative
+		 */
+		adj = ((long)((tsc - tsc0) * fixmult)) >> 32;
+		rtc = rtc0 + adj;
+	} else {
+		rtc = uv_rtc_resync();
+	}
+
+	/*
+	 * Don't return a rtc value less than the previous. Note: optimized
+	 * for typical case where last_rtc must be updated. Other case
+	 * rarely happens.
+	 */
+	rtc = max(rcc->last_rtc_value, rtc);
+	rcc->last_rtc_value = rtc;
+	return rtc;
+}
+
+static cycle_t uv_read_rtc(struct clocksource *cs)
+{
+	struct uv_rtc_cpu_control *rcc = __get_cpu_var(uv_rtc_cpu_control);
+
+	return *rcc->myrtcp;
+}
+
+/*
  * Setup the RTC timer in oneshot mode
  */
 static void uv_rtc_timer_setup(enum clock_event_mode mode,
@@ -354,6 +626,108 @@ static int __init uv_enable_evt_rtc(char
 }
 __setup("uvrtcevt", uv_enable_evt_rtc);
 
+
+#define UVCLK_ATTR(_name) \
+	static struct kobj_attribute uv_##_name##_attr = \
+		__ATTR(_name, 0644, uv_##_name##_show, uv_##_name##_store)
+
+#define UVCLK_ATTR_RO(_name) \
+	static struct kobj_attribute uv_##_name##_attr = \
+		__ATTR(_name, 0444, uv_##_name##_show, NULL)
+
+static void uv_update_all_blade_control(void)
+{
+	struct uv_rtc_cpu_control *rcc;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		rcc = per_cpu(uv_rtc_cpu_control, cpu);
+		rcc->recalc_drift_tsc_delta = ns_2_cycles(1000000 * recalc_drift_msec, cpu);
+		rcc->max_tsc_delta = ns_2_cycles(1000000 * resync_clocks_msec, cpu);
+		rcc->max_readclocks_tsc_delta = ns_2_cycles(max_readclocks_tsc_nsec, cpu);
+	}
+}
+
+static ssize_t uv_recalculate_drift_msec_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", recalc_drift_msec);
+}
+static ssize_t uv_recalculate_drift_msec_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	unsigned long input;
+
+	if (strict_strtoul(buf, 10, &input))
+		return 0;
+
+	recalc_drift_msec = input;
+	uv_update_all_blade_control();
+
+	return count;
+}
+UVCLK_ATTR(recalculate_drift_msec);
+
+static ssize_t uv_resync_clocks_msec_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", resync_clocks_msec);
+}
+static ssize_t uv_resync_clocks_msec_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	unsigned long input;
+
+	if (strict_strtoul(buf, 10, &input))
+		return 0;
+
+	resync_clocks_msec = input;
+	uv_update_all_blade_control();
+
+	return count;
+}
+UVCLK_ATTR(resync_clocks_msec);
+
+static ssize_t uv_max_readclocks_tsc_nsec_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", max_readclocks_tsc_nsec);
+}
+static ssize_t uv_max_readclocks_tsc_nsec_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	unsigned long input;
+
+	if (strict_strtoul(buf, 10, &input))
+		return 0;
+
+	max_readclocks_tsc_nsec = input;
+	uv_update_all_blade_control();
+
+	return count;
+}
+UVCLK_ATTR(max_readclocks_tsc_nsec);
+
+static ssize_t uv_resync_clocks_failures_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", atomic_read(&resync_clocks_failures));
+}
+UVCLK_ATTR_RO(resync_clocks_failures);
+
+static struct attribute *uv_rtc_attrs[] = {
+	&uv_recalculate_drift_msec_attr.attr,
+	&uv_resync_clocks_msec_attr.attr,
+	&uv_max_readclocks_tsc_nsec_attr.attr,
+	&uv_resync_clocks_failures_attr.attr,
+	NULL,
+};
+
+static struct attribute_group uv_rtc_attr_group = {
+	.attrs = uv_rtc_attrs,
+	.name = "sgi_rtc",
+};
+
 static __init void uv_rtc_register_clockevents(struct work_struct *dummy)
 {
 	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
@@ -363,31 +737,80 @@ static __init void uv_rtc_register_clock
 	clockevents_register_device(ced);
 }
 
+static __init int uv_setup_per_cpu_tables(void)
+{
+	struct uv_rtc_cpu_control *rcc = __get_cpu_var(uv_rtc_cpu_control);
+	struct uv_rtc_blade_control *rbc, **rbcp;
+	int b, node, cpu, numblades;
+
+	/* Allocate per node structures for RTC */
+	numblades = uv_num_possible_blades();
+	rbcp = kzalloc(sizeof(void *) * numblades, GFP_ATOMIC);
+	if (!rbcp)
+		return -ENOMEM;
+	for_each_online_node(node) {
+		b = uv_node_to_blade_id(node);
+		if (!rbcp[b])
+			rbcp[b] = kzalloc_node(sizeof(*rbc), GFP_ATOMIC, node);
+		rbc = rbcp[b];
+		if (!rbcp[b])
+			goto err;
+		for_each_online_cpu(cpu)
+			if (cpu_to_node(cpu) == node) {
+				rcc = kzalloc_node(sizeof(*rcc), GFP_ATOMIC, node);
+				rcc->rbc = rbc;
+				rcc->myrtcp = uv_raw_rtc_address(cpu);
+				per_cpu(uv_rtc_cpu_control, cpu) = rcc;
+			}
+	}
+	uv_update_all_blade_control();
+	kfree(rbcp);
+	return 0;
+
+err:
+	for_each_online_cpu(cpu)
+		kfree(per_cpu(uv_rtc_cpu_control, cpu));
+	for_each_online_node(node)
+		kfree(rbcp[uv_node_to_blade_id(node)]);
+	kfree(rbcp);
+	return -ENOMEM;
+}
+
 static __init int uv_rtc_setup_clock(void)
 {
-	int rc;
+	struct clocksource *cs;
+	int rc, csi;
 
 	if (!is_uv_system())
 		return -ENODEV;
 
-	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
-				clocksource_uv.shift);
+	rc = uv_setup_per_cpu_tables();
+	if (rc)
+		return rc;
 
-	/* If single blade, prefer tsc */
-	if (uv_num_possible_blades() == 1)
-		clocksource_uv.rating = 250;
+	for (csi = 0; csi < ARRAY_SIZE(clocksources); csi++) {
+		cs = clocksources[csi];
+		cs->mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
+				cs->shift);
+
+		/* If single blade, prefer tsc */
+		if (uv_num_possible_blades() == 1)
+			cs->rating = 250;
+		rc = clocksource_register(cs);
+		if (rc)
+			goto error;
+	}
 
-	rc = clocksource_register(&clocksource_uv);
-	if (rc)
-		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
-	else
-		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
-			sn_rtc_cycles_per_second/(unsigned long)1E6);
+	printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
+		sn_rtc_cycles_per_second/(unsigned long)1E6);
 
-	if (rc || !uv_rtc_evt_enable || x86_platform_ipi_callback)
-		return rc;
+	if (sysfs_create_group(kernel_kobj, &uv_rtc_attr_group))
+		printk(KERN_INFO "UV RTC - unable to create /sys files\n");
 
 	/* Setup and register clockevents */
+	if (!uv_rtc_evt_enable)
+		return 0;
+
 	rc = uv_rtc_allocate_timers();
 	if (rc)
 		goto error;
@@ -415,7 +838,8 @@ static __init int uv_rtc_setup_clock(voi
 	return 0;
 
 error:
-	clocksource_unregister(&clocksource_uv);
+	for (csi = csi - 1; csi >= 0; csi--)
+		clocksource_unregister(clocksources[csi]);
 	printk(KERN_INFO "UV RTC clockevents failed rc %d\n", rc);
 
 	return rc;
