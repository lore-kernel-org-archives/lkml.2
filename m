Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1BIULX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:11:23 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49444 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1BIULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:11:20 -0500
Date: Wed, 9 Feb 2011 15:11:08 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Ian Lance Taylor <iant@google.com>
Cc: Martin Capitanio <m@capitanio.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Russ Cox <rsc@golang.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
Subject: Re: [golang-dev] Re: mmap, the language go, problems with the
 linux kernel
Message-ID: <20110209201108.GI9533@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ian Lance Taylor <iant@google.com>,
	Martin Capitanio <m@capitanio.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	golang-dev <golang-dev@googlegroups.com>, Russ Cox <rsc@golang.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Albert Strasheim <fullung@gmail.com>
References: <1297168678.2190.21.camel@marvin>
 <AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
 <1297269019.4888.91.camel@marvin>
 <20110209191755.GE9533@thunk.org>
 <mcrei7hnfs2.fsf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mcrei7hnfs2.fsf@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:56:13AM -0800, Ian Lance Taylor wrote:
> 
> However, I think it's still worth pointing out that while ulimit -v no
> doubt has specialized applications, it does not do exactly what I think
> most people want.  I think most people want some way to say "do not let
> this program cause my machine to start thrashing."  That's what I use
> ulimit -v for; if I don't, a program which accidentally allocates memory
> in an endless loop starts thrashing.  But I don't actually care how much
> virtual memory the program is using; what I care about is limiting the
> amount of physical memory it is using, so that it doesn't take over my
> machine.

Agreed, I don't think ulimit -v is particularly useful for much of
anything, especially in these days of 64-bit systems where we have
gobs and gobs of address space.

If the performance hit isn't that horrible, making Linux enforce
RLIMIT_RSS is probably the right answer for the "do not let this
program cause my machine to start thrashing".  But even that doesn't
help if you have some pesky program that fires up large number of
processes, like, say, Chrome.  :-)

So it's not a per-process limit that we really want; instead, what we
want to do is put a program like Chrome into its own container group,
and then use memcg to constrain how much memory all of the processes
in that container group is allowed to use.  And we can also use that
same abstraction to control how much scheduler and I/O bandwidth
programs in that container are allowed to use as well.

> I think that would be a useful feature to implement regardless of how we
> feel about ulimit -v and Go.  I think we can reasonably expect more and
> more programs to try to advantage of large virtual address spaces.  Lets
> have a way to use them while still having a way to keep them from
> thrashing.

I think we do have a way of doing that.  The kernel side support for
that is there, and a number of companies are using that to keep
programs from using too much physical memory.  What's missing is the
userspace tools to make the right thing happen automatically when you
double click on an "Open Office" or "Chrome" icon on your desktop.

       	     	   	 	    	     - Ted
