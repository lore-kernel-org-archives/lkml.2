Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab1FAN65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:58:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65202 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab1FAN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hc+6hBhRr5wWwEOEwPfNFIdFDHJhwGz+C52PmLtiHSWubfW34G+HfpWo08/O9wmYJc
         GQfgfANfrWgRqUV3kOALlC3YFPq2IN2ZD3XJo8wsPSptQLDE7BjPK7zpqOLXa+Hwt+js
         y+s0rKDcaUZMw+IfxvL6CIPOIE4gxG6I17OHc=
MIME-Version: 1.0
Date: Wed, 1 Jun 2011 21:58:54 +0800
Message-ID: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
Subject: [PATCH] sched: fix conflict of schedule domain balance in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SD_BALANCE_WAKE and SD_WAKE_AFFINE are defined to be mutually exclusive, and
are checked in select_task_rq_rt() and find_lowest_rq() respectively.

The target cpu that is elected only from schedule domains of SD_WAKE_AFFINE if
CPU topology concerned, conflicts with the SD_BALANCE_WAKE requirement.

And checking for cache-hot is also added to confirm the comment there.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..87c44e6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1005,7 +1005,7 @@ select_task_rq_rt(struct task_struct *p, int
sd_flag, int flags)
 	struct rq *rq;
 	int cpu;

-	if (sd_flag != SD_BALANCE_WAKE)
+	if (!(sd_flag & SD_BALANCE_WAKE))
 		return smp_processor_id();

 	cpu = task_cpu(p);
@@ -1253,7 +1253,8 @@ static int find_lowest_rq(struct task_struct *task)
 	 * We prioritize the last cpu that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
-	if (cpumask_test_cpu(cpu, lowest_mask))
+	if (cpumask_test_cpu(cpu, lowest_mask) &&
+	    task_hot(task, task_rq(task)->clock_task, NULL))
 		return cpu;

 	/*
@@ -1265,7 +1266,7 @@ static int find_lowest_rq(struct task_struct *task)

 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_AFFINE) {
+		if (sd->flags & (SD_WAKE_AFFINE | SD_BALANCE_WAKE)) {
 			int best_cpu;

 			/*
