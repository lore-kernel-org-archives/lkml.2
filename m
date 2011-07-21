Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1GUShx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1GUShw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:37:52 -0400
Date: Thu, 21 Jul 2011 20:34:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] (Was: connector: add an event for monitoring process
	tracers)
Message-ID: <20110721183446.GA3643@redhat.com>
References: <1310751918-31579-1-git-send-email-vzapolskiy@gmail.com> <20110718161558.GA366@ioremap.net> <20110718171420.GA11470@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718171420.GA11470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Oleg Nesterov wrote:
>
> proc_fork_connector() reads task->real_parent lockless. In theory
> this is not safe with CLONE_PTHREAD or CLONE_PARENT. Yes, this is
> only theoretical, but afaics we need something like
>
> 	--- x/drivers/connector/cn_proc.c
> 	+++ x/drivers/connector/cn_proc.c
> 	@@ -55,6 +55,7 @@ void proc_fork_connector(struct task_str
> 		struct proc_event *ev;
> 		__u8 buffer[CN_PROC_MSG_SIZE];
> 		struct timespec ts;
> 	+	struct task_struct *parent;
> 	 
> 		if (atomic_read(&proc_event_num_listeners) < 1)
> 			return;
> 	@@ -65,8 +66,11 @@ void proc_fork_connector(struct task_str
> 		ktime_get_ts(&ts); /* get high res monotonic timestamp */
> 		put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
> 		ev->what = PROC_EVENT_FORK;
> 	-	ev->event_data.fork.parent_pid = task->real_parent->pid;
> 	-	ev->event_data.fork.parent_tgid = task->real_parent->tgid;
> 	+	rcu_read_lock();
> 	+	parent = rcu_dereference(task->real_parent);
> 	+	ev->event_data.fork.parent_pid = parent->pid;
> 	+	ev->event_data.fork.parent_tgid = parent->tgid;
> 	+	rcu_read_unlock();
> 		ev->event_data.fork.child_pid = task->pid;
> 		ev->event_data.fork.child_tgid = task->tgid;
>
> Otherwise ->real_parent can point to the freed/reused and may be
> unmapped memory.

Looks like, nobody cares ;) I am sending the patch.

> But the actual question is, the usage of proc_exec_connector()
> looks "obviously wrong", no? Don't we need
>
> 	--- x/fs/exec.c
> 	+++ x/fs/exec.c
> 	@@ -1380,15 +1380,16 @@ int search_binary_handler(struct linux_b
> 				 */
> 				bprm->recursion_depth = depth;
> 				if (retval >= 0) {
> 	-				if (depth == 0)
> 	+				if (depth == 0) {
> 						tracehook_report_exec(fmt, bprm, regs);
> 	+					proc_exec_connector(current);
> 	+				}
> 					put_binfmt(fmt);
> 					allow_write_access(bprm->file);
> 					if (bprm->file)
> 						fput(bprm->file);
> 					bprm->file = NULL;
> 					current->did_exec = 1;
> 	-				proc_exec_connector(current);
> 					return retval;
> 				}
> 				read_lock(&binfmt_lock);
>
>
> ? Or do we really want to call proc_exec_connector() twice or
> more in "#!whatever" case?

I think this should be fixed too, I'll send the patch later.

Oleg.

