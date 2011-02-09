Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1BIQag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:30:36 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:26755 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1BIQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:30:35 -0500
X-RZG-AUTH: :O2kGeEG7b/pS1E64W3aniLTNDUcEh+JwjGMyQkjVygg3aAH02IubSkmAm8qJPKJ6clJS
X-RZG-CLASS-ID: mo00
Subject: Re: mmap, the language go, problems with the linux kernel
From: Martin Capitanio <m@capitanio.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Russ Cox <rsc@golang.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
In-Reply-To: <AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
References: <1297168678.2190.21.camel@marvin>
	 <AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 17:30:19 +0100
Message-ID: <1297269019.4888.91.camel@marvin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 08:23 -0800, Linus Torvalds wrote:
> On Tue, Feb 8, 2011 at 4:37 AM, martin capitanio <m@capitanio.org> wrote:
> >
> > There popped up a serious problem by implementing a fast memory
> > management for the language go. Maybe some experienced kernel hacker
> > could join the discussion and help to find the best linux solution for
> > the "mmap fiasco" problem.
> >
> > https://groups.google.com/forum/#!msg/golang-dev/EpUlHQXWykg/LN2o9fV6R3wJ
> 
...
> And quite frankly, I think your "use a big array" in go is a mistake.
> You may think it's clever and simple, and that "hey, the OS won't
> allocate pages we don't touch", but it's still a serious mistake. And
> it's not a mistake because of RLIMIT_AS - that's just a secondary or
> tertiary symptom of you being lazy and not doing the right thing.
...

So, I hope I managed now to put all the involved on the cc list. Here
are the relevant responses I've got from the other ml. I think
there is still a confusion what the mmap syscall actually should
do in the case of PROT_NONE (Data cannot be accessed)
http://pubs.opengroup.org/onlinepubs/009695399/functions/mmap.html

On Wed, 2011-02-09 at 09:57 -0500, Russ Cox wrote:
Thanks for posting the LKML response.
> Most of what Linus says is true but probably not
> crucial enough to avoid laziness for now.  We can
> always change the strategy later if it becomes a
> problem.
> 
> The comment about large pages would be the most
> important reason not to do what we're doing but sounds
> more like a kernel bug than our fault.  We're being
> very up front with the kernel about which memory we
> are and are not using: what we're not using has prot==0.
> If Linux sees a 16 GB prot==0 mapping and decides to
> dedicate >0 bytes of memory to backing it, then that's
> not our problem.
> 
> Other tools like Native Client use enormous prot==0
> mappings.  I doubt Linux would ever make the mistake
> of giving them real amounts of physical memory.

On Tue, 2011-02-08 at 13:26 +0000, Alan Cox wrote:
...
> Linux implements virtual address space limits, and enforces them. The go
> language stuff wants to allocate huge amounts of virtual space so you
> need to tell the OS you want to allow it to do crazy stuff, which you can
> do so. But virtual address space is not free - it has to be tracked and
> if the application suddenely tries to fill all of it what will happen ?
> 
> You'll hit problems if the kernel is running with vm overcommit disabled
> (as well configured servers do),
> 
> There are of course ways and means - you can provide your own mmap to
> override the libc one for example and manage the address space yourself -
> within limits by allocating addresses and doing the syscall giving an
> address request.
> 
> You'll be ok I suspect on Linux on x86 but there are platforms with very
> complicated aliasing rules where the OS tries very hard to map certain
> things at certain addresses to avoid cache aliasing work and big slow
> downs. There are good reasons why mmap works the way it does.
...

On Wed, 2011-02-09 at 07:26 -0800, Albert Strasheim wrote:
> I'm a bit concerned about Alan Cox's comment:
> 
> "You'll hit problems if the kernel is running with vm overcommit
> disabled (as well configured servers do)."
> 
> We are planning to do exactly that, on a server that will be running
> many, many Go processes.
> 
> But maybe virtual memory with prot==0 doesn't factor into the
> overcommit accounting?
...


