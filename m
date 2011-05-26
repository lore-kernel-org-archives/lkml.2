Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1EZPEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757579Ab1EZPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 08:03:21 -0700
Message-ID: <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: Colin Walters <walters@verbum.org>
Cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 7:37 AM, Colin Walters <walters@verbum.org> wrote:
>
> I'm curious which features you feel are esoteric and cool but unused?

Just about anything linux-specific. Ranging from the totally new
concepts (epoll/clone/splice/signalfd) to just simple cleanups and
extensions of reasonably standard stuff (sync_file_range/sendpage).

Sure, there's almost always *somebody* who uses them, but they are
seldom actually worth it.

The one thing that works well is when you expose it as a standard
interface. So futexes are linux-specific, but they are exposed as the
standard pthreads condition variables etc to apps - very few actually
use them as futexes. But because glibc uses them for the pthreads
synchronization, I think they ended up being used inside glibc for
low-level stuff too, so I think futexes ended up being an unqualified
success - much better than the standard interface.

The "it can be used in standard libraries" ends up being a very
powerful thing. It doesn't have to be libc - if something like a glib
or a big graphical interface uses them, they can get very popular. But
if you have to have actual config options (autoconf or similar) to
enable the feature on Linux, along with a compatibility case (because
older kernels don't even support it, so it's not even "linux", it's
"linux newer than xyz"), then very very few applications end up using
it.

And security issues in particular are often *very* subtle. For
example, something like a system call filter sounds like an obviously
safe thing: it can only limit what you do, right?

Except no, not right at all. Imagine that you're limiting a suid
application, and the one operation you limit is "setuid()". Imagine
that the suid application explicitly drops privileges in order to run
safely as the user. Imagine, further, that it doesn't even check the
return value, because it *knows* that if it is root, it will succeed,
and if it isn't root, then it wasn't suid to begin with and doesn't
need to do anything about it.

Unlikely? Hell no. That's standard practice. And if you allow filter
setup that survives fork+exec, you just opened a HUGE security hole.

Fixable? Yes, easily. And I haven't looked at the current patches, but
I would not be AT ALL surprised if they had exactly the above huge
security hole.

My point being that (a) I'm very dubious about new non-standard
features, because historically they seldom get used very widely and
(b) I'm doubly dubious about security things because it turns out it's
damn easy to get it wrong in all kinds of small subtle details.

                            Linus
