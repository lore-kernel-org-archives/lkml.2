Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1HOSyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:54:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab1HOSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:54:01 -0400
Date: Mon, 15 Aug 2011 20:49:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: more safe tasklist locking in
	cgroup_attach_proc
Message-ID: <20110815184957.GA16588@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu> <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown> <20110728062616.GC15204@unix33.andrew.cmu.edu> <20110728171345.67d3797d@notabene.brown> <20110729142842.GA8462@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729142842.GA8462@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Ben Blum wrote:
>
> According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
> not sufficient to guarantee the tasklist is stable w.r.t. de_thread and
> exit. Taking tasklist_lock for reading, instead of rcu_read_lock,
> ensures proper exclusion.

Yes.

So far I still think we should fix while_each_thread() so that it works
under rcu_read_lock() "as exepected", I'll try to think more.

But whatever we do with while_each_thread(), this can't help
cgroup_attach_proc(), it needs the locking.

> -	rcu_read_lock();
> +	read_lock(&tasklist_lock);
>  	if (!thread_group_leader(leader)) {

Agreed, this should work.

But can't we avoid the global list? thread_group_leader() or not, we do
not really care. We only need to ensure we can safely find all threads.

How about the patch below?


With or without this/your patch this leader can die right after we
drop the lock. ss->can_attach(leader) and ss->attach(leader) look
suspicious. If a sub-thread execs, this task_struct has nothing to
do with the threadgroup.



Also. This is off-topic, but... Why cgroup_attach_proc() and
cgroup_attach_task() do ->attach_task() + cgroup_task_migrate()
in the different order? cgroup_attach_proc() looks wrong even
if currently doesn't matter.


Oleg.

--- x/kernel/cgroup.c
+++ x/kernel/cgroup.c
@@ -2000,6 +2000,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	/* threadgroup list cursor and array */
 	struct task_struct *tsk;
 	struct flex_array *group;
+	unsigned long flags;
 	/*
 	 * we need to make sure we have css_sets for all the tasks we're
 	 * going to move -before- we actually start moving them, so that in
@@ -2027,19 +2028,10 @@ int cgroup_attach_proc(struct cgroup *cg
 		goto out_free_group_list;
 
 	/* prevent changes to the threadgroup list while we take a snapshot. */
-	rcu_read_lock();
-	if (!thread_group_leader(leader)) {
-		/*
-		 * a race with de_thread from another thread's exec() may strip
-		 * us of our leadership, making while_each_thread unsafe to use
-		 * on this task. if this happens, there is no choice but to
-		 * throw this task away and try again (from cgroup_procs_write);
-		 * this is "double-double-toil-and-trouble-check locking".
-		 */
-		rcu_read_unlock();
-		retval = -EAGAIN;
+	retval = -EAGAIN;
+	if (!lock_task_sighand(leader, &flags))
 		goto out_free_group_list;
-	}
+
 	/* take a reference on each task in the group to go in the array. */
 	tsk = leader;
 	i = 0;
@@ -2055,9 +2047,9 @@ int cgroup_attach_proc(struct cgroup *cg
 		BUG_ON(retval != 0);
 		i++;
 	} while_each_thread(leader, tsk);
+	unlock_task_sighand(leader, &flags);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
-	rcu_read_unlock();
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.

