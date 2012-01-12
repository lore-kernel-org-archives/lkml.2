Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2ALQwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:52:05 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58576 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870Ab2ALQwA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:52:00 -0500
MIME-Version: 1.0
In-Reply-To: <1326385635.7642.89.camel@gandalf.stny.rr.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com> <1326385635.7642.89.camel@gandalf.stny.rr.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 08:51:38 -0800
X-Google-Sender-Auth: Y14h8qJQ5rKZS7kKLjc2KqhQI_k
Message-ID: <CAObL_7GU2rw9v0gU1sQ4hhunGb6HeJ1KFqU+7eX4WpG+rCUa5Q@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 8:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-01-12 at 08:14 -0800, Andrew Lutomirski wrote:
>
>> The longer I linger on lists and see neat ideas like this, the more I
>> get annoyed that execve is magical.  I dream of a distribution that
>> doesn't use setuid, file capabilities, selinux transitions on exec, or
>> any other privilege changes on exec *at all*.
>
> Is that the fear with filtering on execv? That if we have filters on an
> execv calling a setuid program that we change the behavior of that
> privileged program and might cause unexpected results?

Exactly.

>
> In that case, just have execv fail if filtering is enabled and we are
> execing a setuid program. But I don't see why non "magical" execv's
> should be prohibited.
>

How do you define "non-magical"?

If setuid is set, then it's obviously magical.  On a nosuid
filesystem, strange things happen.  If file capabilities are enabled
and set, then different magic happens.  With LSMs involved, anything
can be magical.  (SELinux AFAICT looks up rules on every single exec,
so it might be impossible for execve to be non-magical.)  If execve is
banned entirely when seccomp is enabled, then there will never be any
attacks based on abusing these mechanisms.

My proposal is to have an alternative mechanism that, from a security
POV, does nothing that the caller couldn't have done on its own.  The
only reason it would be needed at all is because implementing execve
with correct semantics from userspace is a PITA -- the right set of
fds needs to be closed, threads need to be killed (without races),
vmas need to be found an unmapped, a new program needs to be mapped in
(possibly at the same place that the old one was mapped at),
/proc/self/exe needs to be updated, auxv needs to be recreated
(including using values that glibc might have erased already), etc.

The code is short and it works (although I have no idea whether it
applies to current kernels).

Oleg: my only issue with setting something like LSM_UNSAFE_SECCOMP is
that a different class of vulnerability might be introduced: take a
setuid program that calls other setuid programs (or just uses execve
as a way to get the default execve capability handling, SELinux
handling, etc), run it (as root!) inside seccomp, and watch it
possibly develop security holes.  If the alternate execve is a
different syscall, then this can't happen.  And if someone remaps
execve to execve_nosecurity (from userspace or via some in-kernel
mechanism) and causes problems, it's entirely clear who to blame.

--Andy
