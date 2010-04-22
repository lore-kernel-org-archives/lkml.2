Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0DVT1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:34 -0400
Received: from kroah.org ([198.145.64.141]:37119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475Ab0DVT13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:29 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:07 2010
Message-Id: <20100422190907.864799567@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>
Subject: [005/197] oom: fix the unsafe usage of badness() in proc_oom_score()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b95c35e76b29ba812e5dabdd91592e25ec640e93 upstream.

proc_oom_score(task) has a reference to task_struct, but that is all.
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
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


