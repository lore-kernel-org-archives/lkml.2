Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2FFQPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:15:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab2FFQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:15:31 -0400
Date: Wed, 6 Jun 2012 09:15:18 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix wrmsrl() debug wrapper
Git-Commit-ID: 1c2ac3fde3e35279958e7b0408e2dcf866465301
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c2ac3fde3e35279958e7b0408e2dcf866465301
Gitweb:     http://git.kernel.org/tip/1c2ac3fde3e35279958e7b0408e2dcf866465301
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 May 2012 15:25:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:23:22 +0200

perf/x86: Fix wrmsrl() debug wrapper

Move the wrmslr() debug wrapper to the common header now that all the
include games are gone. Also clean it up a bit to avoid multiple
evaluation of the argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   11 -----------
 arch/x86/kernel/cpu/perf_event.h |   12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c4706cf..43c2017 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -35,17 +35,6 @@
 
 #include "perf_event.h"
 
-#if 0
-#undef wrmsrl
-#define wrmsrl(msr, val) 					\
-do {								\
-	trace_printk("wrmsrl(%lx, %lx)\n", (unsigned long)(msr),\
-			(unsigned long)(val));			\
-	native_write_msr((msr), (u32)((u64)(val)), 		\
-			(u32)((u64)(val) >> 32));		\
-} while (0)
-#endif
-
 struct x86_pmu x86_pmu __read_mostly;
 
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 7241e2f..23b5710 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -14,6 +14,18 @@
 
 #include <linux/perf_event.h>
 
+#if 0
+#undef wrmsrl
+#define wrmsrl(msr, val) 						\
+do {									\
+	unsigned int _msr = (msr);					\
+	u64 _val = (val);						\
+	trace_printk("wrmsrl(%x, %Lx)\n", (unsigned int)(_msr),		\
+			(unsigned long long)(_val));			\
+	native_write_msr((_msr), (u32)(_val), (u32)(_val >> 32));	\
+} while (0)
+#endif
+
 /*
  *          |   NHM/WSM    |      SNB     |
  * register -------------------------------
