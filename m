Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0EGSnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:43:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0EGSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:43:08 -0400
Date: Fri, 7 May 2010 18:42:45 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271190201-25705-4-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Call x86_setup_perfctr() from .hw_config()
Message-ID: <tip-9d0fcba67e47ff398a6fa86476d4884d472dc98a@git.kernel.org>
Git-Commit-ID: 9d0fcba67e47ff398a6fa86476d4884d472dc98a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:42:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d0fcba67e47ff398a6fa86476d4884d472dc98a
Gitweb:     http://git.kernel.org/tip/9d0fcba67e47ff398a6fa86476d4884d472dc98a
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 13 Apr 2010 22:23:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:00 +0200

perf, x86: Call x86_setup_perfctr() from .hw_config()

The perfctr setup calls are in the corresponding .hw_config()
functions now. This makes it possible to introduce config functions
for other pmu events that are not perfctr specific.

Also, all of a sudden the code looks much nicer.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271190201-25705-4-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c    |    9 ++-------
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3d3bceb..c2c1e10 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -505,7 +505,7 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-	return 0;
+	return x86_setup_perfctr(event);
 }
 
 /*
@@ -543,12 +543,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
-	/* Processor specifics */
-	err = x86_pmu.hw_config(event);
-	if (err)
-		return err;
-
-	return x86_setup_perfctr(event);
+	return x86_pmu.hw_config(event);
 }
 
 static void x86_pmu_disable_all(void)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 15367cc..9e00205 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -455,7 +455,7 @@ static int p4_hw_config(struct perf_event *event)
 		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 
-	return 0;
+	return x86_setup_perfctr(event);
 }
 
 static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
