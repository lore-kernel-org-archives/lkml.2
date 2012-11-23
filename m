Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2KWJO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:14:58 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:34447 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2KWJOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:14:55 -0500
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
To: oleg@redhat.com (Oleg Nesterov)
Date: Fri, 23 Nov 2012 20:14:52 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121122161238.GA27078@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121123091453.016B0592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Oleg,

After the detour into the VDSO page, which is really a separate issue,
but one which I was able to work around in user-mode (for my particular
needs, not yet for all others who write checkpoint/restore pacakges),
I am sad to report that despite my previous post, the "vsyscall" problem
was not solved after all.

I made some further tests, without the fix that allows a hardware
breakpoint in the kernel, hoping that fixing the VDSO issue solves
it all, but alas, current libraries still call the vsyscall page even
when the VDSO page is present.

My dynamic glibc library calls call the VDSO version of "gettimeofday()",
but still uses the vsyscall version of "time()", while the static library
uses vsyscall for both.

What I discovered now, is that PTRACE_SYSCALL (also PTRACE_SINGLESTEP)
does not work within the vsyscall page, so I cannot trap the kernel-calls
there (this is very simple to verify using "gdb" or "strace").

I suspect that statically-linked executables will be around for a while,
long after the rest of the glibc library moves to VDSO, hence I still need
to place hardware breakpoints in the vsyscall page.

The necessary patch was already discussed and is very simple.

Or, there is an alternative: if only I (the ptracer or the traced process)
was allowed to munmap the vsyscall page, just get rid of that page
altogether, or at least make it non-executable, that would be fine
too for me, because then the process will get a SIGSEGV signal, which
the ptracer can easily handle.

Best Regards,
Amnon.

> On 11/22, Amnon Shiloh wrote:
> >
> > Now however, that "vsyscall" was effectively replaced by vdso, it
> > creates a new problem for me and probably for anyone else who uses
> > some form of checkpoint/restore:
> 
> Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
> seem to enjoy trying to solve the c/r problems.
> 
> > Suppose a process is checkpointed because the system needs to reboot
> > for a kernel-upgrade, then restored on the new and different kernel.
> > The new VDSO page may no longer match the new kernel - it could for
> > example fetch data from addresses in the vsyscall page that now
> > contain different things; or in case the hardware also was changed,
> > it may use machine-instructions that are now illegal.
> 
> Sure. You shouldn't try to save/restore this page(s) directly. But
> I do not really understand why do you need. IOW, I don't really
> understand the problem, it depends on what c/r actually does.
> 
> > As I don't mind to forego the "fast" sys_time(), my obvious solution
> > is to disable the vdso for traced processes that may be checkpointed.
> >
> > One way to do it would be by brute-force: straight after "execve"
> > unmap the tracee's vdso page,
> 
> Not sure this will be always possible. For example, my (old) glibc
> assumes that vsyscall() must work, I won't be surprised if some time
> later it won't work without vdso. But again, I do not know.
> 
> > then manipulate the ELF tables in
> > its memory so the VDSO entry is gone and the library will not go
> > looking for it.
> 
> Probably it would be enough to simply erase AT_SYSINFO_EHDR note,
> but again, I can be easily wrong.
> 
> > I just wonder whether you know of an easier and more standard way
> > to disable the vdso in user-mode
> 
> Only the kernel parameter, afaics. vdso=0
> 
> > - ideally on a per-process basis,
> > or otherwise, if it's too hard, on the whole computer.  I searched
> > the web and found references to "/proc/sys/vm/vdso_enable", but I
> > have no such file or "sysctl" option on my system.
> 
> sys/vm/vdso_enabled, but only if CONFIG_X86_32 for some reason. See
> kernel/sysctl.c
> 
> Oleg.
> 
> 

