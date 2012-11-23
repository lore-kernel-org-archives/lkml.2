Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2KWAUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:20:25 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:43896 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2KWAUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:20:24 -0500
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
To: xemul@parallels.com (Pavel Emelyanov)
Date: Fri, 23 Nov 2012 11:20:21 +1100 (EST)
Cc: oleg@redhat.com (Oleg Nesterov), gorcunov@openvz.org (Cyrill Gorcunov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <50AE91AD.1090709@parallels.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121123002021.9A78159206F@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> >>
> >> Now however, that "vsyscall" was effectively replaced by vdso, it
> >> creates a new problem for me and probably for anyone else who uses
> >> some form of checkpoint/restore:
> > 
> > Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
> > seem to enjoy trying to solve the c/r problems.
> 
> Thank you :)

Thank YOU for joining!

> >> Suppose a process is checkpointed because the system needs to reboot
> >> for a kernel-upgrade, then restored on the new and different kernel.
> >> The new VDSO page may no longer match the new kernel - it could for
> >> example fetch data from addresses in the vsyscall page that now
> >> contain different things; or in case the hardware also was changed,
> >> it may use machine-instructions that are now illegal.
> 
> If we could make VDSO entry points not move across the kernels (iow, make
> them looks as yet another syscall table) this would help, I suppose.

It will indeed solve PART of the problem, but there is one more issue:

One obviously cannot c/r a process while it runs in the VDSO page
without c/r'ing that page itself, but this can probably be handled
by single-stepping the process until it is out of that page (assuming
there are no sleeps, pauses or extremely long loops on that page) -
but suppose a catched signal interrupts the VDSO code and the process
needs to be checkpointed within that interrupt code - eventually it
will return ("sigreturn") to the VDSO page... a different page...
and probably fall on the wrong machine-instruction (or even between
machine-instructions), with all registers scrambled anyway.

The solution can be to hold all catched signals while in the VDSO page.
This is not something the application (or library) can reasonably do
due to the prohibitive cost of "sigprocmask()" before and after, defying
the whole purpose of the VDSO page, but could be achieved by some new
'prctl' option (or perhaps even be the default).

In my specific case, because the checkpointed process is ptraced,
and assuming VDSO entry points are fixed, the ptracer can postpone
all catched signals that occur within the VDSO page, but for others
who write/maintain a c/r package, that's probably not an option.

> 
> > Sure. You shouldn't try to save/restore this page(s) directly. But
> > I do not really understand why do you need. IOW, I don't really
> > understand the problem, it depends on what c/r actually does.
> 
> Think about it like this -- you stop a process, then change the kern^w VDSO
> page. Everything should work as it used to be :)

There are two reasons one may need to save/restore this page:
1) Entry points are not fixed (yet).
2) In case the process needs to return to it back from an interrupt.

> 
> >> As I don't mind to forego the "fast" sys_time(), my obvious solution
> >> is to disable the vdso for traced processes that may be checkpointed.
> 
> This is very poor solution from my POV. Nobody wants to have their applications
> work fast only until it's checkpointed.

I know, but it's a price I must and am willing to pay until a solution
is found that prevents catching signals within the VDSO page.

I made a small experiment and just zeroed out the whole VDSO page
straight after "execve" (brute force, easier than having to study
the internal format of the VDSO page).  The program worked, using
the glibc version of "gettimeofday()" instead (which used "vsyscall",
but probably for not much longer).

So consider my immediate personal problem solved - what I'll do next
is to compile a special temporary kernel with all vdso functions
(__vdso_gettimeofday, __vdso_time, __vdso_clock_gettime, __vdso_getcpu)
reduced to system-calls, so they become kernel/hardware-independent,
then I'll save and set aside the resulting VDSO page and always replace
original VDSO pages with "my-vdso" after "execve".

However, this doesn't solve the problem for other c/r packages that do
not ptrace their processes all the time, and therefore unable to replace
the VDSO page immediately after each "execve".
For them you will need to either:

1) fix the VDSO entry points + introduce a kernel feature to prevent
   catching signals within the VDSO page (probably a new prctl,
   or make it the default) ; or
2) Introduce a kernel feature (probably a new prctl, so long as
   it is not reset across fork/clone/exec) for those programs who
   request it to load a "slow-but-sure", kernel/hardware-independent
   version of the VDSO page.

> 
> Thanks,
> Pavel
> 


Thank you and Best Regards,
Amnon.
