Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0HCV3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:29:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0HCV3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:29:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=r5m1rjaKBf26/0FPSsWyjsjnSCXpaVl3afiKSALxInTwERyjIJ9ZfUkC/DMKwE8eF
	G4w3pm1eE7pTHQuDW2k5g==
MIME-Version: 1.0
In-Reply-To: <1280749178.1923.114.camel@laptop>
References: <1280467146-32218-1-git-send-email-ncrao@google.com> 
	<1280749178.1923.114.camel@laptop>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 3 Aug 2010 14:28:37 -0700
Message-ID: <AANLkTimMyUd9BxXO5JxgpAiAKCJAS1xZiTXTgp+GKSU0@mail.gmail.com>
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to inefficient 
	load balancing
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Thanks for the feedback!

On Mon, Aug 2, 2010 at 4:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> The thing is that from a fairness point of view 1 nice-0 (weight=1024)
> on one CPU and 512 SCHED_IDLE (weight=2) tasks on another CPU and all
> other CPUs idle is correct.
>
> It just doesn't seem to be the thing that most people expect.
>
> Special casing things like you've done is utterly the wrong thing to do.
>

I see your point here, and yes I agree having 1 nice-0 on one cpu, 512
SCHED_IDLE tasks on another cpu and all other cpus idle is correct if
we only considered fairness. However, we would also like to maximize
machine utilization. The fitness function we would ideally like to
optimize for is a combination of both fairness and utilization.

I'm going to take a step back here and explain the bigger problem we
are trying to solve. We have two types of workloads -- high priority
tasks that need to run for short periods of time and can consume as
much cpu as required when they run; and low priority tasks that
ideally consume slack cpu. Let's say we had a machine with enough
tasks to soak up all the cpus. There are two cases to implement the
priority scheme.

The first case is to run all tasks run as SCHED_NORMAL. The machine is
fully utilized but this has other side-effects. Low priority tasks
consume much more cpu than we would like, they get to preempt high
priority tasks, and this results in poor performance of high priority
tasks.

The second case is to run high priority tasks as SCHED_NORMAL and low
priority tasks as SCHED_IDLE. We choose SCHED_IDLE to minimize
interference with high priority tasks -- we don't want low priority
tasks to preempt high priority or to be favored over high priority
tasks in any way. When there are high priority tasks, we want low
priority tasks to get as little cpu as possible; thus giving them the
minimum possible weight works out well. In this case, we are able to
isolate high prio tasks from low prio tasks reasonably well. However,
sub-optimal machine utilization defeats the purpose of packing a
machine with lots of low priority tasks as we are not able to consume
the slack cpu.

This RFC is really meant to explain the problem that we are facing. We
presented one possible solution to fix this but we are also open to
other suggestions and ideas.

> This problem comes in two forms and its name is infeasible weight
> distribution. The load-balancer tries to ensure W_k ~= W_l, k,l elem_of
> CPUs, where W_k = \Sum_i w_i^k, where w_i^k is the i-th task on CPU k.
>
> The two cases are statically infeasible, and dynamically infeasible.
>
> We say the task-set is statically infeasible if for a task set of n
> tasks there is no way to statically distribute them on N <= n CPUs such
> that each task gets equal service (assuming the scheduling on each CPU
> is fair).
>
> We say the task-set is dynamically infeasible if for the given scenario
> there is no way to rotate the tasks to obtain equality.
>
> Lets assume 2 CPUs.
>
> Ex.1: 2 tasks of different weight.
>
> Ex.2: 3 tasks of equal weight.
>
> The first example is both statically and dynamically infeasible as there
> is no way to occupy both CPUs such that each task gets the proportional
> correct service.
>
> The second example is statically infeasible, but dynamically feasible,
> for if we rotate one task, such that we alternate between 2:1 and 1:2 in
> equal measures, each task will receive its correct 2/3rd CPU service.
>
> The current load-balancer isn't particularly skilled at either issue.
>
> The proper solution is to 'fix' find_busiest_group() so that it will:
>  - pick the heaviest cpu with more than 1 task on it
>  - slowly over-balance things
>
> The first thing will solve your issue.
>

Thanks for your suggestions; I explored the first one a bit and I
added a check into find_busiest_queue() (instead of
find_busiest_group()) to skip a cpu if it has only 1 task on it (patch
attached below - did you have something else in mind?). This fixes the
example I posted in the RFC, but it doesn't work as well when the
SCHED_NORMAL tasks have a sleep/wakeup pattern. I have some data below
where the load balancer fails to fully utilize a machine. In these
examples, I ran with the upstream kernel and with a kernel compiled
with the check in fbq().

Setup: We run 16 SCHED_IDLE soakers and about half as many
SCHED_NORMAL tasks which have 100ms / 100ms sleep/busy cycles. This is
actually a very common use case that we run into.

2.6.35-rc6

12:41:45 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft
%steal   %idle    intr/s
12:41:46 PM  all   97.50    0.00    0.00    0.00    0.00    0.00
0.00    2.50  16405.00
12:41:47 PM  all   89.72    0.00    0.06    0.00    0.00    0.00
0.00   10.22  15736.00
12:41:48 PM  all   90.54    0.06    0.06    0.00    0.00    0.00
0.00    9.34  15791.09
12:41:49 PM  all   93.00    0.00    0.06    0.00    0.00    0.00
0.00    6.93  15816.83
12:41:50 PM  all   96.44    0.00    0.06    0.00    0.00    0.06
0.00    3.44  16362.00
12:41:51 PM  all   97.62    0.00    0.06    0.00    0.00    0.00
0.00    2.31  16326.00
12:41:52 PM  all   99.56    0.00    0.06    0.00    0.00    0.00
0.00    0.38  16512.12
12:41:53 PM  all   99.06    0.00    0.06    0.00    0.00    0.00
0.00    0.88  16289.00
12:41:54 PM  all   99.50    0.00    0.06    0.00    0.00    0.00
0.00    0.44  16149.50
12:41:55 PM  all   98.06    0.00    0.06    0.00    0.00    0.00
0.00    1.88  16405.05
Average:     all   96.10    0.01    0.06    0.00    0.00    0.01
0.00    3.83  16177.92

2.6.35-rc6 + fbg-fix

12:42:48 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft
%steal   %idle    intr/s
12:42:49 PM  all   98.07    0.00    0.06    0.00    0.00    0.00
0.00    1.87  16346.00
12:42:50 PM  all   98.75    0.00    0.12    0.00    0.00    0.00
0.00    1.12  16236.63
12:42:51 PM  all   99.56    0.06    0.19    0.00    0.00    0.00
0.00    0.19  16616.16
12:42:52 PM  all   97.94    0.00    0.06    0.00    0.00    0.06
0.00    1.94  16348.00
12:42:53 PM  all   96.94    0.00    0.25    0.00    0.00    0.00
0.00    2.81  16234.65
12:42:54 PM  all   98.56    0.06    0.06    0.00    0.00    0.00
0.00    1.31  16339.00
12:42:55 PM  all   97.56    0.00    0.19    0.00    0.00    0.00
0.00    2.25  16570.71
12:42:56 PM  all   99.50    0.00    0.06    0.00    0.00    0.00
0.00    0.44  16400.00
12:42:57 PM  all   95.25    0.00    0.37    0.00    0.00    0.00
0.00    4.37  16367.00
12:42:58 PM  all   97.75    0.00    0.06    0.00    0.00    0.00
0.00    2.19  16409.00
Average:     all   97.99    0.01    0.14    0.00    0.00    0.01
0.00    1.85  16386.00

-Thanks,
Nikhil

---
fqb-fix patch:

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..e05c61f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2742,13 +2742,8 @@ find_busiest_queue(struct sched_group *group,
enum cpu_idle_type idle,
                        continue;

                rq = cpu_rq(i);
-               wl = weighted_cpuload(i);

-               /*
-                * When comparing with imbalance, use weighted_cpuload()
-                * which is not scaled with the cpu power.
-                */
-               if (capacity && rq->nr_running == 1 && wl > imbalance)
+               if (capacity && rq->nr_running == 1)
                        continue;

                /*
@@ -2757,6 +2752,7 @@ find_busiest_queue(struct sched_group *group,
enum cpu_idle_type idle,
                 * the load can be moved away from the cpu that is potentially
                 * running at a lower capacity.
                 */
+               wl = weighted_cpuload(i);
                wl = (wl * SCHED_LOAD_SCALE) / power;

                if (wl > max_load) {
