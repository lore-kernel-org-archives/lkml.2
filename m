Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2LENOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:14:40 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:14150 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LENOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:14:38 -0500
Message-ID: <8e2e79d5d683f9a774965e47acb20992.squirrel@mail.sublimeip.com>
In-Reply-To: <20121205092951.GA14280@host2.jankratochvil.net>
References: <20121205092951.GA14280@host2.jankratochvil.net>
Date: Thu, 6 Dec 2012 00:14:35 +1100
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
From: u3557@miso.sublimeip.com
To: "Jan Kratochvil" <jan.kratochvil@redhat.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>,
        "Amnon Shiloh" <u3557@miso.sublimeip.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Pedro Alves" <palves@redhat.com>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Reply-To: mosix@mosix.com.au
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jan,

> x86 debug registers are already very scarce.  Besides that userland
> applications know they have 4 of them available so it would also break
> them.

If a userland application wants to cheat, then it has no need to bypass
the debug registers: even if there were 4096 of them, covering the whole
vsyscall page, it could simply copy the whole vsyscall page somewhere
else, then run (or emulate) it, or look directly at the raw data within
the vsyscall page.  The only way to overcome that would be to make the
vsyscall page either non-existent or unreadable.

Personally, allowing userland applications to read the vsyscall page
can't hurt me and my applications, but if someone else is concerned with
such malicious programs (does anyone?), if they need to construct the
strictest-of-strict jail, where jailed applications cannot glimpse
any information from the kernel they run on no matter how hard they try,
then they must at least make the vsyscall page unreadable, then rely
either on kernel emulation or a SIGSEGV (the later would be quite
sufficient for my own needs as a substitute for debug-registers,
but unfortunately not for the current version of "strace").

If, as I was told, it's too hard to remove the vsyscall page on a
per-process basis, then it's sufficient to make it unreadable on
context-switch.

My concern, however, is not with the bad guys, but with good honest
programs that would run incorrectly if allowed to call "time()" or
"gettimeofday()" unsupervised.  No good program or library jumps into
the vsyscall page except into its 3 official entry points.

In summary, it should be decided:

If it is important enough for Linux to support paranoidically strict
jails, then full kernel emulation of PTRACE_SYSCALL (and PTRACE_SYSEMU)
is inescapable.

If, on the other hand, there is only a need to allow applications such as
mine and "strace"/"gdb" to trap system-calls that occur via the vsyscall
page, then in principle a variety of options are possible:

1. Allow setting the x86 hardware-debug registers into the vsyscall page.
2. Optional (per-process) removal of execute-permission from the vsyscall
   page.
3. Optional (per-process) removal of both read and execute permissions
   from the vsyscall page.
4. Optional (per-process) elimination of the vsyscall page altogether.
5. Kernel vsyscall emulation code to send some signal or event to traced
   processes if the ptracer asked for it (using a new ptrace option).
6. Complete and transparent emulation of PTRACE_SYSCALL/PTRACE_SYSEMU.

Option #1 requires the least effort (a 2-line fix).
Option #6 requires the most effort.

Best Regards,
Amnon.

> On Sun, 02 Dec 2012 20:30:58 +0100, Oleg Nesterov wrote:
>> Yes, that is why I said this needs the new option.
>
> I do not mind new options although personally I do not find them
> meaningful
> for an already deprecated ABI compatibility-only issue.
>
>
>> If the tracer does PTRACE_SYSCALL the tracee reports syscall exit
>> _after_ gettimeofday/etc. The tracer can look at regs->orig_ax == -1
>> and detect that this is not syscall but vsyscall, it can look at
>> regs->ip then (not with the patch below).
>
> I believe applications just call PTRACE_SYSCALL twice, without checking
> orig_eax.  At least strace and its TCB_INSYSCALL looks so.
>
>
> On Mon, 03 Dec 2012 00:54:58 +0100, u3557@miso.sublimeip.com wrote:
>> The beauty of using the x86 debug-registers,
>
> x86 debug registers are already very scarce.  Besides that userland
> applications know they have 4 of them available so it would also break
> them.
>
>
> Regards,
> Jan
>


