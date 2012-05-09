Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab2EIOd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:33:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab2EIOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:33:27 -0400
Date: Wed, 9 May 2012 07:33:14 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-d47e8238cd76f1ffa7c8cd30e08b8e9074fd597e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-6-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Take instruction pointer from ibs sample
Git-Commit-ID: d47e8238cd76f1ffa7c8cd30e08b8e9074fd597e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:33:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d47e8238cd76f1ffa7c8cd30e08b8e9074fd597e
Gitweb:     http://git.kernel.org/tip/d47e8238cd76f1ffa7c8cd30e08b8e9074fd597e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:13 +0200

perf/x86-ibs: Take instruction pointer from ibs sample

Each IBS sample contains a linear address of the instruction that
caused the sample to trigger. This address is more precise than the
rip that was taken from the interrupt handler's stack. Update the rip
with that address. We use this in the next patch to implement
precise-event sampling on AMD systems using IBS.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-6-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h        |    6 ++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   48 +++++++++++++++++++----------
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8a3c75d..4e40a64 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -158,6 +158,7 @@ struct x86_pmu_capability {
 #define IBS_CAPS_OPCNT			(1U<<4)
 #define IBS_CAPS_BRNTRGT		(1U<<5)
 #define IBS_CAPS_OPCNTEXT		(1U<<6)
+#define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
@@ -170,14 +171,14 @@ struct x86_pmu_capability {
 #define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
 #define IBSCTL_LVT_OFFSET_MASK		0x0F
 
-/* IbsFetchCtl bits/masks */
+/* ibs fetch bits/masks */
 #define IBS_FETCH_RAND_EN	(1ULL<<57)
 #define IBS_FETCH_VAL		(1ULL<<49)
 #define IBS_FETCH_ENABLE	(1ULL<<48)
 #define IBS_FETCH_CNT		0xFFFF0000ULL
 #define IBS_FETCH_MAX_CNT	0x0000FFFFULL
 
-/* IbsOpCtl bits */
+/* ibs op bits/masks */
 /* lower 4 bits of the current count are ignored: */
 #define IBS_OP_CUR_CNT		(0xFFFF0ULL<<32)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
@@ -185,6 +186,7 @@ struct x86_pmu_capability {
 #define IBS_OP_ENABLE		(1ULL<<17)
 #define IBS_OP_MAX_CNT		0x0000FFFFULL
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
+#define IBS_RIP_INVALID		(1ULL<<38)
 
 extern u32 get_ibs_caps(void);
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index bc401bd..cc1f329 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -9,6 +9,7 @@
 #include <linux/perf_event.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/ptrace.h>
 
 #include <asm/apic.h>
 
@@ -382,7 +383,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	struct perf_raw_record raw;
 	struct pt_regs regs;
 	struct perf_ibs_data ibs_data;
-	int offset, size, overflow, reenable;
+	int offset, size, check_rip, offset_max, throttle = 0;
 	unsigned int msr;
 	u64 *buf, config;
 
@@ -413,28 +414,41 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0, hwc->last_period);
+	if (!perf_ibs_set_period(perf_ibs, hwc, &config))
+		goto out;	/* no sw counter overflow */
+
+	ibs_data.caps = ibs_caps;
+	size = 1;
+	offset = 1;
+	check_rip = (perf_ibs == &perf_ibs_op && (ibs_caps & IBS_CAPS_RIPINVALIDCHK));
+	if (event->attr.sample_type & PERF_SAMPLE_RAW)
+		offset_max = perf_ibs->offset_max;
+	else if (check_rip)
+		offset_max = 2;
+	else
+		offset_max = 1;
+	do {
+		rdmsrl(msr + offset, *buf++);
+		size++;
+		offset = find_next_bit(perf_ibs->offset_mask,
+				       perf_ibs->offset_max,
+				       offset + 1);
+	} while (offset < offset_max);
+	ibs_data.size = sizeof(u64) * size;
+
+	regs = *iregs;
+	if (!check_rip || !(ibs_data.regs[2] & IBS_RIP_INVALID))
+		instruction_pointer_set(&regs, ibs_data.regs[1]);
 
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-		ibs_data.caps = ibs_caps;
-		size = 1;
-		offset = 1;
-		do {
-		    rdmsrl(msr + offset, *buf++);
-		    size++;
-		    offset = find_next_bit(perf_ibs->offset_mask,
-					   perf_ibs->offset_max,
-					   offset + 1);
-		} while (offset < perf_ibs->offset_max);
-		raw.size = sizeof(u32) + sizeof(u64) * size;
+		raw.size = sizeof(u32) + ibs_data.size;
 		raw.data = ibs_data.data;
 		data.raw = &raw;
 	}
 
-	regs = *iregs; /* XXX: update ip from ibs sample */
-
-	overflow = perf_ibs_set_period(perf_ibs, hwc, &config);
-	reenable = !(overflow && perf_event_overflow(event, &data, &regs));
-	config = (config >> 4) | (reenable ? perf_ibs->enable_mask : 0);
+	throttle = perf_event_overflow(event, &data, &regs);
+out:
+	config = (config >> 4) | (throttle ? 0 : perf_ibs->enable_mask);
 	perf_ibs_enable_event(hwc, config);
 
 	perf_event_update_userpage(event);
