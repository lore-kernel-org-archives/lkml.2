Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab2EIFxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38870 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869Ab2EIFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:12 -0400
Message-Id: <20120509055042.769766413@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bryan ODonoghue <bryan.odonoghue@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 094/167] [PATCH] x86, apic: APIC code touches invalid MSR on P5 class
 machines
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linux.intel.com>

commit cbf2829b61c136edcba302a5e1b6b40e97d32c00 upstream.

Current APIC code assumes MSR_IA32_APICBASE is present for all systems.
Pentium Classic P5 and friends didn't have this MSR. MSR_IA32_APICBASE
was introduced as an architectural MSR by Intel @ P6.

Code paths that can touch this MSR invalidly are when vendor == Intel &&
cpu-family == 5 and APIC bit is set in CPUID - or when you simply pass
lapic on the kernel command line, on a P5.

The below patch stops Linux incorrectly interfering with the
MSR_IA32_APICBASE for P5 class machines. Other code paths exist that
touch the MSR - however those paths are not currently reachable for a
conformant P5.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linux.intel.com>
Link: http://lkml.kernel.org/r/4F8EEDD3.1080404@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/apic.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 11544d8..edc2448 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1637,9 +1637,11 @@ static int __init apic_verify(void)
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
 
 	/* The BIOS may have set up the APIC at some other address */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (l & MSR_IA32_APICBASE_ENABLE)
-		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+	if (boot_cpu_data.x86 >= 6) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (l & MSR_IA32_APICBASE_ENABLE)
+			mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+	}
 
 	pr_info("Found and enabled local APIC!\n");
 	return 0;
@@ -1657,13 +1659,15 @@ int __init apic_force_enable(unsigned long addr)
 	 * MSR. This can only be done in software for Intel P6 or later
 	 * and AMD K7 (Model > 1) or later.
 	 */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-		pr_info("Local APIC disabled by BIOS -- reenabling.\n");
-		l &= ~MSR_IA32_APICBASE_BASE;
-		l |= MSR_IA32_APICBASE_ENABLE | addr;
-		wrmsr(MSR_IA32_APICBASE, l, h);
-		enabled_via_apicbase = 1;
+	if (boot_cpu_data.x86 >= 6) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
+			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
+			l &= ~MSR_IA32_APICBASE_BASE;
+			l |= MSR_IA32_APICBASE_ENABLE | addr;
+			wrmsr(MSR_IA32_APICBASE, l, h);
+			enabled_via_apicbase = 1;
+		}
 	}
 	return apic_verify();
 }
@@ -2209,10 +2213,12 @@ static void lapic_resume(void)
 		 * FIXME! This will be wrong if we ever support suspend on
 		 * SMP! We'll need to do this as part of the CPU restore!
 		 */
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		l &= ~MSR_IA32_APICBASE_BASE;
-		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-		wrmsr(MSR_IA32_APICBASE, l, h);
+		if (boot_cpu_data.x86 >= 6) {
+			rdmsr(MSR_IA32_APICBASE, l, h);
+			l &= ~MSR_IA32_APICBASE_BASE;
+			l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+			wrmsr(MSR_IA32_APICBASE, l, h);
+		}
 	}
 
 	maxlvt = lapic_get_maxlvt();
-- 
1.7.10



