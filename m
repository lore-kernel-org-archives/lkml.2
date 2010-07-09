Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0GIUxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:53:22 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45667 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0GIUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:53:21 -0400
Date: Fri, 9 Jul 2010 22:53:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to
	syscall metadata declarations
Message-ID: <20100709205319.GA13941@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> <20100709203301.GA13839@merkur.ravnborg.org> <1278708374.1537.161.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278708374.1537.161.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 04:46:14PM -0400, Steven Rostedt wrote:
> On Fri, 2010-07-09 at 22:33 +0200, Sam Ravnborg wrote:
> > On Fri, Jul 09, 2010 at 03:56:42PM -0400, Steven Rostedt wrote:
> 
> > This looks like a fix that just hide the real bug.
> > If I remember the original report correct the problem is
> > that the symbol:
> > 
> >     __start_syscalls_metadata
> > 
> > Does not point to a valid syscall entry.
> > 
> > The symbol is assigned in vmlinux.lds.h like this:
> > #define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
> >                          *(__syscalls_metadata)                         \
> >                          VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
> > 
> > Now consider what is happening if we have the following scanario:
> > 
> > . equals 0x1004 so __start_syscalls_metadata is set to 0x1004
> > But __syscall_metadata require 8 byte alignment so it starts at 0x1008.
> 
> 
> I did not know that the linker could start a section at a half a word
> size. That seems to me to be a linker bug.

In this case the linker does not start a section - we are in the
middle of an output section.

   *(__syscalls_metadata)

Is only used to tell the linker that it shall include the content
of the "__syscalls_metadata" input section in the current output section.

So what we have here is something like this:

.data : AT(ADDR(.data) - LOAD_OFFSET) {
	*(_ftrace_events)
	__start_syscalls_metadata = .;
	*(__syscalls_metadata)
}

.data is the outpud section - and the linker will align the output section
to the biggest alignmnet it see within the referenced input sections.

But in this case we have no control of the value of "." (current address)
when we have processed (_ftrace_events) so it may even be at a 2 byte boundary.
The linker will add padding as needed to satisfy the alignmnet of
__syscalls_metadata - but that padding will be inbetween "." and the first
member in __syscalls_metadata.

	Sam
