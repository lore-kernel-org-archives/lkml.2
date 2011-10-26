Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab1JZPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:20:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34408 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab1JZPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:20:07 -0400
Date: Wed, 26 Oct 2011 16:10:05 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Shuah Khan <shuah.khan@hp.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [RFC][PATCH X86_32 1/2]: Call do_notify_resume() with
	interrupts enabled
Message-ID: <20111026151005.GA1413@flint.arm.linux.org.uk>
References: <20111025141812.GA21225@linux.vnet.ibm.com> <20111025161426.GC17067@redhat.com> <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 02:38:39PM +0200, Linus Torvalds wrote:
> Ingo, Thomas, I think this is your call, but it seems valid,

Hi Linus,

I guess I should've talked to you about this during a moment during the
kernel summit, but as I'm now back home it'll have to be email.

I've been toying with a similar patch for ARM, but I keep feeling uneasy
about having interrupts enabled in this path (even though they get enabled
in the depths of the signal handling code.)

I worry about are race condition like the following:

syscall enter
...
syscall returns -ERESTARTNOHAND
check for signal
	signal pending, but no handler, setup for restart
	interrupt happens, sets need_resched
need_resched set
	switch to another thread
...
	something happens which queues SIGIO
	switch back to this thread
check for signal
	signal pending, has handler, but we've setup for a restart
return to userspace
run SIGIO handler
restart syscall

This feels like it violates the expectations of the syscall being
restarted - which explicitly asks to be restarted only if there wasn't
a handler run.

I've been working on the assumption that this is a problem and we should
do something about it - but it's non-trivial to solve all the corner cases.
We can do a lot better with the restarting if we delay setting up for a
restart until either we setup the user stack for the sig handler or
immediately before returning to userspace (with a TIF flag.)

If you're interested in seeing where I got to, the patch is available at:
	https://lkml.org/lkml/2011/8/25/231

However, that doesn't solve the (probably unsolvable) case where an
ERESTARTSYS syscall is interrupted by a SA_RESTART-marked handler, and
while that handler is running it is then interrupted by a non-SA_RESTART-
marked handler.  I think that is far too an obscure case to care about
though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
