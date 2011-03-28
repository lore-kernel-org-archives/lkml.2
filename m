Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1C1QVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:21:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32798 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1C1QVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PBRdwVUS+FFXNVmETHyARb3S+GIwWTJCIdJbRHj1hC/boJG5czqWq3PNdLKWTfWfzi
         jVd0sx3SHY6CyxuSxk3TCP7JTFemhyw1+d989ZwBEp7l3hNHWHSCgLHevoFatDXs57HN
         FFClJkefvFw+n0jdswq9axlAETVECWfqYtvgQ=
Date: Tue, 29 Mar 2011 01:21:37 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Michel Lespinasse <walken@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] forkbomb killer
Message-ID: <20110328162137.GA2904@barrios-desktop>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
 <20110324105222.GA2625@barrios-desktop>
 <20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
 <20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
 <20110326023452.GA8140@google.com>
 <AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 05:48:45PM +0900, Hiroyuki Kamezawa wrote:
> 2011/3/26 Michel Lespinasse <walken@google.com>:
> > On Fri, Mar 25, 2011 at 01:05:50PM +0900, Minchan Kim wrote:
> >> Okay. Each approach has a pros and cons and at least, now anyone
> >> doesn't provide any method and comments but I agree it is needed(ex,
> >> careless and lazy admin could need it strongly). Let us wait a little
> >> bit more. Maybe google guys or redhat/suse guys would have a opinion.
> >
> > I haven't heard of fork bombs being an issue for us (and it's not been
> > for me on my desktop, either).
> >
> > Also, I want to point out that there is a classical userspace solution
> > for this, as implemented by killall5 for example. One can do
> > kill(-1, SIGSTOP) to stop all processes that they can send
> > signals to (except for init and itself). Target processes
> > can never catch or ignore the SIGSTOP. This stops the fork bomb
> > from causing further damage. Then, one can look at the process
> > tree and do whatever is appropriate - including killing by uid,
> > by cgroup or whatever policies one wants to implement in userspace.
> > Finally, the remaining processes can be restarted using SIGCONT.
> >
> 
> Can that solution work even under OOM situation without new login/commands ?
> Please show us your solution, how to avoid Andrey's Bomb  with your way.
> Then, we can add Documentation, at least. Or you can show us your tool.
> 
> Maybe it is....
> - running as a daemon. (because it has to lock its work memory before OOM.)
> - mlockall its own memory to work under OOM.
> - It can show process tree of users/admin or do all in automatic way
> with user's policy.
> - tell us which process is guilty.
> - wakes up automatically when OOM happens.....IOW, OOM should have some notifier
>   to userland.
> - never allocate any memory at running. (maybe it can't use libc.)
> - never be blocked by any locks, for example, some other task's mmap_sem.
>   One of typical mistakes of admins at OOM is typing 'ps' to see what
> happens.....
> - Can be used even with GUI system, which can't show console.

Hi Kame,

I am worried about run-time cost. 
Should we care of mistake of users for robustness of OS?
Mostly right but we can't handle all mistakes of user so we need admin.
For exampe, what happens if admin execute "rm -rf /"?
For avoiding it, we get a solution "backup" about critical data.

In the same manner, if the system is very critical of forkbomb, 
admin should consider it using memcg, virtualization, ulimit and so on.
If he don't want it, he should become a hard worker who have to 
cross over other building to reboot it. Although he is a diligent man, 
Reboot isn't good. So I suggest following patch which is just RFC. 
For making formal patch, I have to add more comment and modify sysrq.txt.

>From 51bec44086a6b6c0e56ea978a2eb47e995236b47 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Tue, 29 Mar 2011 00:52:20 +0900
Subject: [PATCH] [RFC] Prevent livelock by forkbomb

Recently, We discussed how to prevent forkbomb.
The thing is a trade-off between cost VS effect.

Forkbomb is a _race_ case which happes by someone's mistake
so if we have to pay cost in fast path(ex, fork, exec, exit),
It's a not good.

Now, sysrq + I kills all processes. When I tested it, I still
need rebooting to work my system really well(ex, x start)
although console works. I don't know why we need such sysrq(kill
all processes and then what we can do?)

So I decide to change sysrq + I to meet our goal which prevent
forkbomb. The rationale is following as.

Forkbomb means somethings makes repeately tasks in a short time so
system don't have a free page then it become almost livelock state.
This patch uses the characteristc of forkbomb.

When you push sysrq + I, it kills recent created tasks.
(In this version, 1 minutes). Maybe all processes included
forkbomb tasks are killed. If you can't get normal state of system
after you push sysrq + I, you can try one more. It can kill futher
recent tasks(ex, 2 minutes).

You can continue to do it until your system becomes normal state.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 drivers/tty/sysrq.c   |   45 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/sched.h |    6 ++++++
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 81f1395..6fb7e18 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -329,6 +329,45 @@ static void send_sig_all(int sig)
 	}
 }
 
+static void send_sig_recent(int sig)
+{
+	struct task_struct *p;
+	unsigned long task_jiffies, last_jiffies = 0;
+	bool kill = false;
+
+retry:
+	for_each_process_reverse(p) {
+		if (p->mm && !is_global_init(p) && !fatal_signal_pending(p)) {
+			/* recent created task */
+			last_jiffies = timeval_to_jiffies(p->real_start_time);
+			force_sig(sig, p);
+			break;
+		}
+	}
+
+	for_each_process_reverse(p) {
+		if (p->mm && !is_global_init(p)) {
+			task_jiffies = timeval_to_jiffies(p->real_start_time);
+			/*
+			 * Kill all processes which are created recenlty
+			 * (ex, 1 minutes)
+			 */
+			if (task_jiffies > (last_jiffies - 60 * HZ)) {
+				force_sig(sig, p);
+				kill = true;
+			}
+			else
+				break;
+		}
+	}
+
+	/*
+	 * If we can't kill anything, restart with next group.
+	 */
+	if (!kill)
+		goto retry;
+}
+
 static void sysrq_handle_term(int key)
 {
 	send_sig_all(SIGTERM);
@@ -374,13 +413,13 @@ static struct sysrq_key_op sysrq_thaw_op = {
 
 static void sysrq_handle_kill(int key)
 {
-	send_sig_all(SIGKILL);
+	send_sig_recent(SIGKILL);
 	console_loglevel = 8;
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
-	.help_msg	= "kill-all-tasks(I)",
-	.action_msg	= "Kill All Tasks",
+	.help_msg	= "kill-recent-tasks(I)",
+	.action_msg	= "Kill Recent Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..ddd0a40 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2194,12 +2194,18 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
 }
 #endif
 
+#define prev_task(p) \
+	list_entry_rcu((p)->tasks.prev, struct task_struct, tasks)
+
 #define next_task(p) \
 	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
 
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
 
+#define for_each_process_reverse(p) \
+	for (p = &init_task ; (p = prev_task(p)) != &init_task ; )
+
 extern bool current_is_single_threaded(void);
 
 /*
-- 
1.7.1


> 
> Thanks,
> -Kame

-- 
Kind regards,
Minchan Kim
