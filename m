Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2IGNMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:12:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34894 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2IGNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:12:10 -0400
Subject: [RFC][PATCH] Improving directed yield scalability for PLE handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
In-Reply-To: <500D2162.8010209@redhat.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
	 <500D2162.8010209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 07 Sep 2012 08:11:49 -0500
Message-ID: <1347023509.10325.53.camel@oc6622382223.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090713-4242-0000-0000-000002D21938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed recently that PLE/yield_to() is still not that scalable
for really large guests, sometimes even with no CPU over-commit.  I have
a small change that make a very big difference.

First, let me explain what I saw:

Time to boot a 3.6-rc kernel in an 80-way VM on a 4 socket, 40 core, 80
thread Westmere-EX system:  645 seconds!

Host cpu: ~98% in kernel, nearly all of it in spin_lock from double
runqueue lock for yield_to()

So, I added some schedstats to yield_to(), one to count when we failed
this test in yield_to()

    if (task_running(p_rq, p) || p->state)

and one when we pass all the conditions and get to actually yield:

     yielded = curr->sched_class->yield_to_task(rq, p, preempt);


And during boot up of this guest, I saw:


failed yield_to() because task is running: 8368810426
successful yield_to(): 13077658
                      0.156022% of yield_to calls
                      1 out of 640 yield_to calls

Obviously, we have a problem.  Every exit causes a loop over 80 vcpus,
each one trying to get two locks.  This is happening on all [but one]
vcpus at around the same time.  Not going to work well.

So, since the check for a running task is nearly always true, I moved
that -before- the double runqueue lock, so 99.84% of the attempts do not
take the locks.  Now, I do not know is this [not getting the locks] is a
problem.  However, I'd rather have a little inaccurate test for a
running vcpu than burning 98% of CPU in host kernel.  With the change
the VM boot time went to:  100 seconds, an 85% reduction in time.

I also wanted to check to see this did not affect truly over-committed
situations, so I first started with smaller VMs at 2x cpu over-commit:

16 VMs, 8-way each, all running dbench (2x cpu over-commmit)
           throughput +/- stddev
               -----     -----
ple off:        2281 +/- 7.32%  (really bad as expected)
ple on:        19796 +/- 1.36%
ple on: w/fix: 19796 +/- 1.37%  (no degrade at all)

In this case the VMs are small enough, that we do not loop through
enough vcpus to trigger the problem.  host CPU is very low (3-4% range)
for both default ple and with yield_to() fix.

So I went on to a bigger VM:

10 VMs, 16-way each, all running dbench (2x cpu over-commit)
           throughput +/- stddev
               -----     -----
ple on:         2552 +/- .70%
ple on: w/fix:  4621 +/- 2.12%  (81% improvement!)

This is where we start seeing a major difference.  Without the fix, host
cpu was around 70%, mostly in spin_lock.  That was reduced to 60% (and
guest went from 30 to 40%).  I believe this is on the right track to
reduce the spin lock contention, still get proper directed yield, and
therefore improve the guest CPU available and its performance.

However, we still have lock contention, and I think we can reduce it
even more.  We have eliminated some attempts at double runqueue lock
acquire because the check for the target vcpu is running is now before
the lock.  However, even if the target-to-yield-to vcpu [for the same
guest upon we PLE exited] is not running, the physical
processor/runqueue that target-to-yield-to vcpu is located on could be
running a different VM's vcpu -and- going through a directed yield,
therefore that run queue lock may already acquired.  We do not want to
just spin and wait, we want to move to the next candidate vcpu.  We need
a check to see if the smp processor/runqueue is already in a directed
yield.  Or, perhaps we just check if that cpu is not in guest mode, and
if so, we skip that yield attempt for that vcpu and move to the next
candidate vcpu.  So, my question is:  given a runqueue, what's the best
way to check if that corresponding phys cpu is not in guest mode?

Here's the changes so far (schedstat changes not included here):

signed-off-by:  Andrew Theurer <habanero@linux.vnet.ibm.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..f8eff8c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4844,6 +4844,9 @@ bool __sched yield_to(struct task_struct *p, bool
preempt)
 
 again:
 	p_rq = task_rq(p);
+	if (task_running(p_rq, p) || p->state) {
+		goto out_no_unlock;
+	}
 	double_rq_lock(rq, p_rq);
 	while (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
@@ -4856,8 +4859,6 @@ again:
 	if (curr->sched_class != p->sched_class)
 		goto out;
 
-	if (task_running(p_rq, p) || p->state)
-		goto out;
 
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
 	if (yielded) {
@@ -4879,6 +4880,7 @@ again:
 
 out:
 	double_rq_unlock(rq, p_rq);
+out_no_unlock:
 	local_irq_restore(flags);
 
 	if (yielded)

  




