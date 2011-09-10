Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1IJLTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 07:19:36 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40429 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963Ab1IJLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 07:19:35 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Sat, 10 Sep 2011 12:19:30 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109091809.57272.pedro@codesourcery.com> <201109092203.10062.vda.linux@googlemail.com>
In-Reply-To: <201109092203.10062.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109101219.30942.pedro@codesourcery.com>
X-OriginalArrivalTime: 10 Sep 2011 11:19:33.0599 (UTC) FILETIME=[844336F0:01CC6FAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 21:03:10, Denys Vlasenko wrote:
> On Friday 09 September 2011 19:09, Pedro Alves wrote:

> No need to shout.

Sorry.

> execve is such a rare syscall the one extra stop on it is not
> going to be a problem.
> 
> > And about not needing to handle the magic unadorned SIGTRAP.
> > The magic unadorned post-exec SIGTRAP does not have `status & 0xff00'
> > set, it is not a ptrace event!
> 
> What SIGTRAP? With PTRACE_O_TRACEEXEC, there is no SIGTRAP.

But _without_ PTRACE_O_TRACEEXEC there is.  You've raised its
existence as justification for needing to be able to set
options directly on PTRACE_SEIZE.  Point is, if we don't get rid
of the SIGTRAP when PTRACE_O_TRACEEXEC is _not_ in effect, then
_everyone_ will always pass PTRACE_O_TRACEEXEC to SEIZE.
If that is true, you might as well make it default...  But
I'm claiming that a tracer may not want to see exec events at
all, so making it so that when you don't specify
PTRACE_O_TRACEEXEC, then you also don't get the magic SIGTRAP,
is more useful, and eliminates your justification too.  Oleg already
showed it's a super trivial patch too.  If you want to be
able to specify options directly on SEIZE, fine, I can see
that it is useful (of course gdb does the same "I still need to
set options on this child" dance as strace does).

> > If we don't disable the magic SIGTRAP, there's no way for a
> > tracer to do a very non-invasive SEIZE, say, a GDB mode that
> > only cares to let the tracer run free to catch SIGSEGVs
> > in some child, while later on during the run, the user remembers
> > to set a breakpoint.  At that point the tracer needs to catch
> > exec events, so it'd enable TRACE_O_EVENTEXEC.  Getting rid of
> > the SIGTRAP gets rid of the spurious stops when TRACE_O_EVENTEXEC
> > is not enabled.
> 
> This part I don't understand.

Say, you run the whole of gcc's testsuite under gdb, and
let it run until one of the children SIGSEGVs.  You do "gdb make; run".
Currently, all the children stop momentarily for fork/vfork/exec,
which slows down the run significantly (there are thousands of
forks/execs).  We should be able to only SEIZE the shell that runs
"make" (gdb runs the child through the shell, like "sh -c make"),
and let all its children run free, the least invasive way possible.
When a SIGSEGV happens, gdb can sync up about the process that crashed
from /proc.

We can't get rid of the magic SIGTRAP on PTRACE_ATTACH/PTRACE_TRACEME
for backwards compatibility reasons, but SEIZE is new.

> (btw, PTRACE_O_TRACEEXEC, not TRACE_O_EVENTEXEC).

Thanks.

-- 
Pedro Alves
