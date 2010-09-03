Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0ICJOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:14:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0ICJOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:14:02 -0400
Subject: [PATCH] perf, x86: Disable perf if the BIOS got its grubby paws on
 the PMU
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan Van De Ven <arjan@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 11:13:47 +0200
Message-ID: <1283505227.1783.224.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable all of perf if we find any active PMCs on boot.

It has been reported that some BIOSes access the PMU, for obscure things
better done by the OS. Come down hard on this practice and fully disable
the PMU.

[ Boot tested on a westmere system with a sane BIOS -- I don't actually
  have an affected system to test this on. ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Robert, do you know if any AMD system BIOSes carry similar
Feat^H^H^H^HFailureAdd?

 arch/x86/kernel/cpu/perf_event_intel.c |   35 ++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ee05c90..6849653 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -923,6 +923,19 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static void print_BIOS_fail(void)
+{
+	printk(KERN_ERR "\n");
+	printk(KERN_ERR "=============================================\n");
+	printk(KERN_ERR "It appears the BIOS is actively using the PMU\n");
+	printk(KERN_ERR "this avoids Linux from using it, please de-  \n");
+	printk(KERN_ERR "activate this BIOS feature or request a BIOS \n");
+	printk(KERN_ERR "update from your vendor.                     \n");
+	printk(KERN_ERR "=============================================\n");
+
+	memset(&x86_pmu, 0, sizeof(x86_pmu));
+}
+
 static __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -930,6 +943,8 @@ static __init int intel_pmu_init(void)
 	unsigned int unused;
 	unsigned int ebx;
 	int version;
+	u64 val;
+	int i;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -968,6 +983,26 @@ static __init int intel_pmu_init(void)
 		x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
 
 	/*
+	 * Check to see if the BIOS enabled any of the counters, if so
+	 * complain and bail.
+	 */
+	for (i = 0; i < x86_pmu.num_counters; i++) {
+		rdmsrl(x86_pmu.eventsel + i, val);
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE) {
+			print_BIOS_fail();
+			return -EBUSY;
+		}
+	}
+
+	for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, val);
+		if (val & (0x03 << i*4)) {
+			print_BIOS_fail();
+			return -EBUSY;
+		}
+	}
+
+	/*
 	 * v2 and above have a perf capabilities MSR
 	 */
 	if (version > 1) {

