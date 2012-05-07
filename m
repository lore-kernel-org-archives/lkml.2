Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2EGUd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:33:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:42035 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2EGUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:33:22 -0400
Date: Mon, 7 May 2012 22:33:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 17/18] tile: Use common threadinfo allocator
In-Reply-To: <4FA82A80.3090001@tilera.com>
Message-ID: <alpine.LFD.2.02.1205072227540.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150142.311126440@linutronix.de> <4FA54569.2040209@tilera.com> <alpine.LFD.2.02.1205072134130.6271@ionos> <4FA82A80.3090001@tilera.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Chris Metcalf wrote:
> On 5/7/2012 3:45 PM, Thomas Gleixner wrote:
> > What's the difference between a kernel stack page for a given node and
> > a page which is allocated on a given node ?
> 
> No difference except in how it is allocated (and of course how it is
> used).  The task migration code currently knows that the kernel stack
> should have its home cache migrated; it finds it by VA.  In the absence of
> migration the kernel stack page is not treated differently than any other
> page_alloc'ed page.
> 
> >> The simplest approach is of course just to allow
> >> __HAVE_ARCH_THREAD_INFO_ALLOCATOR to continue to be meaningful and use it
> >> for tile, but maybe there's some halfway point.  For example, that symbol
> >> could refer only to the allocate function, and not also imply an
> >> arch-specific free function.  Or, we could have a new much more focused
> >> override that was just "a function to use instead of alloc_pages_node",
> >> e.g. provide a weak alloc_threadinfo_pages_node() that just was generically
> >> just a call to alloc_pages_node, which architectures could override.
> > Again, that would give you what? 
> 
> The advantage is that when you initially allocate the stack page, you can
> set its home cache appropriately to be on the local cpu, where the new task
> is likely to run.  Otherwise, you could imagine using a suitable hook for
> when the task starts up to migrate the page at that point, but you miss out
> on the opportunity to have the allocator return a suitably-cached page up
> front when the task is created.
> 
> > If you treat kernel stack pages different to general pages allocated
> > on a node then why not using a special GFP flag for that purpose?
> 
> There are certainly different possible ways to tell the allocator to
> allocate a page with its cache "here" vs with its cache fully-distributed
> (and thus less local, and less good for stack or percpu pages).  We use a
> different approach (some per-task data structures that pass homing info to
> the allocator) but we could probably use GFP_ values instead.  But the
> point is we need to be able to know to do so, and I think the only obvious
> way is to override something in the threadinfo allocator.

Wrong. The obvious way is to use the common code and add a special
flag to it.

There is nothing wrong to add

#ifndef ARCH_THREADINFO_GFP
#define ARCH_THREADINFO_GFP (0)
#endif

and or ARCH_THREADINFO_GFP to the generic THREADINFO_GFP flags

instead of insisting on a separate allocator function for something
which has no fricking reason to be arch specific (IA64 and some weird
sparc crap aside)

Thanks,

	tglx

