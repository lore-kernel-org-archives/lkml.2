Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1KWAIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:08:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab1KWAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:08:04 -0500
Date: Tue, 22 Nov 2011 16:08:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-Id: <20111122160802.e99d6218.akpm@linux-foundation.org>
In-Reply-To: <20111108191149.GA7236@sgi.com>
References: <20111108191149.GA7236@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011 13:11:49 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> Resending this.

Not enough times apparently :(
 
> 
> Allow manual override of the tick_do_timer_cpu.
> 
> While not necessarily harmful, doing jiffies updates on an application cpu
> does cause some extra overhead that HPC benchmarking people notice.  They
> prefer to have OS activity isolated to certain cpus.  They like reproducibility
> of results, and having jiffies updates bouncing around introduces variability.

This doesn't really explain what the patch does.  "override" with what?
What effects can the user expect to see from doing
the-action-which-you-didn't-describe?

> ===================================================================
> --- linux.orig/kernel/time/tick-sched.c
> +++ linux/kernel/time/tick-sched.c
> @@ -834,6 +834,104 @@ void tick_cancel_sched_timer(int cpu)
>  }
>  #endif
>  
> +
> +#ifdef CONFIG_SYSFS
> +/**
> + * sysfs_show_do_timer_cpu - sysfs interface for tick_do_timer_cpu
> + * @dev:        unused
> + * @buf:        char buffer where value of tick_do_timer_cpu is copied
> + *
> + * Provides sysfs interface for showing the current tick_do_timer_cpu.
> + */
> +static ssize_t
> +sysfs_show_do_timer_cpu(struct sys_device *dev,
> +				struct sysdev_attribute *attr, char *buf)
> +{
> +	ssize_t count = 0;
> +
> +	count = snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);
> +
> +	return count;

Save some trees:

	return snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);

> +}
> +
> +/**
> + * sysfs_override_do_timer_cpu - manually override tick_do_timer_cpu
> + * @dev:        unused
> + * @buf:        cpu number of desired tick_do_timer_cpu
> + * @count:      length of buffer
> + *
> + * Takes input from sysfs interface for manually overriding the selected
> + * tick_do_timer_cpu.  Only applicable when not running in nohz mode.
> + */
> +static ssize_t
> +sysfs_override_do_timer_cpu(struct sys_device *dev,
> +					struct sysdev_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	char b[16];
> +	size_t ret = count;
> +	int c;
> +
> +#ifdef CONFIG_NO_HZ
> +	/* nohz mode not supported */
> +	if (tick_nohz_enabled)
> +		return -EINVAL;
> +#endif
> +	/* strings from sysfs write are not 0 terminated! */

hm.  Aren't they?

> +	if (count >= sizeof(b))
> +		return -EINVAL;
> +
> +	/* strip off \n: */
> +	if (buf[count-1] == '\n')
> +		count--;
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	memcpy(b, buf, count);
> +	b[count] = 0;
> +
> +	if (sscanf(b, "%d", &c) != 1)
> +		return -EINVAL;

You should be able to use strim() in here, and eliminate b[].  Not that
the \n needed to be removed anyway!  I think it's OK to modify the
incoming memory for sysfs write handlers.

Also, kstrto*() should be used to detect and reject input of the form
"42foo".

But surely we have a helper function somewhere to read an integer out
of a sysfs-written buffer.  If not, we should!

> +	if (!cpu_online(c))
> +		return -EINVAL;
> +
> +	tick_do_timer_cpu = c;
> +
> +	return ret;
> +}
> +
> +/*
> + * Sysfs setup bits:
> + */
> +static SYSDEV_ATTR(jiffies_cpu, 0644, sysfs_show_do_timer_cpu,
> +		   sysfs_override_do_timer_cpu);
> +
> +static struct sysdev_class timekeeping_sysclass = {
> +	.name = "timekeeping",
> +};

The patch shouod add some user-facing documentation for the user-facing
feature.

> +static struct sys_device device_timekeeping = {
> +	.id     = 0,
> +	.cls    = &timekeeping_sysclass,
> +};
> +
> +static int __init init_timekeeping_sysfs(void)
> +{
> +	int error = sysdev_class_register(&timekeeping_sysclass);
> +
> +	if (!error)
> +		error = sysdev_register(&device_timekeeping);
> +	if (!error)
> +		error = sysdev_create_file(
> +				&device_timekeeping,
> +				&attr_jiffies_cpu);
> +	return error;
> +}
> +
> +device_initcall(init_timekeeping_sysfs);
> +#endif /* SYSFS */

