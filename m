Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1LACH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:07:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555Ab1LACH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:07:28 -0500
Date: Wed, 30 Nov 2011 20:07:27 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111201020727.GB30097@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <20111122160802.e99d6218.akpm@linux-foundation.org>
 <20111130152959.GA19205@sgi.com>
 <20111130161131.31cdccff.akpm@linux-foundation.org>
 <20111130161610.69c516f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130161610.69c516f7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 04:16:10PM -0800, Andrew Morton wrote:
> On Wed, 30 Nov 2011 16:11:31 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
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
> > 
> > I think the check can just be removed?  Surely cpu_online(1000000000)
> > will return false?
> > 
> 
> And the whole thing is racy, isn't it?  The "new" CPU can go offline a
> nanosecond after we performed that test, so why perform it at all?

See my email concerning the panic in cpu_online().
