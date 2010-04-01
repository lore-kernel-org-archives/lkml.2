Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab0DAQib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084Ab0DAQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:38:13 -0400
Date: Thu, 1 Apr 2010 15:13:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 1/1] oom: fix the unsafe usage of badness() in
	proc_oom_score()
Message-ID: <20100401131357.GB11291@redhat.com>
References: <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com> <20100331091628.GA11438@redhat.com> <20100331201746.GC11635@redhat.com> <alpine.DEB.2.00.1004010029260.6285@chino.kir.corp.google.com> <20100401131321.GA11291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401131321.GA11291@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_oom_score(task) have a reference to task_struct, but that is all.
If this task was already released before we take tasklist_lock

	- we can't use task->group_leader, it points to nowhere

	- it is not safe to call badness() even if this task is
	  ->group_leader, has_intersects_mems_allowed() assumes
	  it is safe to iterate over ->thread_group list.

	- even worse, badness() can hit ->signal == NULL

Add the pid_alive() check to ensure __unhash_process() was not called.

Also, use "task" instead of task->group_leader. badness() should return
the same result for any sub-thread. Currently this is not true, but
this should be changed anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- TTT/fs/proc/base.c~PROC_OOM_SCORE	2010-03-11 13:11:50.000000000 +0100
+++ TTT/fs/proc/base.c	2010-04-01 14:41:17.000000000 +0200
@@ -442,12 +442,13 @@ static const struct file_operations proc
 unsigned long badness(struct task_struct *p, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
-	unsigned long points;
+	unsigned long points = 0;
 	struct timespec uptime;
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
-	points = badness(task->group_leader, uptime.tv_sec);
+	if (pid_alive(task))
+		points = badness(task, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }

