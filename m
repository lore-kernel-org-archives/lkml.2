Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1BITSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:18:03 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:57335 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1BITSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:18:01 -0500
Date: Wed, 9 Feb 2011 14:17:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Capitanio <m@capitanio.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Russ Cox <rsc@golang.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
Subject: Re: mmap, the language go, problems with the linux kernel
Message-ID: <20110209191755.GE9533@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Capitanio <m@capitanio.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	golang-dev <golang-dev@googlegroups.com>, Russ Cox <rsc@golang.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Albert Strasheim <fullung@gmail.com>
References: <1297168678.2190.21.camel@marvin>
 <AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
 <1297269019.4888.91.camel@marvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297269019.4888.91.camel@marvin>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 05:30:19PM +0100, Martin Capitanio wrote:
> So, I hope I managed now to put all the involved on the cc list. Here
> are the relevant responses I've got from the other ml. I think
> there is still a confusion what the mmap syscall actually should
> do in the case of PROT_NONE (Data cannot be accessed)
> http://pubs.opengroup.org/onlinepubs/009695399/functions/mmap.html

Actually, I don't think the confusion has anything to do with
PROT_NONE.  The Go designers have themselves said that their intent
was to reserve the virtual address space.  So that much is clear.

The real quesiton is what does RLIMIT_AS and ulimit -v supposed to
*do*.  The Single Unix Specification (and POSIX, which is where this
comes from), is quite vague: "the maximum size of a process's total
available memory, in bytes".  What in the world is "total available
memory"?!?  BSD also has RLIMIT_RSS, which was not adopted by Posix
(not surprising, given that in the early days it was dominated by
System V folks).

AIX and the BSD's don't implement RLIMIT_AS at all.  Solaris does, but
the man page just says "total available memory", again without
specifying what that means.  Solaris also has a RLIMIT_VMEM, which is
the total amount of virtual address space, so apparently Solaris seems
to think that RLIMIT_VMEM and RLIMIT_AS are different things.

Linux has interpreted RLIMIT_AS to mean total amount of virtual
address space for a long, long time.  (The interpretation AS ==
"address space" does make sense, although it's not clear that's what
the original definition of RLIMIT_AS was supposed to mean.)  Linux
also has a RLIMIT_RSS, probably taken from BSD, which is not
implemented (although if you are using memory cgroups, you can
effectively get the same result as limiting a process's RSS, although
via different API).

Bash has definied rlimit -v to mean "total amount of virtual memory"
and implements it via RLIMIT_AS, so it's pretty clear that its intent
was that rlimit -v is supposed to mean "virtual address space".  (Or
maybe it was documented that way and the letter 'v' chosen because
that's what RLIMIT_AS has meant on Linux for a long time.)

The bottom line is that so long as Go's memory management system is
intending to reserve virtual address space, there is no real conflict
in the question of what PROT_NONE means.  Both Linux and Go intend it
to mean, "reserve address space".  The better line of argumentation
from the Go perspective is that RLIMIT_AS shouldn't mean restricting
the virtual address space, but "something else".  But that would mean
changing Linux's behavior, which has been established for many, many
years.  And arguably the specification is vague at best.  (What does
"available memory" mean, anyway?  Does it mean physical memory?
physical memory plus whatever swap space happens to be available?
Does VM overcommit be taken into account --- what if every single page
in every single copy of the 'ftpd' binary gets attached by a debugger
and modified?)

Linux has interpreted it to mean "virtual address space", and in fact
it's documented as such in the its version of the getrlimit man page.
I'd have to agree with Linus that it's probably way too late to change
what it means (or what Linux thinks it means, anyway).

In any case, it's deployed on so many machines that any change would
take years to roll out anyway.  What I'd probably recommend to Go
developers is to check the value of RLIMIT_AS via getrlimit(), and if
it's too small for what you want, print a human-readable error or
warning message telling the user to limit the RLIMIT_AS, and then
either stop, or use some alternate allocation strategy.

       	     	    	 	   	      - Ted
