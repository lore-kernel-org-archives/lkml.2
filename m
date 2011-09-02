Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1IBT6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:58:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:54267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab1IBT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:58:03 -0400
Date: Fri, 2 Sep 2011 21:57:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20110902192958.GB30665@sgi.com>
Message-ID: <alpine.LFD.2.02.1109022155080.2723@ionos>
References: <20110817160759.GA3482@sgi.com> <alpine.LFD.2.02.1108171819120.2807@ionos> <20110823195628.GB4533@sgi.com> <alpine.LFD.2.02.1109021015290.2723@ionos> <20110902192958.GB30665@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, Dimitri Sivanich wrote:
> On Fri, Sep 02, 2011 at 10:19:36AM +0200, Thomas Gleixner wrote:
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

Isn't there a function which parses sysfs writes into an integer ?

Thanks,

	tglx
