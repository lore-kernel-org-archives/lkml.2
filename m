Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2JJArw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:47:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56455 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2JJAru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:47:50 -0400
Date: Tue, 9 Oct 2012 17:47:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121010004746.GF26835@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
 <20121010002634.GX26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010002634.GX26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:26:34PM -0700, Zach Brown wrote:
> > The AIO ringbuffer stuff just annoys me more than most
> 
> Not more than everyone, though, I can personally promise you that :).
> 
> > (it wasn't until
> > the other day that I realized it was actually exported to userspace...
> > what led to figuring that out was noticing aio_context_t was a ulong,
> > and got truncated to 32 bits with a 32 bit program running on a 64 bit
> > kernel. I'd been horribly misled by the code comments and the lack of
> > documentation.) 
> 
> Yeah.  It's the userspace address of the mmaped ring.  This has annoyed
> the process migration people who can't recreate the context in a new
> kernel because there's no userspace interface to specify creation of a
> context at a specific address.

Yeah I did finally figure that out - and a file descriptor that
userspace then mmap()ed would solve that problem...

> 
> > But if we do have an explicit handle, I don't see why it shouldn't be a
> > file descriptor.
> 
> Because they're expensive to create and destroy when compared to a
> single system call.  Imagine that we're using waiting for a single
> completion to implement a cheap one-off sync call.  Imagine it's a
> buffered op which happens to hit the cache and is really quick.

True. But that could be solved with a separate interface that either
doesn't use a context to submit a call synchronously, or uses an
implicit per thread context.

> (And they're annoying to manage: libraries and O_CLOEXEC, running into
> fd/file limit tunables, bleh.)

I don't have a _strong_ opinion there, but my intuition is that we
shouldn't be creating new types of handles without a good reason. I
don't think the annoyances are for the most part particular to file
descriptors, I think the tend to be applicable to handles in general and
at least with file descriptors they're known and solved.

Also, with a file descriptor it naturally works with an epoll event
loop. (eventfd for aio is a hack).

> If the 'completion context' is no more than a structure in userspace
> memory then a lot of stuff just works.  Tasks can share it amongst
> themselves as they see fit.  A trivial one-off sync call can just dump
> it on the stack and point to it.  It doesn't have to be specifically
> torn down on task exit.

That would be awesome, though for it to be worthwhile there couldn't be
any kernel notion of a context at all and I'm not sure if that's
practical. But the idea hadn't occured to me before and I'm sure you've
thought about it more than I have... hrm.

Oh hey, that's what acall does :P

For completions though you really want the ringbuffer pinned... what do
you do about that?

> > > And perhaps obviously, I'd start with the acall stuff :).  It was a lot
> > > lighter.  We could talk about how to make it extensible without going
> > > all the way to the generic packed variable size duplicating or not and
> > > returning or not or.. attributes :).
> > 
> > Link? I haven't heard of acall before.
> 
> I linked to it after that giant silly comment earlier in the thread,
> here it is again:
> 
>   http://lwn.net/Articles/316806/

Oh whoops, hadn't started reading yet - looking at it now :)

> There's a mostly embarassing video of a jetlagged me giving that talk at
> LCA kicking around.. ah, here:
> 
>  http://mirror.linux.org.au/pub/linux.conf.au/2009/Thursday/131.ogg
> 
> - z
