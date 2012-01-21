Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab2AUWoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 17:44:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51273 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2AUWoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 17:44:44 -0500
Message-ID: <4F1B3FD5.1080502@lwfinger.net>
Date: Sat, 21 Jan 2012 16:44:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Alok N Kataria <akataria@vmware.com>,
        Dan Hecht <dhecht@vmware.com>,
        wireless <linux-wireless@vger.kernel.org>
Subject: (Very old) Regression following commit bfc0f59
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently discovered that an ancient laptop built by Mtech and containing an 
AMD K6 450/2 CPU was generating errors when using the Cardbus versions of 
Broadcom cards using either b43 of b43legacy. Expecting some change in those 
drivers or ssb, I found a kernel old enough to work without the error, and did a 
bisection. I was very surprised when "x86: merge tsc calibration", which is 
commit bfc0f5947afa5e3a13e55867f4478c8a92c11dca (dated July 1, 2008), turned out 
to be the source of the regression. It was verified by generating a reversion 
patch. One main difference is that the bad code gets a processor speed of 
214.398 MHz, whereas reverting the commit yields 428.845 MHz, which is more in 
keeping with the stated frequency of 450 MHz. As the machine is more than 10 
years old, the clock may have drifted considerably.

I did some checking to see what parts of the commit needed to be reverted, and 
found that the bug is reversed by applying the patch below. I will continue to 
analyze the code to see if I can find the problem, but I wanted to see if anyone 
here could spot anything. I expect that it is a specific problem with the AMD 
K6, as I expect that such problems on current 32-bit CPUs would have been fixed 
long ago.

Thanks,

Larry

Reversion patch that works:

Index: wireless-testing/arch/x86/kernel/tsc_32.c
===================================================================
--- wireless-testing.orig/arch/x86/kernel/tsc_32.c
+++ wireless-testing/arch/x86/kernel/tsc_32.c
@@ -65,6 +65,57 @@ void set_cyc2ns_scale(unsigned long cpu_
  	local_irq_restore(flags);
  }

+unsigned long native_calculate_cpu_khz(void)
+{
+	unsigned long long start, end;
+	unsigned long count;
+	u64 delta64 = (u64)ULLONG_MAX;
+	int i;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/* run 3 times to ensure the cache is warm and to get an accurate reading */
+	for (i = 0; i < 3; i++) {
+		mach_prepare_counter();
+		rdtscll(start);
+		mach_countup(&count);
+		rdtscll(end);
+
+		/*
+		 * Error: ECTCNEVERSET
+		 * The CTC wasn't reliable: we got a hit on the very first read,
+		 * or the CPU was so fast/slow that the quotient wouldn't fit in
+		 * 32 bits..
+		 */
+		if (count <= 1)
+			continue;
+
+		/* cpu freq too slow: */
+		if ((end - start) <= CALIBRATE_TIME_MSEC)
+			continue;
+
+		/*
+		 * We want the minimum time of all runs in case one of them
+		 * is inaccurate due to SMI or other delay
+		 */
+		delta64 = min(delta64, (end - start));
+	}
+
+	/* cpu freq too fast (or every run was bad): */
+	if (delta64 > (1ULL<<32))
+		goto err;
+
+	delta64 += CALIBRATE_TIME_MSEC/2; /* round for do_div */
+	do_div(delta64,CALIBRATE_TIME_MSEC);
+
+	local_irq_restore(flags);
+	return (unsigned long)delta64;
+err:
+	local_irq_restore(flags);
+	return 0;
+}
+
  #ifdef CONFIG_CPU_FREQ

  /*
Index: wireless-testing/arch/x86/kernel/tsc.c
===================================================================
--- wireless-testing.orig/arch/x86/kernel/tsc.c
+++ wireless-testing/arch/x86/kernel/tsc.c
@@ -3,9 +3,6 @@
  #include <linux/init.h>
  #include <linux/module.h>
  #include <linux/timer.h>
-#include <linux/acpi_pmtmr.h>
-
-#include <asm/hpet.h>
  #include <asm/timer.h>

  unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
@@ -89,109 +86,6 @@ int __init notsc_setup(char *str)
  #endif

  __setup("notsc", notsc_setup);
-
-#define MAX_RETRIES     5
-#define SMI_TRESHOLD    50000
-
-/*
- * Read TSC and the reference counters. Take care of SMI disturbance
- */
-static u64 __init tsc_read_refs(u64 *pm, u64 *hpet)
-{
-	u64 t1, t2;
-	int i;
-
-	for (i = 0; i < MAX_RETRIES; i++) {
-		t1 = get_cycles();
-		if (hpet)
-			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
-		else
-			*pm = acpi_pm_read_early();
-		t2 = get_cycles();
-		if ((t2 - t1) < SMI_TRESHOLD)
-			return t2;
-	}
-	return ULLONG_MAX;
-}
-
-/**
- * tsc_calibrate - calibrate the tsc on boot
- */
-static unsigned int __init tsc_calibrate(void)
-{
-	unsigned long flags;
-	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled();
-	unsigned int tsc_khz_val = 0;
-
-	local_irq_save(flags);
-
-	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
-
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-	outb(0xb0, 0x43);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	tr1 = get_cycles();
-	while ((inb(0x61) & 0x20) == 0);
-	tr2 = get_cycles();
-
-	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
-
-	local_irq_restore(flags);
-
-	/*
-	 * Preset the result with the raw and inaccurate PIT
-	 * calibration value
-	 */
-	delta = (tr2 - tr1);
-	do_div(delta, 50);
-	tsc_khz_val = delta;
-
-	/* hpet or pmtimer available ? */
-	if (!hpet && !pm1 && !pm2) {
-		printk(KERN_INFO "TSC calibrated against PIT\n");
-		goto out;
-	}
-
-	/* Check, whether the sampling was disturbed by an SMI */
-	if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX) {
-		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
-				"using PIT calibration result\n");
-		goto out;
-	}
-
-	tsc2 = (tsc2 - tsc1) * 1000000LL;
-
-	if (hpet) {
-		printk(KERN_INFO "TSC calibrated against HPET\n");
-		if (hpet2 < hpet1)
-			hpet2 += 0x100000000ULL;
-		hpet2 -= hpet1;
-		tsc1 = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
-		do_div(tsc1, 1000000);
-	} else {
-		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
-		if (pm2 < pm1)
-			pm2 += (u64)ACPI_PM_OVRRUN;
-		pm2 -= pm1;
-		tsc1 = pm2 * 1000000000LL;
-		do_div(tsc1, PMTMR_TICKS_PER_SEC);
-	}
-
-	do_div(tsc2, tsc1);
-	tsc_khz_val = tsc2;
-
-out:
-	return tsc_khz_val;
-}
-
-unsigned long native_calculate_cpu_khz(void)
-{
-	return tsc_calibrate();
-}
-
  #ifdef CONFIG_X86_32
  /* Only called from the Powernow K7 cpu freq driver */
  int recalibrate_cpu_khz(void)

