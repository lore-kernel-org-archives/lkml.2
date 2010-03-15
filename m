Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936759Ab0COVAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:00:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48842 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab0COVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MOMRaVF34/sslTIwqNawIunArCCBwIYdrA3YiIkvzfjA/HGv8b0VqaqnBmhpQFQDOB
         b7whwWO4tgTUKeubqFaxV7hlunNA22WOJamsDcub4KnbWg7EuwkYBcm2zDdzsfqVMw/H
         ljYJePuPKar+pjVBXoPkH72m1pRfPdGZtLExo=
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
Subject: [PATCH] perf: Fix unexported generic perf_arch_fetch_caller_regs
Date: Mon, 15 Mar 2010 22:00:06 +0100
Message-Id: <1268686806-7286-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100312172641.f683dfd9.sfr@canb.auug.org.au>
References: <20100312172641.f683dfd9.sfr@canb.auug.org.au>
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

And also only build it if trace events are enabled.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/cpu/perf_event.c |    1 -
 kernel/trace/trace_event_perf.c  |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7645fae..5fb490c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1713,4 +1713,3 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
-EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
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

