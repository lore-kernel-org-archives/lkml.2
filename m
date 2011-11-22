Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1KVTtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:49:17 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40117 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KVTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:49:15 -0500
Message-ID: <1321991338.6445.70.camel@work-vm>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Date: Tue, 22 Nov 2011 11:48:58 -0800
In-Reply-To: <4ECB6D60.1010702@redhat.com>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	 <4ECB6D60.1010702@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112219-3352-0000-0000-000000ECD8FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 04:37 -0500, Rik van Riel wrote:
> On 11/21/2011 10:33 PM, John Stultz wrote:
> > This patch provides new fadvise flags that can be used to mark
> > file pages as volatile, which will allow it to be discarded if the
> > kernel wants to reclaim memory.
> >
> > This is useful for userspace to allocate things like caches, and lets
> > the kernel destructively (but safely) reclaim them when there's memory
> > pressure.
> >
> > Right now, we can simply throw away pages if they are clean (backed
> > by a current on-disk copy).  That only happens for anonymous/tmpfs/shmfs
> > pages when they're swapped out.  This patch lets userspace select
> > dirty pages which can be simply thrown away instead of writing them
> > to disk first.  See the mm/shmem.c for this bit of code.  It's
> > different from FADV_DONTNEED since the pages are not immediately
> > discarded; they are only discarded under pressure.
> 
> I've got a few questions:
> 
> 1) How do you tell userspace some of its data got
>     discarded?

You get a return code when marking the page non-volatile if it has been
discarded. This follows the ashmem style that Robert described in the
other mail.

> 2) How do you prevent the situation where every
>     volatile object gets a few pages discarded, making
>     them all unusable?
>     (better to throw away an entire object at once)

Indeed. One of the issues folks brought up about the ashmem code was
that it manages its own lru.  This attempt just simplifies the code, by
using the kerenl's own lru, but does have the draw back that it is page
based instead of  object or range-based.

We could try to zap the entire range when a page from the range is
written out, or we could go back to using a range based lru, like ashmem
does. 


> 3) Isn't it too slow for something like Firefox to
>     create a new tmpfs object for every single throw-away
>     cache object?

So, if you mean creating a new file for every cache object, that doesn't
seem necessary, as you could map a number of objects into the same file
and mark the ranges as volatile or not as needed. 

Or are you worried about the allocation of the range structure when we
mark a region as volatile?

Either way, I'd defer to Robert on real-world usage. 


> Johannes, Jon and I have looked at an alternative way to
> allow the kernel and userspace to cooperate in throwing
> out cached data.  This alternative way does not touch
> the alloc/free fast path at all, but does require some
> cooperation at "shrink cache" time.
> 
> The idea is quite simple:
> 
> 1) Every program that we are interested in already has
>     some kind of main loop where it polls on file descriptors.
>     It is easy for such programs to add an additional file,
>     which would be a device or sysfs file that wakes up the
>     program from its poll/select loop when memory is getting
>     full to the point that userspace needs to shrink its
>     caches.
> 
>     The kernel can be smart here and wake up just one process
>     at a time, targeting specific NUMA nodes or cgroups. Such
>     kernel smarts do not require additional userspace changes.
> 
> 2) When userspace gets such a "please shrink your caches"
>     event, it can do various things.  A program like firefox
>     could throw away several cached objects, eg. uncompressed
>     images or entire pre-rendered tabs, while a JVM can shrink
>     its heap size and a database could shrink its internal
>     cache.

So similarly to Robert, I don't see this approach as necessarily
exclusive to the volatile flags. There are just some tradeoffs with the
different approaches.

The upside with your approach is that applications don't have to
remember to re-pin the cache before using it and unpin it after its done
using it.

The downside is that the "please shrink your caches" message is likely
to arrive when the system is low on resources. Once applications have
been asked to "be nice and get small!", having to wait for that action
to occur might not be great. Where as with the volatile regions, there
are just additionally easily freeable pages available when the kernel
needs them.

thanks
-john


