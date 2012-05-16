Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab2EPRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:34:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:8137 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759267Ab2EPRe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100852011"
Date: Wed, 16 May 2012 13:35:23 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516173523.GK22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:52:00AM +0100, James Bottomley wrote:
> On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
> > There are a number of interesting non-volatile memory (NVM) technologies
> > being developed.  Some of them promise DRAM-comparable latencies and
> > bandwidths.  At Intel, we've been thinking about various ways to present
> > those to software.  This is a first draft of an API that supports the
> > operations we see as necessary.  Patches can follow easily enough once
> > we've settled on an API.
> 
> If we start from first principles, does this mean it's usable as DRAM?
> Meaning do we even need a non-memory API for it?  The only difference
> would be that some pieces of our RAM become non-volatile.

I'm not talking about a specific piece of technology, I'm assuming that
one of the competing storage technologies will eventually make it to
widespread production usage.  Let's assume what we have is DRAM with a
giant battery on it.

So, while we can use it just as DRAM, we're not taking advantage of the
persistent aspect of it if we don't have an API that lets us find the
data we wrote before the last reboot.  And that sounds like a filesystem
to me.

> Or is there some impediment (like durability, or degradation on rewrite)
> which makes this unsuitable as a complete DRAM replacement?

The idea behind using a different filesystem for different NVM types is
that we can hide those kinds of impediments in the filesystem.  By the
way, did you know DRAM degrades on every write?  I think it's on the
order of 10^20 writes (and CPU caches hide many writes to heavily-used
cache lines), so it's a long way away from MLC or even SLC rates, but
it does exist.

> Alternatively, if it's not really DRAM, I think the UNIX file
> abstraction makes sense (it's a piece of memory presented as something
> like a filehandle with open, close, seek, read, write and mmap), but
> it's less clear that it should be an actual file system.  The reason is
> that to present a VFS interface, you have to already have fixed the
> format of the actual filesystem on the memory because we can't nest
> filesystems (well, not without doing artificial loopbacks).  Again, this
> might make sense if there's some architectural reason why the flash
> region has to have a specific layout, but your post doesn't shed any
> light on this.

We can certainly present a block interface to allow using unmodified
standard filesystems on top of chunks of this NVM.  That's probably not
the optimum way for a filesystem to use it though; there's really no
point in constructing a bio to carry data down to a layer that's simply
going to do a memcpy().
