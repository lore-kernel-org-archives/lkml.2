Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0DMU3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:29:01 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48654 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0DMU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:52 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh467h2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SF-01-CAY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/12] perf: introduce flag for model specific events
Date: Tue, 13 Apr 2010 22:23:13 +0200
Message-ID: <1271190201-25705-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0589 (UTC) FILETIME=[9CF42F50:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a flag to mark events as model specific. The
flag can be used to setup hardware events other than generic
performance counters by passing special config data to the pmu. The
data can be interpreted different from generic events and can be used
for other purposes.

The concept of PMU model-specific arguments was practiced already in
Perfmon2. Perfmon2 provides an interface to pass model specific config
values to the pmu and receive event specific samples back. The
implementation of the model specific flag extends the perf_event i/f
by this feature too.

The userland program must be aware of the cpu model to create
model specific events. This could be done for example by checking the
cpu and family.

The model_spec flag can be arbitrarily reused on other models or
architectures. For backward compatibility all architectures must
return an error, if model_spec events are not supported and the bit is
set.

E.g., this flag is used to setup IBS on an AMD cpu. IBS is not common
to pmu features from other vendors or architectures. The pmu must be
setup with a special config value. Sample data is returned in a
certain format back to the userland. An IBS event is passed in the
config field of the event attributes and with model_spec and raw event
flag enabled. The samples are then passed back in a raw sample.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/powerpc/kernel/perf_event.c |    3 +++
 arch/sh/kernel/perf_event.c      |    3 +++
 arch/sparc/kernel/perf_event.c   |    3 +++
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 include/linux/perf_event.h       |    3 ++-
 5 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 08460a2..8e68e15 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1037,6 +1037,9 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 	event->hw.config_base = ev;
 	event->hw.idx = 0;
 
+	if (attr->model_spec)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/*
 	 * If we are not running on a hypervisor, force the
 	 * exclude_hv bit to 0 so that we don't care what
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 81b6de4..eef545a 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -109,6 +109,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	if (!sh_pmu_initialized())
 		return -ENODEV;
 
+	if (attr->model_spec)
+		return -EOPNOTSUPP;
+
 	/*
 	 * All of the on-chip counters are "limited", in that they have
 	 * no interrupts, and are therefore unable to do sampling without
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e277193..5c1d2a4 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1083,6 +1083,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	} else
 		return -EOPNOTSUPP;
 
+	if (attr->model_spec)
+		return -EOPNOTSUPP;
+
 	/* We save the enable bits in the config_base.  */
 	hwc->config_base = sparc_pmu->irq_bit;
 	if (!attr->exclude_user)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5945128..9eeffad 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -432,6 +432,9 @@ static int x86_setup_perfctr(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	u64 config;
 
+	if (attr->model_spec)
+		return -EOPNOTSUPP;
+
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6e96cc8..e90ba6e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -204,8 +204,9 @@ struct perf_event_attr {
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
 				precise        :  1, /* OoO invariant counter */
+				model_spec     :  1, /* model specific hw event */
 
-				__reserved_1   : 48;
+				__reserved_1   : 47;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
-- 
1.7.0.3


