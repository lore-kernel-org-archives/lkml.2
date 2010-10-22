Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0JVNFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:05:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:41803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab0JVNFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:05:08 -0400
Date: Fri, 22 Oct 2010 13:04:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.462621937@chello.nl>
References: <20101019134808.462621937@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Clean up reserve_ds_buffers() signature
Message-ID: <tip-f80c9e304b8e8062230b0cda2c2fdd586149c771@git.kernel.org>
Git-Commit-ID: f80c9e304b8e8062230b0cda2c2fdd586149c771
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:04:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f80c9e304b8e8062230b0cda2c2fdd586149c771
Gitweb:     http://git.kernel.org/tip/f80c9e304b8e8062230b0cda2c2fdd586149c771
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:50:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:26 +0200

perf, x86: Clean up reserve_ds_buffers() signature

Now that reserve_ds_buffers() never fails, change it to return
void and remove all code dealing with the error return.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.462621937@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c          |    9 +++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 61e78f6..a333bf9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -382,7 +382,7 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
-static int reserve_ds_buffers(void);
+static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
@@ -546,11 +546,8 @@ static int __x86_pmu_event_init(struct perf_event *event)
 		if (atomic_read(&active_events) == 0) {
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
-			else {
-				err = reserve_ds_buffers();
-				if (err)
-					release_pmc_hardware();
-			}
+			else
+				reserve_ds_buffers();
 		}
 		if (!err)
 			atomic_inc(&active_events);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 05c7db6..8a7f81c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -191,7 +191,7 @@ static void release_ds_buffers(void)
 	put_online_cpus();
 }
 
-static int reserve_ds_buffers(void)
+static void reserve_ds_buffers(void)
 {
 	int bts_err = 0, pebs_err = 0;
 	int cpu;
@@ -200,7 +200,7 @@ static int reserve_ds_buffers(void)
 	x86_pmu.pebs_active = 0;
 
 	if (!x86_pmu.bts && !x86_pmu.pebs)
-		return 0;
+		return;
 
 	if (!x86_pmu.bts)
 		bts_err = 1;
@@ -251,8 +251,6 @@ static int reserve_ds_buffers(void)
 	}
 
 	put_online_cpus();
-
-	return 0;
 }
 
 /*
@@ -714,9 +712,8 @@ static void intel_ds_init(void)
 
 #else /* CONFIG_CPU_SUP_INTEL */
 
-static int reserve_ds_buffers(void)
+static void reserve_ds_buffers(void)
 {
-	return 0;
 }
 
 static void release_ds_buffers(void)
