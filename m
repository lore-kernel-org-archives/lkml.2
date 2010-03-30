Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0C3DAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:00:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0C3DAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:00:09 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=hXE_r7D8ljoA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=wjzBHERUFhrufxORbz0A:9 a=43RRSe44h1U7d5C-vwOsb3UE3x8A:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100330030005.859603521@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 29 Mar 2010 22:58:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing: Fix lockdep warning in global_clock()
References: <20100330025800.713540457@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-lockdep-warning-in-global_clock.patch
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


