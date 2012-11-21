Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2KURar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:30:47 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:64235 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2KURaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:30:46 -0500
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
To: oleg@redhat.com (Oleg Nesterov)
Date: Thu, 22 Nov 2012 04:30:43 +1100 (EST)
Cc: rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121121141627.GB21030@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121121173043.F0319592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Yes, I can see that "arch/x86/kernel/vsyscall_64.c"
has changed dramatically since I last looked at it.

Since this is the case, I no longer need to trap the vsyscall page.

Now however, that "vsyscall" was effectively replaced by vdso, it
creates a new problem for me and probably for anyone else who uses
some form of checkpoint/restore:

Suppose a process is checkpointed because the system needs to reboot
for a kernel-upgrade, then restored on the new and different kernel.
The new VDSO page may no longer match the new kernel - it could for
example fetch data from addresses in the vsyscall page that now
contain different things; or in case the hardware also was changed,
it may use machine-instructions that are now illegal.

As I don't mind to forego the "fast" sys_time(), my obvious solution
is to disable the vdso for traced processes that may be checkpointed.

One way to do it would be by brute-force: straight after "execve"
unmap the tracee's vdso page, then manipulate the ELF tables in
its memory so the VDSO entry is gone and the library will not go
looking for it.  Alternately, the function-table within the VDSO
page can be erased.

I just wonder whether you know of an easier and more standard way
to disable the vdso in user-mode - ideally on a per-process basis,
or otherwise, if it's too hard, on the whole computer.  I searched
the web and found references to "/proc/sys/vm/vdso_enable", but I
have no such file or "sysctl" option on my system.

Best Regards,
Amnon.


> 
> Hi Amnon,
> 
> Please read my previous email ;)
> http://marc.info/?l=linux-kernel&m=135342649119153
> 
> On 11/21, u3557@miso.sublimeip.com wrote:
> >
> > Hi Oleg,
> >
> > > Or. Perhaps we can define TRAP_VSYSCALL and change emulate_vsyscall() to
> > > do
> > >
> > >
> > > 	if (current->ptrace && test_thread_flag(TIF_SYSCALL_TRACE))
> > > 		send_sigtrap(TRAP_VSYSCALL, ...);
> > >
> > > if it returns true?
> > >
> >
> > I wish it were possible, but the vsyscall page is entered in user-mode,
> 
> Only in NATIVE mode. emulate_vsyscall() runs in kernel mode.
> 
> And in the NATIVE mode PTRACE_SYSCALL should work just fine, because:
> 
> > The vsyscall page was designed in order to avoid user/kernel context
> > switches,
> 
> True, it was. But not today. Please look at __vsyscall_page:
> 
> 	__vsyscall_page:
> 
> 		mov $__NR_gettimeofday, %rax
> 		syscall
> 		ret
> 
> If you want the "fast" sys_time() without entering the kernel, you can
> use __vdso_time(). And since vdso has the user-space mapping you can
> insert "int3" or use hw breakpoints.
> 
> At least this is my understanding after I glanced at the new implementation.
> 
> 
> However. It is not that I think that TRAP_VSYSCALL is really good idea.
> At least it needs another option...
> 
> Oleg.
> 
> 

