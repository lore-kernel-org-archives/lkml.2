Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1KVJiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:38:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab1KVJiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:38:08 -0500
Message-ID: <4ECB6D60.1010702@redhat.com>
Date: Tue, 22 Nov 2011 04:37:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:33 PM, John Stultz wrote:
> This patch provides new fadvise flags that can be used to mark
> file pages as volatile, which will allow it to be discarded if the
> kernel wants to reclaim memory.
>
> This is useful for userspace to allocate things like caches, and lets
> the kernel destructively (but safely) reclaim them when there's memory
> pressure.
>
> Right now, we can simply throw away pages if they are clean (backed
> by a current on-disk copy).  That only happens for anonymous/tmpfs/shmfs
> pages when they're swapped out.  This patch lets userspace select
> dirty pages which can be simply thrown away instead of writing them
> to disk first.  See the mm/shmem.c for this bit of code.  It's
> different from FADV_DONTNEED since the pages are not immediately
> discarded; they are only discarded under pressure.

I've got a few questions:

1) How do you tell userspace some of its data got
    discarded?

2) How do you prevent the situation where every
    volatile object gets a few pages discarded, making
    them all unusable?
    (better to throw away an entire object at once)

3) Isn't it too slow for something like Firefox to
    create a new tmpfs object for every single throw-away
    cache object?

Johannes, Jon and I have looked at an alternative way to
allow the kernel and userspace to cooperate in throwing
out cached data.  This alternative way does not touch
the alloc/free fast path at all, but does require some
cooperation at "shrink cache" time.

The idea is quite simple:

1) Every program that we are interested in already has
    some kind of main loop where it polls on file descriptors.
    It is easy for such programs to add an additional file,
    which would be a device or sysfs file that wakes up the
    program from its poll/select loop when memory is getting
    full to the point that userspace needs to shrink its
    caches.

    The kernel can be smart here and wake up just one process
    at a time, targeting specific NUMA nodes or cgroups. Such
    kernel smarts do not require additional userspace changes.

2) When userspace gets such a "please shrink your caches"
    event, it can do various things.  A program like firefox
    could throw away several cached objects, eg. uncompressed
    images or entire pre-rendered tabs, while a JVM can shrink
    its heap size and a database could shrink its internal
    cache.

3) After doing that, they could all call the same glibc
    function that walks across program-internal free memory
    and calls MADV_FREE on all free regions that span
    multiple pages, which gives the pages back to the kernel,
    without needing to move VMA boundaries.  This is relatively
    light weight and allows for the nuking of pages right in
    the middle of a heap VMA.

4) In some GUI libraries, like gtk/glib, we could open the
    memory pressure device node (or sysfs file) by default,
    hooking it up to the glibc function from (3) by default,
    which would give all gtk/glib programs the ability to
    give free()d memory back to the kernel on request, without
    needing to even modify the program.

    Program modification would only be needed in order to
    free cached objects, etc.  The modification of programs
    running under those libraries would consist of overriding
    the "shrink caches" hook with their own function, which
    first does program-specific stuff and then calls the
    default hook to take care of the glibc side.

We considered the same approach you are proposing as well, but
we did not come up with satisfactory answers to the questions I
asked above, which is why we came up with this scheme.

Unfortunately we have not gotten around to implementing it yet,
but I'd be happy to work on it with you guys if you are
interested.
