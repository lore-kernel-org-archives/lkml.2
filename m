Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0L3Rph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:45:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754910Ab0L3Rpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:45:36 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX197MNJUtSR7nGQWVY9LoxnJVZ7OiwPeQ7tC8ix+fy
	urI7BkqWd/XF1X
Date: Thu, 30 Dec 2010 18:45:29 +0100
From: torbenh <torbenh@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, john.stultz@linaro.org,
        roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
 process.
Message-ID: <20101230174529.GE2086@siel.b>
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	Dario Faggioli <raistlin@linux.it>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel <linux-kernel@vger.kernel.org>, john.stultz@linaro.org,
	roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>
References: <1293121303.3390.185.camel@Palantir>
 <1293533742.2899.1028.camel@Palantir>
 <20101228163829.GA26533@redhat.com>
 <1293572304.2899.1214.camel@Palantir>
 <20101229132130.GA16349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229132130.GA16349@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 02:21:30PM +0100, Oleg Nesterov wrote:
> On 12/28, Dario Faggioli wrote:
> >
> > On Tue, 2010-12-28 at 17:38 +0100, Oleg Nesterov wrote:
> >
> > > >  	rcu_read_lock();
> > > >  	p = find_task_by_vpid(pid);
> > > > -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> > > > -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> > > > +	if (!p || (CPUCLOCK_PERTHREAD(which_clock) &&
> > > > +		   same_thread_group(p, current) && !has_group_leader_pid(p)))
> > > >  		error = -EINVAL;
> > > > -	}
> > > >  	rcu_read_unlock();
> > >
> > > How so? For example, with this change
> > > clock_getres(MAKE_THREAD_CPUCLOCK(pid_of_sub_thread)) won't work, no?
> > >
> > I tested all the clock_getres() calls that came to my mind (at least the
> > one that are possible from an userspace program), and they always worked
> > because of this (still in check_clock):
> >
> >         const pid_t pid = CPUCLOCK_PID(which_clock);
> >
> >         if (pid == 0)
> >                 return 0;
> >
> > Which triggers all the times,
> 
> No, please note pid_of_sub_thread above.
> 
> > The whole point was about, given the current implementation of
> > clock_getcpuclockid done by glibc, can we remove that "failed with
> > success" (showed in the changelog) thing and come up with some
> > meaningful clockid for that situation? It's more than possible for the
> > answer to be no!!! :-P
> 
> I think we should change glibc if clock_getcpuclockid() doesn't work,
> please see below.

http://www.kernel.org/doc/man-pages/online/pages/man3/pthread_getcpuclockid.3.html

this one works.
ok... it takes a pthread_t for identifying the thread.
but it works.

> 
> > > I think, if we want to remove this limitation, we need something
> > > like the patch below. If it doesn't help, we should fix glibc.
> > >
> > > --- x/kernel/posix-cpu-timers.c
> > > +++ x/kernel/posix-cpu-timers.c
> > > @@ -39,10 +39,8 @@ static int check_clock(const clockid_t w
> > >
> > >  	rcu_read_lock();
> > >  	p = find_task_by_vpid(pid);
> > > -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> > > -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> > > +	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) || has_group_leader_pid(p)))
> > >  		error = -EINVAL;
> > > -	}
> > >  	rcu_read_unlock();
> > >
> > Which won't work because CPUCLOCK_PERTHREAD(which_clock) is always false
> > in this case.
> 
> I guess, this is because glibc passes MAKE_PROCESS_CLOCK() id, right?
> But we shouldn't add the hacks to the kernel to hide the limitations
> in glibc.
> 
> > BTW, again, I see your point, the fix might need to happen at glibc
> > level. I'll check that and come back if I find something interesting.
> 
> Yes, please.
> 
> 
> BTW. What is the test-case? I am looking at http://gitorious.org/clockid,
> I guess it is clockid.c...
> 
> You do not need clock_getcpuclockid() at all. In fact I do not really
> understand what this helper should actually do, probably it is only
> needed to validate the pid. You can simply use MAKE_THREAD_CPUCLOCK()
> to sample a single thread via clock_gettime().
> 
> IOW. Unless I missed something, with this patch, the only problem
> is that getcpuclockid() always assumes MAKE_PROCESS_CPUCLOCK(),
> I do not think this is the kernel problem.
> 
> Oleg.
> 

-- 
torben Hohn
