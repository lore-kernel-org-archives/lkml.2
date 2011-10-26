Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab1JZRem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:34:42 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:48671 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920Ab1JZRel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:34:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/lkml
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Shuah Khan <shuah.khan@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [RFC][PATCH X86_32 1/2]: Call do_notify_resume() with
	interrupts enabled
In-Reply-To: Russell King's message of  Wednesday, 26 October 2011 16:10:05 +0100 <20111026151005.GA1413@flint.arm.linux.org.uk>
References: <20111025141812.GA21225@linux.vnet.ibm.com>
	<20111025161426.GC17067@redhat.com>
	<CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
	<20111026151005.GA1413@flint.arm.linux.org.uk>
X-Windows: flaky and built to stay that way.
Message-Id: <20111026173438.9007C2C0D7@topped-with-meat.com>
Date: Wed, 26 Oct 2011 10:34:38 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=mZZbtzAwqg8A:10
		a=kj9zAlcOel0A:10 a=fSL0Xm43gfnve0d9cbYA:9 a=wBLEjfIkVQDL_3qIZqgA:7
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I worry about are race condition like the following:
> 
> syscall enter
> ...
> syscall returns -ERESTARTNOHAND
> check for signal
> 	signal pending, but no handler, setup for restart
> 	interrupt happens, sets need_resched
> need_resched set
> 	switch to another thread
> ...
> 	something happens which queues SIGIO
> 	switch back to this thread
> check for signal
> 	signal pending, has handler, but we've setup for a restart
> return to userspace
> run SIGIO handler
> restart syscall

I don't think this is a violation.  That ERESTARTNOHAND referred to
restarting for the signal that interrupted that first syscall.  That
decision has already been made.  You can consider that restart already to
have begun before the second signal arrives.  In essence, it's like the
first syscall had never been entered, because the user state is already
rolled back to where the syscall instruction is about to execute (correct
me if I'm wrong about that).  Then the second signal comes along and
prevents that instruction from executing.  It's really no different from if
you had gotten all the way back to user mode, but not yet executed the
first user instruction (i.e. the syscall instruction), when the second
signal interrupted the user task.

> However, that doesn't solve the (probably unsolvable) case where an
> ERESTARTSYS syscall is interrupted by a SA_RESTART-marked handler, and
> while that handler is running it is then interrupted by a non-SA_RESTART-
> marked handler.  I think that is far too an obscure case to care about
> though.

I'm personally for caring about all cases, no matter how obscure.  For that
particular one, I don't think I see the problem.  I'm probably overlooking
something.  ERESTARTSYS says that the user state should be rolled back to
the syscall instruction before the handler setup.  So it's just as if the
signal had arrived before user mode executed the syscall instruction in the
first place.  That just affects the sigcontext saved before the handler
runs.  Nothing about that interacts with further interruptions during the
handler.  What am I missing?

However, we already have the fundamental constraint that
ERESTART_RESTARTBLOCK states are lost when a handler runs.


Thanks,
Roland
