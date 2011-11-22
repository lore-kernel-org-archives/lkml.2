Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1KVJFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:05:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1KVJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:05:25 -0500
Date: Tue, 22 Nov 2011 10:05:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111122090522.GA26768@tiehlicka.suse.cz>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
 <20111122022118.GT25776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122022118.GT25776@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 18:21:18, Tejun Heo wrote:
> On Tue, Nov 22, 2011 at 10:20:02AM +0800, Li Zefan wrote:
> > Tejun Heo wrote:
> > > Hello, Michal.
> > > 
> > > On Wed, Nov 16, 2011 at 10:50:34PM +0100, Michal Hocko wrote:
> > >> +/* Task is frozen or will freeze immediately when next it gets woken */
> > >> +static bool is_task_frozen_enough(struct task_struct *task)
> > >> +{
> > >> +	return frozen(task) ||
> > >> +		(task_is_stopped_or_traced(task) && freezing(task));
> > >> +}
> > > 
> > > Hmmm... w/ pending freezer updates, the above would always return
> > > %true if there's freezing in progress, which can't be right.  Maybe
> > 
> > Only if the task is stopped/trace.
> 
> You're right, missed parantheses.
> 
> > If we try to freeze a stopped task, it will be kept in freezing state.
> > 
> > > just test stopped/traced?
> > 
> > This can trigger a BUG_ON in update_if_frozen(), because we always count a
> > stopped task as frozen.
> 
> So, yeah, the patch looks good to me, but it still isn't difficult to
> trigger BUG_ON() there.  We need a lot of fixes in cgroup_freezer.

I am not sure which BUG_ON you have in mind.
update_if_frozen:
	BUG_ON(nfrozen != ntotal);

Should be OK because this patch does:
@@ -231,7 +238,7 @@ static void update_if_frozen(struct cgroup *cgroup,
        cgroup_iter_start(cgroup, &it);
        while ((task = cgroup_iter_next(cgroup, &it))) {
                ntotal++;
-               if (frozen(task))
+               if (is_task_frozen_enough(task))

AFAICS your current implementation in (pm-freezer) uses (freezing || frozen)
so the patch should be updated to (freezing || is_task_frozen_enough).

Updated patch - on top of your pm-freezer branch
---
>From aba1042a96b6e79e0b14e3c397389389c9e2f522 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 16 Nov 2011 22:38:42 +0100
Subject: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks

2d3cbf8b (cgroup_freezer: update_freezer_state() does incorrect state
transitions) removed is_task_frozen_enough and replaced it with a simple
frozen call. This, however, breaks freezing for a group with stopped tasks
because those cannot be frozen and so the group remains in CGROUP_FREEZING
state (update_if_frozen doesn't count stopped tasks) and never reaches
CGROUP_FROZEN.

Let's add is_task_frozen_enough back and use it at the original locations
(update_if_frozen and try_to_freeze_cgroup). Semantically we consider
stopped tasks as frozen enough so we should consider both cases when
testing frozen tasks.

Testcase:
mkdir /dev/freezer
mount -t cgroup -o freezer none /dev/freezer
mkdir /dev/freezer/foo
sleep 1h &
pid=$!
kill -STOP $pid
echo $pid > /dev/freezer/foo/tasks
echo FROZEN > /dev/freezer/foo/freezer.state
while true
do
        cat /dev/freezer/foo/freezer.state
        [ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
        sleep 1
done
echo OK

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>
---
 kernel/cgroup_freezer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e411a60..96090a5 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -152,6 +152,13 @@ static void freezer_destroy(struct cgroup_subsys *ss,
 	kfree(freezer);
 }
 
+/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -224,7 +231,7 @@ static void update_if_frozen(struct cgroup *cgroup,
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (freezing(task) && frozen(task))
+		if (freezing(task) || is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -276,7 +283,7 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task))
 			continue;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
-- 
1.7.7.1



Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
