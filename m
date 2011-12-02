Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1LBUO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:14:56 -0500
Received: from relay3.sgi.com ([192.48.152.1]:47483 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820Ab1LBUOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:14:55 -0500
Date: Fri, 2 Dec 2011 14:14:52 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111202201452.GF2164@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <20111122160802.e99d6218.akpm@linux-foundation.org>
 <20111130152959.GA19205@sgi.com>
 <20111130161131.31cdccff.akpm@linux-foundation.org>
 <20111130161610.69c516f7.akpm@linux-foundation.org>
 <20111201020727.GB30097@sgi.com>
 <20111130181318.38f4659d.akpm@linux-foundation.org>
 <20111201163740.GA11693@sgi.com>
 <20111201145623.d2bf252e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201145623.d2bf252e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 02:56:23PM -0800, Andrew Morton wrote:
> On Thu, 1 Dec 2011 10:37:40 -0600
> Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > +static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
> > +						struct sysdev_attribute *attr,
> > +						const char *buf, size_t size)
> > +{
> > +	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
> > +	unsigned int new;
> > +	int rv;
> > +
> > +#ifdef CONFIG_NO_HZ
> > +	/* nohz mode not supported */
> > +	if (tick_nohz_enabled)
> > +		return -EINVAL;
> > +#endif
> > +
> > +	rv = kstrtouint(buf, 0, &new);
> > +	if (rv)
> > +		return rv;
> > +
> > +	/* Protect against cpu-hotplug */
> > +	get_online_cpus();
> > +
> > +	if (new >= nr_cpu_ids || !cpu_online(new)) {
> > +		put_online_cpus();
> > +		return -ERANGE;
> > +	}
> > +
> > +	*(unsigned int *)(ea->var) = new;
> > +
> > +	put_online_cpus();
> > +
> > +	return size;
> > +}
> 
> OK, I think this fixes one race.  We modify tick_do_timer_cpu inside
> get_online_cpus().  If that cpu goes offline then
> tick_handover_do_timer() will correctly hand the timer functions over
> to a new CPU, and tick_handover_do_timer() runs in the CPU hotplug
> handler which I assume is locked by get_online_cpus().  Please check
> all this.

Yes,  _cpu_down() runs cpu_hotplug_begin(), which locks and holds the mutex
that get_online_cpus() needs in order to update the refcount
(cpu_hotplug_begin doesn't exit until refcount==0).

The notification that calls tick_handover_do_timer() is done in both the
CPU_DYING and CPU_DYING_FROZEN (CPU_TASKS_FROZEN), but I believe this always
comes from _cpu_down() in either case.

> 
> Now, the above code can alter tick_do_timer_cpu while a timer interrupt
> is actually executing on another CPU.  Will this disrupt aything?  I
> think it might cause problems.  If we take an interrupt on CPU 5 and
> that CPU enters tick_periodic() and another CPU alters
> tick_do_timer_cpu from 5 to 4 at exactly the correct time, tick_periodic()
> might fail to run do_timer().  Or it might run do_timer() on both CPUs 4 and
> 5 concurrently?
> 

Well, we do have to take the write_seqlock() in tick_periodic, so there's
no danger of do_timer running exactly concurrently.

But yes, we may end up with 2 jiffies ticks occurring close together
(when 5 runs do_timer while 4 waits for the seqlock), or we might end up
missing a jiffies update for almost a full tick (when it changes from 5
to 4 immediately after 4 has done the 'tick_do_timer_cpu == cpu' check).

So at that time, we could be off +- almost a tick.  The question is, how
critical is that?  When you down a cpu, the same sort of thing could 
happen via tick_handover_do_timer(), which itself does nothing more than
change tick_do_timer_cpu.
