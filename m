Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1G0Qgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:36:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1G0Qgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:36:33 -0400
Date: Wed, 27 Jul 2011 18:33:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] introduce find_get_task_by_vpid()
Message-ID: <20110727163329.GE23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the new helper, find_get_task_by_vpid(), which simply
does find_task_by_vpid() + get_task_struct() under rcu_read_lock().

It has several potential users which currently do this by hand,
and we are going to add clone_vfork_restart() which needs it too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/pid.c          |   13 +++++++++++++
 2 files changed, 14 insertions(+)

--- 3.1/include/linux/sched.h~5_find_get_task	2011-07-26 20:35:55.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-07-26 20:36:10.000000000 +0200
@@ -2107,6 +2107,7 @@ extern struct pid_namespace init_pid_ns;
  */
 
 extern struct task_struct *find_task_by_vpid(pid_t nr);
+extern struct task_struct *find_get_task_by_vpid(pid_t vnr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
 
--- 3.1/kernel/pid.c~5_find_get_task	2011-07-26 15:50:15.000000000 +0200
+++ 3.1/kernel/pid.c	2011-07-26 20:33:18.000000000 +0200
@@ -427,6 +427,19 @@ struct task_struct *find_task_by_vpid(pi
 	return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
 }
 
+struct task_struct *find_get_task_by_vpid(pid_t vnr)
+{
+	struct task_struct *task;
+
+	rcu_read_lock();
+	task = find_task_by_vpid(vnr);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	return task;
+}
+
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid;

