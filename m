Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2CHMZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:25:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab2CHMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:25:30 -0500
Date: Thu, 8 Mar 2012 04:24:45 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-db98c5faf8cb350212ea3af786cb3ba0d4e7a01e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323968199-9326-5-git-send-email-robert.richter@amd.com>
References: <1323968199-9326-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86-ibs] perf/x86:
  Implement 64-bit counter support for IBS
Git-Commit-ID: db98c5faf8cb350212ea3af786cb3ba0d4e7a01e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 04:25:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db98c5faf8cb350212ea3af786cb3ba0d4e7a01e
Gitweb:     http://git.kernel.org/tip/db98c5faf8cb350212ea3af786cb3ba0d4e7a01e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:56:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 11:35:22 +0100

perf/x86: Implement 64-bit counter support for IBS

This patch implements 64 bit counter support for IBS. The
sampling period is no longer limited to the hw counter width.

The functions perf_event_set_period() and
perf_event_try_update() can be used as generic functions. They
can replace similar code that is duplicate across architectures.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323968199-9326-5-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h        |    2 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  204 +++++++++++++++++++++++++++---
 2 files changed, 185 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e8fb2c7..9cf6696 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -177,6 +177,8 @@ struct x86_pmu_capability {
 #define IBS_FETCH_MAX_CNT	0x0000FFFFULL
 
 /* IbsOpCtl bits */
+/* lower 4 bits of the current count are ignored: */
+#define IBS_OP_CUR_CNT		(0xFFFF0ULL<<32)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
 #define IBS_OP_VAL		(1ULL<<18)
 #define IBS_OP_ENABLE		(1ULL<<17)
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 40a6d9d..573d248 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -44,9 +44,11 @@ struct perf_ibs {
 	u64		cnt_mask;
 	u64		enable_mask;
 	u64		valid_mask;
+	u64		max_period;
 	unsigned long	offset_mask[1];
 	int		offset_max;
 	struct cpu_perf_ibs __percpu *pcpu;
+	u64		(*get_count)(u64 config);
 };
 
 struct perf_ibs_data {
@@ -58,6 +60,78 @@ struct perf_ibs_data {
 	u64		regs[MSR_AMD64_IBS_REG_COUNT_MAX];
 };
 
+static int
+perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *count)
+{
+	s64 left = local64_read(&hwc->period_left);
+	s64 period = hwc->sample_period;
+	int overflow = 0;
+
+	/*
+	 * If we are way outside a reasonable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		overflow = 1;
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		overflow = 1;
+	}
+
+	if (unlikely(left < min))
+		left = min;
+
+	if (left > max)
+		left = max;
+
+	*count = (u64)left;
+
+	return overflow;
+}
+
+static  int
+perf_event_try_update(struct perf_event *event, u64 new_raw_count, int width)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int shift = 64 - width;
+	u64 prev_raw_count;
+	u64 delta;
+
+	/*
+	 * Careful: an NMI might modify the previous event value.
+	 *
+	 * Our tactic to handle this is to first atomically read and
+	 * exchange a new raw count - then add that new-prev delta
+	 * count to the generic event atomically:
+	 */
+	prev_raw_count = local64_read(&hwc->prev_count);
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					new_raw_count) != prev_raw_count)
+		return 0;
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (event-)time and add that to the generic event.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count.
+	 */
+	delta = (new_raw_count << shift) - (prev_raw_count << shift);
+	delta >>= shift;
+
+	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
+
+	return 1;
+}
+
 static struct perf_ibs perf_ibs_fetch;
 static struct perf_ibs perf_ibs_op;
 
@@ -91,18 +165,14 @@ static int perf_ibs_init(struct perf_event *event)
 		if (hwc->sample_period & 0x0f)
 			/* lower 4 bits can not be set in ibs max cnt */
 			return -EINVAL;
-		max_cnt = hwc->sample_period >> 4;
-		if (max_cnt & ~perf_ibs->cnt_mask)
-			/* out of range */
-			return -EINVAL;
-		config |= max_cnt;
 	} else {
 		max_cnt = config & perf_ibs->cnt_mask;
+		config &= ~perf_ibs->cnt_mask;
 		event->attr.sample_period = max_cnt << 4;
 		hwc->sample_period = event->attr.sample_period;
 	}
 
-	if (!max_cnt)
+	if (!hwc->sample_period)
 		return -EINVAL;
 
 	hwc->config_base = perf_ibs->msr;
@@ -111,16 +181,71 @@ static int perf_ibs_init(struct perf_event *event)
 	return 0;
 }
 
+static int perf_ibs_set_period(struct perf_ibs *perf_ibs,
+			       struct hw_perf_event *hwc, u64 *period)
+{
+	int ret;
+
+	/* ignore lower 4 bits in min count: */
+	ret = perf_event_set_period(hwc, 1<<4, perf_ibs->max_period, period);
+	local64_set(&hwc->prev_count, 0);
+
+	return ret;
+}
+
+static u64 get_ibs_fetch_count(u64 config)
+{
+	return (config & IBS_FETCH_CNT) >> 12;
+}
+
+static u64 get_ibs_op_count(u64 config)
+{
+	return (config & IBS_OP_CUR_CNT) >> 32;
+}
+
+static void
+perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
+		      u64 config)
+{
+	u64 count = perf_ibs->get_count(config);
+
+	while (!perf_event_try_update(event, count, 20)) {
+		rdmsrl(event->hw.config_base, config);
+		count = perf_ibs->get_count(config);
+	}
+}
+
+/* Note: The enable mask must be encoded in the config argument. */
+static inline void perf_ibs_enable_event(struct hw_perf_event *hwc, u64 config)
+{
+	wrmsrl(hwc->config_base, hwc->config | config);
+}
+
+/*
+ * We cannot restore the ibs pmu state, so we always needs to update
+ * the event while stopping it and then reset the state when starting
+ * again. Thus, ignoring PERF_EF_RELOAD and PERF_EF_UPDATE flags in
+ * perf_ibs_start()/perf_ibs_stop() and instead always do it.
+ */
 static void perf_ibs_start(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+	u64 config;
 
-	if (test_and_set_bit(IBS_STARTED, pcpu->state))
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
 		return;
 
-	wrmsrl(hwc->config_base, hwc->config | perf_ibs->enable_mask);
+	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+	hwc->state = 0;
+
+	perf_ibs_set_period(perf_ibs, hwc, &config);
+	config = (config >> 4) | perf_ibs->enable_mask;
+	set_bit(IBS_STARTED, pcpu->state);
+	perf_ibs_enable_event(hwc, config);
+
+	perf_event_update_userpage(event);
 }
 
 static void perf_ibs_stop(struct perf_event *event, int flags)
@@ -129,15 +254,28 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
 	u64 val;
+	int stopping;
 
-	if (!test_and_clear_bit(IBS_STARTED, pcpu->state))
-		return;
+	stopping = test_and_clear_bit(IBS_STARTED, pcpu->state);
 
-	set_bit(IBS_STOPPING, pcpu->state);
+	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
+		return;
 
 	rdmsrl(hwc->config_base, val);
-	val &= ~perf_ibs->enable_mask;
-	wrmsrl(hwc->config_base, val);
+
+	if (stopping) {
+		set_bit(IBS_STOPPING, pcpu->state);
+		val &= ~perf_ibs->enable_mask;
+		wrmsrl(hwc->config_base, val);
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+	}
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	perf_ibs_event_update(perf_ibs, event, val);
+	hwc->state |= PERF_HES_UPTODATE;
 }
 
 static int perf_ibs_add(struct perf_event *event, int flags)
@@ -148,6 +286,8 @@ static int perf_ibs_add(struct perf_event *event, int flags)
 	if (test_and_set_bit(IBS_ENABLED, pcpu->state))
 		return -ENOSPC;
 
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
 	pcpu->event = event;
 
 	if (flags & PERF_EF_START)
@@ -164,9 +304,11 @@ static void perf_ibs_del(struct perf_event *event, int flags)
 	if (!test_and_clear_bit(IBS_ENABLED, pcpu->state))
 		return;
 
-	perf_ibs_stop(event, 0);
+	perf_ibs_stop(event, PERF_EF_UPDATE);
 
 	pcpu->event = NULL;
+
+	perf_event_update_userpage(event);
 }
 
 static void perf_ibs_read(struct perf_event *event) { }
@@ -187,8 +329,11 @@ static struct perf_ibs perf_ibs_fetch = {
 	.cnt_mask		= IBS_FETCH_MAX_CNT,
 	.enable_mask		= IBS_FETCH_ENABLE,
 	.valid_mask		= IBS_FETCH_VAL,
+	.max_period		= IBS_FETCH_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSFETCH_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSFETCH_REG_COUNT,
+
+	.get_count		= get_ibs_fetch_count,
 };
 
 static struct perf_ibs perf_ibs_op = {
@@ -207,8 +352,11 @@ static struct perf_ibs perf_ibs_op = {
 	.cnt_mask		= IBS_OP_MAX_CNT,
 	.enable_mask		= IBS_OP_ENABLE,
 	.valid_mask		= IBS_OP_VAL,
+	.max_period		= IBS_OP_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSOP_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSOP_REG_COUNT,
+
+	.get_count		= get_ibs_op_count,
 };
 
 static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
@@ -220,9 +368,9 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	struct perf_raw_record raw;
 	struct pt_regs regs;
 	struct perf_ibs_data ibs_data;
-	int offset, size;
+	int offset, size, overflow, reenable;
 	unsigned int msr;
-	u64 *buf;
+	u64 *buf, config;
 
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
 		/* Catch spurious interrupts after stopping IBS: */
@@ -257,11 +405,25 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	regs = *iregs; /* XXX: update ip from ibs sample */
 
-	if (perf_event_overflow(event, &data, &regs))
-		; /* stop */
-	else
-		/* reenable */
-		wrmsrl(hwc->config_base, hwc->config | perf_ibs->enable_mask);
+	/*
+	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
+	 * supported in all cpus. As this triggered an interrupt, we
+	 * set the current count to the max count.
+	 */
+	config = ibs_data.regs[0];
+	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
+		config &= ~IBS_OP_CUR_CNT;
+		config |= (config & IBS_OP_MAX_CNT) << 36;
+	}
+
+	perf_ibs_event_update(perf_ibs, event, config);
+
+	overflow = perf_ibs_set_period(perf_ibs, hwc, &config);
+	reenable = !(overflow && perf_event_overflow(event, &data, &regs));
+	config = (config >> 4) | (reenable ? perf_ibs->enable_mask : 0);
+	perf_ibs_enable_event(hwc, config);
+
+	perf_event_update_userpage(event);
 
 	return 1;
 }
