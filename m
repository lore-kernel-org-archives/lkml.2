Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab2KYXsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:48:39 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:55023 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2KYXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:48:38 -0500
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
To: oleg@redhat.com (Oleg Nesterov)
Date: Mon, 26 Nov 2012 10:48:34 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121125225533.GA24905@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121125234834.DAC34592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> > 2) I was then told (in my own words): "oh, don't worry, the vsyscall page
> >    has now been minimized, all it contains now is *real* system calls,
> >    and it always calls them".
> 
> Not sure where did you get this idea ;) From the very beginning you were
> told that EMULATE mode doesn't do this.

Sorry, I was not aware of the existence of "EMULATE" at the time,
or that it was the default, so I lived in a "NATIVE" world... and
was content that yesterday's problem was solved...  I just looked
at the vsyscall page itself, found the system-calls there and was
"happy" with it, that I could now catch them like anywhere else.

> > 8) Any solution that allows a ptracer to prevent its traced process
> >    from entering the vsyscall page and execute there system-calls
> >    unchecked (thus in effect escape its jailer), would do for me.
> 
> Well. I am even more confused... probably this was already discussed
> and I missed this, but.
> 
> Why do you need to _prevent_, say, sys_gettimeofday()? Why we can't
> change emulate_vsyscall() to respect PTRACE_SYSCALL and report
> TRAP_VSYSCALL or PTRACE_EVENT_VSYSCALL as I tried to suggest in
> http://marc.info/?l=linux-kernel&m=135343635523715 ?
> 
> Oleg.
> 

For my own application, I would be happy with this.

But I suspect it might break current versions of "strace",
or similar programs that expect to find the program-counter
pointing at a "syscall" instruction.

At present "strace" fails to report "gettimeofday()", but at
least it does not crash.  Surely "strace" can and should be
enhanced to handle this, but existing versions may suffer.

> 
> You previously replied that this can not work. Now that you see that
> this _can_ work, could you please explain why this is not enough?

I think it COULD work, but not based on PTRACE_SYSCALL
(or PTRACE_SYSEMU) alone.  A new ptrace option will be needed, saying:
"Yes, I am aware of TRAP_VSYSCALL and I know how to handle it."

While for my own application, just fixing the range-check in
arch_check_bp_in_kernelspace will do, requiring a smaller patch,
I agree that fixing this properly by adding a new ptrace option
can help other programmers, so they need not bother with the x86
debug-registers (or perhaps they may need them for other purposes).

Best Regards,
Amnon.
