Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2CADRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:17:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2CADRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:17:52 -0500
Message-ID: <4F4EEB0F.2000504@cn.fujitsu.com>
Date: Thu, 01 Mar 2012 11:20:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH v2] cgroups: Run subsystem fork callback from cgroup_post_fork()
References: <1330057410-9375-1-git-send-email-fweisbec@gmail.com> <1330362171-30697-1-git-send-email-fweisbec@gmail.com> <20120229155500.GU3090@google.com> <20120229162148.GA8375@somewhere.redhat.com>
In-Reply-To: <20120229162148.GA8375@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 11:15:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 11:16:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年03月01日 00:21, Frederic Weisbecker 写道:
> On Wed, Feb 29, 2012 at 07:55:00AM -0800, Mandeep Singh Baines wrote:
>> Frederic Weisbecker (fweisbec@gmail.com) wrote:
>>> When a user freezes a cgroup, the freezer sets the subsystem state
>>> to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
>>>
>>> But there is a possible race here, although unlikely, if a task
>>> forks and the parent is preempted between write_unlock(tasklist_lock)
>>> and cgroup_post_fork(). If we freeze the cgroup while the parent
>>
>> So what if you moved cgroup_post_forks() a few lines up to be
>> inside the tasklist_lock?
> 
> It won't work. Consider this scenario:
> 
> CPU 0                                     CPU 1
> 
>                                        cgroup_fork_callbacks()
>                                        write_lock(tasklist_lock)
> try_to_freeze_cgroup() {               add child to task list etc...
> 	cgroup_iter_start()
>         freeze tasks                        
>         cgroup_iter_end()
> }                                      cgroup_post_fork()
>                                        write_unlock(tasklist_lock)
> 
> If this is not the first time we call cgroup_iter_start(), we won't go
> through the whole tasklist, we simply iterate through the css set task links.
> 
> Plus we try to avoid anything under tasklist_lock when possible.
> 

Your patch won't close the race I'm afraid.

// state will be set to FREEZING
echo FROZEN > /cgroup/sub/freezer.state
                                          write_lock(tasklist_lock)
                                          add child to task list ...
					  write_unlock(tasklist_lock)
// state will be updated to FROZEN
cat /cgroup/sub/freezer.state
					  cgroup_post_fork()
					  ->freezer_fork()

freezer_fork() will freeze the task only if the cgroup is in FREEZING
state, and will BUG if the state is FROZEN.

We can fix freezer_fork(), but seems that requires we hold cgroup_mutex
in that function(), which we don't like at all. Not to say your
task_counter stuff..

At this moment I don't see a solution without tasklist_lock involved,
any better idea?

(I just realized be patch below introduces a tasklist_lock <-> freezer->lock
ABBA deadlock, so it's bad to screw up with tasklist lock)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index fc0646b..74527ac 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -278,6 +278,12 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	struct task_struct *task;
 	unsigned int num_cant_freeze_now = 0;
 
+	/*
+	 * With this lock held and the check in freezer_fork(), a
+	 * half-forked task has no chance to escape from freezing.
+	 */
+	read_lock(&tasklist_lock);
+
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task))
@@ -289,6 +295,8 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	}
 	cgroup_iter_end(cgroup, &it);
 
+	read_unlock(&tasklist_lock);
+
 	return num_cant_freeze_now ? -EBUSY : 0;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e2cd3e2..2450720 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1328,15 +1328,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
+	/* Need tasklist lock for parent etc handling! */
+	write_lock_irq(&tasklist_lock);
+
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
 	cgroup_fork_callbacks(p);
 	cgroup_callbacks_done = 1;
 
-	/* Need tasklist lock for parent etc handling! */
-	write_lock_irq(&tasklist_lock);
-
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
@@ -1393,9 +1393,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	cgroup_post_fork(p);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);

