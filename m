Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2ARVJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:09:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55475 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab2ARVJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:09:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120118171210.GB16835@redhat.com>
References: <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
	<20120117170512.GB17070@redhat.com>
	<CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
	<49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	<20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
	<20120118170006.GA16835@redhat.com>
	<20120118171210.GB16835@redhat.com>
Date: Wed, 18 Jan 2012 13:09:09 -0800
Message-ID: <CAMnK33VcHEP4sMkzk09VEZL=h2eUqvHHF99jmF0qzDj_6SzVOw@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: Chris Evans <scarybeasts@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Oleg. Seems like this would be a nice change to have. As we
can see, people do use ptrace() as a security technology.

With this in place, you can also (where possible) set up the tracee
with PR_SET_PDEATHSIG==SIGKILL. And then, you have defences again
either of the tracer or tracee dying from a stray SIGKILL.

On Wed, Jan 18, 2012 at 9:12 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/18, Oleg Nesterov wrote:
>>
>> On 01/17, Chris Evans wrote:
>> >
>> > 1) Tracee is compromised; executes fork() which is syscall that isn't allowed
>> > 2) Tracee traps
>> > 2b) Tracee could take a SIGKILL here
>> > 3) Tracer looks at registers; bad syscall
>> > 3b) Or tracee could take a SIGKILL here
>> > 4) The only way to stop the bad syscall from executing is to rewrite
>> > orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
>> > syscall has finished)
>> > 5) Disaster: the tracee took a SIGKILL so any attempt to address it by
>> > pid (such as PTRACE_SETREGS) fails.
>> > 6) Syscall fork() executes; possible unsupervised process now running
>> > since the tracer wasn't expecting the fork() to be allowed.
>>
>> As for fork() in particular, it can't succeed after SIGKILL.
>>
>> But I agree, probably it makes sense to change ptrace_stop() to check
>> fatal_signal_pending() and do do_group_exit(SIGKILL) after it sleeps
>> in TASK_TRACED. Or we can change tracehook_report_syscall_entry()
>>
>>       -       return 0;
>>       +       return !fatal_signal_pending();
>>
>> (no, I do not literally mean the change above)
>>
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
>  /*
>  * ptrace report for syscall entry and exit looks identical.
>  */
> -static inline void ptrace_report_syscall(struct pt_regs *regs)
> +static inline int ptrace_report_syscall(struct pt_regs *regs)
>  {
>        int ptrace = current->ptrace;
>
>        if (!(ptrace & PT_PTRACED))
> -               return;
> +               return 0;
>
>        ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
>
> @@ -72,6 +72,8 @@ static inline void ptrace_report_syscall
>                send_sig(current->exit_code, current, 1);
>                current->exit_code = 0;
>        }
> +
> +       return fatal_signal_pending(current);
>  }
>
>  /**
> @@ -96,8 +98,7 @@ static inline void ptrace_report_syscall
>  static inline __must_check int tracehook_report_syscall_entry(
>        struct pt_regs *regs)
>  {
> -       ptrace_report_syscall(regs);
> -       return 0;
> +       return ptrace_report_syscall(regs);
>  }
>
>  /**
>
