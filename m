Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1DSMFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:05:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1DSMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:05:09 -0400
Date: Tue, 19 Apr 2011 12:04:50 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-c8e5910edf8bbe2e5c6c35a4ef2a578cc7893b25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1302913676-14352-4-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE
Git-Commit-ID: c8e5910edf8bbe2e5c6c35a4ef2a578cc7893b25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 12:04:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8e5910edf8bbe2e5c6c35a4ef2a578cc7893b25
Gitweb:     http://git.kernel.org/tip/c8e5910edf8bbe2e5c6c35a4ef2a578cc7893b25
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Sat, 16 Apr 2011 02:27:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 10:08:12 +0200

perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE

Using ALTERNATIVE() when checking for X86_FEATURE_PERFCTR_CORE avoids
an extra pointer chase and data cache hit.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1302913676-14352-4-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..224a84f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/nmi.h>
 #include <asm/compat.h>
 #include <asm/smp.h>
+#include <asm/alternative.h>
 
 #if 0
 #undef wrmsrl
@@ -363,12 +364,18 @@ again:
 	return new_raw_count;
 }
 
-/* using X86_FEATURE_PERFCTR_CORE to later implement ALTERNATIVE() here */
 static inline int x86_pmu_addr_offset(int index)
 {
-	if (boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		return index << 1;
-	return index;
+	int offset;
+
+	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
+	alternative_io(ASM_NOP2,
+		       "shll $1, %%eax",
+		       X86_FEATURE_PERFCTR_CORE,
+		       "=a" (offset),
+		       "a"  (index));
+
+	return offset;
 }
 
 static inline unsigned int x86_pmu_config_addr(int index)
