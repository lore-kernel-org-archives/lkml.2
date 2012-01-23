Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2AWSlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:41:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34204 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab2AWSle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:41:34 -0500
Message-ID: <4F1DA9D0.6090208@fb.com>
Date: Mon, 23 Jan 2012 10:41:20 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com> <1327318449.2446.5.camel@twins>
In-Reply-To: <1327318449.2446.5.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-23_04:2012-01-22,2012-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/12 3:34 AM, Peter Zijlstra wrote:

> Its not just your tracepoint data being wrong, it'll wreck all related
> stats :/

I see: these stats are also used in sched_debug.c.

>
> This'll fail to compile for !CONFIG_SCHEDSTAT I guess.. I should have
> paid more attention to the initial patch, that tracepoint having
> side-effects is a big no-no.
>
> Having unconditional writes there is somewhat sad, but I suspect putting
> a conditional around it isn't going to help much..

For performance reasons?


> bah can we
> restructure things so we don't need this?
>

We can go back to the old code, where these values were getting reset in 
{en,de}queue_sleeper(). But we'll have to do it conditionally, so the 
values are preserved till context switch time when we need it there.

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1003,6 +1003,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, 
struct sched_entity *se)
                 if (unlikely(delta > se->statistics.sleep_max))
                         se->statistics.sleep_max = delta;

+               if (!trace_sched_stat_sleeptime_enabled())
+                       se->statistics.sleep_start = 0;
                 se->statistics.sum_sleep_runtime += delta;

                 if (tsk) {
@@ -1019,6 +1021,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, 
struct sched_entity *se)
                 if (unlikely(delta > se->statistics.block_max))
                         se->statistics.block_max = delta;

+               if (!trace_sched_stat_sleeptime_enabled())
+                       se->statistics.block_start = 0;
                 se->statistics.sum_sleep_runtime += delta;

                 if (tsk) {

This looks pretty ugly too, I don't know how to check for a tracepoint 
being active (Steven?). The only advantage of this approach is that it's 
in the sleep/wakeup path, rather than the context switch path.

Conceptually, the following seems to be the simplest:

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1939,8 +1939,10 @@ static void finish_task_switch(struct rq *rq, 
struct task_struct *prev)
         finish_lock_switch(rq, prev);

         trace_sched_stat_sleeptime(current, rq->clock);
+#ifdef CONFIG_SCHEDSTAT
         current->se.statistics.block_start = 0;
         current->se.statistics.sleep_start = 0;
+#endif /* CONFIG_SCHEDSTAT */

Perhaps we can reorder fields in sched_statistics so we touch one 
cacheline here instead of two?

  -Arun
