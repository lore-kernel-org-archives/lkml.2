Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0DPOql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0DPOqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:46:40 -0400
Date: Fri, 16 Apr 2010 10:46:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       peterz@infradead.org, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416144624.GG15159@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100416014712.GC15570@nowhere>
 <20100416143232.GA5540@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416143232.GA5540@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 06:32:32PM +0400, Cyrill Gorcunov wrote:
> On Fri, Apr 16, 2010 at 03:47:14AM +0200, Frederic Weisbecker wrote:
> [...]
> > > +
> > > +/* Callback function for perf event subsystem */
> > > +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> > > +		 struct perf_sample_data *data,
> > > +		 struct pt_regs *regs)
> > > +{
> > > +	int this_cpu = smp_processor_id();
> > > +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> > > +
> > > +	if (touch_ts == 0) {
> > > +		__touch_watchdog();
> > > +		return;
> > > +	}
> > > +
> > > +	/* check for a hardlockup
> > > +	 * This is done by making sure our timer interrupt
> > > +	 * is incrementing.  The timer interrupt should have
> > > +	 * fired multiple times before we overflow'd.  If it hasn't
> > > +	 * then this is a good indication the cpu is stuck
> > > +	 */
> > > +	if (is_hardlockup(this_cpu)) {
> > > +		/* only print hardlockups once */
> > > +		if (cpumask_test_cpu(this_cpu, to_cpumask(hardlockup_mask)))
> > > +			return;
> > > +
> > > +		if (hardlockup_panic)
> > > +			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> > > +		else
> > > +			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> > > +
> > > +		cpumask_set_cpu(this_cpu, to_cpumask(hardlockup_mask));
> > 
> > 
> > 
> > May be have an arch spin lock there to update your cpu mask safely.
> > 
> 
> Hmm, this is NMI handler path so from what we protect this per-cpu data?
> Do I miss something? /me confused

It's not per-cpu which is the problem I believe.  If you have multiple
cpus dealing with hardlockups than they can overwrite each other's data.

Cheers,
Don
