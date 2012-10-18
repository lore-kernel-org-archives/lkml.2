Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab2JRX0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:26:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:16007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab2JRXTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="206293158"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 29/34] perf, x86: Add Haswell TSX event aliases
Date: Thu, 18 Oct 2012 16:19:37 -0700
Message-Id: <1350602382-12771-30-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add infrastructure to generate event aliases in /sys/devices/cpu/events/

And use this to set up user friendly aliases for the common TSX events.
TSX tuning relies heavily on the PMU, so it's important to be user friendly.

This replaces the generic transaction events in an earlier version
of this patchkit.

tx-start/commit/abort  to count RTM transactions
el-start/commit/abort  to count HLE ("elision") transactions
tx-conflict/overflow   to count conflict/overflow for both combined.

The general abort events exist in precise and non precise variants
Since the common case is sampling plain "tx-aborts" in precise.

This is very important because abort sampling only really works
with PEBS enabled, otherwise it would report the IP after the abort,
not the abort point. But counting with PEBS has more overhead,
so also have tx/el-abort-count aliases that do not enable PEBS
for perf stat.

It would be nice to switch automatically between those two, like in the
previous version, but that would need more new infrastructure for sysfs
first.

There is an tx-abort<->tx-aborts alias too, because I found myself
using both variants.

Also added friendly aliases for cpu/cycles,intx=1/ and
cpu/cycles,intx=1,intx_cp=1/ and the same for instructions.
These will be used by perf stat -T, and are also useful for users directly.

So for example to get transactional cycles can use "perf stat -e cycles-t"

Some of the sysfs macros/functions could probably move to generic code, but
I left it in the Intel code for now until there are more users.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   95 ++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 878814a..94389a9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2041,6 +2041,99 @@ static __init void intel_gen_arch_events(void)
 	x86_pmu.events_attrs = intel_arch_events;
 }
 
+struct sevent_attribute {
+	struct device_attribute		attr;
+	const char			*val;
+};
+
+#define PMU_EVENT(_name, _id, _val)					\
+	static struct sevent_attribute attr_ ## _name =			\
+	{ .attr =							\
+	  { .attr = { .name = _id, .mode = 0444 },			\
+	    .show = show_sevent },					\
+	  .val = _val }
+
+static ssize_t show_sevent(struct device *dev,
+			  struct device_attribute *attr,
+			  char *page)
+{
+	struct sevent_attribute *e = container_of(attr, struct sevent_attribute, attr);
+
+	return sprintf(page, "%s", e->val);
+}
+
+/* Haswell special events */
+PMU_EVENT(tx_start,       "tx-start",       "event=0xc9,umask=0x1");
+PMU_EVENT(tx_commit,      "tx-commit",      "event=0xc9,umask=0x2");
+PMU_EVENT(tx_abort,       "tx-abort",       "event=0xc9,umask=0x4,precise=2");
+PMU_EVENT(tx_abort_count, "tx-abort-count", "event=0xc9,umask=0x4");
+/* alias */
+PMU_EVENT(tx_aborts,      "tx-aborts",      "event=0xc9,umask=0x4,precise=2");
+PMU_EVENT(tx_capacity,    "tx-capacity",    "event=0x54,umask=0x2");
+PMU_EVENT(tx_conflict,    "tx-conflict",    "event=0x54,umask=0x1");
+PMU_EVENT(el_start,       "el-start",       "event=0xc8,umask=0x1");
+PMU_EVENT(el_commit,      "el-commit",      "event=0xc8,umask=0x2");
+PMU_EVENT(el_abort,       "el-abort",       "event=0xc8,umask=0x4,precise=2");
+PMU_EVENT(el_abort_count, "el-abort-count", "event=0xc8,umask=0x4");
+/* alias */
+PMU_EVENT(el_aborts,      "el-aborts",      "event=0xc8,umask=0x4,precise=2");
+/* shared with tx-* */
+PMU_EVENT(el_capacity,    "el-capacity",    "event=0x54,umask=0x2");
+/* shared with tx-* */
+PMU_EVENT(el_conflict,    "el-conflict",    "event=0x54,umask=0x1");
+PMU_EVENT(cycles_t,       "cycles-t",       "event=0x3c,intx=1");
+PMU_EVENT(cycles_ct,      "cycles-ct",      "event=0x3c,intx=1,intx_cp=1");
+PMU_EVENT(insns_t,        "instructions-t", "event=0xc0,intx=1");
+PMU_EVENT(insns_ct,       "instructions-ct","event=0xc0,intx=1,intx_cp=1");
+
+#define PMU_EVENT_PTR(x) &attr_ ## x .attr.attr
+
+static struct attribute *hsw_events_attrs[] = {
+	PMU_EVENT_PTR(tx_start),
+	PMU_EVENT_PTR(tx_commit),
+	PMU_EVENT_PTR(tx_abort),
+	PMU_EVENT_PTR(tx_aborts),
+	PMU_EVENT_PTR(tx_abort_count),
+	PMU_EVENT_PTR(tx_capacity),
+	PMU_EVENT_PTR(tx_conflict),
+	PMU_EVENT_PTR(el_start),
+	PMU_EVENT_PTR(el_commit),
+	PMU_EVENT_PTR(el_abort),
+	PMU_EVENT_PTR(el_aborts),
+	PMU_EVENT_PTR(el_abort_count),
+	PMU_EVENT_PTR(el_capacity),
+	PMU_EVENT_PTR(el_conflict),
+	PMU_EVENT_PTR(cycles_t),
+	PMU_EVENT_PTR(cycles_ct),
+	PMU_EVENT_PTR(insns_t),
+	PMU_EVENT_PTR(insns_ct),
+	NULL
+};
+
+/* Merge two pointer arrays */
+static __init struct attribute **merge_attr(struct attribute **a,
+					    struct attribute **b)
+{
+	struct attribute **new;
+	int j, i;
+
+	for (j = 0; a[j]; j++)
+		;
+	for (i = 0; b[i]; i++)
+		j++;
+	j++;
+	new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
+	if (!new)
+		return a;
+	j = 0;
+	for (i = 0; a[i]; i++)
+		new[j++] = a[i];
+	for (i = 0; b[i]; i++)
+		new[j++] = b[i];
+	new[j] = NULL;
+	return new;
+}
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2268,6 +2361,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.format_attrs = intel_hsw_formats_attr;
 		x86_pmu.memory_lat_events = intel_hsw_memory_latency_events;
+		x86_pmu.events_attrs = merge_attr(x86_pmu.events_attrs,
+						  hsw_events_attrs);
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

