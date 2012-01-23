Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2AWChS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:37:18 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37907 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2AWChQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:37:16 -0500
Message-ID: <beeb7e2f1e2c8774c44f60e65b100941.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120121012311.GW7180@jl-vm1.vm.bytemark.co.uk>
References: <20120116183730.GB21112@redhat.com> <4F19EDAF.2000109@zytor.com>
    <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl>
    <201201210107.37250.vda.linux@googlemail.com>
    <CAB=4xhpKM5VwhKeoevzp+4VqvstV8siqjy68TJYBBir9F8hP1g@mail.gmail.com>
    <20120121012311.GW7180@jl-vm1.vm.bytemark.co.uk>
Date: Mon, 23 Jan 2012 03:37:00 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Jamie Lokier" <jamie@shareable.org>
Cc: "Roland McGrath" <mcgrathr@google.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Andrew Lutomirski" <luto@mit.edu>,
        "Oleg Nesterov" <oleg@redhat.com>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 4a4e1dd80dce9ac0d9378b25a0c059e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, January 21, 2012 02:23, Jamie Lokier wrote:
> Roland McGrath wrote:
>> On Fri, Jan 20, 2012 at 4:07 PM, Denys Vlasenko
>> <vda.linux@googlemail.com> wrote:
>> >> Maybe a bit telling whether it is syscall entry or exit?
>> >
>> > Yes, this one too. This is one of longstanding annoyances
>> > that this information is not exposed.
>>
>> That is not really "state", it's just which event you want.
>> That is much better addressed by replacing PTRACE_SYSCALL
>> with PTRACE_O_TRACE_SYSCALL_{ENTRY,EXIT} and PTRACE_EVENT_SYSCALL_{ENTRY,EXIT}.
>> Oleg can whip that up for you no problem.
>
> I agree, that is so obviously the right thing to do and it's very easy
> to do in the tracehook functions.

Yes, bad place for it, much better via ptrace flags. We're usually not
interested in syscall exit events, so having a way to not always get
syscall exit events would improve performance quite a bit too.

> There is one slight problem that some archs don't use
> tracehook yet. Probably that should be fixed anyway.
>
> (Fwiw, two other issues with arch-independent ptrace have come up in this
> thread, which ought to be fairly easy to fix:
>    - If tracer dies, tracee is free to continue running.  For security
>      tracers, and would be useful for strace as well, it would be good
>      to have an option to SIGKILL the tracee if tracer dies.

It should be easy to add a PTRACE_O_SIGKILL_ON_DEATH option.

>    - Can't abort or change an unwanted syscall if the process receives
>      SIGKILL as it's about to start a syscall (which will be its last).)

This is very important for any syscall filtering/control via ptrace, otherwise
SIGKILL becomes a security problem. Oleg had a patch for that:

On Wed, January 18, 2012 18:12, Oleg Nesterov wrote:
> On 01/18, Oleg Nesterov wrote:
>> Not only for security. The current behaviour sometime confuses the
>> users. Debugger sends SIGKILL to the tracee and assumes it should
>> die asap, but the tracee exits only after syscall.
>
> Something like the patch below.
>
> Oleg.
>
> --- x/include/linux/tracehook.h
> +++ x/include/linux/tracehook.h
> @@ -54,12 +54,12 @@ struct linux_binprm;
>  /*
>   * ptrace report for syscall entry and exit looks identical.
>   */
> -static inline void ptrace_report_syscall(struct pt_regs *regs)
> +static inline int ptrace_report_syscall(struct pt_regs *regs)
>  {
>  	int ptrace = current->ptrace;
>
>  	if (!(ptrace & PT_PTRACED))
> -		return;
> +		return 0;
>
>  	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
>
> @@ -72,6 +72,8 @@ static inline void ptrace_report_syscall
>  		send_sig(current->exit_code, current, 1);
>  		current->exit_code = 0;
>  	}
> +
> +	return fatal_signal_pending(current);
>  }
>
>  /**
> @@ -96,8 +98,7 @@ static inline void ptrace_report_syscall
>  static inline __must_check int tracehook_report_syscall_entry(
>  	struct pt_regs *regs)
>  {
> -	ptrace_report_syscall(regs);
> -	return 0;
> +	return ptrace_report_syscall(regs);
>  }
>
>  /**
>

