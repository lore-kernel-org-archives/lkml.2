Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2BQFWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:22:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56681 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2BQFWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:22:39 -0500
Message-ID: <1329456095.2373.43.camel@js-netbook>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Thu, 16 Feb 2012 21:21:35 -0800
In-Reply-To: <20120215123750.3333141f@notabene.brown>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <20120214051659.GH14132@dastard>	<1329198932.2753.62.camel@work-vm>
	 <20120214235106.GL7479@dastard>	<1329265750.2340.17.camel@work-vm>
	 <20120215123750.3333141f@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021705-6148-0000-0000-00000384D3B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 12:37 +1100, NeilBrown wrote:
> On Tue, 14 Feb 2012 16:29:10 -0800 John Stultz <john.stultz@linaro.org> wrote:
> 
> > But I'm open to other ideas and arguments.
> 
> I didn't notice the original patch, but found it at
> https://lwn.net/Articles/468837/
> and had a look.
> 
> My first comment is -ENODOC.  A bit background always helps, so let me try to
> construct that:

Apologies for not providing better documentation, and thanks for your
first pass below.

>  The goal is to allow applications to interact with the kernel's cache
>  management infrastructure.  In particular an application can say "this
>  memory contains data that might be useful in the future, but can be
>  reconstructed if necessary, and it is cheaper to reconstruct it than to read
>  it back from disk, so don't bother writing it out".

Or alternatively for tmpfs/ramfs, "this data can be reconstructed, so
purge it and free up memory".  But as it currently stands, being fs
agnostic, for disk backed filesystems "don't bother writing it out" is
correct as well. 

>  The proposed mechanism - at a high level - is for user-space to be able to
>  say "This memory is volatile" and then later "this memory is no longer
>  volatile".  If the content of the memory is still available the second
>  request succeeds.  If not, it fails.. Well, actually it succeeds but reports
>  that some content has been lost. (not sure what happens then - can the app do
>  a binary search to find which pages it still has or something).

The app should expect all was lost in that range.

>  (technically we should probably include the cost to reconstruct the page,
>  which the kernel measures as 'seeks' but maybe that isn't necessary).

Not sure I'm following this.

>  This is implemented by using files in a 'tmpfs' filesystem.  These file
>  support three new flags to fadvise:
> 
>  POSIX_FADV_VOLATILE - this marks a range of pages as 'volatile'.  They may be
>         removed from the page cache as needed, even if they are not 'clean'.
>  POSIX_FADV_NONVOLATILE - this marks a range of pages as non-volatile.
>         If any pages in the range were previously volatile but have since been
>         removed, then a status is returned reporting this.
>  POSIX_FADV_ISVOLATILE - this does not actually give any advice to the kernel
>         but rather asks a question: Are any of these pages volatile?
> 
> 
> Is this an accurate description?

Right now its not tmpfs specific, but otherwise this is pretty spot on.

> My first thoughts are:
>  1/ is page granularity really needed?  Would file granularity be sufficient?

The current users of similar functionality via ashmem do seem to find
page granularity useful. You can share basically an unlinked tmpfs fd
between two applications and mark and unmark ranges of pages
"volatile" (unpinned in ashmem terms) as needed.

>  2/ POSIX_FADV_ISVOLATILE is a warning sign to me - it doesn't actually
>     provide advice.  Is this really needed?  What for?  Because it feels like
>     a wrong interface.

It is more awkward, I agree. And the more I think about it, it seems
like its something we can drop, as it is likely only useful as a probe
before using a page, and using the POSIX_FADV_NONVOLAILE on the range to
be used would also provide the same behavior. So I'll drop it in the
next revision. 

>  3/ Given that this is specific to one filesystem, is fadvise really an
>     appropriate interface?
> 
> (fleshing out the above documentation might be an excellent way to answer
> these questions).

So, the ashmem implementation is really tmpfs specific, but there's also
the expectation on android devices that there isn't swap, so its more
like ramfs.  I'd like to think that this behavior makes some sense on
other filesystems, providing a way to cheaply throw out dirty data
without the cost of hitting the disk. However, the next time the file is
opened, that could cause some really strange inconsistent results, with
some recent pages written out and some stale pages. The vmtruncate would
punch a hole instead of leaving stale data, but that still would have to
hit the disk so its not free. So I'm not really sure if it makes sense
in a totally generic way. That said, it would be easy for now to return
errors if the fs isn't shmem based. 

Really, I'm not married to any specific interface here. fadvise just
seemed the most logical to me. Given page granularity is needed, what
would be a filesystem specific interface that makes sense here?

> As a counter-point,  this is my first thought of an implementation approach
> (-ENOPATCH, sorry)
> 
> - new mount option for tmpfs e.g. 'volatile'.  Any file in a filesystem
>   mounted with that option and which is not currently open by any process can
>   have blocks removed at any time.  The file name must remain, and the file
>   size must not change.
> - lseek can be used to determine if anything has been purged with 'SEEK_DATA'
>   and 'SEEK_HOLE'.
> 
> So you can only mark volatility on a whole-file granularity (hence the
> question above).
>  'open' says "NONVOLATILE".
>  'close' says "VOLATILE".
>  'lseek' is used to check if anything was discarded.
> 
> This approach would allow multiple processes to share a cache (might this be
> valuable?) as it doesn't become truly volatile until all processes close
> their handles.

I do really appreciate the feedback, but I don't think the full file
semantics described here would work for what are essentially existing
users of ashmem.

thanks
-john


