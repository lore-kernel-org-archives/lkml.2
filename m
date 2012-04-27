Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab2D0AkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:40:05 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44495 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab2D0AkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:40:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJbpmU95LapK/2dsb2JhbABFsXOBCIIJAQEFOhwjEAgDGC4UJQMhE4gMvBwTinWFU2MElXyJWYZognqBQw
Date: Fri, 27 Apr 2012 10:39:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
Message-ID: <20120427003953.GC9541@dastard>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:49:46AM -0700, John Stultz wrote:
> This patch provides new fadvise flags that can be used to mark
> file pages as volatile, which will allow it to be discarded if the
> kernel wants to reclaim memory.

.....

> @@ -18,4 +18,9 @@
>  #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
>  #endif
>  
> +#define POSIX_FADV_VOLATILE	8  /* _can_ toss, but don't toss now */
> +#define POSIX_FADV_NONVOLATILE	9  /* Remove VOLATILE flag */

These aren't POSIX standards, so I don't think they should have the
POSIX_ prefix. Besides....

....
> @@ -128,6 +129,19 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>  			invalidate_mapping_pages(mapping, start_index,
>  						end_index);
>  		break;
> +	case POSIX_FADV_VOLATILE:
> +		/* First and last PARTIAL page! */
> +		start_index = offset >> PAGE_CACHE_SHIFT;
> +		end_index = endbyte >> PAGE_CACHE_SHIFT;
> +		ret = mapping_range_volatile(mapping, start_index, end_index);
> +		break;
> +	case POSIX_FADV_NONVOLATILE:
> +		/* First and last PARTIAL page! */
> +		start_index = offset >> PAGE_CACHE_SHIFT;
> +		end_index = endbyte >> PAGE_CACHE_SHIFT;
> +		ret = mapping_range_nonvolatile(mapping, start_index,
> +								end_index);

As it is, I'm still not sold on these being an fadvise() interface
because all it really is a delayed hole punching interface whose
functionailty is currently specific to tmpfs. The behaviour cannot
be implemented sanely by anything else at this point.

> + * The goal behind volatile ranges is to allow applications to interact
> + * with the kernel's cache management infrastructure.  In particular an
> + * application can say "this memory contains data that might be useful in
> + * the future, but can be reconstructed if necessary, so if the kernel
> + * needs, it can zap and reclaim this memory without having to swap it out.

This is what I mean - the definition of volatility is specific to a
filesystem implementation - one that doesn't store persistent data.

> + * The proposed mechanism - at a high level - is for user-space to be able
> + * to say "This memory is volatile" and then later "this memory is no longer
> + * volatile".  If the content of the memory is still available the second
> + * request succeeds.  If not, the memory is marked non-volatile and an
> + * error is returned to denote that the contents have been lost.

For a filesystem, it's not "memory" that is volatile - it is the
*data* that we have to consider that these hints apply to, and that
implies both in memory and on stable storage. because you are
targetting a filesystem without persisten storage, you are using
"memory" interchangably with "data". That basically results in an
interface that can only be used by non-persistent filesystems.
However, for managing on-disk caches of fixed sizes, being able to
mark regions as volatile or not is just as helpful to them as it is
to memory based caches on tmpfs....

So why can't you implement this as fallocate() flags, and then make
the tmpfs implementation of those fallocate flags do the right
things?  I think fallocate is the right interface, because this is
simply an extension of the existing hole punching implementation.
IOWs, the specification you are describing means that FADV_VOLATILE
could be correctly implemented as an immediate hole punch by every
filesystem that supports hole punching.

This probably won't perform wonderfully, which is where the range
tracking and delayed punching (and the implied memory freeing)
optimiation comes into play. Sure, for tmpfs this can be implemented
as a shrinker, but for real filesystems that have to punch blocks a
shrinker is really the wrong context to be running such
transactions. However, using the fallocate() interface allows each
filesytsem to optimise the delayed hole punching as they see best,
something that cannot be done with this fadvise() interface.

It's all great that this can replace a single function in ashmem,
but focussing purely on ashmem misses the point that this
functionality has wider use, and that using a different interface
allows independently tailored and optimised implementations of that
functionality....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
