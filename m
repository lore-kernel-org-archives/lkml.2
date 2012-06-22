Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab2FVOmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:42:49 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:48988
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933184Ab2FVOmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:42:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M60WV0-02-6PT-02
X-M-MSG: 
Date: Fri, 22 Jun 2012 16:42:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        William Cohen <wcohen@redhat.com>
Subject: [PATCH] oprofile, perf: Use per-cpu framework
Message-ID: <20120622144231.GJ24632@erda.amd.com>
References: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
 <20120615154359.GE12031@mudshark.cambridge.arm.com>
 <20120615161635.GV1478@erda.amd.com>
 <20120615161954.GF12031@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120615161954.GF12031@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 15.06.12 17:19:54, Will Deacon wrote:
> On Fri, Jun 15, 2012 at 05:16:35PM +0100, Robert Richter wrote:
> > On 15.06.12 16:43:59, Will Deacon wrote:
> > > Given both the lack of feedback and the trivial nature of this patch would
> > > you be able to pick this up please? I'd rather not push it via the ARM tree
> > > as the change is under drivers/.
> > 
> > Will, I will apply it. Sorry for not responding earlier.

I just realized I wrote a patch some time ago that introduces per_cpu
variables, see below. Please give it a try to, I will then queue it
for v3.6.

Your patch should go upstream anyway to make it into stable trees.

Thanks,

-Robert


>From f8bbfd7d28303967ca4e8597de9bdc9bf8b197e7 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 23 Feb 2012 17:07:06 +0100
Subject: [PATCH] oprofile, perf: Use per-cpu framework

This changes oprofile_perf.c to use the per-cpu framework.

Using the per-cpu framework should avoid error like the following:

 arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:28:28: error: variably modified 'perf_events' at file scope

Reported-by: William Cohen <wcohen@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprofile_perf.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index efc4b7f..f3cfa0b 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2010 ARM Ltd.
+ * Copyright 2012 Advanced Micro Devices, Inc., Robert Richter
  *
  * Perf-events backend for OProfile.
  */
@@ -25,7 +26,7 @@ static int oprofile_perf_enabled;
 static DEFINE_MUTEX(oprofile_perf_mutex);
 
 static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[NR_CPUS];
+static DEFINE_PER_CPU(struct perf_event **, perf_events);
 static int num_counters;
 
 /*
@@ -38,7 +39,7 @@ static void op_overflow_handler(struct perf_event *event,
 	u32 cpu = smp_processor_id();
 
 	for (id = 0; id < num_counters; ++id)
-		if (perf_events[cpu][id] == event)
+		if (per_cpu(perf_events, cpu)[id] == event)
 			break;
 
 	if (id != num_counters)
@@ -74,7 +75,7 @@ static int op_create_counter(int cpu, int event)
 {
 	struct perf_event *pevent;
 
-	if (!counter_config[event].enabled || perf_events[cpu][event])
+	if (!counter_config[event].enabled || per_cpu(perf_events, cpu)[event])
 		return 0;
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
@@ -91,18 +92,18 @@ static int op_create_counter(int cpu, int event)
 		return -EBUSY;
 	}
 
-	perf_events[cpu][event] = pevent;
+	per_cpu(perf_events, cpu)[event] = pevent;
 
 	return 0;
 }
 
 static void op_destroy_counter(int cpu, int event)
 {
-	struct perf_event *pevent = perf_events[cpu][event];
+	struct perf_event *pevent = per_cpu(perf_events, cpu)[event];
 
 	if (pevent) {
 		perf_event_release_kernel(pevent);
-		perf_events[cpu][event] = NULL;
+		per_cpu(perf_events, cpu)[event] = NULL;
 	}
 }
 
@@ -257,12 +258,12 @@ void oprofile_perf_exit(void)
 
 	for_each_possible_cpu(cpu) {
 		for (id = 0; id < num_counters; ++id) {
-			event = perf_events[cpu][id];
+			event = per_cpu(perf_events, cpu)[id];
 			if (event)
 				perf_event_release_kernel(event);
 		}
 
-		kfree(perf_events[cpu]);
+		kfree(per_cpu(perf_events, cpu));
 	}
 
 	kfree(counter_config);
@@ -277,8 +278,6 @@ int __init oprofile_perf_init(struct oprofile_operations *ops)
 	if (ret)
 		return ret;
 
-	memset(&perf_events, 0, sizeof(perf_events));
-
 	num_counters = perf_num_counters();
 	if (num_counters <= 0) {
 		pr_info("oprofile: no performance counters\n");
@@ -298,9 +297,9 @@ int __init oprofile_perf_init(struct oprofile_operations *ops)
 	}
 
 	for_each_possible_cpu(cpu) {
-		perf_events[cpu] = kcalloc(num_counters,
+		per_cpu(perf_events, cpu) = kcalloc(num_counters,
 				sizeof(struct perf_event *), GFP_KERNEL);
-		if (!perf_events[cpu]) {
+		if (!per_cpu(perf_events, cpu)) {
 			pr_info("oprofile: failed to allocate %d perf events "
 					"for cpu %d\n", num_counters, cpu);
 			ret = -ENOMEM;
-- 
1.7.8.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

