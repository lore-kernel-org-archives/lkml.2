Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2KHBK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:10:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49173 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2KHBK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:10:57 -0500
Date: Wed, 7 Nov 2012 17:10:35 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        eranian@google.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: perf: POWER-event translation questions
Message-ID: <20121108011035.GA20670@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110801-9360-0000-0000-00000C89EA40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Looking for feedback on this prototype for making POWER-specific event
translations available in sysfs. It is based on the patchset:

	https://lkml.org/lkml/2012/11/7/402

which makes the translations for _generic_ events in POWER available in sysfs:

Since this is in POWER7 specific code I am assigning the names given in the
POWER7 CPU spec for now.

I had earlier tried mapping these events to generic names outside sysfs:

	Power7 name		Generic name

	cmpl-stall-fxu		stalled-cycles-fixed-point
	cmpl-stall-lsu		stalled-cycles-load-store
	cmpl-stall-ifu		stalled-cycles-instruction-fetch
	cmpl-stall-bru 		stalled-cycles-branch-unit

But like Stephane Eranian pointed out mapping such events across architectures
can be confusing.

Another challenge I suspect we will have is the extremely long generic names
we could end up with as the events get more specific.

1. Can we have more than one name for an event ? i.e two sysfs entries,
   eg: 'cmpl-stall-fxu' and 'stalled-cycles-fixed-point' for an event ?

2. Can we allow hyphens in the {name} token  (please see my change to
   util/parse-events.l below). With this change, I can run:

	  perf stat -e cpu/cmplu-stall-bru /tmp/nop

   without any changes to the user level tool (parse-events.l) I have
   tested some common cases, not sure if it will break something :-)

   If we are going to create generic or arch specific sysfs entries in
   /sys/bus/event_source/devices/cpu/events, do we need to add corresponding
   entry in tools/perf/util/parse-events.l ?

Sukadev

---
 arch/powerpc/perf/power7-pmu.c |   13 +++++++++++++
 tools/perf/util/parse-events.l |    2 +-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index aa9f588..9f46abc 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -303,6 +303,10 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 #define	PM_LD_MISS_L1			0x400f0
 #define	PM_BRU_FIN			0x10068
 #define	PM_BRU_MPRED			0x400f6
+#define	PM_CMPLU_STALL_FXU		0x20014
+#define	PM_CMPLU_STALL_LSU		0x20012
+#define	PM_CMPLU_STALL_IFU		0x4004c
+#define	PM_CMPLU_STALL_BRU		0x4004e
 
 static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = 			PM_CYC,
@@ -369,6 +373,11 @@ EVENT_ATTR(cache-misses,               LD_MISS_L1);
 EVENT_ATTR(branch-instructions,        BRU_FIN);
 EVENT_ATTR(branch-misses,              BRU_MPRED);
 
+EVENT_ATTR(cmplu-stall-fxu,            CMPLU_STALL_FXU);
+EVENT_ATTR(cmplu-stall-lsu,            CMPLU_STALL_LSU);
+EVENT_ATTR(cmplu-stall-ifu,            CMPLU_STALL_IFU);
+EVENT_ATTR(cmplu-stall-bru,            CMPLU_STALL_BRU);
+
 static struct attribute *power7_events_attr[] = {
 	EVENT_PTR(CYC),
 	EVENT_PTR(GCT_NOSLOT_CYC),
@@ -378,6 +387,10 @@ static struct attribute *power7_events_attr[] = {
 	EVENT_PTR(LD_MISS_L1),
 	EVENT_PTR(BRU_FIN),
 	EVENT_PTR(BRU_MPRED),
+	EVENT_PTR(CMPLU_STALL_FXU),
+	EVENT_PTR(CMPLU_STALL_LSU),
+	EVENT_PTR(CMPLU_STALL_IFU),
+	EVENT_PTR(CMPLU_STALL_BRU),
 	NULL,
 };
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c87efc1..1967bb2 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -80,7 +80,7 @@ event		[^,{}/]+
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
-name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
+name		[-a-zA-Z_*?][-a-zA-Z0-9_*?]*
 modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]{1,3}
 
-- 
1.7.1

