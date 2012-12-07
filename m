Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2LHAJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:09:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2LHAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:09:03 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7rGhMGw_aYQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=a3FCvQcZPK8A:10 a=CJNL06MskVrAI5SoftQA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121208000900.747763148@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Dec 2012 18:56:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH RT 4/4] sched/rt: Initiate a pull when the priority of a task is lowered
References: <20121207235615.206108556@goodmis.org>
Content-Disposition: inline; filename=rt-migrate-redo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task lowers its priority (say by losing priority inheritance)
if a higher priority task is waiting on another CPU, initiate a pull.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched/rt.c
===================================================================
--- linux-rt.git.orig/kernel/sched/rt.c
+++ linux-rt.git/kernel/sched/rt.c
@@ -997,6 +997,8 @@ inc_rt_prio(struct rt_rq *rt_rq, int pri
 	inc_rt_prio_smp(rt_rq, prio, prev_prio);
 }
 
+static int pull_rt_task(struct rq *this_rq);
+
 static void
 dec_rt_prio(struct rt_rq *rt_rq, int prio)
 {
@@ -1021,6 +1023,9 @@ dec_rt_prio(struct rt_rq *rt_rq, int pri
 		rt_rq->highest_prio.curr = MAX_RT_PRIO;
 
 	dec_rt_prio_smp(rt_rq, prio, prev_prio);
+
+	if (prev_prio < rt_rq->highest_prio.curr)
+		pull_rt_task(rq_of_rt_rq(rt_rq));
 }
 
 #else

