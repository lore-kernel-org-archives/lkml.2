Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1ESMtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:49:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64884 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135Ab1ESMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vPXby2Sbn9khdD7DFaxe9eDMqmdPKm+Ljg6WoHdusyXk1CuSYhhI91iHKABOUo9vCN
         mBSfsCA3agUW1wh7yiknvxwo+rwt3eB0j5cCBoxD3qJubawB6KvyXr+hpuZTDQRGvQg4
         v676bd2dmGd2ucOfXvrDYAXnmNPG4oEOWFoLc=
MIME-Version: 1.0
In-Reply-To: <1305732047.2466.7176.camel@twins>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	<BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	<20110512120606.GA3639@zhy>
	<20110518013842.GD23940@home.goodmis.org>
	<BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	<BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
	<1305725044.26849.11.camel@gandalf.stny.rr.com>
	<BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
	<1305731754.11267.3.camel@gandalf.stny.rr.com>
	<1305732047.2466.7176.camel@twins>
Date: Thu, 19 May 2011 20:49:04 +0800
Message-ID: <BANLkTinbFTdr3ckV86CHBTYoYQQkE3eCsg@mail.gmail.com>
Subject: [PATCH resend] sched: correct how RT task is picked
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When picking RT task for given runqueue and CPU, if CPU is less than
zero, then the check for task's CPU affinity is bypassed, which
creates incorrect result if the number of CPUs for the task to run is
bigger than one.
And lets check the case that CPU is not less than zero, if CPU is in
the mask of cpus_allowed and if CPU == rq->cpu, incorrect result could
also be reached if the number of CPUs for the task to run is not
bigger than one.
On the other hand, if CPU is in the mask of cpus_allowed and if CPU !=
rq->cpu, checking nr_cpus_allowed is overwork since it is computed
based on cpus_allowed as seen in set_cpus_allowed_rt().

In the patch the checks for both CPU and nr_cpus_allowed are removed
for correct results in the case that CPU is different from rq->cpu and
in the case that CPU is not.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-19 20:05:46.000000000 +0800
@@ -1149,11 +1149,8 @@ static void deactivate_task(struct rq *r

 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
-	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->rt.nr_cpus_allowed > 1))
-		return 1;
-	return 0;
+	return !task_running(rq, p) &&
+		cpumask_test_cpu(cpu, &p->cpus_allowed);
 }

 /* Return the second highest RT task, NULL otherwise */
