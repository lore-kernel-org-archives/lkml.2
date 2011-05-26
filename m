Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1EZP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:28:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59554 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab1EZP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dB8GqNFAHM1KyXwrPNavDknC7mkJDAAUzwwh8UQYEQyjI9tY3LBR9tkRsqiXezDI+V
         GKkbCXbyfAAoyaeVv1U72bcw1dESLDrJrf911rWOObfswm5J2uUSpt4L6tQLE9rOz7oR
         PQk/S8tlMlqDFqbMn5zX5PRXoS+F08gj2TboI=
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
Date: Thu, 26 May 2011 11:28:41 -0400
X-Google-Sender-Auth: BJq97JrQj1g6GxH5Uia4trhA5Kg
Message-ID: <BANLkTi=jK3oqUQgTREh=fE+9+=EWwM19vA@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 26, 2011 at 7:37 AM, Colin Walters <walters@verbum.org> wrote:
>>
>> I'm curious which features you feel are esoteric and cool but unused?
>
> Just about anything linux-specific. Ranging from the totally new
> concepts (epoll/clone/splice/signalfd) to just simple cleanups and
> extensions of reasonably standard stuff (sync_file_range/sendpage).

epoll's very widely used via frameworks I'd say; at least the Apache
runtime uses it, libevent does, and apparently the Sun JDK does:
http://www.google.com/codesearch/p?hl=en#ih5hvYJNSIA/src/solaris/classes/sun/nio/ch/EPollPort.java&q=epoll&sa=N&cd=32&ct=rc
And here's an entry on that: http://blogs.oracle.com/alanb/entry/epoll

(Why doesn't glib?  It's hard since the priority design was kind of a
mistake: https://bugzilla.gnome.org/show_bug.cgi?id=156048 )

> The "it can be used in standard libraries" ends up being a very
> powerful thing. It doesn't have to be libc - if something like a glib
> or a big graphical interface uses them, they can get very popular.

Right, that's the distinction I was trying to make.

> But
> if you have to have actual config options (autoconf or similar) to
> enable the feature on Linux, along with a compatibility case (because
> older kernels don't even support it, so it's not even "linux", it's
> "linux newer than xyz"), then very very few applications end up using
> it.

>From my experience as a framework developer, it hasn't been hard at
all to keep track of new Linux features, we talk about them a lot =)
The fallback code is often obvious, like for splice(), though for
signalfd it's going to much more messy to keep around the legacy
helper thread case.

> Unlikely? Hell no. That's standard practice. And if you allow filter
> setup that survives fork+exec, you just opened a HUGE security hole.

Oh definitely, setuid and process inheritance has been a source of
many problems over the years, and I agree it'd be very dangerous for
the syscall filters to stay open across execve.  Of course in practice
glibc secure mode exists to mitigate these things too; it could abort
if one was in place in that case.

But I was more curious about your views on Linux-specific interfaces,
and you answered that; thanks!
