Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0KIVhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:37:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47525 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0KIVhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:37:18 -0500
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
From: john stultz <johnstul@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <201011080756.50930.arnd@arndb.de>
References: <cover.1288897198.git.richard.cochran@omicron.at>
	 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
	 <201011080756.50930.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 13:37:02 -0800
Message-ID: <1289338622.9434.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 07:56 +0100, Arnd Bergmann wrote:
> On Thursday 04 November 2010, Richard Cochran wrote:
> > diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> > index 3e23844..70f40e6 100644
> > --- a/include/linux/posix-timers.h
> > +++ b/include/linux/posix-timers.h
> > @@ -17,10 +17,22 @@ struct cpu_timer_list {
> >  	int firing;
> >  };
> >  
> > +/* Bit fields within a clockid:
> > + *
> > + * The most significant 29 bits hold either a pid or a file descriptor.
> > + *
> > + * Bit 2 indicates whether a cpu clock refers to a thread or a process.
> > + *
> > + * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
> > + *
> > + * A clockid is invalid if bits 2, 1, and 0 all set (see also CLOCK_INVALID
> > + * in include/linux/time.h)
> > + */
> > +
> >  #define 	(clock)		((pid_t) ~((clock) >> 3))
> >  #define CPUCLOCK_PERTHREAD(clock) \
> >  	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
> > -#define CPUCLOCK_PID_MASK	7
> > +
> >  #define CPUCLOCK_PERTHREAD_MASK	4
> >  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
> >  #define CPUCLOCK_CLOCK_MASK	3
> > @@ -28,12 +40,17 @@ struct cpu_timer_list {
> >  #define CPUCLOCK_VIRT		1
> >  #define CPUCLOCK_SCHED		2
> >  #define CPUCLOCK_MAX		3
> > +#define CLOCKFD			CPUCLOCK_MAX
> > +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> 
> It looks like you are turning a kernel internal interface into a user ABI,
> which I think is highly questionable. Using the bits like this internally is
> ok, but making it part of the syscall ABI means that we can never change this
> in the future.
> 
> Maybe I was misunderstanding your patch though.


As Richard already mentioned, the cpuclocks has already exported this as
ABI and its used in pthread_getcpuclockid().

I wonder thought if it would be worth having a syscall to convert from
fd to clock_id so it could be more flexible in the future. But it may
not be worth it, as we're probably already limited by the cpuclock
implementation.

thanks
-john



