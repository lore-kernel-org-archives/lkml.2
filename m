Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0EJTxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab0EJTxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:53:10 -0400
Date: Mon, 10 May 2010 21:50:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pids: init_struct_pid.tasks should never see the
	swapper process
Message-ID: <20100510195014.GC5249@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510194917.GA5249@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"statically initialize struct pid for swapper" commit 820e45db says:

	Statically initialize a struct pid for the swapper process (pid_t == 0)
	and attach it to init_task.  This is needed so task_pid(), task_pgrp()
	and task_session() interfaces work on the swapper process also.

OK, but:

	- it doesn't make sense to add init_task.pids[].node into
	  init_struct_pid.tasks[], and in fact this just wrong.

	  idle threads are special, they shouldn't be visible on any
	  global list. In particular do_each_pid_task(init_struct_pid)
	  shouldn't see swapper.

	  This is the actual reason why kill(0, SIGKILL) from /sbin/init
	  (which starts with 0,0 special pids) crashes the kernel. The
	  signal sent to pgid/sid == 0 must never see idle threads, even
	  if the previous patch fixed the crash itself.

	- we have other idle threads running on the non-boot CPUs, see
	  the next patch.

Change INIT_STRUCT_PID/INIT_PID_LINK to create the empty/unhashed
hlist_head/hlist_node. Like any other idle thread swapper can never exit,
so detach_pid()->__hlist_del() is not possible, but we could change
INIT_PID_LINK() to set pprev = &next if needed.

All we need is the valid swapper->pids[].pid == &init_struct_pid.

Reported-by: Mathias Krause <mathias.krause@secunet.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/init_task.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 34-rc1/include/linux/init_task.h~2_INIT_PID_DONT_LINK_SWAPPER	2010-05-10 19:45:27.000000000 +0200
+++ 34-rc1/include/linux/init_task.h	2010-05-10 20:26:08.000000000 +0200
@@ -53,9 +53,9 @@ extern struct group_info init_groups;
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
 	.tasks		= {						\
-		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
-		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
-		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
+		{ .first = NULL },					\
+		{ .first = NULL },					\
+		{ .first = NULL },					\
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
@@ -70,7 +70,7 @@ extern struct group_info init_groups;
 {								\
 	.node = {						\
 		.next = NULL,					\
-		.pprev = &init_struct_pid.tasks[type].first,	\
+		.pprev = NULL,					\
 	},							\
 	.pid = &init_struct_pid,				\
 }

