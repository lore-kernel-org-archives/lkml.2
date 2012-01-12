Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2ALWSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:18:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38007 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2ALWSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:18:48 -0500
MIME-Version: 1.0
In-Reply-To: <1326390006.7642.114.camel@gandalf.stny.rr.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<1326383015.7642.77.camel@gandalf.stny.rr.com>
	<20120112161418.GA22360@redhat.com>
	<1326386324.7642.96.camel@gandalf.stny.rr.com>
	<20120112173048.GK7180@jl-vm1.vm.bytemark.co.uk>
	<1326390006.7642.114.camel@gandalf.stny.rr.com>
Date: Thu, 12 Jan 2012 16:18:46 -0600
Message-ID: <CABqD9hY+2qJEGqGxO89m6iKK9+oe0q8rHEtOP6w0DKrwpNB90Q@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-01-12 at 17:30 +0000, Jamie Lokier wrote:
>
>> You can do this now, using ptrace().  It's horrible, but half of the
>> horribleness is needing to understand machine-dependent registers,
>> which this new patch doesn't address.  (The other half is a ton of
>> undocumented but important ptrace() behaviours on Linux.)
>
> Yeah I know the horrid use of ptrace, I've implemented programs that use
> it :-p
>
> I guess ptrace can capture the execv and determine if it is OK or not to
> run it. But again, this doesn't stop the possible attacks that could
> happen, with having the execv on a symlink file, having the ptrace check
> say its OK, and then switching the symlink to a setuid file.
>
> When the new execv executed, the parent process would lose all control
> over it. The idea is to prevent this.
>
> I like Alan's suggestion. Have userspace decide to allow execv or not,
> and even let it decide if it should allow setuid execv's or not, but
> still allow non-setuid execvs. If you allow the setuid execv, once that
> happens, the same behavior will occur as with ptrace. A setuid execv
> will lose all its filtering.

In the ptrace case, doesn't it just downgrade the privileges of the new process
if there is a tracer, rather than detach the tracer?

Ignoring that, I've been looking at system call filters as being equivalent to
something like the caps bounding set.  Once reduced, there's no going
back. I think Linus's proposal perfectly resolves the policy decision around
suid execution behavior in the run-with-privs or not scenarios (just like with
how ptrace does it).  However, I'd like to avoid allowing any process to
escape system call filters once installed.  (It's doable to add
suid/caps-based-bypass, but it certainly not ideal from my perspective.)

cheers,
will
