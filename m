Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370Ab2EQS6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:58:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:49819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762253Ab2EQS6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145258042"
Date: Thu, 17 May 2012 14:59:44 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120517185944.GP22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
 <20120516173523.GK22985@linux.intel.com>
 <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:54:38AM +0100, James Bottomley wrote:
> On Wed, 2012-05-16 at 13:35 -0400, Matthew Wilcox wrote:
> > I'm not talking about a specific piece of technology, I'm assuming that
> > one of the competing storage technologies will eventually make it to
> > widespread production usage.  Let's assume what we have is DRAM with a
> > giant battery on it.
> > 
> > So, while we can use it just as DRAM, we're not taking advantage of the
> > persistent aspect of it if we don't have an API that lets us find the
> > data we wrote before the last reboot.  And that sounds like a filesystem
> > to me.
> 
> Well, it sounds like a unix file to me rather than a filesystem (it's a
> flat region with a beginning and end and no structure in between).

That's true, but I think we want to put a structure on top of it.
Presumably there will be multiple independent users, and each will want
only a fraction of it.

> However, I'm not precluding doing this, I'm merely asking that if it
> looks and smells like DRAM with the only additional property being
> persistency, shouldn't we begin with the memory APIs and see if we can
> add persistency to them?

I don't think so.  It feels harder to add useful persistent
properties to the memory APIs than it does to add memory-like
properties to our file APIs, at least partially because for
userspace we already have memory properties for our file APIs (ie
mmap/msync/munmap/mprotect/mincore/mlock/munlock/mremap).

> Imposing a VFS API looks slightly wrong to me
> because it's effectively a flat region, not a hierarchical tree
> structure, like a FS.  If all the use cases are hierarchical trees, that
> might be appropriate, but there hasn't really been any discussion of use
> cases.

Discussion of use cases is exactly what I want!  I think that a
non-hierarchical attempt at naming chunks of memory quickly expands
into cases where we learn we really do want a hierarchy after all.

> > > Or is there some impediment (like durability, or degradation on rewrite)
> > > which makes this unsuitable as a complete DRAM replacement?
> > 
> > The idea behind using a different filesystem for different NVM types is
> > that we can hide those kinds of impediments in the filesystem.  By the
> > way, did you know DRAM degrades on every write?  I think it's on the
> > order of 10^20 writes (and CPU caches hide many writes to heavily-used
> > cache lines), so it's a long way away from MLC or even SLC rates, but
> > it does exist.
> 
> So are you saying does or doesn't have an impediment to being used like
> DRAM?

>From the consumers point of view, it doesn't.  If the underlying physical
technology does (some of the ones we've looked at have worse problems
than others), then it's up to the driver to disguise that.

> > > Alternatively, if it's not really DRAM, I think the UNIX file
> > > abstraction makes sense (it's a piece of memory presented as something
> > > like a filehandle with open, close, seek, read, write and mmap), but
> > > it's less clear that it should be an actual file system.  The reason is
> > > that to present a VFS interface, you have to already have fixed the
> > > format of the actual filesystem on the memory because we can't nest
> > > filesystems (well, not without doing artificial loopbacks).  Again, this
> > > might make sense if there's some architectural reason why the flash
> > > region has to have a specific layout, but your post doesn't shed any
> > > light on this.
> > 
> > We can certainly present a block interface to allow using unmodified
> > standard filesystems on top of chunks of this NVM.  That's probably not
> > the optimum way for a filesystem to use it though; there's really no
> > point in constructing a bio to carry data down to a layer that's simply
> > going to do a memcpy().
> 
> I think we might be talking at cross purposes.  If you use the memory
> APIs, this looks something like an anonymous region of memory with a get
> and put API; something like SYSV shm if you like except that it's
> persistent.  No filesystem semantics at all.  Only if you want FS
> semantics (or want to impose some order on the region for unplugging and
> replugging), do you put an FS on the memory region using loopback
> techniques.
> 
> Again, this depends on use case.  The SYSV shm API has a global flat
> keyspace.  Perhaps your envisaged use requires a hierarchical key space
> and therefore a FS interface looks more natural with the leaves being
> divided memory regions?

I've really never heard anybody hold up the SYSV shm API as something
to be desired before.  Indeed, POSIX shared memory is much closer to
the filesystem API; the only difference being use of shm_open() and
shm_unlink() instead of open() and unlink() [see shm_overview(7)].
And I don't really see the point in creating specialised nvm_open()
and nvm_unlink() functions ...
