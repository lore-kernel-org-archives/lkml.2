Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1AJJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 04:38:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46416 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752008Ab1AJJiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:38:24 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/+MVZYRQP+9cWGnjrqg7+eR7lOWiKIeKPzUVBDPU
	bw+3qY9xQjUpu9
Subject: Re: [PATCH -tip 2/2] sched: Display autogroup names in
 /proc/sched_debug.
From: Mike Galbraith <efault@gmx.de>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110110051643.GD2772@in.ibm.com>
References: <20110110051445.GB2772@in.ibm.com>
	 <20110110051643.GD2772@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 10:38:07 +0100
Message-ID: <1294652287.17357.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 10:46 +0530, Bharata B Rao wrote:
> sched: Display autogroup names in /proc/sched_debug.
> 
> Add autogroup name to cfs_rq and tasks information in /proc/sched_debug.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched_debug.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -92,6 +92,14 @@ static void print_cfs_group_stats(struct
>  #ifdef CONFIG_CGROUP_SCHED
>  static char * task_group_path(struct task_group *tg)
>  {
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
> +
> +	if (enabled && tg->autogroup) {
> +		autogroup_path(tg, group_path, PATH_MAX);
> +		return group_path;
> +	}
> +#endif
>  	/*
>  	 * May be NULL if the underlying cgroup isn't fully-created yet
>  	 */

What prevents the task being moved, and the task group being freed under
you?  Looks to me like task_group_path() needs rcu_read_lock().  It is
locked in the other two instances.  How about the below?

Date: Mon, 10 Jan 2011 10:46:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 2/2] sched: Display autogroup names in /proc/sched_debug.

sched: Display autogroup names in /proc/sched_debug.

Add autogroup name to cfs_rq and tasks information in /proc/sched_debug.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched_autogroup.c |    5 +++++
 kernel/sched_debug.c     |    7 +++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -92,6 +92,9 @@ static void print_cfs_group_stats(struct
 #ifdef CONFIG_CGROUP_SCHED
 static char * task_group_path(struct task_group *tg)
 {
+	if (autogroup_path(tg, group_path, PATH_MAX))
+		return group_path;
+
 	/*
 	 * May be NULL if the underlying cgroup isn't fully-created yet
 	 */
@@ -99,9 +102,7 @@ static char * task_group_path(struct tas
 		group_path[0] = '\0';
 		return group_path;
 	}
-	rcu_read_lock();
 	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
-	rcu_read_unlock();
 	return group_path;
 }
 #endif
@@ -302,7 +303,9 @@ static void print_cpu(struct seq_file *m
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
+	rcu_read_lock();
 	print_rq(m, rq, cpu);
+	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
 }
 
Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.c
+++ linux-2.6/kernel/sched_autogroup.c
@@ -231,6 +231,11 @@ void proc_sched_autogroup_show_task(stru
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (!enabled || tg == &root_task_group)
+		return 0;
+
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
 }
 #endif /* CONFIG_SCHED_DEBUG */


