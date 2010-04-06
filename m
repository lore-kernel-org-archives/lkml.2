Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0DFPb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:31:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29576 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0DFPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R7mWb3L1WGbwSfj/j5Cdbm2v/KmuFzT9u+mZNllG6UvVNQRe7YCCRcduyLPh98zt1t
         S6das9S3GNYwlKsHfI36W8Xp/jOOCMXUDn2BveipZfRLgImTJFGNNyIF+JgGVHBt5i+/
         KlBDiRQwPY1rsXGWJyNGwmVpx4GhA4/zd4F/I=
Date: Tue, 6 Apr 2010 19:31:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100406153115.GB5744@lenovo>
References: <20100323213338.GA29170@redhat.com> <20100406141321.GA8416@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406141321.GA8416@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 04:13:30PM +0200, Frederic Weisbecker wrote:
[...]
> > +static int watchdog_enable(int cpu)
> > +{
> > +	struct perf_event_attr *wd_attr;
> > +	struct perf_event *event = per_cpu(watchdog_ev, cpu);
> > +	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
> > +
> > +	/* is it already setup and enabled? */
> > +	if (event && event->state > PERF_EVENT_STATE_OFF)
> > +		goto out;
> > +
> > +	/* it is setup but not enabled */
> > +	if (event != NULL)
> > +		goto out_enable;
> > +
> > +	/* Try to register using hardware perf events first */
> > +	wd_attr = &wd_hw_attr;
> > +	wd_attr->sample_period = hw_nmi_get_sample_period();
> > +	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
> > +	if (!IS_ERR(event)) {
> > +		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
> > +		goto out_save;
> > +	}
> > +
> > +	/* hardware doesn't exist or not supported, fallback to software events */
> > +	printk(KERN_INFO "NMI watchdog: hardware not available, trying software events\n");
> > +	wd_attr = &wd_sw_attr;
> > +	wd_attr->sample_period = softlockup_thresh * NSEC_PER_SEC;
> > +	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
> 
> I fear the cpu clock is not going to help you detecting any hard lockups.
> If you're stuck in an interrupt or an irq disabled loop, your cpu clock is
> not going to fire.
>

I guess it's not supposed to. For such cases only nmi irqs may help for which
the perf events are there (/me need to check if we program apic timer for anything
like that). But it should help for other deadlocks. Or I miss something?

	-- Cyrill
