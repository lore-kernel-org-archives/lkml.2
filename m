Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1K2Rwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:52:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab1K2Rwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:52:38 -0500
Date: Tue, 29 Nov 2011 18:47:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
Message-ID: <20111129174741.GA32209@redhat.com>
References: <4ED3A6F5.6070606@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3A6F5.6070606@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Pavel Emelyanov wrote:
>
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

Hmm. This way it depends on CONFIG_PID_NS.

Can't we simply add an entry into kern_table[] ? And without ns_, just
/proc/sys/kernel/last_pid.

Oleg.

