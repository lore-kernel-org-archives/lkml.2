Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2ILLCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:02:49 -0400
Received: from [216.32.181.181] ([216.32.181.181]:55128 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755891Ab2ILLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:02:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12bdh1155h)
X-WSS-ID: 0MA8HAI-01-3EV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf: Introduce function to report unsupported syscall attribute flags
Date: Wed, 12 Sep 2012 13:01:25 +0200
Message-ID: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often a syscall fails with

   Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.

but no additional information.

This patch adds some macro magic and a helper function to check and
report unsupported syscall attribute flags:

 has_unsupported_flags(attr1, attr2);
 has_unsupported_flag(attr, flag);
 __has_unsupported_flags(const struct perf_event_attr *attr,
                         u64 notsup);

E.g. dmesg reports the following (checking for the exclude_guest
flag):

 perf: unsupported attribute flags: 0000000000100000

or (checking precise modifier :ppp):

 perf: unsupported attribute flags: 0000000000018000

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c         |   19 ++++++++++---------
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 ++-
 include/linux/perf_event.h               |   23 +++++++++++++++++++++++
 kernel/events/core.c                     |    2 +-
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..9ae8676 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -336,7 +336,7 @@ int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
-		if (!attr->exclude_kernel)
+		if (has_unsupported_flag(attr, exclude_kernel))
 			return -EOPNOTSUPP;
 	}
 
@@ -389,8 +389,11 @@ int x86_pmu_hw_config(struct perf_event *event)
 				precise++;
 		}
 
-		if (event->attr.precise_ip > precise)
+		if (event->attr.precise_ip > precise) {
+			has_unsupported_flag(&event->attr, precise_ip);
 			return -EOPNOTSUPP;
+		}
+
 		/*
 		 * check that PEBS LBR correction does not conflict with
 		 * whatever the user is asking with attr->branch_sample_type
@@ -398,13 +401,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 		if (event->attr.precise_ip > 1) {
 			u64 *br_type = &event->attr.branch_sample_type;
 
-			if (has_branch_stack(event)) {
-				if (!precise_br_compat(event))
-					return -EOPNOTSUPP;
-
-				/* branch_sample_type is compatible */
-
-			} else {
+			if (!has_branch_stack(event)) {
 				/*
 				 * user did not specify  branch_sample_type
 				 *
@@ -419,7 +416,11 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 				if (!event->attr.exclude_kernel)
 					*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
+			} else if (!precise_br_compat(event)) {
+				has_unsupported_flag(&event->attr, precise_ip);
+				return -EOPNOTSUPP;
 			}
+			/* else: branch_sample_type is compatible */
 		}
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 4af8275..fc145b0 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -186,6 +186,7 @@ static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
 	case 2:
 		break;
 	default:
+		has_unsupported_flag(&event->attr, precise_ip);
 		return -EOPNOTSUPP;
 	}
 
@@ -243,7 +244,7 @@ static int perf_ibs_init(struct perf_event *event)
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
-	if (perf_flags(&event->attr) & perf_flags(&ibs_notsupp))
+	if (has_unsupported_flags(&event->attr, &ibs_notsupp))
 		return -EINVAL;
 
 	if (config & ~perf_ibs->config_mask)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c36a04f..eb247a5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -305,6 +305,14 @@ struct perf_event_attr {
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
+#define perf_flags_init(flag) ({					\
+	volatile __u64	flags = 0;					\
+	struct perf_event_attr *attr;					\
+	attr = (void *)((char *)&flags -				\
+			(char *)&perf_flags((struct perf_event_attr *)(0))); \
+	if (!WARN_ON(&perf_flags(attr) != &flags)) 			\
+		attr->flag = ~0;					\
+	flags;})
 
 /*
  * Ioctls that can be done on a perf event fd:
@@ -1208,6 +1216,21 @@ extern int perf_event_overflow(struct perf_event *event,
 				 struct perf_sample_data *data,
 				 struct pt_regs *regs);
 
+static inline bool __has_unsupported_flags(const struct perf_event_attr *attr,
+					   u64 notsup)
+{
+	notsup &= perf_flags(attr);
+	if (notsup)
+		pr_warn("perf: unsupported attribute flags: %016llx\n", notsup);
+	return notsup != 0;
+}
+
+#define has_unsupported_flags(attr1, attr2) \
+	__has_unsupported_flags((attr1), perf_flags(attr2))
+/* flag is the name of the member in struct perf_event_attr: */
+#define has_unsupported_flag(attr, flag) \
+	__has_unsupported_flags((attr), perf_flags_init(flag))
+
 static inline bool is_sampling_event(struct perf_event *event)
 {
 	return event->attr.sample_period != 0;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2ba8904..2667ef6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6291,7 +6291,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	if (attr->__reserved_1)
+	if (has_unsupported_flag(attr, __reserved_1))
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
-- 
1.7.8.6


