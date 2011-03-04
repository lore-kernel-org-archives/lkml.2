Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab1CDTsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:48:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab1CDTsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Y24vt2teYp0EGRs2fXrkdb1igjXUayfXNjzzWrq1NF3BY9bD4YQFCffUTB4VbrHxTl
         UObOQ3jDAaqPnlrDwzcapGTUP6wuvtwdn2nFX0k4/v7EYJp25S7oeujQ1w+H9TCzMt3Q
         8Pgfk3p2cvFso5V/G3RPmU5RiYAsY+yYrSXbk=
Message-ID: <4D7141FC.8000504@gmail.com>
Date: Fri, 04 Mar 2011 22:48:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errata N15 and 17 of 249199-071 should be taken
into account. They are mostly hard to hit at moment
i believe but still better to be fixed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Ming, mind to give it a shot? I seems will be able to test myself
at Wednesday only. And I would like to get a review first to eliminate
some silly mistakes ;)

 arch/x86/kernel/cpu/perf_event_p4.c |   54 ++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -809,15 +809,51 @@ static void p4_pmu_disable_pebs(void)
 static inline void p4_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	unsigned int cntr_msr;
+	u32 prev_lo, prev_hi, new_lo, new_hi;
+
+	cntr_msr = hwc->event_base + hwc->idx;
+
+	/*
+	 * Erratum N17 of 249199-071 says if a performance counter is
+	 * stopped on the precise internal clock cycle where the intermediate
+	 * carry from the lower 32 bits of the counter to the upper eight
+	 * bits occurs, the intermediate carry is lost.
+	 *
+	 * As a workaround we read before stop and check for lost carry
+	 * bit, if it get lost simply write previous value back, this is
+	 * of course might introduce a delta in precise counting but still
+	 * it's a way better than 2^32 magnitude lost.
+	 */
+	rdmsr(cntr_msr, prev_lo, prev_hi);

 	/*
 	 * If event gets disabled while counter is in overflowed
 	 * state we need to clear P4_CCCR_OVF, otherwise interrupt get
 	 * asserted again and again
+	 *
+	 * Erratum N15 of 249199-071 says we are to clear P4_CCCR_COMPARE
+	 * otherwise writing a performance counter may result in incorrect
+	 * value (to be sure we do a double write later) but since
+	 * we're modifying CCCR anyway better to take this bit into account
+	 * just to be double safe. Note we don't touch the former
+	 * config so no affects on user supplied data.
 	 */
 	(void)checking_wrmsrl(hwc->config_base,
 		(u64)(p4_config_unpack_cccr(hwc->config)) &
-			~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
+			~P4_CCCR_COMPARE & ~P4_CCCR_ENABLE &
+			~P4_CCCR_OVF     & ~P4_CCCR_RESERVED);
+
+	/*
+	 * Lets try to recover from error if happened
+	 */
+	if (prev_lo == -1U) {
+		rdmsr(cntr_msr, new_lo, new_hi);
+		if (new_lo == 0 && (new_hi - prev_hi) == 0) {
+			wrmsr_safe(cntr_msr, prev_lo, prev_hi);
+			printk_once("P4 PMU: Recover lost carry bit\n");
+		}
+	}
 }

 static void p4_pmu_disable_all(void)
@@ -841,6 +877,16 @@ static void p4_pmu_enable_pebs(u64 confi
 	struct p4_pebs_bind *bind;
 	unsigned int idx;

+	/*
+	 * NOTE: There is an errata says the full PEBS support
+	 * requires to check if associated counting logic if properly
+	 * configured, in short -- if an event requires some
+	 * additional uops tagging and friends it *must* be guaranted
+	 * the tagging is done properly otherwise the results are
+	 * unknown, for while there is no classic PEBS support but better
+	 * to keep this (potential) problem explicitly marked
+	 */
+
 	BUILD_BUG_ON(P4_PEBS_METRIC__max > P4_PEBS_CONFIG_METRIC_MASK);

 	idx = p4_config_unpack_metric(config);
@@ -866,8 +912,10 @@ static void p4_pmu_enable_event(struct p
 	escr_addr = (u64)bind->escr_msr[thread];

 	/*
-	 * - we dont support cascaded counters yet
-	 * - and counter 1 is broken (erratum)
+	 * In a sake of erratum:
+	 *  - cascaded counters do not work properly with
+	 *    force overflow flag set but take it wider
+	 *  - counter 1 is broken
 	 */
 	WARN_ON_ONCE(p4_is_event_cascaded(hwc->config));
 	WARN_ON_ONCE(hwc->idx == 1);
