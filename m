Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2JJA0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2JJA0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:26:42 -0400
Date: Tue, 9 Oct 2012 17:26:34 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121010002634.GX26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010000600.GB26835@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The AIO ringbuffer stuff just annoys me more than most

Not more than everyone, though, I can personally promise you that :).

> (it wasn't until
> the other day that I realized it was actually exported to userspace...
> what led to figuring that out was noticing aio_context_t was a ulong,
> and got truncated to 32 bits with a 32 bit program running on a 64 bit
> kernel. I'd been horribly misled by the code comments and the lack of
> documentation.) 

Yeah.  It's the userspace address of the mmaped ring.  This has annoyed
the process migration people who can't recreate the context in a new
kernel because there's no userspace interface to specify creation of a
context at a specific address.

> But if we do have an explicit handle, I don't see why it shouldn't be a
> file descriptor.

Because they're expensive to create and destroy when compared to a
single system call.  Imagine that we're using waiting for a single
completion to implement a cheap one-off sync call.  Imagine it's a
buffered op which happens to hit the cache and is really quick.

(And they're annoying to manage: libraries and O_CLOEXEC, running into
fd/file limit tunables, bleh.)

If the 'completion context' is no more than a structure in userspace
memory then a lot of stuff just works.  Tasks can share it amongst
themselves as they see fit.  A trivial one-off sync call can just dump
it on the stack and point to it.  It doesn't have to be specifically
torn down on task exit.

> > And perhaps obviously, I'd start with the acall stuff :).  It was a lot
> > lighter.  We could talk about how to make it extensible without going
> > all the way to the generic packed variable size duplicating or not and
> > returning or not or.. attributes :).
> 
> Link? I haven't heard of acall before.

I linked to it after that giant silly comment earlier in the thread,
here it is again:

  http://lwn.net/Articles/316806/

There's a mostly embarassing video of a jetlagged me giving that talk at
LCA kicking around.. ah, here:

 http://mirror.linux.org.au/pub/linux.conf.au/2009/Thursday/131.ogg

- z
