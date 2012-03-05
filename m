Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab2CEXcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:32:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:33907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab2CEXcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:32:53 -0500
Message-ID: <1330990360.11248.264.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Aman Gupta <aman@tmm1.net>
Cc: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 06 Mar 2012 00:32:40 +0100
In-Reply-To: <1330989903.11248.261.camel@twins>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
	 <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins>
	 <4F551ABE.5080605@nasza-klasa.pl>
	 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
	 <1330989903.11248.261.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 00:25 +0100, Peter Zijlstra wrote:
> I tried writing hpet64 support so we could idle that long, killed all
> kinds of stupid kernel threads (watchdogs mostly) that keep waking up
> and got a brick.. 

Just in case someone wants to have a go at fixing this mess.. :-)

I _think_ the below was the latest, but it was 2am on friday night or
something, so recollections are somewhat hazy.


---
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad0de0c..fd2aab0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -17,6 +17,7 @@
 #include <asm/time.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
+#define HPET64_MASK			CLOCKSOURCE_MASK(64)
 
 /* FSEC = 10^-15
    NSEC = 10^-9 */
@@ -43,6 +44,12 @@ static unsigned long			hpet_num_timers;
 #endif
 static void __iomem			*hpet_virt_address;
 
+#ifdef X86_64
+static int				hpet64;
+#else
+ #define hpet64				(0)
+#endif
+
 struct hpet_dev {
 	struct clock_event_device	evt;
 	unsigned int			num;
@@ -67,6 +74,26 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 	writel(d, hpet_virt_address + a);
 }
 
+inline u64 hpet_read(unsigned int a)
+{
+	u64 ret;
+
+	if (hpet64)
+		ret = readq(hpet_virt_address + a);
+	else
+		ret = readl(hpet_virt_address + a);
+
+	return ret;
+}
+
+static inline void hpet_write(u64 d, unsigned int a)
+{
+	if (hpet64)
+		writeq(d, hpet_virt_address + a);
+	else
+		writel(d, hpet_virt_address + a);
+}
+
 #ifdef CONFIG_X86_64
 #include <asm/pgtable.h>
 #endif
@@ -91,6 +118,10 @@ static inline void hpet_clear_mapping(void)
 static int boot_hpet_disable;
 int hpet_force_user;
 static int hpet_verbose;
+#ifdef X86_64
+static int hpet_force_64;
+static int hpet_force_32;
+#endif
 
 static int __init hpet_setup(char *str)
 {
@@ -101,6 +132,12 @@ static int __init hpet_setup(char *str)
 			hpet_force_user = 1;
 		if (!strncmp("verbose", str, 7))
 			hpet_verbose = 1;
+#ifdef X86_64
+		if(!strncmp("force64", str, 7))
+			hpet_force_64 = 1;
+		if(!strncmp("force32", str, 7))
+			hpet_force_32 = 1;
+#endif
 	}
 	return 1;
 }
@@ -249,8 +286,11 @@ static void hpet_stop_counter(void)
 
 static void hpet_reset_counter(void)
 {
-	hpet_writel(0, HPET_COUNTER);
-	hpet_writel(0, HPET_COUNTER + 4);
+	if (!hpet64) {
+		hpet_writel(0, HPET_COUNTER);
+		hpet_writel(0, HPET_COUNTER + 4);
+	} else
+		hpet_write(0, HPET_COUNTER);
 }
 
 static void hpet_start_counter(void)
@@ -298,7 +338,8 @@ static void hpet_legacy_clockevent_register(void)
 	 */
 	hpet_clockevent.cpumask = cpumask_of(smp_processor_id());
 	clockevents_config_and_register(&hpet_clockevent, hpet_freq,
-					HPET_MIN_PROG_DELTA, 0x7FFFFFFF);
+					HPET_MIN_PROG_DELTA, 
+					hpet64 ? 0x7FFFFFFFFFFFFFFF : 0x7FFFFFFF);
 	global_clock_event = &hpet_clockevent;
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
@@ -308,23 +349,25 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned int cfg, cmp, now;
-	uint64_t delta;
+	uint64_t delta, cmp, now;
+	unsigned int cfg;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
+		now = hpet_read(HPET_COUNTER);
 		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
-		       HPET_TN_SETVAL | HPET_TN_32BIT;
+		       HPET_TN_SETVAL;
+	        if (!hpet64)
+			cfg |= HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
+		hpet_write(cmp, HPET_Tn_CMP(timer));
 		udelay(1);
 		/*
 		 * HPET on AMD 81xx needs a second write (with HPET_TN_SETVAL
@@ -333,7 +376,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		 * (See AMD-8111 HyperTransport I/O Hub Data Sheet,
 		 * Publication # 24674)
 		 */
-		hpet_writel((unsigned int) delta, HPET_Tn_CMP(timer));
+		hpet_write(delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
 		break;
@@ -341,7 +384,9 @@ static void hpet_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_ONESHOT:
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_PERIODIC;
-		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+		cfg |= HPET_TN_ENABLE;
+		if (!hpet64)
+			cfg |= HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
@@ -370,12 +415,12 @@ static void hpet_set_mode(enum clock_event_mode mode,
 static int hpet_next_event(unsigned long delta,
 			   struct clock_event_device *evt, int timer)
 {
-	u32 cnt;
-	s32 res;
+	u64 cnt;
+	s64 res;
 
-	cnt = hpet_readl(HPET_COUNTER);
-	cnt += (u32) delta;
-	hpet_writel(cnt, HPET_Tn_CMP(timer));
+	cnt = hpet_read(HPET_COUNTER);
+	cnt += delta;
+	hpet_write(cnt, HPET_Tn_CMP(timer));
 
 	/*
 	 * HPETs are a complete disaster. The compare register is
@@ -399,7 +444,7 @@ static int hpet_next_event(unsigned long delta,
 	 * the event. The minimum programming delta for the generic
 	 * clockevents code is set to 1.5 * HPET_MIN_CYCLES.
 	 */
-	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
+	res = (s64)(cnt - hpet_read(HPET_COUNTER));
 
 	return res < HPET_MIN_CYCLES ? -ETIME : 0;
 }
@@ -739,7 +784,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
  */
 static cycle_t read_hpet(struct clocksource *cs)
 {
-	return (cycle_t)hpet_readl(HPET_COUNTER);
+	return (cycle_t)hpet_read(HPET_COUNTER);
 }
 
 static struct clocksource clocksource_hpet = {
@@ -763,7 +808,7 @@ static int hpet_clocksource_register(void)
 	hpet_restart_counter();
 
 	/* Verify whether hpet counter works */
-	t1 = hpet_readl(HPET_COUNTER);
+	t1 = hpet_read(HPET_COUNTER);
 	rdtscll(start);
 
 	/*
@@ -777,7 +822,7 @@ static int hpet_clocksource_register(void)
 		rdtscll(now);
 	} while ((now - start) < 200000UL);
 
-	if (t1 == hpet_readl(HPET_COUNTER)) {
+	if (t1 == hpet_read(HPET_COUNTER)) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
 		return -ENODEV;
@@ -847,6 +892,13 @@ int __init hpet_enable(void)
 	id = hpet_readl(HPET_ID);
 	hpet_print_config();
 
+#ifdef X86_64
+	if (((id & HPET_ID_64BIT) || hpet_force_64) && !hpet_force_32) {
+		hpet64 = 1;
+		clocksource_hpet.mask = HPET64_MASK;
+	}
+#endif
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
 	 * The legacy routing mode needs at least two channels, tick timer
@@ -962,9 +1014,9 @@ static unsigned long hpet_rtc_flags;
 static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
-static u32 hpet_t1_cmp;
-static u32 hpet_default_delta;
-static u32 hpet_pie_delta;
+static u64 hpet_t1_cmp;
+static u64 hpet_default_delta;
+static u64 hpet_pie_delta;
 static unsigned long hpet_pie_limit;
 
 static rtc_irq_handler irq_handler;
@@ -972,9 +1024,9 @@ static rtc_irq_handler irq_handler;
 /*
  * Check that the hpet counter c1 is ahead of the c2
  */
-static inline int hpet_cnt_ahead(u32 c1, u32 c2)
+static inline int hpet_cnt_ahead(u64 c1, u64 c2)
 {
-	return (s32)(c2 - c1) < 0;
+	return (s64)(c2 - c1) < 0;
 }
 
 /*
@@ -1015,7 +1067,8 @@ EXPORT_SYMBOL_GPL(hpet_unregister_irq_handler);
  */
 int hpet_rtc_timer_init(void)
 {
-	unsigned int cfg, cnt, delta;
+	unsigned int cfg;
+	u64 cnt, delta;
 	unsigned long flags;
 
 	if (!is_hpet_enabled())
@@ -1036,13 +1089,15 @@ int hpet_rtc_timer_init(void)
 
 	local_irq_save(flags);
 
-	cnt = delta + hpet_readl(HPET_COUNTER);
-	hpet_writel(cnt, HPET_T1_CMP);
+	cnt = delta + hpet_read(HPET_COUNTER);
+	hpet_write(cnt, HPET_T1_CMP);
 	hpet_t1_cmp = cnt;
 
 	cfg = hpet_readl(HPET_T1_CFG);
 	cfg &= ~HPET_TN_PERIODIC;
-	cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+	cfg |= HPET_TN_ENABLE;
+        if (!hpet64)
+		cfg |= HPET_TN_32BIT;
 	hpet_writel(cfg, HPET_T1_CFG);
 
 	local_irq_restore(flags);
@@ -1155,9 +1210,9 @@ static void hpet_rtc_timer_reinit(void)
 	 */
 	do {
 		hpet_t1_cmp += delta;
-		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
+		hpet_write(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_readl(HPET_COUNTER)));
+	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_read(HPET_COUNTER)));
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)

