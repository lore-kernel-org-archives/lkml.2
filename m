Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1EJNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:04:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1EJNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=N9eAMI28FpOXb8NXRSS9Q0QGcENjtLJyges8vjr+faAw9b2VNJz8S4XE33mOfkIuyR
         04/y5cMkXVINYFu1DXN/E8/1fiyQGvEd7A6+jLJwGQxK0RtGap+vQuKH53/dZsUKJ7pD
         /kTYoPgnMZ5zIjCNWoBl4qUtcmwCVYyIwB+7w=
MIME-Version: 1.0
Date: Tue, 10 May 2011 21:04:15 +0800
Message-ID: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
Subject: [PATCH] sched: correct how RT task is picked
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When picking RT task for given CPU,
[1] if the cpu is invalid for cpumask test, right result could not be
reached even by further checking nr_cpus_allowed,
on the other hand, the input cpu is valid in two cases that
pick_next_highest_task_rt() is called, thus the invalid input cpu
looks over-concern.
[2] if the cpu is valid for cpumask test, further checking
nr_cpus_allowed looks overwork, since it is computed based on
cpus_allowed,
what is more, the combination of cpus_allowed and nr_cpus_allowed
could lead to incorrect result if the input cpu == rq->cpu, as in the
case of next_prio() where no pulling task is concerned.

In this work, invalid cpu is not removed but leads to negative result,
but nr_cpus_allowed is.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-10 20:30:38.000000000 +0800
@@ -1149,10 +1149,12 @@ static void deactivate_task(struct rq *r

 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
-	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->rt.nr_cpus_allowed > 1))
-		return 1;
+	if (!task_running(rq, p)) {
+		if (cpu < 0)
+			return 0;
+		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
+			return 1;
+	}
 	return 0;
 }
