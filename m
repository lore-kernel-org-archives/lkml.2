Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2ALWt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:49:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2ALWt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:49:28 -0500
Date: Thu, 12 Jan 2012 14:49:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
Message-Id: <20120112144927.ea342d58.akpm@linux-foundation.org>
In-Reply-To: <4ED3A6F5.6070606@parallels.com>
References: <4ED3A6F5.6070606@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Nov 2011 19:21:25 +0400
Pavel Emelyanov <xemul@parallels.com> wrote:

> The sysctl works on the current task's pid namespace, getting and setting its
> last_pid field.
> 
> Writing is allowed for CAP_SYS_ADMIN-capable tasks thus making it possible to
> create a task with desired pid value. This ability is required badly for the
> checkpoint/restore in userspace.
> 
> This approach suits all the parties for now.

I'm checking this November patch prior to sending it to Linus...

> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 1f24636..1e9cd67 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -401,6 +401,14 @@ PIDs of value pid_max or larger are not allocated.
>  
>  ==============================================================
>  
> +ns_last_pid:
> +
> +The last pid allocated in the current (the one task using this sysctl
> +lives in) pid namespace. When selecting a pid for a next task on fork
> +kernel tries to allocate a number starting from this one.
> +
> +==============================================================
> +
>  powersave-nap: (PPC only)
>  
>  If set, Linux-PPC will use the 'nap' mode of powersaving,
> diff --git a/kernel/pid.c b/kernel/pid.c
> index fa5f722..ce8e00d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -137,7 +137,9 @@ static int pid_before(int base, int a, int b)
>  }
>  
>  /*
> - * We might be racing with someone else trying to set pid_ns->last_pid.
> + * We might be racing with someone else trying to set pid_ns->last_pid
> + * at the pid allocation time (there's also a sysctl for this, but racing
> + * with this one is OK, see comment in kernel/pid_namespace.c about it).
>   * We want the winner to have the "later" value, because if the
>   * "earlier" value prevails, then a pid may get reused immediately.
>   *
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index e9c9adc..bcd3f16 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -191,9 +191,40 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	return;
>  }
>  
> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table tmp = *table;
> +
> +	if (write && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/*
> +	 * Writing directly to ns' last_pid field is OK, since this field
> +	 * is volatile in a living namespace anyway and a code writing to
> +	 * it should synchronize its usage with external means.
> +	 */
> +
> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
> +}
> +
> +static struct ctl_table pid_ns_ctl_table[] = {
> +	{
> +		.procname = "ns_last_pid",
> +		.maxlen = sizeof(int),
> +		.mode = 0666, /* permissions are checked in the handler */
> +		.proc_handler = pid_ns_ctl_handler,
> +	},
> +	{ }
> +};
> +
> +static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
> +
>  static __init int pid_namespaces_init(void)
>  {
>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
> +	register_sysctl_paths(kern_path, pid_ns_ctl_table);
>  	return 0;
>  }

I think we should now make this code conditional on the new
CONFIG_CHECKPOINT_RESTORE.  I'll merge the patch as-is and will ask you
or Cyrill to send a followup patch doing this, please?


I'll confess that part of my motivation for wrapping c/r-specific code
inside CONFIG_CHECKPOINT_RESTORE is to make it easy for us to later
delete it all if your c/r project end up being unsuccessful.  Sorry :)

