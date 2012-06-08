Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2FHNts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:49:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2FHNtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:49:46 -0400
Date: Fri, 8 Jun 2012 09:49:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, nzimmer@sgi.com
Subject: Re: [PATCH] watchdog: Quiet down the boot messages
Message-ID: <20120608134941.GP32472@redhat.com>
References: <1339121736-22574-1-git-send-email-dzickus@redhat.com>
 <1339123274.14838.35.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339123274.14838.35.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 07:41:14PM -0700, Joe Perches wrote:
> On Thu, 2012-06-07 at 22:15 -0400, Don Zickus wrote:
> > A bunch of bugzillas have complained how noisy the nmi_watchdog is during
> > boot-up especially with its expected failure cases (like virt and bios
> > resource contention).
> 
> Hi Don, this seems nicer.
> 
> Just some trivial comments below:

I like the feedback.  I'll respin the patch and include them.

Thanks,
Don

> 
> > This is my attempt to quiet them down and keep it less confusing for the end
> > user.  What I did is print the message for cpu0 and save it for future
> > comparisions.
> 
> comparisons
> 
> []
> > After the change, it is simlified to:
> 
> simplified
> 
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> []
> > @@ -377,6 +377,14 @@ static int watchdog_nmi_enable(int cpu)
> >  	struct perf_event_attr *wd_attr;
> >  	struct perf_event *event = per_cpu(watchdog_ev, cpu);
> >  
> > +	/*
> > +	 * People like the simple clean cpu node info
> > +	 * on boot.  Simplify the noise from the watchdog
> > +	 * by only printing messages that are different than
> > +	 * what cpu0 displayed
> > +	 */
> 
> This comment could be shortened by a line
> 	/*
> 	 * People like simple and clean cpu node info on boot.
> 	 * Reduce the watchdog noise by only printing messages
> 	 * that are different from what cpu0 displayed.
> 	 */
> 
> > +	static unsigned long err0 = 0;
> 
> Strictly, this doesn't need initialization.
> I think the err0 name is unclear.  Maybe cpu0_err instead;
> 
> I think the use of !cpu and cpu is unclear.
> It's still a cpu, just index 0.
> !cpu should be cpu == 0 and
> cpu should be cpu != 0 too.
> 
> 
> > @@ -390,11 +398,21 @@ static int watchdog_nmi_enable(int cpu)
> >  
> >  	/* Try to register using hardware perf events */
> >  	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
> > +
> > +	/* save cpu0 error for future comparision */
> > +	if (!cpu)
> > +		err0 = (IS_ERR(event) ? PTR_ERR(event) : 0);
> 
> 	if (cpu == 0 && IS_ERR(event))
> 		cpu0_err = PTR_ERR(event);
> 
> > +
> >  	if (!IS_ERR(event)) {
> > -		pr_info("enabled, takes one hw-pmu counter.\n");
> > +		/* only print for cpu0 or different than cpu0 */
> 
> 	or if
> 
> > +		if (!cpu || err0)
> 
> 		if (cpu == 0 || cpu0_err)
> 
> > +			pr_info("enabled, takes one hw-pmu counter.\n");
> >  		goto out_save;
> >  	}
> >  
> > +	/* skip displaying the same error again */
> > +	if ((PTR_ERR(event) == err0) && cpu)
> 
> 	if (cpu > 0 && PTR_ERR(event))
> > +		return PTR_ERR(event);
> >  
> >  	/* vary the KERN level based on the returned errno */
> >  	if (PTR_ERR(event) == -EOPNOTSUPP)
> 
> cheers, Joe
> 
