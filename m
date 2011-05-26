Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab1EZQdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:33:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab1EZQdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
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
Date: Thu, 26 May 2011 11:33:22 -0500
Message-ID: <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Walters <walters@verbum.org>, Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 26, 2011 at 7:37 AM, Colin Walters <walters@verbum.org> wrote:
>>
>> I'm curious which features you feel are esoteric and cool but unused?
>
> Just about anything linux-specific. Ranging from the totally new
> concepts (epoll/clone/splice/signalfd) to just simple cleanups and
> extensions of reasonably standard stuff (sync_file_range/sendpage).
>
> Sure, there's almost always *somebody* who uses them, but they are
> seldom actually worth it.
>
> The one thing that works well is when you expose it as a standard
> interface. So futexes are linux-specific, but they are exposed as the
> standard pthreads condition variables etc to apps - very few actually
> use them as futexes. But because glibc uses them for the pthreads
> synchronization, I think they ended up being used inside glibc for
> low-level stuff too, so I think futexes ended up being an unqualified
> success - much better than the standard interface.
>
> The "it can be used in standard libraries" ends up being a very
> powerful thing. It doesn't have to be libc - if something like a glib
> or a big graphical interface uses them, they can get very popular. But
> if you have to have actual config options (autoconf or similar) to
> enable the feature on Linux, along with a compatibility case (because
> older kernels don't even support it, so it's not even "linux", it's
> "linux newer than xyz"), then very very few applications end up using
> it.
>
> And security issues in particular are often *very* subtle. For
> example, something like a system call filter sounds like an obviously
> safe thing: it can only limit what you do, right?
>
> Except no, not right at all. Imagine that you're limiting a suid
> application, and the one operation you limit is "setuid()". Imagine
> that the suid application explicitly drops privileges in order to run
> safely as the user. Imagine, further, that it doesn't even check the
> return value, because it *knows* that if it is root, it will succeed,
> and if it isn't root, then it wasn't suid to begin with and doesn't
> need to do anything about it.
>
> Unlikely? Hell no. That's standard practice. And if you allow filter
> setup that survives fork+exec, you just opened a HUGE security hole.
>
> Fixable? Yes, easily. And I haven't looked at the current patches, but
> I would not be AT ALL surprised if they had exactly the above huge
> security hole.

FWIW, none of the patches deal with privilege escalation via setuid
files or file capabilities.

> My point being that (a) I'm very dubious about new non-standard
> features, because historically they seldom get used very widely and
> (b) I'm doubly dubious about security things because it turns out it's
> damn easy to get it wrong in all kinds of small subtle details.

I agree with both points, so I'm being a bit hypocritical, I suspect.

At present, I'm not aware of any platforms that support system call
restriction in a non-platform-specific fashion: mac has seatbelt,
freebsd has things like capsicum, linux has seccomp :)  This led me to
the proposal around expanding seccomp since it was already a Linux-ism
for this functionality and, ideally, could be minimal to help limit
the subtle-bug-exposure.   However, any form of kernel attack surface
reduction would be great, but I'm unaware of any that integrate with
glibc smoothly (even if some do have nicer programming interfaces).

I've used system call filtering in the past with good effect in server
environments, and I believe the Chromium renderer example is a robust
for Linux desktops, even without glibc integration.  If the
Linux-specific, non-automatic (glibc) interface is a no-go, then I'll
go back to the drawing board.  I'm not sure how to avoid something
Linux-specific in general, even if it's just adding syscall hooks to
LSMs, though it could be possible to share interfaces with some other
platform's implementation of a broader security system that includes
kernel exposure minimization (like capsicum) which could be built-on
what existing substrate is available or a new one, as Ingo proposes.

thanks!
will
