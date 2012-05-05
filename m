Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2EEPVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:21:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:64105 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2EEPVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:21:15 -0400
Message-ID: <4FA54569.2040209@tilera.com>
Date: Sat, 5 May 2012 11:21:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 17/18] tile: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de> <20120505150142.311126440@linutronix.de>
In-Reply-To: <20120505150142.311126440@linutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2012 11:05 AM, Thomas Gleixner wrote:
> Use the core allocator and deal with the extra cleanup in
> arch_release_thread_info().
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/thread_info.h |    6 ++----
>  arch/tile/kernel/process.c          |   23 ++---------------------
>  2 files changed, 4 insertions(+), 25 deletions(-)

We have some changes we haven't yet merged upstream that this will likely
conflict with.

You may note that we have APIs like homecache_alloc_pages() that take a
core or other magic value to indicate what the "home" cache should be on
our architecture.  This enables significant performance optimizations when
you can co-locate the home cache with where most of the core references are
coming from.

The additional changes we haven't yet merged are in the area of managing
the home cache dynamically.  Rather than just setting the home cache at
allocation time, we allow it to be modified dynamically: for example, as
the process migrates, we migrate the kernel and user stack pages.  This is
tricky since there are lots of coherence issues to manage, and the changes
we have include a variety of changes in the core mm code to handle
transitioning the home cache, proper locking, unmapping, hooks in the buddy
allocator, blocking other cores while a page is transitioning, etc etc.

But, the relevance to this change is that as part of that code, we use the
homecache_alloc_page() method to set the home cache of a kernel stack page
to be the core that is running the thread (and then migrate the home cache
dynamically after that).  Using the new proposed core allocator will mean
we lose that hook.  We don't need a free hook (when we're using the dynamic
mode we are already hooked into the allocator itself), but we do need a way
to know when we're allocating a kernel stack page as opposed to any other
kind of a page.

The simplest approach is of course just to allow
__HAVE_ARCH_THREAD_INFO_ALLOCATOR to continue to be meaningful and use it
for tile, but maybe there's some halfway point.  For example, that symbol
could refer only to the allocate function, and not also imply an
arch-specific free function.  Or, we could have a new much more focused
override that was just "a function to use instead of alloc_pages_node",
e.g. provide a weak alloc_threadinfo_pages_node() that just was generically
just a call to alloc_pages_node, which architectures could override.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

