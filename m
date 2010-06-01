Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0FANGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:06:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50827 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab0FANGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YBVaCqACG1p1yykM8+hCu5KvWvA4/LmX4H6/MwVEQYrjkPFXDqZT0DnvdyyxNpOIuL
         Ew1VbE5cSPhykVMawn0eQrl/B9m+gFXPBr4wMoQn9hXWxFkCZM1qkY3CrwdqmhGbjhKV
         xv6dGe1/sqvrurbbopbPQ+cXPIi10th+nRk7w=
MIME-Version: 1.0
Date: Tue, 1 Jun 2010 14:06:13 +0100
Message-ID: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious 
	rcu_dereference_check() usage
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

With 2.6.35-rc1 and your patch in the context below, we still see
"include/linux/cgroup.h:534 invoked rcu_dereference_check() without
protection!", so need this additional patch:

Acquire read-side RCU lock around task_group() calls, addressing
"include/linux/cgroup.h:534 invoked rcu_dereference_check() without
protection!" warning.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 217e4a9..50ec9ea 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1241,6 +1241,7 @@ static int wake_affine(struct sched_domain *sd,
struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
+	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1250,6 +1251,7 @@ static int wake_affine(struct sched_domain *sd,
struct task_struct *p, int sync)
 	}

 	tg = task_group(p);
+	rcu_read_unlock();
 	weight = p->se.load.weight;

 	imbalance = 100 + (sd->imbalance_pct - 100) / 2;

---

On Wed, Apr 21, 2010 at 02:35:43PM -0700, Paul E. McKenney wrote:
    On Tue, Apr 20, 2010 at 11:38:28AM -0400, Miles Lane wrote:
        Excellent. Here are the results on my machine. .config appended.
    First, thank you very much for testing this, Miles!

And as Tetsuo Handa pointed out privately, my patch was way broken.

Here is an updated version.

Thanx, Paul

commit b15e561ed91b7a366c3cc635026f3b9ce6483070
Author: Paul E. McKenney <paulmck@xxxxxxxxxxxxxxxxxx>
Date: Wed Apr 21 14:04:56 2010 -0700

sched: protect __sched_setscheduler() access to cgroups

A given task's cgroups structures must remain while that task is running
due to reference counting, so this is presumably a false positive.
Updated to reflect feedback from Tetsuo Handa.

Signed-off-by: Paul E. McKenney <paulmck@xxxxxxxxxxxxxxxxxx>

diff --git a/kernel/sched.c b/kernel/sched.c
index 14c44ec..f425a2b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4575,9 +4575,13 @@ recheck:
* Do not allow realtime tasks into groups that have no runtime
* assigned.
*/
+ rcu_read_lock();
if (rt_bandwidth_enabled() && rt_policy(policy) &&
- task_group(p)->rt_bandwidth.rt_runtime == 0)
+ task_group(p)->rt_bandwidth.rt_runtime == 0) {
+ rcu_read_unlock();
return -EPERM;
+ }
+ rcu_read_unlock();
#endif

retval = security_task_setscheduler(p, policy, param);
-- 
Daniel J Blueman
