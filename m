Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0IPROd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0IPROb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:14:31 -0400
Date: Thu, 16 Sep 2010 18:39:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, jmorris@namei.org, stable@kernel.org
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side
	critical section
Message-ID: <20100916163927.GA2873@redhat.com>
References: <20100830172631.GA11868@linux.vnet.ibm.com> <4C7C0BAB.3000709@suse.cz> <20100909221555.GB6273@redhat.com> <4C91E0DE.4080507@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C91E0DE.4080507@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Jiri Slaby wrote:
>
> On 09/10/2010 12:15 AM, Oleg Nesterov wrote:
> > On 08/30, Jiri Slaby wrote:
> >>> --- a/kernel/sys.c
> >>> +++ b/kernel/sys.c
> >>> @@ -938,6 +938,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
> >>>  	write_lock_irq(&tasklist_lock);
> >>>
> >>>  	err = -ESRCH;
> >>> +	rcu_read_lock();
> >>>  	p = find_task_by_vpid(pid);
> >>
> >> AFAICT the missing lock doesn't harm due to the write_lock of tasklist
> >> above. But is probably a good thing to do anyway.
> >
> > The problem is, find_task_by_vpid() is not safe without RCU. It is not
> > that the returned task_struct can't go away, find_pid_ns() itself is
> > not safe. This is because the failing copy_process() calls free_pid()
> > without tasklist_lock and modifies pid_hash[] list.
>
> That said, it (950eaaca681c4) should probably go into stable. (Apply to
> all 32-35 whichever are maintained currently.)

Perhaps, but the race is mostly theoretical.

To be honest, I think 950eaaca681c4 needs a comment to explain what
rcu_read_lock() protects, or perhaps we can make it more explicit.

Oleg.

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -931,7 +931,6 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
-	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -939,7 +938,9 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 	write_lock_irq(&tasklist_lock);
 
 	err = -ESRCH;
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
+	rcu_read_unlock();
 	if (!p)
 		goto out;
 
@@ -968,7 +969,9 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 	if (pgid != pid) {
 		struct task_struct *g;
 
+		rcu_read_lock();
 		pgrp = find_vpid(pgid);
+		rcu_read_unlock();
 		g = pid_task(pgrp, PIDTYPE_PGID);
 		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
@@ -985,7 +988,6 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
-	rcu_read_unlock();
 	return err;
 }
 

