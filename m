Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab1D2QNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:13:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1D2QNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110429131845.GA1768@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-4-git-send-email-wad@chromium.org>
	<20110428070636.GC952@elte.hu>
	<1304002571.2101.38.camel@localhost.localdomain>
	<BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	<20110429131845.GA1768@nowhere>
Date: Fri, 29 Apr 2011 11:13:44 -0500
Message-ID: <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Apr 28, 2011 at 01:37:33PM -0500, Will Drewry wrote:
>> On Thu, Apr 28, 2011 at 9:56 AM, Eric Paris <eparis@redhat.com> wrote:
>> > On Thu, 2011-04-28 at 09:06 +0200, Ingo Molnar wrote:
>> >> * Will Drewry <wad@chromium.org> wrote:
>> >>
>> >> > +A collection of filters may be supplied via prctl, and the current set of
>> >> > +filters is exposed in /proc/<pid>/seccomp_filter.
>> >> > +
>> >> > +For instance,
>> >> > +  const char filters[] =
>> >> > +    "sys_read: (fd == 1) || (fd == 2)\n"
>> >> > +    "sys_write: (fd == 0)\n"
>> >> > +    "sys_exit: 1\n"
>> >> > +    "sys_exit_group: 1\n"
>> >> > +    "on_next_syscall: 1";
>> >> > +  prctl(PR_SET_SECCOMP, 2, filters);
>> >> > +
>> >> > +This will setup system call filters for read, write, and exit where reading can
>> >> > +be done only from fds 1 and 2 and writing to fd 0.  The "on_next_syscall" directive tells
>> >> > +seccomp to not enforce the ruleset until after the next system call is run.  This allows
>> >> > +for launchers to apply system call filters to a binary before executing it.
>> >> > +
>> >> > +Once enabled, the access may only be reduced.  For example, a set of filters may be:
>> >> > +
>> >> > +  sys_read: 1
>> >> > +  sys_write: 1
>> >> > +  sys_mmap: 1
>> >> > +  sys_prctl: 1
>> >> > +
>> >> > +Then it may call the following to drop mmap access:
>> >> > +  prctl(PR_SET_SECCOMP, 2, "sys_mmap: 0");
>> >>
>> >> Ok, color me thoroughly impressed
>> >
>> > Me too!
>> >
>> >> I've Cc:-ed Linus and Andrew: are you guys opposed to such flexible, dynamic
>> >> filters conceptually? I think we should really think hard about the actual ABI
>> >> as this could easily spread to more applications than Chrome/Chromium.
>>
>> Would it make sense to start, as Frederic has pointed out, by using
>> the existing ABI - system call numbers - and not system call names?
>> We could leave name resolution to userspace as it is for all other
>> system call consumers now.  It might leave the interface for this
>> support looking more like:
>>   prctl(PR_SET_SECCOMP, 2, _NR_mmap, "fd == 1");
>>   prctl(PR_SET_SECCOMP_FILTER_APPLY, now|on_exec);
>
> PR_SET_SECCOMP_FILTER_APPLY seems only useful if you think there
> are other cases than enable_on_exec that would be useful for these
> filters.
>
> We can think about a default enable on exec behaviour as Steve pointed
> out.
>
> But I have no idea if other cases may be desirable to apply these
> filters.

I nearly have all of the changes in, but I'm still updating my tests.
In general, I think having both on_exec and now is reasonable is
because you can write a much tighter filter set if it is embedded in
the application.  E.g., it may load all its shared libraries, which
you allow, then lock itself down before touching untrusted content.
That said, if the default behavior is enable_on_exec, then you'd only
call PR_SET_SECCOMP_FILTER_APPLY when you want to apply _now_.  I like
that.

That said, I have a general interface question :)  Right now I have:
prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_ADD, syscall_nr, filter_string);
prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, syscall_nr,
filter_string_or_NULL);
prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_APPLY, apply_flags);
  (I will change this to default to apply_on_exec and let FILTER_APPLY
make it apply _now_ exclusively. :)

This can easily be mapped to:
prctl(PR_SET_SECCOMP
       PR_SET_SECOMP_FILTER_ADD
       PR_SET_SECOMP_FILTER_DROP
       PR_SET_SECOMP_FILTER_APPLY
if that'd be preferable (to keep it all in the prctl.h world).

Following along the suggestion of reducing custom parsing, it seemed
to make a lot of sense to make add and drop actions very explicit.
There is no guesswork so a system call filtered process will only be
able to perform DROP operations (if prctl is allowed) to reduce the
allowed system calls.  This also allows more fine grained flexibility
in addition to the in-kernel complexity reduction.  E.g.,
Process starts with
  __NR_read, "fd == 1"
  __NR_read, "fd == 2"
later it can call:
  prctl(PR_SET_SECCOMP, 2, SECCOMP_FILTER_DROP, __NR_read, "fd == 2");
to drop one of the filters without disabling "fd == 1" reading.  (Or
it could pass in NULL to drop all filters).

FWIW, I also am updating the Kconfig to be dependent EXPERIMENTAL, as
it might make sense to get some use prior to considering it finalized
:)  I'm not sure if that is appropriate though.

Thanks! I'll try to post the v2s today once they're working properly :)
will
