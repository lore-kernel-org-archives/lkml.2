Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2JIWzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:55:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40084 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2JIWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:55:12 -0400
Date: Tue, 9 Oct 2012 15:55:09 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121009225509.GA26835@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009224703.GT26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:47:03PM -0700, Zach Brown wrote:
> > If libaio is the only thing in userspace looking at the ringbuffer, and
> > if I'm looking at the latest libaio code this shouldn't break
> > anything...
> 
> We can't assume that libaio is the only thing in userspace using the
> mapped buffer -- as scary a thought as that is :).
> 
> If we wanted to change the behaviour of the ring we'd give userspace a
> way to indicate that it accepts the new semantics.  I'm not immediately
> sure how best to do that -- haven't given it much thought.

Well, the ringbuffer does have those compat flags and incompat flags.
Which libaio conveniently doesn't check, but for what it does it
shouldn't really matter I guess.

I figure if anyone else is using the ringbuffer directly and not
checking the flag fields... well, they deserve to have their stuff
broken :P

OTOH, that is the same situation the tracing stuff was in... but the
stuff that used the tracing fields incorrectly was more widespread.

Anyways, if we can't change the ringbuffer at all we could always create
a new version of the io_setup() syscall that gives you a new ringbuffer
format.

That'd arguably be better anyways, since if we went the incompat flags
route old code would be stuck with not being able to use the ringbuffer
at all on newer kernels. But it would be more of a pain and more kernel
code.


> > Sticking the head and tail pointers on the same cacheline is one of my
> > main complaints. If you could find that comment I'd be interested in
> > reading it, though.
> 
> Yeah, that was on my list.. Heh, found it!

Thanks!

I'm wondering what interest there is in creating a new aio interface to
solve these and other issues.

I kind of feel like as long as we've got a list of complaints, we should
prototype something in one place that fixes all our complaints... think
of it as documenting all the known issues, if nothing else.

> 
> /*
> * This structure defines the head of a ring of events that is mapped into user
> * space.  It isn't used anymore because it has a number of design flaws.  I'll
> * mention them here in the hopes that people read this when considering a
> * design for a ring shared between user and kernel space.
> *
> * - The head and tail pointers are in the same cacheline.  This introduces
> * false sharing between producers and consumers which could otherwise operate
> * independent of one-another, presuming that the producers know ahead of time
> * that room has been reserved for them.
> *
> * - The head and tail semantics are unconventional.  They're always less than
> * the number of events in the ring and their meaning is reversed from the
> * usual construct that one sees in, for example, ethernet hardware where the
> * ring is a power of two and the indexes wrap but are masked when used to
> * dereference elements.
> *
> * - Because of the weird head and tail semantics one can't distinguish from
> * completely empty and full rings.  To work around this the ring is actually
> * created with more events than the aio user asked for and that number is
> * accounted for separately.  The number of free elements in the ring is
> * greater than the number of operations that the kernel aio submission will
> * allow.
> *
> * - Synchronizing head and tail updates between the kernel and user space
> * requires a u32 cmpxchg.  futexes have infrastructure for this which requires
> * working with user addresses.  Trying to nicely re-use the futex code leads
> * to awkward code in aio which sometimes wants to work through kmap()
> * addresses and other times want to work through the mmaped user space
> * pointers.
> *
> * - The head and tail pointers are restricted in value to being less than the
> * number of elements in the ring.  This means that a cmpxchg can see a index
> * which has wrapped and confuse it for the index that it read before trying
> * cmpxchg.  This can end up sending a duplicated previous event instead of a
> * currently queued event in the worst case.
> *
> * - User space doesn't explicitly indicate that it wants to work with the ring
> * from user space.  Even if user space never touches the ring the kernel still
> * has pay the cost of the potential sharing with user space when inserting
> * events.
> *
> * - The kernel magically maps it into the address space.  Users can't put it
> * in whatever memory they like, like shared mem or hugetlb pages or tmpfs
> * pages that they want to sendfile out of.
> *
> * - The ring is allocated out of unswappable kernel memory.  It would be
> * better to have the ring allocated in userspace and given to the kernel.  In
> * the common case the pages will be present and the overhead is minimal and
> * complexity is kept out of the kernel.  In the worst case of memory pressure
> * the kernel has fewer pinned pages tying its hands.
> */
> 
> The submission and completion interface that I threw together for the
> acall experiments took all this into account:
> 
>  http://lwn.net/Articles/316806/
> 
> Man, this all brings back memories :).
> 
> - z
