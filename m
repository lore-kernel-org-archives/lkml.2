Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0IPRfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:35:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:52086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0IPRfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:35:18 -0400
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <20100915162034.GO13563@erda.amd.com>
References: <1284118900.402.35.camel@laptop>
	 <20100910132741.GB4879@redhat.com> <20100910144634.GA1060@elte.hu>
	 <20100910155659.GD13563@erda.amd.com> <20100911094157.GA11521@elte.hu>
	 <20100911114404.GE13563@erda.amd.com> <20100911124537.GA22850@elte.hu>
	 <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com>
	 <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 19:34:40 +0200
Message-ID: <1284658480.2275.589.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 18:20 +0200, Robert Richter wrote:
> Some cpus still deliver spurious interrupts after disabling a counter.
> This caused 'undelivered NMI' messages. This patch fixes this.
> 
I tried the below and that also seems to work.. So yeah, looks like
we're getting late NMIs.

---
 arch/x86/kernel/cpu/perf_event.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0fb1705..9a261ac 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1145,6 +1145,22 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
+static int fixup_overflow(int idx)
+{
+	u64 val;
+
+	rdmsrl(x86_pmu.perfctr + idx, val);
+	if (!(val & (1ULL << (x86_pmu.cntval_bits - 1)))) {
+		val = (u64)(-x86_pmu.max_period);
+		val &= x86_pmu.cntval_mask;
+		wrmsrl(x86_pmu.perfctr + idx, val);
+
+		return 1;
+	}
+
+	return 0;
+}
+
 static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
@@ -1159,8 +1175,11 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+	       		if (fixup_overflow(idx))
+				handled++;
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;

