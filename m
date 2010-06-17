Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694Ab0FQJzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:55:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28459 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367Ab0FQJzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:55:16 -0400
Message-ID: <4C19F0A3.2050707@parallels.com>
Date: Thu, 17 Jun 2010 13:53:39 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Louis Rilling <louis.rilling@kerlabs.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
In-Reply-To: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 08:34 PM, Louis Rilling wrote:
> [ Resending, hopefully with all pieces ]
> 
> Detached tasks are not seen by zap_pid_ns_processes()->sys_wait4(), so
> that release_task()->proc_flush_task() of container init can be called
> before it is for some detached tasks in the namespace.
> 
> Pin proc_mnt's in copy_process(), so that proc_flush_task() becomes safe
> whatever the ordering of tasks.

See one comment below.

> Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
> ---
>  fs/proc/base.c          |   18 ++++++++++++++++++
>  include/linux/proc_fs.h |    4 ++++
>  kernel/fork.c           |    1 +
>  3 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index acb7ef8..d6cdd91 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2663,6 +2663,23 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
>  	.setattr	= proc_setattr,
>  };
>  
> +/*
> + * Pin all proc_mnt so that detached tasks can safely call proc_flush_task()
> + * after container init calls itself proc_flush_task().
> + */
> +void proc_new_task(struct task_struct *task)
> +{
> +	struct pid *pid;
> +	int i;
> +
> +	if (!task->pid)
> +		return;
> +
> +	pid = task_pid(task);
> +	for (i = 0; i <= pid->level; i++)
> +		mntget(pid->numbers[i].ns->proc_mnt);

NAK. Pids live their own lives - task can change one, pid will
become orphan and will be destroyed, so you'll leak.

There's another big problem with proc mount - you can umount proc
and the namespace will have a stale pointer.

I think we should have a kern_mount-ed proc at the namespace createi

> +}
> +
>  static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
>  {
>  	struct dentry *dentry, *leader, *dir;
> @@ -2744,6 +2761,7 @@ void proc_flush_task(struct task_struct *task)
>  		upid = &pid->numbers[i];
>  		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
>  					tgid->numbers[i].nr);
> +		mntput(upid->ns->proc_mnt);
>  	}
>  
>  	upid = &pid->numbers[pid->level];
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 379eaed..f24faa1 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -104,6 +104,7 @@ struct vmcore {
>  
>  extern void proc_root_init(void);
>  
> +void proc_new_task(struct task_struct *task);
>  void proc_flush_task(struct task_struct *task);
>  
>  extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
> @@ -184,6 +185,9 @@ extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
>  #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
>  static inline void proc_net_remove(struct net *net, const char *name) {}
>  
> +static inline void proc_new_task(struct task_struct *task)
> +{
> +}
>  static inline void proc_flush_task(struct task_struct *task)
>  {
>  }
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b6cce14..c6c2874 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1281,6 +1281,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	total_forks++;
>  	spin_unlock(&current->sighand->siglock);
>  	write_unlock_irq(&tasklist_lock);
> +	proc_new_task(p);
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);
>  	perf_event_fork(p);

