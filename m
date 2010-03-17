Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0CQMK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:10:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab0CQMK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:10:27 -0400
Date: Wed, 17 Mar 2010 12:09:34 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268826553-19518-2-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core, x86: Reduce number of CONFIG_X86_LOCAL_APIC macros
Message-ID: <tip-b27ea29c6267889be255f2217fa7a6106e6a8b04@git.kernel.org>
Git-Commit-ID: b27ea29c6267889be255f2217fa7a6106e6a8b04
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 12:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b27ea29c6267889be255f2217fa7a6106e6a8b04
Gitweb:     http://git.kernel.org/tip/b27ea29c6267889be255f2217fa7a6106e6a8b04
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 17 Mar 2010 12:49:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 13:06:58 +0100

perf/core, x86: Reduce number of CONFIG_X86_LOCAL_APIC macros

The function reserve_pmc_hardware() and release_pmc_hardware()
were hard to read. This patch improves readability of the code by
removing most of the CONFIG_X86_LOCAL_APIC macros.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268826553-19518-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5dacf63..793e63f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -313,9 +313,10 @@ again:
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static bool reserve_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -330,11 +331,9 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
-#endif
 
 	return true;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -349,12 +348,10 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
-#endif
 }
 
 static void release_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_events; i++) {
@@ -364,9 +361,15 @@ static void release_pmc_hardware(void)
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
-#endif
 }
 
+#else
+
+static bool reserve_pmc_hardware(void) { return true; }
+static void release_pmc_hardware(void) {}
+
+#endif
+
 static int reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
