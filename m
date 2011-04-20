Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1DTTlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:41:09 -0400
Received: from n1.taur.dk ([217.198.219.102]:53826 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab1DTTlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:41:07 -0400
X-Greylist: delayed 2669 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 15:41:07 EDT
Message-ID: <4DAF2B57.6010100@kasperkp.dk>
Date: Wed, 20 Apr 2011 20:52:07 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Kasper Pedersen <kernel@kasperkp.dk>
Subject: x86: tsc: make TSC calibration more immune to interrupts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a SMI or plain interrupt occurs during the delayed part
of TSC calibration, and the SMI/irq handler is good and fast
so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
off (10-30ppm).

We should not depend on interrupts being longer than 50000
clocks, so always do the 5 tries, and use the best sample we
get.
This should work always for any four periodic or rate-limited
interrupt sources. If we get 5 interrupts with 500ns gaps in
a row, behaviour should be as without this patch.

This costs us 20-100 microseconds in startup time, as
tsc_read_refs is called 8 times.

measurements:
On a 700MHz P3 I see t2-t1=~22000, and 31ppm error.
A Core2 is similar: http://n1.taur.dk/tscdeviat.png
(while mostly t2-t1=~1000, in about 1 of 3000 tests
I see t2-t1=~20000 for both machines.)
vmware ESX4 has t2-t1=~8000 and up.

Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
---
 arch/x86/kernel/tsc.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ffe5755..e916f99 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -117,7 +117,7 @@ static int __init tsc_setup(char *str)
 
 __setup("tsc=", tsc_setup);
 
-#define MAX_RETRIES     5
+#define BESTOF_SAMPLES      5
 #define SMI_TRESHOLD    50000
 
 /*
@@ -125,19 +125,29 @@ __setup("tsc=", tsc_setup);
  */
 static u64 tsc_read_refs(u64 *p, int hpet)
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
+		}
 	}
+	if (best_uncertainty < SMI_TRESHOLD)
+		return best_t2;
+
+	*p = tp;
 	return ULLONG_MAX;
 }
 

