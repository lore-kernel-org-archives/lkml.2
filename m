Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480Ab2EQJyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:54:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59947 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab2EQJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:54:41 -0400
Message-ID: <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: NVM Mapping API
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 May 2012 10:54:38 +0100
In-Reply-To: <20120516173523.GK22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
	 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
	 <20120516173523.GK22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:35 -0400, Matthew Wilcox wrote:
> On Wed, May 16, 2012 at 10:52:00AM +0100, James Bottomley wrote:
> > On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
> > > There are a number of interesting non-volatile memory (NVM) technologies
> > > being developed.  Some of them promise DRAM-comparable latencies and
> > > bandwidths.  At Intel, we've been thinking about various ways to present
> > > those to software.  This is a first draft of an API that supports the
> > > operations we see as necessary.  Patches can follow easily enough once
> > > we've settled on an API.
> > 
> > If we start from first principles, does this mean it's usable as DRAM?
> > Meaning do we even need a non-memory API for it?  The only difference
> > would be that some pieces of our RAM become non-volatile.
> 
> I'm not talking about a specific piece of technology, I'm assuming that
> one of the competing storage technologies will eventually make it to
> widespread production usage.  Let's assume what we have is DRAM with a
> giant battery on it.
> 
> So, while we can use it just as DRAM, we're not taking advantage of the
> persistent aspect of it if we don't have an API that lets us find the
> data we wrote before the last reboot.  And that sounds like a filesystem
> to me.

Well, it sounds like a unix file to me rather than a filesystem (it's a
flat region with a beginning and end and no structure in between).
However, I'm not precluding doing this, I'm merely asking that if it
looks and smells like DRAM with the only additional property being
persistency, shouldn't we begin with the memory APIs and see if we can
add persistency to them?  Imposing a VFS API looks slightly wrong to me
because it's effectively a flat region, not a hierarchical tree
structure, like a FS.  If all the use cases are hierarchical trees, that
might be appropriate, but there hasn't really been any discussion of use
cases.

> > Or is there some impediment (like durability, or degradation on rewrite)
> > which makes this unsuitable as a complete DRAM replacement?
> 
> The idea behind using a different filesystem for different NVM types is
> that we can hide those kinds of impediments in the filesystem.  By the
> way, did you know DRAM degrades on every write?  I think it's on the
> order of 10^20 writes (and CPU caches hide many writes to heavily-used
> cache lines), so it's a long way away from MLC or even SLC rates, but
> it does exist.

So are you saying does or doesn't have an impediment to being used like
DRAM?

> > Alternatively, if it's not really DRAM, I think the UNIX file
> > abstraction makes sense (it's a piece of memory presented as something
> > like a filehandle with open, close, seek, read, write and mmap), but
> > it's less clear that it should be an actual file system.  The reason is
> > that to present a VFS interface, you have to already have fixed the
> > format of the actual filesystem on the memory because we can't nest
> > filesystems (well, not without doing artificial loopbacks).  Again, this
> > might make sense if there's some architectural reason why the flash
> > region has to have a specific layout, but your post doesn't shed any
> > light on this.
> 
> We can certainly present a block interface to allow using unmodified
> standard filesystems on top of chunks of this NVM.  That's probably not
> the optimum way for a filesystem to use it though; there's really no
> point in constructing a bio to carry data down to a layer that's simply
> going to do a memcpy().

I think we might be talking at cross purposes.  If you use the memory
APIs, this looks something like an anonymous region of memory with a get
and put API; something like SYSV shm if you like except that it's
persistent.  No filesystem semantics at all.  Only if you want FS
semantics (or want to impose some order on the region for unplugging and
replugging), do you put an FS on the memory region using loopback
techniques.

Again, this depends on use case.  The SYSV shm API has a global flat
keyspace.  Perhaps your envisaged use requires a hierarchical key space
and therefore a FS interface looks more natural with the leaves being
divided memory regions?

James


