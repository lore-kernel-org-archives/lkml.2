Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2DRQhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:37:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:57340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2DRQho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="133991651"
Message-ID: <4F8EEDD3.1080404@linux.intel.com>
Date: Wed, 18 Apr 2012 17:37:39 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: tglx@linuxtronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] APIC code touches invalid MSR on P5 class machines
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all.

We've been testing with a legacy simulation platform and have run across
a bug, in the APIC code.

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
---
 arch/x86/kernel/apic/apic.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

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
1.7.0.7
