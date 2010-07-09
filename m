Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0GIWCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:02:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34491 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0GIWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:02:54 -0400
Date: Sat, 10 Jul 2010 00:02:52 +0200
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
Message-ID: <20100709220252.GA14080@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> <20100709203301.GA13839@merkur.ravnborg.org> <1278708374.1537.161.camel@gandalf.stny.rr.com> <20100709205319.GA13941@merkur.ravnborg.org> <1278709550.1537.164.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278709550.1537.164.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 05:05:50PM -0400, Steven Rostedt wrote:
> On Fri, 2010-07-09 at 22:53 +0200, Sam Ravnborg wrote:
> 
> > But in this case we have no control of the value of "." (current address)
> > when we have processed (_ftrace_events) so it may even be at a 2 byte boundary.
> > The linker will add padding as needed to satisfy the alignmnet of
> > __syscalls_metadata - but that padding will be inbetween "." and the first
> > member in __syscalls_metadata.
> 
> Fine, but this is a separate issue. I doubt the "ALIGN(8);" would have
> helped us anyway. Remember what the issue we had:
> 
> ffffffff8173c438 <__start_syscalls_metadata>:
>         ...
> 
> ffffffff8173c440 <__syscall_meta__mmap>:
> 
> 
> __start_syscalls_metadata was already aligned to 8, but for some strange
> reason, gcc decided to align the first member to 16.

I found some more info in following bug:
https://bugzillafiles.novell.org/attachment.cgi?id=344563

Jeff Mahoney says:
GCC 4.5 introduced behavior that forces the alignment of structures to
 use the largest possible value. The default value is 32 bytes, so if
 some structures are defined with a 4-byte alignment and others aren't
 declared with an alignment constraint at all - it will align at 32-bytes.

So according to this we can rely on 32 byte alignment and
this is trivial to add in vmlinux.lds.h.

	Sam
