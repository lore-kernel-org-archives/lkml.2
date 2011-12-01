Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1LAW4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:56:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1LAW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:56:24 -0500
Date: Thu, 1 Dec 2011 14:56:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-Id: <20111201145623.d2bf252e.akpm@linux-foundation.org>
In-Reply-To: <20111201163740.GA11693@sgi.com>
References: <20111108191149.GA7236@sgi.com>
	<20111122160802.e99d6218.akpm@linux-foundation.org>
	<20111130152959.GA19205@sgi.com>
	<20111130161131.31cdccff.akpm@linux-foundation.org>
	<20111130161610.69c516f7.akpm@linux-foundation.org>
	<20111201020727.GB30097@sgi.com>
	<20111130181318.38f4659d.akpm@linux-foundation.org>
	<20111201163740.GA11693@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 10:37:40 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> +static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
> +						struct sysdev_attribute *attr,
> +						const char *buf, size_t size)
> +{
> +	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
> +	unsigned int new;
> +	int rv;
> +
> +#ifdef CONFIG_NO_HZ
> +	/* nohz mode not supported */
> +	if (tick_nohz_enabled)
> +		return -EINVAL;
> +#endif
> +
> +	rv = kstrtouint(buf, 0, &new);
> +	if (rv)
> +		return rv;
> +
> +	/* Protect against cpu-hotplug */
> +	get_online_cpus();
> +
> +	if (new >= nr_cpu_ids || !cpu_online(new)) {
> +		put_online_cpus();
> +		return -ERANGE;
> +	}
> +
> +	*(unsigned int *)(ea->var) = new;
> +
> +	put_online_cpus();
> +
> +	return size;
> +}

OK, I think this fixes one race.  We modify tick_do_timer_cpu inside
get_online_cpus().  If that cpu goes offline then
tick_handover_do_timer() will correctly hand the timer functions over
to a new CPU, and tick_handover_do_timer() runs in the CPU hotplug
handler which I assume is locked by get_online_cpus().  Please check
all this.

Now, the above code can alter tick_do_timer_cpu while a timer interrupt
is actually executing on another CPU.  Will this disrupt aything?  I
think it might cause problems.  If we take an interrupt on CPU 5 and
that CPU enters tick_periodic() and another CPU alters
tick_do_timer_cpu from 5 to 4 at exactly the correct time, tick_periodic()
might fail to run do_timer().  Or it might run do_timer() on both CPUs 4 and
5 concurrently?


