Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab2JYIOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:14:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:55549 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2JYIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:14:29 -0400
Date: Thu, 25 Oct 2012 10:14:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if
 FUTEX_WAITERS is not set
In-Reply-To: <5088C10C.80503@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1210250936270.2756@ionos>
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com> <5086A3D1.7080709@linux.intel.com> <alpine.LFD.2.02.1210232138540.2756@ionos> <5088C10C.80503@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Darren Hart wrote:
> On 10/23/2012 01:29 PM, Thomas Gleixner wrote:
> > Now the proposed change
> > 
> > -	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> > +       if (unlikely(ownerdied ||
> > +                       !(curval & (FUTEX_TID_MASK | FUTEX_WAITERS)))) {
> > 
> > solves the problem, but it's not obvious why and it wreckages the
> > "stale WAITERS bit" case.
> 
> 
> In what scenario does the WAITERS bit become stale for pi futexes? This
> corner case seems rather core to your solution, so I would like to
> understand it a bit better.

Hmm. I can't reconstruct the scenario anymore, though this has been an
issue some time ago. Either we fixed up that case in course of the big
restructuring of the code or it's just there and I cant decode
it. Brain hurts.

> > Now there is a different solution to that problem. Do not look at the
> > user space value at all and enforce a lookup of possibly available
> > pi_state. If pi_state can be found, then the new incoming locker T3
> > blocks on that pi_state and legitimately races with T2 to acquire the
> > rt_mutex and the pi_state and therefor the proper ownership of the
> > user space futex.
> 
> My first concern here is performance impact by forcing the pi_state
> lookup, however, if we got this far, we already took the syscall, and
> our performance sucks anyway. Correctness obviously trumps performance here.

Right, the pi_state lookup is cheap compared to the syscall, locking ....

And even without the stale WAITERS bit issue, the bit below is a good
reason to do it this way.

> > Another benefit of changing the code this way is that it makes it less
> > dependent on untrusted user space values and therefor minimizes the
> > possible wreckage which might be inflicted.
> 
> That's a definite plus!

Indeed.

> I was surprised at how fast you were able to page all this in after all
> that travel - or is this what you did for 12 hours on the plane?

Nah. I'm just too paranoid to apply any futex patch w/o understanding
the root cause of it.  Darn, if I only could remember how that stale
waiters bit issue got inflicted ....

Thanks,

	tglx


