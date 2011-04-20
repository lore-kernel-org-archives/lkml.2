Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1DTVXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:23:35 -0400
Received: from n1.taur.dk ([217.198.219.102]:60777 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1DTVXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:23:34 -0400
Message-ID: <4DAF4E8B.6030506@kasperkp.dk>
Date: Wed, 20 Apr 2011 23:22:19 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x86: tsc: v2 make TSC calibration more immune to interrupts
References: <4DAF2B57.6010100@kasperkp.dk>	 <1303326959.2796.136.camel@work-vm>  <4DAF37B4.3040408@kasperkp.dk> <1303331280.2796.154.camel@work-vm>
In-Reply-To: <1303331280.2796.154.camel@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a SMI or plain interrupt occurs during the delayed part
of TSC calibration, and the SMI/irq handler is good and fast
so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
off (10-30ppm).

We should not depend on interrupts being longer than 50000
clocks, so, in the refined calibration, always do the 5
tries, and use the best sample we get.

This should work always for any four periodic or rate-limited
interrupt sources. If we get 5 interrupts with 500ns gaps in
a row, behaviour should be as without this patch.

It is safe to use the first value that passes SMI_TRESHOLD
for the initial calibration: As long as tsc_khz is above
100MHz, SMI_TRESHOLD represents less than 1% of error.

The 8 additional samples costs us 28 microseconds in startup
time.

measurements:
On a 700MHz P3 I see t2-t1=~22000, and 31ppm error.
A Core2 is similar: http://n1.taur.dk/tscdeviat.png
(while mostly t2-t1=~1000, in about 1 of 3000 tests
I see t2-t1=~20000 for both machines.)
vmware ESX4 has t2-t1=~8000 and up.

v2: John Stulz suggested limiting best uncertainty to
where it is needed, saving ~170usec startup time.

Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
---
 arch/x86/kernel/tsc.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ffe5755..8dc813b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -117,27 +117,39 @@ static int __init tsc_setup(char *str)
 
 __setup("tsc=", tsc_setup);
 
-#define MAX_RETRIES     5
+#define BESTOF_SAMPLES      5
 #define SMI_TRESHOLD    50000
 
 /*
  * Read TSC and the reference counters. Take care of SMI disturbance
  */
-static u64 tsc_read_refs(u64 *p, int hpet)
+static u64 tsc_read_refs(u64 *p, int hpet, int find_best)
 {
-	u64 t1, t2;
+	u64 t1, t2, tp, best_uncertainty, uncertainty, best_t2;
 	int i;
 
-	for (i = 0; i < MAX_RETRIES; i++) {
+	best_uncertainty = SMI_TRESHOLD;
+	best_t2 = 0;
+	for (i = 0; i < BESTOF_SAMPLES; i++) {
 		t1 = get_cycles();
 		if (hpet)
-			*p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
+			tp = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
 		else
-			*p = acpi_pm_read_early();
+			tp = acpi_pm_read_early();
 		t2 = get_cycles();
-		if ((t2 - t1) < SMI_TRESHOLD)
-			return t2;
+		uncertainty = t2 - t1;
+		if (uncertainty < best_uncertainty) {
+			best_uncertainty = uncertainty;
+			best_t2 = t2;
+			*p = tp;
+			if (!find_best)
+				break;
+		}
 	}
+	if (best_uncertainty < SMI_TRESHOLD)
+		return best_t2;
+
+	*p = tp;
 	return ULLONG_MAX;
 }
 
@@ -455,9 +467,9 @@ unsigned long native_calibrate_tsc(void)
 		 * read the end value.
 		 */
 		local_irq_save(flags);
-		tsc1 = tsc_read_refs(&ref1, hpet);
+		tsc1 = tsc_read_refs(&ref1, hpet, 0);
 		tsc_pit_khz = pit_calibrate_tsc(latch, ms, loopmin);
-		tsc2 = tsc_read_refs(&ref2, hpet);
+		tsc2 = tsc_read_refs(&ref2, hpet, 0);
 		local_irq_restore(flags);
 
 		/* Pick the lowest PIT TSC calibration so far */
@@ -928,11 +940,11 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 		 */
 		hpet = is_hpet_enabled();
 		schedule_delayed_work(&tsc_irqwork, HZ);
-		tsc_start = tsc_read_refs(&ref_start, hpet);
+		tsc_start = tsc_read_refs(&ref_start, hpet, 1);
 		return;
 	}
 
-	tsc_stop = tsc_read_refs(&ref_stop, hpet);
+	tsc_stop = tsc_read_refs(&ref_stop, hpet, 1);
 
 	/* hpet or pmtimer available ? */
 	if (ref_start == ref_stop)


