Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab1IJMMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 08:12:44 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:42588 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab1IJMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 08:12:43 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Sat, 10 Sep 2011 13:12:38 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109101219.30942.pedro@codesourcery.com> <201109101340.16506.vda.linux@googlemail.com>
In-Reply-To: <201109101340.16506.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109101312.39256.pedro@codesourcery.com>
X-OriginalArrivalTime: 10 Sep 2011 12:12:42.0133 (UTC) FILETIME=[F0C6E450:01CC6FB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 12:40:16, Denys Vlasenko wrote:
> On Saturday 10 September 2011 13:19, Pedro Alves wrote:
> > On Friday 09 September 2011 21:03:10, Denys Vlasenko wrote:
> > > execve is such a rare syscall the one extra stop on it is not
> > > going to be a problem.
> > > 
> > > > And about not needing to handle the magic unadorned SIGTRAP.
> > > > The magic unadorned post-exec SIGTRAP does not have `status & 0xff00'
> > > > set, it is not a ptrace event!
> > > 
> > > What SIGTRAP? With PTRACE_O_TRACEEXEC, there is no SIGTRAP.
> > 
> > But _without_ PTRACE_O_TRACEEXEC there is.  You've raised its
> > existence as justification for needing to be able to set
> > options directly on PTRACE_SEIZE.
> 
> It was an example. There may be other options with similar
> problem of "we want to enable new behavior ASAP, without
> waiting fro the first ptrace-stop".

As I said, there may be other examples, and I can see that
options-on-SEIZE is useful (it even makes the tracer less invasive,
as it doesn't force an interrup/stop for setting options), but as
I have been saying, that particular example IMO should be fixed
some other way.

(just-options-on-SEIZE scares me in terms of future expansion,
as it assumes only bitflags will ever be necessary.)

> > Point is, if we don't get rid 
> > of the SIGTRAP when PTRACE_O_TRACEEXEC is _not_ in effect, then
> > _everyone_ will always pass PTRACE_O_TRACEEXEC to SEIZE.
> 
> Yes, that's the nature of many options: they are fixing
> ptrace quirks, and therefore newer programs which know about
> these options will _always_ use them. 

I think it's better to work on a case by case basis, and not
claim all of them fix quirks.  In my mind, there are clearly different
sets of ptrace options.  PTRACE_O_TRACECLONE|FORK|VFORK|EXEC
forces _extra_ stops in the tracees that would not happen
if the tracee wasn't being traced in the first place (ignore the
magic exec SIGTRAP).

> For example, should we
> also unconditionally enable PTRACE_O_TRACESYSGOOD?

PTRACE_O_TRACESYSGOOD changes only the status reported by wait
on syscalls.  To get a syscall stop/SIGTRAP, you need to use
PTRACE_SYSCALL in the first place, and you can only do that
when the tracee is already ptrace stopped.  At that point, you
can just do PTRACE_O_TRACESYSGOOD yourself.  Nothing is seriously
lost if we don't enable it by default.  But it's fine with me
to enable it by default.

> I doubt about "significantly". fork and exec are heavy syscalls
> (they trash entire L1 data cache on today's CPUs), a ptrace stop
> on top of that is perhaps 10% slowdown _of the syscall_,
> about a few % slowdown overall.

There's the userland rountrip and context switches you get away
without.  With RT in the picture, it may be super important -- who
knows.

It's super easy to do it right.  IMO, let's just do it.

> > When a SIGSEGV happens, gdb can sync up about the process that crashed
> > from /proc.
> 
> It doesn't need to do even that - but probably will, gdb code is said
> to be quite complex. 

I happen to know gdb's code quite well.  ;-)

> and it will require a serious rewrite to get rid of that requirement.

Maybe, and it'd need a couple extra ptrace features (e.g., like being able
to make the tracer not see stops for signals it is not interested in.
Red Hat discussed some of those desirable ptrace features for making
gdb less invasive on the archer@ list a while ago.) but I'm
claiming it's better to leave the door open.

-- 
Pedro Alves
