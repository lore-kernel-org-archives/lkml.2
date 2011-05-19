Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1ESIcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:32:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57245 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab1ESIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oH/gRLAeqGo6yDJSW3eItI90GxTaQhzAIrrjyp1yPd3aa2oWQDXSP7I1ZC/Lulnals
         o3pBZlQ7kUj094y+i2c6uxSimt7w9FkbUs3tVR8vwFbB123VcrBYeHRnVav46dFQa8uY
         DyVS/CS20VBGEKDFwgsmJQGZuibU689jn67RA=
Subject: [PATCH -tip] rcu: use kthread_create_on_node()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 10:32:45 +0200
Message-ID: <1305793965.3028.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a26ac2455ffc (move TREE_RCU from softirq to kthread) added
creation of per cpu kthreads.

Use kthread_create_on_node() NUMA friendly function, to let these
threads use local node for their stack/task struct.

We did a similar change in commit 94dcf29a11b3 (kthread: use
kthread_create_on_node())

Also change rcu torture kthread creation.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutorture.c |    3 ++-
 kernel/rcutree.c    |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e138db..40d9ed2 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1282,7 +1282,8 @@ static int rcutorture_booster_init(int cpu)
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
-	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
+	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
+						  cpu_to_node(cpu),
 					  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..b013915 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1649,7 +1649,10 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (!rcu_kthreads_spawnable ||
 	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
 		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	t = kthread_create_on_node(rcu_cpu_kthread,
+				   (void *)(long)cpu,
+				   cpu_to_node(cpu),
+				   "rcuc%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	kthread_bind(t, cpu);


