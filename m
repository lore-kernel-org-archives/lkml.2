Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0DFTdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:33:36 -0400
Received: from www.tglx.de ([62.245.132.106]:38626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0DFTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:33:30 -0400
Date: Tue, 6 Apr 2010 21:31:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <20100406174459.60088461@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1004062024560.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop>
 <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <20100406174459.60088461@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010, Alan Cox wrote:
> > Do you feel some of these situations would also benefit from some kernel 
> > assistance to stop spinning when the owner schedules out? Or are you 
> > saying that there are situations where pure userspace spinlocks will 
> > always be the best option?
> 
> There are cases its the best option - you are assuming for example that
> the owner can get scheduled out. Eg nailing one thread per CPU in some
> specialist high performance situations means they can't.

Fair enough, but that's not the problem Darren is targeting.
 
> > If the latter, I'd think that they would also be situations where 
> > sched_yield() is not used as part of the spin loop. If so, then these 
> > are not our target situations for FUTEX_LOCK_ADAPTIVE, which hopes to 
> > provide a better informed mechanism for making spin or sleep decisions. 
> > If sleeping isn't part of the locking construct implementation, then 
> > FUTEX_LOCK_ADAPTIVE doesn't have much to offer.
> 
> I am unsure about the approach. As Avi says knowing that the lock owner is
> scheduled out allows for far better behaviour. It doesn't need complex
> per lock stuff or per lock notifier entries on pre-empt either.
> 
> A given task is either pre-empted or not and in the normal case of things
> you need this within a process so you've got shared pages anyway. So you
> only need one instance of the 'is thread X pre-empted' bit somewhere in a
> non swappable page.

I fear we might end up with a pinned page per thread to get this
working properly and it restricts the mechanism to process private
locks.

> That gives you something along the lines of
> 
> 	runaddr = find_run_flag(lock);
> 	do {
> 		while(*runaddr == RUNNING) {
> 			if (trylock(lock))
> 				return WHOOPEE;
> 			cpu relax
> 		}
> 		yield (_on(thread));

That would require a new yield_to_target() syscall, which either
blocks the caller when the target thread is not runnable or returns an
error code which signals to go into the slow path.

> 	} while(*runaddr != DEAD);
> 
> 
> which unlike blindly spinning can avoid the worst of any hit on the CPU
> power and would be a bit more guided ?

I doubt that the syscall overhead per se is large enough to justify
all of the above horror. We need to figure out a more efficient way to
do the spinning in the kernel where we have all the necessary
information already. Darren's implementation is suboptimal AFAICT.

Thanks,

	tglx
