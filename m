Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1GUSiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab1GUSiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:38:04 -0400
Date: Thu, 21 Jul 2011 20:35:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] proc_fork_connector: a lockless ->real_parent usage is
	not safe
Message-ID: <20110721183511.GB3643@redhat.com>
References: <1310751918-31579-1-git-send-email-vzapolskiy@gmail.com> <20110718161558.GA366@ioremap.net> <20110718171420.GA11470@redhat.com> <20110721183446.GA3643@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721183446.GA3643@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_fork_connector() uses ->real_parent lockless. This is not safe
if copy_process() was called with CLONE_THREAD or CLONE_PARENT, in
this case the parent != current can go away at any moment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 drivers/connector/cn_proc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- ts/drivers/connector/cn_proc.c~proc_fork_connector_parent	2011-04-06 21:33:43.000000000 +0200
+++ ts/drivers/connector/cn_proc.c	2011-07-21 20:24:09.000000000 +0200
@@ -55,6 +55,7 @@ void proc_fork_connector(struct task_str
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
+	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -65,8 +66,11 @@ void proc_fork_connector(struct task_str
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_FORK;
-	ev->event_data.fork.parent_pid = task->real_parent->pid;
-	ev->event_data.fork.parent_tgid = task->real_parent->tgid;
+	rcu_read_lock();
+	parent = rcu_dereference(task->real_parent);
+	ev->event_data.fork.parent_pid = parent->pid;
+	ev->event_data.fork.parent_tgid = parent->tgid;
+	rcu_read_unlock();
 	ev->event_data.fork.child_pid = task->pid;
 	ev->event_data.fork.child_tgid = task->tgid;
 

