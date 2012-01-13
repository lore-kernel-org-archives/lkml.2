Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2AMCox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 21:44:53 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:34457 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2AMCov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 21:44:51 -0500
Message-ID: <6c0244a1a4d64274ecdd09c89d1c98d7.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120112175750.GN7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
    <1326302710-9427-2-git-send-email-wad@chromium.org>
    <1326383015.7642.77.camel@gandalf.stny.rr.com>
    <CABqD9hbOUy1qO0f+JFitRXH6c5EgLTWOh5eGdo8dTxeXJ40h2g@mail.gmail.com>
    <20120112172241.GJ7180@jl-vm1.vm.b
    <20120112175750.GN7180@jl-vm1.vm.bytemark.co.uk>
Date: Fri, 13 Jan 2012 03:44:40 +0100
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
 BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Jamie Lokier" <jamie@shareable.org>
Cc: "Will Drewry" <wad@chromium.org>, "Steven Rostedt" <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundatio
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 3c11394861542ed80f8a69179537bf2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think execve should be allowed and follow the same rules as execve under ptrace.

On Thu, January 12, 2012 18:57, Jamie Lokier wrote:
> Will Drewry wrote:
>> On Thu, Jan 12, 2012 at 11:22 AM, Jamie Lokier <jamie@shareable.org> wrote:
>> > Will Drewry wrote:
>> >> On Thu, Jan 12, 2012 at 9:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >> > On Wed, 2012-01-11 at 11:25 -0600, Will Drewry wrote:
>> >> >
>> >> >> Filter programs may _only_ cross the execve(2) barrier if last filter
>> >> >> program was attached by a task with CAP_SYS_ADMIN capabilities in its
>> >> >> user namespace. �Once a task-local filter program is attached from a
>> >> >> process without privileges, execve will fail. �This ensures that only
>> >> >> privileged parent task can affect its privileged children (e.g., setuid
>> >> >> binary).
>> >> >
>> >> > This means that a non privileged user can not run another program with
>> >> > limited features? How would a process exec another program and filter
>> >> > it? I would assume that the filter would need to be attached first and
>> >> > then the execv() would be performed. But after the filter is attached,
>> >> > the execv is prevented?
>> >>
>> >> Yeah - it means tasks can filter themselves, but not each other.
>> >> However, you can inject a filter for any dynamically linked executable
>> >> using LD_PRELOAD.
>> >>
>> >> > Maybe I don't understand this correctly.
>> >>
>> >> You're right on. �This was to ensure that one process didn't cause
>> >> crazy behavior in another. I think Alan has a better proposal than
>> >> mine below. �(Goes back to catching up.)
>> >
>> > You can already use ptrace() to cause crazy behaviour in another
>> > process, including modifying registers arbitrarily at syscall entry
>> > and exit, aborting and emulating syscalls.
>> >
>> > ptrace() is quite slow and it would be really nice to speed it up,
>> > especially for trapping a small subset of syscalls, or limiting some
>> > kinds of access to some file descriptors, while everything else runs
>> > at normal speed.
>> >
>> > Speeding up ptrace() with BPF filters would be a really nice. �Not
>> > that I like ptrace(), but sometimes it's the only thing you can rely on.
>> >
>> > LD_PRELOAD and code running in the target process address space can't
>> > always be trusted in some contexts (e.g. the target process may modify
>> > the tracing code or its data); whereas ptrace() is pretty complete and
>> > reliable, if ugly.
>> >
>> > There's already a security model around who can use ptrace(); speeding
>> > it up needn't break that.
>> >
>> > If we'd had BPF ptrace in the first place, SECCOMP wouldn't have been
>> > needed as userspace could have done it, with exactly the restrictions
>> > it wants. �Google's NaCl comes to mind as a potential user.
>>
>> That's not entirely true.  ptrace supervisors are subject to races and
>> always fail open.  This makes them effective but not as robust as a
>> seccomp solution can provide.
>
> What races do you know about?
>
> I'm not aware of any ptrace races if it's used properly.  I'm also not
> sure what you mean by fail open/close here, unless you mean the target
> process gets to carry on if the tracing process dies.

That one could be easily fixed with a new ptrace option.

The tracer can kill all traced tasks before it dies except when it exits
with a SIGKILL. In that case another observer task could kill all the
traced tasks, but that is just moving the problem around.

> Having said that, I can think of one race, but I think your BPF scheme
> has the same one: After checking the syscall's string arguments and
> other pointed to data, another thread can change those arguments
> before the real syscall uses them.

I have implemented a ptrace based jailer which avoids these kinds of
races by copying such strings to read-only memory before the system call
is allowed to proceed. Only races that can't be closed with ptrace are
symlink races, and then only with an attacker outside the jail.

And the architectural differences in registers are easily abstracted away
when you're only interested in system call arguments and the instruction
pointer. The system call table information is more annoying, but unavoidable.

Our jailer is around 5k lines of code and supports checking file paths, PIDs,
FDs, SYSV IPC and has limited networking support (no incoming peer address
filtering), all race free. The idea is transparent jailing of complex tasks
with minimal configuration (everything is contained within the jail, access
to anything else needs explicit permission). It's more or less finished for
a few years now, but everyone is busy with other things and no one got around
releasing the code. :-/

It would be nice to avoid the ptrace overhead for system calls that are always
allowed or always denied, so I hope this BPF filtering can be made to work in
conjunction with ptrace so that the tracer only has to handle system calls not
handled by the BPF filter. One way to achieve that is to have a way for the BPF
filter to let a system call generate ptrace system call events or not, with a
new ptrace option PTRACE_UNHANDLED_SYSCALL or something like that to ask for
the unhandled system calls events.

Greetings,

Indan


