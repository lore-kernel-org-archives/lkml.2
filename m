Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1EYOAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:00:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab1EYOAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fSQXF8qpnCQRHLZYiKJvvCAeF9SfzlKPXc5r6HCgM/rimWrov9pIJbNjGKWrT3lsdI
         eDupqwJcx9YKuuR7L6xTMI9j9aefm0n2MB3/isxRkZCseHt57731R/OaauSMROWxyS7g
         5NpzJnCrV0G1isN6K0Z9rD0gYGz5nCGc2TxRg=
MIME-Version: 1.0
In-Reply-To: <1306248401.1465.69.camel@gandalf.stny.rr.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	<1306244836.2497.60.camel@laptop>
	<BANLkTik6cc+jA3Ft4wOTWPwKhOheUM-VbQ@mail.gmail.com>
	<1306247058.1465.66.camel@gandalf.stny.rr.com>
	<BANLkTimynA+wdsEwayzdDZRTPeZHRoDtgg@mail.gmail.com>
	<1306248401.1465.69.camel@gandalf.stny.rr.com>
Date: Wed, 25 May 2011 22:00:03 +0800
Message-ID: <BANLkTin-feweuE_vm_x1Ex8Yr4ezsJ2wKA@mail.gmail.com>
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-24 at 22:33 +0800, Hillf Danton wrote:
>> On Tue, May 24, 2011 at 10:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, 2011-05-24 at 22:01 +0800, Hillf Danton wrote:
>> >> On Tue, May 24, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
>> >> >> If there are pushable tasks and they are high enough in priority, in which
>> >> >> case task p is covered, the current could keep holding its CPU.
>> >> >
>> >> > -ENOPARSE..
>> >> >
>> >>
>> >> Here the priority is same, then pushing task p off has little difference from
>> >> pushing any other pushable.
>> >
>> > If task p is currently running and is a FIFO task, you do not push it
>> > off for another task of same prio.
>> >
>> If it is one of the current principles in RT schedule, the patch has
>> to be dropped.
>>
>
> Yes, that is the definition of FIFO (First In First Out). The tasks that
> get to the CPU first run till they voluntarily schedule away, or are
> preempted by an even high priority task. Tasks of the same priority must
> wait till the previous task has finished.
>

Then I try to fix the violation of FIFO, my thought is like below:

---
Subject: [PATCH] sched: fix the violation of SCHED_FIFO in
check_preempt_equal_prio()

Starvation of the same priority tasks is a perfectly valid situation for
SCHED_FIFO.

If task p is currently running and is a FIFO task, you do not push it
off for another task of same prio.
Yes, that is the definition of FIFO (First In First Out). The tasks that
get to the CPU first run till they voluntarily schedule away, or are
preempted by an even high priority task. Tasks of the same priority must
wait till the previous task has finished.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/include/linux/sched.h	Sat May 14 15:21:53 2011
+++ sched.h	Wed May 25 21:24:22 2011
@@ -1159,7 +1159,7 @@ struct sched_rt_entity {
 	unsigned long timeout;
 	unsigned int time_slice;
 	int nr_cpus_allowed;
-
+	struct rq *last_rq;
 	struct sched_rt_entity *back;
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity	*parent;
--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Wed May 25 21:41:02 2011
@@ -933,6 +933,7 @@ static void dequeue_task_rt(struct rq *r
 {
 	struct sched_rt_entity *rt_se = &p->rt;

+	rt_se->last_rq = rq;
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);

@@ -1030,6 +1031,13 @@ select_task_rq_rt(struct task_struct *p,

 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
+	if (p->rt.last_rq == rq)
+		/*
+		 * if task is not newcomer,
+		 * simply preempt current for the sake of SCHED_FIFO.
+		 */
+		goto sched;
+
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;

@@ -1045,6 +1053,7 @@ static void check_preempt_equal_prio(str
 	 * current and none to run 'p', so lets reschedule
 	 * to try and push current away:
 	 */
+sched:
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
 }
