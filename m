Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1EZRiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:38:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48588 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab1EZRiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
	<BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<20110525191152.GC19633@outflux.net>
	<BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
	<BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
	<BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
	<BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
	<BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
	<BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
	<BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com>
Date: Thu, 26 May 2011 12:38:19 -0500
Message-ID: <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Walters <walters@verbum.org>, Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 26, 2011 at 10:02 AM, Will Drewry <wad@chromium.org> wrote:
>>
>> Absolutely - that was what I meant :/  The patches do not currently
>> check creds at creation or again at use, which would lead to
>> unprivileged filters being used in a privileged context.  Right now,
>> though, if setuid() is not allowed by the seccomp-filter, the process
>> will be immediately killed with do_exit(SIGKILL) on call -- thus
>> avoiding a silent failure.
>
> Umm.
>
> You do realize that there is a reason we don't allow random kill()
> system calls to succeed without privileges either?
>
> So no, "we kill it with sigkill" is not safe *either*. It now is
> potentially a way to kill privileged processes that you didn't have
> permission to kill.
>
> My point is that it all sounds designed for well-behaved processes.
> "kill it if it does something bad" sounds like a *wonderful* idea if
> you're doing a sandbox.

Yeah - we end up in a weird place, because for many suid executables,
the failure would be immediate (at priv drop), but it introduces bugs
that will be less obvious in more complex scenarios.

> But it is suddenly potentially deadly if that capability is used by a
> malicious user for a process that isn't ready for it.
>
> One option is to just not ever allow execve() from inside a restricted
> environment.

That'd certainly be fine with me.  Another option could be adding a
cred checking (from set to use) or execve time checking or ..., but
simple works for me.  I'm not hung up on the implementation details
specifically if the end result is that the syscalls can be _safely_
whitelisted.

Thanks!
