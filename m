Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0ESVlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38617 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0ESVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:05 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS85-02-UV4-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/7] perf: introduce raw_type attribute to specify the type of a raw sample
Date: Wed, 19 May 2010 23:20:18 +0200
Message-ID: <1274304024-6551-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a method to specify the type of a raw sample.
This can be used to setup hardware events other than generic
performance counters by passing special config data to the pmu. The
config data can be interpreted different from generic events and thus
can be used for other purposes.

The raw_type attribute is an extension of the ABI. It reuses the
unused bp_type space for this. Generic performance counters can be
setup by setting the raw_type attribute to null. Thus special raw
events must have a type other than null.

Raw types can be defined as needed for cpu models or architectures.
To keep backward compatibility all architectures must return an error
for an event with a raw_type other than null that is not supported.

E.g., raw_type can be used to setup IBS on an AMD cpu. IBS is not
common to pmu features from other vendors or architectures. The pmu
must be setup with a special config value. Sample data is returned in
a certain format back to the userland. An IBS event is created by
setting a raw event and encoding the IBS type in raw_type. The pmu
handles this raw event then and passes raw sample data back.

Raw type could be architecure specific, e.g. for x86:

enum perf_raw_type {
        PERF_RAW_PERFCTR                        = 0,
        PERF_RAW_IBS_FETCH                      = 1,
        PERF_RAW_IBS_OP                         = 2,

        PERF_RAW_MAX,
};

Null is the architecture's default, meaning for x86 a perfctr.

Maybe the raw type definition could also be part of the ABI with one
definition for all architectures.

To use raw events with perf, the raw event syntax could be suffixed by
the type (as for breakpoints):

   -e rNNN[:TYPE]

Example:

 perf record -e r186A:1          # ... meaning IBS fetch, cycle count 100000
 perf record -e r0:1 -c 100000   # ... the same

Or with named types:

 perf record -e r186A:IBS_FETCH ...
 perf record -e r0:IBS_FETCH -c 100000 ...

This solution has a number of advantages: A raw event type may be
specified without to encode the type in the config value. The attr
flags are not 'polluted'. We can follow the already existing
breakpoint concept in syntax and encoding.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/kernel/perf_event.c             |    5 +++++
 arch/powerpc/kernel/perf_event.c         |    2 ++
 arch/powerpc/kernel/perf_event_fsl_emb.c |    2 ++
 arch/sh/kernel/perf_event.c              |    2 ++
 arch/x86/kernel/cpu/perf_event.c         |    5 ++++-
 arch/x86/kernel/cpu/perf_event_amd.c     |    3 +++
 arch/x86/kernel/cpu/perf_event_intel.c   |    3 +++
 arch/x86/kernel/cpu/perf_event_p4.c      |    5 +++++
 include/linux/perf_event.h               |    5 ++++-
 9 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 9e70f20..73d680c 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -388,6 +388,11 @@ __hw_perf_event_init(struct perf_event *event)
 	} else if (PERF_TYPE_HW_CACHE == event->attr.type) {
 		mapping = armpmu_map_cache_event(event->attr.config);
 	} else if (PERF_TYPE_RAW == event->attr.type) {
+		if (event->attr.raw_type) {
+			pr_debug("invalid raw type %x\n",
+				 event->attr.raw_type);
+			return -EINVAL;
+		}
 		mapping = armpmu->raw_event(event->attr.config);
 	} else {
 		pr_debug("event type %x not supported\n", event->attr.type);
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 43b83c3..c8fb3cf 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1036,6 +1036,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 			return ERR_PTR(err);
 		break;
 	case PERF_TYPE_RAW:
+		if (event->attr.raw_type)
+			return ERR_PTR(-EINVAL);
 		ev = event->attr.config;
 		break;
 	default:
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 369872f..7547e96 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -452,6 +452,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 		break;
 
 	case PERF_TYPE_RAW:
+		if (event->attr.raw_type)
+			return ERR_PTR(-EINVAL);
 		ev = event->attr.config;
 		break;
 
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 81b6de4..482cf48 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -142,6 +142,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 	switch (attr->type) {
 	case PERF_TYPE_RAW:
+		if (attr->raw_type)
+			return -EINVAL;
 		config = attr->config & sh_pmu->raw_event_mask;
 		break;
 	case PERF_TYPE_HW_CACHE:
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fd4db0d..3539b53 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -449,8 +449,11 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	if (attr->type == PERF_TYPE_RAW)
+	if (attr->type == PERF_TYPE_RAW) {
+		if (attr->raw_type)
+			return -EINVAL;
 		return 0;
+	}
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 611df11..87e5ae4 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -121,6 +121,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
+	if (event->attr.raw_type)
+		return -EINVAL;
+
 	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fdbc652..d15faf5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -770,6 +770,9 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
+	if (event->attr.raw_type)
+		return -EINVAL;
+
 	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
 		return 0;
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 87e1803..1001892 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -437,6 +437,11 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
+		/* only raw perfctr config supported */
+		if (event->attr.raw_type) {
+			rc = -EINVAL;
+			goto out;
+		}
 
 		/* user data may have out-of-bound event index */
 		evnt = p4_config_unpack_event(event->attr.config);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fe50347..f9d2d5e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -222,7 +222,10 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	__u32			bp_type;
+	union {
+		__u32		bp_type;
+		__u32		raw_type;
+	};
 	__u64			bp_addr;
 	__u64			bp_len;
 };
-- 
1.7.1


