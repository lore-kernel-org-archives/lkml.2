Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0CYBEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:04:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0CYBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:04:18 -0400
X-Authority-Analysis: v=1.0 c=1 a=jXwxiBOXcpEA:10 a=GzHTLUccyWwA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=wjzBHERUFhrufxORbz0A:9 a=43RRSe44h1U7d5C-vwOsb3UE3x8A:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100325010415.814675156@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Mar 2010 21:02:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: Fix lockdep warning in global_clock()
References: <20100325010223.843140579@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-lockdep-warning-in-global_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

# echo 1 > events/enable
 # echo global > trace_clock

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
...
---[ end trace 3f86734a89416623 ]---
possible reason: unannotated irqs-on.
...

There's no reason to use the raw_local_irq_save() in trace_clock_global.
The local_irq_save() version is fine, and does not cause the bug in lockdep.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BA97FA1.7030606@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6fbfb8f..9d589d8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
 	int this_cpu;
 	u64 now;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
 	now = cpu_clock(this_cpu);
@@ -110,7 +110,7 @@ u64 notrace trace_clock_global(void)
 	arch_spin_unlock(&trace_clock_struct.lock);
 
  out:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return now;
 }
-- 
1.7.0


