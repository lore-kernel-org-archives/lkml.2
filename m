Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab2KXNpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 08:45:15 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:59967 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2KXNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 08:45:13 -0500
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
To: oleg@redhat.com (Oleg Nesterov)
Date: Sun, 25 Nov 2012 00:45:11 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121123163320.GA32716@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121124134511.47C5A592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> Hello Amnon,
> 
> I am a bit confused,

So let's get things in order.

1) I asked for the ability to set hardware breakpoints on the vsyscall
   page (x86 debug registers), so that the ptracer can stop the process
   whenever it attempts to jump there, then the ptracer can emulate those
   system calls instead (gettimeofday, time, getcpu).

   That would solve all my problems, because the traced process will
   never even enter the vsyscall page (the ptracer will adjust its
   program-counter).

2) I was then told (in my own words): "oh, don't worry, the vsyscall page
   has now been minimized, all it contains now is *real* system calls,
   and it always calls them".

   [as a side-issue I was introduced to the new VDSO, had some issues there
    and solved them separately, so we are back on the original topic]

3) I was thinking to myself - well, that's fine, if the vsyscall now
   always invokes a *real* system-call (and nothing else), then the
   ptracer can catch it just like any other system-call using
   PTRACE_SYSCALL (or PTRACE_SYSEMU), and emulate it as usual,
   vsyscall-or-no-vsyscall.

4) I made some tests and found that I was wrong in my assumption:
   PTRACE_SYSCALL does NOT work within the vsyscall page (nor does
   PTRACE_SINGLESTEP).  Ptracers are not even aware that their tracee
   ever issued a system call there (despite using PTRACE_SYSCALL or
   PTRACE_SYSEMU), so they are unable to emulate it (or even to report
   it, in the case of "strace").

5) Therefore, I still need the original feature - to relax
   "arch_check_bp_in_kernelspace()", or whatever else will allow me
   to set the x86 debug-registers to trap all attempts to enter the
   vsyscall page.

6) I just suggested an alternative: to have the whole vsyscall page
   removed on a per-process basis. I accept your reply that this is
   not possible.

7) I suggested a third alternative: to have the vsyscall page be
   unexecutable on a per-process basis, so attempts to use it will
   incur SIGSEGV.   I understand that this option is still under
   discussion.

8) Any solution that allows a ptracer to prevent its traced process
   from entering the vsyscall page and execute there system-calls
   unchecked (thus in effect escape its jailer), would do for me.

Best Regards,
Amnon.


> 
> On 11/23, Amnon Shiloh wrote:
> >
> > What I discovered now, is that PTRACE_SYSCALL (also PTRACE_SINGLESTEP)
> > does not work within the vsyscall page, so I cannot trap the kernel-calls
> > there (this is very simple to verify using "gdb" or "strace").
> 
> Sure, but we alredy discussed this?
> 
> Once again, PTRACE_SYSCALL should work in the NATIVE mode. Obviously it
> won't work in EMULATE mode but we can change emulate_vsyscall() to report
> TRAP_VSYSCALL or even introduce PTRACE_EVENT_VSYSCALL.
> 
> > The necessary patch was already discussed and is very simple.
> 
> Do you mean TRAP_VSYSCALL/PTRACE_EVENT_VSYSCALL above or additional
> in_gate_area_no_mm() check to allow the hw bp?
> 
> > Or, there is an alternative: if only I (the ptracer or the traced process)
> > was allowed to munmap the vsyscall page,
> 
> It is not possible to unmap it. The kernel (swapper_pg_dir) has this
> mapping, not the process. Unlike vdso. IOW, you can only "unmap" it
> globally and obviously you can't do this from the userspace.
> 
> Oleg.
> 
> 

