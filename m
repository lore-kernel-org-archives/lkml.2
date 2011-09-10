Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab1IJLkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 07:40:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab1IJLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 07:40:20 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pedro Alves <pedro@codesourcery.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Sat, 10 Sep 2011 13:40:16 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109092203.10062.vda.linux@googlemail.com> <201109101219.30942.pedro@codesourcery.com>
In-Reply-To: <201109101219.30942.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109101340.16506.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 13:19, Pedro Alves wrote:
> On Friday 09 September 2011 21:03:10, Denys Vlasenko wrote:
> > execve is such a rare syscall the one extra stop on it is not
> > going to be a problem.
> > 
> > > And about not needing to handle the magic unadorned SIGTRAP.
> > > The magic unadorned post-exec SIGTRAP does not have `status & 0xff00'
> > > set, it is not a ptrace event!
> > 
> > What SIGTRAP? With PTRACE_O_TRACEEXEC, there is no SIGTRAP.
> 
> But _without_ PTRACE_O_TRACEEXEC there is.  You've raised its
> existence as justification for needing to be able to set
> options directly on PTRACE_SEIZE.

It was an example. There may be other options with similar
problem of "we want to enable new behavior ASAP, without
waiting fro the first ptrace-stop".

> Point is, if we don't get rid 
> of the SIGTRAP when PTRACE_O_TRACEEXEC is _not_ in effect, then
> _everyone_ will always pass PTRACE_O_TRACEEXEC to SEIZE.

Yes, that's the nature of many options: they are fixing
ptrace quirks, and therefore newer programs which know about
these options will _always_ use them. For example, should we
also unconditionally enable PTRACE_O_TRACESYSGOOD?



> > > If we don't disable the magic SIGTRAP, there's no way for a
> > > tracer to do a very non-invasive SEIZE, say, a GDB mode that
> > > only cares to let the tracer run free to catch SIGSEGVs
> > > in some child, while later on during the run, the user remembers
> > > to set a breakpoint.  At that point the tracer needs to catch
> > > exec events, so it'd enable TRACE_O_EVENTEXEC.  Getting rid of
> > > the SIGTRAP gets rid of the spurious stops when TRACE_O_EVENTEXEC
> > > is not enabled.
> > 
> > This part I don't understand.
> 
> Say, you run the whole of gcc's testsuite under gdb, and
> let it run until one of the children SIGSEGVs.  You do "gdb make; run".
> Currently, all the children stop momentarily for fork/vfork/exec,
> which slows down the run significantly (there are thousands of
> forks/execs).

I doubt about "significantly". fork and exec are heavy syscalls
(they trash entire L1 data cache on today's CPUs), a ptrace stop
on top of that is perhaps 10% slowdown _of the syscall_,
about a few % slowdown overall.


> We should be able to only SEIZE the shell that runs 
> "make" (gdb runs the child through the shell, like "sh -c make"),
> and let all its children run free, the least invasive way possible.

True.

> When a SIGSEGV happens, gdb can sync up about the process that crashed
> from /proc.

It doesn't need to do even that - but probably will, gdb code is said
to be quite complex. I think current code will require auto-attach stops
in forked children anyway (for parent-child accounting and such),
and it will require a serious rewrite to get rid of that requirement.

-- 
vda
