Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1AZS75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:59:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab1AZS74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:59:56 -0500
Date: Wed, 26 Jan 2011 19:51:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] fix the theoretical task_cpu/task_curr problem in
	kick_process/task_oncpu_function_call
Message-ID: <20110126185159.GB32578@redhat.com>
References: <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126184957.GA32578@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kick_process() and task_oncpu_function_call() are not right, they
can use the dead CPU for smp_send_reschedule/smp_call_function_single
if try_to_wake_up() makes this task running after we read task_cpu().

Given that task_curr() is inline this problem is pure theoretical,
compiler doesn't read task_cpu() twice, but the code looks wrong.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- perf/kernel/sched.c~task_cpu_vs_task_curr	2011-01-26 19:26:40.000000000 +0100
+++ perf/kernel/sched.c	2011-01-26 19:26:58.000000000 +0100
@@ -2269,7 +2269,7 @@ void kick_process(struct task_struct *p)
 
 	preempt_disable();
 	cpu = task_cpu(p);
-	if ((cpu != smp_processor_id()) && task_curr(p))
+	if ((cpu != smp_processor_id()) && (cpu_curr(cpu) == p))
 		smp_send_reschedule(cpu);
 	preempt_enable();
 }
@@ -2292,7 +2292,7 @@ void task_oncpu_function_call(struct tas
 
 	preempt_disable();
 	cpu = task_cpu(p);
-	if (task_curr(p))
+	if (cpu_curr(cpu) == p)
 		smp_call_function_single(cpu, func, info, 1);
 	preempt_enable();
 }

