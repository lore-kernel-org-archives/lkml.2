Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1HZPiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:38:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49324 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1HZPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:38:50 -0400
Date: Fri, 26 Aug 2011 17:38:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com,
        oleg@redhat.com, paul@paulmenage.org, tj@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] cgroups: Don't attach task to subsystem if migration
 failed
Message-ID: <20110826153843.GE3298@somewhere>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:44:36PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      cgroups: fix ordering of calls in cgroup_attach_proc
> has been added to the -mm tree.  Its filename is
>      cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: cgroups: fix ordering of calls in cgroup_attach_proc
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> awaiting useful changelog...
> 

Here is the patch with a (trial of a) useful changelog. Subject
has been changed as well:

---
>From a9b84e395a0355cd1aa5ee0f525cd682b16dad63 Mon Sep 17 00:00:00 2001
From: Ben Blum <bblum@andrew.cmu.edu>
Date: Thu, 25 Aug 2011 13:44:36 -0700
Subject: [PATCH] cgroups: Don't attach task to subsystem if migration failed

If a task has exited to the point it has called cgroup_exit()
already, then we can't migrate it to another cgroup anymore.

This can happen when we are attaching a task to a new cgroup
between the call to ->can_attach_task() on subsystems and
the migration that is eventually tried in cgroup_task_migrate().

In this case cgroup_task_migrate() returns -ESRCH and we don't
want to attach the task to the subsystems because the attachment
to the new cgroup itself failed.

Fix this by only calling ->attach_task() on the subsystems if
the cgroup migration succeeded.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/cgroup.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d2b6ce..84bdace 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2135,14 +2135,17 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
-		/* attach each task to each subsystem */
-		for_each_subsys(root, ss) {
-			if (ss->attach_task)
-				ss->attach_task(cgrp, tsk);
-		}
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		if (retval == 0) {
+			/* attach each task to each subsystem */
+			for_each_subsys(root, ss) {
+				if (ss->attach_task)
+					ss->attach_task(cgrp, tsk);
+			}
+		} else {
+			BUG_ON(retval != -ESRCH);
+		}
 	}
 	/* nothing is sensitive to fork() after this point. */
 
-- 
1.7.5.4


