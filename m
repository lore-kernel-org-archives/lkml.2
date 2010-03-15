Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936964Ab0COWR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:17:27 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50534 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936926Ab0COWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tO5pLuaJdLENIt55jQThkQvj3NddWSgkbHMW+8I7hfLD7TLaGuUtkZUbDl2UfcMzdb
         5QSnrErcN6Js7MXPFrQreX9LaGMt35WGdoH3+3ltKzq8ot2QWJdeA4VAnLE+dcJlyaly
         5M+n7CCvCV9sYeL9MaLlpySHvZkYQHEq7KWrA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "\\ \" H . Peter Anvin \\ \"" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2] perf: Fix unexported generic perf_arch_fetch_caller_regs
Date: Mon, 15 Mar 2010 23:17:22 +0100
Message-Id: <1268691442-8300-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1268686806-7286-1-git-send-regression-fweisbec@gmail.com>
References: <1268686806-7286-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_arch_fetch_caller_regs() is exported for the overriden x86
version, but not for the generic weak version.
As a general rule, weak functions should have their symbol exported
in the same file they are defined.

So let's export it on trace_event_perf.c as it is used by trace
events only.

This fixes:
	ERROR: ".perf_arch_fetch_caller_regs" [fs/xfs/xfs.ko] undefined!
	ERROR: ".perf_arch_fetch_caller_regs" [arch/powerpc/platforms/cell/spufs/spufs.ko] undefined!

v2: And also only build it if trace events are enabled.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
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
 
-- 
1.6.2.3

