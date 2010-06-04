Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0FDBgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:36:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab0FDBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:35:59 -0400
X-Authority-Analysis: v=1.1 cv=xm0otvE9/LjRWYlyDrHfx7zP0/MGCmNk7gQgTP1ehto= c=1 sm=0 a=m9zbCL8xMT8A:10 a=UBIxAjGgU1YA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=8kKieykxIYvStuLX--4A:9 a=YxcNidWMb_avnU1gOT0A:7 a=F0ponAG3pTEazdB52fQku1Q2El4A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100604013557.137176726@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Jun 2010 21:35:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing/sched: Make preempt_schedule() notrace
References: <20100604013506.159506222@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-sched-Make-preempt_schedule-notrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracer code uses ftrace_preempt_disable() to disable
preemption instead of normal preempt_disable(). But there's a slight
race condition that may cause it to lose a preemption check.

This was made to keep the function tracer from recursing on itself
by disabling preemption then having the enable call the function tracer
again, causing infinite recursion.

The bug was assumed to happen if the call was just in schedule, but
this is incorrect. The bug is caused by preempt_schedule() which
is called by preempt_enable(). The calling of preempt_enable() when
NEED_RESCHED was set would call preempt_schedule() which would call
the function tracer again.

By making the preempt_schedule() and add_preempt_count() notrace
then this will prevent the inifinite recursion. This is because
the add_preempt_count() would stop the preempt_enable() in the
function tracer from calling preempt_schedule() again.

The sub_preempt_count() is also made notrace just to keep it
symmetric.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 15b93f6..cd6787e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3730,7 +3730,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
  * off of preempt_enable. Kernel preemptions off return from interrupt
  * occur there and call schedule directly.
  */
-asmlinkage void __sched preempt_schedule(void)
+asmlinkage void __sched notrace preempt_schedule(void)
 {
 	struct thread_info *ti = current_thread_info();
 
@@ -3742,9 +3742,9 @@ asmlinkage void __sched preempt_schedule(void)
 		return;
 
 	do {
-		add_preempt_count(PREEMPT_ACTIVE);
+		add_preempt_count_notrace(PREEMPT_ACTIVE);
 		schedule();
-		sub_preempt_count(PREEMPT_ACTIVE);
+		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
-- 
1.7.0


