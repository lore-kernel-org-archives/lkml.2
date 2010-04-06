Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0DFQl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:41:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60297 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845Ab0DFQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:41:53 -0400
Date: Tue, 6 Apr 2010 17:44:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20100406174459.60088461@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBB531A.4070500@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	<4BBA5305.7010002@redhat.com>
	<4BBA5C00.4090703@us.ibm.com>
	<4BBA6279.20802@redhat.com>
	<4BBA6B6F.7040201@us.ibm.com>
	<4BBB36FA.4020008@redhat.com>
	<1270560931.1595.342.camel@laptop>
	<20100406145128.6324ac9a@lxorguk.ukuu.org.uk>
	<4BBB531A.4070500@us.ibm.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you feel some of these situations would also benefit from some kernel 
> assistance to stop spinning when the owner schedules out? Or are you 
> saying that there are situations where pure userspace spinlocks will 
> always be the best option?

There are cases its the best option - you are assuming for example that
the owner can get scheduled out. Eg nailing one thread per CPU in some
specialist high performance situations means they can't.

> If the latter, I'd think that they would also be situations where 
> sched_yield() is not used as part of the spin loop. If so, then these 
> are not our target situations for FUTEX_LOCK_ADAPTIVE, which hopes to 
> provide a better informed mechanism for making spin or sleep decisions. 
> If sleeping isn't part of the locking construct implementation, then 
> FUTEX_LOCK_ADAPTIVE doesn't have much to offer.

I am unsure about the approach. As Avi says knowing that the lock owner is
scheduled out allows for far better behaviour. It doesn't need complex
per lock stuff or per lock notifier entries on pre-empt either.

A given task is either pre-empted or not and in the normal case of things
you need this within a process so you've got shared pages anyway. So you
only need one instance of the 'is thread X pre-empted' bit somewhere in a
non swappable page.

That gives you something along the lines of

	runaddr = find_run_flag(lock);
	do {
		while(*runaddr == RUNNING) {
			if (trylock(lock))
				return WHOOPEE;
			cpu relax
		}
		yield (_on(thread));
	} while(*runaddr != DEAD);


which unlike blindly spinning can avoid the worst of any hit on the CPU
power and would be a bit more guided ?

