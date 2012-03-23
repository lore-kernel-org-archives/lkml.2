Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab2CWTVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:21:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54588 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab2CWTVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:21:54 -0400
Date: Fri, 23 Mar 2012 12:21:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120323192143.GY2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120319152317.GA3932@gmail.com>
 <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com>
 <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032319-7182-0000-0000-0000011B8DDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 06:08:01PM -0700, Linus Torvalds wrote:
> On Mon, Mar 19, 2012 at 8:33 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > If it would help, I would be happy to put together an itemized list.
> > I will of course do so for the next merge window.
> 
> Ok. I would like to get an itemized list next time, now I ended up
> re-doing the merges with the one Ingo sent me.

Will do!

> However, looking at the current state of RCU, the thing I would
> *really* like to *finally* be fixed is that total disaster called
> __rcu_read_lock() (and to a lesser degree __rcu_read_unlock).
> 
> Why do I call it a total disaster?
> 
> Simple: there are two versions of that function (not counting the
> inlined trivial non-preempt version that just disables preemption),
> AND THEY ARE BOTH IDENTICAL.
> 
> More importantly, they are both IDENTICALLY BAD.
> 
> They are crap because:
> 
>  - they shouldn't be out-of-line to begin with.
> 
>    Doing a function call for these things is stupid. It's  not like
> it's even "oh, there are two versions of it, so the linker picks one
> over the other". Sure, there are two versions of it, but they are the
> same stupid code just duplicated.
> 
>  - the rcu counter should be a per-cpu counter, not a per-thread one
> 
> Right now that function ends up being two instructions:
> 
>         mov    %gs:0xb700,%rax
>         incl   0x100(%rax)
> 
> and dammit, using a function call to do that is pretty much
> borderline. But it should be *one* instruction that just increments
> the percpu variable:
> 
>         incl %gs:rcu_read_lock_nesting
> 
> and it shouldn't be out-of-line.
> 
> Because wouldn't it be nice to just make the scheduler save/restore
> the rcu read lock depth for the rcu preemption case.

Good point, especially given that there already is an RCU hook in
the scheduler entry path that could be used for this purpose, namely
rcu_note_context_switch().  I would need a hook in the scheduler exit
path.  My guess is that this should go right after post_schedule().
(Or am I missing an early exit in there somewhere, Peter?)

The nice thing about this is that it avoids include-file issues.

Other architectures would have a load-add-store sequence, but assuming
that no RCU read-side critical sections in the scheduler extend over
the rcu_note_context_switch() and rcu_note_context_switch_end() (or
whatever), this should be OK -- the value will be properly saved and
restored.

I don't believe that I would have thought of this approach, so I don't
feel quite as guilty about being lazy on inlining __rcu_read_lock()
and __rcu_read_unlock().  Thank you!

> Yeah, we should do the same thing with the preempt count. It shouldn't
> be in the thread structure, it should be per-cpu.
> 
> Please? Every time I look at some profiles, that silly rcu_read_lock
> is there in the profile. It's annoying. I'd rather see it in the
> function that invokes it.

Let me see what I can do...

							Thanx, Paul

