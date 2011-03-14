Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1CNTuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:50:01 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:65207 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1CNTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:50:00 -0400
Subject: Re: [PATCH] Restrict write access to dmesg_restrict
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, mingo@elte.hu, davem@davemloft.net,
        dzickus@redhat.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1300131356-24389-1-git-send-email-richard@nod.at>
References: <1300131356-24389-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 15:49:55 -0400
Message-ID: <1300132195.2194.6.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 20:35 +0100, Richard Weinberger wrote:
> When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed
> to read the kernel ring buffer.
> But a root user without CAP_SYS_ADMIN is able to reset
> dmesg_restrict to 0.

A minor correction, CAP_SYSLOG is needed to read the kernel syslog.  But
I think requiring CAP_SYS_ADMIN is appropriate to modify the value of
the sysctl, so assuming the commit message reflects this:

Acked-by: Dan Rosenberg <drosenberg@vsecurity.com>

> 
> This is an issue when e.g. LXC (Linux Containers) are used
> and complete user space is running without CAP_SYS_ADMIN.
> A unprivileged and jailed root user can bypass the
> dmesg_restrict protection.
> 
> With this patch writing to dmesg_restrict is only allowed
> when root has CAP_SYS_ADMIN.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  kernel/sysctl.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4eed0af..f90c8f6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -169,6 +169,11 @@ static int proc_taint(struct ctl_table *table, int write,
>  			       void __user *buffer, size_t *lenp, loff_t *ppos);
>  #endif
>  
> +#ifdef CONFIG_PRINTK
> +static int proc_dmesg_restrict(struct ctl_table *table, int write,
> +				void __user *buffer, size_t *lenp, loff_t *ppos);
> +#endif
> +
>  #ifdef CONFIG_MAGIC_SYSRQ
>  /* Note: sysrq code uses it's own private copy */
>  static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
> @@ -704,7 +709,7 @@ static struct ctl_table kern_table[] = {
>  		.data		= &dmesg_restrict,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> +		.proc_handler	= proc_dmesg_restrict,
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> @@ -2397,6 +2402,17 @@ static int proc_taint(struct ctl_table *table, int write,
>  	return err;
>  }
>  
> +#ifdef CONFIG_PRINTK
> +static int proc_dmesg_restrict(struct ctl_table *table, int write,
> +				void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	if (write && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +}
> +#endif
> +
>  struct do_proc_dointvec_minmax_conv_param {
>  	int *min;
>  	int *max;
> -- 
> 1.6.6.1


