Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1EZSIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:08:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39526 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1EZSIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <17077.1306431502@turing-police.cc.vt.edu>
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
	<17077.1306431502@turing-police.cc.vt.edu>
Date: Thu, 26 May 2011 13:08:10 -0500
Message-ID: <BANLkTimhcqSyQjwbXTn00Huu_5++3MczDw@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:38 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 26 May 2011 12:02:45 CDT, Will Drewry said:
>
>> Absolutely - that was what I meant :/  The patches do not currently
>> check creds at creation or again at use, which would lead to
>> unprivileged filters being used in a privileged context.  Right now,
>> though, if setuid() is not allowed by the seccomp-filter, the process
>> will be immediately killed with do_exit(SIGKILL) on call -- thus
>> avoiding a silent failure.
>
> How do you know you have the bounding set correct?
>
> This has been a long-standing issue for SELinux policy writing - it's usually
> easy to get 95% of the bounding box right (you need these rules for shared
> libraries, you need these rules to access the user's home directory, you need
> these other rules to talk TCP to the net, etc).  There's a nice tool that
> converts any remaining rejection messages into rules you can add to the policy.
>
> The problem is twofold: (a) that way you can never be sure you got *all* the
> rules right and (b) the missing rules are almost always in squirrelly little
> error-handling code that gets invoked once in a blue moon.  So in this case,
> you end up with trying to debug the SIGKILL that happened when the process was
> already in trouble for some other reason...
>
> "Wow. Who would have guessed that program only called gettimeofday() in
> the error handler for when it was formatting its crash message?"
>
> Exactly.

Depending on the need, there is work involved, and there are many ways
to determine your bounding box.  It can be very tight -- where you
analyze normal workloads (perf,strace,objdump) and accept the fact
that pathological workloads may result in process death -- or it can
be quite loose and enable most system calls, just not newer ones,
let's say.  In practice, you might get bit a few times if you're
overly zealous (I know I have), but it's the difference between
failing open and failing closed.  There are some scenarios where you
never, ever want to fail-open even at the cost of process death and
lack of solid insight into a valid failure path.

Hope that makes sense and isn't too general,
will
