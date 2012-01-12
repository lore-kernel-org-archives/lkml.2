Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2ALRgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:36:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34088 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2ALRf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120112172241.GJ7180@jl-vm1.vm.bytemark.co.uk>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<1326383015.7642.77.camel@gandalf.stny.rr.com>
	<CABqD9hbOUy1qO0f+JFitRXH6c5EgLTWOh5eGdo8dTxeXJ40h2g@mail.gmail.com>
	<20120112172241.GJ7180@jl-vm1.vm.bytemark.co.uk>
Date: Thu, 12 Jan 2012 11:35:55 -0600
Message-ID: <CABqD9hYza5BpOk-+n0svHVGuWem39M=asGTMPy0z1ke0rCv8hA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:22 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Will Drewry wrote:
>> On Thu, Jan 12, 2012 at 9:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Wed, 2012-01-11 at 11:25 -0600, Will Drewry wrote:
>> >
>> >> Filter programs may _only_ cross the execve(2) barrier if last filter
>> >> program was attached by a task with CAP_SYS_ADMIN capabilities in its
>> >> user namespace.  Once a task-local filter program is attached from a
>> >> process without privileges, execve will fail.  This ensures that only
>> >> privileged parent task can affect its privileged children (e.g., setuid
>> >> binary).
>> >
>> > This means that a non privileged user can not run another program with
>> > limited features? How would a process exec another program and filter
>> > it? I would assume that the filter would need to be attached first and
>> > then the execv() would be performed. But after the filter is attached,
>> > the execv is prevented?
>>
>> Yeah - it means tasks can filter themselves, but not each other.
>> However, you can inject a filter for any dynamically linked executable
>> using LD_PRELOAD.
>>
>> > Maybe I don't understand this correctly.
>>
>> You're right on.  This was to ensure that one process didn't cause
>> crazy behavior in another. I think Alan has a better proposal than
>> mine below.  (Goes back to catching up.)
>
> You can already use ptrace() to cause crazy behaviour in another
> process, including modifying registers arbitrarily at syscall entry
> and exit, aborting and emulating syscalls.
>
> ptrace() is quite slow and it would be really nice to speed it up,
> especially for trapping a small subset of syscalls, or limiting some
> kinds of access to some file descriptors, while everything else runs
> at normal speed.
>
> Speeding up ptrace() with BPF filters would be a really nice.  Not
> that I like ptrace(), but sometimes it's the only thing you can rely on.
>
> LD_PRELOAD and code running in the target process address space can't
> always be trusted in some contexts (e.g. the target process may modify
> the tracing code or its data); whereas ptrace() is pretty complete and
> reliable, if ugly.
>
> There's already a security model around who can use ptrace(); speeding
> it up needn't break that.
>
> If we'd had BPF ptrace in the first place, SECCOMP wouldn't have been
> needed as userspace could have done it, with exactly the restrictions
> it wants.  Google's NaCl comes to mind as a potential user.

That's not entirely true.  ptrace supervisors are subject to races and
always fail open.  This makes them effective but not as robust as a
seccomp solution can provide.

With seccomp, it fails close.  What I think would make sense would be
to add a user-controllable failure mode with seccomp bpf that calls
tracehook_ptrace_syscall_entry(regs).  I've prototyped this and it
works quite well, but I didn't want to conflate the discussions.

Using ptrace() would also mean that all consumers of this interface
would need a supervisor, but with seccomp, the filters are installed
and require no supervisors to stick around for when failure occurs.

Does that make sense?
thanks!
will
