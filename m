Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0IOSrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:47:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0IOSrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:47:51 -0400
Message-ID: <4C9114A6.6040500@oracle.com>
Date: Wed, 15 Sep 2010 11:47:02 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Wright <john.wright@hp.com>
Subject: 2.6.32.y stable kernel regression with taskset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found problem with cpuscaling test.

Under 2.6.32.21   Userspace gov  
min freq load test time is nearly the same as max freq load test time around  ~16 seconds

under 2.6.18-194
min freq load test time is ~40 seconds
max freq load test time	  is ~ 17 seconds

the test is 
1. set governor for one cpu to userspace
2. set freq to min for that cpu
3. using taskset to put load test only on that cpu, and get the time for load test.

so that mean taskset did not put load test on cpu that we want. and other cpu still have ondemand governor and load test get done much faster

git bisect report:

c6fc81afa2d7ef2f775e48672693d8a0a8a7325d is the first bad commit
commit c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
Author: John Wright <john.wright@hp.com>
Date:   Tue Apr 13 16:55:37 2010 -0600

    sched: Fix a race between ttwu() and migrate_task()
    
    Based on commit e2912009fb7b715728311b0d8fe327a1432b3f79 upstream, but
    done differently as this issue is not present in .33 or .34 kernels due
    to rework in this area.
    
    If a task is in the TASK_WAITING state, then try_to_wake_up() is working
    on it, and it will place it on the correct cpu.
    
    This commit ensures that neither migrate_task() nor __migrate_task()
    calls set_task_cpu(p) while p is in the TASK_WAKING state.  Otherwise,
    there could be two concurrent calls to set_task_cpu(p), resulting in
    the task's cfs_rq being inconsistent with its cpu.
    
    Signed-off-by: John Wright <john.wright@hp.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 a9d18950d8edddb761c0266706f671f0e9a006fe 2c3a7d7d5e616ecc276b4e93f4b6e5162a9382c8 M	kernel

diff --git a/kernel/sched.c b/kernel/sched.c
index 2591562..3261c19 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2116,12 +2116,10 @@ migrate_task(struct task_struct *p, int dest_cpu, struct
 
 	/*
 	 * If the task is not on a runqueue (and not running), then
-	 * it is sufficient to simply update the task's cpu field.
+	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p)) {
-		set_task_cpu(p, dest_cpu);
+	if (!p->se.on_rq && !task_running(rq, p))
 		return 0;
-	}
 
 	init_completion(&req->done);
 	req->task = p;
@@ -7167,6 +7165,9 @@ static int __migrate_task(struct task_struct *p, int src_c
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
 		goto done;
+	/* Waking up, don't get in the way of try_to_wake_up(). */
+	if (p->state == TASK_WAKING)
+		goto fail;
 	/* Affinity changed (again). */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;


after reverting it, cpuscaling can pass the test.

BTW, currently mainline is ok.

Thanks

Yinghai Lu
