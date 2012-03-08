Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab2CHXXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:23:09 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:47310 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2CHXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:23:05 -0500
Subject: [PATCH] sched, x86: fix overflow in cyc2ns_offset
To: sqazi@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
From: Salman Qazi <sqazi@google.com>
Date: Thu, 08 Mar 2012 15:23:03 -0800
Message-ID: <20120308232303.11660.48285.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a machine boots up, the TSC generally gets reset.  However, when
kexec is used to boot into a kernel, the TSC value would be carried
over from the previous kernel.  The computation of cycns_offset in
set_cyc2ns_scale is prone to an overflow, if the machine has been up
more than 208 days prior to the kexec.  The overflow happens when
we multiply *scale, even though there is enough room to store the
final answer.  We fix this issue by decomposing tsc_now into the
quotient and remainder of division by CYC2NS_SCALE_FACTOR and then
performing the multiplication separately on the two components.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 arch/x86/kernel/tsc.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..ef1dc8e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -608,6 +608,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now, *offset;
 	unsigned long flags, *scale;
+	unsigned long long quot;
+	unsigned long long rem;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
@@ -620,7 +622,15 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+
+		/*
+		 * Avoid premature overflow by splitting into quotient
+		 * and remainder.  See the comment above __cycles_2_ns
+		 */
+		quot = (tsc_now >> CYC2NS_SCALE_FACTOR);
+		rem = tsc_now & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
+		*offset = ns_now - (quot * *scale +
+				    ((rem * *scale) >> CYC2NS_SCALE_FACTOR));
 	}
 
 	sched_clock_idle_wakeup_event(0);

