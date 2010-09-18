Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0IRTKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:10:07 -0400
Received: from kroah.org ([198.145.64.141]:51805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab0IRTCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:20 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.730346214@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Daniel J Blueman <daniel.blueman@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [104/123] sched: apply RCU protection to wake_affine()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-apply-rcu-protection-to-wake_affine.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit f3b577dec1f2ce32d2db6d2ca6badff7002512af upstream

The task_group() function returns a pointer that must be protected
by either RCU, the ->alloc_lock, or the cgroup lock (see the
rcu_dereference_check() in task_subsys_state(), which is invoked by
task_group()).  The wake_affine() function currently does none of these,
which means that a concurrent update would be within its rights to free
the structure returned by task_group().  Because wake_affine() uses this
structure only to compute load-balancing heuristics, there is no reason
to acquire either of the two locks.

Therefore, this commit introduces an RCU read-side critical section that
starts before the first call to task_group() and ends after the last use
of the "tg" pointer returned from task_group().  Thanks to Li Zefan for
pointing out the need to extend the RCU read-side critical section from
that proposed by the original patch.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1250,6 +1250,7 @@ static int wake_affine(struct sched_doma
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
+	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1275,6 +1276,7 @@ static int wake_affine(struct sched_doma
 	balanced = !this_load ||
 		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
+	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within


