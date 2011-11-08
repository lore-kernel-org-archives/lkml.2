Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1KHMBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:01:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51752 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1KHMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:01:07 -0500
Date: Tue, 8 Nov 2011 15:59:00 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        Alexey Dobriyan <adobriyan@gmail.com>, security@kernel.org
Subject: Re: [PATCH] proc: restrict access to /proc/$PID/{sched,schedstat}
Message-ID: <20111108115900.GA14587@albatros>
References: <20111105104828.GA3489@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111105104828.GA3489@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ed l-k)

On Sat, Nov 05, 2011 at 14:48 +0400, Vasiliy Kulikov wrote:
> /proc/$PID/{sched,schedstat} contain debugging scheduler counters, which
> should not be world readable.  They may be used to gather private information
> about processes' activity.  E.g. it can be used to count the number of
> characters typed in gksu dialog:
> 
> http://www.openwall.com/lists/oss-security/2011/11/05/3
> 
> This infoleak is similar to io (1d1221f375c) and stat's eip/esp (f83ce3e6b02d)
> infoleaks.  Probably other 0644/0444 procfs files are vulnerable to
> similar infoleaks.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  fs/proc/base.c |   32 ++++++++++++++++++++++----------
>  1 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6278ef1..8b67eec 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -410,10 +410,16 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
>   */
>  static int proc_pid_schedstat(struct task_struct *task, char *buffer)
>  {
> -	return sprintf(buffer, "%llu %llu %lu\n",
> -			(unsigned long long)task->se.sum_exec_runtime,
> -			(unsigned long long)task->sched_info.run_delay,
> -			task->sched_info.pcount);
> +	int ret;
> +	ret = lock_trace(task);
> +	if (!ret) {
> +		ret = sprintf(buffer, "%llu %llu %lu\n",
> +				(unsigned long long)task->se.sum_exec_runtime,
> +				(unsigned long long)task->sched_info.run_delay,
> +				task->sched_info.pcount);
> +		unlock_trace(task);
> +	}
> +	return ret;
>  }
>  #endif
>  
> @@ -1390,15 +1396,21 @@ static int sched_show(struct seq_file *m, void *v)
>  {
>  	struct inode *inode = m->private;
>  	struct task_struct *p;
> +	int ret;
>  
>  	p = get_proc_task(inode);
>  	if (!p)
>  		return -ESRCH;
> -	proc_sched_show_task(p, m);
> +	ret = lock_trace(p);
> +	if (!ret) {
> +		proc_sched_show_task(p, m);
> +		ret = 0;
> +		unlock_trace(p);
> +	}
>  
>  	put_task_struct(p);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static ssize_t
> @@ -2813,7 +2825,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	ONE("personality", S_IRUGO, proc_pid_personality),
>  	INF("limits",	  S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
> -	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> +	REG("sched",      S_IRUSR|S_IWUSR, proc_pid_sched_operations),
>  #endif
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
> @@ -2851,7 +2863,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	ONE("stack",      S_IRUGO, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
> -	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
> +	INF("schedstat",  S_IRUSR, proc_pid_schedstat),
>  #endif
>  #ifdef CONFIG_LATENCYTOP
>  	REG("latency",  S_IRUGO, proc_lstats_operations),
> @@ -3162,7 +3174,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	ONE("personality", S_IRUGO, proc_pid_personality),
>  	INF("limits",	 S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
> -	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> +	REG("sched",     S_IRUSR|S_IWUSR, proc_pid_sched_operations),
>  #endif
>  	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> @@ -3196,7 +3208,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	ONE("stack",      S_IRUGO, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
> -	INF("schedstat", S_IRUGO, proc_pid_schedstat),
> +	INF("schedstat", S_IRUSR, proc_pid_schedstat),
>  #endif
>  #ifdef CONFIG_LATENCYTOP
>  	REG("latency",  S_IRUGO, proc_lstats_operations),
> -- 
> 1.7.0.4
> 

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
