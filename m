Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1BAQAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:00:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1BAQAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:00:04 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296473120.15234.375.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 13:59:56 -0200
Message-ID: <1296575996.5081.20.camel@mothafucka.localdomain>
Mime-Version: 1.0
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

Because that part is kvm-specific, and this is scheduler general.
It seemed cleaner to me to do it this way. But I can do it differently,
certainly.

> 


