Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2BQFi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:38:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60757 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2BQFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:38:49 -0500
Message-ID: <1329457113.2373.53.camel@js-netbook>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Dave Chinner <david@fromorbit.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Thu, 16 Feb 2012 21:38:33 -0800
In-Reply-To: <20120217044557.GI14132@dastard>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <20120214051659.GH14132@dastard> <1329198932.2753.62.camel@work-vm>
	 <20120214235106.GL7479@dastard> <1329265750.2340.17.camel@work-vm>
	 <20120215123750.3333141f@notabene.brown> <20120217044557.GI14132@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021705-3270-0000-0000-000004186283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 15:45 +1100, Dave Chinner wrote:
> On Wed, Feb 15, 2012 at 12:37:50PM +1100, NeilBrown wrote:
> > On Tue, 14 Feb 2012 16:29:10 -0800 John Stultz <john.stultz@linaro.org> wrote:
> > 
> > > But I'm open to other ideas and arguments.
> > 
> > I didn't notice the original patch, but found it at
> > https://lwn.net/Articles/468837/
> > and had a look.
> > 
> > My first comment is -ENODOC.  A bit background always helps, so let me try to
> > construct that:
> > 
> >  The goal is to allow applications to interact with the kernel's cache
> >  management infrastructure.  In particular an application can say "this
> >  memory contains data that might be useful in the future, but can be
> >  reconstructed if necessary, and it is cheaper to reconstruct it than to read
> >  it back from disk, so don't bother writing it out".
> > 
> >  The proposed mechanism - at a high level - is for user-space to be able to
> >  say "This memory is volatile" and then later "this memory is no longer
> >  volatile".  If the content of the memory is still available the second
> >  request succeeds.  If not, it fails.. Well, actually it succeeds but reports
> >  that some content has been lost. (not sure what happens then - can the app do
> >  a binary search to find which pages it still has or something).
> > 
> >  (technically we should probably include the cost to reconstruct the page,
> >  which the kernel measures as 'seeks' but maybe that isn't necessary).
> > 
> >  This is implemented by using files in a 'tmpfs' filesystem.  These file
> >  support three new flags to fadvise:
> > 
> >  POSIX_FADV_VOLATILE - this marks a range of pages as 'volatile'.  They may be
> >         removed from the page cache as needed, even if they are not 'clean'.
> >  POSIX_FADV_NONVOLATILE - this marks a range of pages as non-volatile.
> >         If any pages in the range were previously volatile but have since been
> >         removed, then a status is returned reporting this.
> >  POSIX_FADV_ISVOLATILE - this does not actually give any advice to the kernel
> >         but rather asks a question: Are any of these pages volatile?
> 
> What about for files that aren't on tmpfs? the fadvise() interface
> is not tmpfs specific, and given that everyone is talking about
> volatility of page cache pages, I fail to see what is tmpfs specific
> about this proposal.
> 
> So what are the semantics that are supposed to apply to a file that
> is on a filesystem with stable storage that is cached in the page
> cache?

Indeed, this is probably the most awkward case.  So currently, we use
vmtruncate_range, which should punch a hole in the file. If I switch to
invalidate_inode_pages2_range(), then I think dirty data is dropped and
the backed page remains (I'm currently reading over that now).

> If this is tmpfs specific behaviour that is required, then IMO
> fadvise is not the correct interface to use here because fadvise is
> supposed to be a generic interface to controlling the page cache
> behaviour on any given file....
>
> > As a counter-point,  this is my first thought of an implementation approach
> > (-ENOPATCH, sorry)
> > 
> > - new mount option for tmpfs e.g. 'volatile'.  Any file in a filesystem
> >   mounted with that option and which is not currently open by any process can
> >   have blocks removed at any time.  The file name must remain, and the file
> >   size must not change.
> > - lseek can be used to determine if anything has been purged with 'SEEK_DATA'
> >   and 'SEEK_HOLE'.
> > 
> > So you can only mark volatility on a whole-file granularity (hence the
> > question above).
> >  'open' says "NONVOLATILE".
> >  'close' says "VOLATILE".
> >  'lseek' is used to check if anything was discarded.
> > 
> > This approach would allow multiple processes to share a cache (might this be
> > valuable?) as it doesn't become truly volatile until all processes close
> > their handles.
> 
> If this functionality is only useful for tmpfs, then I'd much prefer
> a tmpfs specific approach like this....

Since, as I think more on this, this seems to map closer to file hole
punching, would fallocate be the right interface? FALLOC_FL_PUNCH_HOLE
isn't supported by all filesystems, after all. 

Maybe FALLOC_FL_VOLATILE and FALLOC_FL_NONVOLATILE?

thanks
-john

