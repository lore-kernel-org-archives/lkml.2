Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2EBS3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:29:13 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:5673
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674Ab2EBS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:29:11 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zzzz1202hzz8275bh5eeeKz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8L-01-6JS-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
Date: Wed, 2 May 2012 20:26:29 +0200
Message-ID: <1335983192-23731-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements support for IBS pseudo events. Pseudo events are
derived from an IBS sample and determined through a combination of one
or more IBS event flags or values. See here for a full description:

 Software Optimization Guide for AMD Family 15h Processors
 Appendix F Guide to Instruction-Based Sampling on AMD Family 15h Processors
 Advanced Micro Devices, Inc.
 Publication No. 47414, Revision 3.06
 January 2012
 http://support.amd.com/us/Processor_TechDocs/47414_15h_sw_opt_guide.pdf

The list of supported events is provided by perf-list. A pseudo event
can be set up like this:

 # perf record -a -e ibs_op:MISPREDICTED_BRANCH ...

The filter rules for IBS samples depending on a pseudo event are also
described in the document above. The filter is setup in the perf tool
pmu handler and passed to the kernel via config1/config2 attr values.
The interface is extendable to pass the pseudo events directly to the
kernel.

There are some pseudo events capable to count latencies or other
values. Counting values of such events is not yet supported.

This patch includes kernel and userland changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   83 ++++++-
 tools/perf/util/pmu-ibs.c                |  433 +++++++++++++++++++++++++-----
 2 files changed, 445 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 03743ad..1675479 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -478,6 +478,81 @@ static struct perf_ibs perf_ibs_op = {
 	.get_count		= get_ibs_op_count,
 };
 
+enum ibs_filter_type {
+	IBS_NO_FILTER		= 0,
+	IBS_MATCH_FILTER	= 1,
+	IBS_ANY_SET_FILTER	= 2,
+	IBS_PSEUDO_EVENT	= 0x0F,
+};
+
+struct ibs_filter {
+	struct {
+		u16		idx		: 8;
+		u16		reserved	: 4;
+		u16		type		: 4;
+	};
+	union {
+		struct {
+			u8	mask;
+			u8	match;
+		};
+		u16		any;
+	};
+};
+
+static bool
+__perf_ibs_sample_matches(struct ibs_filter *filter, void *data, int size)
+{
+	int left = size;
+
+	switch (filter->type) {
+	case IBS_MATCH_FILTER:
+		left -= sizeof(u8);
+		break;
+	case IBS_ANY_SET_FILTER:
+		left -= sizeof(u16);
+		break;
+	default:
+		return false;
+	}
+
+	left -= filter->idx;
+	if (left < 0)
+		return false;
+
+	switch (filter->type) {
+	case IBS_MATCH_FILTER:
+		return ((*(u8*)(data + filter->idx)) & filter->mask) == filter->match;
+	case IBS_ANY_SET_FILTER:
+		return (*(u16*)(data + filter->idx)) & filter->any;
+	};
+
+	return false;
+}
+
+static bool perf_ibs_sample_matches(struct perf_event *event,
+				    struct perf_ibs_data *data)
+{
+	int i;
+	union {
+		struct ibs_filter filter[4];
+		u64	config[2];
+	} f;
+	struct ibs_filter *filter = f.filter;
+
+	f.config[0] = event->attr.config1;
+	f.config[1] = event->attr.config2;
+
+	for (i = 0; i < 4; i++, filter++) {
+		if (filter->type == IBS_NO_FILTER)
+			break;
+		if (!__perf_ibs_sample_matches(filter, data->regs, data->size))
+			return false;
+	}
+
+	return true;
+}
+
 static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 {
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
@@ -487,7 +562,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	struct perf_raw_record raw;
 	struct pt_regs regs;
 	struct perf_ibs_data ibs_data;
-	int offset, size, check_rip, offset_max, throttle = 0;
+	int offset, size, check_rip, filter, offset_max, throttle = 0;
 	unsigned int msr;
 	u64 *buf, *config, period;
 
@@ -517,7 +592,8 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	size = 1;
 	offset = 1;
 	check_rip = (perf_ibs == &perf_ibs_op && (ibs_caps & IBS_CAPS_RIPINVALIDCHK));
-	if (event->attr.sample_type & PERF_SAMPLE_RAW)
+	filter = (event->attr.config1 != 0);
+	if (filter || (event->attr.sample_type & PERF_SAMPLE_RAW))
 		offset_max = perf_ibs->offset_max;
 	else if (check_rip)
 		offset_max = 2;
@@ -532,6 +608,9 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	} while (offset < offset_max);
 	ibs_data.size = sizeof(u64) * size;
 
+	if (filter && !perf_ibs_sample_matches(event, &ibs_data))
+		goto out;
+
 	regs = *iregs;
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
diff --git a/tools/perf/util/pmu-ibs.c b/tools/perf/util/pmu-ibs.c
index 07acb82..604cb8c 100644
--- a/tools/perf/util/pmu-ibs.c
+++ b/tools/perf/util/pmu-ibs.c
@@ -12,84 +12,378 @@
 #include <linux/compiler.h>
 #include "pmu.h"
 
-static const char *events[] = {
-	"ibs_fetch:2M_PAGE",
-	"ibs_fetch:4K_PAGE",
-	"ibs_fetch:ABORTED",
-	"ibs_fetch:ALL",
-	"ibs_fetch:ATTEMPTED",
-	"ibs_fetch:COMPLETED",
-	"ibs_fetch:ICACHE_HITS",
-	"ibs_fetch:ICACHE_MISSES",
-	"ibs_fetch:ITLB_HITS",
-	"ibs_fetch:KILLED",
-	"ibs_fetch:L1_ITLB_MISSES_L2_ITLB_HITS",
-	"ibs_fetch:L1_ITLB_MISSES_L2_ITLB_MISSES",
-	"ibs_fetch:LATENCY",
-	"ibs_op:ALL",
-	"ibs_op:ALL_LOAD_STORE",
-	"ibs_op:BANK_CONF_LOAD",
-	"ibs_op:BANK_CONF_STORE",
-	"ibs_op:BRANCH_RETIRED",
-	"ibs_op:CANCELLED",
-	"ibs_op:COMP_TO_RET",
-	"ibs_op:DATA_CACHE_MISS",
-	"ibs_op:DATA_HITS",
-	"ibs_op:DC_LOAD_LAT",
-	"ibs_op:DCUC_MEM_ACC",
-	"ibs_op:DCWC_MEM_ACC",
-	"ibs_op:FORWARD",
-	"ibs_op:L1_DTLB_1G",
-	"ibs_op:L1_DTLB_2M",
-	"ibs_op:L1_DTLB_4K",
-	"ibs_op:L1_DTLB_HITS",
-	"ibs_op:L1_DTLB_MISS_L2_DTLB_HIT",
-	"ibs_op:L1_L2_DTLB_MISS",
-	"ibs_op:L2_DTLB_1G",
-	"ibs_op:L2_DTLB_2M",
-	"ibs_op:L2_DTLB_4K",
-	"ibs_op:LOAD",
-	"ibs_op:LOCKED",
-	"ibs_op:MAB_HIT",
-	"ibs_op:MISALIGNED_DATA_ACC",
-	"ibs_op:MISPREDICTED_BRANCH",
-	"ibs_op:MISPREDICTED_BRANCH_TAKEN",
-	"ibs_op:MISPREDICTED_RETURNS",
-	"ibs_op:NB_CACHE_MODIFIED",
-	"ibs_op:NB_CACHE_OWNED",
-	"ibs_op:NB_LOCAL_CACHE",
-	"ibs_op:NB_LOCAL_CACHE_LAT",
-	"ibs_op:NB_LOCAL_DRAM",
-	"ibs_op:NB_LOCAL_L3",
-	"ibs_op:NB_LOCAL_ONLY",
-	"ibs_op:NB_LOCAL_OTHER",
-	"ibs_op:NB_REMOTE_CACHE",
-	"ibs_op:NB_REMOTE_CACHE_LAT",
-	"ibs_op:NB_REMOTE_DRAM",
-	"ibs_op:NB_REMOTE_ONLY",
-	"ibs_op:NB_REMOTE_OTHER",
-	"ibs_op:RESYNC",
-	"ibs_op:RETURNS",
-	"ibs_op:STORE",
-	"ibs_op:TAG_TO_RETIRE",
-	"ibs_op:TAKEN_BRANCH",
-	NULL
+enum ibs_filter_type {
+	IBS_NO_FILTER		= 0,
+	IBS_MATCH_FILTER	= 1,
+	IBS_ANY_SET_FILTER	= 2,
+	IBS_PSEUDO_EVENT	= 0x0F,
+};
+
+struct ibs_filter {
+	struct {
+		__u16		idx		: 8;
+		__u16		reserved	: 4;
+		__u16		type		: 4;
+	};
+	union {
+		struct {
+			__u8	mask;
+			__u8	match;
+		};
+		__u16		any;
+	};
+};
+
+struct ibs_event {
+	__u16			id;
+	const char		*name;
+	const char		*desc;
+	union {
+		__u16		pseudo_event;
+		__u64		config;
+		struct ibs_filter filter[2];
+	};
+};
+
+#define IBS_FETCH_CTL		0
+#define IBS_OP_DATA		2
+#define IBS_OP_DATA2		3
+#define IBS_OP_DATA3		4
+
+#define IBS_IDX(reg, bit)	((reg)<<3)+((bit)>>3)
+#define IBS_MASK(bit, m)	(0xFF&m)
+#define IBS_MASK16(bit, m)	(0xFFFF&m)
+#define IBS_FILTER_MATCH_ANY()	{ { 0, 0, 0 }, { .any = 0 } }
+
+#define IBS_FILTER_ANY_SET(reg, bit, m)				\
+	{							\
+		{						\
+		.type	= IBS_ANY_SET_FILTER,			\
+		.idx	= IBS_IDX(reg, bit),			\
+		.reserved = 0,					\
+		},{						\
+		.any	= IBS_MASK16(bit, m),			\
+		}						\
+	},
+
+#define IBS_FILTER_ALL_CLEAR(reg, bit, m)			\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg, bit),			\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit, m),			\
+		.match = 0,					\
+		}}						\
+	},							\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg, (bit) + 8),		\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit, (m) >> 8),		\
+		.match	= 0,					\
+		}}						\
+	},
+
+#define IBS_FILTER_ALL_SET(reg, bit, m)				\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg, bit),			\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit, m),			\
+		.match	= IBS_MASK(bit, m),			\
+		}}						\
+	},
+
+#define IBS_FILTER_MATCH(reg, bit, m, v)			\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg, bit),			\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit, m),			\
+		.match	= IBS_MASK(bit, v),			\
+		}}						\
+	},
+
+#define IBS_FILTER_MATCH2(reg, reg2, bit, bit2, m, m2, v, v2)	\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg, bit),			\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit, m),			\
+		.match	= IBS_MASK(bit, v),			\
+		}}						\
+	},							\
+	{							\
+		{						\
+		.type	= IBS_MATCH_FILTER,			\
+		.idx	= IBS_IDX(reg2, bit2),			\
+		.reserved = 0,					\
+		},{{						\
+		.mask	= IBS_MASK(bit2, m2),			\
+		.match	= IBS_MASK(bit2, v2),			\
+		}}						\
+	}
+
+#define IBS_EVENT(i, n, d)					\
+	{							\
+		.id 	= (i),					\
+		.name	= (n),					\
+		.desc	= (d),					\
+		{ .filter = { IBS_FILTER_##i } },		\
+	}
+#define IBS_FILTER(type, args...)		IBS_FILTER_##type(args)
+
+/*
+ * ID   Name                             Derivation
+ *
+ * F000 IBS fetch samples                Number of all IBS fetch samples
+ * F001 IBS fetch killed                 Number of killed IBS fetch samples
+ * F002 IBS fetch attempted              Number of non-killed IBS fetch samples
+ * F003 IBS fetch completed              IbsFetchComp
+ * F004 IBS fetch aborted                ~IbsFetchComp
+ * F005 IBS L1 ITLB hit                  ~IbsL1TlbMiss & IbsPhyAddrValid
+ * F006 IBS L1 ITLB miss, L2 ITLB hit    IbsL1TlbMiss & ~IbsL2TlbMiss
+ * F007 IBS L1 ITLB miss, L2 ITLB miss   IbsL1TlbMiss & IbsL2TlbMiss
+ * F008 IBS instruction cache miss       IbsIcMiss
+ * F009 IBS instruction cache hit        IbsFetchComp & ~IbsIcMiss
+ * F00A IBS 4K page translation          IbsL1TlbPgSz=0 & IbsPhyAddrValid
+ * F00B IBS 2M page translation          IbsL1TlbPgSz=1 & IbsPhyAddrValid
+ * F00C IBS 1G page translation          IbsL1TlbPgSz=2 & IbsPhyAddrValid
+ * F00D Reserved
+ * F00E IBS fetch latency                IbsfetchLat
+ */
+#define IBS_FILTER_0xf000 IBS_FILTER(MATCH_ANY)
+#define IBS_FILTER_0xf001 IBS_FILTER(ALL_CLEAR,	IBS_FETCH_CTL,	48, 0x019c)
+#define IBS_FILTER_0xf002 IBS_FILTER(ANY_SET,	IBS_FETCH_CTL,	48, 0x019c)
+#define IBS_FILTER_0xf003 IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x04, 0x04)
+#define IBS_FILTER_0xf004 IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x04, 0x00)
+#define IBS_FILTER_0xf005 IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x90, 0x10)
+#define IBS_FILTER_0xf006 IBS_FILTER(MATCH2,	IBS_FETCH_CTL, IBS_FETCH_CTL, 56, 48, 0x01, 0x80, 0x00, 0x80)
+#define IBS_FILTER_0xf007 IBS_FILTER(MATCH2,	IBS_FETCH_CTL, IBS_FETCH_CTL, 56, 48, 0x01, 0x80, 0x01, 0x80)
+#define IBS_FILTER_0xf008 IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x08, 0x08)
+#define IBS_FILTER_0xf009 IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x0C, 0x04)
+#define IBS_FILTER_0xf00a IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x70, 0x10)
+#define IBS_FILTER_0xf00b IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x70, 0x30)
+#define IBS_FILTER_0xf00c IBS_FILTER(MATCH,	IBS_FETCH_CTL,	48, 0x70, 0x60)
+#if 0
+#define IBS_FILTER_0xf00e IBS_FILTER(COUNT,	IBS_FETCH_CTL,	32, 0xffff)
+#endif
+
+/*
+ * ID   Name                             Derivation
+ *
+ * F100 IBS all op samples               Number of all IBS op samples
+ * F101 IBS tag to retire cycles         Sum of all tag to retire cycles
+ * F102 ibs completion to retire cycles  Sum of all completion to retire cycles
+ * F103 IBS branch op                    IbsOpBrnRet
+ * F104 IBS mispredicted branch op       IbsOpBrnRet & IbsOpBrnMisp
+ * F105 IBS taken branch op              IbsOpBrnRet & IbsOpBrnTaken
+ * F106 IBS mispredicted taken branch op IbsOpBrnRet & IbsOpBrnTaken & IbsOpBrnMisp
+ * F107 IBS return op                    IbsOpReturn
+ * F108 IBS mispredicted return op       IbsOpReturn & IbsOpMispReturn
+ * F109 IBS resync op                    IbsOpBrnResync
+ */
+#define IBS_FILTER_0xf100 IBS_FILTER(MATCH_ANY)
+#if 0
+#define IBS_FILTER_0xf101 IBS_FILTER(COUNT,	IBS_OP_DATA,	16, 0xffff)
+#define IBS_FILTER_0xf102 IBS_FILTER(COUNT,	IBS_OP_DATA,	 0, 0xffff)
+#endif
+#define IBS_FILTER_0xf103 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x20, 0x20)
+#define IBS_FILTER_0xf104 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x30, 0x30)
+#define IBS_FILTER_0xf105 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x28, 0x28)
+#define IBS_FILTER_0xf106 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x38, 0x38)
+#define IBS_FILTER_0xf107 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x04, 0x04)
+#define IBS_FILTER_0xf108 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x06, 0x06)
+#define IBS_FILTER_0xf109 IBS_FILTER(MATCH,	IBS_OP_DATA,	32, 0x01, 0x01)
+
+/*
+ * ID   Name                             Derivation
+ *
+ * F200 IBS All Load/Store Ops           IbsLdOp | IbsStOp
+ * F201 IBS Load Ops                     IbsLdOp
+ * F202 IBS Store Ops                    IbsStOp
+ * F203 IBS L1 DTLB Hit                  ~IbsDcL1tlbMiss & IbsDcLinAddrValid
+ * F204 IBS L1 DTLB Miss L2 DTLB Hit     IbsDcL1tlbMiss & ~IbsDcL2tlbMiss
+ * F205 IBS L1 DTLB Miss L2 DTLB Miss    IbsDcL1tlbMiss & IbsDcL2tlbMiss
+ * F206 IBS DC Miss                      IbsDcMiss
+ * F207 IBS DC Hit                       ~IbsDcMiss
+ * F208 IBS Misaligned Access            IbsDcMisAcc
+ * F209 IBS Bank Conflict On Load Op     IbsDcLdBnkCon
+ * F20A Reserved
+ * F20B IBS Store to Load Forwarded      IbsDcStToLdFwd
+ * F20C IBSStore to Load Forwarding Cancelled IbsDcStToLdCan
+ * F20D IBS UC memory access             IbsDcUcMemAcc
+ * F20E IBS WC memory access             IbsDcWcMemAcc
+ * F20F IBS locked operation             IbsDcLockedOp
+ * F210 IBS MAB hit                      IbsDcMabHit
+ * F211 IBS L1 DTLB 4K page              ~IbsDcL1tlbHit2M & ~IbsDcL1tlbHit1G &
+ *                                       IbsDcLinAddrValid
+ * F212 IBS L1 DTLB 2M page              IbsDcL1tlbHit2M & IbsDcLinAddrValid
+ * F213 IBS L1 DTLB 1G page              IbsDcL1tlbHit1G & IbsDcLinAddrValid
+ * F214 Reserved
+ * F215 IBS L2 DTLB 4K page              ~IbsDcL2tlbMiss & IbsDcL1tlbMiss &
+ *                                       ~IbsDcL1tlbHit2M & lbsDcLinAddrValid
+ * F216 IBS L2 DTLB 2M page              ~IbsDcL2tlbMiss & IbsDcL1tlbMiss &
+ *                                       IbsDcL1tlbHit2M & lbsDcLinAddrValid
+ * F217 Reserved
+ * F218 Reserved
+ * F219 IBS DC miss load latency         IbsDcMissLat when IbsLdOp & IbsDcMiss
+ */
+#define IBS_FILTER_0xf200 IBS_FILTER(ANY_SET,	IBS_OP_DATA3,	 0, 0x0003)
+#define IBS_FILTER_0xf201 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x01, 0x01)
+#define IBS_FILTER_0xf202 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x02, 0x02)
+#define IBS_FILTER_0xf203 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x04, 0x02, 0x00)
+#define IBS_FILTER_0xf204 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x0C, 0x08)
+#define IBS_FILTER_0xf205 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x0C, 0x0C)
+#define IBS_FILTER_0xf206 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x80, 0x80)
+#define IBS_FILTER_0xf207 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 0, 0x80, 0x00) IBS_FILTER(ANY_SET,   IBS_OP_DATA3,    0, 0x0003)
+#define IBS_FILTER_0xf208 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x01, 0x01)
+#define IBS_FILTER_0xf209 IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x02, 0x02)
+#define IBS_FILTER_0xf20b IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x08, 0x08)
+#define IBS_FILTER_0xf20c IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x10, 0x10)
+#define IBS_FILTER_0xf20d IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x40, 0x40)
+#define IBS_FILTER_0xf20e IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x20, 0x20)
+#define IBS_FILTER_0xf20f IBS_FILTER(MATCH,	IBS_OP_DATA3,	 8, 0x80, 0x80)
+#define IBS_FILTER_0xf210 IBS_FILTER(MATCH,	IBS_OP_DATA3,	16, 0x01, 0x01)
+#define IBS_FILTER_0xf211 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x30, 0x02, 0x00)
+#define IBS_FILTER_0xf212 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x10, 0x02, 0x10)
+#define IBS_FILTER_0xf213 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x20, 0x02, 0x20)
+#define IBS_FILTER_0xf215 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x1C, 0x02, 0x04)
+#define IBS_FILTER_0xf216 IBS_FILTER(MATCH2,	IBS_OP_DATA3, IBS_OP_DATA3, 16, 0, 0x02, 0x1C, 0x02, 0x14)
+#if 0
+#define IBS_FILTER_0xf219 IBS_FILTER(COUNT,	IBS_OP_DATA3,	32, 0x00FFFF, 0x00FFFF)
+#endif
+
+/*
+ * ID   Name                             Derivation
+ *
+ * F240 IBS NB local                     ~NbIbsReqDstProc
+ * F241 IBS NB remote                    NbIbsReqDstProc
+ * F242 IBS NB local L3                  NbIbsReqSrc=0x1 & ~NbIbsReqDstProc
+ * F243 IBS NB local L1/L2 (intercore)   NbIbsReqSrc=0x2 & ~NbIbsReqDstProc
+ * F244 IBS NB remote L1/L2/L3 cache     NbIbsReqSrc=0x2 & NbIbsReqDstProc
+ * F245 IBS NB local DRAM                NbIbsReqSrc=0x3 & ~NbIbsReqDstProc
+ * F246 IBS NB remote DRAM               NbIbsReqSrc=0x3 & NbIbsReqDstProc
+ * F247 IBS NB local other               NbIbsReqSrc=0x7 & ~NbIbsReqDstProc
+ * F248 IBS NB remote other              NbIbsReqSrc=0x7 & NbIbsReqDstProc
+ * F249 IBS NB cache M state             NbIbsReqSrc=0x2 & ~NbIbsReqCacheHitSt
+ * F24A IBS NB cache O state             NbIbsReqSrc=0x2 & NbIbsReqCacheHitSt
+ * F24B IBS NB local latency             IbsDcMissLat when ~NbIbsReqDstProc
+ * F24C IBS NB remote latency            IbsDcMissLat when NbIbsReqDstProc
+ */
+#define IBS_FILTER_0xf240 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x10, 0x00) IBS_FILTER(ANY_SET,	IBS_OP_DATA2,	0, 0x0007)
+#define IBS_FILTER_0xf241 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x10, 0x10) IBS_FILTER(ANY_SET,	IBS_OP_DATA2,	0, 0x0007)
+#define IBS_FILTER_0xf242 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x01) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf243 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x02) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf244 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x12) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf245 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x03) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf246 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x13) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf247 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x07) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf248 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x17, 0x17) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf249 IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x27, 0x02) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+#define IBS_FILTER_0xf24a IBS_FILTER(MATCH,	IBS_OP_DATA2,	 0, 0x27, 0x22) IBS_FILTER(MATCH,	IBS_OP_DATA3,	0, 0x81, 0x81)
+
+static struct ibs_event events[] = {
+	IBS_EVENT(0xf000, "ibs_fetch:ALL", "All IBS fetch samples"),
+	IBS_EVENT(0xf001, "ibs_fetch:KILLED", "IBS fetch killed"),
+	IBS_EVENT(0xf002, "ibs_fetch:ATTEMPTED", "IBS fetch attempted"),
+	IBS_EVENT(0xf003, "ibs_fetch:COMPLETED", "IBS fetch completed"),
+	IBS_EVENT(0xf004, "ibs_fetch:ABORTED", "IBS fetch aborted"),
+	IBS_EVENT(0xf005, "ibs_fetch:ITLB_HITS", "IBS ITLB hit"),
+	IBS_EVENT(0xf006, "ibs_fetch:L1_ITLB_MISSES_L2_ITLB_HITS", "IBS L1 ITLB misses (and L2 ITLB hits)"),
+	IBS_EVENT(0xf007, "ibs_fetch:L1_ITLB_MISSES_L2_ITLB_MISSES", "IBS L1 L2 ITLB miss"),
+	IBS_EVENT(0xf008, "ibs_fetch:ICACHE_MISSES", "IBS instruction cache misses"),
+	IBS_EVENT(0xf009, "ibs_fetch:ICACHE_HITS", "IBS instruction cache hit"),
+	IBS_EVENT(0xf00a, "ibs_fetch:4K_PAGE", "IBS 4K page translation"),
+	IBS_EVENT(0xf00b, "ibs_fetch:2M_PAGE", "IBS 2M page translation"),
+	IBS_EVENT(0xf00c, "ibs_fetch:1G_PAGE", "IBS 1G page translation"),
+#if 0
+	IBS_EVENT(0xf00e, "ibs_fetch:LATENCY", "IBS fetch latency"),
+#endif
+	IBS_EVENT(0xf100, "ibs_op:ALL", "All IBS op samples"),
+#if 0
+	IBS_EVENT(0xf101, "ibs_op:TAG_TO_RETIRE", "IBS tag-to-retire cycles"),
+	IBS_EVENT(0xf102, "ibs_op:COMP_TO_RET", "IBS completion-to-retire cycles"),
+#endif
+	IBS_EVENT(0xf103, "ibs_op:BRANCH_RETIRED", "IBS branch op"),
+	IBS_EVENT(0xf104, "ibs_op:MISPREDICTED_BRANCH", "IBS mispredicted branch op"),
+	IBS_EVENT(0xf105, "ibs_op:TAKEN_BRANCH", "IBS taken branch op"),
+	IBS_EVENT(0xf106, "ibs_op:MISPREDICTED_BRANCH_TAKEN", "IBS mispredicted taken branch op"),
+	IBS_EVENT(0xf107, "ibs_op:RETURNS", "IBS return op"),
+	IBS_EVENT(0xf108, "ibs_op:MISPREDICTED_RETURNS", "IBS mispredicted return op"),
+	IBS_EVENT(0xf109, "ibs_op:RESYNC", "IBS resync op"),
+	IBS_EVENT(0xf200, "ibs_op:ALL_LOAD_STORE", "IBS all load store ops"),
+	IBS_EVENT(0xf201, "ibs_op:LOAD", "IBS load ops"),
+	IBS_EVENT(0xf202, "ibs_op:STORE", "IBS store ops"),
+	IBS_EVENT(0xf203, "ibs_op:L1_DTLB_HITS", "IBS L1 DTLB hit"),
+	IBS_EVENT(0xf204, "ibs_op:L1_DTLB_MISS_L2_DTLB_HIT", "IBS L1 DTLB misses L2 hits"),
+	IBS_EVENT(0xf205, "ibs_op:L1_L2_DTLB_MISS", "IBS L1 and L2 DTLB misses"),
+	IBS_EVENT(0xf206, "ibs_op:DATA_CACHE_MISS", "IBS data cache misses"),
+	IBS_EVENT(0xf207, "ibs_op:DATA_HITS", "IBS data cache hits"),
+	IBS_EVENT(0xf208, "ibs_op:MISALIGNED_DATA_ACC", "IBS misaligned data access"),
+	IBS_EVENT(0xf209, "ibs_op:BANK_CONF_LOAD", "IBS bank conflict on load op"),
+#if 0
+	IBS_EVENT(0xf20a, "ibs_op:BANK_CONF_STORE", "IBS bank conflict on store op"),
+#endif
+	IBS_EVENT(0xf20b, "ibs_op:FORWARD", "IBS store-to-load forwarded"),
+	IBS_EVENT(0xf20c, "ibs_op:CANCELLED", "IBS store-to-load cancelled"),
+	IBS_EVENT(0xf20d, "ibs_op:DCUC_MEM_ACC", "IBS UC memory access"),
+	IBS_EVENT(0xf20e, "ibs_op:DCWC_MEM_ACC", "IBS WC memory access"),
+	IBS_EVENT(0xf20f, "ibs_op:LOCKED", "IBS locked operation"),
+	IBS_EVENT(0xf210, "ibs_op:MAB_HIT", "IBS MAB hit"),
+	IBS_EVENT(0xf211, "ibs_op:L1_DTLB_4K", "IBS L1 DTLB 4K page"),
+	IBS_EVENT(0xf212, "ibs_op:L1_DTLB_2M", "IBS L1 DTLB 2M page"),
+	IBS_EVENT(0xf213, "ibs_op:L1_DTLB_1G", "IBS L1 DTLB 1G page"),
+	IBS_EVENT(0xf215, "ibs_op:L2_DTLB_4K", "IBS L2 DTLB 4K page"),
+	IBS_EVENT(0xf216, "ibs_op:L2_DTLB_2M", "IBS L2 DTLB 2M page"),
+#if 0
+	IBS_EVENT(0xf217, "ibs_op:L2_DTLB_1G", "IBS L2 DTLB 1G page"),
+	IBS_EVENT(0xf219, "ibs_op:DC_LOAD_LAT", "IBS data cache miss load latency"),
+#endif
+	IBS_EVENT(0xf240, "ibs_op:NB_LOCAL_ONLY", "IBS Northbridge local"),
+	IBS_EVENT(0xf241, "ibs_op:NB_REMOTE_ONLY", "IBS Northbridge remote"),
+	IBS_EVENT(0xf242, "ibs_op:NB_LOCAL_L3", "IBS Northbridge local L3"),
+	IBS_EVENT(0xf243, "ibs_op:NB_LOCAL_CACHE", "IBS Northbridge local core L1 or L2 cache"),
+	IBS_EVENT(0xf244, "ibs_op:NB_REMOTE_CACHE", "IBS Northbridge local core L1, L2, L3 cache"),
+	IBS_EVENT(0xf245, "ibs_op:NB_LOCAL_DRAM", "IBS Northbridge local DRAM"),
+	IBS_EVENT(0xf246, "ibs_op:NB_REMOTE_DRAM", "IBS Northbridge remote DRAM"),
+	IBS_EVENT(0xf247, "ibs_op:NB_LOCAL_OTHER", "IBS Northbridge local APIC MMIO Config PCI"),
+	IBS_EVENT(0xf248, "ibs_op:NB_REMOTE_OTHER", "IBS Northbridge remote APIC MMIO Config PCI"),
+	IBS_EVENT(0xf249, "ibs_op:NB_CACHE_MODIFIED", "IBS Northbridge cache modified state"),
+	IBS_EVENT(0xf24a, "ibs_op:NB_CACHE_OWNED", "IBS Northbridge cache owned state"),
+#if 0
+	IBS_EVENT(0xf24b, "ibs_op:NB_LOCAL_CACHE_LAT", "IBS Northbridge local cache latency"),
+	IBS_EVENT(0xf24c, "ibs_op:NB_REMOTE_CACHE_LAT", "IBS Northbridge remote cache latency"),
+#endif
+	{ 0, NULL, NULL, { .filter = { IBS_FILTER_MATCH_ANY() } } }
 };
 
 static int ibs_parse_event(struct perf_event_attr *attr, char *sys, char *name)
 {
-	const char **event;
+	struct ibs_event *event;
 
 	if (strcmp("ibs_op", sys) && strcmp("ibs_fetch", sys))
 		return -ENOENT;
 
-	for (event = events; *event; event++) {
-		if (!strcmp(*event + strlen(sys) + 1, name))
+	for (event = events; event->id; event++) {
+		if (!strcmp(event->name + strlen(sys) + 1, name))
 			goto match;
 	}
 
 	return -EINVAL;
 match:
+	/* pseudo event found */
+	attr->config1 = event->config;
 	attr->sample_type = PERF_SAMPLE_CPU;
 
 	return 0;
@@ -97,13 +391,14 @@ match:
 
 static void ibs_print_events(const char *sys)
 {
-	const char **event;
+	struct ibs_event *event;
 
 	printf("\n");
 
-	for (event = events; *event; event++) {
-		if (!strncmp(sys, *event, strlen(sys)))
-			printf("  %-50s [PMU event: %s]\n", *event, sys);
+	for (event = events; event->id; event++) {
+		if (!strncmp(sys, event->name, strlen(sys)))
+			printf("  %-50s [PMU event: %s, id:0x%x]\n",
+			       event->name, sys, event->id);
 	}
 }
 
-- 
1.7.8.4


