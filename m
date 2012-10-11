Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab2JKCmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:42:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65304 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab2JKCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:42:29 -0400
Date: Wed, 10 Oct 2012 19:41:53 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Zach Brown <zab@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121011024152.GD24174@moria.home.lan>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
 <20121010110356.GA11468@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010110356.GA11468@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 07:03:56AM -0400, Theodore Ts'o wrote:
> On Tue, Oct 09, 2012 at 02:37:00PM -0700, Kent Overstreet wrote:
> > > Honestly: I wouldn't bother.  Nothing of consequence uses cancel.
> > > 
> > > I have an RFC patch series that tears it out.  Let me polish that up
> > > send it out, I'll cc: you.
> > 
> > Even better :)
> > 
> > I've been looking at aio locking the past few days, and I was getting
> > ready to write something up about cancellation to the lists.
> 
> I can definitely think of use cases (inside of Google) where we could
> really use aio_cancel.  The issue is it's hard use it safely (i.e., we
> need to know whether the file system has already extended the file
> before we can know whether or not we can safely cancel the I/O).
> 
> > Short version, supporting cancellation without global sychronization is
> > possible but it'd require help from the allocator.
> 
> Well, we would need some kind of flag to indicate whether cancellation
> is possible, yes.  But if we're doing AIO to a raw disk, or we're
> talking about a read request, we wouldn't need any help from the
> file system's block allocator.
> 
> And maybe the current way of doing things isn't the best way.  But it
> would be nice if we didn't completely give up on the functionality of
> aio_cancel.

I thought about this more, and I think ripping out cancellation is a bad
idea in the long term too.

With what aio is capable of now (O_DIRECT), it's certainly arguable that
cancellation doesn't give you much and isn't worth the hassle of
implementing.

But, if we ever fix aio (and I certainly hope we do) and implement
something capable of doing arbitrary IO asynchronously, then we really
are going to need cancellation, because of io to sockets/pipes that can
be blocked for an unbounded amount of time.

Even if it turns out programs don't ever need cancellation in practice,
the real kicker is checkpoint/restore - for checkpoint/restore we've got
to enumerate all the outstanding operations or wait for them to complete
(for the ones that do complete in bounded time), and that's the hard
part of cancellation right there.

Zach might object here and point out that if we implement asynchronous
operations with kernel threads, we can implement cancelling by just
killing the thread. But this is only relevant if we _only_ implement
asynchronous operations with threads in aio v2, and I personally think
that's a lousy idea.

The reason is there's a lot of things that need to be fixed with aio in
aio v2, so aio v2 really needs to be a complete replacement for existing
aio users. It won't be if we start using kernel threads where we weren't
before - kernel threads are cheap but they aren't free, we'll regress on
performance and that means the new interfaces probably won't get used at
all by the existing users.

This isn't a big deal - we can implement aio v2 as a generic async
syscall mechanism, and then the default implementation for any given
syscall will just be the thread pool stuff but use optimized async
implementations for cases where it's available - this'll let us make use
of much of the existing infrastructure.

But it does mean we need a cancellation mechanism that isn't tied to
threads - i.e. does basically what the existing aio cancellation does.

So, IMO we should bite the bullet and do cancellation right now.

Also, I don't think there's anything really terrible about the existing
cancellation mechanism (unlike retrys, that code is... wtf), it's just
problematic for locking/performance. But that's fixable.

It is definitely possible to implement cancellation such that it doesn't
cost anything when it's not being used, but we do need some help from
the allocator.

Say we had a way of iterating over all the slabs in the kiocb cache:
if we pass a constructor to kmem_cache_create() we can guarantee that
all the refcounts are initialized to 0. Combine that with
SLAB_DESTROY_BY_RCU, and we can safely do a try_get_kiocb() when we're
iterating over all the kiocbs looking for the one we want.

The missing piece is a way to iterate over all those slabs, I haven't
been able to find any exposed interface for that.

If we could implement such a mechanism, that would be the way to go (and
I don't think it'd be useful for just aio, this sort of thing comes up
elsewhere. Anything that has to time out operations in particular). 

The other option would be to use a simpler dedicated allocator - I have
a simple fast percpu allocator I wrote awhile back for some driver code,
that allocates out of a fixed sized array (I needed to be able to
reference objects by a 16 bit id, i.e. index in the array). I could
easily change that to allocate pages (i.e. slabs) lazily... then we'd
have one of these allocator structs per kioctx so they'd get freed when
the kioctx goes away and we'd have less to look through when we want to
cancel something.

This'd probably be the shortest path, but - while it's no slower than
the existing slab allocators, it doesn't do numa allocation. I don't
know how much that matters on in practice with objects this small.
Besides that, adding another general purpose allocator would IMO be a
little silly.

Either way, IMO the right way to do it is with help from the allocator.
