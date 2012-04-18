Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DRRUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:20:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2DRRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:20:17 -0400
Date: Wed, 18 Apr 2012 10:19:53 -0700
From: "tip-bot for Bryan O'Donoghue" <bryan.odonoghue@linux.intel.com>
Message-ID: <tip-cbf2829b61c136edcba302a5e1b6b40e97d32c00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        bryan.odonoghue@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, stable@vger.kernel.org,
        bryan.odonoghue@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <4F8EEDD3.1080404@linux.intel.com>
References: <4F8EEDD3.1080404@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic:
  APIC code touches invalid MSR on P5 class machines
Git-Commit-ID: cbf2829b61c136edcba302a5e1b6b40e97d32c00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 10:20:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbf2829b61c136edcba302a5e1b6b40e97d32c00
Gitweb:     http://git.kernel.org/tip/cbf2829b61c136edcba302a5e1b6b40e97d32c00
Author:     Bryan O'Donoghue <bryan.odonoghue@linux.intel.com>
AuthorDate: Wed, 18 Apr 2012 17:37:39 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 18 Apr 2012 09:44:31 -0700

x86, apic: APIC code touches invalid MSR on P5 class machines

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
Cc: <stable@vger.kernel.org>
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
