Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0HQPWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:22:39 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16098 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0HQPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:22:37 -0400
X-SpamScore: 18
X-BigFish: VPS18(z3cfcs329eqz936eKzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7AYPB-02-30C-02
X-M-MSG: 
Date: Tue, 17 Aug 2010 17:22:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100817152225.GQ26154@erda.amd.com>
References: <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100809194829.GB26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

this is version 3 without timestamp code. Compared to -v1 it
implements the handling for 2-1-0 nmi sequences.

-Robert

>From 71a206394d8a3536b033247ec14ad037fef77236 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 17 Aug 2010 16:42:03 +0200
Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs

When perfctrs are running it is valid to have unhandled nmis, two
events could trigger 'simultaneously' raising two back-to-back
NMIs. If the first NMI handles both, the latter will be empty and daze
the CPU.

The solution to avoid an 'unknown nmi' massage in this case was simply
to stop the nmi handler chain when perfctrs are runnning by stating
the nmi was handled. This has the drawback that a) we can not detect
unknown nmis anymore, and b) subsequent nmi handlers are not called.

This patch addresses this. Now, we check this unknown NMI if it could
be a perfctr back-to-back NMI. Otherwise we pass it and let the kernel
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

The perfctr nmi handler was handling more than one counter and no
counter was handled in the subsequent nmi (see [1] and [2] above).

There is another case if there are two subsequent back-to-back nmis
[3]. The 2nd is detected as back-to-back because the first handled
more than one counter. If the second handles one counter and the 3rd
handles nothing, we drop the 3rd nmi because it could be a
back-to-back nmi.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   65 ++++++++++++++++++++++++++++++-------
 1 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..bbcc89e 100644
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
 
+struct perfctr_nmi {
+	unsigned int	marked;
+	int		handled;
+};
+
+static DEFINE_PER_CPU(struct perfctr_nmi, nmi);
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
@@ -1214,22 +1222,53 @@ perf_event_nmi_handler(struct notifier_block *self,
 	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
-
+	case DIE_NMIUNKNOWN:
+		this_nmi = percpu_read(irq_stat.__nmi_count);
+		if (this_nmi != __get_cpu_var(nmi).marked)
+			/* let the kernel handle the unknown nmi */
+			return NOTIFY_DONE;
+		/*
+		 * This one is a perfctr back-to-back nmi. Two events
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
+	if (handled > 1)
+		goto mark_nmi;
+	if ((__get_cpu_var(nmi).marked == this_nmi)
+	    && (__get_cpu_var(nmi).handled > 1))
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
+		goto mark_nmi;
+
+	/* this may not trigger back-to-back nmis */
+	return NOTIFY_STOP;
+
+ mark_nmi:
+	/* the next nmi could be a back-to-back nmi */
+	__get_cpu_var(nmi).marked	= this_nmi + 1;
+	__get_cpu_var(nmi).handled	= handled;
 
 	return NOTIFY_STOP;
 }
-- 
1.7.1.1

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

