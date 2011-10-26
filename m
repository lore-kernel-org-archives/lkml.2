Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1JZTDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:03:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1JZTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:03:45 -0400
Date: Wed, 26 Oct 2011 20:58:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20111026185838.GA24358@redhat.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com> <20111025161426.GC17067@redhat.com> <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com> <20111026151005.GA1413@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026151005.GA1413@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26, Russell King wrote:
>
> I've been toying with a similar patch for ARM, but I keep feeling uneasy
> about having interrupts enabled in this path (even though they get enabled
> in the depths of the signal handling code.)
>
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

I don't understand how "interrupts disabled" can help... A signal
can come without preempt_schedule().

> check for signal
> 	signal pending, has handler, but we've setup for a restart
> return to userspace
> run SIGIO handler
> restart syscall
>
> This feels like it violates the expectations of the syscall being
> restarted - which explicitly asks to be restarted only if there wasn't
> a handler run.

But this doesn't differ from the case when this signal comes after
the sycall was already restarted?

> However, that doesn't solve the (probably unsolvable) case where an
> ERESTARTSYS syscall is interrupted by a SA_RESTART-marked handler, and
> while that handler is running it is then interrupted by a non-SA_RESTART-
> marked handler.  I think that is far too an obscure case to care about
> though.

If I understand correctly, this was already discussed:

	 Re: HR timers prevent an itimer from generating EINTR?
	 http://marc.info/?l=linux-kernel&m=125384722012869

Unfortunately, marc.info doesn't show the authoritative reply from
Roland, but he agreed with "not a problem".

Or I misunderstood?

Oleg.

