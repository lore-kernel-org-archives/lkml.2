Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2DBSVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:21:01 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:24354
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab2DBSUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X7-02-33Q-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/12] perf/x86-ibs: Take instruction pointer from ibs sample
Date: Mon, 2 Apr 2012 20:19:11 +0200
Message-ID: <1333390758-10893-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each IBS sample contains a linear address of the instruction that
caused the sample to trigger. This address is more precise than the
rip that was taken from the interrupt handler's stack. Update the rip
with that address. We use this in the next patch to implement
precise-event sampling on AMD systems using IBS.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h        |    6 ++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   48 +++++++++++++++++++----------
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 9cf6696..651172d 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -157,6 +157,7 @@ struct x86_pmu_capability {
 #define IBS_CAPS_OPCNT			(1U<<4)
 #define IBS_CAPS_BRNTRGT		(1U<<5)
 #define IBS_CAPS_OPCNTEXT		(1U<<6)
+#define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
@@ -169,14 +170,14 @@ struct x86_pmu_capability {
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
@@ -184,6 +185,7 @@ struct x86_pmu_capability {
 #define IBS_OP_ENABLE		(1ULL<<17)
 #define IBS_OP_MAX_CNT		0x0000FFFFULL
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
+#define IBS_RIP_INVALID		(1ULL<<38)
 
 extern u32 get_ibs_caps(void);
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index eec3ea2..0321b64 100644
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
-- 
1.7.8.4


