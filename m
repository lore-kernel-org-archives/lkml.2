Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2EGTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:46:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41816 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab2EGTp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:45:59 -0400
Date: Mon, 7 May 2012 21:45:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 17/18] tile: Use common threadinfo allocator
In-Reply-To: <4FA54569.2040209@tilera.com>
Message-ID: <alpine.LFD.2.02.1205072134130.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150142.311126440@linutronix.de> <4FA54569.2040209@tilera.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2012, Chris Metcalf wrote:

> On 5/5/2012 11:05 AM, Thomas Gleixner wrote:
> > Use the core allocator and deal with the extra cleanup in
> > arch_release_thread_info().
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > ---
> >  arch/tile/include/asm/thread_info.h |    6 ++----
> >  arch/tile/kernel/process.c          |   23 ++---------------------
> >  2 files changed, 4 insertions(+), 25 deletions(-)
> 
> We have some changes we haven't yet merged upstream that this will likely
> conflict with.
> 
> You may note that we have APIs like homecache_alloc_pages() that take a
> core or other magic value to indicate what the "home" cache should be on
> our architecture.  This enables significant performance optimizations when
> you can co-locate the home cache with where most of the core references are
> coming from.
> 
> The additional changes we haven't yet merged are in the area of managing
> the home cache dynamically.  Rather than just setting the home cache at
> allocation time, we allow it to be modified dynamically: for example, as
> the process migrates, we migrate the kernel and user stack pages.  This is
> tricky since there are lots of coherence issues to manage, and the changes
> we have include a variety of changes in the core mm code to handle
> transitioning the home cache, proper locking, unmapping, hooks in the buddy
> allocator, blocking other cores while a page is transitioning, etc etc.
> 
> But, the relevance to this change is that as part of that code, we use the
> homecache_alloc_page() method to set the home cache of a kernel stack page
> to be the core that is running the thread (and then migrate the home cache
> dynamically after that).  Using the new proposed core allocator will mean
> we lose that hook.  We don't need a free hook (when we're using the dynamic
> mode we are already hooked into the allocator itself), but we do need a way
> to know when we're allocating a kernel stack page as opposed to any other
> kind of a page.

What's the difference between a kernel stack page for a given node and
a page which is allocated on a given node ?
 
> The simplest approach is of course just to allow
> __HAVE_ARCH_THREAD_INFO_ALLOCATOR to continue to be meaningful and use it
> for tile, but maybe there's some halfway point.  For example, that symbol
> could refer only to the allocate function, and not also imply an
> arch-specific free function.  Or, we could have a new much more focused
> override that was just "a function to use instead of alloc_pages_node",
> e.g. provide a weak alloc_threadinfo_pages_node() that just was generically
> just a call to alloc_pages_node, which architectures could override.

Again, that would give you what? 

If you treat kernel stack pages different to general pages allocated
on a node then why not using a special GFP flag for that purpose?

Thanks,

	tglx
