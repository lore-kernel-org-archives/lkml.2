Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0GIV4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:56:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53426 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0GIV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:56:04 -0400
Date: Fri, 9 Jul 2010 23:56:01 +0200
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
Message-ID: <20100709215601.GA13985@merkur.ravnborg.org>
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
> Fine, but this is a separate issue.
No - this is the exact issue we are facing here.

In the linker script we have no control what-so-ever on the alignment of "."
so relying on any alignment is a potential bug.

In this particular case gcc decide to increase the alignment of
syscall_metadata from 8 to 16.

And then suddenly things fall apart because we rely on "." being
properly aligned - and it is only 4 byte aligned.

So you fixed this by forcing gcc to use a smaller alignment
for syscall_metadata (from 16 => 4).
But what happens next time when "." is two-byte aligned?
We will not change aligment down to 2...

So to fix this properly we need to make sure that "." is properly
aligned to the alignment of syscall_metadata.

In other words - the linker script needs to be fixed too.
But the fix in the .h file is required so we know the alignmnet
of syscall_metadata.

	Sam
