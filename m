Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1DWNjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:39:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62439 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1DWNjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ic5er7hDGXP+3uQs6B2MeFTAfVa4WtG8Y2xhkhqja6YK39SUBQbP/GFZhaaAzckd1E
         qUrCjQYw9uFl1yhiSqhOnvoDdeWlRKXF9jVYN+fd2Nx7EQAqVNYC8fTIWZvXWn/2DLuf
         /s0CuvUciIKL0yUlKnhPWq5kYtg6nLV6W9q18=
MIME-Version: 1.0
Date: Sat, 23 Apr 2011 21:39:40 +0800
Message-ID: <BANLkTimyN49J0UTo69Rabppeow9Fz-LcfQ@mail.gmail.com>
Subject: [PATCH] sched: try to rewrite tg_has_rt_tasks()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reshuffled not based upon scanning the list of existing threads
but upon the relevant info carried by the input task group. Compared
with the original, it is simpler, and nothing important is missed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/sched.c	2011-04-23 21:48:14.000000000 +0800
@@ -8756,13 +8756,11 @@ static unsigned long to_ratio(u64 period
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
-	struct task_struct *g, *p;
-
-	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+	int cpu;
+	for_each_online_cpu(cpu) {
+		if (tg->rt_rq[cpu]->rt_nr_running != 0)
 			return 1;
-	} while_each_thread(g, p);
-
+	}
 	return 0;
 }
