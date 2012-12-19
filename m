Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2LSH3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:29:51 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51054 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2LSH3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:29:44 -0500
Date: Tue, 18 Dec 2012 23:29:29 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf/POWER7: Make some POWER7 events available in sysfs
Message-ID: <20121219072929.GC30790@us.ibm.com>
References: <20121219072646.GA30580@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219072646.GA30580@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121907-5518-0000-0000-00000A231636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make some POWER7-specific perf events available in sysfs.

	$ /bin/ls -1 /sys/bus/event_source/devices/cpu/events/
	branch-instructions
	branch-misses
	cache-misses
	cache-references
	cpu-cycles
	instructions
	PM_BRU_FIN
	PM_BRU_MPRED
	PM_CMPLU_STALL
	PM_CYC
	PM_GCT_NOSLOT_CYC
	PM_INST_CMPL
	PM_LD_MISS_L1
	PM_LD_REF_L1
	stalled-cycles-backend
	stalled-cycles-frontend

where the 'PM_*' events are POWER specific and the others are the
generic events.

This will enable users to specify these events with their symbolic
names rather than with their raw code.

	perf stat -e 'cpu/PM_CYC' ...

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    2 ++
 arch/powerpc/perf/power7-pmu.c               |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 20ca90f..4315bc9 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -134,3 +134,5 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
 #define	GENERIC_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _g)
 #define	GENERIC_EVENT_PTR(_id)		EVENT_PTR(_id, _g)
 
+#define	POWER_EVENT_ATTR(_name, _id)	EVENT_ATTR(PM_##_name, _id, _p)
+#define	POWER_EVENT_PTR(_id)		EVENT_PTR(_id, _p)
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index ae5d757..5627940 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -373,6 +373,15 @@ GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		BRU_MPRED);
 
+POWER_EVENT_ATTR(CYC,				CYC);
+POWER_EVENT_ATTR(GCT_NOSLOT_CYC,		GCT_NOSLOT_CYC);
+POWER_EVENT_ATTR(CMPLU_STALL,			CMPLU_STALL);
+POWER_EVENT_ATTR(INST_CMPL,			INST_CMPL);
+POWER_EVENT_ATTR(LD_REF_L1,			LD_REF_L1);
+POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
+POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
+POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
+
 static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(CYC),
 	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -382,6 +391,15 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(LD_MISS_L1),
 	GENERIC_EVENT_PTR(BRU_FIN),
 	GENERIC_EVENT_PTR(BRU_MPRED),
+
+	POWER_EVENT_PTR(CYC),
+	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
+	POWER_EVENT_PTR(CMPLU_STALL),
+	POWER_EVENT_PTR(INST_CMPL),
+	POWER_EVENT_PTR(LD_REF_L1),
+	POWER_EVENT_PTR(LD_MISS_L1),
+	POWER_EVENT_PTR(BRU_FIN),
+	POWER_EVENT_PTR(BRU_MPRED),
 	NULL
 };
 
-- 
1.7.1

