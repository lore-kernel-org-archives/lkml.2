Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0FIW6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:58:18 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:40685 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756915Ab0FIW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:58:17 -0400
Date: Thu, 10 Jun 2010 08:58:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com, stable@kernel.org
Subject: Re: [PATCH 1/3] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100609225804.GK7869@dastard>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
 <1276043840-1946-2-git-send-email-david@fromorbit.com>
 <20100609140942.6799c84a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609140942.6799c84a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 02:09:42PM -0700, Andrew Morton wrote:
> On Wed,  9 Jun 2010 10:37:18 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> > This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> > needs to terminate after a certain number of pages are written, not after a
> > certain number of calls to ->writepage are made.  This is a regression
> > introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
> > no_nrwrite_index_update writeback control flag"), but cannot be reverted
> > directly due to subsequent bug fixes that have gone in on top of it.
> 
> Might be needed in -stable.  Unfortunately the most important piece of
> information which is needed to make that decision was cunningly hidden
> from us behind the vague-to-the-point-of-uselessness term "adverse
> effects".
> 
> _what_ "adverse effects"??

Depends on how the specific filesystem handles a negative
nr_to_write, doesn't it? I can't speak for the exact effect on
anything other than XFS except to say that most ->write_page
implemetnations don't handle the wbc->nr_to_write < 0 specifically...

For XFS, it results in increased CPU usage because it triggers
page-at-a-time allocation (i.e no clustering), which increases
overhead in the elveator due to merging requirements of single page
bios and increased fragmentation due to small interleaved
allocations on concurrent writeback workloads. Effectively it causes
accelerated aging of XFS filesystems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
