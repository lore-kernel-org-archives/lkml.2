Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1AaL0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:26:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:58180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab1AaL0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:26:22 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296473120.15234.375.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:27:18 +0100
Message-ID: <1296473238.15234.377.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 12:25 +0100, Peter Zijlstra wrote:
> On Fri, 2011-01-28 at 14:52 -0500, Glauber Costa wrote:
> 
> > +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> > +static DEFINE_PER_CPU(u64, cpu_steal_time);
> > +
> > +#ifndef CONFIG_64BIT
> > +static DEFINE_PER_CPU(seqcount_t, steal_time_seq);
> > +
> > +static inline void steal_time_write_begin(void)
> > +{
> > +	__this_cpu_inc(steal_time_seq.sequence);
> > +	smp_wmb();
> > +}
> > +
> > +static inline void steal_time_write_end(void)
> > +{
> > +	smp_wmb();
> > +	__this_cpu_inc(steal_time_seq.sequence);
> > +}
> > +
> > +static inline u64 steal_time_read(int cpu)
> > +{
> > +	u64 steal_time;
> > +	unsigned seq;
> > +
> > +	do {
> > +		seq = read_seqcount_begin(&per_cpu(steal_time_seq, cpu));
> > +		steal_time = per_cpu(cpu_steal_time, cpu);
> > +	} while (read_seqcount_retry(&per_cpu(steal_time_seq, cpu), seq));
> > +
> > +	return steal_time;
> > +}
> > +#else /* CONFIG_64BIT */
> > +static inline void steal_time_write_begin(void)
> > +{
> > +}
> > +
> > +static inline void steal_time_write_end(void)
> > +{
> > +}
> > +
> > +static inline u64 steal_time_read(int cpu)
> > +{
> > +	return per_cpu(cpu_steal_time, cpu);
> > +}
> 
> 
> > @@ -3536,6 +3592,11 @@ static int touch_steal_time(int is_idle)
> >  
> >  	if (st) {
> >  		account_steal_time(st);
> > +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> > +		steal_time_write_begin();
> > +		__this_cpu_add(cpu_steal_time, steal);
> > +		steal_time_write_end();
> > +#endif
> >  		return 1;
> >  	}
> >  	return 0;
> 
> 
> Why replicate all logic you've already got in patch 4? That too is
> reading steal time in a loop in kvm_account_steal_time(), why not extend
> that interface to take a cpu argument and be done with it?

Also, this relies on touch_steal_time() to have ran, not at all
something that is tied to calling update_rq_clock().

We can call update_rq_clock() many many times between ticks, as can the
stealtime increase because the vcpu can schedule many many times between
ticks.



