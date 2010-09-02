Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0IBTIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab0IBTIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:08:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] perf, x86: Try to handle unknown nmis with an enabled PMU
Date: Thu,  2 Sep 2010 15:07:48 -0400
Message-Id: <1283454469-1909-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

When the PMU is enabled it is valid to have unhandled nmis, two
events could trigger 'simultaneously' raising two back-to-back
NMIs. If the first NMI handles both, the latter will be empty and daze
the CPU.

The solution to avoid an 'unknown nmi' massage in this case was simply
to stop the nmi handler chain when the PMU is enabled by stating
the nmi was handled. This has the drawback that a) we can not detect
unknown nmis anymore, and b) subsequent nmi handlers are not called.

This patch addresses this. Now, we check this unknown NMI if it could
be a PMU back-to-back NMI. Otherwise we pass it and let the kernel
handle the unknown nmi.

This is a debug log:

cpu #6, nmi #32333, skip_nmi #32330, handled = 1, time = 1934364430
cpu #6, nmi #32334, skip_nmi #32330, handled = 1, time = 1934704616
cpu #6, nmi #32335, skip_nmi #32336, handled = 2, time = 1936032320
cpu #6, nmi #32336, skip_nmi #32336, handled = 0, time = 1936034139
cpu #6, nmi #32337, skip_nmi #32336, handled = 1, time = 1936120100
cpu #6, nmi #32338, skip_nmi #32336, handled = 1, time = 1936404607
cpu #6, nmi #32339, skip_nmi #32336, handled = 1, time = 1937983416
cpu #6, nmi #32340, skip_nmi #32341, handled = 2, time = 1938201032
cpu #6, nmi #32341, skip_nmi #32341, handled = 0, time = 1938202830
cpu #6, nmi #32342, skip_nmi #32341, handled = 1, time = 1938443743
cpu #6, nmi #32343, skip_nmi #32341, handled = 1, time = 1939956552
cpu #6, nmi #32344, skip_nmi #32341, handled = 1, time = 1940073224
cpu #6, nmi #32345, skip_nmi #32341, handled = 1, time = 1940485677
cpu #6, nmi #32346, skip_nmi #32347, handled = 2, time = 1941947772
cpu #6, nmi #32347, skip_nmi #32347, handled = 1, time = 1941949818
cpu #6, nmi #32348, skip_nmi #32347, handled = 0, time = 1941951591
Uhhuh. NMI received for unknown reason 00 on CPU 6.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue

Deltas:

nmi #32334 340186
nmi #32335 1327704
nmi #32336 1819      <<<< back-to-back nmi [1]
nmi #32337 85961
nmi #32338 284507
nmi #32339 1578809
nmi #32340 217616
nmi #32341 1798      <<<< back-to-back nmi [2]
nmi #32342 240913
nmi #32343 1512809
nmi #32344 116672
nmi #32345 412453
nmi #32346 1462095   <<<< 1st nmi (standard) handling 2 counters
nmi #32347 2046      <<<< 2nd nmi (back-to-back) handling one counter
nmi #32348 1773      <<<< 3rd nmi (back-to-back) handling no counter! [3]

For  back-to-back nmi detection there are the following rules:

The PMU nmi handler was handling more than one counter and no
counter was handled in the subsequent nmi (see [1] and [2] above).

There is another case if there are two subsequent back-to-back nmis
[3]. The 2nd is detected as back-to-back because the first handled
more than one counter. If the second handles one counter and the 3rd
handles nothing, we drop the 3rd nmi because it could be a
back-to-back nmi.

[ dz - renamed nmi variable to pmu_nmi to avoid clash with .nmi in
  entry.S ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100817152225.GQ26154@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   59 +++++++++++++++++++++++++++++--------
 1 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..3efdf28 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1154,7 +1154,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		/*
 		 * event overflow
 		 */
-		handled		= 1;
+		handled++;
 		data.period	= event->hw.last_period;
 
 		if (!x86_perf_event_set_period(event))
@@ -1200,12 +1200,20 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
+struct pmu_nmi_state {
+	unsigned int	marked;
+	int		handled;
+};
+
+static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
+
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
 			 unsigned long cmd, void *__args)
 {
 	struct die_args *args = __args;
-	struct pt_regs *regs;
+	unsigned int this_nmi;
+	int handled;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1214,22 +1222,47 @@ perf_event_nmi_handler(struct notifier_block *self,
 	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
-
+	case DIE_NMIUNKNOWN:
+		this_nmi = percpu_read(irq_stat.__nmi_count);
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
+			/* let the kernel handle the unknown nmi */
+			return NOTIFY_DONE;
+		/*
+		 * This one is a PMU back-to-back nmi. Two events
+		 * trigger 'simultaneously' raising two back-to-back
+		 * NMIs. If the first NMI handles both, the latter
+		 * will be empty and daze the CPU. So, we drop it to
+		 * avoid false-positive 'unknown nmi' messages.
+		 */
+		return NOTIFY_STOP;
 	default:
 		return NOTIFY_DONE;
 	}
 
-	regs = args->regs;
-
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	/*
-	 * Can't rely on the handled return value to say it was our NMI, two
-	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
-	 *
-	 * If the first NMI handles both, the latter will be empty and daze
-	 * the CPU.
-	 */
-	x86_pmu.handle_irq(regs);
+
+	handled = x86_pmu.handle_irq(args->regs);
+	if (!handled)
+		return NOTIFY_DONE;
+
+	this_nmi = percpu_read(irq_stat.__nmi_count);
+	if ((handled > 1) ||
+		/* the next nmi could be a back-to-back nmi */
+	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
+	     (__get_cpu_var(pmu_nmi).handled > 1))) {
+		/*
+		 * We could have two subsequent back-to-back nmis: The
+		 * first handles more than one counter, the 2nd
+		 * handles only one counter and the 3rd handles no
+		 * counter.
+		 *
+		 * This is the 2nd nmi because the previous was
+		 * handling more than one counter. We will mark the
+		 * next (3rd) and then drop it if unhandled.
+		 */
+		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
+		__get_cpu_var(pmu_nmi).handled	= handled;
+	}
 
 	return NOTIFY_STOP;
 }
-- 
1.7.2.2

