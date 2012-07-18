Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2GRS6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:58:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2GRS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:58:12 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH] tracing: Remove unneeded checks from the stack tracer
Date: Wed, 18 Jul 2012 11:56:01 -0700
Message-Id: <1342637761-9655-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that 'ftrace_enabled' flag should not be used inside the tracer
functions. The ftrace core is using this flag for internal purposes, and
the flag wasn't meant to be used in tracers' runtime checks.

stack tracer is the only tracer that abusing the flag. So stop it from
serving as a bad example.

Also, there is a local 'stack_trace_disabled' flag in the stack tracer,
which is never updated; so it can be removed as well.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/trace/trace_stack.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index d4545f4..94c2c53 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -33,7 +33,6 @@ static unsigned long max_stack_size;
 static arch_spinlock_t max_stack_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
-static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
 static DEFINE_MUTEX(stack_sysctl_mutex);
 
@@ -115,9 +114,6 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
 	int cpu;
 
-	if (unlikely(!ftrace_enabled || stack_trace_disabled))
-		return;
-
 	preempt_disable_notrace();
 
 	cpu = raw_smp_processor_id();
-- 
1.7.10.4

