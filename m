Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0LWSTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:19:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0LWSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:19:31 -0500
Date: Thu, 23 Dec 2010 19:12:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
Message-ID: <20101223181213.GA16501@redhat.com>
References: <1293121303.3390.185.camel@Palantir> <20101223164453.GA13111@redhat.com> <1293125901.2748.10.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293125901.2748.10.camel@Palantir>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Dario Faggioli wrote:
>
> On Thu, 2010-12-23 at 17:44 +0100, Oleg Nesterov wrote:
> > > Therefore, this patch removes such limitation and enables the
> > > following behaviour, for the threaded and process-based case,
> > > respectively:
> >
> > Can't comment, I never understood this.
> >
> If I can ask... What's that you never understood? Why the limitation is
> there?

Yes. IOW, I agree it looks strange, clock_gettime() can sample the
whole group but not a single thread.

> > > @@ -349,18 +347,21 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
> > >  		rcu_read_lock();
> > >  		p = find_task_by_vpid(pid);
> > >  		if (p) {
> > > -			if (CPUCLOCK_PERTHREAD(which_clock)) {
> > > -				if (same_thread_group(p, current)) {
> > > -					error = cpu_clock_sample(which_clock,
> > > -								 p, &rtn);
> > > -				}
> > > +
> > > +			if (CPUCLOCK_PERTHREAD(which_clock) &&
> > > +			    same_thread_group(p, current)) {
> > > +				error = cpu_clock_sample(which_clock,
> > > +							 p, &rtn);
> > >  			} else {
> > >  				read_lock(&tasklist_lock);
> > > -				if (thread_group_leader(p) && p->sighand) {
> > > +				if (!CPUCLOCK_PERTHREAD(which_clock) &&
> > > +				    thread_group_leader(p) && p->sighand)
> > >  					error =
> > >  					    cpu_clock_sample_group(which_clock,
> > > -							           p, &rtn);
> > > -				}
> > > +								   p, &rtn);
> > > +				else
> > > +					error = cpu_clock_sample(which_clock,
> > > +								 p, &rtn);
> > >  				read_unlock(&tasklist_lock);
> >
> > Can't understand... why did you duplicate cpu_clock_sample() ?
> >
> > IOW, it seems to me you could simply kill the
> > "if (same_thread_group(p, current)) {" line with the same efect, no?
> >
> Well, yes, but looking at the original code I thought that in the !
> same_thread_group() case I might need the tasklist_lock...
>
> Am I wrong? Is it there just because of cpu_clock_sample_group()?

Yes, it is because of _group (we are going to sample all sub-threads),
not because of !same_thread_group().

Oh. In fact we should remove this tasklist, but this is another story.

Oleg.

