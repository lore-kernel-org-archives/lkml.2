Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1IBUjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:39:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35786 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755273Ab1IBUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:39:19 -0400
Date: Fri, 2 Sep 2011 15:39:17 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20110902203917.GA340@sgi.com>
References: <20110817160759.GA3482@sgi.com>
 <alpine.LFD.2.02.1108171819120.2807@ionos>
 <20110823195628.GB4533@sgi.com>
 <alpine.LFD.2.02.1109021015290.2723@ionos>
 <20110902192958.GB30665@sgi.com>
 <alpine.LFD.2.02.1109022155080.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109022155080.2723@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 09:57:59PM +0200, Thomas Gleixner wrote:
> On Fri, 2 Sep 2011, Dimitri Sivanich wrote:
> > On Fri, Sep 02, 2011 at 10:19:36AM +0200, Thomas Gleixner wrote:
> > +#ifdef CONFIG_SYSFS
> > +/**
> > + * sysfs_show_do_timer_cpu - sysfs interface for tick_do_timer_cpu
> > + * @dev:        unused
> > + * @buf:        char buffer where value of tick_do_timer_cpu is copied
> > + *
> > + * Provides sysfs interface for showing the current tick_do_timer_cpu.
> > + */
> > +static ssize_t
> > +sysfs_show_do_timer_cpu(struct sys_device *dev,
> > +				struct sysdev_attribute *attr, char *buf)
> > +{
> > +	ssize_t count = 0;
> > +
> > +	count = snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);
> > +
> > +	return count;
> > +}
> > +
> > +/**
> > + * sysfs_override_do_timer_cpu - manually override tick_do_timer_cpu
> > + * @dev:        unused
> > + * @buf:        cpu number of desired tick_do_timer_cpu
> > + * @count:      length of buffer
> > + *
> > + * Takes input from sysfs interface for manually overriding the selected
> > + * tick_do_timer_cpu.  Only applicable when not running in nohz mode.
> > + */
> > +static ssize_t
> > +sysfs_override_do_timer_cpu(struct sys_device *dev,
> > +					struct sysdev_attribute *attr,
> > +					const char *buf, size_t count)
> > +{
> > +	char b[16];
> > +	size_t ret = count;
> > +	int c;
> > +
> > +#ifdef CONFIG_NO_HZ
> > +	/* nohz mode not supported */
> > +	if (tick_nohz_enabled)
> > +		return -EINVAL;
> > +#endif
> > +	/* strings from sysfs write are not 0 terminated! */
> > +	if (count >= sizeof(b))
> > +		return -EINVAL;
> > +
> > +	/* strip off \n: */
> > +	if (buf[count-1] == '\n')
> > +		count--;
> > +	if (count < 1)
> > +		return -EINVAL;
> > +
> > +	memcpy(b, buf, count);
> > +	b[count] = 0;
> > +
> > +	if (sscanf(b, "%d", &c) != 1)
> > +		return -EINVAL;
> 
> Isn't there a function which parses sysfs writes into an integer ?
>

There is sysdev_store_int(), but one would need to define a
sysdev_ext_attribute specifying a global int (as 'var') to accept the value.
We would not want that value to be tick_do_timer_cpu, however.

Maybe there's another function that I'm missing?

Given the value restrictions for tick_do_timer_cpu, would you agree that it
seems simpler to leave it this way (or use some form of strtol) rather than
using sysdev_store_int?
