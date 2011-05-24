Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1EXUhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:37:46 -0400
Received: from n1.taur.dk ([217.198.219.102]:55567 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab1EXUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:37:45 -0400
X-Greylist: delayed 2800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 16:37:45 EDT
Message-ID: <4DDC0B4F.6060202@kasperkp.dk>
Date: Tue, 24 May 2011 21:47:27 +0200
From: Kasper Pedersen <kkp2010@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <johnstul@us.ibm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kasper Pedersen <kkp2010@kasperkp.dk>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v3] x86: tsc: make TSC calibration immune to interrupts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a SMI or plain interrupt occurs during the delayed part
of TSC calibration, and the SMI/irq handler is good and fast
so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
off (10-30ppm).

We should keep plain interrupts out of the reading of
tsc/reference, so disable interrupts there.

We should not depend on SMIs being longer than 50000 clocks,
so, in the refined calibration, always do the 5 tries, and
use the best sample we get.

This should work always for any four periodic or rate-limited
SMI sources. If we get 5 SMIs with 500ns gaps in a row, 
behaviour should be as without this patch.

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

v2: save ~170usec startup time (Stultz)
v3: also disabling irqs. (Triplett)

Signed-off-by: Kasper Pedersen <kkp2010@kasperkp.dk>
---
 arch/x86/kernel/tsc.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ffe5755..9983c03 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -117,27 +117,42 @@ static int __init tsc_setup(char *str)
 
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
+	unsigned long flags;
 
-	for (i = 0; i < MAX_RETRIES; i++) {
+	best_uncertainty = SMI_TRESHOLD;
+	best_t2 = 0;
+	for (i = 0; i < BESTOF_SAMPLES; i++) {
+		local_irq_save(flags);
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
+		local_irq_restore(flags);
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
 
@@ -455,9 +470,9 @@ unsigned long native_calibrate_tsc(void)
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
@@ -928,11 +943,11 @@ static void tsc_refine_calibration_work(struct work_struct *work)
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

