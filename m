Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3AJAUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:20:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33493 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab3AJAUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:20:38 -0500
From: sukadev@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        <robert.richter@amd.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6][v3] perf/POWER7: Make some POWER7 events available in sysfs
Date: Wed,  9 Jan 2013 16:20:30 -0800
Message-Id: <1357777232-32037-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1357777232-32037-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1357777232-32037-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011000-7182-0000-0000-0000044F880B
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

	perf stat -e 'cpu/PM_CYC/' ...

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    2 ++
 arch/powerpc/perf/power7-pmu.c               |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3f21d89..b29fcc6 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -133,3 +133,5 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
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

