Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1LACK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:10:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LACK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:10:56 -0500
Date: Wed, 30 Nov 2011 18:12:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-Id: <20111130181205.2eccd879.akpm@linux-foundation.org>
In-Reply-To: <20111201020631.GA30097@sgi.com>
References: <20111108191149.GA7236@sgi.com>
	<20111122160802.e99d6218.akpm@linux-foundation.org>
	<20111130152959.GA19205@sgi.com>
	<20111130161131.31cdccff.akpm@linux-foundation.org>
	<20111201020631.GA30097@sgi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 20:06:31 -0600 Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Wed, Nov 30, 2011 at 04:11:31PM -0800, Andrew Morton wrote:
> > On Wed, 30 Nov 2011 09:29:59 -0600
> > Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > +static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
> > > +						struct sysdev_attribute *attr,
> > > +						const char *buf, size_t size)
> > > +{
> > > +	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
> > > +	unsigned int new;
> > > +	int rv;
> > > +
> > > +#ifdef CONFIG_NO_HZ
> > > +	/* nohz mode not supported */
> > > +	if (tick_nohz_enabled)
> > > +		return -EINVAL;
> > > +#endif
> > > +
> > > +	rv = kstrtouint(buf, 0, &new);
> > > +	if (rv)
> > > +		return rv;
> > > +
> > > +	if (new >= NR_CPUS || !cpu_online(new))
> > > +		return -ERANGE;
> > > +
> > > +	*(unsigned int *)(ea->var) = new;
> > > +	return size;
> > > +}
> > 
> > checkpatch tells us:
> > 
> > WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> 
> I think a check against num_possible_cpus() should be OK.

You want cpu_possible().  Or maybe cpu_present().

> > 
> > I think the check can just be removed?  Surely cpu_online(1000000000)
> > will return false?
> 
> A value > NR_CPUS and < MAX_INT caused a panic in sysfs_store_do_timer_cpu,
> presumably from the cpu_online() check.  The check against NR_CPUS avoided
> the panic.

OK.  Well, it's not a panic:

static inline unsigned int cpumask_check(unsigned int cpu)
{
#ifdef CONFIG_DEBUG_PER_CPU_MAPS
	WARN_ON_ONCE(cpu >= nr_cpumask_bits);
#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
	return cpu;
}

so we can't do cpu_online(insane number)


