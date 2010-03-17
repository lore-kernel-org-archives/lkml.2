Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0CQJtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:49:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:40614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab0CQJtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:49:40 -0400
Date: Wed, 17 Mar 2010 09:48:52 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268697902-9518-1-git-send-regression-fweisbec@gmail.com>
References: <1268697902-9518-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix unexported generic perf_arch_fetch_caller_regs
Message-ID: <tip-a6b84574eed7e4fd8cb8dac2d0926fe2cf34b941@git.kernel.org>
Git-Commit-ID: a6b84574eed7e4fd8cb8dac2d0926fe2cf34b941
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 09:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6b84574eed7e4fd8cb8dac2d0926fe2cf34b941
Gitweb:     http://git.kernel.org/tip/a6b84574eed7e4fd8cb8dac2d0926fe2cf34b941
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 16 Mar 2010 01:05:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 10:44:42 +0100

perf: Fix unexported generic perf_arch_fetch_caller_regs

perf_arch_fetch_caller_regs() is exported for the overriden x86
version, but not for the generic weak version.

As a general rule, weak functions should not have their symbol
exported in the same file they are defined.

So let's export it on trace_event_perf.c as it is used by trace
events only.

This fixes:

	ERROR: ".perf_arch_fetch_caller_regs" [fs/xfs/xfs.ko] undefined!
	ERROR: ".perf_arch_fetch_caller_regs" [arch/powerpc/platforms/cell/spufs/spufs.ko] undefined!

-v2: And also only build it if trace events are enabled.
-v3: Fix changelog mistake

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1268697902-9518-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ++-
 kernel/perf_event.c              |    2 ++
 kernel/trace/trace_event_perf.c  |    2 ++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7645fae..60398a0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1702,6 +1702,7 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
+#ifdef CONFIG_EVENT_TRACING
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 	regs->ip = ip;
@@ -1713,4 +1714,4 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
-EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
+#endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fb3031c..574ee58 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2786,10 +2786,12 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
+#ifdef CONFIG_EVENT_TRACING
 __weak
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 }
+#endif
 
 /*
  * Output
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0709e4f..7d79a10 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -12,6 +12,8 @@
 DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
 EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
 
+EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
+
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
