Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1JNAet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:34:49 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:38729 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1JNAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:34:47 -0400
Date: Thu, 13 Oct 2011 20:31:15 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Ben Blum <bblum@andrew.cmu.edu>, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/2] cgroups: use sighand lock instead of tasklist_lock in
 cgroup_attach_proc
Message-ID: <20111014003115.GB22527@ghc17.ghc.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815184957.GA16588@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use sighand lock instead of tasklist_lock in cgroup_attach_proc.

From: Ben Blum <bblum@andrew.cmu.edu>

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 kernel/cgroup.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 893fc3d..32fb4c8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2003,6 +2003,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	/* threadgroup list cursor and array */
 	struct task_struct *tsk;
 	struct flex_array *group;
+	unsigned long flags;
 	/*
 	 * we need to make sure we have css_sets for all the tasks we're
 	 * going to move -before- we actually start moving them, so that in
@@ -2029,20 +2030,18 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (retval)
 		goto out_free_group_list;
 
-	/* prevent changes to the threadgroup list while we take a snapshot. */
-	read_lock(&tasklist_lock);
-	if (!thread_group_leader(leader)) {
-		/*
-		 * a race with de_thread from another thread's exec() may strip
-		 * us of our leadership, making while_each_thread unsafe to use
-		 * on this task. if this happens, there is no choice but to
-		 * throw this task away and try again (from cgroup_procs_write);
-		 * this is "double-double-toil-and-trouble-check locking".
-		 */
-		read_unlock(&tasklist_lock);
-		retval = -EAGAIN;
+	/* prevent changes to the threadgroup list while we take a snapshot.
+	 * If the leader exits, its links on the thread_group list become
+	 * invalid. One way this can happen is if a sub-thread does exec() when
+	 * de_thread() calls release_task(leader) (and leader->sighand gets set
+	 * to NULL, in which case lock_task_sighand will fail). Since in that
+	 * case the threadgroup is still around, cgroup_procs_write should try
+	 * again (finding the new leader), which EAGAIN indicates here. This is
+	 * double-double-toil-and-trouble-check locking". */
+	retval = -EAGAIN;
+	if (!lock_task_sighand(leader, &flags))
 		goto out_free_group_list;
-	}
+
 	/* take a reference on each task in the group to go in the array. */
 	tsk = leader;
 	i = 0;
@@ -2058,9 +2057,9 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		BUG_ON(retval != 0);
 		i++;
 	} while_each_thread(leader, tsk);
+	unlock_task_sighand(leader, &flags);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
-	read_unlock(&tasklist_lock);
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
