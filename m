Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0KBN6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:58:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41405 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0KBN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TtVVcHQGwAkv9GFpew6KtFx/iGCP7Nuvb5RGYdsX42nCHsbxGVj0GuZnUokf2zdsXb
         HeUqkKUQFHy/vzCL6AHRr6OBjJ+wbHrUUHbUMH4AHNh/TQsTMslAvI+uYLq1znD+5W10
         0H1T2wivjO47eOOEGnEizuT0UiE+3zVYD4gSs=
Date: Tue, 2 Nov 2010 15:58:21 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
 find_task_by_vpid call
Message-ID: <20101102135821.GA5964@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
Add rcu_read_lock/rcu_read_unlock to call find_task_by_vpid.

Tetsuo Handa wrote:

Quoting from one of posts in that thead
http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388

| Usually tasklist gives enough protection, but if copy_process() fails
| it calls free_pid() lockless and does call_rcu(delayed_put_pid().   
| This means, without rcu lock find_pid_ns() can't scan the hash table
| safely.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..855bc53 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -38,11 +38,13 @@ static int check_clock(const clockid_t which_clock)
 		return 0;
 
 	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
+	rcu_read_unlock();
 	read_unlock(&tasklist_lock);
 
 	return error;
@@ -395,17 +397,21 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 		if (pid == 0) {
 			p = current;
 		} else {
+			rcu_read_lock();
 			p = find_task_by_vpid(pid);
 			if (p && !same_thread_group(p, current))
 				p = NULL;
+			rcu_read_unlock();
 		}
 	} else {
 		if (pid == 0) {
 			p = current->group_leader;
 		} else {
+			rcu_read_lock();
 			p = find_task_by_vpid(pid);
 			if (p && !thread_group_leader(p))
 				p = NULL;
+			rcu_read_unlock();
 		}
 	}
 	new_timer->it.cpu.task = p;

