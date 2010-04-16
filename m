Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0DPOqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:46:20 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:50833 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab0DPOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=awBfVByJlJBBcO/IkFa4Km/WqyJK7CoNLhZ55EvxurbiQQ6Q7BsPD3pQj+tkI3t4e5
         OE4IuE4I+RGuaoCiJpWsm4LAwyZ9aVMviihRxF9wNL2q3f1pFIlCF0bTLTl1u3XlzKYs
         HRhlkimLGx8yG692uao2Qnvxdc6vNr6/oJD/4=
Date: Fri, 16 Apr 2010 16:46:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416144616.GC5162@nowhere>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com> <20100416014712.GC15570@nowhere> <20100416143232.GA5540@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416143232.GA5540@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


The cpu mask is not per cpu here, this is a shared bitmap, so you
can race against other cpus NMIs.

That said, as I suggested, having a per cpu var that we set when we
warned would be much better than a spinlock here.

