Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1EYMs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:48:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59315 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab1EYMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WX+r5U0hWF7Olry02iNYNF/8M/Lkw3CSlmkZP3PXog6Zj2eEkeg/HkfFd93Ws2oyYC
         JAMh6wGg/nLwGXEAuPORgnOlfQjRPtTJ9fGVSnZLYPg1fg3TBkR9QQoVi4X3BI/jsVCZ
         DH7D2myu1UPmJdl0VyqonCDl6gfbECXXwe9/o=
MIME-Version: 1.0
Date: Wed, 25 May 2011 20:48:26 +0800
Message-ID: <BANLkTi=ybwWg9z6tKaAL-BfeSmsq6EL-=Q@mail.gmail.com>
Subject: [PATCH] sched: deduplicate atomic operations in select_nohz_load_balancer()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two atomic-related operations, atomic_read and atomic_cmpxchg, are
used here to do the job. Since comparison is already included in the
later, the former is folded in the later, and operation is shorter.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_fair.c	Sat May 14 15:21:56 2011
+++ sched_fair.c	Wed May 25 20:15:34 2011
@@ -3806,35 +3806,25 @@ void select_nohz_load_balancer(int stop_

 	if (stop_tick) {
 		if (!cpu_active(cpu)) {
-			if (atomic_read(&nohz.load_balancer) != cpu)
-				return;
-
 			/*
 			 * If we are going offline and still the leader,
 			 * give up!
 			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
+			atomic_cmpxchg(&nohz.load_balancer, cpu, nr_cpu_ids);

 			return;
 		}

 		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);

-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);

-		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
+		/* make me the ilb owner */
+		if (nr_cpu_ids ==
+		    atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids, cpu)) {
 			int new_ilb;

-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
-					   cpu) != nr_cpu_ids)
-				return;
-
 			/*
 			 * Check to see if there is a more power-efficient
 			 * ilb.
@@ -3853,10 +3843,7 @@ void select_nohz_load_balancer(int stop_

 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);

-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
+		atomic_cmpxchg(&nohz.load_balancer, cpu, nr_cpu_ids);
 	}
 	return;
 }
